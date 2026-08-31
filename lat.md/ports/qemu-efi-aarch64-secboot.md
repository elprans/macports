# qemu-efi-aarch64-secboot

The [Portfile](../../emulators/qemu-efi-aarch64-secboot/Portfile) repackages Debian sid's AAVMF firmware for AArch64 QEMU guests.

## Packaging

This port adapts Debian's prebuilt AArch64 firmware and discovery metadata to the MacPorts filesystem.

It is an overlay-only alternative to source-built [[edk2-uefi]]. It extracts Debian's architecture-independent package and installs the Secure Boot code image, empty and Microsoft-enrolled variable stores, and adjusted QEMU descriptors.

Variable stores are converted from raw images to qcow2 and descriptor formats and paths are rewritten for the MacPorts prefix. The port depends on QEMU only for `qemu-img`; it performs no firmware compilation and has livecheck disabled.
