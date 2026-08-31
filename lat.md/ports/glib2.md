# glib2

The [Portfile](../../devel/glib2/Portfile) retains GLib 2.88.0 as the base of the overlay's GNOME introspection stack.

## Difference from MacPorts

The default tree is at 2.88.3 revision 1. Its later recipe adds a direct D-Bus dependency, a PowerPC IPv6 traffic-class compatibility patch, and activation handling for files moved from older GObject Introspection packages.

The local copy has no overlay-only patch beyond its older snapshot. It should normally move or be retired with [[gobject-introspection]] and [[pango]] rather than remain independently pinned.
