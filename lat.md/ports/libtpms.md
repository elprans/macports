# libtpms

The [Portfile](../../security/libtpms/Portfile) adds libtpms 0.10.1, the TPM 1.2 and TPM 2.0 emulation library consumed by [[swtpm]].

## Packaging

The port bootstraps the upstream autotools build with `autogen.sh`, enables both TPM generations, and defaults to MacPorts OpenSSL 3. Explicit pkg-config configuration keeps dependency discovery inside the prefix.

The upstream test suite is enabled with `make check`. NSS/freebl support is intentionally omitted because packaging that backend on macOS is substantially more involved and only benefits TPM 1.2.
