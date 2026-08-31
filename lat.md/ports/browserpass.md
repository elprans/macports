# browserpass

The [Portfile](../../www/browserpass/Portfile) adds browserpass-native 3.1.0, the native-messaging bridge between browser extensions and the `pass` password store.

## Packaging

The Go binary is installed in `libexec`, while browser manifests are rewritten to that prefixed location. Firefox registration is opt-in; without `+firefox`, the package installs the host and documentation but no system-wide Firefox manifest.

The local patch makes `/opt/local/bin/gpg2` the first GPG candidate, aligning process discovery with the runtime dependency on MacPorts `gnupg2`. Builds may fetch Go dependencies from the network and are intentionally non-parallel.
