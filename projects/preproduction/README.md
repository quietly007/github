# 🚀 QUI3TLY.CLOUD PREPRODUCTION PLAN
**Project**: B+ (87/100) → A+++ (100/100)  
**Timeline**: 8 weeks (Feb-Mar 2026)  
**Total Investment**: 330-387 hours

---

## 📊 CURRENT STATUS

**Phase 1 Project Audit**: ✅ COMPLETE (2026-01-29)
- **Grade**: B+ (87/100)
- **Location**: `.reports/audits/project/20260129-154914/`
- **56 containers verified** (24 Master + 32 Lady)

**Strengths**:
- ✅ Infrastructure stable (2% disk master, 3% lady)
- ✅ Monitoring operational (Prometheus/Grafana/Loki)
- ✅ Security strong (A-, 14/15 points)
- ✅ Mail system verified (18 Mailcow containers)

**Critical Gaps**:
- ❌ **Office suite missing** (OnlyOffice + Nextcloud integration)
- ❌ **Accounting system missing** (Odoo/ERPNext)
- ❌ **CCTV/NVR missing** (80+ cameras planned)
- ⚠️ **Documentation 10.7%** (6 docs for 56 containers)
- ⚠️ **Security issues** (file permissions, systemd failures)
- ⚠️ **Nextcloud not finalized** (needs OnlyOffice integration)

---

## 📁 PHASE STRUCTURE

### PHASE-00: Planning & Baseline ✅
**Status**: COMPLETE  
**Contents**: Initial planning documents
- Master plan overview
- Phase 1 audit analysis
- Critical actions identified
- 8-week timeline draft

**Location**: `PHASE-00/`

### PHASE-01: Critical Infrastructure Fixes (Week 1)
**Focus**: 🔴 Security + Nextcloud + Foundation  
**Duration**: 10-15 hours  
**Target Grade**: 90/100

**Priority Tasks**:
1. **Security hardening** (2-3h)
   - All secrets → 600 permissions
   - Resolve systemd failures
   - cAdvisor privilege review
2. **Nextcloud finalization + OnlyOffice** (4-6h)
   - Deploy OnlyOffice on Lady (Nextcloud server)
   - Integrate with Nextcloud
   - Test document editing
3. **Service inventory** (2-3h)
   - Document all 56 containers
   - Canonical source of truth
4. **Critical service docs** (4-6h)
   - Authelia, Portainer, Semaphore, Nextcloud
5. **HTTP routing fixes** (30-60min)
   - Fix cloud.quietly.online 502
   - Fix nextcloud.quietly.online 404

**Location**: `PHASE-01/`

### PHASE-02: DNS & Documentation (Week 2)
**Focus**: 🟡 Perfect DNS + Doc ramp-up  
**Duration**: 14-18 hours  
**Target Grade**: 91/100

**Tasks**:
- Execute DNS Audit (audit 02)
- Document 7 more services (30% coverage)
- PTR record for mail server
- DMARC policy setup
- CAA records verification

**Location**: `PHASE-02/`

### PHASE-03: Services Deep-Dive (Weeks 3-4)
**Focus**: 🟡 All services + Performance  
**Duration**: 40-50 hours  
**Target Grade**: 93/100

**Tasks**:
- Services audit (audit 03) - all 56 services
- Log analysis per service
- Performance audit (audit 04) - 40% optimization
- Deploy accounting system (Odoo)

**Location**: `PHASE-03/`

### PHASE-04: Security & Mail Excellence (Week 5)
**Focus**: 🟡 Zero vulnerabilities + Mail perfection  
**Duration**: 18-26 hours  
**Target Grade**: 94/100

**Tasks**:
- Security audit (audit 05)
- Mail audit (audit 06) - >95% deliverability
- CVE scanning
- Secrets verification

**Location**: `PHASE-04/`

### PHASE-05: Monitoring & CCTV (Week 6)
**Focus**: 🟡 100% coverage + Business tools  
**Duration**: 28-42 hours  
**Target Grade**: 96/100

**Tasks**:
- Monitoring audit (audit 07)
- Deploy CCTV/NVR (Frigate/Shinobi)
- DSC Powermanage integration
- Version parity on agents

**Location**: `PHASE-05/`

### PHASE-06: Branding & Polish (Week 7)
**Focus**: 🟡 Unified identity  
**Duration**: 12-16 hours  
**Target Grade**: 98/100

**Tasks**:
- Branding audit (audit 08)
- Apply qui3tly.cloud identity to all services
- 100% documentation coverage

**Location**: `PHASE-06/`

### PHASE-07: Governance & A+++ (Week 8)
**Focus**: 🟡 MANDATORY compliance + Final  
**Duration**: 8-12 hours  
**Target Grade**: 100/100 A+++

**Tasks**:
- Governance audit (audit 09)
- MANDATORY enforcement mechanisms
- Final verification
- Grade assessment

**Location**: `PHASE-07/`

---

## 💡 BETTER SUGGESTION: OnlyOffice Architecture

**Current Plan**: OnlyOffice on Master (standalone)  
**Better Approach**: OnlyOffice on Lady (integrated with Nextcloud)

### Why Better:
✅ **Co-location**: OnlyOffice runs where Nextcloud runs (Lady)  
✅ **Performance**: Lower latency between Nextcloud ↔ OnlyOffice  
✅ **Resource efficiency**: Shared network, no cross-server calls  
✅ **Simpler deployment**: One docker-compose stack  
✅ **Logical grouping**: All "cloud storage + productivity" on one server

### Revised Architecture:
```
LADY SERVER:
├── Nextcloud Stack:
│   ├── nextcloud (app)
│   ├── nextcloud-db (PostgreSQL)
│   ├── nextcloud-redis (cache)
│   └── onlyoffice-documentserver (NEW)
├── Mailcow Stack (18 containers)
└── Monitoring Agents (4)

MASTER SERVER:
├── Monitoring Stack (9)
├── Reverse Proxy & Security (6)
├── Management (4)
└── Network & VPN (3)
```

**Decision**: ✅ Deploy OnlyOffice on Lady, integrated with Nextcloud

---

## 🎯 QUICK START

### Option 1: Begin PHASE-01 (Recommended)
```bash
cd ~/projects/preproduction/PHASE-01/
cat README.md
```

### Option 2: Review Planning (PHASE-00)
```bash
cd ~/projects/preproduction/PHASE-00/
cat README.md
```

### Option 3: Review Full Structure
```bash
cd ~/projects/preproduction/
tree -L 2
```

---

## 📈 GRADE PROGRESSION

| Phase | Week | Focus | Grade Target |
|-------|------|-------|--------------|
| 00 | 0 | Planning | 87/100 (B+) ✅ |
| 01 | 1 | Security + Nextcloud | 90/100 (B++) |
| 02 | 2 | DNS + Docs | 91/100 (A-) |
| 03 | 3-4 | Services + Performance | 93/100 (A) |
| 04 | 5 | Security + Mail | 94/100 (A) |
| 05 | 6 | Monitoring + CCTV | 96/100 (A+) |
| 06 | 7 | Branding | 98/100 (A+) |
| 07 | 8 | Governance | **100/100 (A+++)** 🎉 |

---

## 📚 REFERENCE

### Audit Reports:
- **Phase 1 (Complete)**: `.reports/audits/project/20260129-154914/`
- **Remaining 8 audits**: `personal/audits/02-09_AUDIT_REQUEST_*.md`

### Planning Documents:
- **PHASE-00**: Initial planning (this was the baseline)
- **PHASE-01 to PHASE-07**: Execution phases (to be created)

### Key Decisions:
- ✅ OnlyOffice on Lady (not Master) - better architecture
- ✅ Security issues moved to Week 1 (PHASE-01)
- ✅ Nextcloud finalization in Week 1 (before OnlyOffice)
- ✅ Separate folders per phase for clear organization

---

## 🚀 NEXT STEPS

1. **Review PHASE-00** (planning complete)
2. **Create PHASE-01** (Week 1 execution plan)
3. **Begin PHASE-01 work** (security + Nextcloud + foundation)

**Ready to create PHASE-01?** Let me know and I'll generate the comprehensive Week 1 plan with the revised architecture! 🚀

---

**Last Updated**: 2026-01-29  
**Status**: PHASE-00 complete, ready for PHASE-01
