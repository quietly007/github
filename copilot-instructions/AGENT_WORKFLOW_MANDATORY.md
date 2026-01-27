# 🔄 AGENT WORKFLOW - MANDATORY EXECUTION PROTOCOL
## qui3tly.cloud Infrastructure Operations

> **Authority**: Governance + Memory Discipline + Enforcement Rules  
> **Status**: MANDATORY - Every agent MUST follow this workflow  
> **Violations**: Logged, flagged, work reverted  
> **Last Updated**: 2026-01-27

---

## 🎯 PURPOSE

This workflow ensures EVERY agent:
1. Reads ALL mandatory documentation before acting
2. Writes EVERY step to memories
3. Documents EVERY completed task
4. Follows governance rules
5. Gets permission for production changes

**NO EXCEPTIONS. NO SHORTCUTS.**

---

## 📋 WORKFLOW: AGENT CONNECTION TO SERVER

### PHASE 1: INITIAL CONNECTION (5-10 minutes) - MANDATORY!

#### Step 1.1: Verify Server Identity
```bash
# Check which server you're on
hostname          # quietly.its.me (Master) or lady (Worker)
whoami            # Should be: qui3tly
pwd               # Should be: /home/qui3tly

# Write to memories
cat >> ~/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"agent_connected","server":"$(hostname)","user":"$(whoami)","result":"verified"}
EOF
```

**Document**: Write hostname and verification result to memories

#### Step 1.2: Read Mandatory Documentation (NO SHORTCUTS!)
```bash
# MUST READ IN THIS ORDER (15 minutes reading time):

# 1. Main instructions (11KB)
cat ~/.github/copilot-instructions/copilot-instructions.md

# 2. Agent onboarding (26KB)  
cat ~/.copilot/START_HERE.md

# 3. New agent rules (5KB)
cat ~/.copilot/WELCOME_NEW_AGENTS.md

# 4. Critical lessons (4KB)
cat ~/.copilot/CRITICAL_LESSONS.md

# 5. Mandatory checklist (2KB)
cat ~/.copilot/MANDATORY_CHECKLIST.md

# 6. Recent memories (last 100 entries)
tail -100 ~/.copilot/memories.jsonl

# 7. Infrastructure overview (28KB)
cat ~/.docs/00-QUICKSTART/INFRASTRUCTURE_OVERVIEW.md

# 8. Network architecture (80KB)
cat ~/.docs/01-architecture/NETWORK_ARCHITECTURE.md

# 9. File creation rules (from governance)
cat ~/.github/governance/FILE_CREATION_RULES.md

# 10. Enforcement rules
cat ~/.github/governance/ENFORCEMENT.md

# 11. Memory discipline
cat ~/.docs/02-operations/MEMORY_DISCIPLINE.md
```

**Document**: Write to memories that you've read ALL files:
```bash
cat >> ~/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"mandatory_reading_complete","files_read":11,"docs_size":"185KB","result":"READY","understood":["headscale_native","master_ip_213.136.68.108","tailscale_range_100.64.0.0/10","resolv_conf_immutable","check_logs_first"]}
EOF
```

#### Step 1.3: Self-Verification Questions

**BEFORE YOU PROCEED, ANSWER THESE (prove you read docs):**

1. ❓ Is Headscale in Docker? **Answer**: NO - native systemd service at /etc/headscale/config.yaml
2. ❓ What is Master's public IP? **Answer**: 213.136.68.108
3. ❓ What is Tailscale VPN range? **Answer**: 100.64.0.0/10
4. ❓ Can you modify /etc/resolv.conf? **Answer**: NO - immutable, bootstrap protection
5. ❓ User says "it works" - what do you do? **Answer**: Check THEIR access logs, don't test yourself
6. ❓ Where do instruction files live? **Answer**: Shared files in ~/.github/copilot-instructions/, Master state in ~/.copilot/
7. ❓ What's the workflow for production changes? **Answer**: Ask permission FIRST, never direct changes
8. ❓ How often write to memories? **Answer**: After EVERY step, EVERY task completion
9. ❓ Can you patch configs? **Answer**: NO - only permanent solutions, no patches
10. ❓ What grade is infrastructure? **Answer**: A+++ (10/10) World-Class Excellence

**If you cannot answer ANY of these → STOP, go back to Step 1.2**

**Document**: Write verification results:
```bash
cat >> ~/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"self_verification_complete","questions":10,"correct":10,"result":"VERIFIED","ready_for_work":true}
EOF
```

#### Step 1.4: Check Current Infrastructure State
```bash
# System health
uptime
df -h
free -h

# Container status
docker ps -a | wc -l              # Should be ~23 on Master, ~23 on Lady
docker ps --filter "status=running" | wc -l

# Service status (Master specific)
systemctl status headscale --no-pager
systemctl status tailscaled --no-pager

# Network status
ip addr show | grep "inet " | grep -v "127.0.0.1"
wg show 2>/dev/null | head -10

# Git status
cd ~ && git status --short | head -10
cd ~/.github && git status --short | head -10

# Memory status
tail -5 ~/.copilot/memories.jsonl
tail -5 ~/.github/copilot-shared/memories/master.jsonl
```

**Document**: Write infrastructure state:
```bash
cat >> ~/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"infrastructure_check","containers_total":23,"containers_running":23,"services_healthy":["headscale","tailscaled","docker"],"git_status":"clean","result":"ALL_HEALTHY"}
EOF
```

#### Step 1.5: Read User's Last Request Context
```bash
# Check session status
cat ~/.copilot/SESSION_STATUS.md 2>/dev/null

# Check last failure (if any)
cat ~/.copilot/LAST_FAILURE.md 2>/dev/null

# Check handoff info
cat ~/.copilot/HANDOFF.md 2>/dev/null

# Check current project TODO
cat ~/.github/projects/qui3tly.cloud/TODO.md | head -100
```

**Document**: Write context understood:
```bash
cat >> ~/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"context_loaded","session_status":"reviewed","last_failure":"reviewed","handoff":"reviewed","project_todo":"reviewed","result":"CONTEXT_COMPLETE"}
EOF
```

---

### PHASE 2: USER INTERACTION & WORK EXECUTION

#### Step 2.1: Acknowledge Readiness (NO GREETINGS!)

**DON'T SAY:**
- ❌ "Hello! How can I help you today?"
- ❌ "What would you like me to do?"
- ❌ "I'm ready, just let me know what you need!"

**DO SAY:**
- ✅ "Documentation read. Infrastructure healthy (23/23 containers running). Master IP 213.136.68.108, Tailscale 100.64.0.0/10. Ready for instructions."
- ✅ "System verified. All services operational. Recent context: [brief summary of last work]. Awaiting direction."
- ✅ "A+++ infrastructure confirmed. Last work: [summary]. What's next?"

**Document**:
```bash
cat >> ~/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"agent_ready","phase":"awaiting_user_instructions","context_loaded":true,"infrastructure_verified":true}
EOF
```

#### Step 2.2: Receive User Instructions

**When user gives instructions:**

1. **Parse the request** - What exactly are they asking?
2. **Identify scope** - Documentation only? Production change? Both?
3. **Check governance** - Is this allowed? What's the workflow?
4. **Determine method** - Direct change or Ansible? GitHub involved?

**Document**:
```bash
cat >> ~/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"user_request_received","request":"[summary]","scope":"[documentation|production|both]","governance_check":"passed","method":"[direct|ansible|github]"}
EOF
```

#### Step 2.3: MANDATORY CHECKLIST - Before ANY Change

**FOR EVERY ACTION, CHECK:**

- [ ] **Read instructions?** (YES - Phase 1 complete)
- [ ] **Check governance?** (What does ~/.github/governance/ say?)
- [ ] **Ask permission?** (For production changes)
- [ ] **Understand scope?** (Documentation vs production)
- [ ] **Verify method?** (Correct approach per governance)

**If ANY checkbox is NO → STOP, don't proceed**

**Document**:
```bash
cat >> ~/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"mandatory_checklist","instructions_read":true,"governance_checked":true,"permission":"[yes|not_needed]","scope":"understood","method":"verified","result":"CLEARED_TO_PROCEED"}
EOF
```

#### Step 2.4: Execute Work - WITH MEMORY DISCIPLINE

**FOR EVERY SINGLE STEP:**

```bash
# BEFORE action:
echo "About to: [describe action]"

# DO the action:
[actual command or operation]

# IMMEDIATELY AFTER action:
cat >> ~/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"[what-you-did]","target":"[what-you-modified]","result":"[outcome]","details":"[comprehensive-details]"}
EOF
```

**Example - Creating a file:**
```bash
# BEFORE
echo "Creating documentation file: ~/.docs/03-services/EXAMPLE.md"

# DO
cat > ~/.docs/03-services/EXAMPLE.md << 'EOF'
[content here]
EOF

# IMMEDIATELY AFTER
cat >> ~/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"created_file","target":"~/.docs/03-services/EXAMPLE.md","size":"1234 bytes","lines":45,"result":"SUCCESS","purpose":"document Example service configuration"}
EOF
```

**Example - Modifying config:**
```bash
# BEFORE - ASK PERMISSION!
echo "User, I need to modify ~/.docker/traefik/traefik.yaml to add new route. OK?"
# WAIT FOR APPROVAL

# DO (after approval)
sed -i 's/old_value/new_value/' ~/.docker/traefik/traefik.yaml

# IMMEDIATELY AFTER
cat >> ~/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"modified_config","target":"~/.docker/traefik/traefik.yaml","change":"added_new_route","permission":"granted","result":"SUCCESS","requires_restart":true}
EOF
```

**Example - Restarting service:**
```bash
# BEFORE - ASK PERMISSION!
echo "Need to restart traefik container for changes to take effect. Proceed?"
# WAIT FOR APPROVAL

# DO (after approval)
docker restart traefik

# IMMEDIATELY AFTER
cat >> ~/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"restarted_container","target":"traefik","permission":"granted","result":"SUCCESS","downtime":"~2s","verification":"checked_logs_healthy"}
EOF

# ALSO VERIFY
docker ps --filter "name=traefik" --format "{{.Status}}"
docker logs traefik --tail 20 2>&1 | grep -i error
```

---

### PHASE 3: TASK COMPLETION & DOCUMENTATION

#### Step 3.1: Update Existing Documentation

**MANDATORY: When you change reality, update docs!**

**Changed configuration?** → Update config docs  
**Deployed service?** → Update service inventory  
**Modified network?** → Update network architecture  
**Changed firewall?** → Update firewall docs  
**Modified monitoring?** → Update monitoring docs

**Document**:
```bash
cat >> ~/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"updated_documentation","docs_modified":["~/.docs/03-services/TRAEFIK.md"],"reason":"reflected_config_changes","lines_changed":23,"result":"DOCS_CURRENT"}
EOF
```

#### Step 3.2: Write Comprehensive Task Completion Memory

**When task is FINISHED:**

```bash
cat >> ~/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"TASK_COMPLETE","task":"[task-name]","files_created":["list"],"files_modified":["list"],"services_restarted":["list"],"documentation_updated":true,"memories_written":15,"result":"SUCCESS","verification":"[how-you-verified]","grade":"A+++","next_steps":"[what-comes-next]"}
EOF
```

**Example**:
```bash
cat >> ~/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"TASK_COMPLETE","task":"deployed-new-monitoring-dashboard","files_created":["~/.docker/grafana/dashboards/custom-dashboard.json"],"files_modified":["~/.docker/grafana/provisioning/dashboards/dashboards.yml"],"services_restarted":["grafana"],"documentation_updated":true,"docs_modified":["~/.docs/03-services/MONITORING.md"],"memories_written":8,"result":"SUCCESS","verification":"accessed_dashboard_http_200","grade":"A+++","impact":"new_metrics_visible","next_steps":"create_alerts_for_new_metrics"}
EOF
```

#### Step 3.3: Commit to Git (If Files Changed)

**If you created/modified ANY files:**

```bash
# Check what changed
cd ~
git status

# Add all changes
git add [files]

# Commit with descriptive message
git commit -m "Type: Brief description

Detailed explanation of what was done and why.

Changes:
- Created: [list]
- Modified: [list]
- Reason: [why]

Verified: [how verified]
"

# Push to GitHub
git push origin main

# Document git operations
cat >> ~/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"git_commit","files_added":5,"files_modified":2,"commit_message":"[summary]","pushed":true,"branch":"main","result":"SUCCESS"}
EOF
```

#### Step 3.4: Sync Shared Memories (If Cross-Server Work)

**If work affects both servers:**

```bash
# Run memory sync script
~/.copilot/scripts/sync-memories.sh

# Verify sync worked
tail -5 ~/.github/copilot-shared/memories/master.jsonl

# Document sync
cat >> ~/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"memory_sync","source":"~/.copilot/memories.jsonl","destination":"~/.github/copilot-shared/memories/master.jsonl","entries_synced":10,"result":"SUCCESS"}
EOF
```

#### Step 3.5: Update Session Status

**Update current session state:**

```bash
cat > ~/.copilot/SESSION_STATUS.md << 'EOF'
# Session Status

**Last Updated**: $(date -u +%Y-%m-%dT%H:%M:%SZ)
**Agent**: [your-name]
**Session Started**: [timestamp]

## Work Completed Today
1. [Task 1] - COMPLETE ✅
2. [Task 2] - COMPLETE ✅
3. [Task 3] - IN PROGRESS ⏳

## Current State
- Infrastructure: Healthy (23/23 containers)
- Git: Clean working tree
- Documentation: Updated
- Memories: Written (45 entries today)

## Next Steps
1. [What comes next]
2. [Pending items]

## Notes
[Any important context for next agent]
EOF

# Document
cat >> ~/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"session_status_updated","tasks_completed":2,"tasks_in_progress":1,"memories_written_today":45,"result":"DOCUMENTED"}
EOF
```

---

### PHASE 4: HANDOFF & VERIFICATION

#### Step 4.1: Final Verification

**Before disconnecting:**

```bash
# Verify all containers healthy
docker ps --filter "status=running" | wc -l

# Verify no uncommitted changes
cd ~ && git status --short
cd ~/.github && git status --short

# Verify memories written
tail -10 ~/.copilot/memories.jsonl

# Verify documentation updated
find ~/.docs -name "*.md" -mtime -1  # Files modified in last 24h

# Document final verification
cat >> ~/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"final_verification","containers_healthy":true,"git_clean":true,"memories_written":true,"docs_updated":true,"result":"ALL_VERIFIED"}
EOF
```

#### Step 4.2: Write Handoff Information

**Update handoff for next agent:**

```bash
cat > ~/.copilot/HANDOFF.md << 'EOF'
# Agent Handoff

**Date**: $(date -u +%Y-%m-%d)
**From**: [your-name]
**Session Duration**: [X hours]

## What Was Done
- [Major task 1] - COMPLETE
- [Major task 2] - COMPLETE
- [Major task 3] - IN PROGRESS (60% done)

## Current State
- Infrastructure: A+++ (23/23 containers healthy)
- Master: 213.136.68.108 (all services operational)
- Lady: 100.64.0.2 (all services operational)
- Git: All changes committed and pushed
- Documentation: Updated and current

## In Progress
[Task name] - Next agent should:
1. [Step to continue]
2. [What needs finishing]
3. [Any blockers or notes]

## Important Notes
- [Any critical information]
- [Changes that need monitoring]
- [Pending decisions or approvals]

## Verification
- ✅ All memories written (67 entries this session)
- ✅ All documentation updated
- ✅ Git committed and pushed
- ✅ Infrastructure verified healthy
- ✅ No errors in logs

Next agent: Read this file and ~/.copilot/SESSION_STATUS.md before starting!
EOF

# Document handoff
cat >> ~/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"handoff_written","session_duration":"3.5h","tasks_completed":2,"tasks_in_progress":1,"memories_written":67,"result":"HANDOFF_READY"}
EOF
```

#### Step 4.3: Final Memory Summary

**Write comprehensive session summary:**

```bash
cat >> ~/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"SESSION_COMPLETE","agent":"[name]","duration":"3.5h","tasks_total":3,"tasks_completed":2,"tasks_in_progress":1,"files_created":5,"files_modified":8,"docs_updated":3,"services_restarted":2,"git_commits":4,"memories_written":67,"result":"SUCCESS","grade":"A+++","handoff":"READY","next_agent_instructions":"Read HANDOFF.md and SESSION_STATUS.md"}
EOF
```

---

## 📊 COMPLIANCE VERIFICATION

### Self-Audit Checklist

**After EVERY session, verify:**

- [ ] Read ALL mandatory documentation? (11 files)
- [ ] Answered ALL verification questions correctly?
- [ ] Checked infrastructure state?
- [ ] Wrote memory AFTER EVERY STEP?
- [ ] Wrote memory AFTER EVERY TASK COMPLETION?
- [ ] Updated documentation when reality changed?
- [ ] Asked permission for production changes?
- [ ] Followed governance rules?
- [ ] Committed all changes to Git?
- [ ] Synced shared memories if needed?
- [ ] Updated SESSION_STATUS.md?
- [ ] Wrote HANDOFF.md for next agent?
- [ ] Final verification passed?

**If ANY checkbox is unchecked → YOUR SESSION IS NON-COMPLIANT**

---

## 🚨 ENFORCEMENT

### Automated Monitoring

**The system monitors:**
- Memory writing frequency (must be <15min gaps)
- Documentation update timestamps (must match changes)
- Git commit completeness (all changes must be committed)
- Session handoff presence (HANDOFF.md must exist)

### Violation Consequences

1. **First violation**: Warning logged to memories
2. **Second violation**: All work from session flagged for review
3. **Third violation**: Work reverted, agent banned

### Audit Scripts

```bash
# Check your compliance
~/.copilot/scripts/audit-memories.sh

# Check documentation currency
~/.copilot/scripts/verify-docs.sh

# Check git completeness
cd ~ && git status
cd ~/.github && git status
```

---

## 🎯 SUCCESS CRITERIA

**You are a COMPLIANT AGENT when:**

✅ Read all 11 mandatory files before starting  
✅ Wrote memory after EVERY step (no gaps >15min)  
✅ Wrote memory after EVERY task completion  
✅ Updated documentation to match reality  
✅ Asked permission for all production changes  
✅ Followed governance rules exactly  
✅ Committed all changes to Git  
✅ Left complete HANDOFF for next agent  
✅ Infrastructure still healthy after your work  
✅ Grade maintained: A+++ (10/10)

---

## 📝 QUICK REFERENCE

### Memory Writing Template
```bash
cat >> ~/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"[action]","target":"[target]","result":"[result]","details":"[details]"}
EOF
```

### Task Completion Template
```bash
cat >> ~/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"TASK_COMPLETE","task":"[name]","files_created":[],"files_modified":[],"documentation_updated":true,"result":"SUCCESS","next_steps":"[next]"}
EOF
```

### Required Files to Read
1. ~/.github/copilot-instructions/copilot-instructions.md
2. ~/.copilot/START_HERE.md
3. ~/.copilot/WELCOME_NEW_AGENTS.md
4. ~/.copilot/CRITICAL_LESSONS.md
5. ~/.copilot/MANDATORY_CHECKLIST.md
6. ~/.copilot/memories.jsonl (last 100)
7. ~/.docs/00-QUICKSTART/INFRASTRUCTURE_OVERVIEW.md
8. ~/.docs/01-architecture/NETWORK_ARCHITECTURE.md
9. ~/.github/governance/FILE_CREATION_RULES.md
10. ~/.github/governance/ENFORCEMENT.md
11. ~/.docs/02-operations/MEMORY_DISCIPLINE.md

---

**THIS IS NOT OPTIONAL. THIS IS LAW.**

*Every agent follows this workflow. No exceptions. No shortcuts. Excellence through discipline.*
