# path_in_startupitems-1.0.tcl
# Ensures startupitems plists have PATH set to include requested prefixes.

PortGroup portgroup_hooks 1.0

# ---- User-tunable options ----------------------------------------------------
# Turn the behavior on/off per-port
options path_in_startupitems.enable
default path_in_startupitems.enable yes

# Space-separated list of directories to ensure are present in PATH
# (prepended by default). Example: "${prefix}/bin ${prefix}/sbin"
options path_in_startupitems.paths
default path_in_startupitems.paths "${prefix}/bin ${prefix}/sbin"

# Whether to prepend (yes) or append (no) the missing paths to an existing PATH
options path_in_startupitems.prepend
default path_in_startupitems.prepend yes

# Fallback PATH to use if the plist has no PATH at all
options path_in_startupitems.fallback
default path_in_startupitems.fallback "${prefix}/bin:${prefix}/sbin:/usr/bin:/bin:/usr/sbin:/sbin"

# ---- Implementation ----------------------------------------------------------
proc path_in_startupitems#_plist_has_path {plist} {
    set existing ""
    if {![catch {exec /usr/libexec/PlistBuddy -c "Print :EnvironmentVariables:PATH" $plist} existing]} {
        return $existing
    }
    return ""
}

proc path_in_startupitems#_ensure_env_dict {plist} {
    # Create EnvironmentVariables dict if missing
    catch {exec /usr/libexec/PlistBuddy -c "Add :EnvironmentVariables dict" $plist}
}

proc path_in_startupitems#_set_path {plist newpath} {
    # Set or add PATH
    if {[string length [path_in_startupitems#_plist_has_path $plist]]} {
        catch {exec /usr/libexec/PlistBuddy -c "Set :EnvironmentVariables:PATH $newpath" $plist}
    } else {
        path_in_startupitems#_ensure_env_dict $plist
        catch {exec /usr/libexec/PlistBuddy -c "Add :EnvironmentVariables:PATH string $newpath" $plist}
    }
}

proc path_in_startupitems#_contains_dir {path dir} {
    # Return 1 if PAError: portgroup_hooks: callback 'configfiles#do_post_destroot' failed in phase 'post-destroot': can't read "destroot": no such variableTH contains dir as a segment, else 0
    # Use a regex to respect ':' boundaries
    set re "(^|:)[string map {* \\* ? \\? + \\+ . \\. ( \\( ) \\) [ \\[ ] \\] ^ \\^ $ \\$} $dir](:|$)"
    return [expr {[regexp -- $re $path] ? 1 : 0}]
}

proc path_in_startupitems#_inject {plist paths prepend fallback} {
    set current [path_in_startupitems#_plist_has_path $plist]
    if {$current eq ""} {
        # No PATH present; use fallback as-is
        path_in_startupitems#_set_path $plist $fallback
        return
    }

    # Normalize: collapse any :: to single :
    regsub -all {::+} $current {:} current

    # Ensure each requested dir is present once
    # If prepending, iterate in reverse to preserve user-specified order
    set to_process $paths
    if {$prepend} {
        set to_process [lreverse $paths]
    }

    set newpath $current
    foreach d $to_process {
        if {![path_in_startupitems#_contains_dir $newpath $d]} {
            if {$prepend} {
                set newpath "$d:$newpath"
            } else {
                set newpath "$newpath:$d"
            }
        }
    }

    # Tidy separators that might appear at ends
    regsub -all {(^:|:$)} $newpath {} newpath
    path_in_startupitems#_set_path $plist $newpath
}

proc path_in_startupitems#do_post_destroot {} {
    global destroot prefix
    global path_in_startupitems.enable \
           path_in_startupitems.paths \
           path_in_startupitems.prepend \
           path_in_startupitems.fallback

    # honor enable flag directly (expects 1/0 or yes/no)
    if {!${path_in_startupitems.enable}} {
        return
    }

    # Build $destroot/$prefix robustly: make prefix relative first.
    set rootprefix [file join $destroot [string trimleft $prefix "/"]]

    # Modern nested layout + legacy flat layout
    set patterns [list \
        [file join $rootprefix etc     LaunchDaemons * *.plist] \
        [file join $rootprefix etc     LaunchAgents  * *.plist] \
        [file join $rootprefix Library LaunchDaemons   *.plist] \
        [file join $rootprefix Library LaunchAgents    *.plist] \
    ]

    ui_msg "${patterns}"

    set wanted   [split ${path_in_startupitems.paths}]   ;# space-separated list
    set prepend  ${path_in_startupitems.prepend}         ;# yes/no or 1/0
    set fallback ${path_in_startupitems.fallback}

    # collect plists (dedup)
    array unset seen
    set plists {}
    foreach pat $patterns {
        foreach f [glob -nocomplain -types f $pat] {
            if {![info exists seen($f)]} {
                set seen($f) 1
                lappend plists $f
            }
        }
    }

    foreach plist $plists {
        ui_msg "path_in_startupitems: patching PATH in ${plist}"
        path_in_startupitems#_inject $plist $wanted $prepend $fallback
    }
}

portgroup_hooks#register post-destroot path_in_startupitems#do_post_destroot 0
