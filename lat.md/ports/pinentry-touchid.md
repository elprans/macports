# pinentry-touchid

The [Portfile](../../security/pinentry-touchid/Portfile) adds pinentry-touchid 0.0.3, a macOS GPG pinentry helper that authorizes cached credentials with Touch ID.

## Packaging

The Go source build installs one binary and its documentation. Runtime dependencies retain `pinentry-mac` as the conventional fallback and require MacPorts GnuPG.

Go modules may be fetched during the serialized build, so the port is not fully offline-reproducible. No source patches or architecture restrictions are declared.
