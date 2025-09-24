# portgroup_hooks-1.0.tcl
# Generic callback registry + runner for MacPorts phases (e.g. post-destroot, post-activate).

namespace eval portgroup_hooks {
    # callbacks(phase) -> list of {priority proc}
    variable callbacks
    # installed(phase) -> boolean (whether we installed the default phase body)
    variable installed
}

# Register a 0-arg callback proc for a phase. Higher priority runs earlier.
proc portgroup_hooks#register {phase procname {priority 0}} {
    portgroup_hooks#_install_default $phase
    lappend ::portgroup_hooks::callbacks($phase) [list $priority $procname]
}

# Run all callbacks for a phase. Any error aborts the phase immediately.
proc portgroup_hooks#run {phase} {
    set lst {}
    if {[info exists ::portgroup_hooks::callbacks($phase)]} {
        set lst $::portgroup_hooks::callbacks($phase)
    }
    if {[llength $lst] == 0} { return }

    set sorted [lsort -integer -decreasing -index 0 $lst]
    ui_debug "portgroup_hooks: running [llength $sorted] callbacks for phase '$phase'"

    foreach item $sorted {
        set cb [lindex $item 1]
        if {[catch { {*}$cb } err opts]} {
            ui_error "portgroup_hooks: callback '$cb' failed in phase '$phase': $err"
            # rethrow to abort the phase
            return -code error -errorinfo [dict get $opts -errorinfo] $err
        }
    }
}

# Convenience runners (optional, handy in Portfiles)
proc portgroup_hooks#run_post_destroot {}  { portgroup_hooks#run post-destroot }
proc portgroup_hooks#run_post_activate {}  { portgroup_hooks#run post-activate }

# --- internals ---------------------------------------------------------------

# Ensure a default phase body exists that calls our runner.
proc portgroup_hooks#_install_default {phase} {
    if {[info exists ::portgroup_hooks::installed($phase)] && $::portgroup_hooks::installed($phase)} {
        return
    }
    set ::portgroup_hooks::installed($phase) 1
    # Define the phase body to call the runner (e.g. "post-activate { portgroup_hooks#run post-activate }")
    $phase "portgroup_hooks#run $phase"
}

