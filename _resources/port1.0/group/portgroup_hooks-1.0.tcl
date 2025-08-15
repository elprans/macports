# portgroup_hooks-1.0.tcl
# Lightweight callback registry + runner for MacPorts phases.

namespace eval portgroup_hooks {
    variable post_destroot {}
    variable installed_default_post_destroot 0
}

# Register a callback proc to be run for a phase.
# Supported phases in this snippet: post-destroot
# 'priority' is an integer; higher runs first. Default 0.
proc portgroup_hooks#register {phase procname {priority 0}} {
    switch -- $phase {
        post-destroot {
            lappend ::portgroup_hooks::post_destroot [list $priority $procname]
        }
        default {
            error "portgroup_hooks: unsupported phase '$phase'"
        }
    }
}

# Internal: return sorted list of callback procs by priority (desc)
proc portgroup_hooks#_sorted {lst} {
    set sorted [lsort -integer -decreasing -index 0 $lst]
    set out {}
    foreach item $sorted { lappend out [lindex $item 1] }
    return $out
}

# Run all registered post-destroot callbacks (safe to call multiple times)
proc portgroup_hooks#run_post_destroot {} {
    set cbs [portgroup_hooks#_sorted $::portgroup_hooks::post_destroot]
    if {[llength $cbs] == 0} {
        return
    }
    ui_debug "portgroup_hooks: running [llength $cbs] post-destroot callbacks"
    foreach cb $cbs {
        if {[catch { {*}$cb } err]} {
            ui_warn "portgroup_hooks: callback '$cb' failed: $err"
        }
    }
}

# Install a default post-destroot that calls the runner
if {!$::portgroup_hooks::installed_default_post_destroot} {
    set ::portgroup_hooks::installed_default_post_destroot 1
    post-destroot {
        portgroup_hooks#run_post_destroot
    }
}

