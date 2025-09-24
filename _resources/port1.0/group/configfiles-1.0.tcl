# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*-
# vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# PortGroup: configfiles 1.0
# Purpose: Protect configuration files installed by a port using a material-difference check.
# Behavior:
#   - Treats matching files as "<dst>.sample" in destroot (so user edits aren't clobbered).
#   - On activate, copies sample to <dst> if missing; otherwise:
#       * Overwrites only if user's file is "empty" (comments/blank) OR material-equal to sample.
#       * Else preserves user file and writes "<dst>.mp-new".
#
# Maintainer-facing options:
#   configfiles.patterns            List of glob patterns (absolute or ${prefix}-relative).
#   configfiles.comment_regex       RE for comment line markers (default {#|;|//}).
#   configfiles.overwrite_if_empty  yes|no — allow overwrite when user file is only comments/blank.
#   configfiles.backup_format       strftime fmt appended to ".mp-bak-" for backups.
#   configfiles.write_new_suffix    Suffix for saving new defaults when preserving user file.
#   configfiles.normalize_whitespace yes|no — collapse internal whitespace when diffing.
#
# Example in a Portfile:
#   PortGroup configfiles 1.0
#   # defaults to etc/${name}/*.conf
#   # configfiles.patterns {etc/myd/*.conf etc/myd.d/*.rules}

PortGroup portgroup_hooks 1.0

namespace eval configfiles {
    variable entries {} ;# dict: dst -> sample
}

options configfiles.patterns \
        configfiles.comment_regex \
        configfiles.overwrite_if_empty \
        configfiles.backup_format \
        configfiles.write_new_suffix \
        configfiles.normalize_whitespace

# Default protects etc/${name}/*.conf (prefix-relative). Set to {} to disable.
default configfiles.patterns             "etc/\${name}/*.conf"
default configfiles.comment_regex        {#|;|//}
default configfiles.overwrite_if_empty   yes
default configfiles.backup_format        {.mp-bak-%Y%m%d%H%M%S}
default configfiles.write_new_suffix     {.mp-new}
default configfiles.normalize_whitespace yes

proc configfiles::abspath {path} {
    # Accept absolute or prefix-relative paths
    global prefix
    if {[string match "/*" $path]} {
        return $path
    }
    return [file normalize "${prefix}/$path"]
}

proc configfiles::materialize {path} {
    global configfiles.comment_regex configfiles.normalize_whitespace
    if {![file exists $path]} { return "" }
    set fh [open $path r]
    set out {}
    while {[gets $fh line] >= 0} {
        set t [string trim $line]
        if {$t eq ""} { continue }
        if {[regexp "^\s*(?:${configfiles.comment_regex})" $t]} { continue }
        if {${configfiles.normalize_whitespace}} {
            set t [regsub -all {\s+} $t { }]
        }
        lappend out $t
    }
    close $fh
    return [join $out "\n"]
}

# Expand patterns under a given root ("${destroot}" or ""), resolving ${name}, ${prefix}, etc.
proc configfiles::expand_patterns_into_entries {root} {
    global configfiles.patterns
    variable entries

    # Normalize to a list; important to *brace* the var name since it has a dot.
    set pats {}
    foreach p ${configfiles.patterns} {
        lappend pats $p
    }
    if {![llength $pats]} {
        return
    }

    foreach pat $pats {
        # Expand ${name} etc., but no command/backslash substitution
        set pat_expanded [subst -nocommands -nobackslashes $pat]
        set ap [configfiles::abspath $pat_expanded]
        set search "${root}${ap}"
        foreach match [glob -nocomplain -- $search] {
            if {$root ne "" && [string first $root $match] == 0} {
                set dst [string range $match [string length $root] end]
            } else {
                set dst $match
            }
            dict set entries $dst "${dst}.sample"
        }
    }
}

# --- post-destroot: move live files to .sample based on patterns ---
proc configfiles#do_post_destroot {} {
    global destroot

    # Expand patterns in the destroot tree
    configfiles::expand_patterns_into_entries ${destroot}
    if {![info exists ::configfiles::entries] || ![dict size $::configfiles::entries]} { return }

    foreach dst [dict keys $::configfiles::entries] {
        set sample [dict get $::configfiles::entries $dst]
        set dstd   "${destroot}${dst}"
        set sams   "${destroot}${sample}"
        if {[file exists $dstd]} {
            file mkdir [file dirname $sams]
            if {![file exists $sams]} {
                file rename -force $dstd $sams
                ui_msg "configfiles: moved ${dstd} -> ${sams}"
            } else {
                file delete -force $dstd
            }
        }
    }
}

# --- post-activate: install/merge with material-diff; expand patterns live ---
proc configfiles#do_post_activate {} {
    # Ensure entries include any live files that match patterns (e.g., upgrades)
    configfiles::expand_patterns_into_entries ""
    if {![info exists ::configfiles::entries] || ![dict size $::configfiles::entries]} { return }

    global configfiles.overwrite_if_empty configfiles.backup_format configfiles.write_new_suffix

    foreach dst [lsort -unique [dict keys $::configfiles::entries]] {
        set sample [dict get $::configfiles::entries $dst]

        if {![file exists $sample]} {
            if {[file exists $dst]} {
                ui_msg "configfiles: sample missing for ${dst}; skipping"
            }
            continue
        }

        if {![file exists $dst]} {
            file mkdir [file dirname $dst]
            file copy -force $sample $dst
            ui_msg "configfiles: installed default ${dst}"
            continue
        }
        set mat_user   [configfiles::materialize $dst]
        set mat_sample [configfiles::materialize $sample]

        set do_overwrite 0
        if {${configfiles.overwrite_if_empty} && $mat_user eq ""} {
            set do_overwrite 1
        } elseif {$mat_user eq $mat_sample} {
            set do_overwrite 1
        }

        if {$do_overwrite} {
            # Avoid backup if files are literally the same on disk
            set identical 0
            if {[file exists $dst]} {
                set fh1 [open $dst r];  fconfigure $fh1 -translation binary
                set fh2 [open $sample r]; fconfigure $fh2 -translation binary
                set data1 [read $fh1]
                set data2 [read $fh2]
                close $fh1; close $fh2
                if {$data1 eq $data2} { set identical 1 }
            }
            if {!$identical} {
                set backup "${dst}[clock format [clock seconds] -format ${configfiles.backup_format}]"
                file copy -force $dst $backup
                ui_msg "configfiles: backed up ${dst} to ${backup}"
            }
            file copy -force $sample $dst
            ui_msg "configfiles: replaced ${dst} with defaults"
        } else {
            set new "${dst}${configfiles.write_new_suffix}"
            file copy -force $sample $new
            ui_msg "configfiles: kept existing ${dst}; new defaults saved as ${new}"
        }
    }
}

portgroup_hooks#register post-destroot configfiles#do_post_destroot 0
portgroup_hooks#register post-activate configfiles#do_post_activate 0
