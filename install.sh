#!/bin/bash
# memex - Lightweight persistent memory for Claude Code sessions
# Usage: curl -fsSL https://raw.githubusercontent.com/AsyrafHussin/memex/main/install.sh | bash

set -e

echo "memex: Setting up session memory..."

mkdir -p memory

if [ ! -f "memory/latest.md" ]; then
  cat > "memory/latest.md" << 'EOF'
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
  echo "memex: Created memory/latest.md"
else
  echo "memex: memory/latest.md already exists, skipping"
fi

echo "memex: Done! Memory will be saved automatically by the plugin."
