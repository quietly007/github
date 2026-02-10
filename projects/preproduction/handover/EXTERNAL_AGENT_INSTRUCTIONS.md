# INSTRUCTIONS FOR EXTERNAL AGENT

**Date:** 2026-02-09  
**Location:** `/home/qui3tly/projects/preproduction/handover/`

---

## 📋 YOUR TASK

Review the internal agent's audit reports and provide independent verification.

**Reports to Review:**
1. `COMPREHENSIVE_INFRASTRUCTURE_AUDIT_2026-02-09.md` (37KB - infrastructure detail)
2. `REALITY_CHECK_AUDIT_2026-02-09.md` (17KB - simplification analysis)

---

## 📂 WHERE TO SAVE YOUR REVIEW

**Save your external verification report as:**

```
/home/qui3tly/projects/preproduction/handover/EXTERNAL_AGENT_REVIEW_YYYY-MM-DD.md
```

**Example:**
```
/home/qui3tly/projects/preproduction/handover/EXTERNAL_AGENT_REVIEW_2026-02-10.md
```

---

## 📖 WHAT TO READ FIRST (REQUIRED)

### 1. Project Structure
```bash
/home/qui3tly/projects/preproduction/
├── PHASE-00/  # Planning & baseline
├── PHASE-01/  # Core services
├── PHASE-02/  # Security
├── PHASE-03/  # Monitoring
├── PHASE-04/  # Business apps
├── PHASE-05/  # Advanced monitoring
├── PHASE-06/  # Optimization
├── PHASE-07/  # Governance (incomplete)
├── PHASE-08/  # Final certification (not started)
└── handover/  # (YOU ARE HERE)
```

### 2. Audit Requests (9 total)
```bash
/home/qui3tly/personal/audits/
├── 01_AUDIT_REQUEST_PROJECT.md
├── 02_AUDIT_REQUEST_DNS.md
├── 03_AUDIT_REQUEST_SERVICES.md
├── 04_AUDIT_REQUEST_PERFORMANCE.md
├── 05_AUDIT_REQUEST_SECURITY_PERMISSIONS.md
├── 06_AUDIT_REQUEST_MAIL_SYSTEM.md
├── 07_AUDIT_REQUEST_MONITORING_SYSTEM.md
├── 08_AUDIT_REQUEST_BRANDING_DESIGN.md
└── 09_AUDIT_REQUEST_GOVERNANCE.md
```

### 3. Service Documentation
```bash
/home/qui3tly/personal/manuals/
├── [56 service manuals - all .md files]
```

### 4. Governance & Standards
```bash
/.governance/              # (if exists) Governance framework
/.docs/00-standards/       # Documentation standards
/.copilot/                 # Agent instructions
~/.docker-compose/         # Service configurations
```

---

## 🎯 YOUR REVIEW SCOPE

### VERIFY Internal Agent's Findings:

**1. Infrastructure Audit Accuracy**
- [ ] Verify 60 containers count (24 Master + 36 Lady)
- [ ] Verify 85 violations documented correctly
- [ ] Verify service status (what's running vs stopped)
- [ ] Verify log analysis accuracy
- [ ] Test actual service functionality (don't just trust container status)

**2. Reality Check Accuracy**
- [ ] Verify Master services accessibility (agent claims 0/5 working)
- [ ] Verify Lady services (agent claims only mail + nextcloud working)
- [ ] Verify Prometheus status (agent claims DOWN)
- [ ] Verify complexity vs functionality gap analysis
- [ ] Verify simplification recommendations are valid

**3. Project Scope Verification**
- [ ] Read all 8 PHASE README files
- [ ] Verify PHASE-07 incomplete status
- [ ] Verify PHASE-08 not started
- [ ] Verify A+++ certification requirements (100-point rubric)
- [ ] Calculate actual project grade

**4. Completeness Check**
- [ ] Did internal agent miss anything critical?
- [ ] Are all 9 audit requests addressed?
- [ ] Is governance framework evaluated?
- [ ] Are documentation standards checked?

---

## 📝 YOUR REPORT SHOULD INCLUDE

### Section 1: Internal Agent Audit Verification
- Accuracy rating (% correct)
- Corrections needed (what agent got wrong)
- Missing items (what agent didn't check)

### Section 2: Independent Findings
- Additional violations found
- Additional broken services discovered
- Additional risks identified

### Section 3: User Request Assessment
- Does internal agent's simplification plan meet user intent?
- Is "MAX SIMPLIFICATION" achievable?
- Are recommendations appropriate?

### Section 4: Decision Recommendation
```
[ ] APPROVE: Internal agent audit accurate, proceed with simplification plan
[ ] APPROVE WITH CHANGES: Audit mostly accurate, but modify plan as follows...
[ ] REJECT: Audit incomplete/inaccurate, re-audit required
```

### Section 5: Action Plan
- What to do next (prioritized TODO list)
- What NOT to do (risky actions)
- Timeline recommendation
- Go/No-Go for production

---

## 🔧 TEMPLATE FILE PROVIDED

Use the template file in this same directory:
```
EXTERNAL_AGENT_REVIEW_TEMPLATE.md
```

Copy it and rename with your timestamp, then fill it out.

---

## ⚠️ CRITICAL REMINDERS

**DO:**
- ✅ Read EVERYTHING before reviewing audits
- ✅ Test services independently (don't trust agent's claims)
- ✅ Verify all numbers and statistics
- ✅ Check if user intent understood correctly
- ✅ Provide independent judgment

**DON'T:**
- ❌ Trust internal agent audit without verification
- ❌ Skip reading project phases
- ❌ Make assumptions
- ❌ Execute any changes (READ-ONLY review)

---

## 📞 QUESTIONS?

If anything is unclear, document questions in your review report under:
```
## QUESTIONS FOR USER (qui3tly)
```

User will answer before final decisions made.

---

**SAVE YOUR REVIEW TO:**
`/home/qui3tly/projects/preproduction/handover/EXTERNAL_AGENT_REVIEW_YYYY-MM-DD.md`

**THEN:** Discuss findings with user to decide next steps.
