# Port inventory

The overlay contains 25 ports. Thirteen shadow ports in the default MacPorts tree, while twelve add software that the default tree does not currently package.

## Patch maintenance

Every port that carries local patch files requires a matching local source checkout for patch updates, rebases, and version bumps.

Reroll patches from that checkout against the exact source revision packaged by the port, and validate the patched source tree before copying the refreshed patch files into the overlay. Do not maintain patches by editing the exported patch files in isolation.

Use the configured Lat external-source mirror when one exists. Patch-bearing ports may add further checkout-specific guidance, such as [[codex#Version bumps|Codex's Rust-cache workflow]].

## Agent maintenance commands

The trusted project layer authorizes only the commands below; a matching root-owned sudoers fragment enforces exact arguments for privileged MacPorts maintenance.

Codex loads `.codex/rules/macports-overlay.rules` for this root. `/private/etc/sudoers.d/macports-agent-maintenance` consolidates the exact privileged grants; always use `sudo -n` so agents fail instead of waiting for a password.

Codex maintenance uses these exact commands:

```sh
/opt/local/bin/port lint --nitpick codex
sudo -n /opt/local/bin/port -q checksum codex
sudo -n /opt/local/bin/port -N clean codex
sudo -n /opt/local/bin/port -N clean --all codex
sudo -n /opt/local/bin/port -N extract codex
sudo -n /opt/local/bin/port -N patch codex
sudo -n /opt/local/bin/port -N configure codex
sudo -n /opt/local/bin/port -N build codex
sudo -n /opt/local/bin/port -N test codex
sudo -n /opt/local/bin/port -N destroot codex
sudo -n /opt/local/bin/port -N -n -s upgrade --force codex
```

QEMU maintenance retains these exact commands:

```sh
sudo -n /opt/local/bin/port -N clean qemu
sudo -n /opt/local/bin/port -N clean --all qemu
sudo -n /opt/local/bin/port -N patch qemu
sudo -n /opt/local/bin/port -N -n -s upgrade --force qemu
```

EDK2 maintenance retains these exact commands:

```sh
sudo -n /opt/local/bin/port -N clean edk2-uefi
sudo -n /opt/local/bin/port -N clean --all edk2-uefi
sudo -n /opt/local/bin/port -N -n -s upgrade --force edk2-uefi
```

Do not append variants, options, extra ports, shell redirections, or compound commands. Add any new command explicitly to the rules, sudoers fragment, and this section before using it.

## Upstream shadows

These ports take precedence over an existing MacPorts port and must be reviewed against the default tree before their local copy is updated or removed.

- [[pango]] — Older Pango line with explicit GLib GIR and legacy-Darwin support
- [[libvirt]] — Newer libvirt plus protected configuration and launchd services
- [[qemu]] — QEMU patch carrier for Apple HVF and Arm interrupt behavior
- [[py-libvirt]] — Binding version kept in lockstep with local libvirt
- [[powershell]] — Official binary-archive installation instead of a source build
- [[gstreamer1-gst-plugins-base]] — Older GStreamer base with Cocoa GL header conflict handling
- [[py-virtualfish]] — Older project lineage and Python compatibility set
- [[gobject-introspection]] — Stale revision of the same 1.86.0 release
- [[freerdp]] — Straightforward newer FreeRDP release
- [[glib2]] — Older GLib point release lacking later MacPorts maintenance
- [[codex]] — Newer Codex with signing, V8 assets, and local feature patches
- [[opencode]] — Straightforward older OpenCode pin
- [[sccache]] — Newer sccache release with regenerated offline Cargo sources

## Overlay-only ports

These ports have no matching port in the default tree, so their pages describe both the packaged software and the local packaging policy.

- [[linearmouse]] — Installs the signed macOS application from its DMG
- [[termsvg]] — Builds the terminal recorder and SVG exporter from Go source
- [[browserpass]] — Native-messaging host for the browserpass extension
- [[virt-firmware]] — Python utilities for editing virtual firmware volumes
- [[edk2-uefi]] — Reproducible source builds of x86 and Arm QEMU firmware
- [[qemu-efi-aarch64-secboot]] — Repackages Debian AAVMF Secure Boot firmware
- [[swtpm]] — Software TPM emulator and launchd service
- [[notion-cli]] — Installs Notion's architecture-specific `ntn` binary
- [[ds4]] — Arm64 Metal inference engine for DeepSeek V4 Flash
- [[pinentry-touchid]] — Touch ID-aware GPG pinentry helper
- [[granted]] — Go-built cloud role and account launcher
- [[libtpms]] — TPM emulation library used by swtpm
