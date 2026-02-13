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

### As a Claude Code Plugin (Recommended)

**Step 1:** Add the marketplace

```
/plugin marketplace add AsyrafHussin/memex
```

**Step 2:** Install the plugin

```
/plugin install memex@memex
```

You can choose the scope during install:

| Scope | Flag | Use Case |
|-------|------|----------|
| User (default) | `--scope user` | All your projects |
| Project | `--scope project` | Shared with team via git |
| Local | `--scope local` | This project only, gitignored |

**Step 3:** Restart Claude Code. The plugin is now active.

### Standalone (Without Plugin System)

If you prefer not to use the plugin system, run this in your project root:

```bash
curl -fsSL https://raw.githubusercontent.com/AsyrafHussin/memex/main/install.sh | bash
```

This creates `memory/latest.md` and adds a `## NOW` section to your `MEMORY.md`.

## Usage

### Automatic (Plugin Mode)

When installed as a plugin:

1. **Session start** — The hook automatically reads `memory/latest.md` and shows you what was last done and what's next
2. **Before pushing** — The `memory-protocol` skill reminds Claude to save session state

### Commands

```
/memex:save      Save current session state to memory
/memex:status    Show what was done and what's next
```

### Standalone Mode

Without the plugin, just tell Claude:

> "Read memory/latest.md and continue where we left off"

And before ending a session:

> "Save session state to memory/latest.md and update MEMORY.md ## NOW"

## How It Works

```
Session 1: Work on features -> /memex:save -> commit + push
                                    |
                            memory/latest.md updated
                            MEMORY.md ## NOW updated
                                    |
Session 2: Starts -> hook reads latest.md -> Claude knows where you left off
                                    |
                            "Last session you completed X. Next up is Y."
```

## File Structure

```
your-project/
  memory/
    latest.md          <- overwritten each session (what happened, what's next)
  MEMORY.md            <- project knowledge + ## NOW status (auto-loaded)
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

## Update

### Update the Plugin

To get the latest version:

```
/plugin marketplace update memex
/plugin update memex@memex
```

Or use the interactive UI:

1. Run `/plugin`
2. Go to **Marketplaces** tab
3. Click **Update** on the memex marketplace

### Uninstall

```
/plugin uninstall memex@memex
/plugin marketplace remove memex
```

## Comparison

| | claude-mem | memex |
|---|---|---|
| Dependencies | SQLite, Bun, Chroma, Node, Python | **None** |
| Storage | Database (~/.claude-mem/) | Markdown files (in your repo) |
| Token cost | 500+ per session | ~50 lines |
| Install | Complex multi-step | One command |
| Git tracked | No | **Yes** (travels with repo) |
| Offline | Needs worker service | **Always works** |

## Plugin Components

| Component | Path | Purpose |
|-----------|------|---------|
| Manifest | `.claude-plugin/plugin.json` | Plugin metadata |
| Hook | `hooks/hooks.json` | Auto-reads memory on session start |
| Command | `commands/save.md` | `/memex:save` — save session state |
| Command | `commands/status.md` | `/memex:status` — show current state |
| Skill | `skills/memory-protocol/SKILL.md` | Auto-save before push |
| Templates | `templates/memory/` | Default file templates |

## Configuration

No configuration needed. It just works.

If you want to customize the memory format, edit the templates in `templates/memory/`.

## License

MIT
