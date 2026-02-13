#!/bin/bash
# memex - Lightweight persistent memory for Claude Code sessions
# Usage: curl -fsSL https://raw.githubusercontent.com/AsyrafHussin/memex/main/install.sh | bash

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

# Add ## NOW section to CLAUDE.md (auto-loaded by Claude Code)
if [ -f "CLAUDE.md" ]; then
  if ! grep -q "## NOW" CLAUDE.md; then
    # Append NOW section
    cat >> CLAUDE.md << 'EOF'

## NOW
- Done: (not started)
- Next: (first task)
- See: memory/latest.md
EOF
    echo "memex: Added ## NOW section to CLAUDE.md"
  fi
else
  echo "memex: No CLAUDE.md found. The ## NOW section will be added when you create one."
fi

echo "memex: Done! Use /memex:save before ending a session to persist memory."
