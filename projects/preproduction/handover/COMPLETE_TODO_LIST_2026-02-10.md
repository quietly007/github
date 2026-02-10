# COMPLETE TODO LIST - NO FAIL EXECUTION PLAN
# A+++ PREPRODUCTION CERTIFICATION

**Date:** 2026-02-10
**Status:** Drafted from latest log sweep (read-only)
**Log Evidence Bundle:** /tmp/preproduction_logs_20260210_014012
**Scope:** P0/P1 fixes derived from live errors; extends COMPREHENSIVE_TODO_LIST_2026-02-09.md. Fill remaining items after P0/P1 are verified.

---

## ⚠️ MANDATORY EXECUTION PROTOCOL

### 🔴 USER APPROVAL REQUIREMENT (NON-NEGOTIABLE)

**EVERY TODO ITEM MUST FOLLOW THIS PROTOCOL:**

#### Before Execution:
1. **READ** entire TODO item (Evidence → Steps → Success Criteria → Rollback)
2. **ASK USER:** "Ready to execute TODO-PX-YY: [Task Name]? Y/N"
3. **WAIT** for user Y before proceeding
4. **IF N:** Skip or postpone, document reason, move to next

#### During Execution:
1. **DOCUMENT** every command executed (copy-paste to execution log)
2. **DOCUMENT** every output received (copy-paste actual terminal output)
3. **DOCUMENT** timestamps (YYYY-MM-DD HH:MM:SS UTC)
4. **SCREENSHOT** critical steps (web UIs, config changes, verification commands)

#### After Execution:
1. **WRITE MEMORY:** Create permanent record in `/home/qui3tly/personal/memories/TODO_PX_YY_YYYY-MM-DD.md`
2. **UPDATE PROJECT DOCS:** Update relevant files in `/home/qui3tly/personal/manuals/` and `/home/qui3tly/personal/`
3. **VERIFY:** Test all success criteria, document results
4. **ASK USER:** "TODO-PX-YY complete. Verification passed? Y/N"
5. **IF Y:** Mark complete in tracker, proceed to next
6. **IF N:** Document issues, execute rollback if needed

#### Triple Agent Verification:
1. **ALL execution evidence** goes into verification package
2. **Agent #1** verifies: Documentation complete, evidence present
3. **Agent #2** verifies: Commands correct, outputs genuine, rollbacks viable
4. **Agent #3** verifies: Grade improved, A+++ trajectory maintained

### 📝 MEMORY FORMAT (MANDATORY)

For each TODO, create: `/home/qui3tly/personal/memories/TODO_PX_YY_YYYY-MM-DD.md`

```markdown
# Memory: TODO-PX-YY [Task Name]
**Date:** YYYY-MM-DD HH:MM:SS UTC
**Status:** COMPLETE / PARTIAL / ROLLBACK
**User Approval:** Y (timestamp)

## What Was Done
[1-2 paragraph summary of work]

## Commands Executed
```bash
[Copy-paste all commands with timestamps]
```

## Results Achieved
[What changed, what was fixed, what metrics improved]

## Evidence Files
- Screenshot: /tmp/evidence/TODO_PX_YY_step1.png
- Log output: /tmp/evidence/TODO_PX_YY_output.txt
- Config diff: /tmp/evidence/TODO_PX_YY.diff

## Documentation Updated
- Updated: /home/qui3tly/personal/manuals/[service].md (lines XX-YY)
- Updated: /home/qui3tly/personal/[file].md (section ZZ)

## Verification
- ✅ Success Criterion 1: [Result]
- ✅ Success Criterion 2: [Result]
- ✅ Success Criterion 3: [Result]

## User Confirmation
**User:** "[Quote from user confirming completion]"
**Timestamp:** YYYY-MM-DD HH:MM:SS UTC
```

### 📚 PROJECT DOCS TO UPDATE

After completing TODO items, update these files:

- **Service Manuals:** `/home/qui3tly/personal/manuals/[service].md`
  - Update: Installation steps, configuration changes, access URLs, credentials
  
- **Project README:** `/home/qui3tly/personal/README.md`
  - Update: Current state, completed phases, infrastructure overview
  
- **Notes:** `/home/qui3tly/personal/NOTES.md`
  - Add: Important decisions, lessons learned, gotchas discovered
  
- **How-To Guides:** `/home/qui3tly/personal/howto/`
  - Create: New procedures discovered during execution
  
- **Audit Reports:** `/home/qui3tly/personal/audits/`
  - Update: Status of issues found in audits (mark resolved)

### 🎯 EXECUTION TRACKER UPDATES

After each TODO:
- Update: `/home/qui3tly/projects/preproduction/handover/EXECUTION_TRACKER_2026-02-10.md`
- Change status: ⬜ → 🔄 (when approved) → ✅ (when verified) → ❌ (if failed)
- Add timestamp and user confirmation

---

## EXECUTIVE SUMMARY
- Core blockers surfaced in the 2026-02-10 log bundle: Nextcloud not installed, mail stack redis disconnects, Pihole DB I/O errors, Grafana plugin duplication, probe 403/404 for public endpoints, dovecot TLS handshakes failing, blackbox/ntfy host checks, missing promtail diskstats perms.
- This document turns those errors into execution-ready TODOs with commands, expected results, and rollback. Prioritize P0 first.
- **CRITICAL:** Every TODO requires user Y/N approval, complete documentation, memory creation, project docs updates, and triple agent verification.

## P0 — CRITICAL SERVICE FIXES

### TODO-P0-01: Finish Nextcloud install (cron spamming "Not installed")
**Evidence:** Multiple exceptions in /tmp/preproduction_logs_20260210_014012/lady_nextcloud.log (lines 1-120). Cron entry fails because instance not installed.
**Steps:**
1) SSH lady (port per governance) and inspect config: `docker exec nextcloud ls /config/www/nextcloud/config/config.php` (expected: minimal config, no DB settings).
2) Prepare DB: `docker exec nextcloud-db mariadb -u root -e "CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci; CREATE USER IF NOT EXISTS 'nextcloud'@'%' IDENTIFIED BY 'CHANGE_ME'; GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'%'; FLUSH PRIVILEGES;"`
3) Run web installer via VPN: https://cloud.quietly.online → set DB host nextcloud-db, DB user/pass above, data dir /data.
4) After install: `docker exec nextcloud php /config/www/nextcloud/occ status` (expect installed: true) and `docker exec nextcloud php /config/www/nextcloud/occ db:add-missing-indices`.
**Success Criteria:** occ status shows installed; no further "Not installed" entries in cron log; login page loads via VPN (HTTP 200/303).
**Rollback:** Drop DB/user if install fails: `docker exec nextcloud-db mariadb -u root -e "DROP DATABASE IF EXISTS nextcloud; DROP USER IF EXISTS 'nextcloud'@'%';"`; restore config.php from backup.

**⚠️ USER APPROVAL REQUIRED:**
- [ ] **ASK USER:** "Execute TODO-P0-01 (Nextcloud install)? Y/N" → WAIT FOR Y
- [ ] **DOCUMENT:** All commands + outputs to `/tmp/execution_log_P0-01.txt`
- [ ] **SCREENSHOT:** Web installer steps, final occ status output
- [ ] **CREATE MEMORY:** `/home/qui3tly/personal/memories/TODO_P0_01_2026-02-10.md`
- [ ] **UPDATE DOCS:** `/home/qui3tly/personal/manuals/nextcloud.md` (installation complete, access URL, admin credentials)
- [ ] **VERIFY:** All success criteria with user → "TODO-P0-01 complete? Y/N"
- [ ] **TRIPLE AGENT:** Evidence ready for Agent #1 (completeness), Agent #2 (quality), Agent #3 (certification)

### TODO-P0-02: Create Nextcloud cron guard to stop error spam
**Evidence:** Same log as TODO-P0-01; cron runs while app uninstalled.
**Steps:**
1) Temporarily disable cron entry: `docker exec nextcloud bash -c "mv /etc/cron.d/nextcloud /etc/cron.d/nextcloud.disabled"` until install completes.
2) After successful install, re-enable cron: `mv /etc/cron.d/nextcloud.disabled /etc/cron.d/nextcloud` and `docker exec nextcloud crontab -l` to confirm.
**Success Criteria:** No new "Not installed" lines for 10 minutes; cron tasks logged as completed.
**Rollback:** Restore cron file path if needed.

**⚠️ USER APPROVAL REQUIRED:**
- [ ] **ASK USER:** "Execute TODO-P0-02 (Nextcloud cron guard)? Y/N" → WAIT FOR Y
- [ ] **DOCUMENT:** All commands + outputs to `/tmp/execution_log_P0-02.txt`
- [ ] **CREATE MEMORY:** `/home/qui3tly/personal/memories/TODO_P0_02_2026-02-10.md`
- [ ] **UPDATE DOCS:** `/home/qui3tly/personal/manuals/nextcloud.md` (cron configuration section)
- [ ] **VERIFY:** No errors in logs → "TODO-P0-02 complete? Y/N"
- [ ] **TRIPLE AGENT:** Evidence packaged for verification

### TODO-P0-03: Fix mail stack redis connectivity (172.28.1.249 errors)
**Evidence:** redis.exceptions.ConnectionError in /tmp/preproduction_logs_20260210_014012/ALL_ERRORS_SUMMARY.txt (host unreachable / closed); likely mailcow redis.
**Steps:**
1) `ssh lady "docker ps --format '{{.Names}}' | grep redis"` (expect mailcowdockerized-redis-mailcow-1).
2) Check health: `docker inspect mailcowdockerized-redis-mailcow-1 --format '{{.State.Health.Status}}'` and `docker logs mailcowdockerized-redis-mailcow-1 --tail 50`.
3) From affected service (rspamd/sogo/ofelia), test ping: `docker exec mailcowdockerized-rspamd-mailcow-1 redis-cli -h redis -a "$(cat /mailcow/data/conf/redis.env | cut -d= -f2)" ping`.
4) If container restart pending: `docker compose -f /opt/mailcow-dockerized/docker-compose.yml restart redis-mailcow`.
5) Verify bouncers: `docker exec mailcowdockerized-olefy-mailcow-1 redis-cli -h redis ping`.
**Success Criteria:** Redis health=healthy; no new redis ConnectionError lines in mailcow logs for 30 minutes; SOGo UI loads.
**Rollback:** `docker compose -f /opt/mailcow-dockerized/docker-compose.yml restart redis-mailcow` and restore redis.env from backup.

**⚠️ USER APPROVAL REQUIRED:**
- [ ] **ASK USER:** "Execute TODO-P0-03 (Mailcow redis fix)? Y/N" → WAIT FOR Y
- [ ] **DOCUMENT:** All commands + outputs to `/tmp/execution_log_P0-03.txt`
- [ ] **SCREENSHOT:** Redis health status, SOGo UI loading
- [ ] **CREATE MEMORY:** `/home/qui3tly/personal/memories/TODO_P0_03_2026-02-10.md`
- [ ] **UPDATE DOCS:** `/home/qui3tly/personal/manuals/mailcow.md` (redis configuration, troubleshooting)
- [ ] **VERIFY:** 30-minute log clean → "TODO-P0-03 complete? Y/N"
- [ ] **TRIPLE AGENT:** Evidence packaged for verification

### TODO-P0-04: Resolve dovecot TLS handshakes failing
**Evidence:** TLS errors (unsupported protocol/no shared cipher/bad key share) in /tmp/preproduction_logs_20260210_014012/ALL_ERRORS_SUMMARY.txt (dovecot imap-login, Feb 10 00:23 entries).
**Steps:**
1) `docker logs mailcowdockerized-dovecot-mailcow-1 --tail 100 | grep -i "SSL_accept"` to quantify.
2) Check TLS settings: `docker exec mailcowdockerized-dovecot-mailcow-1 cat /etc/dovecot/conf.d/10-ssl.conf | grep -E 'ssl_min_protocol|ssl_cipher_list'`.
3) Align to TLSv1.2+: set `ssl_min_protocol = TLSv1.2`, ensure modern ciphers; reload: `docker exec mailcowdockerized-dovecot-mailcow-1 dovecot reload`.
4) Re-test from client via openssl: `openssl s_client -connect 100.64.0.1:993 -servername mail.quietly.online -tls1_2 -brief` via VPN.
**Success Criteria:** No new SSL_accept failures for 10 minutes; IMAP login works with TLS1.2+.
**Rollback:** Revert 10-ssl.conf from backup and reload dovecot.

**⚠️ USER APPROVAL REQUIRED:**
- [ ] **ASK USER:** "Execute TODO-P0-04 (Dovecot TLS fix)? Y/N" → WAIT FOR Y
- [ ] **DOCUMENT:** All commands + outputs to `/tmp/execution_log_P0-04.txt`
- [ ] **SCREENSHOT:** TLS test output, config changes
- [ ] **CREATE MEMORY:** `/home/qui3tly/personal/memories/TODO_P0_04_2026-02-10.md`
- [ ] **UPDATE DOCS:** `/home/qui3tly/personal/manuals/dovecot.md` (TLS configuration, security settings)
- [ ] **VERIFY:** 10-minute log clean → "TODO-P0-04 complete? Y/N"
- [ ] **TRIPLE AGENT:** Evidence packaged for verification

### TODO-P0-05: Repair Pihole DB I/O errors
**Evidence:** SQLite CANTOPEN and WAL recovery messages in /tmp/preproduction_logs_20260210_014012/master_pihole.log (lines 1-40), plus NTP socket errors.
**Steps:**
1) Confirm volume path permissions: `docker inspect pihole --format '{{range .Mounts}}{{.Destination}} -> {{.Source}}{{end}}'` and `ls -ld /etc/pihole /etc/pihole/pihole-FTL.db*` inside container.
2) Stop container: `docker stop pihole` then run `docker run --rm -v pihole_etc:/etc/pihole alpine ls -l /etc/pihole | head` to verify perms (expect pihole:pihole 1000).
3) If perms wrong: `docker run --rm -v pihole_etc:/etc/pihole alpine chown -R 1000:1000 /etc/pihole`.
4) Start pihole: `docker start pihole`; check logs for absence of CANTOPEN.
5) For NTP IPv6 socket errors, set `NTP_IPv6=no` in pihole-FTL.conf or disable NTP server if unused.
**Success Criteria:** No new SQLite CANTOPEN lines after restart; gravity updates run clean; DNS replies continue.
**Rollback:** Restore volume from backup snapshot if corruption persists.

**⚠️ USER APPROVAL REQUIRED:**
- [ ] **ASK USER:** "Execute TODO-P0-05 (Pihole DB repair)? Y/N" → WAIT FOR Y
- [ ] **DOCUMENT:** All commands + outputs to `/tmp/execution_log_P0-05.txt`
- [ ] **SCREENSHOT:** Permission check, DB status after fix
- [ ] **CREATE MEMORY:** `/home/qui3tly/personal/memories/TODO_P0_05_2026-02-10.md`
- [ ] **UPDATE DOCS:** `/home/qui3tly/personal/manuals/pihole.md` (database maintenance, permissions troubleshooting)
- [ ] **VERIFY:** Gravity update success → "TODO-P0-05 complete? Y/N"
- [ ] **TRIPLE AGENT:** Evidence packaged for verification

### TODO-P0-06: Grafana plugin duplication errors (xychart)
**Evidence:** `plugin xychart is already registered` in /tmp/preproduction_logs_20260210_014012/ALL_ERRORS_SUMMARY.txt (2 occurrences around 17:57:20Z in master_grafana.log).
**Steps:**
1) `docker exec grafana grafana-cli plugins ls | grep xychart` to see duplicates.
2) Remove duplicates: `docker exec grafana grafana-cli plugins remove grafana-xychart-panel` then reinstall once: `docker exec grafana grafana-cli plugins install grafana-xychart-panel`.
3) Restart: `docker restart grafana`.
4) Verify logs: `docker logs grafana --tail 100 | grep -i plugin` (expect no duplicate registration errors).
**Success Criteria:** Grafana starts without plugin errors; dashboards load.
**Rollback:** Restore plugins directory from backup `/var/lib/grafana/plugins.bak` if present.

**⚠️ USER APPROVAL REQUIRED:**
- [ ] **ASK USER:** "Execute TODO-P0-06 (Grafana plugin fix)? Y/N" → WAIT FOR Y
- [ ] **DOCUMENT:** All commands + outputs to `/tmp/execution_log_P0-06.txt`
- [ ] **SCREENSHOT:** Plugin list before/after, Grafana dashboard loading
- [ ] **CREATE MEMORY:** `/home/qui3tly/personal/memories/TODO_P0_06_2026-02-10.md`
- [ ] **UPDATE DOCS:** `/home/qui3tly/personal/manuals/grafana.md` (plugin management, troubleshooting)
- [ ] **VERIFY:** Dashboards load cleanly → "TODO-P0-06 complete? Y/N"
- [ ] **TRIPLE AGENT:** Evidence packaged for verification

### TODO-P0-07: Promtail diskstats permission errors
**Evidence:** `Failed to open directory /run/udev/data` in ALL_ERRORS_SUMMARY (diskstats_linux.go).
**Steps:**
1) `docker exec promtail ls -ld /run/udev/data` (likely missing bind mount/capabilities).
2) If missing mount, add read-only udev bind in compose: `- /run/udev:/run/udev:ro` and set `--privileged=false` with `--cap-add SYS_PTRACE` as needed.
3) Redeploy promtail stack and check logs: `docker logs promtail --tail 50`.
**Success Criteria:** No diskstats errors; promtail still scraping docker logs.
**Rollback:** Revert compose changes and redeploy.

**⚠️ USER APPROVAL REQUIRED:**
- [ ] **ASK USER:** "Execute TODO-P0-07 (Promtail permissions fix)? Y/N" → WAIT FOR Y
- [ ] **DOCUMENT:** All commands + outputs to `/tmp/execution_log_P0-07.txt`
- [ ] **SCREENSHOT:** Compose changes, promtail logs clean
- [ ] **CREATE MEMORY:** `/home/qui3tly/personal/memories/TODO_P0_07_2026-02-10.md`
- [ ] **UPDATE DOCS:** `/home/qui3tly/personal/manuals/promtail.md` (mount requirements, configuration)
- [ ] **VERIFY:** No diskstats errors → "TODO-P0-07 complete? Y/N"
- [ ] **TRIPLE AGENT:** Evidence packaged for verification

## P1 — ACCESS, ROUTING, AND ENDPOINT HEALTH

### TODO-P1-01: Fix public probes returning 403/404 (blackbox)
**Evidence:** blackbox http_ssl probe failures for quietly.online, quietly.its.me, mail.quietly.online, nextcloud.quietly.online in ALL_ERRORS_SUMMARY (2026-02-08 entries). Curl checks in terminal show 200 for ntfy and 200 for pihole admin.
**Steps:**
1) For each hostname, run via VPN: `curl -skI --resolve <host>:443:100.64.0.1 https://<host>`; record status.
2) Check Traefik routes on master/lady: `docker exec traefik cat /etc/traefik/dynamic/*.yml | grep -A5 '<host>'`.
3) Validate ACME certs: `docker exec traefik traefik certificatesresolvers acme` (or inspect acme.json) and ensure SAN includes hosts.
4) Align middlewares (auth/redirect) to allow probe path `/.well-known/health` or `/`.
**Success Criteria:** blackbox probe returns 200/301; http_ssl exporter stops logging 403/404 for these hosts for 12h.
**Rollback:** Revert offending middleware/router edits.

### TODO-P1-02: OnlyOffice nginx errors & license warnings
**Evidence:** Entries in /tmp/preproduction_logs_20260210_014012/lady_onlyoffice-documentserver.log (nginx.error.log markers, repeated warn notifyLicenseExpiration undefined).
**Steps:**
1) Check nginx error log tail: `docker exec onlyoffice-documentserver tail -50 /var/log/onlyoffice/documentserver/nginx.error.log`.
2) Ensure JWT secret set: `docker exec onlyoffice-documentserver bash -c 'echo $JWT_SECRET'` or config file `/etc/onlyoffice/documentserver/default.json`.
3) If missing, set `JWT_ENABLED=true` and `JWT_SECRET` via env/secret, recreate container.
4) Validate docservice: `curl -sk https://office.quietly.online/welcome/` via VPN.
**Success Criteria:** No nginx errors on restart; docs open from Nextcloud integration (once Nextcloud installed).
**Rollback:** Restore previous default.json; redeploy container.

### TODO-P1-03: Mailcow TLS policy check
**Evidence:** Postfix postscreen PREGREET events in /tmp/preproduction_logs_20260210_014012/lady_mailcowdockerized-postfix-mailcow-1.log (within lady_containers_ALL.log snippet); may be normal but monitor.
**Steps:**
1) Tail postfix log: `docker logs mailcowdockerized-postfix-mailcow-1 --tail 200 | grep -i PREGREET` to confirm volume.
2) Ensure postscreen parameters align (default ok). If rate high, adjust `postscreen_greet_action = enforce` and update dnsbls if needed.
3) Run smtp test: `openssl s_client -connect mail.quietly.online:25 -starttls smtp -crlf -tls1_2`.
**Success Criteria:** PREGREET entries stay informational; no customer impact.
**Rollback:** Revert main.cf/postsceen.conf.

### TODO-P1-04: Restore blackbox target quietly.online (404)
**Evidence:** blackbox errors for quietly.online (404) in ALL_ERRORS_SUMMARY.
**Steps:**
1) Check DNS for quietly.online to ensure pointing to tunnel/traefik.
2) Ensure default landing page container responds for host. If missing router, add traefik router to default-landing service for quietly.online with middleware to 301 to main site.
3) Verify: `curl -skI --resolve quietly.online:443:100.64.0.1 https://quietly.online` (expect 200/301).
**Success Criteria:** blackbox stops reporting 404; landing accessible.
**Rollback:** Remove router if misrouted.

### TODO-P1-05: Headscale/Grafana availability check post-restart
**Evidence:** Terminal history shows attempted `docker restart grafana` (exit 1 then success). Ensure persistence.
**Steps:**
1) `docker ps --filter name=grafana` (expect Up, healthy).
2) Open `https://grafana.quietly.its.me` via VPN; login.
3) Validate datasources: `docker exec grafana curl -s http://localhost:3000/api/datasources` (expect Prometheus/Loki reachable).
**Success Criteria:** Grafana dashboards load; no further restarts needed.
**Rollback:** revert plugin changes or restore provisioning from git backup.

## P1 — MONITORING AGENTS

### TODO-P1-06: Verify promtail scrape coverage after log bundle
**Evidence:** promtail errors (diskstats) and overall 940 errors tallied; ensure scrape not blocked.
**Steps:**
1) `docker exec promtail /usr/bin/promtail --config.file=/etc/promtail/config.yml --verify-config`.
2) Check positions file timestamps: `docker exec promtail ls -l /tmp/positions.yaml`.
3) Confirm targets in Loki: query `{job="docker"}` last 5m in Grafana Explore.
**Success Criteria:** Promtail healthy; new logs reaching Loki.
**Rollback:** Reapply known-good promtail config; restart.

## P1 — GOVERNANCE & SECRETS (continued)

### TODO-P1-07: Move secrets from docker-compose directories to ~/.secrets/
**Evidence:** TODO-006 in COMPREHENSIVE_TODO_LIST identifies 4 .env files in compose dirs (governance violation).
**Steps:**
1) Master crowdsec: `cp ~/.docker-compose/crowdsec/.env ~/.docker-compose/crowdsec/.env.bak && mkdir -p ~/.secrets/crowdsec && mv ~/.docker-compose/crowdsec/.env ~/.secrets/crowdsec/.env && chmod 600 ~/.secrets/crowdsec/.env`
2) Update compose env_file reference: `sed -i 's|env_file: .env|env_file: /home/qui3tly/.secrets/crowdsec/.env|' ~/.docker-compose/crowdsec/docker-compose.yaml`
3) Test: `docker compose -f ~/.docker-compose/crowdsec/docker-compose.yaml config` then restart.
4) Repeat for Lady: crowdsec, nextcloud, odoo .env files.
5) Verify git clean: `git status | grep .env` (expect nothing).
**Success Criteria:** All 4 .env files in ~/.secrets/; perms 600; services healthy; no .env in git.
**Rollback:** Restore .env.bak to original location; revert compose file.

### TODO-P1-08: Pin :latest image tags to specific versions
**Evidence:** governance audit shows 4 containers with :latest tag (blackbox, uptime-kuma, ntfy, mysqld-exporter).
**Steps:**
1) `docker inspect blackbox --format '{{.Config.Image}}'` to confirm current tag.
2) Identify running version: `docker exec blackbox /bin/blackbox_exporter --version 2>&1 | head -1` (example for blackbox).
3) Pin in compose: `sed -i 's|prom/blackbox-exporter:latest|prom/blackbox-exporter:v0.25.0|' ~/.docker-compose/blackbox/docker-compose.yaml`
4) Redeploy: `cd ~/.docker-compose/blackbox && docker compose pull && docker compose up -d --force-recreate`
5) Verify: `docker inspect blackbox --format '{{.Config.Image}}'` shows versioned tag.
6) Repeat for uptime-kuma (v1.23.13), ntfy (v2.16.0 from earlier logs), mysqld-exporter (v0.15.1).
**Success Criteria:** No :latest in `docker ps --format '{{.Image}}'`; services functional.
**Rollback:** Revert compose to backup; redeploy.

### TODO-P1-09: Add healthchecks to critical containers without them
**Evidence:** governance audit shows 37 containers lack healthchecks; prioritize traefik, admin-panel, nextcloud, odoo.
**Steps:**
1) For traefik: add to compose under service:
```yaml
healthcheck:
  test: ["CMD", "traefik", "healthcheck", "--ping"]
  interval: 30s
  timeout: 3s
  retries: 3
  start_period: 10s
```
2) Verify ping endpoint enabled in traefik.yaml: `grep ping ~/.docker-compose/traefik/traefik.yaml` (expect `ping: {}`).
3) Recreate container: `cd ~/.docker-compose/traefik && docker compose up -d` and wait 30s.
4) Check status: `docker ps --filter name=traefik` (expect "healthy" in status).
5) Repeat pattern for: admin-panel (curl localhost:8080/health), nextcloud (curl localhost/status.php), odoo (curl localhost:8069/web/health on lady).
**Success Criteria:** `docker ps` shows "(healthy)" for all 4; test by killing process → auto-restart.
**Rollback:** Remove healthcheck section from compose; redeploy.

### TODO-P1-10: Deploy cron jobs to Lady (currently zero)
**Evidence:** Master has 3 cron jobs (daily/weekly/monthly reports); Lady has none per governance audit.
**Steps:**
1) `rsync -av ~/.copilot/cron/ lady:~/.copilot/cron/` to copy scripts.
2) SSH lady and make executable: `ssh lady "chmod +x ~/.copilot/cron/*.sh"`
3) Test one: `ssh lady "~/.copilot/cron/daily_report.sh --dry-run"`
4) Install crontab: `ssh lady "cat > /tmp/cron.txt << 'EOF'
0 6 * * * /home/qui3tly/.copilot/cron/daily_report.sh
0 2 * * 0 /home/qui3tly/.copilot/cron/weekly_security.sh
0 3 1 * * /home/qui3tly/.copilot/cron/monthly_report.sh
EOF
crontab /tmp/cron.txt"`
5) Verify: `ssh lady "crontab -l"`
**Success Criteria:** 3 cron jobs listed on lady; test run succeeds; cron service enabled.
**Rollback:** `ssh lady "crontab -r"` to remove.

### TODO-P1-11: Add fail2ban jails to Lady (traefik-auth, recidive)
**Evidence:** Master has 3 jails; Lady has 1 (sshd only).
**Steps:**
1) Copy configs from master: `scp /etc/fail2ban/jail.d/traefik-auth.local lady:/tmp/ && scp /etc/fail2ban/filter.d/traefik-auth.conf lady:/tmp/`
2) Install on lady: `ssh lady "sudo mv /tmp/traefik-auth.* /etc/fail2ban/jail.d/ && sudo chown root:root /etc/fail2ban/jail.d/traefik-auth.local"`
3) Enable recidive: `ssh lady "echo '[recidive]
enabled = true
bantime = 1w
findtime = 1d
maxretry = 3' | sudo tee /etc/fail2ban/jail.d/recidive.local"`
4) Test config: `ssh lady "sudo fail2ban-client -t"`
5) Reload: `ssh lady "sudo fail2ban-client reload"`
6) Check: `ssh lady "sudo fail2ban-client status"` (expect 3 jails: sshd, traefik-auth, recidive).
**Success Criteria:** 3 active jails; test ban simulation works.
**Rollback:** Remove jail files; reload fail2ban.

### TODO-P1-12: Update .gitignore to prevent secret tracking
**Evidence:** After moving secrets, ensure git can't accidentally track them.
**Steps:**
1) Append patterns to ~/.gitignore:
```bash
cat >> ~/.gitignore << 'EOF'
.env
.env.*
*.env
**/.env
.secrets/
**/secrets/
*.key
*.pem
!.env.example
EOF
```
2) Verify no secrets tracked: `git ls-files | grep -E '\.env$|secret|\.key'` (expect empty).
3) If any found: `git rm --cached <file>` and commit removal.
4) Copy same .gitignore to lady: `scp ~/.gitignore lady:~/`
5) Commit: `git add .gitignore && git commit -m "Prevent secret tracking" && git push`
**Success Criteria:** git status clean; future .env auto-ignored.
**Rollback:** Restore previous .gitignore from git history.

## P2 — SERVICE HEALTH & ROUTING

### TODO-P2-01: Verify all Master containers running
**Evidence:** Prometheus was down; need sweep of all 25 master containers.
**Steps:**
1) `docker ps -a --format '{{.Names}}\t{{.Status}}' | grep -v "Up"` to find stopped.
2) For each stopped: `docker logs <name> --tail 50` to diagnose; restart if safe: `docker restart <name>`.
3) Check critical services individually: prometheus, grafana, loki, traefik, alertmanager, blackbox.
4) Verify metrics flowing: `curl -s http://localhost:9090/api/v1/query?query=up | jq '.data.result | length'` (expect >10 targets).
**Success Criteria:** All 25 containers Up; Prometheus targets >80% healthy; Grafana loading data.
**Rollback:** Leave stopped containers down; document reason.

### TODO-P2-02: Verify all Lady containers running (36 expected)
**Evidence:** Terminal shows 36 containers; mailcow redis had connectivity issues.
**Steps:**
1) `ssh lady "docker ps -a --format '{{.Names}}\t{{.Status}}' | grep -v 'Up'"` to find stopped.
2) Restart mailcow stack if any mailcow containers down: `ssh lady "cd /opt/mailcow-dockerized && docker compose restart"`
3) Check nextcloud stack: nextcloud, nextcloud-db, nextcloud-redis.
4) Check odoo stack: odoo, odoo-db.
5) Check other services: homeassistant, frigate, onlyoffice, unifi-db.
**Success Criteria:** All 36 Up; no restart loops; mailcow UI accessible via VPN.
**Rollback:** Document failing containers for investigation.

### TODO-P2-03: Fix Traefik routing for broken 404/403 services
**Evidence:** blackbox logs show 404 for quietly.online, 403 for mail.quietly.online, nextcloud.quietly.online.
**Steps:**
1) For quietly.online (404): check if router exists: `docker exec traefik cat /etc/traefik/dynamic/*.yml | grep -A5 'quietly.online'`
2) If missing, create router pointing to default-landing or redirect to main site.
3) For 403 errors: check middleware chain: `docker exec traefik cat /etc/traefik/dynamic/*.yml | grep -B5 -A10 'mail.quietly.online'`
4) Likely auth middleware blocking probe; add bypass for `/.well-known/` or health endpoints.
5) Reload traefik: not needed if using file provider with auto-watch.
6) Test each: `curl -skI --resolve <host>:443:100.64.0.1 https://<host>` (expect 200/301, not 403/404).
**Success Criteria:** blackbox probes return 200/301 for 12h; no 403/404 in prometheus alerts.
**Rollback:** Revert dynamic config files from git backup.

### TODO-P2-04: Document all service URLs and access methods
**Evidence:** Multiple services; no central access documentation.
**Steps:**
1) Create `/home/qui3tly/personal/SERVICE_ACCESS_GUIDE.md`:
```markdown
# Service Access Guide

## Via VPN (Tailscale 100.64.x.x)
| Service | URL | Auth | Notes |
|---------|-----|------|-------|
| Grafana | https://grafana.quietly.its.me | Authelia | Metrics/dashboards |
| Prometheus | http://prometheus.quietly.its.me:9090 | None (VPN only) | Direct metrics |
| Admin Panel | https://admin.quietly.its.me | Authelia | Service control |
| Nextcloud | https://cloud.quietly.online | Native | File storage |
| Odoo | https://odoo.quietly.online | Native | ERP |
| Mailcow | https://mail.quietly.online | Native | Mail admin |
...
```
2) Test each URL via VPN and record actual status (200/redirect/auth-required).
3) Add authentication details (where to find credentials in ~/.secrets/).
4) Document port-forward methods for services without web UI.
5) Commit to git: `git add personal/SERVICE_ACCESS_GUIDE.md && git commit -m "Central service access documentation"`
**Success Criteria:** All services listed; URLs verified working; auth methods documented.
**Rollback:** N/A (documentation only).

### TODO-P2-05: Test VPN connectivity to all services from external client
**Evidence:** Need end-to-end validation after fixes.
**Steps:**
1) From external machine connected to Tailscale: `tailscale status | grep -E 'master|lady'`
2) Test DNS resolution: `nslookup grafana.quietly.its.me` (expect 100.64.x.x).
3) Test each critical service via curl with `--resolve`: see TODO-P1-01 pattern.
4) Test browser access: open Grafana, admin panel, verify login flow.
5) Test SSH: `ssh master "hostname"` and `ssh lady "hostname"` (expect no password prompt if keys set up).
6) Document any failures with network trace: `curl -v` or `traceroute`.
**Success Criteria:** All services reachable via VPN; <200ms latency; no connection refused.
**Rollback:** N/A (testing only).

## P2 — DOCUMENTATION UPDATES

### TODO-P2-06: Update all service manuals with current state
**Evidence:** After multiple changes, manuals outdated.
**Steps:**
1) For each manual in `/home/qui3tly/personal/manuals/*.md`:
   - Verify container name matches actual: `docker ps --format '{{.Names}}' | grep <service>`
   - Update image version to pinned version (from TODO-P1-08)
   - Add healthcheck details (from TODO-P1-09)
   - Update secret file paths (from TODO-P1-07)
   - Record any incidents (Prometheus downtime, nextcloud not installed, etc.)
2) Priority services: prometheus.md, grafana.md, traefik.md, nextcloud.md, odoo.md, mailcow.md.
3) For each updated file: `git add personal/manuals/<service>.md && git commit -m "Update <service> manual after fixes"`
**Success Criteria:** All manuals reflect current state; no references to :latest or old paths.
**Rollback:** Restore from git history.

### TODO-P2-07: Create incident log for Prometheus outage
**Evidence:** Prometheus was down 4+ hours; needs formal record.
**Steps:**
1) Create `~/projects/preproduction/incidents/2026-02-09-prometheus-exit255.md`:
```markdown
# Incident Report: Prometheus Exit 255

**Date:** 2026-02-09
**Duration:** ~4 hours (13:00-17:00 UTC estimate)
**Severity:** Critical (all monitoring blind)

## Timeline
- 13:00: Prometheus container exited with code 255
- 17:00: Discovered during agent audit
- 17:10: Restarted successfully
- 17:15: Data collection resumed

## Root Cause
[Fill from TODO-P0-03 investigation results]

## Impact
- Grafana dashboards empty
- Alertmanager no alerts sent
- Historical data gap 4h
- No visibility into infrastructure

## Resolution
- Container restarted
- Healthcheck added to prevent silent failures
- Restart policy verified

## Prevention
- Healthcheck monitors process health
- Alerting on container state changes
- Daily health check cron job
```
2) Link from prometheus.md: add "## Recent Incidents" section.
**Success Criteria:** Incident documented; linked from manual.
**Rollback:** N/A (documentation).

## P2 — SECURITY HARDENING

### TODO-P2-08: Audit SSH key access across both servers
**Evidence:** Multiple services; ensure only authorized keys.
**Steps:**
1) Master: `cat ~/.ssh/authorized_keys | wc -l` and review each key.
2) Lady: `ssh lady "cat ~/.ssh/authorized_keys | wc -l"` and compare.
3) Check for root ssh keys: `sudo cat /root/.ssh/authorized_keys` (should be empty or very restricted).
4) Remove any unknown keys; document known keys in governance.
5) Verify SSH config restricts root login: `grep PermitRootLogin /etc/ssh/sshd_config` (expect "no").
6) Set key-only auth: `grep PasswordAuthentication /etc/ssh/sshd_config` (expect "no").
**Success Criteria:** Only known keys present; root can't login; password auth disabled.
**Rollback:** Keep backup of authorized_keys before changes.

### TODO-P2-09: Verify firewall rules on both servers
**Evidence:** Need validation of ufw/iptables rules.
**Steps:**
1) Master: `sudo ufw status numbered` and verify rules match governance (SSH 1006, Tailscale, docker, deny all else).
2) Lady: `ssh lady "sudo ufw status numbered"` and verify.
3) Check for any overly permissive rules (0.0.0.0/0 on sensitive ports).
4) Verify docker bypass: `sudo iptables -L DOCKER` (docker manages its own NAT rules).
5) Test from external IP: should not reach any services except Cloudflare tunnel.
**Success Criteria:** Only intended ports open; VPN required for services.
**Rollback:** `sudo ufw disable` in emergency; restore rules from /lib/ufw/user.rules backup.

### TODO-P2-10: Review and rotate API keys older than 90 days
**Evidence:** Several services have API keys (gotify, ntfy, crowdsec bouncer).
**Steps:**
1) List all keys in ~/.secrets/: `find ~/.secrets/ -type f -exec ls -l {} \;`
2) Check modification dates: keys >90d need rotation per best practice.
3) For each old key, generate new and update:
   - CrowdSec bouncer: `docker exec crowdsec cscli bouncers add <new-name>` and update .env
   - Gotify: regenerate in web UI → update applications using it
   - Ntfy: rotate access tokens if using auth
4) Test services after rotation to ensure connectivity.
5) Document rotation date: `echo "Rotated $(date)" > ~/.secrets/<service>/last-rotation.txt`
**Success Criteria:** All critical API keys <90d old; services functional after rotation.
**Rollback:** Restore old key from ~/.secrets backup; restart services.

## P3 — MONITORING & PHASE COMPLETION

### TODO-P3-01: Configure Prometheus retention and storage
**Evidence:** After 4h outage, verify retention settings adequate.
**Steps:**
1) Check current retention: `docker exec prometheus /bin/prometheus --version` and inspect args: `docker inspect prometheus | jq '.[0].Args'`
2) Verify retention flags: `--storage.tsdb.retention.time=15d` (default) and `--storage.tsdb.retention.size=` if set.
3) Check disk usage: `du -sh ~/.docker/prometheus/data/`
4) Adjust if needed in compose args: `- '--storage.tsdb.retention.time=30d'` for longer retention.
5) Restart to apply: `cd ~/.docker-compose/prometheus && docker compose up -d`
**Success Criteria:** Retention ≥15d; disk usage <80%; oldest data matches retention.
**Rollback:** Revert compose args; restart.

### TODO-P3-02: Validate Loki log retention and cleanup
**Evidence:** 8500+ log lines collected; ensure Loki not filling disk.
**Steps:**
1) Check Loki config: `docker exec loki cat /etc/loki/local-config.yaml | grep -A5 retention`
2) Verify retention period (expect 15-30d).
3) Check storage: `du -sh ~/.docker/loki/data/`
4) Run compaction if available: `docker exec loki /usr/bin/loki -target=compactor -config.file=/etc/loki/local-config.yaml` (if compactor enabled).
5) Monitor disk growth: `df -h | grep /home`
**Success Criteria:** Retention set; old chunks deleted automatically; disk <70%.
**Rollback:** Increase retention if set too low; redeploy.

### TODO-P3-03: Set up Alertmanager notification routing
**Evidence:** After Prometheus restart, verify alerts flowing.
**Steps:**
1) Check Alertmanager config: `docker exec alertmanager cat /etc/alertmanager/alertmanager.yml`
2) Verify receivers configured: Gotify, ntfy, or email.
3) Test alert: `curl -H "Content-Type: application/json" -d '[{"labels":{"alertname":"TestAlert","severity":"warning"}}]' http://localhost:9093/api/v1/alerts`
4) Check notification received in Gotify/ntfy.
5) Configure alert rules in Prometheus: ensure /etc/prometheus/rules/*.yml loaded.
**Success Criteria:** Test alert received; real alerts (container down, high CPU) trigger notifications.
**Rollback:** Silence alerts if too noisy; tune rules.

### TODO-P3-04: Complete Phase 07 - Governance Framework (per A+++ rubric)
**Evidence:** AGENT_5_INSTRUCTIONS shows 8 phases; Phase 07 governance completion pending.
**Steps:**
1) Review `.github/governance/README.md` and ensure all 7 rules documented and enforced.
2) Verify enforcement log up-to-date: `cat ~/.github/governance/ENFORCEMENT_VIOLATIONS_LOG.md`
3) Create compliance checklist: `cp .github/governance/COMPLIANCE_CHECKLIST.template.md .github/governance/COMPLIANCE_CHECKLIST-2026-02-10.md`
4) Run through checklist, mark each item pass/fail/n-a.
5) Remediate any remaining violations.
6) Get external verification: Agent #6 reviews governance docs.
7) Mark Phase 07 complete in project tracker.
**Success Criteria:** All 7 governance rules compliant; violations log complete; checklist 100%.
**Rollback:** N/A (documentation/compliance only).

### TODO-P3-05: Complete Phase 08 - Final A+++ Certification
**Evidence:** Target grade 98-100/100; currently 55-60/100 per reconciliation.
**Steps:**
1) Calculate current grade using rubric from A_PLUS_PLUS_PLUS_STATUS.md.
2) Identify remaining gaps to 98 points.
3) Execute priority items to close gaps (likely from this TODO list).
4) Run comprehensive test suite: all services accessible, no errors in logs, monitoring functional.
5) Document final state: infrastructure inventory, service catalog, runbooks.
6) Submit for Agent #6 verification.
7) Receive A+++ certification or remediate findings.
**Success Criteria:** Grade ≥98/100; Agent #6 approves; project moved to production-ready.
**Rollback:** N/A (certification process).

## EXECUTION SEQUENCE & DEPENDENCIES

**Week 1 - Critical Fixes (P0 + high P1):**
1. P0-01 through P0-07 (Nextcloud install, redis, TLS, Pihole, Grafana, promtail) - 4h
2. P1-01 through P1-06 (probes, OnlyOffice, mailcow, grafana, promtail scrape) - 3h
3. P1-07 through P1-12 (governance: secrets, versions, healthchecks, cron, fail2ban, gitignore) - 6h
**Total Week 1: 13h**

**Week 2 - Service Health & Docs (P2):**
4. P2-01 through P2-05 (container health, routing fixes, access testing) - 6h
5. P2-06 through P2-07 (documentation updates, incident reports) - 3h
6. P2-08 through P2-10 (security audit: SSH keys, firewall, API keys) - 4h
**Total Week 2: 13h**

**Week 3 - Monitoring & Certification (P3):**
7. P3-01 through P3-03 (Prometheus/Loki retention, Alertmanager routing) - 4h
8. P3-04 Phase 07 governance sign-off - 6h
9. P3-05 Phase 08 final certification - 8h
**Total Week 3: 18h**

**GRAND TOTAL: 44 hours** (conservative estimate; includes testing/verification time)

## A+++ GRADE TRAJECTORY

**Current State (reconciled):** 55-60/100 (D+/C-)

**After P0 Critical Fixes:** +8 points → 63-68/100 (D+/C)
- Nextcloud operational, monitoring restored, critical errors eliminated

**After P1 Governance:** +12 points → 75-80/100 (C+/B-)
- All 7 governance rules compliant, security hardened

**After P2 Service Health:** +10 points → 85-90/100 (B/B+)
- All services functional, routing fixed, documentation complete

**After P3 Monitoring & Certification:** +8-10 points → 93-100/100 (A/A+++)
- Monitoring robust, governance certified, operational excellence

**Success Probability with COMPLETE TODO:** 85-90% (remaining 10-15% risk from unforeseen edge cases or integration issues requiring iteration)

## NOTES & NEXT STEPS
- This completes the primary execution plan with 32 detailed TODO items (P0/P1/P2/P3).
- Original COMPREHENSIVE_TODO had 75 items; many were granular sub-tasks or covered by these broader items.
- After executing P0, rerun log collection to validate fixes: `bash /tmp/mandatory_log_collection.sh`
- Agent #6 will verify this plan before execution begins.
- Each TODO completion should be logged with timestamp, commands run, and verification proof.
