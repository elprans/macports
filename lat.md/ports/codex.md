# codex

The [Portfile](../../llm/codex/Portfile) packages Codex 0.162.1 with local macOS integration and nine patches beyond the default MacPorts recipe.

## Difference from MacPorts

The default tree is at 0.160.0. The overlay advances Codex to 0.162.1 and adds local signing, optional sccache, conservative build resource controls, eight feature patches, and a Windows compatibility patch.

It signs `codex` and `codex-code-mode-host` with a stable local identity, hardened runtime, and dylib-loading entitlements. A `libexec/codex` package holds both binaries and a manifest; symlinks expose the commands in `bin`. The ripgrep port supplies search externally.

The package layout identifies the shipped CLI without bundling ripgrep. The daemon runs that executable directly instead of copying it into managed releases; it replaces an older managed server when the PID record names a different executable path. Legacy managed installs keep their original selection behavior.

Automatic daemon updates are off by default. Packaged CLIs stop the updater even if settings explicitly enable it; upgrading the port, not the daemon's release directory, changes the running app server. A separate patch lets daemon package validation accept system ripgrep, which the runtime discovers through `PATH`.

The build uses Codex-published V8 pointer-compression and sandbox assets, optional sccache, a 25.6 GB per-job memory estimate, and no parallel build. Crate checksums live in a separate Tcl file to keep the Portfile maintainable.

The Windows compatibility patch follows the upstream network-policy helper rename so the source compiles; upstream now provides the ChatGPT crate's recursion limit.

## Local features

Eight local patches add keyring fallback, cost accounting, sandbox socket access, synchronous follow-ups, warning removal, system ripgrep, and shipped-binary daemon startup.

The catalog-advertised asynchronous question tool uses [[codex:codex-rs/core/src/tools/handlers/request_user_input_async.rs#RequestUserInputAsyncHandler|the blocking user-input path]]. The TUI shows a question prompt immediately, and the active turn waits for the answers as a tool result instead of retaining hidden queued follow-ups.

Successful local compaction still emits its compaction item and updates usage, but [[codex:codex-rs/core/src/compact.rs#run_compact_task_inner_impl|the compaction path]] no longer emits the generic long-thread warning.

With `allow_local_binding`, restricted macOS sessions can bind IP sockets and exchange loopback traffic, including through `sendfile`, without receiving blanket outbound Internet access.

Restricted sessions retain configured Unix-socket allowlists when the managed TCP proxy is disabled. Seatbelt merges, canonicalizes, and deduplicates all socket grants without starting a proxy or granting TCP/IP access; allow-all dominates.

Keyring fallback extends [[codex:codex-rs/model-provider-info/src/lib.rs#ModelProviderInfo#api_key]]. [[codex:codex-rs/cli/src/doctor.rs#provider_specific_auth_check|Doctor's provider auth check]] follows the same precedence: a nonempty environment key wins, then an opt-in OS keyring record under service `Codex Model Providers` and the provider's `env_key` account. It distinguishes missing records from keyring access failures without including secret values or backend error text in reports.

Cost tracking treats upstream `usage_metadata.amount` as authoritative. If Vercel AI Gateway omits it, Codex authenticates `GET /v1/generation?id=...` and retries after 5, 15, and 60 seconds for the settled `total_cost`.

Gateway WebSocket responses expose provider response IDs rather than their billing generation IDs, so this lookup cannot settle their costs. Leaving WebSockets disabled in the provider configuration uses the HTTP path for cost attribution.

Totals use fixed-point USD micros and persist total, post-fork incremental cost, and completeness with token-count rollout events. They flow through [[codex:codex-rs/app-server-protocol/src/protocol/v2/thread.rs#ThreadTokenUsage]] into the footer, title, status line, `/status`, and exit summary without requiring backend usage access.

The `/cost` command and status surfaces read project totals from one indexed SQLite aggregate and never scan rollout JSONL synchronously. If SQLite is unavailable, cost fails immediately instead of falling back to rollout parsing.

Upstream `daybreak_enabled` metadata is an optional per-thread Daybreak preference, not an access grant. It shares the metadata update path with local cost state; explicit Daybreak, project, and cost updates require SQLite so persisted state cannot silently diverge.

The cost schema is initialized outside SQLx history by [[codex:codex-rs/state/src/migrations.rs#ensure_local_thread_cost_schema]] after upstream migrations run. An immediate transaction makes its column check and idempotent index/table DDL safe across concurrent startups.

All numbered state migrations remain upstream-owned. Local cost-schema additions evolve through rerunnable startup DDL and never add or rewrite `_sqlx_migrations` rows.

A project is the normalized Git root, or normalized working directory outside Git, and includes persisted active and archived threads. Startup reconciles distinct stored working directories, and live metadata changes update project identity and cost rows immediately after durable token-count appends.

A cursor- and fingerprint-driven background backfill parses lightweight rollout envelopes under the rollout maintenance lock with bounded concurrency and batched SQLite writes. During backfill, `/cost` returns the indexed subtotal immediately and prefixes it with `~` if any matching thread is missing, stale, or incomplete.

Project aggregation counts each root thread's total and each fork's post-fork increment. It preserves ordinal, history-base, timestamp fallback, copied, referenced, reverted, and partial-history semantics; revert switches the selected rollout and cost row atomically, using an incomplete zero row if reconstruction fails.

Dollar displays round fixed-point micros to cents and use Codex's locale-aware integer grouping helper. The exit summary adds `Cost` after token usage, and a thread with no observed charge displays `$0.00` rather than `unavailable`.

## Version bumps

Following the overlay-wide [[ports#Patch maintenance|patch-maintenance rule]], every Codex version bump requires semantically rerolling its local patches against the new upstream revision in `~/dev/mirrors/codex`.

Review upstream changes before editing: remove behavior now supplied upstream, adapt local behavior to new native abstractions, and preserve the desired end state instead of replaying old hunks. Build in the mirror to reuse its Rust cache, then export the reviewed diff into the port.

Run the resulting Portfile through the exact [[ports#Agent maintenance commands|agent maintenance commands]] authorized for Codex; phase-specific commands isolate failures before the final source-only upgrade.
