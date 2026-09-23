# granted

The [Portfile](../../devel/granted/Portfile) adds Granted 0.39.0 for assuming cloud roles and opening multiple cloud accounts in isolated browser sessions.

## Packaging

The source and Go module come from fwdcloudsec. Builds require Go 1.25.7, inject MacPorts-specific version, configuration-directory, and builder metadata, suppress the build date, and rewrite helper lookup for the MacPorts prefix.

The package installs `granted`, an `assumego` symlink, and Bash and Fish `assume` helpers. Go dependencies may be downloaded during the non-parallel build.
