# sccache

The [Portfile](../../devel/sccache/Portfile) advances the default MacPorts sccache recipe from 0.8.2 to 0.17.0.

## Difference from MacPorts

Only release metadata and the lockfile-derived Cargo crate inventory change. The upstream source build, default feature set, and single-binary install remain inherited from the default port.

The source now uses the tagged GitHub archive, and all registry crates are enumerated from the 0.17.0 `Cargo.lock` for the Cargo PortGroup's offline build.
