# ds4

The [Portfile](../../llm/ds4/Portfile) adds DwarfStar, a small native inference stack optimized for DeepSeek V4 Flash on Apple Silicon.

## Packaging

The port is pinned to commit `cafc134f` and uses a date-like version because no release is selected. It targets arm64 on macOS 13 or newer and builds without host-specific native CPU flags for package portability.

Five tools are installed: the core CLI, coding agent, benchmark, evaluator, and HTTP server. The implementation uses its Metal backend and ships model documentation, but not model weights. Livecheck is disabled because the package tracks a commit rather than releases.
