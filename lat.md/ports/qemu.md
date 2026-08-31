# qemu

The [Portfile](../../emulators/qemu/Portfile) is a QEMU 11.1.0 patch carrier focused on Arm guests under Apple's Hypervisor.framework.

## Difference from MacPorts

The default tree is at 11.1.1, while this overlay remains at 11.1.0 revision 18. Most ordinary macOS portability patches come from MacPorts; eight additional patches correspond to commits after the 11.1.0 tag in the local QEMU checkout.

## Local HVF patch set

The patches tolerate redundant HVF unmaps in [[qemu:accel/hvf/hvf-all.c#hvf_set_phys_mem]], advertise GICv3 and nested EL2 during vCPU setup in [[qemu:target/arm/hvf/hvf.c#hvf_arch_init_vcpu]], and keep Apple's platform GIC from receiving invalid PPI or duplicate raw interrupt delivery through [[qemu:hw/intc/arm_gicv3_hvf.c#hvf_gicv3_set_irq]].

They also leave `MDCR_EL2` under HVF control, mask the native virtual timer before software-GIC delivery, and add rate-limited GIC/VTimer diagnostics. This behavior is coupled to the Arm firmware investigation support in [[edk2-uefi]].
