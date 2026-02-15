# MULTI-AGENT QUALITY VERIFICATION WORKFLOW
## qui3tly.cloud - Universal Agent Coordination Protocol

**Applies To**: ALL PHASES (Phase 00, Phase 01, Phase 02, ... Phase N)  
**Goal**: Achieve A+++ grade (90+/100) through iterative agent reviews  
**Final Authority**: User (qui3tly) - Phase complete ONLY when user verifies

---

## 🔄 AGENT CHAIN PROCESS

```
User Request
    ↓
Agent 1 (Initial work, Grade X/100)
    ↓
Creates AGENT2_HANDOVER.md
    ↓
👤 USER VERIFIES HANDOVER ← REQUIRED!
    ↓
Agent 2 works in AGENT2/ folder
    ↓
Creates AGENT2/AGENT3_HANDOVER.md
    ↓
👤 USER VERIFIES HANDOVER ← REQUIRED!
    ↓
Agent 3 works in AGENT3/ folder
    ↓
Creates AGENT3/AGENT4_HANDOVER.md
    ↓
👤 USER VERIFIES HANDOVER ← REQUIRED!
    ↓
[Continue until A+++ achieved]
    ↓
Final Agent creates USER_VERIFICATION.md
    ↓
👤 USER APPROVES ENTIRE PHASE ✅ ("Phase XX is done!")
    ↓
Agent 1 RETURNS → Consolidates ALL agent work
    ↓
Creates ONE simple consolidated folder
    ↓
Updates ALL project documentation
    ↓
Phase XX Complete → Ready for Phase XX+1
```

---

## 📋 UNIVERSAL RULES (ALL AGENTS, ALL PHASES)

### Rule 0: STRICT FILE MODIFICATION LIMITS
🚨 **AGENTS CAN ONLY MODIFY THEIR OWN FILES - NOTHING ELSE!**

**CRITICAL - NO EXCEPTIONS**:
- ❌ **CANNOT modify previous agents' files** (AGENT1/, AGENT2/, AGENT3/ work)
- ❌ **CANNOT modify phase root files** (unless you are Agent 1 during initial work)
- ❌ **CANNOT modify project-level files** (README.md, AGENT_WORKFLOW.md, etc.)
- ❌ **CANNOT modify other phases** (PHASE-01/, PHASE-02/, etc.)
- ❌ **CANNOT modify personal/ documentation** (personal/NOTES.md, cheatsheets/, etc.)
- ✅ **CAN ONLY modify files in YOUR agent folder** (AGENTN/ where N = your number)

**What You CAN Modify**:
```
PHASE-XX-NAME/AGENTN/          ← YOUR folder only!
├── CHANGELOG.md               ← You create/edit this
├── AUDIT_REPORT.md            ← You create/edit this
├── EVIDENCE/                  ← You create/edit files here
│   └── [your evidence files]
└── AGENT[N+1]_HANDOVER.md     ← You create this
```

**What You CANNOT Modify Without Explicit User Approval**:
```
❌ PHASE-XX-NAME/               ← Phase root (Agent 1 initial work)
   ├── *.md                     ← NOT yours to change!
   ├── DIAGRAMS/                ← NOT yours to change!
   └── EVIDENCE/                ← NOT yours to change!

❌ PHASE-XX-NAME/AGENT2/        ← Agent 2's work (if you are Agent 3)
   └── [all files]              ← NOT yours to change!

❌ ~/projects/qui3tly.cloud/    ← Project root
   ├── README.md                ← NOT yours to change!
   ├── AGENT_WORKFLOW.md        ← NOT yours to change!
   └── [anything here]          ← NOT yours to change!

❌ personal/                    ← User's personal docs
   └── [anything]               ← NOT yours to change!
```

**Why This Rule Exists**:
- Preserves audit trail (each agent's work stays intact)
- Prevents corruption of previous verified work
- Clear accountability (who changed what)
- User can verify each agent independently

**If You Need to Change Something Outside Your Folder**:
1. Document the need in your AUDIT_REPORT.md
2. Explain why the change is necessary
3. Provide exact change recommendation
4. Request user approval in your handover
5. **DO NOT make the change yourself**
6. User will decide and make change if approved

**Violation = Immediate Rejection**:
- User will REJECT your handover
- You must undo unauthorized changes
- Resubmit clean work in your folder only

---

### Rule 1: Isolated Work Folders
✅ **Each agent works in SEPARATE folder**
```
PHASE-XX-NAME/
├── [Agent 1 work here in root]
├── AGENT2/                    ← Agent 2 isolated folder
│   ├── [Agent 2 reports]
│   ├── [Agent 2 evidence]
│   └── AGENT3_HANDOVER.md     ← REQUIRED!
├── AGENT3/                    ← Agent 3 isolated folder
│   ├── [Agent 3 reports]
│   ├── [Agent 3 evidence]
│   └── AGENT4_HANDOVER.md     ← REQUIRED if grade < 90
└── AGENT4/                    ← Agent 4 isolated folder (if needed)
    └── [continues...]
```

**Why**: Track progress, prevent overwriting, clear ownership

### Rule 2: Mandatory Handover Documents
✅ **Every agent MUST create handover for next agent**

**Handover Template**:
```markdown
# AGENTX_HANDOVER.md
**From**: Agent [N]
**To**: Agent [N+1]
**Date**: [Date]
**Current Grade**: X/100 (after my work)
**Target Grade**: Y/100 (for next agent)
**User Verification**: ⏳ PENDING (Agent N+1 cannot start until user approves)

---

## MY DELIVERABLES

**Work Folder**: AGENT[N]/ (if Agent 2+) or phase root (if Agent 1)

**Files Created**:
- ✅ CHANGELOG.md - My changes log
- ✅ AUDIT_REPORT.md - My detailed findings
- ✅ EVIDENCE/ - Proof of my claims
- ✅ [other files...]

**What I Completed**:
1. [Task 1 with evidence]
2. [Task 2 with evidence]
3. [Task 3 with evidence]

**Grade Evolution**: [Previous grade] → [My grade]

---

## NEXT AGENT MISSION

**Agent [N+1] Goals**:
1. [Clear goal 1]
2. [Clear goal 2]
3. [Clear goal 3]

**Your Work Folder**: PHASE-XX-NAME/AGENT[N+1]/

**Your Mandatory Deliverables**:
- AGENT[N+1]/CHANGELOG.md
- AGENT[N+1]/AUDIT_REPORT.md
- AGENT[N+1]/EVIDENCE/
- AGENT[N+1]/AGENT[N+2]_HANDOVER.md (if grade < 90)

---

## VERIFICATION COMMANDS

**How to verify my work**:
```bash
[Command 1 to verify claim 1]
[Command 2 to verify claim 2]
```

---

## USER: PLEASE VERIFY

**Review My Work**:
1. Read AGENT[N]/AUDIT_REPORT.md
2. Check AGENT[N]/EVIDENCE/ for proof
3. Run verification commands above
4. Review AGENT[N]/CHANGELOG.md

**Approve or Reject**:
- ✅ APPROVE → Agent [N+1] can start
- ❌ REJECT → I will fix issues

**Agent [N+1] Status**: ⏳ BLOCKED until user approves this handover
```

### Rule 3: User Verification Gates
✅ **USER MUST VERIFY EACH HANDOVER + FINAL PHASE**

**Two Types of User Verification**:

1. **Handover Verification** (after each agent):
   - Agent completes work
   - Agent creates AGENT[X+1]_HANDOVER.md
   - **USER REVIEWS HANDOVER** ← Agent X+1 cannot start until approved!
   - User approves → Next agent starts
   - User rejects → Current agent fixes issues

2. **Phase Verification** (when A+++ achieved):
   - Final agent completes work
   - Creates FINAL_VERIFICATION.md (not another handover)
   - **USER REVIEWS ENTIRE PHASE** 
   - User approves → Phase complete, next phase begins
   - User rejects → Another agent iteration

**Critical**: No agent starts work until user approves previous handover!

### Rule 4: Grade-Based Continuation
✅ **Agent chain continues until A+++ (90+/100)**

| Grade | Action |
|-------|--------|
| < 70/100 (C-) | Agent N+1 required, major work needed |
| 70-79/100 (C) | Agent N+1 required, significant improvements |
| 80-89/100 (B) | Agent N+1 required, polish needed |
| 90-94/100 (A) | Agent N+1 optional, user decides |
| 95-100/100 (A+++) | Ready for user verification |

**Final Agent**: Creates `USER_VERIFICATION.md` instead of next handover

### Rule 5: Folder Structure Standards
✅ **Every agent folder MUST contain these files**:

```
AGENTX/                          ← Your isolated work folder
├── CHANGELOG.md                 ← REQUIRED: Your changes log
├── AUDIT_REPORT.md              ← REQUIRED: Your detailed audit findings
├── VERIFICATION_REPORT.md       - What you verified from previous agent
├── CORRECTIONS_APPLIED.md       - What you fixed
├── EVIDENCE/                    ← REQUIRED: Command outputs, logs, configs
│   └── [verification evidence]
├── CORRECTED_FILES/             - Updated versions (if any)
│   └── [v2.X files]
└── AGENT[X+1]_HANDOVER.md       ← REQUIRED: Next agent brief
```

**Mandatory Files** (every agent must create):
1. **CHANGELOG.md** - Chronological list of all changes you made
2. **AUDIT_REPORT.md** - Detailed findings, analysis, recommendations
3. **EVIDENCE/** - Proof of your claims (command outputs, screenshots)
4. **AGENT[X+1]_HANDOVER.md** - Mission brief for next agent

**Optional Files** (create if applicable):
- VERIFICATION_REPORT.md - If verifying previous agent
- CORRECTIONS_APPLIED.md - If fixing errors
- CORRECTED_FILES/ - If updating files

### Rule 6: Clean Error Logs Mandatory
✅ **NO AGENT CAN CLAIM COMPLETION UNTIL LOGS HAVE NO ERRORS**

**CRITICAL DEFINITION**:
- **"CLEAN" = NO ERRORS EXIST** in logs (not "file deleted")
- error_logs_after.txt MUST exist but be EMPTY (0 lines, 0 bytes)
- Empty file proves: You ran error check, found ZERO errors
- Infrastructure must be ERROR-FREE before handover

**Before You Start**:
```bash
# Capture baseline errors
for container in $(docker ps --format "{{.Names}}"); do
  docker logs $container --tail 100 2>&1 | grep -i "error\|fatal\|critical"
done > AGENTN/EVIDENCE/error_logs_before.txt

# This file will have content if errors exist
wc -l AGENTN/EVIDENCE/error_logs_before.txt
```

**During Your Work**:
- FIX every error at its root cause (don't just restart containers)
- Fix configs, patch bugs, resolve dependencies
- Document every fix in CHANGELOG.md
- Re-run error checks after each fix to verify resolved

**Before Handover**:
```bash
# Verify ALL errors are resolved
for container in $(docker ps --format "{{.Names}}"); do
  docker logs $container --tail 100 2>&1 | grep -i "error\|fatal\|critical"
done > AGENTN/EVIDENCE/error_logs_after.txt

# This file MUST be empty (0 lines)
wc -l AGENTN/EVIDENCE/error_logs_after.txt
# Output: 0 AGENTN/EVIDENCE/error_logs_after.txt

# If > 0: You have unfixed errors, cannot create handover yet!
```

**Success Criteria**:
- ✅ error_logs_after.txt exists (proves you ran the check)
- ✅ error_logs_after.txt is EMPTY (proves no errors found)
- ✅ wc -l returns: "0 error_logs_after.txt"
- ✅ All services run WITHOUT errors/fatal/critical messages
- ✅ CHANGELOG.md documents root cause + fix for each error
- ❌ File has content = Infrastructure has errors = Handover REJECTED

**NOT Acceptable**:
- ❌ Deleting error_logs_after.txt (must exist as proof)
- ❌ Ignoring errors ("they're not important")
- ❌ Just restarting containers without fixing root cause
- ❌ Claiming "done" while logs still show errors
- ❌ Touching/truncating log files to hide errors

**If Errors Cannot Be Fixed**: Document in CHANGELOG + AUDIT_REPORT:
- Why unfixable (3rd party service down, upstream bug)
- Evidence of fix attempts made
- Request user approval for exception
- Get user decision before claiming completion

---

## 📊 PHASE PROGRESSION MODEL

### Phase Structure (Universal)
```
PHASE-00-FOUNDATION/            Phase 01, 02, 03... follow same pattern
├── [Agent 1 initial work]
├── AGENT2/
│   └── AGENT3_HANDOVER.md
├── AGENT3/
│   └── AGENT4_HANDOVER.md
├── AGENT4/
│   └── [USER_VERIFICATION.md or AGENT5_HANDOVER.md]
└── [continues until user approves]
```

### Grade Evolution Example
```
Agent 1: 72/100 (C+)  → needs improvement
Agent 2: 85/100 (B+)  → better, but not A+++
Agent 3: 93/100 (A++) → close to target
Agent 4: 97/100 (A+++) → ready for user verification
User: ✅ APPROVED → Phase complete
```

---

## 🎯 WHAT EACH AGENT DOES

### Agent 1 (Initial + Phase Consolidator)

**AT PHASE START** (Initial Work):
- Complete initial work (audit, implementation, analysis)
- Document baseline state
- Create **AGENT2_HANDOVER.md** in phase root
- Self-grade work honestly
- Hand off to Agent 2 (via user verification)

**AFTER ENTIRE PHASE APPROVED** (Consolidation Work):

⚠️ **CRITICAL**: Agent 1 does NOT consolidate after each agent!

**Trigger**: User states **"Phase XX is done!"** (after ALL agents finished + user verified entire phase)

**Agent 1 Returns to Consolidate**:

1. **Read All Agent Work**:
   - AGENT2/CHANGELOG.md, AUDIT_REPORT.md, EVIDENCE/
   - AGENT3/CHANGELOG.md, AUDIT_REPORT.md, EVIDENCE/
   - AGENT4/... (all agents involved)
   - All handover documents

2. **Create ONE Consolidated Folder** (PHASE-XX-CONSOLIDATED/):
   ```
   PHASE-XX-CONSOLIDATED/              ← Simple, clean folder
   ├── FINAL_REPORT.md                 ← All findings merged
   ├── COMPLETE_CHANGELOG.md           ← All changes chronologically
   ├── KEY_EVIDENCE/                   ← Critical proof only
   │   └── [essential files]
   ├── LESSONS_LEARNED.md              ← What we learned
   └── PHASE_SUMMARY.md                ← Executive summary
   ```

3. **Update Project Documentation**:
   - ~/projects/qui3tly.cloud/README.md (mark Phase XX ✅ complete)
   - PHASE-XX-NAME/README.md (phase summary)
   - Update phase status tracking

4. **Update Personal Documentation** (personal/):
   - personal/NOTES.md (key learnings)
   - personal/cheatsheets/ (new procedures)
   - personal/howto/ (new guides)
   - personal/manuals/ (service updates)
   - personal/audits/ (consolidated findings)

5. **Archive Agent Work Folders** (optional cleanup):
   - Keep AGENT2/, AGENT3/, AGENT4/ if needed for reference
   - OR archive them (compress to AGENT_WORK_ARCHIVE.tar.gz)
   - Result: Clean phase folder without 96 scattered agent folders

6. **Prepare Next Phase**:
   - Verify PHASE-XX+1/ exists and is ready
   - Copy forward any required baselines
   - Update project roadmap

**Result**: Clean, simple documentation ready for next phase!

**NOT Acceptable**:
- ❌ Consolidating after Agent 2 (too early!)
- ❌ Consolidating after Agent 3 (still too early!)
- ❌ Leaving 96 agent folders scattered everywhere
- ❌ Complex nested documentation structure

**Success = ONE simple consolidated folder + updated docs**

### Agent 2 (Secondary)
- Work in **AGENT2/** folder **ONLY**
- **DO NOT modify Agent 1's files or phase root files**
- **Capture error logs BEFORE starting** (baseline)
- Create **AGENT2/CHANGELOG.md** (document every change)
- Create **AGENT2/AUDIT_REPORT.md** (comprehensive findings)
- Verify Agent 1's claims (READ only, document issues in YOUR report)
- **Fix ALL errors found in logs** (document in YOUR folder)
- Deep dive analysis (results in YOUR folder)
- **Verify error logs are CLEAN before handover**
- Create **AGENT2/AGENT3_HANDOVER.md** (next agent mission)
- **If you find errors in Agent 1's work**: Document in YOUR audit report, recommend fixes to user, DO NOT edit Agent 1's files
- **Notify user when handover ready for verification**

### Agent 3+ (Quality Iterations)
- Work in **AGENT3/** folder **ONLY** (or AGENT4/, AGENT5/, etc.)
- **DO NOT modify previous agents' folders** (AGENT1/, AGENT2/, etc.)
- **Capture error logs BEFORE starting** (baseline)
- Create **AGENT[N]/CHANGELOG.md** (document every change in YOUR folder)
- Create **AGENT[N]/AUDIT_REPORT.md** (comprehensive findings)
- Verify previous agents' work (READ only, document issues in YOUR report)
- **Fix ALL errors found in logs** (document fixes in YOUR folder)
- Polish and improve (YOUR analysis in YOUR folder)
- Fill gaps (YOUR contributions in YOUR folder)
- **Verify error logs are CLEAN before handover**
- Create **AGENT[N]/AGENT[N+1]_HANDOVER.md** OR **USER_VERIFICATION.md**
- **If you find errors in previous work**: Document in YOUR audit report, recommend fixes, DO NOT edit their files
- **Notify user when handover ready for verification**

### Final Agent (Before User)
- Work in **AGENT[N]/** folder
- Create **AGENT[N]/CHANGELOG.md** (document every change)
- Create **AGENT[N]/AUDIT_REPORT.md** (comprehensive findings)
- Achieve A+++ grade (90+/100)
- Create **USER_VERIFICATION.md** (not next handover)
- **Notify user for final phase approval**

---

## 📚 PHASE COMPLETION & DOCUMENTATION CONSOLIDATION

**After User Approves Entire Phase**:

### When Consolidation Happens

**NOT After**:
- ❌ Agent 2 finishes → NO consolidation yet
- ❌ Agent 3 finishes → NO consolidation yet  
- ❌ Agent 4 finishes → NO consolidation yet

**YES After**:
- ✅ Final agent achieves A+++ (90+/100)
- ✅ Final agent creates USER_VERIFICATION.md
- ✅ User reviews ENTIRE phase (all agent work)
- ✅ **User explicitly states: "Phase XX is done!"**
- ✅ THEN Agent 1 returns to consolidate

### Agent 1 Consolidation Process

**Step 1: Gather All Agent Work**
- Read every AGENT[N]/CHANGELOG.md
- Read every AGENT[N]/AUDIT_REPORT.md
- Review all EVIDENCE/ folders
- Read all handover documents
- Understand complete phase journey

**Step 2: Create Simple Consolidated Documentation**

Create ONE folder: `PHASE-XX-CONSOLIDATED/`

```
PHASE-XX-CONSOLIDATED/
├── FINAL_REPORT.md              ← Merged findings from all agents
│   ├── Phase objectives
│   ├── Work performed (Agent 1, 2, 3, 4...)
│   ├── Issues found and fixed
│   ├── Final grade: A+++ (9X/100)
│   └── Recommendations for next phase
│
├── COMPLETE_CHANGELOG.md        ← Chronological ALL changes
│   ├── [Date] Agent 1: [changes]
│   ├── [Date] Agent 2: [changes]
│   ├── [Date] Agent 3: [changes]
│   └── [Date] Agent 4: [changes]
│
├── KEY_EVIDENCE/                ← Essential proof only
│   ├── error_logs_before.txt (Phase start baseline)
│   ├── error_logs_after.txt (Phase end - clean!)
│   ├── critical_configs.txt
│   └── [other key evidence]
│
├── LESSONS_LEARNED.md           ← What we learned this phase
│   ├── What worked well
│   ├── What didn't work
│   ├── Process improvements
│   └── Apply to next phase
│
└── PHASE_SUMMARY.md             ← Executive summary (1-2 pages)
    ├── Phase XX goals
    ├── Agents involved: 1, 2, 3, 4
    ├── Key achievements
    ├── Grade: 72/100 → 97/100 (A+++)
    └── Ready for Phase XX+1
```

**Step 3: Update All Project Documentation**

```bash
# Update project README
~/projects/qui3tly.cloud/README.md
- Mark Phase XX: ✅ COMPLETE (9X/100)
- Update progress tracking

# Update phase README  
PHASE-XX-NAME/README.md
- Add completion date
- Link to PHASE-XX-CONSOLIDATED/
- Final grade and summary

# Update personal documentation
personal/NOTES.md               ← Key learnings
personal/cheatsheets/           ← New commands/procedures
personal/howto/                 ← New guides created
personal/manuals/               ← Updated service docs
personal/audits/                ← Consolidated audit findings
```

**Step 4: Clean Up Agent Folders (Optional)**

```bash
# Option 1: Archive agent work folders
cd PHASE-XX-NAME/
tar -czf AGENT_WORK_ARCHIVE.tar.gz AGENT2/ AGENT3/ AGENT4/
rm -rf AGENT2/ AGENT3/ AGENT4/

# Option 2: Keep for reference (if needed)
# Leave AGENT2/, AGENT3/, AGENT4/ as-is

# Result: No 96 scattered agent folders cluttering workspace!
```

**Step 5: Prepare Next Phase**

```bash
# Verify next phase exists
ls ~/projects/qui3tly.cloud/PHASE-XX+1/

# Create transition document
PHASE-XX-TO-XX+1-TRANSITION.md
```

**Step 6: Notify User**

"Phase XX consolidation complete! All documentation updated. Ready for Phase XX+1."

### Consolidation Success Criteria

- ✅ ONE simple PHASE-XX-CONSOLIDATED/ folder created
- ✅ All agent work merged into clean, readable docs
- ✅ Project README updated (Phase XX marked complete)
- ✅ Personal documentation updated
- ✅ Agent folders archived or organized (not 96 scattered folders)
- ✅ Phase XX+1 prepared and ready
- ✅ User approves consolidation work

### What Gets Consolidated

**From Multiple Agents** → **To Simple Docs**:

```
AGENT2/CHANGELOG.md (47 changes)
AGENT3/CHANGELOG.md (23 changes)     →  COMPLETE_CHANGELOG.md (70 changes total)
AGENT4/CHANGELOG.md (0 changes)

AGENT2/AUDIT_REPORT.md (34 pages)
AGENT3/AUDIT_REPORT.md (28 pages)   →  FINAL_REPORT.md (focus on key findings)
AGENT4/AUDIT_REPORT.md (12 pages)

AGENT2/EVIDENCE/ (156 files)
AGENT3/EVIDENCE/ (89 files)          →  KEY_EVIDENCE/ (20 critical files)
AGENT4/EVIDENCE/ (34 files)
```

**Result**: Clean, consolidated, simple documentation!

---

### User (Final Authority)
- **Review every agent handover before next agent starts**
- Verify 3 mandatory files in each AGENT[N]/ folder:
  1. CHANGELOG.md
  2. AUDIT_REPORT.md  
  3. AGENT[N+1]_HANDOVER.md
- Check EVIDENCE/ folder for proof
- **CRITICAL: Verify agent stayed in their folder**
  - Check agent did NOT modify previous agents' work
  - Check agent did NOT modify project-level files
  - Check agent did NOT modify anything without approval
  - Any unauthorized modifications = IMMEDIATE REJECTION
- **CRITICAL: Verify Infrastructure is ERROR-FREE**
  - Check error_logs_after.txt EXISTS and is EMPTY (0 lines)
  - Empty file = No errors found when agent ran final check
  - File has content = Infrastructure still has errors = REJECT
  - Agent must FIX errors at root cause, not hide them
  - Any unresolved errors without approved exception = REJECT handover
- **Per-Handover Decision**:
  - APPROVE HANDOVER → Agent N+1 can start
  - REQUEST CHANGES → Agent N fixes, resubmits (in their folder only!)
  - REJECT → Agent N revises work
- **Final Phase Decision**:
  - APPROVE PHASE → Phase complete, proceed to next phase
  - CONTINUE ITERATION → Request Agent N+1

---

## 📝 HANDOVER DOCUMENT CHAIN

**Location Pattern**:
```
PHASE-XX-NAME/
├── AGENT2_HANDOVER.md              ← Agent 1 creates (in root)
├── AGENT2/
│   └── AGENT3_HANDOVER.md          ← Agent 2 creates (in AGENT2/)
├── AGENT3/
│   └── AGENT4_HANDOVER.md          ← Agent 3 creates (in AGENT3/)
└── AGENT4/
    └── USER_VERIFICATION.md        ← Final agent creates (if A+++ achieved)
```

**Each handover contains**:
1. What previous agent completed
2. What next agent must do
3. Where to work (folder path)
4. How to verify previous work
5. Evidence of current grade
6. Target grade for next agent

---

## ✅ SUCCESS CRITERIA

### Agent Success
- ✅ Work completed in isolated folder
- ✅ All deliverables present
- ✅ Evidence documented
- ✅ Next handover created (if grade < 90)
- ✅ Grade improved from previous agent

### Phase Success
- ✅ Final grade A+++ (90+/100)
- ✅ All agent folders present
- ✅ Complete handover chain documented
- ✅ USER VERIFIES AND APPROVES ← **MOST IMPORTANT**
- ✅ Ready for next phase

### Project Success
- ✅ All phases completed (Phase 00 → Phase N)
- ✅ Each phase has agent chain + user approval
- ✅ Documentation complete and accurate
- ✅ Infrastructure stable and optimized
- ✅ User satisfied with quality

---

## 🚨 CRITICAL REMINDERS

### For ALL Agents
1. ⚠️ **DO NOT** modify ANY files outside YOUR agent folder - FORBIDDEN!
2. ⚠️ **DO NOT** change previous agents' work - audit trail must stay intact
3. ⚠️ **DO NOT** edit project-level files (README.md, AGENT_WORKFLOW.md, etc.)
4. ⚠️ **DO NOT** declare phase complete - only user can
5. ⚠️ **DO NOT** work in previous agent's folder - stay isolated
6. ⚠️ **DO NOT** skip handover creation - it's mandatory
7. ⚠️ **DO NOT** assume user approves automatically
8. ⚠️ **DO** work ONLY in YOUR folder (AGENTN/ where N = your number)
9. ⚠️ **DO** be honest about grade - quality matters
10. ⚠️ **DO** create thorough handovers - next agent depends on you
11. ⚠️ **DO** preserve all previous work - don't delete anything
12. ⚠️ **DO** request user approval for ANY changes outside your folder

### For User
1. ✅ Review each agent folder systematically
2. ✅ Verify claims with evidence in EVIDENCE/ folders
3. ✅ Request Agent N+1 if quality insufficient
4. ✅ Approve only when truly satisfied
5. ✅ Phase complete = user approval, not agent declaration

---

## 📖 EXAMPLE: Phase 00 Foundation

**Current State**:
```
Agent 1 (Lucky Luke): 72/100 (C+)
├── Initial audit complete
├── Hardware specs corrected
├── Created AGENT2_HANDOVER.md
└── Waiting for Agent 2

Agent 2: Not started
├── Will work in AGENT2/
├── Target: 95/100 (A++)
├── Must create AGENT3_HANDOVER.md
└── Must verify + deep dive

Agent 3+: TBD based on Agent 2 grade
└── Continue until A+++ (90+/100)

User Verification: After A+++ achieved
└── Phase 00 complete ONLY when user approves
```

**Handover Chain**:
```
AGENT2_HANDOVER.md (exists) ✅
→ Agent 2 works
→ AGENT2/AGENT3_HANDOVER.md (Agent 2 creates)
→ Agent 3 works
→ AGENT3/[AGENT4_HANDOVER.md OR USER_VERIFICATION.md]
→ [Continue or submit to user]
→ User reviews
→ User approves ✅
→ Phase 00 complete
→ Phase 01 begins (with same agent workflow)
```

---

## 🔄 APPLIES TO ALL PHASES

This workflow is **UNIVERSAL**:
- Phase 00: Foundation audit
- Phase 01: Infrastructure improvements
- Phase 02: Service optimization
- Phase 03: Security hardening
- Phase N: Whatever comes next

**Same rules every time**:
1. Agent 1 → initial work → AGENT2_HANDOVER.md
2. Agent 2+ → isolated folders → next handover
3. Continue until A+++ (90+/100)
4. User verifies → Phase complete
5. Repeat for next phase

---

**Every agent must understand**: 
- Your work = isolated folder
- Your responsibility = next handover
- Phase done = only when USER verifies
- Goal = A+++ through agent collaboration

**User gets**: Handover #2, #3, #4... until handover says "A+++ achieved, ready for your verification"
