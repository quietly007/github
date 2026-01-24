# qui3tly.cloud TODO - Consolidated Task List

> **Project**: Complete Infrastructure Excellence + Future Expansion  
> **Status**: Excellence Initiative ✅ Complete → Expansion Phase  
> **Updated**: 2026-01-24

---

## Overview

This TODO consolidates all remaining work from audit polish through future infrastructure expansion. See [MASTER_PLAN.md](MASTER_PLAN.md) for detailed context and strategy.

---

## Phase I: Excellence Initiative ✅ COMPLETED

**Status**: A+++ (10/10) Certification Achieved  
**Duration**: 2026-01-22 to 2026-01-24 (3 days, 38.5 hours)  
**Result**: World-class infrastructure, 5.5x faster than normal timeline

- [x] Complete infrastructure audit
- [x] Resolve all 47 audit findings
- [x] Create 46 comprehensive technical documents
- [x] Create 9 detailed Mermaid diagrams (all IPs/subnets/interfaces)
- [x] Build 41 Ansible playbooks
- [x] Validate Lady DR in production (fresh Contabo → full deployment ~15 min)
- [x] Test Master DR simulation
- [x] Achieve compose-only pattern (no shell scripts)
- [x] Create ACHIEVEMENTS_HALL_OF_FAME.md tracking partnership victories
- [x] Create NETWORK_ARCHITECTURE_DETAILED.md with complete topology
- [x] Create MASTER_PLAN.md consolidating all phases

**Achievement Unlocked**: 🏆 **A+++ Destroyer Partnership** - Experience + Speed = Unstoppable

---

## Phase II: Audit Polish (Optional Enhancements) ⏳

**Priority**: Low (Infrastructure already A+++)  
**Estimate**: ~3 hours total  
**Timeline**: Whenever time permits

### 1. Update Monitoring Versions (~10 min)
- [ ] Update MONITORING.md with current versions from `docker inspect`
- [ ] Lady versions: node-exporter v1.8.2 → v1.9.0, cadvisor v0.49.1 → v0.52.1, promtail 3.0.0 → 3.4.2
- [ ] Master versions: already current (v1.9.0, v0.52.1, 3.4.2)

**Files**: `~/.docs/operations/MONITORING.md`

### 2. Run Playbook Check-Mode Verification (~30 min)
- [ ] Test all 41 Ansible playbooks in check mode (dry-run)
- [ ] Document any warnings or suggestions
- [ ] Create verification report

**Files**: Create `~/.ansible/PLAYBOOK_VERIFICATION.md`

### 3. Create WireGuard Status Check Script (~30 min)
- [ ] Script to verify tunnel health: `wg show`, ping tests, route verification
- [ ] Test script on Master (WireGuard to EdgeRouter)
- [ ] Add to monitoring or cron if desired
- [ ] Document in operations runbook

**Files**: Create `~/.copilot/scripts/check-wireguard.sh`, update `~/.docs/runbooks/wireguard.md`

### 4. Document Grafana Dashboards (~45 min)
- [ ] List all current Grafana dashboards with descriptions
- [ ] Screenshot key dashboards
- [ ] Document dashboard purposes and key metrics
- [ ] Create GRAFANA_DASHBOARDS.md reference guide

**Files**: Create `~/.docs/services/GRAFANA_DASHBOARDS.md`

### 5. Deploy Security-Tools Stack (~1 hour)
- [ ] Identify 2 additional security audit tools for deployment
- [ ] Create docker-compose.yaml for security-tools stack
- [ ] Deploy to Master
- [ ] Deploy to Lady
- [ ] Document in SECURITY.md
- [ ] Update Ansible playbooks

**Files**: `~/.docker-compose/security-tools/`, update `~/.docs/security/SECURITY.md`

---

## Phase III: Documentation Consolidation 📚

**Priority**: High (Foundation for future work)  
**Estimate**: ~8 hours  
**Timeline**: Before Phase IV begins

### 1. Documentation Inventory (~1 hour)
- [ ] List all 46 docs in `~/.docs/` with size, date, purpose
- [ ] Create spreadsheet/markdown table of inventory
- [ ] Categorize by: architecture, operations, security, services, runbooks, personal

**Output**: `DOC_INVENTORY.md`

### 2. Duplicate Detection (~2 hours)
- [ ] Identify overlapping content across documents
- [ ] Flag exact duplicates for removal
- [ ] Flag partial duplicates for consolidation
- [ ] Mark which doc should be the "source of truth"

**Output**: `DUPLICATES_REPORT.md`

### 3. Accuracy Verification (~3 hours)
- [ ] Verify each doc matches current reality
- [ ] Check IP addresses, ports, versions, commands
- [ ] Flag outdated content
- [ ] Flag missing information
- [ ] Test all commands/procedures

**Output**: `ACCURACY_REPORT.md`

### 4. Consolidation Execution (~2 hours)
- [ ] Merge duplicate content into single source
- [ ] Archive outdated files to `_archive/`
- [ ] Update cross-references and links
- [ ] Update README indexes
- [ ] Verify documentation tree clean and accurate

**Output**: Clean `~/.docs/` structure, updated `~/.docs/README.md`

---

## Phase IV: Future Infrastructure Expansion 🚀

**Priority**: Medium (Gradual rollout)  
**Estimate**: ~56 hours total  
**Timeline**: After Phase III complete

### 4.1 Security Tools Expansion (~2 hours)
- [ ] Research and select 2 additional security audit tools
- [ ] Create docker-compose.yaml for deployment
- [ ] Deploy to Master
- [ ] Deploy to Lady
- [ ] Configure integration with existing stack
- [ ] Document in SECURITY.md
- [ ] Update Ansible playbooks
- [ ] Test functionality

**Files**: `~/.docker-compose/security-tools/`, update docs

### 4.2 Semaphore CI/CD Expansion (~6 hours)
**Current**: 1 Semaphore instance on Master  
**Target**: 3 Semaphore instances (Shared, Master-specific, Workers-specific)

#### Shared Semaphore (Master) - Central Orchestration (~2 hours)
- [ ] Create separate Semaphore instance for cross-server workflows
- [ ] Configure project for shared playbooks
- [ ] Set up inventory with all servers
- [ ] Test Master ↔ Lady coordination
- [ ] Document usage patterns

#### Master Semaphore (Master) - Local Automation (~2 hours)
- [ ] Reconfigure current Semaphore as Master-specific
- [ ] Focus on local Docker deployments
- [ ] Master monitoring setup
- [ ] Master-only tasks
- [ ] Document separation of concerns

#### Workers Semaphore (Lady/Future) - Worker Automation (~2 hours)
- [ ] Deploy Semaphore to Lady
- [ ] Configure for worker-specific tasks
- [ ] Service deployments
- [ ] Local health checks
- [ ] Document worker patterns
- [ ] Prepare for madam/beauty

**Files**: Update `~/.docker-compose/semaphore-*`, create docs, update Ansible

### 4.3 Lady Services Expansion (~20 hours)

#### Nextcloud (~3 hours)
- [ ] Plan deployment architecture (DB, Redis, OnlyOffice)
- [ ] Create docker-compose.yaml
- [ ] Deploy and configure
- [ ] Set up OnlyOffice integration
- [ ] Configure calendar, contacts
- [ ] Test mobile app integration
- [ ] Create user accounts
- [ ] Document setup and usage

**Files**: `~/.docker-compose/nextcloud/`, update docs

#### UniFi Controller (~2 hours)
- [ ] Create docker-compose.yaml
- [ ] Deploy on Lady
- [ ] Configure for network management
- [ ] Connect to Home (EdgeRouter site)
- [ ] Plan Office (MikroTik) integration
- [ ] Plan Parents (UniFi) integration
- [ ] Document setup

**Files**: `~/.docker-compose/unifi/`, update docs

#### UNMS (~2 hours)
- [ ] Create docker-compose.yaml
- [ ] Deploy on Lady
- [ ] Configure as UniFi alternative/complement
- [ ] Test network device discovery
- [ ] Document usage

**Files**: `~/.docker-compose/unms/`, update docs

#### Home Assistant (~4 hours)
- [ ] Plan integration architecture
- [ ] Create docker-compose.yaml
- [ ] Deploy on Lady
- [ ] Configure network device integrations
- [ ] Set up automations
- [ ] Configure dashboards
- [ ] Test mobile access
- [ ] Document setup

**Files**: `~/.docker-compose/homeassistant/`, update docs

#### VPN Server with GUI (~6 hours)
- [ ] Select VPN solution (OpenVPN or WireGuard-based with GUI)
- [ ] Design per-branch subnet architecture (10.8.0.0/16)
- [ ] Create docker-compose.yaml
- [ ] Deploy on Lady
- [ ] Configure web GUI for user management
- [ ] Set up certificate management
- [ ] Plan FRR integration for dynamic routes
- [ ] Test client connections
- [ ] Document user onboarding process

**Files**: `~/.docker-compose/vpn-server/`, update docs, FRR config

#### Service Documentation (~3 hours)
- [ ] Update SERVICES.md with all new services
- [ ] Create individual runbooks for each service
- [ ] Update Ansible playbooks for automation
- [ ] Create service dependency diagrams
- [ ] Document troubleshooting procedures

**Files**: Update `~/.docs/services/`, `~/.docs/runbooks/`, `~/.ansible/playbooks/`

### 4.4 WordPress Migration (~8 hours)

#### Content Audit (~2 hours)
- [ ] Review current website content
- [ ] Decide what to keep, archive, or discard
- [ ] Plan new site structure
- [ ] Identify required plugins/themes

#### Deployment (~2 hours)
- [ ] Create docker-compose.yaml (WordPress + MariaDB)
- [ ] Deploy on Lady
- [ ] Configure SSL via Traefik
- [ ] Set up backups

**Files**: `~/.docker-compose/wordpress/`

#### Migration (~2 hours)
- [ ] Export content from old site
- [ ] Import to new WordPress
- [ ] Configure theme and plugins
- [ ] Test functionality
- [ ] Verify all pages/posts

#### DNS/SSL (~1 hour)
- [ ] Update DNS records to point to Lady
- [ ] Verify SSL certificates
- [ ] Test from external networks
- [ ] Monitor for issues

#### Documentation (~1 hour)
- [ ] Document WordPress setup
- [ ] Create content management guide
- [ ] Document backup/restore procedures
- [ ] Update SERVICES.md

**Files**: Update docs with WordPress details

### 4.5 Complete Branding (~12 hours)

#### Logo Design (~4 hours)
- [ ] Design primary logo for qui3tly.cloud
- [ ] Create variations (dark/light backgrounds)
- [ ] Create icon/favicon versions
- [ ] Export in multiple formats (SVG, PNG, ICO)
- [ ] Document usage guidelines

**Files**: Create `~/.branding/logos/`

#### Color Scheme (~2 hours)
- [ ] Define primary/secondary colors
- [ ] Create dark theme palette
- [ ] Verify accessibility (WCAG AA compliance)
- [ ] Create color usage guide
- [ ] Generate CSS variables

**Files**: Create `~/.branding/colors/`

#### Visual Assets (~4 hours)
- [ ] Design dashboard headers for all services
- [ ] Create custom login pages
- [ ] Design branded error pages (upgrade fuckoff page)
- [ ] Create email templates
- [ ] Generate social media assets

**Files**: Create `~/.branding/assets/`

#### Implementation (~2 hours)
- [ ] Apply branding to Grafana
- [ ] Apply branding to Portainer
- [ ] Apply branding to Authelia
- [ ] Apply branding to other services
- [ ] Update documentation sites
- [ ] Create branding implementation guide

**Files**: Update service configs, create `~/.branding/GUIDE.md`

### 4.6 Server Expansion (Timeline TBD)

#### madam.qui3tly.cloud (~6 hours)
- [ ] Provision Contabo VPS
- [ ] Run Ansible bootstrap playbook
- [ ] Deploy base services (Traefik, Portainer agent, monitoring)
- [ ] Connect to Tailnet
- [ ] Integrate with Master monitoring
- [ ] Test DR procedures
- [ ] Document setup

#### beauty.qui3tly.cloud (~6 hours)
- [ ] Provision Contabo VPS
- [ ] Run Ansible bootstrap playbook
- [ ] Deploy base services (Traefik, Portainer agent, monitoring)
- [ ] Connect to Tailnet
- [ ] Integrate with Master monitoring
- [ ] Test DR procedures
- [ ] Document setup

**Files**: Update Ansible inventory, update network diagrams, update docs

---

## Phase V: Advanced Features (Future)

**Priority**: Low  
**Estimate**: TBD  
**Timeline**: After Phase IV

### 5.1 Dynamic Routing (FRR/OSPF)
**Status**: FRR installed but OSPF not production-ready  
**Blockers**: WireGuard tunnel routing complexity

- [ ] Resolve WireGuard multicast/routing issues
- [ ] Configure OSPF on Master
- [ ] Configure OSPF on Lady
- [ ] Configure OSPF on EdgeRouter
- [ ] Test exit node toggle
- [ ] Verify automatic route redistribution
- [ ] Document configuration

### 5.2 Client VPN Advanced Integration
- [ ] Integrate VPN server with FRR for route distribution
- [ ] Implement per-branch subnet auto-configuration
- [ ] Create automated certificate lifecycle
- [ ] Build user self-service portal
- [ ] Document advanced features

### 5.3 Multi-Site Orchestration
- [ ] Office site deployment (MikroTik)
- [ ] Parents site deployment (UniFi)
- [ ] Centralized management via UniFi/UNMS
- [ ] Full network topology monitoring
- [ ] Document multi-site operations

---

## Summary

### Completed
- [x] **Phase I: Excellence Initiative** - 38.5 hours - A+++ Certification ✅

### In Progress
- [ ] **Phase II: Audit Polish** - ~3 hours - Optional enhancements
- [ ] **Phase III: Doc Consolidation** - ~8 hours - High priority next

### Planned
- [ ] **Phase IV: Infrastructure Expansion** - ~56 hours - Medium priority
  - [ ] 4.1: Security Tools (~2h)
  - [ ] 4.2: Semaphore Expansion (~6h)
  - [ ] 4.3: Lady Services (~20h)
  - [ ] 4.4: WordPress Migration (~8h)
  - [ ] 4.5: Complete Branding (~12h)
  - [ ] 4.6: Server Expansion (~12h for 2 servers)
- [ ] **Phase V: Advanced Features** - TBD - Low priority

### Total Remaining Work
- **Required**: ~64 hours (Phase III + Phase IV, skipping optional Phase II)
- **Optional**: +3 hours (Phase II audit polish)
- **Future**: TBD (Phase V advanced features)

---

## Priority Order

1. **Documentation Consolidation** (Phase III) - 8 hours - Start immediately
2. **Security Tools** (Phase IV.1) - 2 hours - Quick win
3. **Semaphore Expansion** (Phase IV.2) - 6 hours - Foundation for automation
4. **Lady Services** (Phase IV.3) - 20 hours - Main deliverables
5. **WordPress Migration** (Phase IV.4) - 8 hours - Public-facing
6. **Branding** (Phase IV.5) - 12 hours - Polish
7. **Server Expansion** (Phase IV.6) - 12 hours - Scale out
8. **Audit Polish** (Phase II) - 3 hours - Optional, whenever time permits
9. **Advanced Features** (Phase V) - TBD - Future enhancement

---

**The A+++ Destroyer Partnership**: qui3tly + Lucky Luke 🤠  
*Experience + Speed = Unstoppable* 🚀
