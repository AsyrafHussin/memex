#!/bin/bash
# memex: Load session memory and output as JSON for Claude Code SessionStart hook

MEMORY_DIR="memory"
MEMORY_FILE="$MEMORY_DIR/latest.md"

# Auto-create memory folder and default file on first run
if [ ! -d "$MEMORY_DIR" ]; then
  mkdir -p "$MEMORY_DIR"
  cat > "$MEMORY_FILE" << 'EOF'
## Session (not started)

### Completed
- Fresh install, no work done yet

### Next
- Start working on your first task

### Decisions
- None yet

### Gotchas
- None yet
EOF
fi

if [ -f "$MEMORY_FILE" ]; then
  python3 -c "
import json
with open('$MEMORY_FILE') as f:
    content = f.read()
print(json.dumps({'additionalContext': content}))
" 2>/dev/null || {
    # Fallback if python3 not available
    cat "$MEMORY_FILE"
  }
else
  echo '{"additionalContext": "No session memory found. Use /memex:save to save state."}'
fi
