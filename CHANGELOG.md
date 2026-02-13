# Changelog

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
