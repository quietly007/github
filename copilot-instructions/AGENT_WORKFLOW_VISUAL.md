# 📊 AGENT WORKFLOW - VISUAL GUIDE
## Quick Reference Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                     AGENT CONNECTS TO SERVER                        │
└────────────────────────────────┬────────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────────┐
│  PHASE 1: INITIAL CONNECTION (5-10 min) - MANDATORY READING         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  Step 1.1: Verify Server Identity                                   │
│  ├─ hostname, whoami, pwd                                           │
│  └─ ✍️  WRITE TO MEMORIES: agent_connected                          │
│                                                                       │
│  Step 1.2: Read 11 Mandatory Files (15 min reading)                 │
│  ├─ copilot-instructions.md                                         │
│  ├─ START_HERE.md                                                   │
│  ├─ WELCOME_NEW_AGENTS.md                                           │
│  ├─ CRITICAL_LESSONS.md                                             │
│  ├─ MANDATORY_CHECKLIST.md                                          │
│  ├─ memories.jsonl (last 100)                                       │
│  ├─ INFRASTRUCTURE_OVERVIEW.md                                      │
│  ├─ NETWORK_ARCHITECTURE.md                                         │
│  ├─ FILE_CREATION_RULES.md                                          │
│  ├─ ENFORCEMENT.md                                                  │
│  ├─ MEMORY_DISCIPLINE.md                                            │
│  └─ ✍️  WRITE TO MEMORIES: mandatory_reading_complete               │
│                                                                       │
│  Step 1.3: Self-Verification (10 questions)                         │
│  ├─ Is Headscale in Docker? (NO)                                    │
│  ├─ Master's public IP? (213.136.68.108)                            │
│  ├─ Tailscale range? (100.64.0.0/10)                                │
│  ├─ Can modify /etc/resolv.conf? (NO)                               │
│  └─ ✍️  WRITE TO MEMORIES: self_verification_complete               │
│                                                                       │
│  Step 1.4: Check Infrastructure State                               │
│  ├─ docker ps, systemctl status, ip addr, git status                │
│  └─ ✍️  WRITE TO MEMORIES: infrastructure_check                     │
│                                                                       │
│  Step 1.5: Read Context                                             │
│  ├─ SESSION_STATUS.md, HANDOFF.md, TODO.md                          │
│  └─ ✍️  WRITE TO MEMORIES: context_loaded                           │
│                                                                       │
└────────────────────────────────┬────────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────────┐
│  PHASE 2: USER INTERACTION & WORK EXECUTION                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  Step 2.1: Acknowledge Readiness                                    │
│  ├─ "Documentation read. Infrastructure healthy. Ready."            │
│  └─ ✍️  WRITE TO MEMORIES: agent_ready                              │
│                                                                       │
│  Step 2.2: Receive User Instructions                                │
│  ├─ Parse request                                                    │
│  ├─ Identify scope (documentation/production/both)                   │
│  ├─ Check governance                                                 │
│  └─ ✍️  WRITE TO MEMORIES: user_request_received                    │
│                                                                       │
│  Step 2.3: MANDATORY CHECKLIST                                      │
│  ├─ ☑️  Read instructions? YES                                      │
│  ├─ ☑️  Check governance? YES                                       │
│  ├─ ☑️  Ask permission? (if production)                             │
│  ├─ ☑️  Understand scope? YES                                       │
│  ├─ ☑️  Verify method? YES                                          │
│  └─ ✍️  WRITE TO MEMORIES: mandatory_checklist                      │
│                                                                       │
│  Step 2.4: Execute Work WITH MEMORY DISCIPLINE                      │
│  ┌──────────────────────────────────────────────────────────┐       │
│  │  FOR EVERY SINGLE STEP:                                  │       │
│  │                                                           │       │
│  │  1. Echo: "About to [action]"                            │       │
│  │  2. DO the action                                        │       │
│  │  3. ✍️  IMMEDIATELY WRITE TO MEMORIES                    │       │
│  │                                                           │       │
│  │  Example:                                                │       │
│  │  $ cat > file.md << 'EOF'                                │       │
│  │  [content]                                               │       │
│  │  EOF                                                     │       │
│  │  $ cat >> memories.jsonl << 'EOF'                        │       │
│  │  {"ts":"...","action":"created_file","target":"file.md"} │       │
│  │  EOF                                                     │       │
│  └──────────────────────────────────────────────────────────┘       │
│                                                                       │
└────────────────────────────────┬────────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────────┐
│  PHASE 3: TASK COMPLETION & DOCUMENTATION                           │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  Step 3.1: Update Existing Documentation                            │
│  ├─ Changed config? → Update config docs                            │
│  ├─ Deployed service? → Update service inventory                    │
│  ├─ Modified network? → Update network architecture                 │
│  └─ ✍️  WRITE TO MEMORIES: updated_documentation                    │
│                                                                       │
│  Step 3.2: Write Comprehensive Task Completion Memory               │
│  ├─ ✍️  action: TASK_COMPLETE                                       │
│  ├─ ✍️  files_created: [list]                                       │
│  ├─ ✍️  files_modified: [list]                                      │
│  ├─ ✍️  documentation_updated: true                                 │
│  ├─ ✍️  verification: [how verified]                                │
│  └─ ✍️  next_steps: [what's next]                                   │
│                                                                       │
│  Step 3.3: Commit to Git                                            │
│  ├─ git add [files]                                                 │
│  ├─ git commit -m "Detailed message"                                │
│  ├─ git push origin main                                            │
│  └─ ✍️  WRITE TO MEMORIES: git_commit                               │
│                                                                       │
│  Step 3.4: Sync Shared Memories (if cross-server)                   │
│  ├─ Run sync-memories.sh                                            │
│  └─ ✍️  WRITE TO MEMORIES: memory_sync                              │
│                                                                       │
│  Step 3.5: Update Session Status                                    │
│  ├─ Update SESSION_STATUS.md                                        │
│  └─ ✍️  WRITE TO MEMORIES: session_status_updated                   │
│                                                                       │
└────────────────────────────────┬────────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────────┐
│  PHASE 4: HANDOFF & VERIFICATION                                    │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  Step 4.1: Final Verification                                       │
│  ├─ ☑️  Containers healthy?                                         │
│  ├─ ☑️  Git clean?                                                  │
│  ├─ ☑️  Memories written?                                           │
│  ├─ ☑️  Docs updated?                                               │
│  └─ ✍️  WRITE TO MEMORIES: final_verification                       │
│                                                                       │
│  Step 4.2: Write Handoff Information                                │
│  ├─ Update HANDOFF.md                                               │
│  │   ├─ What was done                                               │
│  │   ├─ Current state                                               │
│  │   ├─ In progress items                                           │
│  │   └─ Important notes                                             │
│  └─ ✍️  WRITE TO MEMORIES: handoff_written                          │
│                                                                       │
│  Step 4.3: Final Memory Summary                                     │
│  └─ ✍️  WRITE TO MEMORIES: SESSION_COMPLETE                         │
│      ├─ duration                                                     │
│      ├─ tasks_completed                                              │
│      ├─ files_created/modified                                       │
│      ├─ memories_written                                             │
│      └─ next_agent_instructions                                      │
│                                                                       │
└────────────────────────────────┬────────────────────────────────────┘
                                 │
                                 ▼
                        ┌────────────────┐
                        │   DISCONNECT   │
                        │                │
                        │  Ready for     │
                        │  next agent!   │
                        └────────────────┘
```

---

## 🎯 KEY PRINCIPLES

### 1. ✍️  WRITE MEMORIES AFTER EVERY STEP
**Not at the end. Not when convenient. IMMEDIATELY AFTER EVERY ACTION.**

```bash
# Pattern:
[DO SOMETHING]
cat >> ~/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"what","target":"where","result":"outcome"}
EOF
```

### 2. 📚 UPDATE DOCS WHEN REALITY CHANGES
**Changed a config? Update config docs. Deployed service? Update inventory.**

### 3. 🔒 ASK PERMISSION FOR PRODUCTION CHANGES
**Don't restart services. Don't modify configs. ASK FIRST.**

### 4. ✅ VERIFY BEFORE DISCONNECTING
**Containers healthy? Git clean? Memories written? Docs updated? Handoff written?**

---

## ⚠️ COMMON VIOLATIONS

### ❌ DON'T BE THIS AGENT:
- Skips reading mandatory files
- Makes assumptions instead of checking logs
- Forgets to write memories
- Doesn't update documentation
- Makes production changes without permission
- Doesn't leave handoff for next agent
- Commits nothing to Git

### ✅ BE THIS AGENT:
- Reads ALL 11 files before starting
- Checks actual logs and data
- Writes memory after EVERY step
- Updates docs to match reality
- Asks permission before production changes
- Leaves complete handoff
- Commits all changes to Git
- Infrastructure still A+++ after work

---

## 📊 COMPLIANCE SCORECARD

After your session, verify:

```
☑️  Read 11 mandatory files                    [____]
☑️  Answered 10 verification questions         [____]
☑️  Wrote memory after EVERY step              [____]
☑️  Wrote memory after EVERY task completion   [____]
☑️  Updated documentation                      [____]
☑️  Asked permission for prod changes          [____]
☑️  Committed all changes to Git               [____]
☑️  Synced shared memories                     [____]
☑️  Updated SESSION_STATUS.md                  [____]
☑️  Wrote HANDOFF.md                           [____]
☑️  Final verification passed                  [____]
☑️  Infrastructure still healthy               [____]

TOTAL: ___/12

Required: 12/12 (100%)
```

---

**THIS WORKFLOW IS MANDATORY. NO EXCEPTIONS.**

*Excellence through discipline. Every agent. Every time.*
