#!/bin/bash
# memex: Remind to save memory before context compaction (/clear or auto)

# Drain stdin (required even if unused, to prevent pipe issues)
INPUT=$(cat)

# Debug: log stdin to help diagnose hook issues
if [ -n "$MEMEX_DEBUG" ]; then
  echo "$INPUT" >> /tmp/memex-debug.log
  echo "---END PreCompact---" >> /tmp/memex-debug.log
fi

echo '{"additionalContext": "MEMEX: Context is about to be compacted. Save session memory NOW before it is lost.\n\n1. Write memory/latest.md with: session date, completed tasks (with commit hashes), next steps, decisions, gotchas\n2. Update ## NOW section in auto-memory MEMORY.md\n3. Commit the memory files"}'
