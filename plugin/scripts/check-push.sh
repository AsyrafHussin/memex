#!/bin/bash
# memex: Detect git commit/push and remind Claude to save memory first

INPUT=$(cat)

# Debug: log stdin to help diagnose hook issues
if [ -n "$MEMEX_DEBUG" ]; then
  echo "$INPUT" >> /tmp/memex-debug.log
  echo "---END PreToolUse---" >> /tmp/memex-debug.log
fi

COMMAND=$(echo "$INPUT" | python3 -c "import sys,json; print(json.loads(sys.stdin.read()).get('tool_input',{}).get('command',''))" 2>/dev/null)

if echo "$COMMAND" | grep -qE 'git commit'; then
  echo '{"additionalContext": "MEMEX: You are about to commit. BEFORE running this commit, make sure memory/latest.md is up to date:\n1. Write memory/latest.md with: session date, completed tasks (with commit hashes), next steps, decisions, gotchas\n2. Update the ## NOW section in auto-memory MEMORY.md\n3. Include memory files in this commit"}'
elif echo "$COMMAND" | grep -qE 'git push'; then
  echo '{"additionalContext": "MEMEX: You are about to push. Make sure memory/latest.md was updated and committed before pushing."}'
fi
