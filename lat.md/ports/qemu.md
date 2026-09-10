# qemu

The [Portfile](../../emulators/qemu/Portfile) is a QEMU 11.1.1 patch carrier focused on Arm guests under Apple's Hypervisor.framework.

## Difference from MacPorts

The overlay matches the default tree at 11.1.1 revision 0, including its macOS compatibility patches, and adds eight local HVF patches maintained as commits on `macports/qemu-11.1.1` in the QEMU checkout.

## Local HVF patch set

The patches tolerate redundant HVF unmaps in [[qemu:accel/hvf/hvf-all.c#hvf_set_phys_mem]], advertise GICv3 and nested EL2 during vCPU setup in [[qemu:target/arm/hvf/hvf.c#hvf_arch_init_vcpu]], and keep Apple's platform GIC from receiving invalid PPI or duplicate raw interrupt delivery through [[qemu:hw/intc/arm_gicv3_hvf.c#hvf_gicv3_set_irq]].

The dirty-log callbacks use the same mapping predicate, leaving unaligned RAM devices such as TPM PPI under software dirty accounting instead of passing invalid ranges to Hypervisor.framework.

The remaining patches leave `MDCR_EL2` under HVF control and mask the native virtual timer before software-GIC delivery. This behavior is coupled to the Arm firmware investigation support in [[edk2-uefi]].
