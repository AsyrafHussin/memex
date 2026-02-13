#!/bin/bash
# memex debug: log stdin from hooks to understand the format
INPUT=$(cat)
HOOK_EVENT=$(echo "$INPUT" | python3 -c "import sys,json; print(json.loads(sys.stdin.read()).get('hook_event_name','unknown'))" 2>/dev/null || echo "parse_failed")
echo "$INPUT" >> /tmp/memex-debug.log
echo "---END $HOOK_EVENT---" >> /tmp/memex-debug.log
