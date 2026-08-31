# edk2-uefi

The [Portfile](../../emulators/edk2-uefi/Portfile) builds TianoCore EDK II firmware from source for x86_64 OVMF and AArch64 ArmVirtQemu guests.

## Reproducible source assembly

The port assembles checked source archives instead of using EDK2's Git submodules, making every input visible to MacPorts.

The default MacPorts tree has no equivalent port. Tagged EDK2 source and each normally-submoduled dependency are fetched independently, then linked into the expected paths. Builds use MacPorts LLVM 20, ACPICA, Python 3.14, and CLANGDWARF.

The default variants build both guest architectures. Each gets plain and Secure Boot firmware, UEFI Shell binaries, raw variable stores, qcow2 templates, and QEMU/libvirt firmware descriptors. [[virt-firmware]] enrolls Red Hat keys and Microsoft DBX data into the Secure Boot stores.

## Debugging behavior

The `+debug` variant additionally retains map and debug files and rewrites embedded symbol paths around [[edk2:ArmPkg/Library/DebugPeCoffExtraActionLib/DebugPeCoffExtraActionLib.c#PeCoffLoaderRelocateImageExtraAction]]. AArch64 debug images are installed but not advertised because they currently trigger an HVF data-abort assertion.

The second patch adds serial traces around GIC interrupt handling and ExitBootServices, including [[edk2:ArmPkg/Drivers/ArmGicDxe/GicV3/ArmGicV3Dxe.c#GicV3IrqInterruptHandler]]. It is diagnostic instrumentation paired with the local [[qemu]] HVF patch set.
