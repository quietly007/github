# HANDOVER TO AGENT #5

## ⚠️ MANDATORY REQUIREMENT - LOG CHECKING

**USER REQUIREMENT (NON-NEGOTIABLE):**
> "I want that every next agent CHECK LOG!!!! ALLL LOGSSSSS!!!!!! Native services, docker, possible, impossible, lady, master... ALL LOGS!!!!!!!!! MUST BE CHECKED!!!! Without that TASK IS NOT COMPLETED!!!"

**BEFORE writing TODO items, YOU MUST CHECK:**
- ✅ Master native logs: `journalctl -xe --no-pager`, `dmesg`, `/var/log/syslog`
- ✅ Lady native logs: `ssh lady "journalctl -xe --no-pager"`, `ssh lady "dmesg"`
- ✅ Master docker logs: ALL 25 containers
  ```bash
  for container in $(docker ps -a --format '{{.Names}}'); do
    echo "=== $container ==="
    docker logs $container --tail 100 2>&1 | grep -iE 'error|fatal|critical|warn|fail'
  done
  ```
- ✅ Lady docker logs: ALL 36 containers
  ```bash
  ssh lady 'for c in $(docker ps -a --format "{{.Names}}"); do
    echo "=== $c ==="; docker logs $c --tail 100 2>&1 | grep -iE "error|fatal|critical|warn|fail"; done'
  ```
- ✅ Critical services: Traefik access logs, Prometheus metrics, Grafana datasource errors
- ✅ Mailcow logs: All 17 containers in mailcow stack
- ✅ Database logs: MariaDB, PostgreSQL, Redis error logs

**Every TODO item you create MUST be based on actual log evidence.**

**IF YOU DON'T CHECK ALL LOGS → YOUR TASK IS NOT COMPLETED → USER WILL REJECT**

---

## 🚨 YOUR MISSION DEPENDS ON AGENT #4'S DECISION

**Agent #3 Found:** TODO list only 25-30% complete, missing 4 audit categories (DNS, Performance, Mail, Branding)

**Agent #4 Decided:** [Agent #4 will specify: 75 items / 120 items / other]

**Your Mission:** COMPLETE THE TODO LIST per Agent #4's recommendation

## 📋 POSSIBLE SCENARIOS

### Scenario A: Agent #4 Says "75 Items Sufficient"
→ Detail existing 63 outlined items (TODO-013 to TODO-075)
→ Time: 7-10 hours
→ Deliverable: 75 items fully detailed

### Scenario B: Agent #4 Says "Expand to ~120 Items"
→ Add ~45 new items covering DNS, Performance, Mail, Branding gaps
→ Detail all 63 existing outlined items
→ Time: 15-20 hours
→ Deliverable: 120 items fully detailed

### Scenario C: Agent #4 Says "Compromise at 90-100 Items"
→ Add ~15-25 critical items only
→ Detail all 63 existing outlined items
→ Time: 10-15 hours
→ Deliverable: 90-100 items fully detailed

## 📖 READ THESE IN ORDER

1. `/home/qui3tly/projects/preproduction/handover/FOURTH_AGENT_VERIFICATION_2026-02-10.md` **(START HERE - Agent #4's decision)**
2. `/home/qui3tly/projects/preproduction/handover/AGENT_5_INSTRUCTIONS.md` (your detailed instructions)
3. `/home/qui3tly/projects/preproduction/handover/THIRD_AGENT_VERIFICATION_2026-02-10.md` (Agent #3's gap analysis)
4. `/home/qui3tly/projects/preproduction/handover/COMPREHENSIVE_TODO_LIST_2026-02-09.md` (current 75-item TODO)

## ✅ REQUIREMENTS FOR EVERY TODO ITEM

**Whether 75, 90, or 120 items, EVERY item needs:**
- ✅ Current state description (actual verification output)
- ✅ **Log evidence** (actual error from logs that proves issue exists)
- ✅ Exact bash commands with expected outputs (copy-pasteable)
- ✅ Success criteria (measurable, objective)
- ✅ Rollback plan (how to undo if fails)
- ✅ Time estimate (realistic)
- ✅ Dependencies (what must be done first)

**Example with log evidence:**
```markdown
TODO-XXX: Fix HomeAssistant EOFError

Log Evidence:
  $ docker logs homeassistant --tail 50 | grep -i error
  2026-02-09 18:23:15 ERROR (MainThread) [homeassistant.core] Error doing job: Task exception was never retrieved
  Traceback (most recent call last):
    File "/usr/src/homeassistant/homeassistant/components/recorder/core.py", line 345, in _async_commit
      await self._async_commit_database()
  EOFError: [Errno 104] Connection reset by peer

Current State: HomeAssistant logging EOFError every 2-5 minutes
Steps: [fix commands]
Success Criteria: No EOFError in logs for 1 hour
Rollback: [restore commands]
```

## 🎯 YOUR DELIVERABLE

**File:** `COMPLETE_TODO_LIST_2026-02-10.md`

**Size:** 
- If 75 items: 80-100KB
- If 120 items: 120-150KB
- If 90-100 items: 100-130KB

**Must Include:**
- All items fully detailed (no outlines, no placeholders)
- A+++ grade trajectory calculation (current 59/100 → target 98-100/100)
- Execution sequence with dependencies
- Risk mitigation plan
- Time estimates (realistic, verified)

## 📊 CONTEXT

**Current State:**
- Infrastructure grade: 59/100 (D+) per Agent #3
- A+++ target: 98-100/100
- Gap: 39-41 points to close
- Current TODO: 12/75 detailed (16%), 63/75 outlined (84%)

**User Demands:**
> "I want complete and detailed NO FAIL TODO list with A+++ result!!!"

**Translation:**
- Complete = covers ALL requirements (not 25-30%)
- Detailed = exact commands, not outlines
- NO FAIL = rollback plans, risk mitigation
- A+++ result = achievable 98-100/100

## ⚠️ CRITICAL

**This is NOT verification. This is COMPLETION.**

Four agents before you verified, analyzed, audited... but NONE completed the TODO list.

**You are the completion specialist. Your ONLY job: Make the TODO list COMPLETE.**

**Agent #6 will verify your work before execution begins.**

**All Documents Attached:** `/home/qui3tly/projects/preproduction/handover/`

**GO.**
