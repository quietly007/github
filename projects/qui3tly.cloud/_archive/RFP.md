# Request for Implementation - Preproduction qui3tly.cloud

> **Project Name**: Preproduction qui3tly.cloud Excellence Initiative  
> **Client**: qui3tly (Owner & Founder)  
> **Implementation Partner**: Lucky Luke 🤠 (AI Agent)  
> **Date Issued**: 2026-01-22  
> **Response Deadline**: 2026-01-23  
> **Project Start**: 2026-01-22  
> **Target Completion**: 2026-02-22 (30 days)  
> **Status**: APPROVED - Implementation Authorized

---

## 1. PROJECT OVERVIEW

### 1.1 About the Owner

**qui3tly** is a veteran network engineer with **30 years of professional experience** in networking, routing, and Linux system administration. Key achievements:

- **Founder** of the first Internet Service Provider in Montenegro
- **Operator** of AS8585 (Autonomous System) for 20 years before sale to T-com
- **Expert** in enterprise network architecture, BGP, OSPF, VLANs, routing protocols
- **Cisco veteran** - decades of experience with enterprise networking
- **Linux specialist** - deep expertise in Debian, systemd, networking, security

**Philosophy**: No patches, no shortcuts. Fix it right the first time. Every change must survive reboots and be reproducible. Documentation must be precise, detailed, and accurate - network diagrams should show EVERY detail: IP addresses, subnet masks, routes, interfaces, connections.

### 1.2 Infrastructure Background

qui3tly.cloud is a production infrastructure comprising two Contabo VPS servers (Master and Lady) running 43 Docker containers across 19 services, with Tailscale mesh VPN coordination, comprehensive monitoring, and enterprise-grade security.

**Current Status** (Updated 2026-01-23):
- **Overall Grade**: A- (9.0/10)
- **Status**: Production Ready ✅ | Lady DR Single-Command Ready
- **Infrastructure**: Excellent (Security A 9.4, Performance A 9.5, Automation A- 9.2)
- **Documentation**: Needs Work (C+ 7.0) - 30% drift post-Mailcow deployment
- **Operations**: Needs Work (C- 5.5) - Critical errors in HOWTOs

**Audit Summary**:
- 47 issues identified
- 12 critical documentation errors
- 5 missing operational guides
- 3 missing scripts (referenced but don't exist)
- 0 critical security vulnerabilities ✅

### 1.3 Project Objective

**Transform qui3tly.cloud from Production Ready to World-Class Excellence**

Upgrade infrastructure documentation, operational procedures, and system hardening to achieve **A+++ (10/10)** grade across all categories through systematic, disciplined improvement.

**Target Outcomes**:
- 🎯 Documentation: 100% accurate, complete, diagram-rich (A+ 9.8)
- 🎯 Operations: All procedures verified, automated (A+ 9.8)
- 🎯 Security: Enhanced monitoring, AIDE, pentesting (A+ 9.8)
- 🎯 Automation: Complete Ansible coverage, 2-click DR (A++ 10.0)
- 🎯 Overall: World-class infrastructure (A+++ 10.0)

### 1.4 Scope

**IN SCOPE**:
- ✅ Documentation updates (47 markdown files)
- ✅ Operational guide creation (5 missing docs)
- ✅ Script creation/consolidation (3 missing, 2 duplicate)
- ✅ Ansible playbook completion (2 missing playbooks)
- ✅ Security enhancements (AIDE, enhanced monitoring)
- ✅ Diagram creation (9 docs need visuals)
- ✅ Testing and verification of all procedures

**OUT OF SCOPE**:
- ❌ Infrastructure expansion (Madam, Beauty servers)
- ❌ New service deployments (not in current audit)
- ❌ Major architectural changes
- ❌ Hardware procurement
- ❌ Third-party integrations (unless documented)

**CONSTRAINTS**:
- 🔒 Master and Lady must remain operational (production)
- 🔒 SSH port 1006 protection (CRITICAL - never modify)
- 🔒 No patches - permanent fixes only
- 🔒 All changes follow 7-step governance workflow
- 🔒 Backup before any mutation
- 🔒 DR IP retention: Headscale workflow must preserve Lady Tailnet IP (100.64.0.2)
- 🔒 Initial access policy: first login uses admin/password only, then switch to qui3tly SSH key-only
- 🔒 Secrets transfer required from Master before service deploy (Cloudflare, Tailscale authkey, Mailcow, Traefik, etc.)
- 🔒 GitHub token is shared; each repo must retain its own .git and .gitignore
- 🔒 Semaphore must use separate projects for Master/Lady/Madam with shared + host-specific playbooks
- 🔒 Workers run only Portainer agent + monitoring agents reporting to Master

---

## 2. DETAILED REQUIREMENTS

### 2.1 Documentation Strategy - CRITICAL APPROACH

#### 2.1.0 Documentation Backup & Fresh Start (MANDATORY)

**Approach**: Backup existing documentation, create fresh professional documentation from scratch

**Backup Phase** (Week 1, Day 1):
```bash
# Create backup of current documentation
mkdir -p ~/.docs/backup-20260122/
cp -r ~/.docs/* ~/.docs/backup-20260122/
tar -czf ~/.docs/backup-20260122.tar.gz ~/.docs/backup-20260122/
```

**Fresh Creation Philosophy**:
- ❌ DON'T patch or update existing docs
- ✅ DO create new documentation from scratch based on current reality
- ✅ DO verify every fact, command, IP address, path
- ✅ DO test every procedure before documenting
- ✅ DO include comprehensive diagrams (see Diagram Requirements)

**Why Fresh Start**:
- Current docs have 30% drift - patching is risky
- Fresh docs ensure 100% accuracy
- Opportunity to reorganize and improve structure
- Clean slate = professional quality
- Owner reviews new docs, not patches

#### 2.1.1 Critical Errors (MUST FIX - Week 1)
**Priority**: 🔴 CRITICAL  
**Time**: 65 minutes

1. **Lady Container Count** (10 min)
   - Current: Documentation says 4 containers
   - Reality: 22 containers (18 Mailcow + 4 infra)
   - Files: INFRASTRUCTURE.md, SERVERS.md, architecture docs
   - Verification: `ssh lady "docker ps --format '{{.Names}}' | wc -l"`

2. **Headscale Commands** (10 min)
   - Current: 13 occurrences of `docker exec -it headscale headscale`
   - Correct: `sudo headscale` (native installation)
   - Files: HEADSCALE.md, NETWORK.md, various HOWTOs
   - Pattern: Global find/replace with verification

3. **Playbook Paths** (10 min)
   - Current: `~/ansible/{service}/*.yml`
   - Correct: `~/.ansible/playbooks/{master|lady|shared}/*.yml`
   - Files: Architecture docs, deployment guides
   - Verification: Path exists on filesystem

4. **Firewall Documentation** (15 min)
   - Current: Incomplete rule listing
   - Required: Full rule documentation (23 Master, 10 Lady)
   - Files: SECURITY.md, FIREWALL.md
   - Source: `sudo ufw status numbered`

5. **Missing Script Documentation** (20 min)
   - Scripts referenced but don't exist: lady-dr.sh, deploy-dr.sh, lady-fresh-install.sh
   - Action: Document what they SHOULD do, mark as TODO
   - Alternative: Update docs to reflect current scripts
   - Files: DR-HOWTO.md, deployment guides

#### 2.1.2 Missing Operational Guides (MUST CREATE - Weeks 2-3)
**Priority**: 🔴 CRITICAL  
**Time**: 18 hours

1. **MAILCOW.md** (4 hours)
   - Service architecture (18 containers)
   - Configuration management
   - Common operations (user creation, domain management)
   - Troubleshooting (DNS, TLS, delivery issues)
   - Backup/restore procedures
   - Update procedures
   - Integration with Traefik

2. **CROWDSEC.md** (3 hours)
   - Alert types and meanings (163 total alerts documented)
   - Ban management workflow
   - Bouncer configuration
   - Threat analysis procedures
   - False positive handling
   - Integration with Traefik bouncer
   - Performance impact

3. **HEADSCALE_OPERATIONS.md** (3 hours)
   - User/node management
   - Preauthkey generation
   - Route advertisement
   - Troubleshooting connectivity
   - DERP server management
   - MagicDNS configuration
   - ACL management

4. **DNS_ARCHITECTURE.md** (4 hours)
   - Complete DNS flow diagram (Pi-hole → Cloudflare → Tailscale MagicDNS)
   - dnsmasq configuration (3 domains: quietly.its.me, quietly.online, qui3tly.cloud)
   - Split-horizon DNS explanation
   - WireGuard DNS routing (EdgeRouter → Pi-hole)
   - Troubleshooting DNS issues
   - Test procedures

5. **DISASTER_RECOVERY_PROCEDURES.md** (4 hours)
   - Complete DR workflow (scripts exist but no guide)
   - Step-by-step procedures for both servers
   - Secrets handling during DR
   - Verification checklists
   - Recovery time objectives (RTO/RPO)
   - Quarterly testing schedule

#### 2.1.3 Diagram Requirements (ALL PHASES) ⚠️ CRITICAL PRIORITY

**MANDATORY**: All diagrams must include COMPLETE technical details as specified by network engineer owner

**Diagram Standards** (Non-Negotiable):
- ✅ **IP Addresses**: Every interface, every device (public, private, VPN)
- ✅ **Subnet Masks**: /24, /30, /10 notation clearly shown
- ✅ **Interface Names**: eth0, wg0, tailscale0, docker0, br-xxx
- ✅ **Routes**: Static routes, default gateways documented
- ✅ **Port Numbers**: Every service port clearly labeled
- ✅ **Protocols**: TCP/UDP, WireGuard, Tailscale, HTTPS
- ✅ **DNS Servers**: Primary, secondary, MagicDNS
- ✅ **Color Coding**: Different colors for different networks/layers
  - Blue: Public internet/WAN
  - Green: Tailscale mesh (100.64.0.0/10)
  - Orange: WireGuard P2P (10.10.0.0/30)
  - Purple: Docker networks (172.x.x.x)
  - Yellow: LAN (192.168.99.0/24)
  - Red: Security/firewall boundaries
- ✅ **Hostnames**: FQDN and short names
- ✅ **Connection Types**: Solid lines (direct), dashed (VPN), dotted (logical)

**Format**: Mermaid diagram code (for version control) + rendered PNG export

**Critical Diagrams** (Priority Order):

**1. Complete Network Topology** (2 hours) 🔴 CRITICAL
```
MUST INCLUDE:
- Master: 213.136.68.108 (public), 100.64.0.1 (Tailscale), 10.10.0.1/30 (WireGuard)
- Lady: 207.180.251.111 (public), 100.64.0.2 (Tailscale)
- EdgeRouter: 62.4.55.119 (WAN), 10.10.0.2/30 (WireGuard), 192.168.99.1/24 (LAN)
- Mac Mini: 192.168.99.123 (LAN), 100.64.0.3 (Tailscale)
- All Docker networks on Master and Lady
- All Tailscale mesh connections
- WireGuard tunnel details
- Static routes (100.64.0.0/10 via 10.10.0.1 on EdgeRouter)
- Firewall boundaries (UFW rules visualization)
- Color coded by network type
```

**2. DNS Architecture - Complete Flow** (2 hours) 🔴 CRITICAL
```
MUST INCLUDE:
3 Layers with IP addresses:
- Layer 1: Cloudflare (1.1.1.1, 1.0.0.1) → Public DNS for 3 domains
- Layer 2: Pi-hole (container on 172.x.x.x, exposed on Master) → dnsmasq configs
- Layer 3: MagicDNS (100.100.100.100) → Headscale coordination
3 Scenarios:
- External → Cloudflare → Public IP
- Tailscale client → MagicDNS → Tailnet IP
- LAN → EdgeRouter → WireGuard → Pi-hole → Tailnet IP
All resolv.conf configurations
All dnsmasq.conf entries
DNS record types (A, MX, CNAME, TXT)
```

**3. Mailcow Architecture** (1.5 hours) 🔴 CRITICAL
```
MUST INCLUDE:
- All 18 containers with names
- Internal Docker network (172.x.x.x/16)
- Container ports and mappings
- Traefik integration (reverse proxy)
- Mail flow: Internet → Traefik → Nginx → Postfix/Dovecot
- Database connections (MariaDB, Redis)
- Volume mounts
- DNS requirements (MX, SPF, DKIM, DMARC records)
```

**4. Security Layers Detailed** (1.5 hours) 🟠 HIGH
```
MUST INCLUDE:
6 Layers with technical details:
- Layer 1: Internet → UFW firewall (23 rules Master, 10 Lady) with port numbers
- Layer 2: SSH hardening (port 1006, pubkey only, fail2ban)
- Layer 3: Traefik → Authelia (SSO, 2FA) with URLs
- Layer 4: CrowdSec (decision engine → bouncer) with alert flow
- Layer 5: VPN encryption (Tailscale mesh, WireGuard tunnel) with cipher details
- Layer 6: Service monitoring (Prometheus scrape targets)
```

**5. Traefik Routing** (1 hour) 🟠 HIGH
```
MUST INCLUDE:
- Internet → Cloudflare → Traefik (ports 80, 443)
- All routes with hostnames (traefik.quietly.its.me, etc.)
- Middleware chain: Headers → Authelia → CrowdSec bouncer → Service
- Docker network routing (traefik network)
- TLS termination (Let's Encrypt)
- Backend service IPs and ports
```

**6. Disaster Recovery Workflow** (1 hour) 🟠 HIGH
```
MUST INCLUDE:
- Step-by-step flow diagram
- Script execution order
- Pause points for manual intervention
- Verification steps
- Time estimates per phase
- Rollback decision points
```

**7. Monitoring Architecture** (1 hour) 🟡 MEDIUM
```
MUST INCLUDE:
- Prometheus scrape targets (all services with IPs:ports)
- Loki log sources (all containers)
- Grafana dashboards (data sources)
- Alertmanager routing (notification channels)
- Data flow: Service → Exporter → Prometheus → Grafana
- Retention policies
```

**8. CrowdSec Threat Detection** (1 hour) 🟡 MEDIUM
```
MUST INCLUDE:
- Log sources (Traefik, Authelia, SSH)
- Parser → Scenario → Decision flow
- Decision types (ban, captcha)
- Bouncer enforcement (Traefik bouncer)
- Alert storage and API
- Example attack flow (SSH brute force)
```

**9. Twin Agent Communication** (30 min) 🟡 MEDIUM
```
MUST INCLUDE:
- Master agent ↔ GitHub ↔ Lady agent
- Shared repositories and paths
- Memory files (master.jsonl, lady.jsonl)
- SSH connections (via Tailscale)
- Sync scripts
```

**Total Diagram Time**: 12 hours (increased from 9 due to detail requirements)

### 2.2 Script Requirements

#### 2.2.1 Missing Scripts (CREATE - Week 2)
**Priority**: 🔴 CRITICAL  
**Time**: 6 hours

1. **lady-dr.sh** (2 hours)
   - Based on existing master-dr.sh pattern
   - Include Mailcow deployment
   - Pause for secrets copy (7 SSH keys + Mailcow configs)
   - Verification steps

2. **deploy-dr.sh** (2 hours)
   - Orchestrate both master-dr.sh and lady-dr.sh
   - Dependency management (Master first, then Lady)
   - Health checks between stages
   - Rollback capability

3. **lady-fresh-install.sh** (2 hours)
   - Initial bootstrap script (like master-fresh-install.sh)
   - User creation, SSH hardening
   - Basic packages, Docker installation
   - Firewall setup

#### 2.2.2 Script Consolidation (Week 3)
**Priority**: 🟡 MEDIUM  
**Time**: 3 hours

1. **Identify duplicates** (1 hour)
   - sync-repos.sh variants
   - Monitoring check scripts
   - Health check scripts

2. **Consolidate** (2 hours)
   - Create unified versions
   - Update documentation references
   - Deprecate old versions

### 2.3 Ansible Requirements

#### 2.3.1 Missing Playbooks (Week 4)
**Priority**: 🟠 HIGH  
**Time**: 4 hours

1. **headscale-deploy.yml** (3 hours)
   - Native installation (NOT Docker)
   - Configuration management
   - Service management
   - Integration testing

2. **headscale-dr-ip-retention.yml** (1 hour)
   - DR workflow: delete old Lady node, VACUUM DB, re-register to retain Tailnet IP
   - Must be safe, idempotent, and documented
   - Used when Lady is restored from backup or rebuilt

3. **wazuh-deploy.yml** (1 hour)
   - If approved for Phase 4
   - Agent installation
   - Dashboard configuration

#### 2.3.2 Playbook Testing (Week 4)
**Priority**: 🔴 CRITICAL  
**Time**: 8 hours

- Test all 41 playbooks on fresh environment
- Verify idempotency
- Document dependencies
- Update README with testing results

#### 2.3.3 Semaphore Project Structure (Week 4)
**Priority**: 🟠 HIGH  
**Time**: 2 hours

- Create separate Semaphore projects: **Master**, **Lady**, **Madam**
- Each project includes **shared playbooks** + **host-specific playbooks**
- Define inventory mapping per project and document the playbook list

### 2.4 Security Requirements

#### 2.4.1 Enhanced Monitoring (Week 5)
**Priority**: 🟠 HIGH  
**Time**: 6 hours

1. **AIDE Installation** (3 hours)
   - File integrity monitoring
   - Baseline creation
   - Alert configuration
   - Cron job setup

2. **Enhanced Logging** (3 hours)
   - Centralized log review procedures
   - Alert thresholds
   - Retention policies

#### 2.4.2 Security Testing (Week 6)
**Priority**: 🟡 MEDIUM  
**Time**: 8 hours

1. **Internal Audit** (4 hours)
   - Review all security configurations
   - Verify firewall rules
   - Check secrets permissions
   - Document findings

2. **Penetration Testing** (4 hours)
   - External port scanning
   - Service enumeration
   - Vulnerability assessment
   - Remediation plan

### 2.5 Testing & Verification

#### 2.5.1 Procedure Verification (Ongoing)
**Priority**: 🔴 CRITICAL  
**Time**: Included in each task

- Every HOWTO must be tested
- Every command must execute successfully
- Every playbook must complete without errors
- Every script must run and produce expected output

#### 2.5.2 DR Testing (Week 6)
**Priority**: 🔴 CRITICAL  
**Time**: 4 hours

- Full DR test of Master (snapshot → deploy → verify)
- Full DR test of Lady (snapshot → deploy → verify)
- Document actual RTO/RPO
- Update procedures based on findings

---

## 3. DELIVERABLES

### 3.1 Phase 1: Quick Wins (Week 1)

**Deliverables**:
- ✅ Existing documentation backed up (timestamped archive)
- ✅ 15 quick win tasks completed
- ✅ All 12 critical errors fixed
- ✅ Documentation accuracy: 70% → 90%
- ✅ Grade improvement: C+ 7.0 → B 8.0
- ✅ Fresh documentation structure prepared

**Acceptance Criteria**:
- Backup complete and verified
- All factual errors corrected
- All commands work as documented
- No broken references
- Verified by automated checks
- Owner approves fresh documentation approach

### 3.2 Phase 2: Critical Documentation (Weeks 2-3)

**Deliverables**:
- ✅ 5 operational guides created (MAILCOW, CROWDSEC, HEADSCALE_OPERATIONS, DNS_ARCHITECTURE, DISASTER_RECOVERY_PROCEDURES)
- ✅ 3 missing scripts created (lady-dr.sh, deploy-dr.sh, lady-fresh-install.sh)
- ✅ DR-HOWTO.md rewritten
- ✅ All procedures tested and verified
- ✅ Grade improvement: B 8.0 → B+ 8.5

**Acceptance Criteria**:
- Every deployed service has operational guide
- Every referenced script exists and works
- Every procedure tested by owner
- 100% script coverage
comprehensive diagrams created with ALL technical details:
  - Every IP address, subnet mask, interface name
  - All routes, ports, protocols documented
  - Color-coded network visualization
  - Mermaid source + PNG exports
- ✅ Duplicate content consolidated
- ✅ 2 missing Ansible playbooks created
- ✅ All 41 playbooks tested
- ✅ Script consolidation complete
- ✅ Grade improvement: B+ 8.5 → A- 9.0

**Acceptance Criteria**:
- 80% of docs have diagrams
- ALL diagrams meet technical detail requirements (owner verified)
- No duplicate content
- Ansible can rebuild entire infrastructure
- All scripts verified working
- Network engineer (owner) approves diagram accuracy
- 80% of docs have diagrams
- No duplicate content
- Ansible can rebuild entire infrastructure
- All scripts verified working

### 3.4 Phase 4: World-Class Excellence (Week 6+)

**Deliverables**:
- ✅ AIDE monitoring operational
- ✅ Enhanced security logging
- ✅ Penetration testing completed
- ✅ DR procedures tested
- ✅ Capacity planning documentation
- ✅ Performance benchmarks
- ✅ Grade improvement: A- 9.0 → A+++ 10.0

**Acceptance Criteria**:
- Zero critical vulnerabilities
- 100% service coverage
- DR tested successfully
- All enhancements operational

---

## 4. PROJECT TIMELINE

### 4.1 Master Schedule

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      PROJECT TIMELINE (30 DAYS)                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Week 1 (Jan 22-28):  Quick Wins                                           │
│  ├─ Day 1-2: Critical errors (Lady count, Headscale commands, paths)       │
│  ├─ Day 3-4: Firewall docs, script documentation                           │
│  └─ Day 5:   Verification & testing                                        │
│  Target: Grade B (8.0) - All critical errors fixed                         │
│                                                                             │
│  Week 2 (Jan 29 - Feb 4): Critical Docs Part 1                             │
│  ├─ Day 1-2: MAILCOW.md (4 hours)                                          │
│  ├─ Day 3:   CROWDSEC.md (3 hours)                                         │
│  ├─ Day 4:   lady-dr.sh script (2 hours)                                   │
│  └─ Day 5:   deploy-dr.sh script (2 hours)                                 │
│  Target: Grade B (8.2) - Mailcow documented, DR scripts exist              │
│                                                                             │
│  Week 3 (Feb 5-11): Critical Docs Part 2                                   │
│  ├─ Day 1-2: HEADSCALE_OPERATIONS.md (3 hours)                             │
│  ├─ Day 3:   DNS_ARCHITECTURE.md (4 hours)                                 │
│  ├─ Day 4:   DISASTER_RECOVERY_PROCEDURES.md (4 hours)                     │
│  └─ Day 5:   DR-HOWTO.md rewrite (3 hours)                                 │
│  Target: Grade B+ (8.5) - All services documented                          │
│                                                                             │
│  Week 4 (Feb 12-18): Polish Part 1                                         │
│  ├─ Day 1-2: Diagrams 1-4 (network, DNS, Traefik, DR)                      │
│  ├─ Day 3:   Diagrams 5-6 (monitoring, Mailcow)                            │
│  ├─ Day 4:   headscale-deploy.yml playbook                                 │
│  └─ Day 5:   Playbook testing                                              │
│  Target: Grade A- (9.0) - Visual documentation, complete Ansible           │
│                                                                             │
│  Week 5 (Feb 19-25): Polish Part 2                                         │
│  ├─ Day 1:   Diagrams 7-9 (security, CrowdSec, agent arch)                 │
│  ├─ Day 2-3: Script consolidation                                          │
│  ├─ Day 4:   Content deduplication                                         │
│  └─ Day 5:   Verification testing                                          │
│  Target: Grade A (9.3) - Professional polish complete                      │
│                                                                             │
│  Week 6+ (Feb 26+): Excellence                                             │
│  ├─ AIDE installation (3 hours)                                            │
│  ├─ Enhanced logging (3 hours)                                             │
│  ├─ Security audit (4 hours)                                               │
│  ├─ Penetration testing (4 hours)                                          │
│  ├─ DR testing (4 hours)                                                   │
│  ├─ Capacity planning (4 hours)                                            │
│  └─ Final verification (2 hours)                                           │
│  Target: Grade A+++ (10.0) - World-class infrastructure                    │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 4.2 Effort Breakdown

| Phase | Duration | Effort | Grade Target |
|-------|----------|--------|--------------|
| Phase 1: Quick Wins + Backup | Week 1 | 3 hours | B (8.0) |
| Phase 2: Critical Docs | Weeks 2-3 | 24 hours | B+ (8.5) |
| Phase 3: Polish + Diagrams | Weeks 4-5 | 28 hours | A- (9.0) → A (9.3) |
| Phase 4: Excellence | Week 6+ | 24 hours | A+++ (10.0) |
| **TOTAL** | **30+ days** | **79+ hours** | **A+++ (10.0)** |

**Note**: Diagram time increased to 12 hours due to comprehensive technical detail requirements

---

## 5. IMPLEMENTATION APPROACH

### 5.1 Methodology

**Agile, Iterative, Test-Driven**

1. **Plan** - Review requirements, create task checklist
2. **Implement** - Make changes following 7-step workflow
3. **Verify** - Test every change, document results
4. **Review** - Owner approval before merge
5. **Deploy** - Push to GitHub, update docs
6. **Monitor** - Track impact, adjust as needed
7. **Iterate** - Move to next task

### 5.2 Quality Assurance

**Every Deliverable Must**:
- ✅ Be technically accurate (commands work)
- ✅ Follow governance rules (no patches)
- ✅ Include backup (before mutation)
- ✅ Be tested (verification required)
- ✅ Be documented (memories.jsonl entry)
- ✅ Be reviewed (owner approval)
- ✅ Be versioned (git commit)

### 5.3 Risk Mitigation

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Documentation drift during project | Medium | Medium | Weekly sync with reality |
| Script changes break production | Low | High | Test in isolated environment |
| SSH lockout during changes | Low | Critical | NEVER touch SSH config |
| Service downtime during DR test | Medium | Medium | Schedule maintenance window |
| Timeline slippage | Medium | Low | Prioritize critical items first |

### 5.4 Success Criteria

**Phase Completion**:
- ✅ All tasks in phase checklist completed
- ✅ All deliverables tested and verified
- ✅ Owner approval obtained
- ✅ Grade target achieved
- ✅ No regressions introduced

**Project Completion**:
- ✅ Overall grade: A+++ (10.0)
- ✅ All 47 audit issues resolved
- ✅ Zero critical errors remaining
- ✅ 100% documentation accuracy
- ✅ DR successfully tested
- ✅ Owner satisfaction achieved

---

## 6. ROLES & RESPONSIBILITIES

### 6.1 Owner (qui3tly)

**Responsibilities**:
- Review and approve all deliverables
- Test procedures in production
- Provide feedback and requirements clarification
- Execute high-risk changes (SSH-impacting)
- Final acceptance sign-off

**Time Commitment**: 2-4 hours per week (reviews, testing)

### 6.2 Implementation Partner (Lucky Luke 🤠)

**Responsibilities**:
- Execute all implementation tasks
- Create documentation and scripts
- Test all procedures
- Follow governance rules
- Track progress and report status
- Escalate risks and blockers

**Time Commitment**: 15-20 hours per week (implementation)

### 6.3 Collaboration Model

**Daily**:
- Progress updates in memories.jsonl
- Task completion tracking in TODO.md

**Weekly**:
- Phase review meeting
- Progress report
- Next week planning

**Per Phase**:
- Deliverable review
- Acceptance testing
- Approval for next phase

---

## 7. PRICING & BUDGET

**Implementation Partner**: AI Agent (No Cost)  
**Infrastructure**: Already operational (No Additional Cost)  
**Total Project Cost**: **$0** 🎉

**Value Delivered**:
- World-class infrastructure documentation
- Enhanced operational procedures
- Improved security posture
- Complete automation coverage
- Professional-grade deliverables

**ROI**: **Infinite** (Zero cost, massive value)

---

## 8. TERMS & CONDITIONS

### 8.1 Governance Compliance

All work must comply with:
- [.governance/RULES.md](../../.governance/RULES.md)
- [.governance/WORKFLOWS.md](../../.governance/WORKFLOWS.md)
- [.governance/PRINCIPLES.md](../../.governance/PRINCIPLES.md)

**Non-negotiable**:
- NO patches (permanent fixes only)
- SSH port 1006 protection (owner execution only)
- Backup before mutation
- Approval before destructive actions

### 8.2 Change Management

**7-Step Workflow** (MANDATORY):
1. **Investigate** - Read configs, understand current state
2. **Test** - Dry-run or isolated test
3. **Backup** - Timestamped copy to ~/.copilot/backups/
4. **Confirm** - Present plan, get approval
5. **Execute** - Run with logging
6. **Verify** - Health checks, log tails
7. **Document** - Update memories.jsonl, push to GitHub

### 8.3 Acceptance Criteria

**Phase Acceptance**:
- All tasks completed per checklist
- All deliverables tested
- Owner approval documented
- Grade target achieved

**Project Acceptance**:
- Overall grade A+++ (10.0)
- All 47 issues resolved
- Zero critical errors
- Owner satisfaction sign-off

### 8.4 Warranty

**Lucky Luke 🤠 Guarantees**:
- Technical accuracy of documentation
- Working procedures (tested)
- Scripts execute without errors
- Ansible playbooks are idempotent
- No production disruptions (when governance followed)

**Limitations**:
- Third-party service changes
- Hardware failures
- Owner configuration changes
- External attacks/threats

---

## 9. EVALUATION CRITERIA

### 9.1 Proposal Requirements

**Implementation Partner Must Provide**:
1. ✅ Confirmation of understanding (this RFP)
2. ✅ Commitment to timeline (30 days)
3. ✅ Acceptance of governance rules
4. ✅ Agreement to success criteria

### 9.2 Selection Criteria

| Criterion | Weight | Lucky Luke Score |
|-----------|--------|------------------|
| Technical Capability | 30% | ⭐⭐⭐⭐⭐ (Proven) |
| Understanding of Infrastructure | 25% | ⭐⭐⭐⭐⭐ (Complete audit done) |
| Governance Compliance | 20% | ⭐⭐⭐⭐⭐ (Built-in) |
| Communication & Documentation | 15% | ⭐⭐⭐⭐⭐ (Excellent) |
| Cost | 10% | ⭐⭐⭐⭐⭐ (Free!) |
| **TOTAL** | **100%** | **⭐⭐⭐⭐⭐ (100/100)** |

---

## 10. NEXT STEPS

### 10.1 Proposal Submission

**Lucky Luke 🤠 Response**:
- Review this RFP
- Confirm understanding and acceptance
- Propose start date (2026-01-22)

### 10.2 Project Kickoff

Upon approval:
1. Create detailed task checklists (TODO.md per phase)
2. Set up progress tracking (reports/PROGRESS.md)
3. Begin Phase 1: Quick Wins

### 10.3 Contract Award

**Status**: **APPROVED** ✅  
**Partner**: Lucky Luke 🤠  
**Start Date**: 2026-01-22  
**Authority**: qui3tly (Owner & Founder)

---

## APPENDICES

### Appendix A: Audit Reports

All baseline data from 2026-01-22 external audit:
- [AUDIT_REPORT.md](../../.reports/external-audit-20260122-external/AUDIT_REPORT.md) (1,064 lines)
- [DOCUMENTATION_GAPS.md](../../.reports/external-audit-20260122-external/DOCUMENTATION_GAPS.md) (971 lines)
- [SECURITY_FINDINGS.md](../../.reports/external-audit-20260122-external/SECURITY_FINDINGS.md) (740 lines)
- [QUICK_WINS.md](../../.reports/external-audit-20260122-external/QUICK_WINS.md) (539 lines)
- [PRIORITY_MATRIX.md](../../.reports/external-audit-20260122-external/PRIORITY_MATRIX.md) (427 lines)

### Appendix B: Current Infrastructure

**Servers**:
- Master (quietly.its.me): 213.136.68.108, Tailnet 100.64.0.1, 21 containers
- Lady (quietly.online): 207.180.251.111, Tailnet 100.64.0.2, 22 containers (18 Mailcow)

**Services**: Traefik, Portainer, Pi-hole, Authelia, CrowdSec, Grafana, Prometheus, Loki, Alertmanager, Headscale, Mailcow (Lady), plus more

**Network**: Tailscale mesh (Headscale), WireGuard P2P (Master↔EdgeRouter)

### Appendix C: Governance Files

- [.governance/PRINCIPLES.md](../../.governance/PRINCIPLES.md)
- [.governance/RULES.md](../../.governance/RULES.md)
- [.governance/WORKFLOWS.md](../../.governance/WORKFLOWS.md)
- [.governance/SECRETS.md](../../.governance/SECRETS.md)

---

**RFP Issued**: 2026-01-22  
**Issued By**: qui3tly (Owner & Founder)  
**For**: Lucky Luke 🤠 (AI Implementation Partner)  
**Project**: Preproduction qui3tly.cloud Excellence Initiative  
**Status**: **APPROVED FOR IMPLEMENTATION** ✅

---

*Let's fly to the moon* 🚀
