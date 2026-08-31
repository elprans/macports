# codex

The [Portfile](../../llm/codex/Portfile) packages Codex 0.149.0 with local macOS integration and two feature patches beyond the default MacPorts recipe.

## Difference from MacPorts

The default tree is at 0.146.0. The overlay adds local signing, a companion binary, specialized V8 inputs, and feature patches.

It signs `codex` and `codex-code-mode-host` with a stable local identity, hardened runtime, and dylib-loading entitlements, and installs both companion binaries together.

The build uses Codex-published V8 pointer-compression and sandbox assets, optional sccache, a 25.6 GB per-job memory estimate, and no parallel build. Crate checksums live in a separate Tcl file to keep the Portfile maintainable.

## Local features

One patch lets custom provider `env_key` authentication fall back to the OS keyring when enabled, extending [[codex:codex-rs/model-provider-info/src/lib.rs#ModelProviderInfo#api_key]]. The other estimates and reports Vercel AI Gateway generation and thread cost through the existing [[codex:codex-rs/app-server-protocol/src/protocol/v2/thread.rs#ThreadTokenUsage]] contract.

## Version bumps

Following the overlay-wide [[ports#Patch maintenance|patch-maintenance rule]], every Codex version bump requires rebasing its local patches against the new upstream revision in `~/dev/mirrors/codex`.

Perform the rebase and validation directly in that mirror checkout so repeated Cargo builds reuse its Rust build cache. Once the patches apply and build cleanly, export the refreshed patch files back into the port before updating its release metadata and checksums.
