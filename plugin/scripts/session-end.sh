#!/bin/bash
# memex: Fallback save on session end
# Since Claude can't write files after session ends, this script
# extracts a basic summary from the transcript as a safety net

INPUT=$(cat)

echo "$INPUT" | python3 -c "
import sys, json, os, datetime

try:
    data = json.loads(sys.stdin.read())
except:
    sys.exit(0)

transcript_path = data.get('transcript_path', '')
cwd = data.get('cwd', '')

if not transcript_path or not cwd:
    sys.exit(0)

memory_file = os.path.join(cwd, 'memory', 'latest.md')

# Skip if memory was saved recently (within last 3 minutes)
if os.path.exists(memory_file):
    mtime = os.path.getmtime(memory_file)
    age = datetime.datetime.now().timestamp() - mtime
    if age < 180:  # 3 minutes
        sys.exit(0)

# Parse transcript and extract last few assistant messages
if not os.path.exists(transcript_path):
    sys.exit(0)

messages = []
try:
    with open(transcript_path) as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                entry = json.loads(line)
                role = entry.get('role', '')
                if role == 'assistant':
                    content = entry.get('content', '')
                    if isinstance(content, list):
                        texts = [b.get('text', '') for b in content if b.get('type') == 'text']
                        content = ' '.join(texts)
                    if isinstance(content, str) and len(content) > 50:
                        messages.append(content[:500])
            except:
                continue
except:
    sys.exit(0)

if not messages:
    sys.exit(0)

# Take last 5 meaningful messages
recent = messages[-5:]
today = datetime.date.today().isoformat()

# Write basic fallback summary
os.makedirs(os.path.dirname(memory_file), exist_ok=True)
with open(memory_file, 'w') as f:
    f.write(f'## Session {today} (auto-saved by memex)\n\n')
    f.write('### Summary (extracted from transcript)\n')
    for msg in recent:
        # First line of each message as a bullet
        first_line = msg.split(chr(10))[0][:200]
        f.write(f'- {first_line}\n')
    f.write('\n### Note\n')
    f.write('This was auto-saved because the session ended without /memex:save.\n')
    f.write('The summary above is a rough extraction. Run /memex:save next session for a proper summary.\n')
" 2>/dev/null
