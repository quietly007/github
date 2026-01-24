#!/bin/bash
# Sync Memories - Push Master's memories to Lady
# Run from MASTER after major changes
# Usage: ./sync-memories.sh

set -euo pipefail

HOSTNAME=$(hostname)
if [[ "$HOSTNAME" != quietly.its.me* ]]; then
    echo "ERROR: This script runs from MASTER (quietly.its.me) only!"
    exit 1
fi

TWIN="lady"
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

echo "🧠 Syncing memories Master → Lady"
echo ""

# Get last N entries from master
ENTRIES=50

echo "Copying last $ENTRIES memory entries to Lady..."

# Append master entries to lady (with marker)
tail -$ENTRIES ~/.copilot/memories.jsonl | while read line; do
    # Add origin marker
    MARKED=$(echo "$line" | jq -c '. + {origin: "master-sync"}')
    echo "$MARKED"
done | ssh $TWIN "cat >> ~/.copilot/memories.jsonl"

# Log the sync
cat >> ~/.copilot/memories.jsonl << EOF
{"ts":"$TIMESTAMP","action":"memory-sync","target":"lady","result":"Pushed last $ENTRIES entries"}
EOF

ssh $TWIN "cat >> ~/.copilot/memories.jsonl << EOF
{\"ts\":\"$TIMESTAMP\",\"action\":\"memory-sync-received\",\"target\":\"from-master\",\"result\":\"Received sync from master\"}
EOF"

echo "✅ Memory sync complete!"
echo ""
echo "Master memories: $(wc -l < ~/.copilot/memories.jsonl) entries"
echo "Lady memories: $(ssh $TWIN 'wc -l < ~/.copilot/memories.jsonl') entries"
