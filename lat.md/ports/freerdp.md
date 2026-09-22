# FreeRDP

The [Portfile](../../net/FreeRDP/Portfile) packages FreeRDP 3.31.1 revision 1 with local SDL3 display-geometry fixes beyond the default MacPorts recipe.

## Difference from MacPorts

The overlay advances the default 3.17.2 revision 1 recipe to 3.31.1 revision 1 and adds an SDL3 display-geometry patch. Dependencies, the build-type patch, macOS client policy, codec variants, and SDL selection otherwise remain inherited.

## SDL3 display geometry

The local patch makes monitor discovery side-effect free and corrects work-area and percentage sizing across high-DPI displays.

Upstream creates a visible borderless window per display and switches it to fullscreen to obtain high-DPI geometry. The [local patch](../../net/FreeRDP/files/patch-client-SDL3-fix-display-geometry-queries.diff) instead derives physical dimensions and desktop scale directly from SDL display data, avoiding macOS Space animations and focus loss.

For windowed work-area and `/size:<percent>` requests, the patch installs the selected display in `MonitorDefArray`, checks geometry-query failures, and converts SDL usable bounds from screen coordinates to physical pixels before sizing. This avoids display ID 0 and the stale 1024x768 fallback.

## Patch maintenance

Maintain the SDL3 display-geometry patch from the [FreeRDP repository](https://github.com/FreeRDP/FreeRDP) checkout at `~/dev/mirrors/FreeRDP` on branch `elprans/patches`, following the overlay-wide [[ports#Patch maintenance|patch-maintenance rule]].

The pinned external source identifies the exact patch commit. Its parent and the packaged `3.31.1` tag have identical touched SDL3 sources, so the exported commit applies directly to this release.
