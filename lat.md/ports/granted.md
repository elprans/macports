# granted

The [Portfile](../../devel/granted/Portfile) adds Granted 0.36.3 for assuming cloud roles and opening multiple cloud accounts in isolated browser sessions.

## Packaging

The Go build injects MacPorts-specific version, configuration directory, and builder metadata while suppressing the build date for reproducibility. A source rewrite changes helper lookup from `/usr/local/bin` to the MacPorts prefix.

The package installs `granted`, an `assumego` symlink, and Bash and Fish `assume` helpers. Go dependencies may be downloaded during the non-parallel build.
