# libvirt

The [Portfile](../../sysutils/libvirt/Portfile) shadows MacPorts with libvirt 12.3.0 and local service integration for a usable QEMU management stack.

## Difference from MacPorts

The default tree is at 11.8.0 revision 1. Beyond the version bump, this port protects `libvirt/*.conf`, puts the MacPorts prefix on daemon startup paths so helpers such as [[swtpm]] are discoverable, and sets the runtime directory under the prefix.

It creates launchd items for `libvirtd`, `virtlogd`, and `virtlockd`. QEMU support remains an opt-in variant, and the port's three portability patches match the default tree: the birth-time fallback is anchored at [[libvirt:src/storage/storage_util.c#virStorageBackendUpdateVolTargetInfoFD]].

The corresponding Python binding is [[py-libvirt]] and should move in lockstep with this port.
