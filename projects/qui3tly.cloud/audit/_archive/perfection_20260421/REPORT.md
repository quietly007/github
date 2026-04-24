# REPORT — qui3tly.cloud Perfection Program

**Date:** 2026-04-21
**Status:** Consolidated — merges internal preproduction audit (Apr 20), external audit (Apr 21), Feb 17 outage root-cause analysis, audit requests 01–13, standards docs, and Feb 16 baseline.
**Verdict:** NO-GO for production lock. Four P0 blockers + three Feb-16 residual security bugs.

---

## 1. One-page executive view

| Dimension | Grade | Driver |
|---|---|---|
| Security | **C+** | 3 public-exposed admin panels, 7 unscoped Lady listeners, Lady kernel 61 days behind |
| Resilience / DR | **D** | No evidenced Lady backup chain; no restore drill evidence |
| Platform stability | **C** | Zero container resource limits; elevated load averages on both nodes |
| Monitoring / alerting | **B** | 20/20 targets up, pipeline not end-to-end tested |
| Documentation | **B-** | High accuracy vs live state, traceability gaps, drift in claims marked "done" |
| **Overall** | **C** | **Not production-safe** |

Sprint to green: **3–5 focused days** once snapshots exist.

---

## 2. Current infrastructure (verified from live evidence 2026-04-20)

### Master — quietly.its.me

- Public 213.136.68.108, Tailscale 100.64.0.1, WireGuard 10.10.0.1
- Debian 12 Bookworm, kernel **6.1.0-44-cloud-amd64**, uptime **7 days**
- 25 containers running, 0 unhealthy, 20/20 Prometheus targets up, 0 active alerts
- Load avg 4.36 / 2.96 / 2.78 — **elevated, root cause not isolated**
- Mem 4.4 GiB / 47 GiB used (9%), swap 0, disk 33 GB / 985 GB (4%)
- Headscale = NATIVE systemd (v0.27.1), all else Docker

### Lady — quietly.online

- Public 207.180.251.111, Tailscale 100.64.0.2
- Debian 12 Bookworm, kernel **6.1.0-42-cloud-amd64** (two minor versions behind Master, built 2025-12-30)
- Uptime **61 days, 21 h** — no maintenance window applied since Feb 2026
- 38 containers (incl. 14 Mailcow subcontainers + Nextcloud + Odoo + UniFi + UISP + HA + Frigate)
- Load avg 4.68 / 2.85 / 2.59 — elevated (ClamAV / Nextcloud suspected)
- Mem 8.9 GiB / 47 GiB used (19%), swap 0, disk 215 GB / 985 GB (23%)
- **No evidenced backup tooling** (no restic, borg, rsync cron, bacula, duplicati)

### Mac mini / EdgeRouter X
- Mac: Tailscale 100.64.0.3, currently offline per last monthly report
- EdgeRouter: WAN 178.20.30.40, LAN 192.168.99.0/24, WireGuard 10.10.0.2

---

## 3. Findings consolidated (cross-referenced)

### P0 — Production blockers

#### P0-1 · Lady security patch backlog + kernel drift
- **Sources:** external audit FINDINGS_VALIDATION §P0-1, preproduction audit §P0-2, daily reports
- **Evidence:** `evidence/11_lady_snapshot_20260420T193118Z.txt` — kernel 6.1.0-42 built 2025-12-30, uptime 61d; openssl/gnutls/nss class upgradable
- **Risk:** Internet-facing SMTP/IMAPS/HTTPS node with known CVEs in actively-exploited package classes
- **Score:** 3×4 = **12/12** (max)
- **Fix:** `apt update && apt upgrade -y && reboot`; verify kernel ≥ 6.1.0-44, 38 containers restart

#### P0-2 · Lady backup posture — no DR evidence
- **Sources:** external BACKUP_DR_DRILL_REVIEW, preproduction TODO (5 DR tasks not started), audit 02/06
- **Evidence:** no `/backup/`, no restic, no borg, no backup cron on Lady
- **At risk:** Mailcow, Nextcloud, Odoo, UniFi, HA, Frigate — 215 GB live data
- **Risk:** Complete irreversible loss. Contabo snapshots are off-site but not for logical corruption / ransomware
- **Score:** 2×4 = **8/12**
- **Fix:** Per-service backup jobs + daily cron + **remote offsite restic** + drilled restore

#### P0-3 · Unscoped 0.0.0.0 listeners on Lady (upgraded scope)
- **Evidence (live ss -tlnp):**

| Port | Binding | Identity | Authorized? |
|---|---|---|---|
| 9618 | 0.0.0.0 | HTCondor collector | No |
| 6789 | 0.0.0.0 | HTCondor condor_master | No (conflicts with UniFi speed test) |
| 6769 | 0.0.0.0 | HTCondor daemon | No |
| 4691 | 0.0.0.0 | Pegasus WMS | No |
| 2529 | 0.0.0.0 | HTCondor | No |
| 30715 | 0.0.0.0 | unidentified high port | No |
| 5000 | 0.0.0.0 | python3 pid 26417 | **Unknown** — see P0-4 |

- **UFW:** no explicit ALLOW, but broad `172.16.0.0/12` and `10.0.0.0/8` rules exist (see P1-4)
- **Score:** 3×3 = **9/12**
- **Fix:** Identify via /proc/<pid>/exe; stop + disable HTCondor; bind or kill python3:5000; ufw deny removed ports

#### P0-4 · Unidentified python3:5000 on Lady (external finding)
- **Evidence:** pid 26417 (+26313), not in compose inventory
- **Risk:** Unknown code on all interfaces. Legit (UISP Flask?), dev leftover, or compromise
- **Score:** 3×3 = **9/12**
- **Fix:** Trace process tree; if UISP → bind localhost; if dev → kill; if unknown origin → snapshot + investigate before cleanup

#### Residual (Feb-16 commit c150f84) — in DOMAIN_STRATEGY v5 §0, not yet remediated

| FQDN | Container | Current middleware | Should be |
|---|---|---|---|
| pihole.quietly.its.me | pihole | crowdsec-bouncer@file,public@file | crowdsec-bouncer@file,vpn-only@file |
| headscale-ui.quietly.its.me | headscale-ui | ...,public@file | ...,vpn-only@file |
| headscale-admin.quietly.its.me | headscale-admin | ...,public@file | ...,vpn-only@file |

Treat as **P0-residual**. Fix-time: 5 min. See `runbooks/01_p0_security_residual.md`.

### P1 — High priority

#### P1-1 · Master AIDE integrity failure
- **Sources:** external §P1-1, preproduction §P1
- **Risk:** File integrity monitor broken on Master (hosts Headscale, Authelia, CrowdSec, Prometheus)
- **Fix:** `journalctl -u aide.service`; `aideinit`; move DB; `systemctl enable --now aide.timer`

#### P1-2 · Zero container resource limits on both nodes
- **Evidence:** 25 Master + 38 Lady containers with no mem/cpu/pids caps
- **Risk:** One runaway → OOM-kills whole node; likely source of elevated load
- **Fix:** Resource classes per PERFORMANCE_CAPACITY_REVIEW (PLAN Phase 3)

#### P1-3 · Traefik hardening — not evidenced (NEEDS VALIDATION)
- Missing: static config, dynamic config, router middleware list, security-header response
- **Fix:** Capture all four + fix gaps + commit evidence

#### P1-4 · Lady UFW broad RFC 1918 rules (external AC-1)
- **Evidence:** ALLOW IN 172.16.0.0/12 and 10.0.0.0/8 — opens entire Docker RFC 1918 inbound
- **Risk:** Default-deny defeated; lateral movement trivial
- **Score:** 2×3 = **6/12**
- **Fix:** Enumerate real Docker bridges; replace broad with specific subnets

### P2 — Medium

- P2-1 sysctl drift — align both nodes to 99-hardening.conf
- P2-2 root/privilege minimization — cadvisor privileged (expected), admin-panel (python slim) as root
- P2-3 image lifecycle — cloudflared 4mo, prometheus 5mo, grafana 4mo, homeassistant 4mo, nextcloud 29 vs 30, uptime-kuma pinned by digest (no tag)
- P2-4 Master load elevated — isolate (likely VS Code server + monitoring)
- P2-5 Nextcloud 5h uptime at snapshot — check RestartCount
- P2-6 7 Master containers without healthcheck — add
- P2-7 Tailscale mac node offline 8d — acceptable (laptop), monitor

### P3 — Polish (tracked, not blockers)

- Branding consistency (audit 08)
- Doc drift reconciliation
- Mandatory alert rules: NodeDown, HighMemory, HighDisk, CriticalDisk, ContainerOOM, TargetDown, CertExpiry30d
- Uptime Kuma image pinning
- DOMAIN_STRATEGY v5 *.qui3tly.cloud migration — **post-perfection**
- CF API token scope test for qui3tly.cloud zone
- Audit requests 01–13 execution — externalizable after P0/P1 clear

---

## 4. The Feb 17 outage — must not recur

Confirmed by TAILSCALE_OUTAGE_INVESTIGATION_2026-02-18:

1. Traefik v3.6.6 crashed 21:50:11 UTC after **137 h uptime** — unbuffered accessLog writer fd self-closed by Go GC
2. acme.json permissions changed 600 → 644 by a `git reset` at 22:39 → cert resolver blocked → Traefik stayed down after reboot
3. Headscale `server_url = https://headscale.quietly.its.me` routed through Traefik:443 → VPN mesh collapsed
4. service-monitor.sh had `((ISSUES_FOUND++))` + `set -euo pipefail` bug → 0 alerts fired

**Mitigations to verify in this program:**
- `bufferingSize: 100` on Traefik accessLog
- `acme.json` = 600
- service-monitor.sh counter arithmetic fixed (`|| true`)
- Headscale-off-Traefik (DOMAIN_STRATEGY v5 Phase 3) is **post-perfection**

---

## 5. Documentation accuracy

External DOCUMENTATION_ACCURACY_REVIEW: HIGH accuracy vs live state. Remaining gaps:

- HTCondor exposure under-quantified in merged report (7 specific ports vs vague reference) — REPORT §P0-3 now lists each
- public@file bugs noted in DOMAIN_STRATEGY v5 §0 but not fixed in live compose — TODO §1A addresses
- Traceability gaps (AIDE status, Traefik config, sysctl, secrets perms, volume types, backup cron, iptables raw) — `runbooks/05_phase5_evidence_collection.md`

---

## 6. Gate scorecard (current)

| Gate | Requirement | Status |
|---|---|---|
| **A** Security | Patches current, no rogue listeners, AIDE active, no public admin panels | **FAIL** (P0-1, P0-3, P1-1, Residual) |
| **B** Resilience | Lady backups + restore drilled + RTO/RPO measured | **FAIL** (P0-2) |
| **C** Stability | Container limits, load cause isolated, no OOM | **FAIL** (P1-2, P2-4) |
| **D** Documentation | All evidence, drift reconciled, FQDN matrix | **PARTIAL** |
| **E** Monitoring | Alert pipeline e2e tested, mandatory rules, Loki retention | **PARTIAL** |
| **F** Final Go/No-Go | All above PASS | **NOT ISSUED** |

---

## 7. Recommendation

Execute PLAN.md phases 0–5 in strict order. Sign each gate under `gates/` as it closes. Final Gate-F decision issued after Phase 5.

**Do not skip Phase 0.** The snapshots are the rollback mechanism for every subsequent step.

---

## 8. Focused review — `admin-panel` (added 2026-04-21)

Not caught by the external audit because it was subsumed under "25 Master containers". A separate review found:

| # | Finding | Severity | Detail |
|---|---|---|---|
| 1 | **Build-on-every-boot** | P1 | Command is `apt-get update && apt-get install openssh-client && pip install flask && python app_simple.py`. No Dockerfile, no pinned versions, no reproducibility. Any restart hits the internet to install unpinned packages. |
| 2 | **Runs as root** | P1 | `Config.User = ""` → uid 0. Flask process is root. |
| 3 | **SSH private key mounted into container as root** | P1 | `~/.docker/admin-panel/ssh/id_ed25519 → /root/.ssh/id_ed25519`. Flask app (unreviewed code) holds outbound SSH credentials. Any Flask RCE/SSRF = shell pivot. |
| 4 | **No resource limits** | P1 | `HostConfig.Memory = 0`. Combined with root + apt-get on restart, a candidate contributor to Master's elevated load. |
| 5 | **Unknown Flask code** | P1 | `~/.docker/admin-panel/app_simple.py` never code-reviewed in the audit set. |
| 6 | **Unaudited `.env`** | P2 | `~/.secrets/admin-panel/.env` loaded into container; contents + rotation age unknown. |
| 7 | **Doc drift** | P2 | `.docs/03-services/ADMIN_PANEL.md` states Basic Auth via Traefik (`admin-auth` middleware). Live compose has only `crowdsec-bouncer@file,vpn-only@file`. Either doc is stale or auth was removed. |
| 8 | **Middleware is CORRECT (positive finding)** | — | `vpn-only@file` properly applied — not one of the three residual `public@file` bugs. |

**Remediation** — see TODO.md §APPENDIX R-ADM-1 … R-ADM-6 (code review → Dockerfile with pinned versions → non-root UID → SSH scope minimization → resource limits → Authelia 2FA on route → doc update).

**Recommendation:** Treat admin-panel as **P1** overall. The combination of "hot-installs packages on boot + runs as root + holds an SSH key + custom unreviewed Flask code + internet-facing (even via VPN-only middleware)" is a disproportionate risk for a small dashboard.

---

## 9. Honest addendum — what I initially skipped (2026-04-21 late-day sweep)

Before this addendum, §1–§8 were built almost entirely on the preproduction reports and external audit. I did **not** deep-read the 13 audit request files, the standards/architecture/operations/security docs, every compose file, `SECURITY_INCIDENT_2026-01-28`, the mail/DNS/branding/governance audit scopes, or the live compose state in full. Admin-panel surfacing only after a prompt proved the gap. The full-source sweep produced `FINDINGS_INDEX.md` alongside this REPORT. Key additional facts now captured:

### 9A · Absolute rules recovered (R01–R22 in FINDINGS_INDEX §1)

Twenty-two non-negotiable rules are now explicit, including previously-under-emphasized ones:

- **R03** — Docker port bindings MUST specify host IP (`127.0.0.1:X:Y` / `100.64.0.X:X:Y`). A port written as `"X:Y"` bypasses UFW and was the Jan-28 incident root cause.
- **R05** — NO `:latest` tags. Covers `frigate:stable` on Lady (currently violating).
- **R06** — Healthchecks mandatory on every service.
- **R09** — Two-repo GitHub model + four symlinks must remain intact.
- **R14** — Mail deliverability >95% mandatory.
- **R19–R21** — Three specific Feb-17 mitigations (acme.json 600, `bufferingSize: 100`, service-monitor arithmetic) must be verified live, not assumed.

### 9B · New compose-level findings

- `~/.docker-compose/crowdsec.bak/` — stale backup compose folder on Master; must be cleaned/documented
- `security-tools` (trivy) — running but undocumented; output destination unknown
- `frigate:stable` on Lady — R05 violation; must pin
- `uisp` on Lady — digest-only pin; technically ok but update-unfriendly, needs documentation
- `nextcloud` on Lady carries `public@file` — **intentional** (public cloud) not a Feb-16 bug
- 21+ Master containers and 14+ Lady containers have no `mem_limit` — aligns with external audit P1-2

### 9C · Credentials sweep (Audit 13) NEVER executed

The external audit sampled credentials informally. A complete sweep has not been done. Added as Phase 1F (inventory + perms + git history + sudoers + SSH map). No rotation in this sprint — rotation plan seeded for Phase 5.

### 9D · DNS + Mail posture unverified

Audit 02 (DNSSEC / CAA / SPF / DKIM / DMARC / PTR per domain) and Audit 06 (Mailcow deliverability + queue + blacklist + mail-tester.com score) have not been run since baseline. Added as Phase 6 + Phase 7, required before Gate-F.

### 9E · Monitoring coverage matrix missing

External audit confirmed 20/20 Prom targets up but not the four-pillar matrix (every service: logs → Loki, metrics → Prom, alert rule, Grafana dashboard). Added as Phase 4+ (R-COV-1..5).

### 9F · Governance self-check

Audit 09 ZERO-TOLERANCE enforcement never re-audited. Added to Gate-D acceptance (R-GOV-1..5).

### 9G · Out-of-scope but tracked

Audit 08 branding, Audit 10 v5 migration, Audit 12 FQDN inventory, Audit 13 rotation, Audit 01 business items (DSC, mobile, Pegasus-SSO, Montefish, Norma) — explicitly NOT Gate-F blockers, explicitly listed in Phase 8 roadmap so nothing is lost.

### 9H · Gate templates

Gate sign-off templates now align with `PHASE_COMPLETION_TEMPLATE.md` (8-category grade assessment).

---

## 10. Updated verdict

Verdict is **unchanged in substance** (still NO-GO for production lock) but the **scope** of remediation grew:

- Original P0 set (patch, backups, listeners, unknown-python, residual public@file) — still P0
- Added P1 from this sweep: credentials sweep, frigate pin, crowdsec.bak housekeeping, Feb-17 mitigations verification, monitoring coverage matrix, DNS verification, mail verification, admin-panel hardening
- Added polish/post-lock items: branding, v5 migration, FQDN inventory, credential rotation, business roadmap

The **3–5 day sprint** estimate holds for P0+P1. Post-lock roadmap is separate program-of-record.

See `FINDINGS_INDEX.md` for the authoritative cross-reference, and the updated TODO.md (now 520+ lines) for the operator checklist including Phases 1F, 1G, 1H, 4+, 6, 7, 8.
