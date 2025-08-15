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
default path_in_startupitems.paths "${prefix}/bin"

# Whether to prepend (yes) or append (no) the missing paths to an existing PATH
options path_in_startupitems.prepend
default path_in_startupitems.prepend yes

# Fallback PATH to use if the plist has no PATH at all
options path_in_startupitems.fallback
default path_in_startupitems.fallback "${prefix}/bin:/usr/bin:/bin:/usr/sbin:/sbin"

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
    # Return 1 if PATH contains dir as a segment, else 0
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
    ui_msg "!!!AAA"
    if {![tbool ${path_in_startupitems.enable}]} {
        return
    }

    # Where startupitems put their plists inside destroot
    set plist_dirs [list \
        "${destroot}${prefix}/Library/LaunchDaemons" \
        "${destroot}${prefix}/Library/LaunchAgents" \
    ]

    # Collect requested paths into a Tcl list (split on whitespace)
    set wanted_paths [split ${path_in_startupitems.paths}]
    set do_prepend   [tbool ${path_in_startupitems.prepend}]
    set fallback     ${path_in_startupitems.fallback}

    foreach dir $plist_dirs {
        foreach plist [glob -nocomplain -types f "${dir}/*.plist"] {
            ui_msg "patching ${plist}"
            path_in_startupitems#_inject $plist $wanted_paths $do_prepend $fallback
        }
    }
}

portgroup_hooks#register post-destroot path_in_startupitems#do_post_destroot 0
