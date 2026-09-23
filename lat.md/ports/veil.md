# veil

The [Portfile](../../devel/veil/Portfile) adds Veil 0.0.7, Vercel's CLI for transforming and rendering deployment configuration through TypeScript hooks.

## Packaging

Veil builds from its tagged Go source with Go 1.26.1 or newer and embeds the release tag in the executable. The package installs the `veil` CLI and its README, specification, and command documentation.

Dependencies may be downloaded during the module-mode build. The test phase runs every Go test in the tagged root module, matching upstream CI.

Upstream publishes neither a license file nor repository license metadata, so the port declares no license rather than inferring one.
