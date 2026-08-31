# linearmouse

The [Portfile](../../aqua/linearmouse/Portfile) adds LinearMouse 0.11.2, a native mouse and trackpad customization application absent from the default MacPorts tree.

## Packaging

The port downloads the upstream signed DMG for macOS 10.15 or newer, mounts it privately with `hdiutil`, copies `LinearMouse.app`, and detaches the image. There is no configure or build phase.

Only x86_64 and arm64 are supported. The installed artifact is the application bundle in the MacPorts applications directory; livecheck follows the project's Sparkle appcast rather than Git tags.
