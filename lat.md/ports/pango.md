# pango

The [Portfile](../../x11/pango/Portfile) shadows MacPorts Pango to retain release 1.56.4 and its older-platform integration choices.

## Difference from MacPorts

The default tree is at 1.58.0, so this is now an older pin rather than a bump. It explicitly requires GLib's GObject GIR as a build input and carries broader Tiger and Leopard workarounds that the newer port has dropped.

The local port also keeps the older GNOME livecheck and Quartz gating. Its original overlay purpose was the GLib/GObject Introspection transition, but retirement now requires confirming that 1.58.0 works with the local [[glib2]] and [[gobject-introspection]] stack.
