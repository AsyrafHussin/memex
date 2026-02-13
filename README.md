# memex

Lightweight persistent memory plugin for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Zero dependencies, just markdown files.

## The Problem

Claude Code loses all context when the session resets or hits the context limit. You have to re-explain what you were working on every time.

## The Solution

Two markdown files that persist your session state:

- **`memory/latest.md`** — What was done, what's next (overwritten each session)
- **`MEMORY.md ## NOW`** — 3-line status pointer (always loaded by Claude Code)

Total overhead: ~50 lines. No database. No dependencies. No runtime.

## Install

```
/plugin marketplace add AsyrafHussin/memex
/plugin install memex@memex
```

Restart Claude Code. The plugin auto-creates a `memory/` folder in your project on first save.

## How It Works — Fully Automatic

Once installed, memex runs automatically with **no manual steps required**:

| When | What Happens |
|------|-------------|
| Session starts | Reads `memory/latest.md` and restores context |
| Before `git commit` | Reminds Claude to update memory before committing |
| Before `git push` | Reminds Claude to ensure memory was committed |
| Before `/clear` or auto-compact | Saves memory before context is wiped |
| Session ends (Ctrl+C) | Extracts basic summary from transcript as fallback |

### Commands

You can also save manually at any time:

```
/memex:save      Save current session state to memory
/memex:status    Show what was done and what's next
```

## What Gets Saved

```markdown
## Session 2026-02-13

### Completed
- Added project description, location, date fields (823741f)
- Added edit progress update feature

### Next
- KB permissions (per-user access restrictions)

### Decisions
- Used single pivot table with role column instead of 2 separate tables

### Gotchas
- Migration ordering: FK tables must be created before referencing tables
```

## File Structure

```
your-project/
  memory/
    latest.md          <- overwritten each session (what happened, what's next)
```

## Update

```
/plugin marketplace update memex
/plugin update memex@memex
```

### Uninstall

```
/plugin uninstall memex@memex
/plugin marketplace remove memex
```

## Hooks

| Hook | Trigger |
|------|---------|
| `SessionStart` | New session, resume, `/clear`, or auto-compact — loads previous memory |
| `PreToolUse` (Bash) | Detects `git push` — reminds to save first |
| `PreCompact` | Before `/clear` or auto-compaction — urgent save |
| `SessionEnd` | Session exit — fallback transcript extraction |

## License

MIT
