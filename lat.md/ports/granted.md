# granted

The [Portfile](../../devel/granted/Portfile) adds Granted 0.39.0 for assuming cloud roles and opening multiple cloud accounts in isolated browser sessions.

## Packaging

The source and Go module come from fwdcloudsec. Builds require Go 1.25.7, inject MacPorts-specific version, configuration-directory, and builder metadata, suppress the build date, and rewrite helper lookup for the MacPorts prefix.

The package installs `granted`, an `assumego` symlink, and Bash and Fish `assume` helpers. Go dependencies may be downloaded during the non-parallel build.

## Firefox launch patch

On macOS, Firefox app bundles launch through LaunchServices so a running browser keeps its selected profile; non-app Firefox installations continue to execute directly.

Maintain the [patch](../../devel/granted/files/patch-firefox-launchservices.diff) from commit `62835f8e0024d29ce1256ec0b7ad4774294ffcea` on the `fixes` branch in `~/dev/mirrors/granted`, following [[ports#Patch maintenance]]. Its parent and v0.39.0 have identical touched sources.
