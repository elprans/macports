# powershell

The [Portfile](../../shells/powershell/Portfile) installs PowerShell 7.5.2 from Microsoft's official architecture-specific macOS binary archive.

## Difference from MacPorts

The default port is newer at 7.6.5 and builds from source with the .NET SDK. This overlay instead skips configure and build, copies the complete arm64 or x64 runtime under `libexec/powershell/7.5.2`, and exposes `pwsh` through a prefix symlink.

The binary packaging is faster and avoids a large build toolchain, but it is less integrated with MacPorts compiler and dependency policy. The local release is now stale, so retaining the port depends on whether the prebuilt-install model is still desired.
