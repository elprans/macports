# virt-firmware

The [Portfile](../../emulators/virt-firmware/Portfile) adds virt-firmware 26.2, a Python tool suite for inspecting and changing OVMF and ArmVirt firmware volumes.

## Packaging

The noarch Python 3.14 package comes from PyPI and depends on `cryptography` and `pefile`. Its principal role in this overlay is to provide `virt-fw-vars`, which enrolls Secure Boot keys and DBX updates into EDK2 variable stores.

Both [[edk2-uefi]] and firmware maintenance workflows rely on that capability. Livecheck is disabled, so updates are explicit rather than discovered automatically.
