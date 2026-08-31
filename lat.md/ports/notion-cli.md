# notion-cli

The [Portfile](../../devel/notion-cli/Portfile) adds Notion CLI 0.14.1 and its `ntn` command for API, authentication, and Notion Workers workflows.

## Packaging

The port selects an upstream x86_64 or AArch64 macOS archive and installs the prebuilt executable plus license and README. It supports macOS 10.15 or newer, has no build dependencies, and does not offer a universal variant.

Livecheck reads the project's `latest.txt`, keeping release discovery independent of archive naming.
