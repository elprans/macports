# swtpm

The [Portfile](../../security/swtpm/Portfile) adds swtpm 0.10.1, a socket-based TPM 1.2/2.0 emulator backed by [[libtpms]].

## Packaging

The autotools build disables Linux CUSE and tests, defaults to OpenSSL 3, and optionally enables GnuTLS as a second backend. Explicit include, library, and pkg-config paths ensure MacPorts cryptography wins over system libraries.

The port creates persistent runtime and state directories and provides a disabled-by-default launchd item. Loading it starts a TPM 2.0 service with separate control and server sockets under `${prefix}/var/run/swtpm` and state under `${prefix}/var/lib/swtpm`.
