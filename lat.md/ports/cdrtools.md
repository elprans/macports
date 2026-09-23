# cdrtools

The [Portfile](../../sysutils/cdrtools/Portfile) shadows MacPorts' cdrtools 3.02-2024-03-21 recipe with a Darwin 27 shell workaround.

## Difference from MacPorts

The local recipe is otherwise identical to the default tree and only changes shell invocation on Darwin 27 and later.

Build and destroot set `MAKE_SHELL_FLAG=-c` because smake's default `/bin/sh -ce` is killed while expanding long archive recipes. The override lets archive and manpage generation complete while smake still checks each recipe's status.
