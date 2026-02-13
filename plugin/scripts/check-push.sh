#!/bin/bash
# memex: Detect git commit/push and BLOCK until memory is updated
# Uses PreToolUse hookSpecificOutput.permissionDecision to deny/allow

INPUT=$(cat)

# Debug logging
if [ -n "$MEMEX_DEBUG" ]; then
  echo "$INPUT" >> /tmp/memex-debug.log
  echo "---END PreToolUse---" >> /tmp/memex-debug.log
fi

# Parse command and cwd in one call
eval "$(echo "$INPUT" | python3 -c "
import sys, json, shlex
d = json.loads(sys.stdin.read())
cmd = d.get('tool_input', {}).get('command', '')
cwd = d.get('cwd', '')
print(f'COMMAND={shlex.quote(cmd)}')
print(f'CWD={shlex.quote(cwd)}')
" 2>/dev/null)"

deny() {
  local reason="$1"
  echo "{\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"permissionDecision\":\"deny\",\"permissionDecisionReason\":\"$reason\"}}"
  exit 0
}

if echo "$COMMAND" | grep -qE 'git commit'; then
  MEMORY_FILE="$CWD/memory/latest.md"

  if [ ! -f "$MEMORY_FILE" ]; then
    # No memory file in this project — skip check
    exit 0
  fi

  # Check if memory/latest.md is staged
  STAGED=$(cd "$CWD" && git diff --cached --name-only 2>/dev/null | grep -c "memory/latest.md")
  if [ "$STAGED" -gt 0 ]; then
    exit 0  # Already staged — allow commit
  fi

  # Check if modified in last 5 minutes but not staged
  if [ "$(uname)" = "Darwin" ]; then
    MOD_TIME=$(stat -f %m "$MEMORY_FILE" 2>/dev/null)
  else
    MOD_TIME=$(stat -c %Y "$MEMORY_FILE" 2>/dev/null)
  fi
  NOW=$(date +%s)
  if [ -n "$MOD_TIME" ] && [ $((NOW - MOD_TIME)) -lt 300 ]; then
    deny "MEMEX: memory/latest.md was updated but NOT staged. Stage it with git add memory/ then retry the commit."
  fi

  # Not updated — block
  deny "MEMEX: STOP. Before committing, update memory/latest.md (session date, completed tasks with commit hashes, next steps, decisions, gotchas). Also update ## NOW in MEMORY.md. Then git add memory/ and retry."

elif echo "$COMMAND" | grep -qE 'git push'; then
  # Check if memory/latest.md was in the last commit
  if [ -n "$CWD" ]; then
    IN_LAST_COMMIT=$(cd "$CWD" && git diff-tree --no-commit-id --name-only -r HEAD 2>/dev/null | grep -c "memory/latest.md")
    if [ "$IN_LAST_COMMIT" -gt 0 ]; then
      exit 0  # Memory was in last commit — allow push
    fi
  fi

  deny "MEMEX: STOP. memory/latest.md was not in the last commit. Update it, commit, then push."
fi
