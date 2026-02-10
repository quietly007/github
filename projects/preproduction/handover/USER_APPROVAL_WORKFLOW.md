# USER APPROVAL WORKFLOW
## Every TODO Requires Your Y/N Approval

**Date:** 2026-02-10  
**Purpose:** Step-by-step guide for user to approve and verify every TODO item  
**Status:** MANDATORY for all 34 TODO items  

---

## 🎯 YOUR ROLE IN EXECUTION

You are the **approval authority** for every change to your infrastructure. No command gets executed without your explicit Y approval.

### What You Do:

1. **APPROVE** (or reject) every TODO before execution starts
2. **REVIEW** documentation and evidence after execution
3. **VERIFY** success criteria with agent
4. **CONFIRM** completion before moving to next TODO

---

## 📋 WORKFLOW FOR EACH TODO ITEM

### Phase 1: PRE-EXECUTION APPROVAL (2-5 minutes)

**Agent asks you:**
> "Ready to execute TODO-P0-01: Finish Nextcloud install (cron spamming 'Not installed')? Y/N"

**You should:**
1. Read the TODO item in [COMPLETE_TODO_LIST_2026-02-10.md](COMPLETE_TODO_LIST_2026-02-10.md)
2. Review: Evidence, Steps, Success Criteria, Rollback plan
3. Check: Is this the right time? Any dependencies? System ready?
4. **Respond:**
   - **Y** = "Yes, execute now" (agent proceeds immediately)
   - **N** = "No, skip or postpone" (agent documents reason, moves to next)

**Example responses:**
```
Y → Execute TODO-P0-01 now
N → Skip TODO-P0-01, dependency not ready
N → Postpone TODO-P0-01 until tomorrow
```

---

### Phase 2: EXECUTION (Agent works, you monitor)

**Agent executes the TODO:**
- Runs all commands from Steps section
- Documents every command and output
- Takes screenshots of critical steps
- Creates execution log: `/tmp/execution_log_P0-01.txt`

**You can:**
- Monitor progress in real-time (watch terminal output)
- Ask questions if anything unclear
- Request pause if issues arise
- See documentation being created

**Agent creates:**
- Execution log with timestamps
- Screenshots of key steps
- Config diffs if files changed
- Backup confirmation

---

### Phase 3: DOCUMENTATION (Agent creates records)

**Agent creates permanent records:**

1. **Memory file:** `/home/qui3tly/personal/memories/TODO_P0_01_2026-02-10.md`
   - What was done (summary)
   - Commands executed (copy-paste)
   - Results achieved (what changed)
   - Evidence files (screenshots, logs)
   - Verification results (success criteria)

2. **Project docs updated:**
   - `/home/qui3tly/personal/manuals/nextcloud.md` (installation complete)
   - `/home/qui3tly/personal/README.md` (current state)
   - `/home/qui3tly/personal/NOTES.md` (lessons learned)

3. **Execution tracker updated:**
   - `/home/qui3tly/projects/preproduction/handover/EXECUTION_TRACKER_2026-02-10.md`
   - Status changed: ⬜ → 🔄 → ✅

**You can:**
- Review memory file (verify summary accurate)
- Check updated manuals (make sure info correct)
- Read execution log if curious about details

---

### Phase 4: POST-EXECUTION VERIFICATION (5-15 minutes)

**Agent tests success criteria:**
```bash
# Example for TODO-P0-01:
docker exec nextcloud php /config/www/nextcloud/occ status
# ✅ Expected: installed: true

docker logs nextcloud --tail 50 --since 10m
# ✅ Expected: No "Not installed" errors

curl -skI https://cloud.quietly.online
# ✅ Expected: HTTP/2 200
```

**Agent asks you:**
> "TODO-P0-01 complete. Verification passed? Please confirm:
> - ✅ occ status shows installed: true
> - ✅ No 'Not installed' errors in last 10 minutes
> - ✅ Login page loads via VPN (HTTP 200)
> 
> Verification passed? Y/N"

**You should:**
1. Review verification results (agent shows you output)
2. Optionally: Test yourself (`curl`, check web UI, etc.)
3. Check memory file was created
4. Check docs were updated
5. **Respond:**
   - **Y** = "Verified, looks good" (agent marks ✅, proceeds to next TODO)
   - **N** = "Something wrong" (agent investigates, may rollback, re-test)

**If you respond N:**
- Agent asks: "What issue do you see?"
- You explain problem
- Agent checks, fixes, or rolls back
- Agent re-tests success criteria
- Agent asks verification again

---

## 🔄 COMPLETE WORKFLOW EXAMPLE

### TODO-P0-01: Nextcloud Installation

**10:00 AM - Pre-Execution Approval**
```
Agent: "Ready to execute TODO-P0-01: Finish Nextcloud install? Y/N"
You: "Y"
Agent: "Starting execution..."
```

**10:01 AM - Execution (Agent works)**
```
Agent executes:
1. SSH to lady, checks config
2. Creates database
3. Runs web installer
4. Verifies with occ status

Agent documents all commands to /tmp/execution_log_P0-01.txt
Agent takes screenshots of web installer
```

**10:25 AM - Documentation (Agent creates records)**
```
Agent creates:
- /home/qui3tly/personal/memories/TODO_P0_01_2026-02-10.md
- Updates /home/qui3tly/personal/manuals/nextcloud.md
- Updates EXECUTION_TRACKER_2026-02-10.md
```

**10:30 AM - Post-Execution Verification**
```
Agent tests:
✅ occ status: installed: true
✅ Logs clean: no errors in last 10 minutes
✅ Web UI: HTTP 200, login page loads

Agent: "TODO-P0-01 complete. Verification passed? Y/N"
You: [review results]
You: "Y"
Agent: "✅ Marked complete in tracker. Moving to TODO-P0-02..."
```

**Total time:** 30 minutes (25 min execution + 5 min verification)

---

## 📊 YOUR CHECKLIST FOR EACH TODO

### Before Approving (Y):
- [ ] Read TODO item completely
- [ ] Understand what will change
- [ ] Check system ready (services up, dependencies met)
- [ ] Verify you have time to monitor execution
- [ ] Rollback plan acceptable if things go wrong

### After Execution (before verification Y):
- [ ] Memory file created and accurate
- [ ] Project docs updated correctly
- [ ] Execution log shows clean run (no unexpected errors)
- [ ] Success criteria all passed
- [ ] Rollback evidence created (backups, git commits)

### Red Flags (respond N for verification):
- ❌ Success criteria didn't pass
- ❌ Memory file missing or incomplete
- ❌ Docs not updated or have errors
- ❌ Unexpected errors in execution log
- ❌ Rollback evidence not created
- ❌ Service not responding as expected

---

## 🎯 WHAT HAPPENS TO YOUR APPROVALS

### For Triple Agent Verification:

**Verification Agent #1 (Completeness):**
- Checks: Your Y approvals documented
- Checks: Memory files exist for all approved TODOs
- Checks: Project docs updated per your verification Y
- Validates: No TODO marked ✅ without your confirmation

**Verification Agent #2 (Quality):**
- Uses: Your verification Y as confirmation criteria passed
- Samples: 10 random TODOs with your Y approval
- Tests: Commands actually match what you approved
- Validates: Documentation accurate (matches your confirmation)

**Verification Agent #3 (Certification):**
- Reviews: Your Y approvals for critical TODOs
- Validates: Grade improved per approved changes
- Tests: 5 independent checks on Y-approved TODOs
- Final: A+++ certification requires your approval on key items

**Your Y/N decisions are part of the certification evidence.**

---

## 💡 TIPS FOR EFFICIENT APPROVALS

### Batch Related TODOs:
If TODO-P0-01 and TODO-P0-02 are closely related (Nextcloud install + cron guard):
```
Agent: "Ready to execute TODO-P0-01 then TODO-P0-02? Y/N"
You: "Y for both"
Agent: Executes P0-01 → verifies → executes P0-02 → verifies both
```

### Pre-Schedule Approvals:
Morning planning session:
```
You: "I approve P0-01 through P0-07 today, but verify each before moving on"
Agent: Executes each, stops after each for your verification Y
```

### Emergency Stop:
During execution:
```
You: "STOP - Something wrong"
Agent: Pauses immediately, doesn't proceed to next step
You + Agent: Investigate, decide rollback or continue
```

---

## 📞 COMMUNICATION TEMPLATE

### Agent Request (Pre-Execution):
```
Ready to execute TODO-[ID]: [Task Name]?

Quick summary:
- What: [Brief description]
- Why: [Evidence/reason]
- Risk: [Low/Medium/High]
- Time: ~[X] minutes
- Rollback: [Available/Tested]

Your approval: Y/N
```

### Agent Request (Post-Execution):
```
TODO-[ID] complete. Verification:

Success criteria results:
✅ [Criterion 1]: [Result]
✅ [Criterion 2]: [Result]
✅ [Criterion 3]: [Result]

Documentation:
✅ Memory: /path/to/memory/file
✅ Docs updated: /path/to/manual
✅ Tracker: Marked 🔄 → ✅

Verification passed? Y/N
```

### Your Response Templates:
```
Y → Approved, execute now
N → Skip for now, reason: [explain]
N → Postpone to [time], reason: [explain]
N → Issue found: [describe problem]
STOP → Emergency pause, investigate immediately
```

---

## 🚀 EXECUTION SCHEDULE WITH YOUR APPROVALS

### Week 1: Critical & Governance (13 TODOs, ~13 hours)

**Day 1: P0 Critical Fixes (4 hours)**
- 09:00: TODO-P0-01 (Nextcloud install) → You approve Y → 1.5h execution → You verify Y
- 10:30: TODO-P0-02 (Nextcloud cron) → You approve Y → 0.25h execution → You verify Y
- 11:00: TODO-P0-03 (Redis fix) → You approve Y → 0.75h execution → You verify Y
- 12:00: TODO-P0-04 (Dovecot TLS) → You approve Y → 1h execution → You verify Y
- 13:30: TODO-P0-05 (Pihole DB) → You approve Y → 0.75h execution → You verify Y
- 14:30: TODO-P0-06 (Grafana plugin) → You approve Y → 0.5h execution → You verify Y
- 15:15: TODO-P0-07 (Promtail perms) → You approve Y → 0.25h execution → You verify Y

**Day 2-3: P1 Governance (9 hours)**
- P1-01 through P1-12 (similar approval pattern)
- Each TODO: Your Y to start → Execution → Your Y to verify

**Agent pauses between each TODO for your verification Y.**

---

## 📋 YOUR APPROVAL LOG

Track your approvals (agent maintains this):

```
TODO-P0-01: Y approved 2026-02-10 09:00, Y verified 10:30
TODO-P0-02: Y approved 2026-02-10 10:35, Y verified 11:00
TODO-P0-03: Y approved 2026-02-10 11:00, Y verified 12:00
...
TODO-P0-05: N postponed 2026-02-10 13:00 (reason: want to check Pihole backup first)
TODO-P0-05: Y approved 2026-02-10 14:00 (backup confirmed), Y verified 15:00
...
```

**Verification agents will review this log to confirm your approval on all changes.**

---

## ✅ SUCCESS = YOUR APPROVAL + AGENT EXECUTION + VERIFICATION Y

```
YOUR Y (approve)
      ↓
AGENT EXECUTES (documents everything)
      ↓
AGENT CREATES MEMORY + UPDATES DOCS
      ↓
AGENT TESTS SUCCESS CRITERIA
      ↓
YOUR Y (verify)
      ↓
✅ TODO COMPLETE
      ↓
MOVE TO NEXT TODO
```

**After all 34 TODOs:**
```
YOUR 34 Y APPROVALS
YOUR 34 Y VERIFICATIONS
      ↓
TRIPLE AGENT VERIFICATION
      ↓
A+++ CERTIFICATION
```

---

**YOU CONTROL THE PACE.**

**YOU VERIFY THE QUALITY.**

**YOUR APPROVALS = CERTIFICATION EVIDENCE.**

**AGENT EXECUTES. YOU APPROVE. TOGETHER → A+++.**
