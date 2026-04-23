# ACTION PLAN TODO — EXTERNAL AUDIT

Date: 2026-04-21
Auditor: External / Independent
Owner: qui3tly
Format: Ordered checklist. Work top-to-bottom. Do not skip items. Do not mark done without evidence.

Legend:
  [ ] not started
  [-] in progress
  [x] complete (add: date + evidence file reference)

---

## PHASE 0 — SAFETY NET (Required Before Any Changes)

- [ ] [R0-1] Create Contabo snapshot for Lady → label: preproduction-2026-04-21-before-patch
- [ ] [R0-2] Create Contabo snapshot for Master → label: preproduction-2026-04-21-before-patch
- [ ] [R0-3] Record snapshot IDs and completion timestamps → evidence/snapshot_log_20260421.txt

Acceptance: Both snapshots "completed" in Contabo panel before Phase 1.

---

## PHASE 1 — SECURITY REMEDIATION

### 1A: Lady Patching (P0-1)

- [ ] [R1-1] Capture pre-patch state → ssh lady "uname -r; apt list --upgradable 2>/dev/null" > evidence/lady_pre_patch_$(date +%Y%m%d).txt
- [ ] [R1-2] Patch Lady → ssh lady "apt update && apt upgrade -y"
- [ ] [R1-3] Reboot Lady → ssh lady "reboot"
- [ ] [R1-4] Verify kernel upgraded → uname -r (must be >= 6.1.0-44-cloud-amd64)
- [ ] [R1-5] Verify 38 containers running → docker ps | wc -l
- [ ] [R1-6] Verify Prometheus targets restored → curl master:9090/api/v1/targets (20/20)
- [ ] [R1-7] Verify zero new alerts → curl master:9093/api/v2/alerts | jq length
- [ ] [R1-8] Save post-patch evidence → evidence/lady_post_patch_$(date +%Y%m%d).txt

Acceptance: Kernel upgraded, all 38 containers up, 20/20 targets, 0 new alerts.

### 1B: Lady — Identify and Remove Non-Core Listeners (P0-3 + AC-2)

- [ ] [R2-1] Document listener state before → ss -tlnp | grep '0.0.0.0' > evidence/lady_listeners_before_$(date +%Y%m%d).txt
- [ ] [R2-2] Identify python3:5000 process → ls -la /proc/$(ss -tlnp | grep ':5000' | grep -oP 'pid=\K[0-9]+' | head -1)/exe
- [ ] [R2-3] Identify port 30715 process → same technique
- [ ] [R2-4] Document findings: is python3:5000 a known service? Record in evidence.
- [ ] [R2-5] Stop and disable condor service (or remove package)
- [ ] [R2-6] Remove or bind python3:5000 to localhost/VPN
- [ ] [R2-7] Remove or bind port 30715 to localhost/VPN
- [ ] [R2-8] Add UFW explicit deny for removed ports → ufw deny 9618/tcp comment "HTCondor removed"
- [ ] [R2-9] Verify clean listener state → ss -tlnp | grep '0.0.0.0' > evidence/lady_listeners_after_$(date +%Y%m%d).txt

Acceptance: Only ports 80, 443, 25, 465, 587, 993, 995, 4190, 1006 remain on 0.0.0.0.

### 1C: Lady — UFW Broad Rule Fix (AC-1)

- [ ] [R3-1] Enumerate Docker bridge subnets → docker network inspect $(docker network ls -q) | jq -r '.[].IPAM.Config[0].Subnet' | sort -u
- [ ] [R3-2] Save subnet list to evidence
- [ ] [R3-3] Add specific subnet UFW rules for each Docker bridge
- [ ] [R3-4] Remove broad 172.16.0.0/12 rule → ufw delete allow in from 172.16.0.0/12
- [ ] [R3-5] Remove broad 10.0.0.0/8 rule → ufw delete allow in from 10.0.0.0/8
- [ ] [R3-6] Test inter-container communications still functional
- [ ] [R3-7] Test external services still accessible (HTTP check)
- [ ] [R3-8] Save ufw status verbose → evidence/lady_ufw_after_$(date +%Y%m%d).txt

Acceptance: Broad rules gone; all services operational; evidence captured.

### 1D: Master — AIDE Repair (P1-1)

- [ ] [R4-1] Check failure reason → journalctl -u aide.service -n 50 > evidence/master_aide_failure_$(date +%Y%m%d).txt
- [ ] [R4-2] Verify system cleanliness → debsums -c 2>/dev/null | head -20
- [ ] [R4-3] Reinitialize AIDE → aideinit
- [ ] [R4-4] Move DB → mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db
- [ ] [R4-5] Enable timer → systemctl enable --now aide.timer
- [ ] [R4-6] Verify timer active → systemctl list-timers aide.timer
- [ ] [R4-7] Run check → aide --check 2>&1 | tee evidence/master_aide_check_$(date +%Y%m%d).txt
- [ ] [R4-8] Review AIDE output — investigate any unexpected file changes

Acceptance: aide.timer active, aide --check exits cleanly, output reviewed and saved.

---

## PHASE 2 — BACKUP AND DR

### 2A: Lady Backup Implementation (P0-2)

- [ ] [R5-1]  Create backup directory → mkdir -p /backup/lady
- [ ] [R5-2]  Run Mailcow backup manually → cd /opt/mailcow-dockerized && bash helper-scripts/backup_and_restore.sh backup all
- [ ] [R5-3]  Verify Mailcow backup artifacts → ls -lh /var/mailcow/backup/
- [ ] [R5-4]  Run Nextcloud DB dump → docker exec nextcloud-db mysqldump -u root --all-databases > /backup/lady/nextcloud_db_$(date +%Y%m%d).sql
- [ ] [R5-5]  Run Odoo dump → docker exec odoo-db pg_dumpall -U odoo > /backup/lady/odoo_$(date +%Y%m%d).sql
- [ ] [R5-6]  Run UniFi dump → docker exec unifi-db mongodump --out /backup/lady/unifi_$(date +%Y%m%d)/
- [ ] [R5-7]  Copy HA config → rsync -av <ha_config_path>/ /backup/lady/homeassistant/
- [ ] [R5-8]  Configure remote backup → install restic, init repo, first transfer
- [ ] [R5-9]  Schedule all jobs in cron → crontab -e
- [ ] [R5-10] Save cron evidence → crontab -l > evidence/lady_crontab_$(date +%Y%m%d).txt
- [ ] [R5-11] Verify remote snapshot → restic snapshots

Acceptance: All 6 service artifacts present, cron scheduled, remote backup confirmed.

### 2B: Master Backup Verification

- [ ] [R5M-1] Check Master backup jobs → crontab -l && systemctl list-timers | grep backup
- [ ] [R5M-2] Verify artifacts present → ls -lh /backup/master/ or equivalent
- [ ] [R5M-3] If missing: implement config/secrets backup (projects/, .docs/, .env files)
- [ ] [R5M-4] Verify Headscale DB backed up

### 2C: Restore Drills

- [ ] [R6-1]  Lady — Nextcloud DB restore drill (to test schema, with timing)
- [ ] [R6-2]  Lady — Mailcow restore drill (subset/non-destructive)
- [ ] [R6-3]  Master — Config restore drill (to /tmp/restore_test/)
- [ ] [R6-4]  Document all drill results → evidence/restore_drills_$(date +%Y%m%d).txt
- [ ] [R6-5]  Calculate and record: achieved RTO vs target, achieved RPO vs target

Acceptance: At least one successful restore drill per node, timing evidence saved, RTO <= target.

---

## PHASE 3 — PLATFORM STABILITY

- [ ] [R7-1]  docker stats --no-stream baseline on both nodes → save to evidence
- [ ] [R7-2]  nproc on both nodes → record CPU count
- [ ] [R7-3]  Apply limits to utility containers (Master first)
- [ ] [R7-4]  Monitor 30 min → confirm no regressions
- [ ] [R7-5]  Apply limits to app containers
- [ ] [R7-6]  Monitor 30 min
- [ ] [R7-7]  Apply limits to critical infra
- [ ] [R7-8]  Monitor 1 hour
- [ ] [R7-9]  Apply limits to monitoring stack (careful — test prometheus memory first)
- [ ] [R7-10] Repeat for Lady
- [ ] [R7-11] Document justified exceptions → evidence/resource_exceptions.txt
- [ ] [R7-12] Final verify: no zero Memory values for critical services

- [ ] [R8-1]  Export Traefik static config → evidence/traefik_static_$(date +%Y%m%d).txt
- [ ] [R8-2]  Export Traefik dynamic config → evidence/traefik_dynamic_$(date +%Y%m%d).txt
- [ ] [R8-3]  Verify api.insecure: false
- [ ] [R8-4]  List all active routers and middleware → evidence/traefik_routers_$(date +%Y%m%d).txt
- [ ] [R8-5]  Confirm every public router has auth middleware
- [ ] [R8-6]  Confirm security headers on 3+ public endpoints
- [ ] [R8-7]  Fix any unprotected routes

---

## PHASE 4 — MONITORING AND ALERTING

- [ ] [M-1]  Fire test alert via Alertmanager API
- [ ] [M-2]  Confirm Ntfy push notification received on device
- [ ] [M-3]  Confirm Gotify notification received
- [ ] [M-4]  Record time-to-notification (target: < 5 min)
- [ ] [M-5]  List all alert rule names → curl localhost:9090/api/v1/rules
- [ ] [M-6]  Add missing mandatory rules (NodeDown, HighDisk, CertExpiry, ContainerOOM)
- [ ] [M-7]  Verify Loki retention policy set
- [ ] [M-8]  Verify Blackbox probe targets cover all critical endpoints
- [ ] [M-9]  Add preproduction KPI dashboard in Grafana
- [ ] [M-10] Pin uptime-kuma to named image tag (not digest)
- [ ] [M-11] Add backup failure metric/alert (after backup jobs implemented)

---

## PHASE 5 — DOCUMENTATION

- [ ] [D-1]  Capture additional evidence (sysctl, AIDE, Traefik, container inspect, crontab)
- [ ] [D-2]  Update PREPRODUCTION_TODO.md with completion timestamps and evidence references
- [ ] [D-3]  Create FQDN service matrix (service, auth type, expected response, last tested)
- [ ] [D-4]  Create change log from Feb baseline to Apr snapshot
- [ ] [D-5]  Update drifted docs (container counts, versions, topology)
- [ ] [D-6]  Commit all new evidence files to preproduction/evidence/
- [ ] [D-7]  Update DOCUMENTATION_COVERAGE_MATRIX.md — mark DR as VERIFIED after drills

---

## PHASE 6 — PRODUCTION GATES FINAL CHECK

- [ ] [GATE-A] Security: apt list --upgradable empty on Lady | no rogue listeners | AIDE active | CrowdSec healthy
- [ ] [GATE-B] Resilience: backup artifacts confirmed | restore drill evidence | RTO/RPO within targets
- [ ] [GATE-C] Stability: resource limits applied to all critical/stateful | no OOM events | load root cause known
- [ ] [GATE-D] Documentation: all evidence committed | TODO fully checked | FQDN matrix complete
- [ ] [GATE-E] Monitoring: alert pipeline tested end-to-end | mandatory rules present | Loki retention set
- [ ] [GATE-FINAL] Issue signed Go/No-Go decision report → audits/GO_NOGO_DECISION_$(date +%Y%m%d).md

---

## Immediate Next 10 Commands (Operator Runbook)

Execute in this exact order:

  # 1. Snapshot Lady in Contabo panel (manual — browser)

  # 2. Capture Lady pre-patch state
  ssh lady "uname -r; apt list --upgradable 2>/dev/null" > \
    ~/projects/qui3tly.cloud/preproduction/evidence/lady_pre_patch_$(date +%Y%m%d).txt

  # 3. Patch Lady
  ssh lady "apt update && apt upgrade -y"

  # 4. Reboot Lady
  ssh lady "reboot"

  # 5. Post-reboot verify (wait 3 min)
  ssh lady "uname -r; docker ps | wc -l; uptime"

  # 6. Identify python3:5000 on Lady
  ssh lady "ss -tlnp | grep '0.0.0.0'; \
    PID=\$(ss -tlnp | grep ':5000' | grep -oP 'pid=\K[0-9]+' | head -1); \
    ls -la /proc/\$PID/exe 2>/dev/null; \
    cat /proc/\$PID/cmdline 2>/dev/null | tr '\0' ' '"

  # 7. Fix AIDE on Master (while Lady is rebooting)
  journalctl -u aide.service -n 30
  aideinit
  mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db
  systemctl enable --now aide.timer
  aide --check 2>&1 | tail -20

  # 8. Check Lady backup state after reboot
  ssh lady "crontab -l 2>/dev/null; ls -lh /backup/ 2>/dev/null || echo NO_BACKUP_DIR"

  # 9. List remaining Lady 0.0.0.0 listeners
  ssh lady "ss -tlnp | grep '0.0.0.0'"

  # 10. Check Prometheus targets and alerts
  curl -s http://localhost:9090/api/v1/targets | \
    jq '.data.activeTargets | {up: map(select(.health=="up")) | length, down: map(select(.health!="up")) | length}'
