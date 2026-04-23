# PLAN — qui3tly.cloud Perfection Program

**Date:** 2026-04-21
**Target end state:** All 6 gates PASS; signed Go/No-Go under `gates/GATE_F_GO_NOGO.md`.
**Duration estimate:** 3–5 focused working days.

---

## Phase 0 — Safety net (MUST come first)

1. Contabo snapshot — Lady → label `perfection-2026-04-21-pre`
2. Contabo snapshot — Master → label `perfection-2026-04-21-pre`
3. Confirm both "completed" in Contabo panel
4. Record snapshot IDs + UTC completion timestamps → `evidence/00_snapshot_log.txt`
5. Freeze non-essential changes (no new containers/FQDNs) until Gate-F
6. `cd ~ && git add -A && git commit -m "perfection: pre-phase-0 freeze"`

**Exit (Gate-0):** Both snapshots completed, IDs logged, freeze acknowledged.

---

## Phase 1 — P0 security remediation

### 1A · Residual public@file fix (Master) — 5 min, zero risk

Fix the three admin panels wrongly exposed since Feb-16 (`pihole`, `headscale-ui`, `headscale-admin`). Middleware label change → no container recreate. See `runbooks/01_p0_security_residual.md`.

### 1B · Lady patch + reboot (P0-1)

- Pre-patch evidence → `evidence/lady_pre_patch_<date>.txt`
- `apt update && apt upgrade -y`
- `reboot`; wait 3 min
- Verify kernel ≥ 6.1.0-44, 38 containers up, 20/20 Prom targets, 0 new alerts
- Post-patch evidence → `evidence/lady_post_patch_<date>.txt`

### 1C · Lady unscoped listeners + unknown python (P0-3 + P0-4)

- `ss -tlnp | grep 0.0.0.0` → evidence (before)
- For each of 9618/6789/6769/4691/2529/30715/5000: `ls -la /proc/<pid>/exe` + `cat /proc/<pid>/cmdline`
- `systemctl stop condor && systemctl disable condor`; `apt remove --purge condor pegasus-wms 2>/dev/null`
- python3:5000 — trace before killing. If UISP → bind `100.64.0.2:5000`. If unknown → kill + investigate
- After: only 80, 443, 25, 465, 587, 993, 995, 4190, 1006 on 0.0.0.0

### 1D · Lady UFW broad-rule fix (P1-4)

- Enumerate real Docker subnets
- Add specific allows per bridge
- Delete `allow in from 172.16.0.0/12` and `allow in from 10.0.0.0/8`
- Verify inter-container comms + external HTTP probe still work

### 1E · Master AIDE repair (P1-1)

- `journalctl -u aide.service -n 50` → evidence
- `debsums -c` sanity check
- `aideinit`; move DB; `systemctl enable --now aide.timer`
- `aide --check` → review output

**Exit (Gate-A):** All 4 P0 closed, residual fixed, AIDE timer active, no broad UFW rules, patches current.

---

## Phase 2 — P0 resilience remediation

### 2A · Lady backup jobs (P0-2)

Per service, artifacts under `/backup/lady/`:

| Service | Method |
|---|---|
| Mailcow | `helper-scripts/backup_and_restore.sh backup all` |
| Nextcloud DB | `mysqldump --all-databases` |
| Nextcloud files | `maintenance:mode --on` → `rsync` → `--off` |
| Odoo | `pg_dumpall -U odoo` |
| UniFi | `mongodump` |
| Home Assistant | `rsync` config |

- `restic` to offsite S3-compatible bucket (encrypted)
- Daily cron; retention `keep-daily 7 --keep-weekly 4 --keep-monthly 3 --prune`

### 2B · Master backup verification

- `crontab -l` + `systemctl list-timers | grep -i backup` → evidence
- If missing: add config/secrets restic job
- Confirm Contabo daily 00:00 snapshot in panel

### 2C · Restore drills (mandatory, ≥1 per node)

- Record T0 → restore to non-production path → verify integrity → T1 → RTO = T1-T0
- RPO = drill_start - backup_creation
- `evidence/restore_drill_<node>_<service>_<date>.txt`

**Exit (Gate-B):** Backups fresh (≤24h), remote restic confirmed, cron documented, ≥3 drills evidenced with RTO/RPO within targets.

---

## Phase 3 — Platform stability

### 3A · Baseline + load RCA
- `nproc`, `docker stats --no-stream`, `ps --sort=-%cpu`
- Investigate Nextcloud RestartCount + Traefik 2-month uptime anomaly

### 3B · Resource limits incremental rollout

Order: **Utility → Apps → Critical infra → Monitoring** (prometheus LAST).

Per-node resource classes per external PERFORMANCE_CAPACITY_REVIEW:

**Master**
- Critical infra (traefik, authelia, crowdsec, pihole): 512 MB / 0.5 CPU / 200 pids
- Monitoring (prometheus, loki, alertmanager): 2 GB / 1.0 CPU / 500 pids
- Apps: 512 MB / 0.5 CPU / 200 pids
- Utility: 128 MB / 0.25 CPU / 100 pids

**Lady**
- Mail (postfix, dovecot, rspamd): 1 GB / 1.0 CPU / 500 pids
- Antivirus (clamd): 2 GB / 1.5 CPU / 200 pids
- DBs: 2 GB / 1.0 CPU / 300 pids
- Apps (nextcloud, odoo): 2 GB / 1.0 CPU / 500 pids
- OnlyOffice: **test 4 GB first**
- Utility: 128 MB / 0.25 CPU / 100 pids

Monitor 30 min after each class. `dmesg | grep -i oom` stays empty.

### 3C · Traefik hardening verification (P1-3)
- Export static + dynamic config
- Router + middleware inventory
- Confirm `api.insecure: false`
- Curl 3 public HTTPS for HSTS / X-Frame-Options / X-Content-Type-Options

### 3D · Healthcheck gaps
- Add healthchecks on: cloudflared, headscale-admin, headscale-ui, it-tools, default-landing, portainer, node-exporter

**Exit (Gate-C):** All critical/stateful services have mem_limit; no OOM; load 1-min ≤ nproc on both nodes.

---

## Phase 4 — Monitoring e2e

- Fire test alert via Alertmanager API
- Confirm Ntfy + Gotify delivery; record time-to-notify (< 5 min)
- List alert rules; add missing: NodeDown, HighMemory, HighDisk, CriticalDisk, ContainerOOM, TargetDown, CertExpiry30d, BackupStale
- Bound Loki retention (e.g. 90d)
- Blackbox probe coverage complete
- Pin uptime-kuma to named tag
- Grafana "Perfection KPI" dashboard

**Exit (Gate-E):** Pipeline tested e2e; mandatory rules present; Loki bounded; Uptime Kuma tagged.

---

## Phase 5 — Documentation reconciliation + sign-off

1. Fill evidence gaps: sysctl, AIDE status, Traefik config, container inspect (restart policy + Memory + User + Mounts), `docker volume ls`, `docker system df`, `crontab -l`, `systemctl list-timers`, raw `iptables -L -n -v`, secrets perms (`find ~/.secrets -type f -printf "%m %p\n"`)
2. Deploy unified `/etc/sysctl.d/99-hardening.conf` both nodes; `sysctl --system`
3. Image updates one at a time (cloudflared, homeassistant, prometheus, grafana); pin uptime-kuma
4. Update drifted docs; FQDN service matrix; change log Feb → Apr
5. `git add -A && git commit -m "perfection: phase-5 evidence + doc reconciliation" && git push`
6. Sign gates A/B/C/D/E; issue GATE_F_GO_NOGO.md

**Exit (Gate-D):** Evidence complete, FQDN matrix exists, docs updated, git clean.

---

## Governance rules

- No undocumented emergency changes
- Every mutation: before evidence, command log, after verification, saved to `evidence/`
- No "done" without measurable acceptance
- No batched changes — one change, one verification, one evidence file
- Rollback on hard failure: restore the Phase-0 Contabo snapshot
- Append a dated entry to `gates/PHASE_LOG.md` after each phase

---

## Out of scope for this sprint

- **DOMAIN_STRATEGY v5** (Headscale independence, *.qui3tly.cloud migration) — separate program
- **Audit requests 01–13** execution — externalizable after perfection closes P0/P1
- **Montefish**, **Project Norma**, multi-site VPN, CCTV NVR, mobile apps — backlog

---

## Rollback plan summary

| Scenario | Action |
|---|---|
| Phase 1 patch breaks Lady boot | Contabo snapshot restore → perfection-2026-04-21-pre (Lady) |
| Phase 1 UFW change blocks inter-container | Re-add broad rules temporarily → investigate specific subnet |
| Phase 3 limits cause regression | Remove `deploy.resources` block; `docker compose up -d <svc>` |
| Phase 5 sysctl breaks networking | `rm /etc/sysctl.d/99-hardening.conf && sysctl --system` |
| Any hard failure | Contabo snapshot restore of affected node |

---

## Next action

Open `TODO.md` and execute item by item starting with Phase 0.
