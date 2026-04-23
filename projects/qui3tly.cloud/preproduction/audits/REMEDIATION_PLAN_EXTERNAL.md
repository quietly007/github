# REMEDIATION PLAN — EXTERNAL AUDIT

Date: 2026-04-21
Auditor: External / Independent

Rules:
  - Snapshot before patching or removing any service.
  - One change, one verification. No batched unverified changes.
  - Every step requires before and after evidence saved to preproduction/evidence/.
  - Do not mark done without measurable verification.

Execution order: Phase 0 → Phase 1 → Phase 2 → Phase 3 → Phase 4 → Phase 5 → Gates

---

## Phase 0: Safety Net (Day 0 — Before Anything Else)

### R0: Contabo VPS Snapshots

Effort: 30 min
Dependencies: Contabo account access
Must complete before: everything

Steps:
  1. Create Lady snapshot: label "preproduction-2026-04-21-before-patch"
  2. Create Master snapshot: label "preproduction-2026-04-21-before-patch"
  3. Confirm both show "completed" in Contabo panel
  4. Record snapshot IDs in evidence/snapshot_log_20260421.txt

Acceptance: Both snapshots completed before Phase 1.
Rollback: N/A — this IS the rollback mechanism.

---

## Phase 1: P0 Security Remediation (Day 1)

### R1: Lady Security Patch + Reboot

Effort: 2-3 hours (including post-reboot validation)
Dependencies: R0 (snapshot must exist)
Execution order: First Lady action

Steps:
  # Before
  uname -r | tee /tmp/before_patch.txt
  apt list --upgradable 2>/dev/null >> /tmp/before_patch.txt

  # Patch
  apt update && apt upgrade -y

  # Reboot
  reboot

  # After (wait 3 minutes, reconnect SSH)
  uname -r                          # verify >= 6.1.0-44-cloud-amd64
  docker ps | wc -l                 # verify all 38 containers running
  uptime                            # confirm fresh boot

Acceptance:
  - apt list --upgradable returns empty (or non-security only)
  - Kernel >= 6.1.0-44-cloud-amd64
  - 38 containers running within 5 min of boot
  - Prometheus targets restore to 20/20 within 10 min
  - Zero new Alertmanager alerts

Rollback: Restore Contabo Lady snapshot if boot fails.

---

### R2: Lady — Identify and Remove Non-Core Listeners

Effort: 1-2 hours
Dependencies: R1 complete
Execution order: After Lady reboot validated

Steps:
  # Step 1: Document current state
  ss -tlnp | grep '0.0.0.0' | tee /tmp/lady_listeners_before.txt

  # Step 2: Identify each unknown process
  # For python3:5000:
  PID=$(ss -tlnp | grep ':5000' | grep -oP 'pid=\K[0-9]+' | head -1)
  ls -la /proc/$PID/exe
  cat /proc/$PID/cmdline | tr '\0' ' '

  # For port 30715:
  PID=$(ss -tlnp | grep ':30715' | grep -oP 'pid=\K[0-9]+' | head -1)
  ls -la /proc/$PID/exe

  # Step 3: Remove HTCondor/Pegasus
  systemctl stop condor 2>/dev/null
  systemctl disable condor 2>/dev/null
  dpkg -l condor 2>/dev/null && apt remove --purge condor

  # Step 4: Address python3:5000
  # If UISP (nico640/docker-unms): bind to localhost in compose, restart container
  # If unknown: kill $PID and identify source, then prevent restart

  # Step 5: Verify clean state
  ss -tlnp | grep '0.0.0.0' | tee /tmp/lady_listeners_after.txt

Acceptance:
  ss -tlnp | grep '0.0.0.0' returns ONLY: 80, 443, 25, 465, 587, 993, 995, 4190, 1006

Rollback: Document all service dependencies before stopping any process. Restore snapshot if needed.

---

### R3: Lady — Fix UFW Broad Internal Rules

Effort: 1 hour
Dependencies: R2 complete, Docker network subnets enumerated
Execution order: After R2

Steps:
  # Enumerate actual Docker bridge subnets
  docker network inspect $(docker network ls -q) | \
    jq -r '.[] | "\(.Name): \(.IPAM.Config[0].Subnet // "none")"' | \
    tee /tmp/lady_docker_subnets.txt

  # Add specific rules (use actual subnets from above)
  # Example — replace with real subnets:
  ufw allow in from <traefik_subnet> comment "traefik bridge"
  ufw allow in from <nextcloud_subnet> comment "nextcloud bridge"
  # ... repeat for each bridge

  # Remove broad rules
  ufw delete allow in from 172.16.0.0/12
  ufw delete allow in from 10.0.0.0/8

  # Verify
  ufw status verbose | tee /tmp/lady_ufw_after_r3.txt

  # Test inter-container communications
  docker exec traefik ping -c2 crowdsec 2>/dev/null || true

  # Test external service still accessible
  curl -sk https://quietly.online/ | head -3

Acceptance:
  - No 172.16.0.0/12 or 10.0.0.0/8 in ufw status
  - All external services operational after rule change

Rollback:
  ufw allow in from 172.16.0.0/12 comment "Docker internal TEMPORARY"
  ufw allow in from 10.0.0.0/8 comment "Docker internal TEMPORARY"
  # Then investigate which specific subnet was needed

---

### R4: Master — AIDE Repair

Effort: 1 hour
Dependencies: None (can run parallel to Lady work)
Execution order: Any time during Day 1

Steps:
  # Diagnose
  journalctl -u aide.service -n 50 | tee /tmp/aide_failure_reason.txt

  # Verify system cleanliness before reinitializing
  debsums -c 2>/dev/null | head -20

  # Reinitialize
  aideinit
  mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db

  # Enable timer
  systemctl enable --now aide.timer

  # Run check and review output
  aide --check 2>&1 | tee /tmp/aide_check_$(date +%Y%m%d).txt

  # Review output — investigate any unexpected changes
  grep -v "^$" /tmp/aide_check_$(date +%Y%m%d).txt | grep -vE "^(Okay|The|AIDE)"

  # Save to evidence
  cp /tmp/aide_check_$(date +%Y%m%d).txt \
     /home/qui3tly/projects/qui3tly.cloud/preproduction/evidence/master_aide_check_$(date +%Y%m%d).txt

Acceptance:
  systemctl status aide.timer shows ACTIVE and next trigger time
  aide --check exits with code 0
  Output reviewed — no unexplained changes

Rollback: AIDE is passive. Reinitializing is non-destructive.

---

## Phase 2: P0 DR Remediation (Day 2)

### R5: Lady — Implement Backup Jobs

Effort: 4-6 hours
Dependencies: R1 (patched system)
Execution order: Can begin during Day 1 if parallel engineer available

Sub-tasks:
  mkdir -p /backup/lady

  # a) Mailcow
  cd /opt/mailcow-dockerized
  bash helper-scripts/backup_and_restore.sh backup all
  ls -lh /var/mailcow/backup/   # verify artifact
  # Cron: 0 2 * * * cd /opt/mailcow-dockerized && bash helper-scripts/backup_and_restore.sh backup all >> /var/log/mailcow_backup.log 2>&1

  # b) Nextcloud DB
  docker exec nextcloud-db mysqldump -u root --all-databases > /backup/lady/nextcloud_db_$(date +%Y%m%d).sql
  wc -l /backup/lady/nextcloud_db_$(date +%Y%m%d).sql   # verify non-empty

  # c) Nextcloud files
  docker exec nextcloud php /var/www/html/occ maintenance:mode --on
  rsync -av <nextcloud_data_path>/ /backup/lady/nextcloud_files/
  docker exec nextcloud php /var/www/html/occ maintenance:mode --off

  # d) Odoo
  docker exec odoo-db pg_dumpall -U odoo > /backup/lady/odoo_$(date +%Y%m%d).sql

  # e) UniFi
  docker exec unifi-db mongodump --out /backup/lady/unifi_$(date +%Y%m%d)/

  # f) Home Assistant config
  rsync -av <ha_config_path>/ /backup/lady/homeassistant/

  # g) Remote offsite
  apt install restic
  restic -r s3://<bucket>/lady init
  restic -r s3://<bucket>/lady backup /backup/lady/
  restic -r s3://<bucket>/lady snapshots   # verify

  # h) Schedule all via cron
  crontab -e
  crontab -l | tee /home/qui3tly/projects/qui3tly.cloud/preproduction/evidence/lady_crontab_$(date +%Y%m%d).txt

Acceptance:
  - All 6 service backup artifacts present in /backup/lady/
  - Remote restic snapshot confirmed
  - Cron schedule documented in evidence

---

### R6: Restore Drills

Effort: 4 hours per node
Dependencies: R5 complete with at least one artifact

Drill protocol:
  1. Record T0 (start timestamp)
  2. Restore to test target (not production data path)
  3. Verify data integrity
  4. Record T1 (completion timestamp) → RTO = T1 - T0
  5. Calculate RPO = drill start - backup creation time
  6. Save all output to evidence/restore_drill_<node>_<date>.txt

Nextcloud DB drill example:
  docker exec nextcloud-db mysql -e "CREATE DATABASE nc_restore_test;"
  docker exec -i nextcloud-db mysql nc_restore_test < /backup/lady/nextcloud_db_*.sql
  docker exec nextcloud-db mysql nc_restore_test -e "SHOW TABLES;" | wc -l
  # Record table count vs original

Acceptance:
  - At least one restore drill per node with timing
  - RTO <= 4h for mail/Nextcloud, <= 8h for Odoo
  - Drill evidence saved to evidence/

---

## Phase 3: P1 Remediation (Day 3)

### R7: Container Resource Limits

Effort: 4-6 hours per node (incremental rollout)
Dependencies: Load root cause identified (R8 below)
Execution order: Utility → Apps → Critical infra → Monitoring heavy-hitters

Rollout sequence per node:
  1. Run docker stats --no-stream baseline → save to evidence
  2. Apply limits to utility containers
  3. Monitor 30 min → docker stats --no-stream
  4. Apply limits to app containers → monitor
  5. Apply limits to critical infra → monitor
  6. Apply limits to monitoring stack (careful — test prometheus memory at runtime first)

Compose snippet:
  services:
    traefik:
      deploy:
        resources:
          limits:
            cpus: '0.5'
            memory: 512M
      pids_limit: 200

Acceptance:
  docker inspect $(docker ps -q) | jq '.[].HostConfig.Memory' | grep -v '^0$' | wc -l
  # Should equal total container count for critical/stateful services
  dmesg | grep -i oom   # should return nothing

Rollback: Remove deploy.resources block and docker compose up -d

---

### R8: Traefik Hardening Verification

Effort: 2 hours
Dependencies: None

Steps:
  docker exec traefik cat /etc/traefik/traefik.yml | \
    tee /home/qui3tly/projects/qui3tly.cloud/preproduction/evidence/traefik_static_$(date +%Y%m%d).txt

  curl -s http://127.0.0.1:8080/api/http/routers | \
    jq '.[] | {name:.name, middlewares:.middlewares}' | \
    tee /home/qui3tly/projects/qui3tly.cloud/preproduction/evidence/traefik_routers_$(date +%Y%m%d).txt

  # Verify dashboard not insecure
  grep "insecure" /path/to/traefik/traefik.yml || echo "insecure not found — check manual"

  # Verify security headers
  curl -si https://qui3tly.cloud/ | grep -iE 'x-frame|strict-transport|x-content-type'

Acceptance:
  - No routers with empty middleware on public routes
  - Security headers present on public HTTPS responses
  - api.insecure: false (or absent)

---

## Phase 4: P2 Remediation (Day 4)

### R9: Sysctl Hardening Alignment

Effort: 1 hour
Create on both nodes:
  cat > /etc/sysctl.d/99-hardening.conf << 'EOF'
  net.ipv4.conf.all.accept_redirects = 0
  net.ipv4.conf.default.accept_redirects = 0
  net.ipv4.conf.all.send_redirects = 0
  net.ipv4.conf.all.rp_filter = 1
  net.ipv4.tcp_syncookies = 1
  kernel.kptr_restrict = 2
  kernel.dmesg_restrict = 1
  kernel.randomize_va_space = 2
  EOF
  sysctl --system

Rollback: rm /etc/sysctl.d/99-hardening.conf && sysctl --system

### R10: Image Updates (P2-3)

Effort: 2 hours
Update cloudflared, homeassistant, prometheus, grafana one at a time.
docker compose pull <service> && docker compose up -d <service>
Verify healthy after each before proceeding to next.
Tag uptime-kuma with named version (not digest).

---

## Phase 5: Documentation + Gates (Day 5)

1. Capture all new evidence: sysctl, AIDE, Traefik config, container inspect, crontab
2. Update PREPRODUCTION_TODO.md with completion timestamps
3. Create FQDN service matrix
4. Update drifted docs to current state
5. Commit all evidence to preproduction/evidence/
6. Run gate checklist → issue signed Go/No-Go report
