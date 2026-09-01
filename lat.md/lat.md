---
lat:
  external-sources:
    qemu:
      repo: https://github.com/qemu/qemu
      commit: 84f07211cc5b4fc6a371559bf8a5de4fb068e648
      strategy: fetch
    edk2:
      repo: https://github.com/tianocore/edk2
      commit: b7a715f7c03c45c6b4575bf88596bfd79658b8ce
      strategy: fetch
    libvirt:
      repo: https://gitlab.com/libvirt/libvirt
      commit: 82125398774535f2b172ed08981a28696ceda2ea
      strategy: fetch
    codex:
      repo: https://github.com/openai/codex
      commit: 758ef40f50c1a458425c7cfbf1eb12cbc07af0b0
      strategy: fetch
---
This graph describes why each port exists in the local overlay and how it differs from the default MacPorts tree.

- [[ports]] — Inventory and per-port design notes
- [[commits]] — Repository commit scope and message requirements
