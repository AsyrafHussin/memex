#!/bin/bash
# memex - Lightweight persistent memory for AI coding sessions
# Usage: curl -fsSL https://raw.githubusercontent.com/asyrafhussin/memex/main/install.sh | bash

set -e

MEMEX_DIR="memory"

echo "memex: Setting up session memory..."

# Create memory directory
mkdir -p "$MEMEX_DIR"

# Create latest.md if not exists
if [ ! -f "$MEMEX_DIR/latest.md" ]; then
  cat > "$MEMEX_DIR/latest.md" << 'EOF'
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
  echo "memex: Created $MEMEX_DIR/latest.md"
fi

# Add ## NOW section to MEMORY.md if it exists but doesn't have it
if [ -f "MEMORY.md" ]; then
  if ! grep -q "## NOW" MEMORY.md; then
    # Prepend NOW section
    TEMP=$(mktemp)
    cat > "$TEMP" << 'EOF'
## NOW
- Done: (not started)
- Next: (first task)
- See: memory/latest.md

EOF
    cat MEMORY.md >> "$TEMP"
    mv "$TEMP" MEMORY.md
    echo "memex: Added ## NOW section to MEMORY.md"
  fi
else
  echo "memex: No MEMORY.md found. Create one with your project context."
fi

echo "memex: Done! Use /memex:save before pushing to persist session memory."
