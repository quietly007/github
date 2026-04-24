# FINDINGS VALIDATION — EXTERNAL AUDIT

Date: 2026-04-21
Auditor: External / Independent
Evidence Timestamp: 20260420T193118Z
Method: Each internal finding cross-checked against evidence snapshots. Where evidence is insufficient, findings are marked "Needs Validation."

---

## Validation Legend

| Symbol | Meaning |
|--------|---------|
| CONFIRMED | Finding validated by direct evidence |
| CONFIRMED + UPGRADED | Finding confirmed and severity raised |
| NEEDS VALIDATION | Insufficient evidence to confirm or deny |
| NEW FINDING | Not in original report; found by external review |

---

## P0-1: Lady Security Patch Backlog — CONFIRMED, P0 maintained

Severity: Critical
Impact: Internet-facing mail/app node running packages with known CVEs. Kernel 80 days and 2 minor versions behind Master.

Evidence:
- evidence/11_lady_snapshot: kernel 6.1.0-42-cloud-amd64 (2025-12-30), up 61 days
- evidence/10_master_snapshot: kernel 6.1.0-44-cloud-amd64 (2026-03-09) for comparison

External challenge: Original report is correct but understated. 61-day unpatched node with open SMTP (port 25) is in the actively-exploited threat model for common Debian package classes — this is not merely a "policy gap."

Validation commands (post-remediation):
  apt list --upgradable 2>/dev/null | grep -i security   # should return empty
  uname -r                                               # should be >= 6.1.0-44

Remediation: apt update && apt upgrade -y, then reboot, verify all 38 containers restart.
Rollback: Restore Contabo snapshot if boot fails. Must snapshot BEFORE patching.

---

## P0-2: Lady Backup Posture — CONFIRMED, P0 maintained

Severity: Critical
Impact: Complete unrecoverable data loss for Nextcloud, Mailcow, Odoo, UniFi, Home Assistant (215G of live data, no evidenced backup chain).

Evidence:
- evidence/11_lady_snapshot: no backup tooling visible (no restic, borgbackup, rsync cron)
- reports/DOCUMENTATION_COVERAGE_MATRIX.md: Operations/backup/DR = PARTIAL (drill evidence pending)
- reports/ACCURACY_VALIDATION_REPORT.md: restore drills listed under "Not yet fully validated"
- todo/PREPRODUCTION_TODO.md: all 5 DR tasks = not started

External challenge: Correctly identified as P0. The probability of needing a restore in any given week is low; the consequence when it is needed without backups is catastrophic and irreversible. This is an unconditional production blocker.

Validation commands (post-remediation):
  crontab -l                         # confirm backup schedule
  ls -lh /backup/                    # confirm recent artifacts
  restic snapshots                   # confirm remote backup destination

Remediation: Implement per-service backup jobs (Mailcow built-in script, mysqldump for Nextcloud, pg_dumpall for Odoo, mongodump for UniFi). Schedule daily cron. Configure remote encrypted offsite destination. Run restore drill per service.

---

## P0-3: Unscoped Listeners on Lady — CONFIRMED + UPGRADED

Severity: Critical (upgraded from original High — more ports found than described)
Impact: 7 unexplained 0.0.0.0 listeners on production mail/app node. Docker userland-proxy may bypass UFW default-deny.

Evidence (from evidence/11_lady_snapshot):
  Port 9618  0.0.0.0 — HTCondor collector
  Port 6789  0.0.0.0 — HTCondor/condor_master
  Port 6769  0.0.0.0 — HTCondor daemon
  Port 4691  0.0.0.0 — Pegasus WMS
  Port 2529  0.0.0.0 — HTCondor
  Port 30715 0.0.0.0 — Unidentified
  Port 5000  0.0.0.0 — python3 pid=26417 (unknown service)

UFW rules reviewed: No explicit ALLOW for any of these ports. However, broad Docker rules (172.16.0.0/12, 10.0.0.0/8) present — see NEW FINDING AC-1.

External challenge: Original report flagged correct class of problem but understated scope. 7 listeners vs vague "condor/pegasus ports" reference. python3:5000 is an additional unknown.

Validation commands (post-remediation):
  ss -tlnp | grep '0.0.0.0' | grep -vE '80|443|25|465|587|993|995|4190|1006'
  # Should return: empty

Remediation:
  1. Identify each unknown process: ls -la /proc/<pid>/exe
  2. Stop and disable condor: systemctl stop condor && systemctl disable condor
  3. Identify python3:5000 — if known service, bind to localhost; if unknown, kill and investigate
  4. Identify port 30715 — same process
  5. After removal, verify with ss -tlnp
Rollback: Document all service dependencies before stopping. Snapshot before changes.

---

## P1-1: Master AIDE Failure — CONFIRMED, P1 maintained

Severity: High
Impact: File integrity controls non-functional. Undetected changes on Master (Headscale, Authelia, CrowdSec, Prometheus — high-value persistence targets).

Evidence: Referenced in reports/PREPRODUCTION_AUDIT_MERGED.md ("aide.service failed").
Traceability gap: Raw systemctl status aide output NOT in evidence snapshots. This P1 claim must be directly evidenced by adding systemctl/journalctl output to next evidence collection pass.

Validation commands:
  systemctl status aide.service aide.timer
  journalctl -u aide.service -n 50
  aide --check 2>&1 | tail -30

Remediation:
  journalctl -u aide.service -n 50   # diagnose failure reason
  aideinit                            # reinitialize after confirming clean system
  mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db
  systemctl enable --now aide.timer
Rollback: AIDE is passive (read-only). Reinitializing only changes the DB baseline — no system impact.

---

## P1-2: Container Resource Governance — CONFIRMED, P1 maintained

Severity: High
Impact: No limits on 25 (Master) + 38 (Lady) containers. One runaway process can OOM-kill all services on a node.

Evidence:
- evidence/10_master_snapshot: running_count=25, load 4.36/2.96/2.78
- evidence/11_lady_snapshot: running_count=38, load 4.68/2.85/2.59
- No resource constraint data visible in docker quick output (absence of limits = unlimited)

External challenge: Would escalate to P0 only if OOM events or near-memory-exhaustion evidenced. Master has 42Gi available, Lady 38Gi — not immediately critical, but the elevated load averages are unexplained and concerning.

Validation commands (post-remediation):
  docker inspect $(docker ps -q) | jq '.[].HostConfig | {Memory, CpuPeriod, PidsLimit}'
  # Expected: non-zero Memory for all critical/stateful containers

Remediation: Apply limits by service class in compose files:
  Class A (critical infra): mem_limit 512m, cpus 0.5, pids_limit 200
  Class B (stateful/db): mem_limit 2g, cpus 1.0
  Class C (utility): mem_limit 128m, cpus 0.25
Rollback: Remove deploy.resources block from compose and docker compose up -d.

---

## P1-3: Traefik Hardening — NEEDS VALIDATION

Severity: High (if misconfigured) / Medium (if locked down)
Impact: Unauthenticated access to internal services if middleware chain incomplete.

Evidence:
- Master: 127.0.0.1:8080 — Traefik dashboard on localhost (acceptable if not externally routed)
- Lady: 127.0.0.1:8080 — same
- Traefik static.yml, dynamic config, and router middleware lists NOT in evidence

Validation commands:
  docker exec traefik cat /etc/traefik/traefik.yml
  curl -s http://127.0.0.1:8080/api/http/routers | jq '.[] | {name:.name, middlewares:.middlewares}'
  curl -si https://qui3tly.cloud/ | grep -iE 'x-frame|strict-transport'

Classification held at P1 as a forcing function to capture this evidence before go-live.

---

## P2-1: Sysctl Hardening Drift — NEEDS VALIDATION

Severity: Medium
Evidence: sysctl output NOT captured in any evidence snapshot. Cannot confirm or deny.
Action: Add sysctl output to next evidence collection pass.

Validation:
  sysctl net.ipv4.conf.all.accept_redirects net.ipv4.conf.all.send_redirects \
         kernel.kptr_restrict kernel.dmesg_restrict net.ipv4.tcp_syncookies \
         kernel.randomize_va_space

---

## P2-2: Container Root/Privilege Minimization — NEEDS VALIDATION

Severity: Medium
Evidence: docker inspect with user field not captured. Inferred root for: python:3.11-slim (admin-panel), nginx variants, uisp (nico640/docker-unms historically root-only).

Validation:
  docker inspect $(docker ps -q) | jq -r '.[] | "\(.Name): \(.Config.User)"'
  # Empty User = running as root

---

## P2-3: Image Lifecycle Hygiene — CONFIRMED, P2 maintained

Severity: Medium

Aged images confirmed in evidence:
  Master: cloudflared:2024.12.2 (~4 months), prometheus:v2.54.1 (~5 months), grafana:11.4.0 (~4 months)
  Master: uptime-kuma running as digest f48d816cb746 (no tag — cannot audit version)
  Lady: homeassistant:2024.12.5 (~4 months), nextcloud:29.0.7 (upstream at 30.x)

Validation:
  docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.CreatedSince}}\t{{.Size}}"
  docker system df

---

## NEW FINDINGS (Not in Original Report)

### AC-1: Lady UFW Broad Internal Allow Rules — NEW, rated P1

Severity: High
Evidence from evidence/11_lady_snapshot:
  Anywhere   ALLOW IN   172.16.0.0/12   # Docker internal
  Anywhere   ALLOW IN   10.0.0.0/8      # Docker internal

Impact: Entire RFC 1918 Docker address space allowed inbound. If any container is compromised, lateral movement to host and other containers is trivially possible.

Remediation:
  docker network inspect $(docker network ls -q) | jq -r '.[].IPAM.Config[0].Subnet' | sort -u
  # Add specific rules per subnet, then remove broad rules:
  ufw delete allow in from 172.16.0.0/12
  ufw delete allow in from 10.0.0.0/8

### AC-2: Unidentified python3:5000 Process — NEW, rated P0

Severity: Critical
Evidence: python3 pid=26417 and pid=26313 listening on 0.0.0.0:5000. Not associated with any compose service in Lady inventory.
Impact: Unknown internet-facing process on production node. Could be debug server, Flask dev server, or leftover test process.

Investigation:
  ls -la /proc/26417/exe
  cat /proc/26417/cmdline | tr '\0' ' '

### AC-3: Master Elevated Load Average — NEW, rated P2

Severity: Medium
Evidence: load 4.36 (1m) with only 4.4Gi/47Gi RAM used. VS Code server process (pid 319669) visible in listener list.
Investigation:
  nproc
  ps -eo pid,cmd,%cpu --sort=-%cpu | head -15

### AC-4: Nextcloud 5-Hour Uptime on Lady — NEW, rated P2

Severity: Medium
Evidence: nextcloud container shows "Up 5 hours" while most Lady containers show "Up 2 months". Unexplained restart.
Investigation:
  docker inspect nextcloud | jq '.[0].State | {StartedAt, FinishedAt, RestartCount}'
