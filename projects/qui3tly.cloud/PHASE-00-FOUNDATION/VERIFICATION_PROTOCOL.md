# VERIFICATION PROTOCOL
## Multi-Agent Verification Process for qui3tly.cloud Project

**Document Version**: 1.0  
**Date**: February 15, 2026  
**Purpose**: Define how three-layer verification works for all 9 phases

---

## 1. WHY MULTI-AGENT VERIFICATION?

**Problem with Single Agent**:
- One agent can make mistakes
- Confirmation bias (agent verifies own work)
- Missed errors compound across phases
- User lacks independent quality assurance

**Solution: Three-Layer Verification**:
```
Layer 1: Primary Agent (Lucky Luke)     → Self-verification, execution
Layer 2: External Agent (Independent)   → Independent verification, quality check
Layer 3: User (qui3tly)                → Final approval, control
```

**Benefits**:
- Independent verification catches errors
- User maintains control and visibility
- Evidence-based decision making
- Quality assurance throughout project

**Critical**: No phase proceeds without all 3 layers approving.

---

## 2. THREE-LAYER VERIFICATION MODEL

### Layer 1: Primary Agent Self-Verification

**Role**: Execute and self-verify

**Responsibilities**:
1. Execute all tasks in phase
2. Test functionality (does it work?)
3. Collect evidence (screenshots, logs, test results)
4. Document results in phase README
5. Self-assess completeness
6. Provide deliverables to external agent

**Deliverables Per Phase**:
- Phase README.md (overview, status, results)
- Specific documents (per phase requirements)
- Evidence folder (screenshots, logs, tests)
- EXTERNAL_AGENT_REQUEST.md (what to verify)
- Completion report (summary of work)

**Self-Verification Checklist**:
- [ ] All tasks in TODO complete
- [ ] All deliverables created
- [ ] All services tested (functionality works)
- [ ] Evidence collected (before/after)
- [ ] Documentation accurate
- [ ] No known blocker issues
- [ ] Ready for external verification

**Output**: "Phase XX ready for external verification"

---

### Layer 2: External Agent Independent Verification

**Role**: Independent quality assurance

**Responsibilities**:
1. Review ALL phase deliverables
2. Test functionality INDEPENDENTLY (don't trust, verify)
3. Check against requirements (RFP, MASTER_PLAN)
4. Identify errors, gaps, inconsistencies
5. Grade quality (excellent/good/acceptable/poor)
6. Provide pass/fail/conditional recommendation

**Independence Requirements**:
- ❌ Do NOT collaborate with primary agent
- ❌ Do NOT take direction from primary agent
- ✅ Read deliverables independently
- ✅ Test independently (replicate tests)
- ✅ Report findings to user (not primary agent)
- ✅ Provide honest + objective assessment

**Verification Activities**:
- **Documentation Review**: Read all docs, check completeness
- **Functionality Testing**: Test services/features independently
- **Accuracy Check**: Compare claims to reality
- **Consistency Check**: No contradictions within phase or across phases
- **Requirements Check**: All RFP/MASTER_PLAN requirements met
- **Quality Assessment**: Grade deliverable quality

**Verification Report Format**:
```markdown
# EXTERNAL AGENT VERIFICATION REPORT - PHASE XX

**Date**: [Date]
**Phase**: [Phase Name]
**Verifier**: [External Agent Name]

## 1. DELIVERABLES REVIEW

| Deliverable | Status | Notes |
|-------------|--------|-------|
| [Doc1] | ✅ Complete | [Comments] |
| [Doc2] | ⚠️ Incomplete | [Missing] |

## 2. FUNCTIONALITY TESTING

| Test | Result | Notes |
|------|--------|-------|
| [Test1] | ✅ Pass | [Details] |
| [Test2] | ❌ Fail | [Issue] |

## 3. ISSUES FOUND

### Critical Issues (Block Approval)
- [Issue 1]: [Description, severity, impact]

### Major Issues (Should Fix)
- [Issue 2]: [Description]

### Minor Issues (Nice to Fix)
- [Issue 3]: [Description]

## 4. REQUIREMENTS CHECK

| Requirement | Met? | Notes |
|-------------|------|-------|
| [Req1] | ✅ Yes | [Comment] |
| [Req2] | ❌ No | [Missing] |

## 5. RECOMMENDATION

**Overall Assessment**: [PASS / CONDITIONAL / FAIL]

**Justification**: [Why this recommendation]

**Conditions (if conditional)**:
- [Condition 1]
- [Condition 2]

**If FAIL, Required Fixes**:
- [Critical fix 1]
- [Critical fix 2]

## 6. SUGGESTIONS

[Optional improvements for future]

---

**Verifier**: [External Agent Name]
**Date**: [Date]
**Recommend**: [PASS / CONDITIONAL / FAIL]
```

**Outcomes**:
- **PASS**: All requirements met, no critical issues, recommend approval
- **CONDITIONAL**: Minor issues found, can proceed if fixed
- **FAIL**: Critical issues found, must fix before approval

**Output**: Verification report sent to user

---

### Layer 3: User Final Approval

**Role**: Final authority and decision maker

**Responsibilities**:
1. Review primary agent deliverables
2. Review external agent verification report
3. Test critical functionality (user acceptance)
4. Make final decision: APPROVED / CONDITIONAL / REJECTED
5. Unlock next phase (if approved) or request fixes

**Decision Criteria**:
- Are requirements met? (per RFP, MASTER_PLAN)
- Is external agent satisfied? (PASS or CONDITIONAL)
- Do I trust the quality? (user testing)
- Are risks acceptable? (if any issues remain)

**User Response Format**:
```
PHASE XX: [APPROVED / CONDITIONAL / REJECTED]

Reason: [Brief explanation]

Conditions (if conditional):
- [Required fix 1]
- [Required fix 2]

Next Steps: [Proceed to Phase XX / Fix issues first / Other]

Approval Date: [Date]
```

**Outcomes**:
- **APPROVED**: Phase locked, proceed to next phase
- **CONDITIONAL**: Fix minor issues, then approved (no re-verification)
- **REJECTED**: Critical issues, primary agent fixes, external agent re-verifies

**Output**: Next phase unlocked OR request for fixes

---

## 3. VERIFICATION WORKFLOW

### 3.1 Phase Start → Completion

```
Phase Start
    ↓
Primary Agent: Execute Tasks
    ↓
Primary Agent: Self-Verify
    ↓
Primary Agent: "Phase XX Ready for Verification"
    ↓
    │
    ├──→ External Agent: Review Deliverables
    │        ↓
    │    External Agent: Test Functionality
    │        ↓
    │    External Agent: Check Requirements
    │        ↓
    │    External Agent: Write Verification Report
    │        ↓
    ├──→ External Agent: Send Report to User
    │
    ↓
User: Review Deliverables + Report
    ↓
User: Test Critical Functionality
    ↓
User: Decision
    │
    ├──→ APPROVED: Lock Phase, Unlock Next Phase
    │
    ├──→ CONDITIONAL: Primary Agent Fixes → Auto-Approved
    │
    └──→ REJECTED: Primary Agent Fixes → External Agent Re-Verifies → User Re-Reviews
```

### 3.2 Timeline Per Phase

**Typical Timeline**:
1. Primary agent execution: 1-7 days (depends on phase)
2. External agent verification: 0.5-1.5 hours
3. User review and approval: 0.5-2 hours

**Total per phase**: Execution time + ~2-4 hours for verification

### 3.3 Parallel vs Sequential

**Primary + External Agents**:
- ❌ Do NOT work in parallel (independence required)
- ✅ Sequential: Primary complete → External verify

**Phases**:
- ✅ Some phases can run parallel (after Phase 00, 01)
- Example: Phases 03-06 can run parallel if resources allow

---

## 4. EVIDENCE REQUIREMENTS

### 4.1 What Evidence is Needed?

**Per Phase, Collect**:
- **Before State**: Screenshots, logs, service status BEFORE changes
- **During Execution**: Configuration files, commands run, outputs
- **After State**: Screenshots, logs, service status AFTER changes
- **Test Results**: Test commands, outputs, pass/fail results
- **Verification**: External agent test results

### 4.2 Evidence Format

**Location**: `PHASE-XX-[NAME]/EVIDENCE/`

**Files**:
```
EVIDENCE/
├── before/
│   ├── screenshot-service-404.png
│   ├── docker-ps-output.txt
│   └── error-logs.txt
├── during/
│   ├── config-changes.diff
│   ├── commands-run.sh
│   └── docker-output.txt
├── after/
│   ├── screenshot-service-200.png
│   ├── docker-ps-output.txt
│   └── success-message.txt
└── verification/
    ├── external-agent-tests.txt
    └── verification-report.md
```

### 4.3 Evidence Standards

**Screenshots**:
- Full screen (context visible)
- Timestamp if possible
- Filename descriptive (not "Screenshot1.png")

**Logs**:
- Plain text format (can grep/search)
- Relevant portion (not entire 10GB log)
- Context lines before/after error

**Command Outputs**:
- Include command run (not just output)
- Exit code (success/failure)
- Timestamp

---

## 5. PASS/FAIL/CONDITIONAL CRITERIA

### 5.1 PASS Criteria

**External Agent Recommends PASS When**:
- ✅ All deliverables complete
- ✅ All requirements met (per RFP/MASTER_PLAN)
- ✅ Functionality tested and working
- ✅ Documentation accurate and complete
- ✅ No critical issues found
- ✅ Minor issues (if any) acceptable

**User Approves When**:
- ✅ External agent recommends PASS
- ✅ User testing confirms functionality
- ✅ User satisfied with quality
- ✅ Risks acceptable

**Result**: Phase locked, next phase unlocked

### 5.2 CONDITIONAL Criteria

**External Agent Recommends CONDITIONAL When**:
- ✅ Most requirements met
- ⚠️ Minor issues found (not blocking)
- example: Typo in documentation
- ⚠️ Small gap (easy to fix)
- ✅ Core functionality working
- ⚠️ Quality good but not perfect

**Conditions Must Be**:
- Specific (not vague)
- Achievable quickly (<1 hour fixes)
- Non-blocking (not critical to next phase)

**User Responds**:
- Reviews conditions
- If acceptable: "CONDITIONAL APPROVED - Fix conditions"
- Primary agent fixes
- No re-verification needed (trust fixes or spot-check)

**Result**: Phase locked after fixes, next phase unlocked

### 5.3 FAIL Criteria

**External Agent Recommends FAIL When**:
- ❌ Critical deliverables missing
- ❌ Core functionality broken
- ❌ Requirements not met (major gaps)
- ❌ Critical errors found
- ❌ Documentation inaccurate or incomplete
- ❌ Quality unacceptable

**User Rejects When**:
- ❌ External agent recommends FAIL
- ❌ User testing reveals major issues
- ❌ User not satisfied with deliverables
- ❌ Risks unacceptable

**Process**:
1. User: "PHASE XX REJECTED - Fix [issues]"
2. Primary agent: Fixes issues
3. Primary agent: "Phase XX ready for re-verification"
4. External agent: Re-verifies (full verification again)
5. External agent: New verification report
6. User: Reviews again

**Result**: Phase NOT locked until approved

---

## 6. COMMUNICATION PROTOCOL

### 6.1 Primary Agent → External Agent

**When**: After primary agent completes phase

**Method**: EXTERNAL_AGENT_REQUEST.md file in phase folder

**Content**:
- Phase name and number
- What was done (summary)
- What to verify (specific items)
- How to verify (instructions if needed)
- Where evidence is (folder locations)
- Expected outcome

**Not Allowed**:
- Direct collaboration during execution
- "I think it's good" (external agent tests independently)

### 6.2 External Agent → User

**When**: After external agent completes verification

**Method**: Verification report (markdown file or direct message)

**Content**:
- Deliverables reviewed (checklist)
- Tests performed
- Issues found (critical/major/minor)
- Requirements check
- Pass/fail/conditional recommendation
- Justification

**Not Allowed**:
- Report to primary agent (goes to user)
- Vague assessment ("looks good")

### 6.3 User → Primary Agent

**When**: After user reviews and decides

**Method**: Direct message or project status file

**Content**:
- Decision: APPROVED / CONDITIONAL / REJECTED
- Reason for decision
- Conditions (if conditional) or fixes required (if rejected)
- Next steps

### 6.4 User → External Agent

**When**: If user has questions on verification report

**Method**: Direct message

**Content**:
- Clarification questions
- Request for additional testing
- Disagreement with assessment (rare)

---

## 7. SPECIAL CASES

### 7.1 External Agent Unavailable

**If external agent not available**:
1. User acknowledges delay
2. Wait for external agent (flexible timeline)
3. OR user appoints backup external agent
4. OR user performs external verification role (not ideal but acceptable)

**Not Allowed**: Skip external verification (defeats multi-agent purpose)

### 7.2 Disagreement Between Agents

**If external agent says FAIL but primary agent disagrees**:
1. External agent provides specific evidence
2. Primary agent reviews evidence
3. Three outcomes:
   - Primary agent: "You're right, I'll fix"
   - Primary agent: "Let user decide" → escalate to user
   - External agent: "I made an error" → revise report

**User is Final Arbiter**: User decides based on evidence

### 7.3 Urgent Fix Needed Mid-Phase

**If critical issue discovered mid-phase**:
1. Primary agent: "Pausing phase, critical issue found"
2. Primary agent: Fixes issue immediately
3. Primary agent: Documents fix in phase README
4. Primary agent: Continues phase execution
5. External agent: Verifies fix as part of phase verification

**User Notification**: If critical (impacts availability), notify user immediately

---

## 8. VERIFICATION CHECKLIST (External Agent)

**Per Phase, External Agent Checks**:

### Documentation
- [ ] All required documents present
- [ ] No TBD/TODO in documents
- [ ] Version numbers and dates present
- [ ] Formatting correct (renders properly)
- [ ] Links work (no 404s)
- [ ] Diagrams present and helpful (if required)
- [ ] Content accurate (matches reality)
- [ ] Content complete (all sections)

### Functionality
- [ ] Services accessible (URLs work)
- [ ] Authentication working (if applicable)
- [ ] Core functionality tested (create/read/update/delete)
- [ ] Integration tested (services communicate)
- [ ] Performance acceptable (not slow)

### Requirements
- [ ] RFP requirements met (per phase)
- [ ] MASTER_PLAN deliverables present
- [ ] TODO tasks complete
- [ ] Success criteria met (per phase README)

### Evidence
- [ ] Before/during/after evidence present
- [ ] Test results documented
- [ ] Screenshots clear and relevant
- [ ] Logs show expected results

### Quality
- [ ] No critical errors
- [ ] No major gaps
- [ ] Documentation quality high
- [ ] User will be satisfied

---

## 9. CONTINUOUS IMPROVEMENT

**After Each Phase**:
- What worked well in verification?
- What could be improved?
- Did external agent have enough information?
- Were verification criteria clear?

**After Project**:
- Overall verification effectiveness?
- Errors caught by verification?
- User satisfaction with process?
- Recommendations for future projects?

---

## 10. CONCLUSION

**Three-Layer Verification**:
1. Primary Agent: Execute + self-verify
2. External Agent: Independent verification + recommendation
3. User: Final approval + control

**No Phase Proceeds Without**: All 3 layers approving

**Benefits**:
- Quality assurance throughout
- Errors caught early
- User maintains control
- Evidence-based decisions

**Critical for Success**: Independence of external agent, user final authority

---

**Document Version**: 1.0  
**Prepared By**: Lucky Luke (Primary Agent)  
**Date**: February 15, 2026  
**Status**: Verification protocol defined for Phase 00  
**Next Action**: External agent reviews Phase 00, applies this protocol
