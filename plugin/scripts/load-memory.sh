#!/bin/bash
# memex: Load session memory and output as JSON for Claude Code SessionStart hook

MEMORY_FILE="memory/latest.md"

if [ -f "$MEMORY_FILE" ]; then
  python3 -c "
import json
with open('$MEMORY_FILE') as f:
    content = f.read()
print(json.dumps({'additionalContext': content}))
" 2>/dev/null || {
    # Fallback if python3 not available — output plain text
    cat "$MEMORY_FILE"
  }
else
  echo '{"additionalContext": "No session memory found. Use /memex:save to save state."}'
fi
