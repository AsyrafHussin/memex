---
name: memory-protocol
description: Automatically save session memory before pushing code. Use this skill when the user asks to push, commit and push, or when a session is ending.
---

# Memory Protocol

When the user asks to push code or when you detect a session is ending, BEFORE the push:

1. **Overwrite** `memory/latest.md` with:
   - Session date
   - What was completed (with commit hashes)
   - What should be done next (be specific)
   - Key decisions made
   - Gotchas encountered

2. **Update** the `## NOW` section in `MEMORY.md` (3 lines max):
   - Done: {last task} ({hash})
   - Next: {next task}
   - See: memory/latest.md

Rules:
- latest.md is always OVERWRITTEN, never appended
- Keep it concise — no code blocks, just descriptions
- Include file paths and function names for context
- Commit the memory files together with the code changes
