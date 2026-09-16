# codex

The [Portfile](../../llm/codex/Portfile) packages Codex 0.153.4 with local macOS integration and five feature patches beyond the default MacPorts recipe.

## Difference from MacPorts

The default tree is at 0.152.1. The overlay advances Codex to 0.153.4 and adds local signing, optional sccache, conservative build resource controls, and five feature patches.

It signs `codex` and `codex-code-mode-host` with a stable local identity, hardened runtime, and dylib-loading entitlements, and installs both companion binaries together.

The build uses Codex-published V8 pointer-compression and sandbox assets, optional sccache, a 25.6 GB per-job memory estimate, and no parallel build. Crate checksums live in a separate Tcl file to keep the Portfile maintainable.

## Local features

Five local patches add opt-in keyring fallback, complete provider-cost accounting, per-connection system DNS refresh, proxy-independent Unix-socket access, and complete loopback traffic in restricted macOS sandboxes.

With `allow_local_binding`, restricted macOS sessions can bind IP sockets and exchange loopback traffic, including through `sendfile`, without receiving blanket outbound Internet access.

Restricted sessions retain configured Unix-socket allowlists when the managed TCP proxy is disabled. Seatbelt merges, canonicalizes, and deduplicates all socket grants without starting a proxy or granting TCP/IP access; allow-all dominates.

Sandbox TCP connections resolve direct targets and upstream proxy hostnames through the operating system for every connection, so persistent Codex processes follow network DNS changes. Address-family filtering preserves OS order, and resolved private addresses remain subject to final target policy.

Keyring fallback extends [[codex:codex-rs/model-provider-info/src/lib.rs#ModelProviderInfo#api_key]]. Cost tracking treats upstream `usage_metadata.amount` as authoritative. If Vercel AI Gateway omits it, Codex authenticates `GET /v1/generation?id=...` and retries after 5, 15, and 60 seconds for the settled `total_cost`.

Totals use fixed-point USD micros and persist total, post-fork incremental cost, and completeness with token-count rollout events. They flow through [[codex:codex-rs/app-server-protocol/src/protocol/v2/thread.rs#ThreadTokenUsage]] into the footer, title, status line, `/status`, and exit summary without requiring backend usage access.

The `/cost` command and status surfaces read project totals from one indexed SQLite aggregate and never scan rollout JSONL synchronously. If SQLite is unavailable, cost fails immediately instead of falling back to rollout parsing.

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
