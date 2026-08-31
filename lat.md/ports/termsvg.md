# termsvg

The [Portfile](../../sysutils/termsvg/Portfile) adds termsvg 0.10.0, a CLI for recording, replaying, and exporting terminal sessions as animated SVG.

## Packaging

The port builds `./cmd/termsvg` from Go source, injects the release version, strips symbols, and installs one binary plus the license and README. Upstream is fetched from a tagged GitHub archive.

The build is deliberately online because `go.offline_build` is disabled, and it is serialized with `use_parallel_build no`. This makes the port simple but less self-contained than a MacPorts Go port with all module distfiles enumerated.
