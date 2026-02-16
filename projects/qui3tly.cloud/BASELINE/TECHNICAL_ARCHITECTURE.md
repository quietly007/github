# TECHNICAL ARCHITECTURE
## qui3tly.cloud Current Infrastructure

**Document Version**: 1.0  
**Date**: February 15, 2026  
**Based On**: Comprehensive Audit 2026-02-15 (452 docs, 1,329 memories, 64 containers analyzed)  
**Purpose**: Document the CURRENT state of infrastructure as foundation for improvements

---

## 1. INFRASTRUCTURE OVERVIEW

### 1.1 High-Level Architecture

```
                    Internet
                       │
            ┌──────────┴──────────┐
            │                     │
    Master Server          Lady Server
    (Control Plane)     (Worker + Business Apps)
    quietly.its.me        quietly.online
    213.136.68.108        207.180.251.111
    25 containers          39 containers
            │                     │
            └─────── VPN ─────────┘
              Tailscale Mesh
              100.64.0.0/10
```

**Total**: 64 containers across 2 VPS servers  
**Grade**: 72/100 (C+) - Working infrastructure with documentation debt  
**Target**: 90/100 (A+++) - Production ready

### 1.2 Servers

| Server | Role | IP | Provider | Specs | Containers |
|--------|------|----|---------| ------|-----------|
| **Master** | Control plane, monitoring, security | 213.136.68.108 | Contabo Germany | 12vCPU, 48GB RAM, 1TB NVMe SSD, Debian 12 | 25 |
| **Lady** | Worker node, business apps, email | 207.180.251.111 | Contabo Germany | 12vCPU, 48GB RAM, 1TB NVMe SSD, Debian 12 | 39 |
| **Mac** | Client device, testing | 100.64.0.3 (VPN) | Local | Mac Mini | 0 |

**Total VPS**: 2 production servers  
**OS**: Debian 12 (Bookworm) on both servers  
**Datacenter**: Contabo, Germany (single datacenter currently)

---

## 2. NETWORK ARCHITECTURE

### 2.1 Network Topology

**Public IPs**:
- Master: 213.136.68.108
- Lady: 207.180.251.111

**VPN Networks**:
- Tailscale mesh: 100.64.0.0/10
  - Master: 100.64.0.1
  - Lady: 100.64.0.2
  - Mac: 100.64.0.3
- WireGuard P2P: 10.10.0.0/30
  - Master: 10.10.0.1
  - EdgeRouter (home gateway): 10.10.0.2

**Domains**:
- qui3tly.cloud → Brand/marketing domain
- quietly.its.me → Primary services (grafana.quietly.its.me, etc.)
- quietly.online → Email domain (user@quietly.online)

### 2.2 VPN Design

**Tailscale Mesh VPN** (Primary):
- Control plane: Headscale v0.27.1 (NATIVE systemd service on Master)
- Mesh topology: Every node can reach every other node directly
- DERP relay: Master acts as relay when direct connection impossible
- Subnet routing: Master routes to home network via WireGuard

**WireGuard P2P Tunnel** (Secondary):
- Purpose: Backup connection to home network (EdgeRouter X)
- Topology: Point-to-point (Master ↔ EdgeRouter)
- Use case: Failover, management access, home network access

**DNS Strategy**:
- Pi-hole on Master (100.64.0.1): DNS filtering, split-horizon DNS
- CRITICAL: /etc/resolv.conf points to 1.1.1.1 (NOT Pi-hole)
- Reason: Prevents DNS bootstrap circular dependency (Headscale ↔ Pi-hole)
- Immutable: `chattr +i /etc/resolv.conf` to prevent overwrites

### 2.3 Critical Network Constraints

**CONSTRAINT 1: Headscale NATIVE (NOT Docker)**
- Runs as systemd service: `headscale.service`
- Version: v0.27.1
- Listens on: 0.0.0.0:8080 (HTTP control plane), 0.0.0.0:3478/udp (DERP relay)
- Why: Avoids Docker networking complexity for VPN control plane
- Status: Working perfectly (~27 entries in memories)

**CONSTRAINT 2: NO OSPF / NO FRR**
- History: OSPF (FRRouting) attempted Jan 11-13, 2026
- Problem: Garbage routes (0.0.0.0/24 from Docker networks)
- Root cause: "redistribute connected" without filtering
- User quote: "CCNA Day 1: Never redistribute without filtering!"
- Decision: Removed FRR completely Jan 13, 2026
- Current: Static routes + Tailscale subnet routing only
- **PERMANENT**: Never introduce OSPF/FRR again

**CONSTRAINT 3: DNS Bootstrap Problem FIXED**
- History: Jan 17, 2026 - 363 Headscale crashes
- Problem: Circular dependency (Headscale needs DNS → Pi-hole needs Headscale)
- Fix: Immutable /etc/resolv.conf → 1.1.1.1 (Cloudflare)
- Fix: SystemD boot order checks (ExecStartPre DNS validation)
- Status: Fixed and documented as MANDATORY constraint

**CONSTRAINT 4: Postfix is THE ONLY MTA**
- Only one Mail Transfer Agent in infrastructure: Postfix (in Mailcow on Lady)
- No other MTAs allowed (prevents mail routing conflicts)
- All mail routes through Postfix on Lady

---

## 3. SERVICE DISTRIBUTION

### 3.1 Master Server Services (25 containers)

**Infrastructure & Networking**:
- **Traefik** v3.6.6: Reverse proxy, SSL termination, 31 routers
- **Headscale** v0.27.1: VPN control plane (NATIVE systemd, NOT container)
- **Pi-hole**: DNS filtering, split-horizon DNS, ad blocking
- **cloudflared**: Cloudflare Tunnel (optional external access)

**Security**:
- **CrowdSec**: IPS/IDS, 24,000+ banned IPs, community rules
- **bouncer-traefik**: CrowdSec integration with Traefik
- **Authelia**: 2FA authentication, SSO, LDAP backend
- **fail2ban**: Automated IP blocking (SSH, Traefik)

**Monitoring Stack**:
- **Prometheus**: Metrics collection, 30-day retention
- **Grafana**: Visualization, 8 dashboards defined
- **Loki**: Log aggregation, 30-day retention
- **Alertmanager**: Alert routing, Gotify webhooks
- **Promtail**: Log shipping agent (Master + Lady)
- **node-exporter**: System metrics (CPU, RAM, disk, network)
- **cAdvisor**: Container metrics (per-container resource usage)
- **Blackbox exporter**: Endpoint testing (HTTP, TCP, ICMP)

**Management & Utilities**:
- **Portainer** 2.33.6: Container management UI
- **Semaphore**: Ansible UI for automation
- **Uptime Kuma**: Uptime monitoring, status pages
- **Gotify**: Push notifications (alerts, events)
- **Ntfy**: Alternative notification service
- **IT-Tools**: Utility tools collection
- **admin-panel**: Custom admin dashboard

**Total Master**: 25 containers + 1 native service (Headscale)

### 3.2 Lady Server Services (39 containers)

**Email Stack (Mailcow - 18 containers)**:
- **Postfix**: MTA (Mail Transfer Agent) - THE ONLY MTA
- **Dovecot**: IMAP server, mailbox storage
- **SOGo**: Webmail, calendars, contacts, ActiveSync
- **Rspamd**: Spam filtering, DKIM signing
- **Redis**: Caching for Mailcow
- **MariaDB**: Database for Mailcow
- **Memcached**: Session caching
- **ClamAV**: Antivirus scanning
- **Solr**: Full-text search
- **Olefy**: Malware detection
- **Watchdog**: Service health monitoring
- **Acme-mailcow**: Let's Encrypt SSL certificates
- **Nginx-mailcow**: Web interface
- **Netfilter-mailcow**: Firewall rules
- **Dockerapi-mailcow**: Docker API proxy
- **Unbound-mailcow**: DNS resolver
- **IPsec-mailcow**: VPN for mobile devices
- **Ofelia-mailcow**: Job scheduler

**Business Applications**:
- **Nextcloud**: File sync, share, collaboration
- **OnlyOffice**: Office suite (partially configured)
- **Odoo**: Business management, accounting (deployed, needs config)
- **UniFi Controller**: UniFi network management
- **UISP**: ISP network management

**Monitoring Agents**:
- **node-exporter**: System metrics
- **cAdvisor**: Container metrics
- **promtail**: Log shipping to Master Loki
- **CrowdSec agent**: Security events to Master CrowdSec

**Total Lady**: 39 containers (18 Mailcow + 21 others)

### 3.3 Service Distribution Strategy

**Master Server Philosophy**:
- Control plane and infrastructure services
- Monitoring hub (collects metrics from all servers)
- Security hub (CrowdSec, Authelia, fail2ban)
- Management tools (Portainer, Semaphore)
- SINGLE POINT: Some services (DNS, VPN control, authentication)

**Lady Server Philosophy**:
- Worker node for business applications
- Email server (complete Mailcow stack)
- Customer-facing services (Nextcloud, office, accounting)
- Monitoring agents only (report to Master)

**Rationale**:
- Separation of concerns (infrastructure vs business apps)
- Easier troubleshooting (know which server has what)
- Future scale: Add more worker nodes (Beauty, Madam planned)
- DR: Can rebuild Master in 15 minutes, Lady takes longer but less critical

**Single Points of Failure** (Current):
- ⚠️ DNS (Pi-hole only on Master)
- ⚠️ Authentication (Authelia only on Master)
- ⚠️ VPN control (Headscale only on Master)
- ✅ Email (only on Lady, but DR tested)
- ✅ Monitoring: Agents on both servers, can rebuild Master hub quickly

---

## 4. STORAGE & DATA

### 4.1 Docker Organization (MANDATORY)

**Directory Structure** (Zero Tolerance Policy):
```
~/.docker-compose/{service}/docker-compose.yaml    ← Compose file ONLY
~/.docker/{service}/config/                        ← Configuration files
~/.docker/{service}/data/                          ← Persistent data
~/.secrets/{service}/                              ← Secrets (600 perms)
```

**Enforcement**:
- DOCKER_ORGANIZATION_MANDATORY.md (567 lines, zero tolerance)
- Violated structure = STOP immediately, fix before proceeding
- Current compliance: 100% (all 64 containers follow this structure)

### 4.2 GitHub Organization (MANDATORY)

**Two-Repository Model**:
- **quietly007/master**: Server-specific files (Master server ~/)
- **quietly007/github**: Shared content (symlinked to ~/.github/)

**Symlinks** (Single Source of Truth):
```
~/.governance → ~/.github/governance/
~/.ansible → ~/.github/ansible/
~/.copilot-shared → ~/.github/copilot-shared/
~/projects → ~/.github/projects/
```

**Grade**: A+ (95.6/100) per GitHub audit Feb 9, 2026

**Rationale**:
- Server-specific files in server repo (master)
- Shared files in github repo (governance, ansible, projects)
- Symlinks for convenient access
- Single commit location (no duplicate commits)

### 4.3 Secrets Management

**Location**: `~/.secrets/{service}/`
**Permissions**: 
- Directory: 700 (drwx------)
- Files: 600 (-rw-------)

**Enforcement**:
- .gitignore prevents Git commits
- Ansible validates permissions
- Zero tolerance: Secrets in Git = project failure

**Backup**: Secrets backed up separately (not in GitHub)

### 4.4 Data Volumes

**Master Server**:
- Prometheus data: Time series metrics (30 days)
- Loki data: Logs (30 days)
- Grafana data: Dashboards, users, settings
- Portainer data: Stacks, configurations
- Uptime Kuma data: Check history

**Lady Server**:
- Mailcow data: 18 container volumes (emails, databases, configs)
- Nextcloud data: Files, database
- Odoo data: Business data, database
- UniFi/UISP data: Network configurations

**Total Storage Used**: ~150-200 GB of 800 GB total (both servers)

---

## 5. SECURITY ARCHITECTURE

### 5.1 Defense in Depth (5 Layers)

**Layer 1: Network Perimeter**
- UFW firewall (Master + Lady)
  - Master: 22 (SSH), 80/443 (HTTP/HTTPS), 8080 (Headscale), 3478/udp (DERP)
  - Lady: 22 (SSH), 25/587 (SMTP), 993 (IMAP), 80/443 (HTTP/HTTPS)
- CrowdSec IPS/IDS: 24,000+ banned IPs, community rules updated regularly
- fail2ban: SSH (both servers), Traefik auth (Master only, Lady missing)

**Layer 2: Application Access Control**
- Traefik reverse proxy: Entry point for all HTTP/HTTPS traffic
- Authelia 2FA: Middleware on sensitive services
- VPN-only middleware: Public access blocked (403), VPN access allowed

**Layer 3: Authentication & Authorization**
- Authelia: LDAP/file backend, 2FA available
- Per-service authentication: Grafana, Portainer, Nextcloud, etc.
- SSH key-only (password auth disabled)

**Layer 4: Secrets Management**
- All secrets in ~/.secrets/ (700/600 permissions)
- No secrets in Git (.gitignore enforced)
- Docker secrets for sensitive service configs

**Layer 5: Monitoring & Response**
- CrowdSec: Real-time threat detection and automated blocking
- Alertmanager: Critical alerts to Gotify
- Log aggregation: All logs in Loki for analysis
- Uptime monitoring: Detects service issues

### 5.2 SSL/TLS Management

**Certificate Authority**: Let's Encrypt (via Traefik ACME)
**Domains**: 
- *.quietly.its.me (wildcard)
- *.quietly.online (wildcard)
- Individual certificates for services

**Renewal**: Automatic (Traefik handles)
**Validation**: HTTP-01 challenge
**Status**: All certificates valid, auto-renewing

### 5.3 Security Gaps (Current)

**Identified**:
1. ⚠️ Lady fail2ban incomplete: Missing traefik-auth and recidive jails
2. ⚠️ Some services return 404/500 (investigation needed)
3. ⚠️ Authelia configuration could be tightened (some services unprotected)

**Planned in Phase 06**:
- Complete Lady fail2ban configuration
- Security audit (port scanning, authentication testing)
- Authelia validation (ensure 2FA on all sensitive services)
- Secrets audit (verify all in ~/.secrets/ with correct permissions)

---

## 6. MONITORING & OBSERVABILITY

### 6.1 Metrics Collection

**Prometheus** (on Master):
- Scrapes: node-exporter (Master + Lady), cAdvisor (Master + Lady), service exporters
- Retention: 30 days
- Storage: Time series database (~10-15 GB)

**Exporters**:
- **node-exporter**: System metrics (CPU, RAM, disk, network)
- **cAdvisor**: Container metrics (per-container resources, restart counts)
- **mysqld-exporter**: MariaDB metrics (Mailcow)
- **Blackbox exporter**: Endpoint testing (HTTP status, SSL expiry, TCP ports)

**Metrics Types**:
- Infrastructure: CPU, RAM, disk, network bandwidth
- Containers: Resource usage, restart counts, health status
- Services: Response times, error rates, uptime
- Security: CrowdSec bans, fail2ban blocks

### 6.2 Log Aggregation

**Loki** (on Master):
- Collects: Docker container logs from Master + Lady
- Shipper: Promtail (runs on both servers)
- Retention: 30 days
- Storage: ~5-10 GB

**Log Sources**:
- All container stdout/stderr
- Systemd logs (Headscale, Docker, etc.)
- Application logs (Traefik access, Mailcow, etc.)

**Analysis**:
- Grafana dashboards: Error rates, trends
- LogQL queries: Search and filter logs
- Alerting: Error spike detection

### 6.3 Visualization

**Grafana** (on Master):
- 8 Dashboards Defined:
  1. Infrastructure Overview: All servers, containers
  2. Server Details: Master, Lady individual
  3. Container Monitoring: Resource usage per container
  4. Service Health: Uptime, response times
  5. Log Analysis: Error rates, trends
  6. Performance Trends: 30-day historical view
  7. Alerting Status: Active alerts, history
  8. Security Dashboard: CrowdSec, fail2ban stats

**Access**: grafana.quietly.its.me (VPN-only, Authelia 2FA)

### 6.4 Alerting

**Alertmanager** (on Master):
- Routes: Critical → Gotify (push notification)
- Rules: 51 defined in CrowdSec alone, plus custom Prometheus rules
- Severity levels: Critical, warning, info
- Silencing: Available for maintenance windows

**Gotify** (on Master):
- Push notifications to mobile devices
- Alert categories: Infrastructure, security, services
- Priority levels: High (critical), normal

**Uptime Kuma** (on Master):
- HTTP/HTTPS endpoint checks
- TCP port checks
- Ping checks
- Status pages (public or VPN-only)

---

## 7. DISASTER RECOVERY & BACKUP

### 7.1 Backup Strategy

**GitHub** (Primary Backup):
- Real-time commits: Configurations, compose files, docs
- Repositories: quietly007/master, quietly007/github
- RPO: 5 minutes (commit frequency)

**Contabo Snapshots** (Secondary Backup):
- Automated: Daily snapshots
- Retention:7 days
- Full server image

**Manual Backups**:
- On-demand snapshots before major changes
- External storage: Occasional manual backup to external HDD

### 7.2 Disaster Recovery Methods (All Tested)

**Method 1: Docker Stack Redeploy**
- Use case: Single service failure
- Process: `docker compose up -d` from compose file
- RTO: 2 minutes
- Test status: 100% success

**Method 2: Ansible Full Restore**
- Use case: Server crash, need full rebuild
- Process: Server-specific playbooks (master/, lady/)
- Playbooks: 46 total (22 master + 17 lady + 7 shared)
- RTO: 15 minutes
- Test status: 100% success

**Method 3: Complete Server Rebuild**
- Use case: Catastrophic failure, new VPS needed
- Process: Fresh VPS → bootstrap → restore from GitHub
- RTO: 45 minutes
- Test status: 100% success

**Test History**:
- Last tested: Jan 23, 2026
- Success rate: 100% (86/86 tests per memories)
- Frequency: Monthly testing scheduled

### 7.3 Recovery Time Objectives (RTO)

- **Critical services** (DNS, VPN, monitoring): 15 minutes
- **Business services** (email, Nextcloud): 30 minutes
- **Complete infrastructure**: 45 minutes

**Recovery Point Objective (RPO)**: 5 minutes (GitHub commit frequency)

---

## 8. TECHNOLOGY STACK

### 8.1 Core Technologies

**Containerization**:
- Docker 24.x
- Docker Compose v2
- No Kubernetes (too complex for current needs)

**VPN & Networking**:
- Headscale v0.27.1 (Tailscale control plane)
- Tailscale (mesh VPN client)
- WireGuard (P2P tunnels)
- Pi-hole (DNS)

**Reverse Proxy**:
- Traefik v3.6.6 (HTTP/HTTPS)
- ACME (Let's Encrypt SSL/TLS)

**Monitoring**:
- Prometheus (metrics)
- Grafana (visualization)
- Loki (logs)
- Alertmanager (alerts)

**Security**:
- CrowdSec (IPS/IDS)
- fail2ban (automated blocking)
- Authelia (2FA, SSO)
- UFW (firewall)

**Email**:
- Mailcow (complete email stack)
  - Postfix (MTA)
  - Dovecot (IMAP)
  - SOGo (webmail, calendars)
  - Rspamd (spam filtering)

**Business Apps**:
- Nextcloud (file storage, collaboration)
- OnlyOffice (office suite)
- Odoo (business management, accounting)
- UniFi/UISP (network management)

**Automation**:
- Ansible (configuration management)
- Git (version control)
- Systemd (service management)

### 8.2 Version Management

**Policy**: Version pinning (no :latest tags)
**Compliance**: 95%+ (5 containers fixed Feb 12, 2026)
**Exception**: docker-bench-security (run-once tool, vendor limitation)

**Example Versions** (as of Feb 15, 2026):
- Traefik: 3.6.6
- Headscale: 0.27.1
- Prometheus: 2.45.0
- Grafana: 10.1.0
- Portainer: 2.33.6
- Mailcow: Latest stable (Mailcow recommends :latest)

---

## 9. CURRENT STATE ASSESSMENT

### 9.1 What's Working ✅

1. **Core Infrastructure**: All 64 containers running, zero unhealthy
2. **VPN Mesh**: Tailscale connectivity Master ↔ Lady ↔ Mac working perfectly
3. **Monitoring**: Prometheus, Grafana, Loki operational, collecting metrics/logs
4. **Security**: CrowdSec blocking 24,000+ IPs, Authelia protecting services
5. **Email**: Mailcow 18-container stack fully operational on Lady
6. **Reverse Proxy**: Traefik 31 routers loaded, SSL working
7. **DR**: Tested 100% success, 3 methods (2min, 15min, 45min RTO)
8. **Git Structure**: Two-repo model working correctly (A+ grade)
9. **Secrets**: All in ~/.secrets/ with 600 permissions
10. **Version Pinning**: 95%+ compliance (mostly no :latest tags)

### 9.2 What Needs Fixing ⚠️

1. **Service Errors**: Some services returning 404/500 (cause unclear)
2. **quietly.online Routing**: Domain has no Traefik routers defined
3. **Documentation Accuracy**: Container counts, grades, service status inconsistent
4. **Lady fail2ban**: Missing traefik-auth and recidive jails
5. **Service Completeness**: Office suite partially deployed, accounting needs config
6. **CCTV/NVR**: Mentioned but not deployed (design only)

### 9.3 Critical Success Factors

**Must Maintain**:
- ✅ Headscale NATIVE (never containerize)
- ✅ NO OSPF/FRR (never introduce)
- ✅ DNS bootstrap fix (immutable /etc/resolv.conf)
- ✅ Single MTA (Postfix only)

**Must Follow**:
- ✅ DOCKER_ORGANIZATION_MANDATORY.md
- ✅ GITHUB_ORGANIZATION_MANDATORY.md
- ✅ MAXIMALLY SIMPLIFIED principle (no bloat)

---

## 10. FUTURE EXPANSION (Out of Scope for Current Project)

**Planned**:
- Additional servers: Beauty, Madam (for Montefish customer)
- Multi-site VPN: Office, Parents locations
- CCTV/NVR: 80+ cameras (Frigate or Shinobi)
- Mobile apps: iOS/Android development
- IPv6: Deployment decision deferred

**Permanently Rejected**:
- OSPF/FRR: Too complex, caused issues, removed Jan 13, 2026

---

## 11. CONCLUSION

The qui3tly.cloud infrastructure is **solid but needs polish** (72/100 → 90/100).

**Strengths**:
- Modern container-based architecture
- VPN mesh working perfectly
- Complete monitoring and security stacks
- DR tested 100% success
- Excellent GitHub and Docker organization

**Gaps**:
- Documentation accuracy and completeness
- Some service accessibility issues
- Security hardening incomplete
- Business applications partially deployed

**Path to 90/100**: Systematic 9-phase approach focusing on:
1. Service stability (fix 404/500)
2. Documentation accuracy and consolidation
3. Service completion (office, accounting)
4. Monitoring validation
5. Security hardening
6. Branding and final polish

---

**Document Version**: 1.0  
**Prepared By**: Lucky Luke (Primary Agent) based on comprehensive audit  
**Date**: February 15, 2026  
**Status**: Draft - Awaiting user review and approval  
**Next Action**: User reviews and confirms technical architecture accuracy
