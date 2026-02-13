#!/bin/bash
# memex: Check context usage and warn when getting high
# Runs on every PostToolUse — must be fast

INPUT=$(cat)

echo "$INPUT" | python3 -c "
import sys, json, os

try:
    data = json.loads(sys.stdin.read())
except:
    sys.exit(0)

cw = data.get('context_window', {})
pct = cw.get('used_percentage', 0)

if not pct or pct < 60:
    sys.exit(0)

state_file = '/tmp/memex-context-warn'
last_warn = 0
try:
    with open(state_file) as f:
        parts = f.read().strip().split(':')
        session = parts[0] if len(parts) > 1 else ''
        last_warn = int(parts[-1])
        # Reset if different session
        sid = data.get('session_id', '')
        if session != sid:
            last_warn = 0
except:
    pass

sid = data.get('session_id', '')
p = int(pct)

if p >= 85 and last_warn < 85:
    with open(state_file, 'w') as f:
        f.write(f'{sid}:{p}')
    print(json.dumps({'additionalContext': f'MEMEX URGENT: Context at {p}%! Save session memory NOW before it runs out. Write memory/latest.md with: session date, completed tasks (with commit hashes), next steps, decisions, gotchas. Update ## NOW in auto-memory MEMORY.md. Commit the memory files.'}))
elif p >= 70 and last_warn < 70:
    with open(state_file, 'w') as f:
        f.write(f'{sid}:{p}')
    print(json.dumps({'additionalContext': f'MEMEX: Context at {p}%. Save session memory soon — write memory/latest.md and update ## NOW in auto-memory MEMORY.md.'}))
" 2>/dev/null
