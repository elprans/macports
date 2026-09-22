# Port inventory

The overlay contains 23 ports. Eleven shadow ports in the default MacPorts tree, while twelve add software that the default tree does not currently package.

## Patch maintenance

Every port that carries local patch files requires a matching local source checkout for patch updates, rebases, and version bumps.

Reroll patches from that checkout against the exact source revision packaged by the port, and validate the patched source tree before copying the refreshed patch files into the overlay. Do not maintain patches by editing the exported patch files in isolation.

Use the configured Lat external-source mirror when one exists. Patch-bearing ports may add further checkout-specific guidance, such as [[codex#Version bumps|Codex's Rust-cache workflow]].

## Agent maintenance commands

The trusted project layer authorizes one uniform operation set for an exact port allowlist; a matching root-owned sudoers fragment enforces complete privileged argument strings.

Codex loads `.codex/rules/macports-overlay.rules` for this root. `/private/etc/sudoers.d/macports-agent-maintenance` consolidates the exact NOPASSWD grants; use plain `sudo` so preauthorized commands run without agent confirmation.

The admitted ports are `codex`, `qemu`, `edk2-uefi`, and `FreeRDP`. Replace `<port>` below with exactly one admitted name; every admitted port has the same operations.

This list is exhaustive, not illustrative. Agents must use only these exact command forms and must not attempt or request approval for alternatives such as `port install`; the forced source-only upgrade is the sole authorized rebuild or reinstall path.

Forced upgrade cannot perform a first installation. If an admitted port is absent, agents must stop after validation and report that initial installation requires a separately authorized command.

```sh
/opt/local/bin/port lint --nitpick <port>
sudo /opt/local/bin/port -q checksum <port>
sudo /opt/local/bin/port -N clean <port>
sudo /opt/local/bin/port -N clean --all <port>
sudo /opt/local/bin/port -N extract <port>
sudo /opt/local/bin/port -N patch <port>
sudo /opt/local/bin/port -N configure <port>
sudo /opt/local/bin/port -N build <port>
sudo /opt/local/bin/port -N test <port>
sudo /opt/local/bin/port -N destroot <port>
sudo /opt/local/bin/port -N -n -s upgrade --force <port>
```

The sudoers fragment uses an anchored POSIX regular expression over the complete argument string. Do not add `sudo -n`, variants, options, extra ports, shell redirections, or compound commands; add operations or admitted names to the project rule, sudoers regex, and this section together before using them.

## Upstream shadows

These ports take precedence over an existing MacPorts port and must be reviewed against the default tree before their local copy is updated or removed.

- [[libvirt]] — Newer libvirt plus protected configuration and launchd services
- [[qemu]] — QEMU patch carrier for Apple HVF and Arm interrupt behavior
- [[py-libvirt]] — Binding version kept in lockstep with local libvirt
- [[gstreamer1-gst-plugins-base]] — Older GStreamer base with Cocoa GL header conflict handling
- [[py-virtualfish]] — Older project lineage and Python compatibility set
- [[gobject-introspection]] — Stale revision of the same 1.86.0 release
- [[freerdp]] — Newer FreeRDP with local SDL3 display-geometry fixes
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
