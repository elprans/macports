# gstreamer1-gst-plugins-base

The [Portfile](../../gnome/gstreamer1-gst-plugins-base/Portfile) retains GStreamer base plugins 1.24.9 revision 1 to control GL headers and display backends on macOS.

## Difference from MacPorts

The default tree is at 1.28.6, while this older fork controls X11, Cocoa, introspection, and installed GL headers explicitly.

The local port defaults to X11, enables introspection directly, and has a Cocoa fallback when X11 is disabled. In Cocoa mode it depends on a GL-header provider but deletes duplicate GL/KHR headers after installation to avoid conflicts.

This is a behavioral fork on an older release, not a simple version pin. Upstream MacPorts now models X11 and Quartz as conflicting variants, so retirement requires checking downstream header consumers and the original Cocoa compilation conflict.
