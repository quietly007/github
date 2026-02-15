# REQUEST FOR PROPOSAL (RFP)
## qui3tly.cloud Infrastructure Project - Complete Reboot

**Document Version**: 1.0  
**Date**: February 15, 2026  
**Prepared By**: Lucky Luke (Primary Agent) & qui3tly  
**Project Name**: qui3tly.cloud Production Readiness Project  
**Project Code**: QC-2026-REBOOT

---

## 1. EXECUTIVE SUMMARY

qui3tly.cloud operates a production infrastructure of 64 containers across 2 VPS servers in Germany (Contabo), providing managed infrastructure, email hosting, VPN solutions, cloud storage, and business applications to clients.

**Current State**: Infrastructure is functional (72/100 grade) with solid technical foundations but suffers from documentation debt, scattered files (452 across 5 locations), and incomplete service deployment.

**This RFP** defines the complete requirements to bring the infrastructure from 72/100 to 90/100 (A+++ Production Ready) through a systematic 9-phase approach with multi-agent iterative quality verification.

**Agent Model**: Each phase uses Agent 2 → 3 → 4 → ... chain until A+++ grade achieved. Each agent works in isolated folder (AGENT2/, AGENT3/, etc.) with mandatory deliverables (CHANGELOG.md, AUDIT_REPORT.md, handover). User verifies each handover. Agent 1 consolidates when phase complete.

**Budget**: Internal project (no external budget)  
**Timeline**: 4 weeks (February 15 - March 15, 2026)  
**Effort**: 60-80 hours total

---

## 2. BUSINESS OBJECTIVES

### 2.1 Primary Objectives

1. **Infrastructure Stability**: Achieve 99.9% uptime with zero critical errors
2. **Documentation Excellence**: Single source of truth, zero contradictions
3. **Service Completeness**: Deploy office suite, accounting system, complete service catalog
4. **Production Readiness**: Grade 90/100 (A+++) certification
5. **Customer Readiness**: Onboarding procedures, SLAs, pricing documented

### 2.2 Business Goals

- **Service Offering Clarity**: qui3tly.cloud value proposition clearly documented
- **Revenue Model**: Pricing structure and revenue model defined
- **Customer Projects**: Ready for Montefish deployment (4 servers, multiple locations)
- **Brand Strength**: Logo assets created, brand consistently applied
- **Operational Excellence**: DR tested, monitoring validated, security hardened

### 2.3 Success Metrics

| Metric | Current | Target | Measurement |
|--------|---------|--------|-------------|
| Infrastructure Grade | 72/100 | 90/100 | External audit |
| Service Uptime | ~99.5% | 99.9% | Uptime Kuma |
| Documentation Accuracy | 60% | 95% | Spot checks |
| Service Documentation | 11% (6/54) | 100% | Count |
| Critical Errors | 2-3 | 0 | Error logs |
| Phase Completion | 0/9 | 9/9 | Phase tracking |

---

## 3. TECHNICAL REQUIREMENTS

### 3.1 Infrastructure Requirements

**Must Maintain (Do Not Break)**:
- ✅ 64 containers running (25 Master + 39 Lady)
- ✅ Tailscale VPN mesh (100.64.0.0/10)
- ✅ WireGuard P2P tunnel (10.10.0.0/30)
- ✅ Traefik reverse proxy (31 routers)
- ✅ Headscale NATIVE service (NOT Docker)
- ✅ Mailcow 18-container stack
- ✅ Monitoring stack (Prometheus, Grafana, Loki)
- ✅ Security stack (CrowdSec, Authelia, fail2ban)

**Must Fix**:
- ❌ Service 404/500 errors (investigate and resolve)
- ❌ quietly.online Traefik routing (no routers defined)
- ❌ Documentation accuracy (container counts, grades, status)
- ❌ Lady fail2ban missing jails (traefik-auth, recidive)

**Must Deploy**:
- 🆕 Office suite (OnlyOffice OR Collabora - decision required)
- 🆕 Accounting system (Odoo enhancement OR ERPNext - decision required)
- 🆕 Complete service documentation (48 remaining services)

### 3.2 Documentation Requirements

**Consolidation**:
- Consolidate 452 files from 5 locations to single source
- Archive 322 backup files properly
- Eliminate contradictions (grades, counts, status)
- Version control clarity (which doc is current)

**Accuracy**:
- Container count: Currently 64 (not 62, 63, or 83)
- Grade: Currently 72/100 (not A+++ or 85/100)
- Service status: Match reality (working vs 404/500)

**Completeness**:
- Business model documented
- Revenue model and pricing structure
- All 54+ services documented (currently 6/54 = 11%)
- Customer onboarding procedures
- SLA definitions and monitoring
- Team roles and responsibilities

### 3.3 Service Deployment Requirements

**Office Suite** (Choose One):
- **Option A**: OnlyOffice Document Server (already partially deployed)
- **Option B**: Collabora Online (LibreOffice-based)
- **Requirements**: Integration with Nextcloud, 5+ concurrent users, PDF export

**Accounting System** (Choose One):
- **Option A**: Odoo (already deployed, needs configuration)
- **Option B**: ERPNext (open-source ERP alternative)
- **Requirements**: Invoicing, expense tracking, multi-currency, reports

**Configuration Requirements**:
- Follow DOCKER_ORGANIZATION_MANDATORY.md structure
- Version pinning (no :latest tags)
- Healthchecks configured
- Monitoring integrated (Prometheus exporters)
- Secrets in ~/.secrets/ with 600 permissions
- Traefik routing with Authelia 2FA

### 3.4 Branding Requirements

**Logo Assets** (5 variants):
1. qui3tly-logo.svg (master vector, full color)
2. qui3tly-logo-dark.svg (for light backgrounds)
3. qui3tly-logo-light.svg (for dark backgrounds)
4. qui3tly-logo-mono.svg (single color)
5. qui3tly-icon.svg (icon-only, square)

**Favicon Set** (7 files):
1. favicon-16x16.png
2. favicon-32x32.png
3. favicon.ico (multi-resolution)
4. apple-touch-icon-180x180.png
5. android-icon-192x192.png
6. icon-512x512.png
7. manifest.json (PWA manifest)

**Brand Application**:
- All services use favicon set
- Traefik error pages use qui3tly.cloud branding
- Email signatures include logo
- Grafana dashboards use brand colors

### 3.5 Monitoring Requirements

**Validation**:
- All 64 containers monitored (healthy/unhealthy)
- All services have uptime checks (Uptime Kuma)
- Critical alerts configured (Alertmanager → Gotify)
- Dashboards for each major service group

**Dashboards Required** (8 total):
1. Infrastructure Overview (all servers, containers)
2. Server Details (Master, Lady individual)
3. Container Monitoring (resource usage)
4. Service Health (uptime, response times)
5. Log Analysis (error rates, trends)
6. Performance Trends (30-day view)
7. Alerting Status (active alerts, history)
8. Security Dashboard (CrowdSec, fail2ban stats)

### 3.6 Security Requirements

**Hardening**:
- Lady fail2ban complete (traefik-auth, recidive jails)
- All secrets in ~/.secrets/ with 600 permissions
- Authelia 2FA on all sensitive services
- CrowdSec rules up to date
- SSL certificates valid and auto-renewing

**Compliance**:
- No secrets in Git repositories
- File permissions per FILE_PERMISSIONS_POLICY.md
- DOCKER_ORGANIZATION_MANDATORY.md enforced (zero tolerance)
- GITHUB_ORGANIZATION_MANDATORY.md enforced (zero tolerance)

---

## 4. SCOPE OF WORK

### 4.1 Phase Breakdown

#### **PHASE 00: FOUNDATION** (5-7 days, 8-12 hours)
**Critical**: Foundation for all subsequent phases. No phase proceeds without Phase 00 approval.

**Deliverables**:
1. BUSINESS_VISION.md - qui3tly.cloud service offering documented
2. TECHNICAL_ARCHITECTURE.md - Current architecture from audit (64 containers, IPs, services)
3. INFRASTRUCTURE_BASELINE.md - Complete inventory with facts
4. DOCUMENTATION_STRATEGY.md - How to organize 452 files
5. VERIFICATION_PROTOCOL.md - Multi-agent verification process
6. AGENT2_HANDOVER.md - Agent 2 mission brief
7. 4+ Mermaid diagrams (network, service distribution, auth flow, verification)

**Verification**: Agent 2/3/4 chain validates Phase 00 completeness, user approves.

#### **PHASE 01: INFRASTRUCTURE STABILITY** (3-4 days, 6-8 hours)
**Goal**: All services accessible, zero critical errors.

**Deliverables**:
1. SERVICE_HEALTH_AUDIT.md - Test all 64 containers, document status
2. CONTAINER_INVENTORY.md - Complete list with versions, status, resources
3. NETWORK_VALIDATION.md - Verify routing, DNS, VPN connectivity
4. Fix 404/500 errors (investigation and resolution)
5. Add quietly.online Traefik routers
6. EVIDENCE/ folder with test results
7. EVIDENCE/error_logs_before.txt - Baseline errors
8. EVIDENCE/error_logs_after.txt - MUST be clean (0 lines)

**Agent Chain**: Agent 1 initial audit → Agent 2 (AGENT2/) verifies + deep dive → Agent 3 (AGENT3/) if grade < 90 → Continue until A+++ → User approves entire phase.

**Mandatory Rules**: Clean error logs (no errors exist), agents work only in their folders, user verification at each handover.

#### **PHASE 02: DOCUMENTATION CONSOLIDATION** (4-5 days, 10-12 hours)
**Goal**: Single source of truth, zero contradictions.

**Deliverables**:
1. SERVICE_CATALOG.md - All 54 services documented
2. NETWORK_DOCUMENTATION.md - Network architecture consolidated
3. RUNBOOKS/ - Troubleshooting guides per service
4. Consolidate 452 files to ~/.docs/ (or chosen location)
5. Archive 322 backup files
6. Update all docs to match reality (counts, grades, status)

**Agent Chain**: Agent 2 verifies accuracy → Agent 3 (if needed) → Continue until A+++ → User approves.

#### **PHASE 03: SERVICE DEPLOYMENT** (4-5 days, 8-10 hours)
**Goal**: Office suite and accounting system deployed.

**Deliverables**:
1. OFFICE_SUITE_DEPLOYMENT.md - Decision, deployment, testing
2. ACCOUNTING_DEPLOYMENT.md - Decision, deployment, testing
3. Integration with Nextcloud (office suite)
4. User testing and acceptance
5. Documentation (service manuals)

**Agent Chain**: Agent 2 tests deployment → Agent 3 (if needed) → Continue until A+++ → User approves.

#### **PHASE 04: MONITORING VALIDATION** (2-3 days, 5-6 hours)
**Goal**: All monitoring operational and validated.

**Deliverables**:
1. MONITORING_VALIDATION.md - Test all dashboards, alerts
2. 8 Grafana dashboards validated
3. Alertmanager rules tested
4. Uptime Kuma checks for all services
5. Documentation updated

**Agent Chain**: Agent 2 validates monitoring → Agent 3 (if needed) → Continue until A+++ → User approves.

#### **PHASE 05: BACKUP & DR VERIFICATION** (2-3 days, 4-5 hours)
**Goal**: DR tested within 30 days, procedures validated.

**Deliverables**:
1. BACKUP_TESTING.md - Test all 3 DR methods
2. Verify RTO targets (2min, 15min, 45min)
3. Update DISASTER_RECOVERY.md with current procedures
4. Document results in EVIDENCE/

**Agent Chain**: Agent 2 reviews DR tests → Agent 3 (if needed) → Continue until A+++ → User approves.

#### **PHASE 06: SECURITY HARDENING** (3-4 days, 6-8 hours)
**Goal**: Security gaps closed, hardening complete.

**Deliverables**:
1. SECURITY_AUDIT.md - Complete security review
2. Lady fail2ban jails added (traefik-auth, recidive)
3. Secrets audit (all in ~/.secrets/, 600 permissions)
4. Authelia validation (2FA on all sensitive services)
5. CrowdSec rules updated

**Agent Chain**: Agent 2 audits security → Agent 3 (if needed) → Continue until A+++ → User approves.

#### **PHASE 07: BRANDING ASSETS** (3-4 days, 6-8 hours)
**Goal**: Logo and favicon assets created and deployed.

**Deliverables**:
1. LOGO_CREATION.md - Logo design process and decisions
2. BANNER_CREATION.md - Banner designs for services
3. 5 logo variants (SVG files)
4. 7 favicon files (PNG, ICO, manifest)
5. DESIGN_ASSETS/ folder with all files
6. Brand deployment across all services

**Agent Chain**: Agent 2 validates brand → Agent 3 (if needed) → Continue until A+++ → User approves.

#### **PHASE 08: FINAL DOCUMENTATION** (4-5 days, 8-10 hours)
**Goal**: Complete, accurate, consolidated documentation.

**Deliverables**:
1. COMPLETE_INFRASTRUCTURE_GUIDE.md - Comprehensive guide
2. SERVICE_CATALOG_FINAL.md - All services documented
3. NETWORK_DIAGRAMS_MASTER.md - All network diagrams
4. RUNBOOK_COLLECTION.md - All troubleshooting guides
5. Business model, revenue model, pricing documented
6. Customer onboarding procedures

**Agent Chain**: Agent 2 validates docs → Agent 3 (if needed) → Continue until A+++ → User approves.

#### **PHASE 09: A+++ CERTIFICATION** (2-3 days, 4-5 hours)
**Goal**: Grade 90/100 achieved and verified.

**Deliverables**:
1. GRADING_RUBRIC.md - Detailed grading criteria
2. VERIFICATION_CHECKLIST.md - All requirements met
3. Final external audit report
4. Grade calculation and justification
5. User sign-off on project completion

**Verification**: Agent 2/3/4 chain performs final audit, user approves and closes project.

### 4.2 Dependencies

- **Phase 00 blocks all others** (foundation required)
- Phase 01 required before Phase 02 (stable before documenting)
- Phase 02 required before later phases (consolidation foundation)
- Phase 03 independent (can run parallel with others if resources allow)
- Phase 04-06 independent (monitoring, backup, security can be parallel)
- Phase 07 independent (branding can run parallel)
- Phase 08 requires Phases 01-07 complete (technical excellence needs all services deployed)
- Phase 09 requires Phase 08 complete (documentation after A+++ achieved)

### 4.3 Out of Scope

**Explicitly NOT Included**:
- ❌ IPv6 deployment (decision: defer to future)
- ❌ CCTV/NVR system (design only, deployment future)
- ❌ Mobile app development (iOS/Android future)
- ❌ Montefish deployment (future customer project)
- ❌ Additional servers (Beauty, Madam future)
- ❌ Multi-site VPN expansion (Office, Parents future)

**Deferred to Future Projects**:
- Infrastructure expansion (4+ servers)
- OSPF/FRR (permanently rejected)
- Customer-specific deployments

---

## 5. DELIVERABLES

### 5.1 Documentation Deliverables

**Project Level** (5 files):
- README.md (project overview, status)
- RFP.md (this document)
- MASTER_PLAN.md (strategy, timeline)
- TODO.md (task tracker)
- ROLES_AND_RESPONSIBILITIES.md (team roles)

**Phase 00** (7 files + 4 diagrams):
- Foundation documents (business, technical, baseline, strategy, protocol)
- Agent 2 handover document (AGENT2_HANDOVER.md)
- Mermaid diagrams

**Phases 01-09** (3-8 files each):
- Phase README
- Specific deliverables per phase
- Agent 2 handover per phase
- EVIDENCE folders with test results

**Total**: 80-100 markdown files + 10-15 diagrams + evidence files

### 5.2 Infrastructure Deliverables

- Office suite deployed and operational
- Accounting system deployed and operational
- All 64 containers verified healthy
- 404/500 errors resolved
- quietly.online routing fixed
- Lady fail2ban jails added
- Monitoring dashboards validated
- DR tested (3 methods)

### 5.3 Branding Deliverables

- 5 logo variants (SVG)
- 7 favicon files (PNG, ICO, manifest)
- Brand deployed across all services
- Email signatures updated
- Traefik error pages branded

### 5.4 Business Deliverables

- Business model documented
- Revenue model and pricing structure
- Customer onboarding procedures
- SLA definitions
- Team roles documented

---

## 6. ACCEPTANCE CRITERIA

### 6.1 Technical Acceptance

✅ **Infrastructure**:
- All 64 containers running and healthy (docker ps shows "healthy")
- Zero critical errors in logs
- All services accessible (no 404/500 errors)
- quietly.online Traefik routing working
- Lady fail2ban complete

✅ **Services**:
- Office suite deployed (OnlyOffice OR Collabora)
- Accounting system deployed (Odoo enhanced OR ERPNext)
- Integration tested (Nextcloud + office suite)
- User acceptance testing passed

✅ **Monitoring**:
- 8 Grafana dashboards operational
- All services in Uptime Kuma
- Alertmanager rules tested
- No false positives in alerts

✅ **Security**:
- All secrets in ~/.secrets/ with 600 permissions
- Authelia 2FA on sensitive services
- fail2ban complete (Master + Lady)
- CrowdSec rules updated
- SSL certificates valid

✅ **DR**:
- All 3 methods tested (2min, 15min, 45min)
- Test results documented
- Procedures updated
- Success rate 100%

### 6.2 Documentation Acceptance

✅ **Accuracy**:
- Container count correct (64)
- Grade correct (72 → 90)
- Service status matches reality
- Zero contradictions

✅ **Completeness**:
- All 54+ services documented
- Business model documented
- Revenue model documented
- Customer onboarding documented
- SLAs documented
- Team roles documented

✅ **Consolidation**:
- Single source of truth (_.docs/_ or chosen location)
- 452 files consolidated
- 322 backups archived
- Version control clear

### 6.3 Business Acceptance

✅ **Business Model**:
- qui3tly.cloud value proposition clear
- Target customers defined
- Service offerings documented
- Competitive positioning clear

✅ **Revenue Model**:
- Pricing structure documented
- Revenue streams identified
- Cost structure understood
- Margin targets set

✅ **Operations**:
- Customer onboarding procedures exist
- SLA definitions clear
- Team structure documented
- Communication templates ready

### 6.4 Phase Acceptance

✅ **Per Phase**:
- All deliverables complete
- Agent 2/3+ chain verification passed (A+++ grade)
- User approval obtained
- Evidence archived
- Phase README updated with "COMPLETE" status
- Next phase unlocked

### 6.5 Project Acceptance

✅ **Final Criteria**:
- All 9 phases complete
- Grade 90/100 achieved
- External audit passed
- User sign-off obtained
- Project closed formally

---

## 7. TIMELINE

**Total Duration**: 4 weeks (February 15 - March 15, 2026)

| Week | Phases | Deliverables |
|------|--------|--------------|
| **1** | Phase 00 | Foundation complete, approved |
| **1-2** | Phase 01 | Infrastructure stable |
| **2** | Phase 02 | Documentation consolidated |
| **2-3** | Phase 03, 04, 05, 06 | Services, monitoring, DR, security (parallel) |
| **3** | Phase 07 | Branding assets |
| **3-4** | Phase 08 | Technical Excellence (A+++ achievement) |
| **4** | Phase 09 | Documentation & Closure |

**Critical Path**: Phase 00 → Phase 01 → Phase 02 → Phase 08 → Phase 09

**Flexible**: Phases 03-07 can run parallel if resources allow (but require Phase 01 stable base)

---

## 8. BUDGET & RESOURCES

### 8.1 Budget

**Type**: Internal project (no external budget)

**Costs**:
- Logo design: $0 (AI-generated or user-created)
- Infrastructure: $0 (existing VPS)
- Tools: $0 (all open-source)
- Labor: Internal (qui3tly + Lucky Luke + Agent chain iterations)

### 8.2 Resources

**Human Resources**:
- qui3tly (10-15 hours) - Approvals, decisions, testing
- Lucky Luke (40-50 hours) - Planning, documentation, coordination
- External Agent (10-15 hours) - Verification per phase

**Technical Resources**:
- 2 VPS servers (existing)
- GitHub repositories (existing)
- Monitoring tools (existing)
- AI tools for logo generation (free tier)

### 8.3 Tools

**Documentation**: Markdown, Mermaid diagrams, VSCode  
**Infrastructure**: Docker, Ansible, Git  
**Monitoring**: Prometheus, Grafana, Loki  
**Design**: AI tools (Midjourney, DALL-E, Stable Diffusion) or SVG editors  
**Communication**: GitHub Copilot, direct user interaction

---

## 9. RISK MANAGEMENT

### 9.1 Identified Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Service downtime during fixes | Medium | High | Test in staging, limit change windows |
| Office suite decision delayed | Low | Medium | Set decision deadline (Phase 03 start) |
| Agent unavailable/blocked | Low | Medium | Continue with next available agent |
| Documentation consolidation breaks links | Medium | Medium | Test all links, maintain original until verified |
| Logo design unsatisfactory | Medium | Low | Multiple iterations, user approval required |
| Phase dependencies cause delays | Low | Medium | Parallel execution where possible |
| User approval delayed | Medium | High | Clear approval checkpoints, flexible schedule |

### 9.2 Mitigation Strategies

**For Service Stability**:
- Test all changes in docker inspect before apply
- Limited change windows (off-peak hours)
- Rollback procedures ready
- DR procedures tested

**For Documentation**:
- Git commits for every change (easy rollback)
- Keep backups until consolidation verified
- Test all internal links
- Agent chain verifies before user approval

**For Timeline**:
- Flexible phase ordering (parallel where possible)
- Buffer time in estimates
- Clear priorities (Phase 00 absolute must)
- User availability confirmed upfront

---

## 10. SUCCESS CRITERIA SUMMARY

**Project Successful When**:
1. ✅ Grade 90/100 achieved (external audit verified)
2. ✅ All 9 phases complete and approved
3. ✅ Zero critical errors in infrastructure
4. ✅ All services documented and operational
5. ✅ Business model and revenue model documented
6. ✅ Branding assets created and deployed
7. ✅ Documentation consolidated (single source of truth)
8. ✅ User satisfaction and formal sign-off

**Grade Calculation** (90/100 target):
- Availability: 95/100 (all services working)
- Reliability: 90/100 (DR tested, uptime proven)
- Monitoring: 90/100 (complete dashboards, validated)
- Security: 90/100 (hardened, tested)
- Documentation: 90/100 (accurate, complete, consolidated)
- Backup/DR: 95/100 (tested 3 methods)
- Change Control: 90/100 (git workflow solid)
- Acceptance: 100/100 (formal project closeout)

**Average: 90/100 = A+++ Production Ready**

---

## 11. APPROVAL & SIGN-OFF

**RFP Prepared By**:
- Lucky Luke (Primary Agent)
- Date: February 15, 2026

**RFP Approved By**:
- [ ] qui3tly (User) - Date: __________

**Notes**:
- This RFP becomes the master reference for the project
- Changes require user approval
- All phases reference this RFP for requirements

---

**Document Version**: 1.0  
**Last Updated**: February 15, 2026  
**Status**: Draft - Awaiting User Approval
