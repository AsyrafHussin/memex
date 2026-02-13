# Changelog

## [0.2.3] - 2026-02-14

### Fixed
- SessionStart hook now fires after `/clear` and auto-compaction (added "clear" and "compact" matchers)
- Fixed stdin consumption bug — `debug-stdin.sh` was chained with `&&` and consumed all stdin, starving `check-push.sh` and `pre-compact.sh`
- Removed dead `PostToolUse` hook (`context_window` data not available in hook stdin)
- `pre-compact.sh` now drains stdin properly to prevent pipe issues

### Changed
- Debug logging is now inline in each script, controlled by `MEMEX_DEBUG` env var
- Removed `debug-stdin.sh` from hook chains

## [0.2.2] - 2026-02-14

### Added
- Auto-create `memory/` folder and default `latest.md` on first session start

## [0.2.1] - 2026-02-13

### Changed
- Simplified install script — just creates `memory/latest.md`, no scope options
- Simplified README — cleaner install instructions, removed unnecessary sections

## [0.2.0] - 2026-02-13

### Added
- `PostToolUse` hook — warns at 70% and 85% context usage
- `PreCompact` hook — saves memory before `/clear` or auto-compaction
- `SessionEnd` hook — fallback transcript extraction when session ends
- `PreToolUse` hook — detects `git push` and reminds to save first

### Changed
- Restructured plugin into `plugin/` subdirectory for valid marketplace schema
- Hook output now uses JSON `additionalContext` for reliable context injection
- `SessionStart` hook only fires on `startup` and `resume` (not `clear`/`compact`)

## [0.1.0] - 2026-02-13

### Added
- Initial release
- `SessionStart` hook — loads `memory/latest.md` on session start
- `/memex:save` command — save session state manually
- `/memex:status` command — show current memory state
- `memory-protocol` skill — auto-invoked before push
- Standalone install script (`install.sh`)
- Plugin marketplace support
