# gobject-introspection

The [Portfile](../../gnome/gobject-introspection/Portfile) shadows the same 1.86.0 release as MacPorts but remains at revision 0.

## Difference from MacPorts

The default tree has revision 1, an additional scanner dumper patch, bootstrap conflict cleanup, and corrected bootstrap destroot environment. The overlay otherwise carries the established prefix, Python, rpath, and library-search patches.

This copy was introduced with the local GLib 2.88 transition, but it now represents an older packaging revision rather than unique behavior. It should be evaluated together with [[glib2]].
