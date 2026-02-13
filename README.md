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

This creates `memory/latest.md` and adds a `## NOW` section to your `CLAUDE.md`.

## How It Works — Fully Automatic

Once installed, memex runs automatically with **no manual steps required**:

| When | What Happens |
|------|-------------|
| Session starts | Reads `memory/latest.md` and restores context |
| Context reaches 70% | Warns Claude to save memory soon |
| Context reaches 85% | Urgent warning — Claude saves immediately |
| Before `git push` | Intercepts and reminds Claude to save first |
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
  MEMORY.md            <- project knowledge + ## NOW status (auto-loaded)
```

## Update

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

## Plugin Components

| Component | Path | Purpose |
|-----------|------|---------|
| Manifest | `plugin/.claude-plugin/plugin.json` | Plugin metadata |
| Hooks | `plugin/hooks/hooks.json` | 6 lifecycle hooks (see below) |
| Command | `plugin/commands/save.md` | `/memex:save` — save session state |
| Command | `plugin/commands/status.md` | `/memex:status` — show current state |
| Skill | `plugin/skills/memory-protocol/SKILL.md` | Auto-save before push |
| Scripts | `plugin/scripts/` | Hook scripts |

### Hooks

| Hook | Script | Trigger |
|------|--------|---------|
| `SessionStart` | `load-memory.sh` | New session or resume — loads previous memory |
| `PreToolUse` (Bash) | `check-push.sh` | Detects `git push` — reminds to save first |
| `PostToolUse` | `check-context.sh` | Every tool use — warns at 70% and 85% context |
| `PreCompact` | `pre-compact.sh` | Before `/clear` or auto-compaction — urgent save |
| `SessionEnd` | `session-end.sh` | Session exit — fallback transcript extraction |

## Configuration

No configuration needed. It just works.

If you want to customize the memory format, edit the templates in `plugin/templates/memory/`.

## License

MIT
