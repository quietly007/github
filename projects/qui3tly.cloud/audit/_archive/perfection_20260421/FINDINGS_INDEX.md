# FINDINGS INDEX — complete sweep (corrects prior omissions)

**Date:** 2026-04-21
**Purpose:** Single cross-referenced index of every finding/constraint/obligation that MUST be honored by the production-lock program. Compiled after full read of:

- 13 audit request files ([`personal/audits/01..13`](../../../personal/audits))
- Standards: `DOCUMENTATION_STANDARD`, `DOCUMENTATION_QUALITY_CHECKLIST`, `PHASE_COMPLETION_TEMPLATE`, `QUI3TLY_BRAND_GUIDELINES`, `INFRASTRUCTURE_OVERVIEW`
- Architecture: `NETWORK_ARCHITECTURE`, `DOMAIN_STRATEGY` v4/v5, `DOCKER_ORGANIZATION_MANDATORY`, `GITHUB_ORGANIZATION_MANDATORY`
- Operations: `BACKUP_STRATEGY`, `DISASTER_RECOVERY`, `ERROR_REMEDIATION_PLAN`, `MEMORY_DISCIPLINE`, `MONITORING`, `TROUBLESHOOTING`
- Security: `FILE_PERMISSIONS_POLICY`, `SECURITY_STANDARDS`, `SYSTEMD_SERVICES`, **`SECURITY_INCIDENT_2026-01-28.md`**
- Monitoring: `ALERT_RULES`, `LESSONS-LEARNED`, `METRICS_REFERENCE`, `PROMETHEUS_TARGETS`
- Proposals: `MONTEFISH/*`, `NORMA/*`
- Full compose inventories (Master 25, Lady 17+Mailcow18)
- `DNS_PIHOLE_CHANGE_REPORT.md`, `TAILSCALE_OUTAGE_INVESTIGATION_2026-02-18.md`, `GITHUB_COMPREHENSIVE_AUDIT.md`
- BASELINE + preproduction full tree + external-audit deliverables

This file supersedes any narrower finding list from the first pass.

---

## Section 1 — ABSOLUTE RULES (non-negotiable, must not be violated)

Any deviation is a blocker. From standards docs, verbatim where possible:

| # | Rule | Source | Scope |
|---|------|--------|-------|
| R01 | **NEVER ASSUME — ALWAYS CHECK THE SYSTEM.** | `DOCUMENTATION_STANDARD.md` Rule #0 | All agents |
| R02 | Secrets: dir 700, files 600. Zero exceptions. | `FILE_PERMISSIONS_POLICY.md` | Fleet |
| R03 | Docker port bindings MUST specify host IP (`127.0.0.1:X:Y` or `100.64.0.X:X:Y`) — `"X:Y"` is forbidden because Docker bypasses UFW. | `SECURITY_STANDARDS.md`, `SECURITY_INCIDENT_2026-01-28` | All compose files |
| R04 | Compose file location MUST be `~/.docker-compose/{svc}/docker-compose.yaml`. No alternatives. | `DOCKER_ORGANIZATION_MANDATORY.md` Rule #1–2 | All services |
| R05 | NO `:latest` tags. All images pinned. | `DOCKER_ORGANIZATION_MANDATORY.md` Rule #5 | All services |
| R06 | All services MUST have healthchecks (interval + timeout + retries). | `DOCKER_ORGANIZATION_MANDATORY.md` Rule #6 | All services |
| R07 | Services SHOULD have `cpus` and `memory` limits (enforce as MUST for critical/stateful). | `DOCKER_ORGANIZATION_MANDATORY.md` Rule #7 + external PERFORMANCE_CAPACITY_REVIEW | All services |
| R08 | Config and data separated: `~/.docker/{svc}/config` vs `~/.docker/{svc}/data`. | `DOCKER_ORGANIZATION_MANDATORY.md` Rule #3 | All services |
| R09 | Two-repo GitHub model: `quietly007/github` (shared) + `quietly007/{master,lady}` (per-node). Symlinks `~/.governance`, `~/.ansible`, `~/.copilot-shared`, `~/projects` must point into `~/.github/`. | `GITHUB_ORGANIZATION_MANDATORY.md` | Fleet |
| R10 | NEVER use `100.100.100.100` as DNS (MagicDNS → boot crash loop). Primary DNS = `1.1.1.1`, fallback `8.8.8.8`. Master `/etc/resolv.conf` `chattr +i`. | `NETWORK_ARCHITECTURE.md` | Master |
| R11 | `qui3tly.cloud` = VPN-ONLY, never public. `quietly.online` + `quietly.its.me` = public. | `DOMAIN_STRATEGY.md` v5 governing principle | Traefik routing |
| R12 | VPN-only services MUST have `vpn-only@file` middleware. Only explicitly-public services may use `public@file`. | `DOMAIN_STRATEGY.md` v5 §0 | Traefik labels |
| R13 | Agents MUST follow instructions. ZERO TOLERANCE for deviation. | `09_AUDIT_REQUEST_GOVERNANCE.md` | All agents |
| R14 | Deliverability target: **>95%** (mail). Spam detection >95%, false-positive <1%, virus detection 100%. | `06_AUDIT_REQUEST_MAIL_SYSTEM.md` | Mailcow |
| R15 | Headscale = NATIVE systemd. Do not containerize. | `INFRASTRUCTURE_OVERVIEW.md` + `TAILSCALE_OUTAGE_INVESTIGATION_2026-02-18.md` | Master |
| R16 | Postfix = only MTA (inside Mailcow). No other MTA on Lady. | `06_AUDIT_REQUEST_MAIL_SYSTEM.md` | Lady |
| R17 | No OSPF/FRR (permanently removed Jan 13 2026). | Project history | Master |
| R18 | Master `/etc/resolv.conf` = `chattr +i` on `1.1.1.1`/`8.8.8.8`. | `NETWORK_ARCHITECTURE.md` | Master |
| R19 | acme.json = 600 permissions (was cause of Feb-17 outage when a `git reset` flipped to 644). | `TAILSCALE_OUTAGE_INVESTIGATION_2026-02-18.md` | Master traefik |
| R20 | `bufferingSize: 100` on Traefik `accessLog` (Feb-17 root cause). | `TAILSCALE_OUTAGE_INVESTIGATION_2026-02-18.md` | Master + Lady traefik |
| R21 | Service monitor script: `((ISSUES_FOUND++))` under `set -euo pipefail` will exit when counter is 0 → arithmetic must be `|| true`. | `TAILSCALE_OUTAGE_INVESTIGATION_2026-02-18.md` | `service-monitor.sh` |
| R22 | READ-ONLY audits must not modify anything. | Audit requests 01–13 preambles | Auditors |

**Every production-lock item must be traceable to one or more of these rules.**

---

## Section 2 — OUTSTANDING ITEMS FROM AUDITS 01–13

These audits each demand a specific deliverable set. Not all have been executed yet. Status below.

| # | Audit | Core deliverable | Status | Action for perfection program |
|---|-------|------------------|--------|-------------------------------|
| 01 | PROJECT | A+++ project audit; OnlyOffice / Odoo / Frigate / DSC / mobile / Pegasus philosophy | Partially executed: OnlyOffice + Odoo + Frigate deployed. DSC Powermanage, mobile app, Pegasus-style SSO still open. | Catalogue the *business* gaps separately; move to post-perfection roadmap |
| 02 | DNS | DNSSEC, CAA, MX/SPF/DKIM/DMARC/PTR for all 3 domains, propagation, TTL, `qui3tly.cloud` zone | Not fully verified | **Add Phase 6 task: DNS verification before Gate-F** |
| 03 | SERVICES | Loki coverage per service, log analysis, per-container health | Partial (monitoring exists, per-service analysis not done) | **Phase 4 — Loki coverage audit** added |
| 04 | PERFORMANCE | Baselines, bottlenecks, capacity planning | External audit did the review; actions = Phase 3 limits rollout | Covered in Phase 3 |
| 05 | SECURITY_PERMISSIONS | Permissions sweep, CVEs, UFW, secrets, users | Partial — external audit found patch backlog + UFW + listeners | Covered in Phase 1; **add explicit secrets perms sweep across both nodes** |
| 06 | MAIL_SYSTEM | 18 Mailcow containers health, DKIM/SPF/DMARC/PTR, blacklist, deliverability >95%, ActiveSync | Not executed since baseline | **Add dedicated Phase 7 Mail section (after Gate-E)** |
| 07 | MONITORING_SYSTEM | 100% Loki coverage, alerts on every critical metric, dashboards | Partial | Covered in Phase 4 — expanded |
| 08 | BRANDING_DESIGN | Unified visual identity across 54 services, favicons, page titles `qui3tly.cloud - <service>`, error pages | Not executed | Added as **Phase 8 (post-lock)** — does not block Gate-F |
| 09 | GOVERNANCE | ZERO-TOLERANCE enforcement, MANDATORY agent rules | Live in `.copilot/` but needs audit | **Add governance self-check to Gate-D** |
| 10 | DOMAIN_STRATEGY v5 | Migrate VPN services to `*.qui3tly.cloud`, CF cert for that zone | Explicitly out-of-scope for THIS sprint | Keep out-of-scope; add pre-reqs to post-perfection roadmap |
| 11 | AUDIT_OF_AUDIT | Meta-review of v5 review chain | Executed (Feb) | Close — no action |
| 12 | FQDN_SWEEP | Complete inventory of every file referencing old FQDNs | Blocking v5 migration (post-perfection) | Keep as prereq for v5 — log only |
| 13 | CREDENTIALS_SWEEP | Every plaintext credential catalogued + rotation plan | **NOT EXECUTED** | **Add as P1 in Phase 1 — expanded below** |

---

## Section 3 — LIVE COMPOSE FINDINGS (my actual sweep, not the summaries)

### 3A · Master (25 active containers)

| Service | Image | `:latest`? | User | Mem limit | Healthcheck? | Middleware | Red flags |
|---|---|---|---|---|---|---|---|
| admin-panel | `python:3.11-slim` | unpinned minor | root | **none** | yes | crowdsec-bouncer+vpn-only | **apt/pip at boot + SSH key + root** |
| alertmanager | `prom/alertmanager:v0.27.0` | pinned | default | 256m | — | crowdsec+vpn-only | — |
| authelia | `authelia/authelia:4.39.15` | pinned | default | **none** | — | crowdsec+vpn-only | — |
| blackbox-exporter | `prom/blackbox-exporter:v0.28.0` | pinned | default | **none** | — | — | — |
| cadvisor | `gcr.io/cadvisor/cadvisor:v0.52.1` | pinned | root | **none** | — | — | **privileged (expected)** |
| crowdsec | `crowdsecurity/crowdsec:v1.6.8` | pinned | default | **none** | — | — | — |
| **crowdsec.bak** | `crowdsecurity/crowdsec:v1.6.8` | — | — | — | — | — | **Stale backup compose present** — remove or document |
| default-landing | `nginx:1.27-alpine` | pinned | default | **none** | — | authelia@docker | — |
| fuckoff-page | `nginx:1.27-alpine` | pinned | default | **none** | — | — | — |
| gotify | `gotify/server:2.5.0` | pinned | default | **none** | — | https-redirect | — |
| grafana | `grafana/grafana:11.4.0` | pinned | default | 1g | — | https-redirect | — |
| headscale-ui | `ghcr.io/gurucomputing/headscale-ui:2025.08.23` | pinned | default | **none** | — | crowdsec+vpn-only | — |
| it-tools | `corentinth/it-tools:2024.10.22-7ca5933` | pinned | default | **none** | — | crowdsec+vpn-only | — |
| loki | `grafana/loki:3.3.2` | pinned | default | 1g | — | crowdsec+vpn-only | — |
| node-exporter | `prom/node-exporter:v1.9.0` | pinned | default | **none** | — | — | — |
| ntfy | `binwiederhier/ntfy:v2.16.0` | pinned | default | **none** | — | https-redirect | — |
| pihole | (see file — first-line of compose is not pihole image; **double-check**) | — | — | — | — | https-redirect | Compose file layout quirk — verify pihole image tag separately |
| portainer | `portainer/portainer-ce:2.33.6` | pinned | default | **none** | — | vpn-only | — |
| prometheus | `prom/prometheus:v2.54.1` | pinned | default | 2g | — | crowdsec+vpn-only | — |
| promtail | `grafana/promtail:3.4.2` | pinned | default | **none** | — | — | — |
| **security-tools** | `aquasec/trivy:0.58.2` | pinned | default | **none** | — | — | Check if running or orphaned; log scanning outputs? |
| semaphore | `semaphoreui/semaphore:v2.10.22` | pinned | default | **none** | — | crowdsec+vpn-only | — |
| traefik | `traefik:v3.6.6` | pinned | default | **none** | — | https-redirect | — |
| uptime-kuma | `louislam/uptime-kuma:1.23.17` | pinned | default | **none** | — | https-redirect | — |

**New findings from this sweep:**
- **crowdsec.bak** is a stale/duplicate compose folder — must be cleaned up (and verified not running)
- **security-tools/trivy** exists — need to know if scan output goes anywhere; currently undocumented
- The pihole entry in my quick grep looked suspicious (image reference went to cloudflared) — compose file needs a dedicated read to confirm pihole image tag
- Almost all Master services missing mem_limit (matches external audit P1-2)
- No `user:` directive set on most services → defaults to image-level user (often root)

### 3B · Lady (non-Mailcow containers)

| Service | Image | `:latest` / unpinned? | Red flags |
|---|---|---|---|
| cadvisor | `gcr.io/cadvisor/cadvisor:v0.52.1` | pinned | privileged (expected) |
| crowdsec | `crowdsecurity/crowdsec:v1.6.8` | pinned | — |
| **frigate** | `ghcr.io/blakeblackshear/frigate:stable` | **:stable — not a pinned version** | **Rule R05 violation** |
| fuckoff-page | `nginx:1.27-alpine` | pinned | — |
| home-assistant | `lscr.io/linuxserver/homeassistant:2024.12.5` | pinned | — |
| mta-sts | `nginx:1.27-alpine` | pinned | — |
| mysqld-exporter | `prom/mysqld-exporter:v0.16.0` | pinned | — |
| **nextcloud** | `lscr.io/linuxserver/nextcloud:29.0.7` | pinned | Middleware chain includes `public@file` — **expected** for `cloud.quietly.online`, but audit log proves middleware is intentional, not a Feb-16 style mistake |
| node-exporter | `prom/node-exporter:v1.9.0` | pinned | — |
| odoo | (postgres:16-alpine for its DB — odoo itself pinned elsewhere; needs verify) | — | — |
| portainer-agent | `portainer/agent:2.24.1` | pinned | — |
| promtail | `grafana/promtail:3.4.2` | pinned | — |
| traefik | `traefik:v3.6.6` | pinned | — |
| **uisp** | `nico640/docker-unms@sha256:b428e73…` | **digest-only (no tag)** — pinned but update-unfriendly | Monitor for new stable tag; document |
| unifi | `lscr.io/linuxserver/unifi-network-application:8.6.9` | pinned | — |

**New findings:**
- **`frigate:stable` violates R05** — must pin to a specific version tag
- **`uisp` is digest-only** — technically pinned, but no update visibility
- Lady missing mem_limits across the board
- `nextcloud` `public@file` is NOT one of the Feb-16 bugs (public by design)

### 3C · Mailcow (Lady)

18 sub-containers. Not individually enumerated here — they follow Mailcow upstream compose. Known state: `ghcr.io/mailcow/unbound:1.24` visible, `privileged: true` present for network-namespace containers (expected Mailcow behavior).

Required work:
- Execute Audit-06 deliverables: deliverability >95%, DKIM/SPF/DMARC/PTR, blacklist check, queue health, backup + restore drill — **moved into Phase 7** of the program
- `mailcow.conf` and `docker-compose.override.yml` credential sweep per Audit-13

---

## Section 4 — DIMENSIONS I PREVIOUSLY MISSED

| # | Dimension | Why it was missed | Added to program as |
|---|---|---|---|
| M01 | `admin-panel` is root+SSH+apt/pip-on-boot | Only caught when user asked | TODO Appendix R-ADM (previous turn) |
| M02 | Credentials sweep (Audit 13) — plaintext secrets everywhere | Scope filter too narrow | **Phase 1F — Credentials Sweep** (below) |
| M03 | DNS audit (Audit 02) — DNSSEC/CAA/MX/SPF/DKIM/DMARC/PTR | Not on external audit radar | **Phase 6 — DNS Verification** (below) |
| M04 | Mail deliverability (Audit 06) | Assumed green | **Phase 7 — Mail Verification** (below) |
| M05 | Monitoring coverage (Audit 07) — every service → Loki + metrics + alert + dashboard | External audit stopped at pipeline test | **Phase 4 expanded — Coverage matrix** |
| M06 | Branding (Audit 08) — 54 services consistency + page titles + favicons | Excluded as "polish" | **Phase 8 — Branding** (post-Gate-F) |
| M07 | Governance self-check (Audit 09) — START_HERE, PRE_FLIGHT, enforcement | Not re-audited | **Gate-D requires governance checklist pass** |
| M08 | `crowdsec.bak` stale compose directory on Master | Compose sweep missed it | **Phase 1 housekeeping** |
| M09 | `security-tools` (trivy) usage status | Not documented | **Phase 4 — verify or retire** |
| M10 | `frigate:stable` unpinned | R05 violation | **Phase 1 hardening** |
| M11 | `uisp` digest-only pin | Acceptable but undocumented | **Phase 5 docs** |
| M12 | FQDN inventory for future v5 migration (Audit 12) | Out of scope but prereq | **Phase 5 — start inventory, complete post-Gate-F** |
| M13 | Feb-17 mitigation verification (bufferingSize, acme.json 600, service-monitor counter) | Assumed from audit but not verified live | **Phase 1G — Feb-17 mitigations verification** |
| M14 | Native services: SSH/fail2ban/UFW/cron/systemd timers comprehensive sweep | Partial | **Phase 1E expanded** |
| M15 | Git history credential exposure (Audit 13 §8) | Not scanned | **Phase 1F — git history scan** |
| M16 | Sudoers NOPASSWD audit | Not checked | **Phase 1F — sudoers audit** |
| M17 | SSH key inventory + usage map | Not done | **Phase 1F — SSH key map** |
| M18 | Pi-hole gravity DB / custom DNS entries referencing old FQDNs | Noted in audits but not verified | **Phase 5 — Pi-hole audit** |
| M19 | `cron` and `systemd timer` inventory including AIDE, Mailcow, backups | Partial | **Phase 2B expanded** |
| M20 | Ansible inventory FQDN references | Noted | **Phase 5 — FQDN sweep prep** |
| M21 | Grafana dashboard hardcoded URLs | Noted | **Phase 5 — Grafana URL audit** |
| M22 | Uptime-Kuma monitor URL audit | Noted | **Phase 5 — Kuma monitor audit** |
| M23 | PHASE_COMPLETION_TEMPLATE compliance for gate sign-offs | Missed standard | **Gate templates updated to match `PHASE_COMPLETION_TEMPLATE.md`** |
| M24 | Brand page title format `qui3tly.cloud - <service>` | Phase 8 | — |
| M25 | Montefish / Norma proposal alignment with perfection outcomes | Out of scope — noted in post-perfection roadmap | — |
| M26 | `SECURITY_INCIDENT_2026-01-28.md` findings all re-verified in live compose files (no `"X:Y"` unbound port bindings remain) | Not re-checked | **Phase 1F — explicit `docker inspect` of HostConfig.Ports binding** |
| M27 | `systemd-masked` services (pmcd/pmie/pmlogger/pmproxy) still masked | Not verified | **Phase 5 evidence** |
| M28 | `PROMETHEUS_TARGETS.md` and `METRICS_REFERENCE.md` alignment with live targets | Not cross-checked | **Phase 4** |
| M29 | `LESSONS-LEARNED.md` — incorporate every lesson into runbooks | Not done | **Phase 5 doc reconciliation** |
| M30 | `ERROR_REMEDIATION_PLAN.md` open items | Not reviewed | **Phase 5 doc reconciliation** |

---

## Section 5 — NEW PHASES (added to PLAN/TODO in the update below)

- **Phase 1F · Credentials Sweep** — Audit 13 execution; no rotation yet, inventory + perms + git history
- **Phase 1G · Feb-17 Mitigations Verification** — `bufferingSize: 100`, acme.json `600`, service-monitor `|| true`
- **Phase 6 · DNS Verification** — Audit 02 deliverables condensed to pre-lock checks
- **Phase 7 · Mail Verification** — Audit 06 condensed to pre-lock checks
- **Phase 8 · Branding + `.qui3tly.cloud` migration prerequisites (POST-Gate-F roadmap, not a blocker)**

Full content in updated PLAN.md and TODO.md sections appended below.

---

## Section 6 — Evidence tracker mapping

Every rule R01–R22 in §1 must show up as at least one evidence file under `evidence/` with a clear acceptance criterion. The mapping is:

| Rule | Evidence file(s) |
|---|---|
| R01 | all evidence files (by existing — means we checked, not assumed) |
| R02 | `evidence/<node>_secrets_perms_*.txt` |
| R03 | `evidence/<node>_port_bindings_*.txt` |
| R04 | `evidence/<node>_compose_paths_*.txt` |
| R05 | `evidence/<node>_image_pins_*.txt` |
| R06 | `evidence/<node>_healthchecks_*.txt` |
| R07 | `evidence/<node>_resource_limits_*.txt` |
| R08 | `evidence/<node>_dir_layout_*.txt` |
| R09 | `evidence/github_symlinks_*.txt` |
| R10 | `evidence/master_resolv_conf_*.txt` |
| R11 | `evidence/fqdn_service_matrix_*.md` |
| R12 | `evidence/traefik_routers_<node>_*.txt` |
| R13 | `evidence/governance_selfcheck_*.md` |
| R14 | `evidence/mail_deliverability_*.txt` |
| R15 | `evidence/headscale_native_*.txt` |
| R16 | `evidence/lady_mta_inventory_*.txt` |
| R17 | `evidence/master_frr_absent_*.txt` |
| R18 | `evidence/master_resolv_immutable_*.txt` |
| R19 | `evidence/traefik_acme_perms_*.txt` |
| R20 | `evidence/traefik_accesslog_config_*.txt` |
| R21 | `evidence/service_monitor_script_*.txt` |
| R22 | N/A (process rule) |

If a rule has no evidence file on Gate-F day, the gate cannot be signed.

---

## How to use this index

1. Read §1 — internalise the 22 hard rules. Everything else exists to enforce them.
2. Read §2 — know which audits have/haven't been executed; close the gap.
3. Read §3 — know the actual live state of both nodes' compose files.
4. Read §4 — 30 new items I missed the first time, all now in the program.
5. Read §5 — the added phases.
6. Cross-reference §6 during Gate-F sign-off.

Next: applied additions to `PLAN.md` and `TODO.md` (see those files).

---

## Section 7 — Phase 1A verified (2026-04-23)

### Status: PASS

Three residual `public@file` compose-file bugs had already been corrected in the working tree (uncommitted since Feb-18 remediation). Live verification against both allowlisted and truly-external sources confirms the fix is effective.

### Evidence

- `evidence/01A_vpn_only_definition_*.txt` — `vpn-only@file` allowlist CIDRs
- `evidence/01A_vpn_only_live_*.txt` — Traefik live middleware API
- `evidence/01A_master_traefik_routers_*.txt` — router chain order
- `evidence/01A_non_vpn_test_*.txt` — initial (INVALID — allowlisted source)
- `evidence/01A_vpn_test_*.txt` — tailnet-routed allowlisted test
- `evidence/01A_external_probe_*.txt` — 9-node external probe via check-host.net
- `evidence/01A_vpn_admin_path_*.txt` — admin path reachable from VPN
- `evidence/01A_public_residual_check_*.txt` — `grep -r public@file` on VPN-only compose folders: empty

### Proof

External probe: 8/9 nodes returned `403 Forbidden` (9th timed out). Allowlisted source returned 200/302/404 (normal application responses). Differential = middleware is enforcing.

### Residual (non-blocking)

- **NB-1** `vpn-only@file` uses deprecated `ipWhiteList`. Traefik logs warning. Migrate to `ipAllowList` in Phase 5 config cleanup.
- **NB-2** `headscale-admin /` returns 404 even from VPN. Path needs discovery + documentation (Phase 5 docs).

### Allowlist CIDRs (documented for audit)

```
100.64.0.0/10         Tailscale VPN
192.168.99.0/24       Home LAN
10.10.0.0/30          WireGuard P2P
172.17-19.0.0/16      Docker bridge networks
172.30.0.0/24         Docker user network
172.70.9.0/29         Cloudflare (cert issuance / CF tunnel?)
213.136.68.108/32     Master public (self)
207.180.251.111/32    Lady public (self)
127.0.0.1/32          Loopback
```

**Consideration:** the two public-IP entries mean if either node's public-facing service is compromised it can hit admin panels. Accept for now — documented.
