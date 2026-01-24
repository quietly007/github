# Copilot - Shared Agent Coordination

> **Purpose**: Cross-server AI agent coordination  
> **Last Updated**: 2026-01-17

## Structure

```
copilot/
├── memories/           # Per-server memory files
│   ├── master.jsonl    # Master server memories
│   └── lady.jsonl      # Lady server memories
├── scripts/            # Shared scripts (synced to both)
└── skills/             # Shared skills/prompts
```

## Usage

Both servers clone this repo to `~/.copilot-shared/`:
- Master: Read/Write
- Lady: Read-only (can read Master's memories)

Local `.copilot/` still exists for server-specific backups/temp files.

## Memory Format

```json
{"ts":"ISO8601","server":"master|lady","action":"WHAT","target":"WHERE","result":"OUTCOME"}
```
