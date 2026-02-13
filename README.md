# memex

Lightweight persistent memory for AI coding sessions. Zero dependencies, just markdown files.

## The Problem

AI coding assistants (Claude Code, Cursor, Copilot) lose all context when the session resets. You have to re-explain what you were working on every time.

## The Solution

Two markdown files that persist your session state:

- **`memory/latest.md`** — What was done, what's next (overwritten each session)
- **`MEMORY.md ## NOW`** — 3-line status pointer (always loaded by Claude Code)

Total overhead: ~50 lines. No database. No dependencies. No runtime.

## Install

### As a Claude Code Plugin

```bash
# From marketplace (coming soon)
/plugin marketplace add asyrafhussin/memex
/plugin install memex

# Or test locally
claude --plugin-dir /path/to/memex
```

### Standalone (any project)

```bash
curl -fsSL https://raw.githubusercontent.com/asyrafhussin/memex/main/install.sh | bash
```

## Usage

### Automatic

The plugin auto-reads `memory/latest.md` at session start. When you push code, the memory-protocol skill reminds Claude to save state.

### Manual

```
/memex:save      Save current session state
/memex:status    Show what was done and what's next
```

## How It Works

```
Session 1: Work on features → /memex:save → pushes code + memory files
                                    ↓
                            memory/latest.md updated
                            MEMORY.md ## NOW updated
                                    ↓
Session 2: Starts → hook reads latest.md → Claude knows exactly where you left off
                                    ↓
                            "Last session you completed X. Next up is Y. Proceed?"
```

## File Structure

```
your-project/
  memory/
    latest.md          ← overwritten each session (what happened, what's next)
  MEMORY.md            ← project knowledge + ## NOW status (auto-loaded)
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

## Comparison

| | claude-mem | memex |
|---|---|---|
| Dependencies | SQLite, Bun, Chroma, Node, Python | **None** |
| Storage | Database (~/.claude-mem/) | Markdown files (in your repo) |
| Token cost | 500+ per session | ~50 lines |
| Install | Complex multi-step | One command |
| Git tracked | No | Yes (travels with repo) |
| Works with | Claude Code only | Any AI editor |
| Offline | Needs worker service | Always works |

## Configuration

No configuration needed. It just works.

If you want to customize the memory format, edit the templates in `templates/memory/`.

## License

MIT
