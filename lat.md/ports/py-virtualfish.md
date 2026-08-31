# py-virtualfish

The [Portfile](../../python/py-virtualfish/Portfile) retains virtualfish 2.5.4 from the original `adambrenecki` repository lineage.

## Difference from MacPorts

The default tree follows `justinmayer` at 2.5.9 and supports Python 3.10 through 3.14. This overlay instead offers Python 3.8 through 3.12, carries revision 1, and loads the select PortGroup without defining a select group.

No local behavioral patch is present. The port is best understood as a stale compatibility pin for older Python subports and project ancestry.
