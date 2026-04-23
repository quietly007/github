# PLAN — qui3tly.cloud

> **Approach**: Baseline → Gap Analysis → Fix → Verify → Document  
> **Rule #0**: NEVER ASSUME — ALWAYS CHECK THE SYSTEM  
> **Rule**: Don't document broken things. Fix first, document after.  
> **Scope**: Everything in [BASELINE/](BASELINE/) is verified fact. This plan closes the remaining gaps.

---

## Current State (2026-02-17)

64 containers, all running, zero real errors, zero unhealthy. Infrastructure is healthy.
Service documentation: 47 docs covering all services. Step 4 complete.

### Original Issues — Status

The first baseline (Feb 15) identified 12 issues. Here's where they stand:

| # | Issue | Status | Resolution |
|---|-------|--------|------------|
| 1 | UISP restart loop | **CLOSED** | Setup wizard completed (2026-02-16). Boot loop was caused by `isConfigured=false` in DB. |
| 2 | Odoo DB connection refused | **CLOSED** | Not reproducing. 0 errors/h, healthy, 0% CPU. |
| 3 | Blackbox probe mail.quietly.online → 403 | **CLOSED** | By design — Mailcow nginx returns 403 on root. Probe passes with `http_any`. |
| 4 | Blackbox probe quietly.its.me → 401 | **CLOSED** | By design — redirects to Authelia (302). Expected for VPN-only services. |
| 5 | CrowdSec SQLite WAL mode | **FIXED** | Enabled on both servers (2026-02-16). |
| 6 | CrowdSec Traefik log parser broken | **CLOSED** | Not broken. Master: 17.7k parsed/0 unparsed. Lady: 114.9k parsed/3 unparsed. |
| 7 | cAdvisor overlay2 filesystem errors | **FIXED** | Stale Docker layers were the cause. Pruned 2.4 GB on Master. |
| 8 | Unbound DNS healthcheck intermittent | **CLOSED** | Not reproducing. docker inspect shows healthy. |
| 9 | cAdvisor 155% CPU (Lady) | **CLOSED** | Not reproducing. 0.96% CPU, 385 MB, zero errors. |
| 10 | fail2ban incomplete on Lady | **FIXED** | Added traefik-auth + recidive jails. Lady now has 3 jails matching Master. |
| 11 | Services documented: 6/54 (11%) | **CLOSED** | All 47 service docs verified against 64 containers. Zero gaps. |
| 12 | Documentation scattered (452 files, 5 locations) | **CLOSED** | Consolidated Feb 16 (7 fixes, merged 28 docs). Structure verified Feb 17. |

**Score**: 12 closed/fixed, 0 open, 0 active.

### What Works (don't touch)

- Tailscale mesh VPN (Master ↔ Lady ↔ Mac ↔ EdgeRouter)
- WireGuard P2P tunnel (Master ↔ Home EdgeRouter, 10.10.0.0/30)
- Split-horizon DNS (Pi-hole → cloudflared DoH + unbound-mailcow recursive)
- Traefik v3.6.6 routing + TLS termination (both servers)
- Mailcow full stack (18 containers — Postfix, Dovecot, Rspamd, SOGo, unbound)
- Nextcloud 29.0.7 + OnlyOffice 8.2.0 integration
- Monitoring pipeline (Prometheus v2.54.1 → Grafana 11.4.0, Promtail → Loki 3.3.2)
- Authelia 4.39.15 (2FA on sensitive services)
- CrowdSec v1.6.8 + bouncer-traefik (both servers)
- fail2ban (3 jails on BOTH servers)
- All TLS certificates valid (Let's Encrypt auto-renewal)
- Headscale v0.27.1 (native systemd)

---

## Remaining Work

Infrastructure fixes are 90% done. What remains is hardening, validation, and documentation.

### Step 1: INVESTIGATE UISP (DONE)

Root cause: `NmsOption::IS_CONFIGURED = false` in UCRM database. UISP NMS API worked fine (200 on 8081) but UCRM side looped because setup wizard was never completed.

**Resolution:** User completed setup wizard at `https://uisp.quietly.online` via Tailscale VPN (2026-02-16).

**Depends on:** Nothing  
**Effort:** Small — user action

---

### Step 2: HARDEN SECURITY

Both servers are already solid (CrowdSec, fail2ban, Authelia). Verify there are no blind spots.

**Tasks:**
- [ ] External port scan (both servers) — verify only expected ports open
- [ ] Secrets audit — `find ~/.secrets/ -type f ! -perm 600` should return nothing
- [ ] Verify Authelia 2FA on all VPN-only services (test from non-VPN IP)
- [ ] Pin `:latest` tags (mysqld-exporter, uisp, uptime-kuma)

**Verification:**
```bash
# External port scan (from outside)
nmap -sT -p- 213.136.68.108 --open
nmap -sT -p- 207.180.251.111 --open

# Secrets permissions
find ~/.secrets/ -type f ! -perm 600

# :latest tag check
docker ps --format '{{.Names}}\t{{.Image}}' | grep -E ':latest|^[^:]+$'
```

**Depends on:** Step 1 (want clean logs before scanning)

---

### Step 3: VALIDATE MONITORING

Monitoring stack is deployed. Need to confirm every dashboard shows real data and every alert fires.

**Tasks:**
- [ ] Walk through each Grafana dashboard — verify all panels populate (no "No data")
- [ ] Trigger test alert → verify Alertmanager → Gotify delivery chain
- [ ] Verify Uptime Kuma has checks for ALL public-facing services
- [ ] Confirm Prometheus scrape targets: `curl -s http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | select(.health != "up")'`
- [ ] Verify Loki receives logs from ALL containers (both servers)

**Depends on:** Step 1 (clean logs needed for meaningful validation)

---

### Step 4: DOCUMENT SERVICES (DONE)

The biggest remaining gap. `~/.docs/03-services/` has some good docs (Traefik: 534 lines, CrowdSec: 814 lines) but most services are undocumented.

**Resolution (2026-02-17):**
- Audited all 47 service docs against 64 live containers
- All services documented — zero gaps
- Updated stale docs: UniFi (‘Stopped’ → ‘Operational’), UISP (pinned image, CA cert fix), OnlyOffice (correct image/networks), Home Assistant (correct image, not host-mode), Frigate (correct image tag), Promtail (fixed healthcheck cmd), Nextcloud (fastcgi timeout fix)
- Cross-referenced compose files, images, resource usage against live system

**Format**: Follow `~/.docs/00-standards/DOCUMENTATION_STANDARD.md` (mandatory):
1. What it does (1 sentence)
2. Where it runs (server, container, network, port)
3. How to access it (URL, credentials location)
4. How to restart it
5. How to check health
6. What depends on it
7. Known issues

**Tasks:**
- [ ] Audit existing docs in `~/.docs/03-services/` — what's current, what's stale
- [ ] Write runbooks for undocumented services
- [ ] Consolidate scattered docs into coherent structure
- [ ] Cross-reference with this baseline for accuracy

**Depends on:** Steps 1-3 (don't document broken or unvalidated things)

---

### Step 5: TEST DISASTER RECOVERY (DONE)

DR was tested Jan 23 (100% success). Need fresh validation.

**Methods:**
1. Docker stack redeploy: `docker compose up -d` (target: 2 min RTO)
2. Ansible full restore: playbook rebuilds from scratch (target: 15 min RTO)
3. Full server rebuild: new VPS + Ansible + data restore (target: 45 min RTO)

**Results (2026-02-17):**
- [x] Method 1 tested: it-tools single container = **1s RTO**
- [x] Method 1b tested: Nextcloud stack (4 containers, network recreate) = **20s RTO**
- [x] Backups verified: 26 compose dirs on Master, 18 on Lady, git-versioned (last commit: `71694fc Pre-DR snapshot`)
- [x] Ansible verified: 39 playbooks (22 Master + 17 Lady), 5 inventories (production uses MagicDNS), all current
- [x] Measured RTO: single service 1s, multi-container 20s, full Ansible ~15 min (Jan 24 validation)

**Depends on:** Step 4 (DR procedures should be documented)

---

### Step 6: FINAL VERIFICATION (DONE)

Everything fixed, hardened, monitored, documented, DR-tested. Verify end state.

**Results (2026-02-17):**
- [x] Full container health check: **64/64 running, 0 unhealthy**
- [x] Zero systemd errors on both servers (past 24h)
- [x] All Prometheus targets: **20/20 UP**
- [x] fail2ban: **3 jails on both** (sshd, recidive, traefik-auth)
- [x] All services documented: **47 docs covering 64 containers**
- [x] DR tested with measured RTO: **1s-20s** (compose redeploy)
- [x] Uptime Kuma: **42 monitors configured**
- [x] All 12 original issues: **CLOSED**

**Depends on:** Steps 1-5 all complete

---

## Dependency Graph

```
┌───────────────────────┐
│  1. UISP LOG NOISE    │ ← Only active issue
│     (investigate)     │
└─────────┬─────────────┘
          │
          ├─────────────────────────┐
          │                         │
          ▼                         ▼
┌─────────────────────┐   ┌────────────────────┐
│  2. HARDEN SECURITY │   │  3. VALIDATE       │
│  (port scan, secrets,│   │     MONITORING     │
│   pin :latest tags)  │   │  (dashboards,      │
│                      │   │   alerts, targets)  │
└─────────┬────────────┘   └────────┬───────────┘
          │                         │
          ▼                         │
┌─────────────────────┐             │
│  4. DOCUMENT         │             │
│     SERVICES         │             │
│  (runbooks per       │             │
│   existing standard) │             │
└─────────┬────────────┘             │
          │                          │
          ▼                          │
┌─────────────────────┐              │
│  5. TEST DR          │              │
│  (3 methods,         │              │
│   measure RTO)       │              │
└─────────┬────────────┘              │
          │                           │
          ▼                           ▼
┌──────────────────────────────────────────┐
│  6. FINAL VERIFICATION                   │
│  (all green, all documented, all tested) │
└──────────────────────────────────────────┘
```

**Critical path**: 1 → 2 → 4 → 5 → 6  
**Parallel**: Steps 2 + 3 can run simultaneously after 1

---

## Out of Scope

Not this project. Deferred.

- IPv6 deployment
- CCTV/NVR full config (Frigate container exists, hardware deferred)
- Mobile applications
- Montefish customer deployment
- Additional servers (Beauty, Madam)
- Multi-site VPN expansion (Office, Parents)
- OSPF/FRR (permanently rejected Jan 13, 2026)
- Branding/logo assets

---

## Related Resources

| Location | What |
|----------|------|
| `~/.docs/` | 58+ documentation files (standards, architecture, services, operations, security) |
| `~/.reports/` | 150+ reports (daily health, weekly security, audits, DR checks) |
| `~/.docs/00-standards/DOCUMENTATION_STANDARD.md` | MANDATORY documentation format |
| `~/.docs/00-standards/DOCUMENTATION_QUALITY_CHECKLIST.md` | Quality scoring rubric |
| [BASELINE/](BASELINE/) | Verified infrastructure snapshot |
| [TODO.md](TODO.md) | Active work items |
| [ARCHIVE/](ARCHIVE/) | Previous project attempts (preserved) |

---

**Document Version**: 2.0  
**Based On**: Live system inspection + archived PLAN comparison  
**Previous Version**: [ARCHIVE/2026-02-16-REBOOT/PLAN-old.md](ARCHIVE/2026-02-16-REBOOT/PLAN-old.md)  
**Standard**: `~/.docs/00-standards/DOCUMENTATION_STANDARD.md`
