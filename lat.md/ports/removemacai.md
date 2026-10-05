# removemacai

The [Portfile](../../sysutils/removemacai/Portfile) adds RemoveMacAI 0.2.4, a Swift CLI that disables Apple Intelligence and removes its downloaded models on Apple Silicon Macs running macOS 27.

## Packaging

The port builds the tagged GitHub source in release mode with Apple's Swift toolchain, without external package dependencies. It installs the executable, README, MIT license, and third-party notices.

The supported platform is arm64 on Darwin 26 or newer, following upstream's macOS 27 support policy. SwiftPM and compiler caches stay within the port work directory, and MacPorts headers are excluded from SDK imports. Livecheck follows GitHub releases.

## Operation

Installation only places files under the MacPorts prefix. Feature settings and model removal are applied when the user invokes the tool and approves its configuration profile in System Settings.

The tool uses Apple's asset service and a configuration profile rather than modifying protected system files. The installed notes recommend inspecting status or a dry run first and running `removemacai revert` before uninstalling to remove the profile and restore settings.

## Validation

The port's test phase runs upstream's built-in self-test, which validates feature selection, model-removal guards, inventory parsing, and generated configuration profiles without changing system settings or contacting the asset service.
