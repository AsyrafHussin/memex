---
description: Save current session state to memory before pushing
---

# Save Session Memory

You MUST update the following files NOW:

## 1. Overwrite `memory/latest.md`

Create/overwrite with this exact structure:

```
## Session {YYYY-MM-DD}

### Completed
- {What was done this session, with commit hashes if available}

### Next
- {What should be done next, be specific}

### Decisions
- {Any architectural or design choices made}

### Gotchas
- {Things that caused issues or would trip you up next time}
```

## 2. Update `MEMORY.md` ## NOW section

Update ONLY the `## NOW` section at the top of MEMORY.md (keep everything else):

```
## NOW
- Done: {last completed task} ({commit hash})
- Next: {next task to work on}
- See: memory/latest.md
```

Rules:
- latest.md is OVERWRITTEN each time (never append)
- MEMORY.md ## NOW section is max 3 lines
- Be specific — file paths, function names, commit hashes
- Don't include code snippets, just describe what changed
