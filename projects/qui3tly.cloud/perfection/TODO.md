# TODO — qui3tly.cloud Perfection Program

**Date:** 2026-04-21
**Owner:** qui3tly
**Status:** ACTIVE — Work top-to-bottom. Do not skip. Do not mark done without evidence file reference.

**Legend:** `[ ]` not started · `[-]` in progress · `[x]` complete — append: ` · <YYYY-MM-DD> · evidence/<filename>`

---

## PHASE 0 — SAFETY NET (blocks everything else)

- [ ] **P0-1** Create Contabo snapshot of Lady — label `perfection-2026-04-21-pre`
- [ ] **P0-2** Create Contabo snapshot of Master — label `perfection-2026-04-21-pre`
- [ ] **P0-3** Record snapshot IDs + UTC timestamps → `evidence/00_snapshot_log.txt`
- [ ] **P0-4** `cd ~ && git add -A && git commit -m "perfection: pre-phase-0 freeze" && git push`
- [ ] **P0-5** Acknowledge freeze: no new containers, FQDNs, or compose changes outside this program until Gate-F

**Gate-0 acceptance:** Both snapshots completed, IDs logged, baseline committed. Sign → `gates/GATE_0_SAFETY_NET.md`.

---

## PHASE 1 — P0 SECURITY REMEDIATION

### 1A · Residual public@file bugs (Master) — Feb-16 carryover

- [ ] **R-SEC-0-1** Backup compose files: `cp ~/.docker-compose/<svc>/docker-compose.yaml ~/.docker-compose/<svc>/docker-compose.yaml.pre-perfection` for pihole, headscale-ui, headscale-admin
- [ ] **R-SEC-0-2** Patch: `sed -i 's/,public@file/,vpn-only@file/g'` on each of the three compose files
- [ ] **R-SEC-0-3** `docker compose up -d` for each (no recreate — labels update in place)
- [ ] **R-SEC-0-4** Verify from NON-VPN: `curl -sI` each FQDN → expect 403 / redirect, NOT admin HTML
- [ ] **R-SEC-0-5** Save outputs → `evidence/master_residual_public_fix_<date>.txt`

### 1B · Lady security patch + reboot (P0-1)

- [ ] **R-SEC-1-1** Pre-patch evidence → `ssh lady "uname -r; apt list --upgradable 2>/dev/null" > evidence/lady_pre_patch_<date>.txt`
- [ ] **R-SEC-1-2** `ssh lady "apt update && apt upgrade -y"`
- [ ] **R-SEC-1-3** `ssh lady "reboot"` (2–3 min downtime)
- [ ] **R-SEC-1-4** Post-reboot: kernel ≥ 6.1.0-44-cloud-amd64, fresh uptime, 38 containers running
- [ ] **R-SEC-1-5** Prom 20/20 targets restored
- [ ] **R-SEC-1-6** 0 new Alertmanager alerts
- [ ] **R-SEC-1-7** Save → `evidence/lady_post_patch_<date>.txt`

### 1C · Lady unscoped listeners + unknown python (P0-3 + P0-4)

- [ ] **R-SEC-2-1** Capture: `ssh lady "ss -tlnp | grep 0.0.0.0" > evidence/lady_listeners_before_<date>.txt`
- [ ] **R-SEC-2-2** Identify each pid on 9618/6769/4691/2529/30715/5000: `ls -la /proc/<pid>/exe; cat /proc/<pid>/cmdline | tr '\0' ' '`
- [ ] **R-SEC-2-3** Decide per listener (kill/bind/keep-with-justification); record
- [ ] **R-SEC-2-4** `systemctl stop condor; systemctl disable condor`
- [ ] **R-SEC-2-5** `apt remove --purge condor pegasus-wms 2>/dev/null` if installed
- [ ] **R-SEC-2-6** python3:5000 — **trace before killing**. If UISP → bind 100.64.0.2:5000 in compose. If unknown → kill + investigate before cleanup
- [ ] **R-SEC-2-7** `ufw deny 9618/tcp; ufw deny 6769/tcp; ufw deny 4691/tcp; ufw deny 2529/tcp; ufw deny 30715/tcp` (keep 6789 if UniFi uses it — document)
- [ ] **R-SEC-2-8** Re-capture → `evidence/lady_listeners_after_<date>.txt` — only 80, 443, 25, 465, 587, 993, 995, 4190, 1006 on 0.0.0.0 (+ 6789 UniFi if kept)
- [ ] **R-SEC-2-9** External probe: `nmap -sT -p 9618,6769,4691,2529,30715,5000 207.180.251.111` → closed/filtered

### 1D · Lady UFW broad RFC 1918 rule fix (P1-4)

- [ ] **R-SEC-3-1** Enumerate Docker bridges → `docker network inspect $(docker network ls -q) | jq -r '.[] | "\(.Name): \(.IPAM.Config[0].Subnet // "none")"' > evidence/lady_docker_subnets_<date>.txt`
- [ ] **R-SEC-3-2** Add specific `ufw allow in from <subnet> comment "<bridge>"` for each
- [ ] **R-SEC-3-3** `ufw delete allow in from 172.16.0.0/12`
- [ ] **R-SEC-3-4** `ufw delete allow in from 10.0.0.0/8`
- [ ] **R-SEC-3-5** Inter-container smoke test: `docker exec traefik wget -q -O- http://crowdsec:8080` or equivalent
- [ ] **R-SEC-3-6** External service smoke: `curl -sk https://quietly.online/` + `https://mail.quietly.online/`
- [ ] **R-SEC-3-7** Save `ufw status verbose` → `evidence/lady_ufw_after_<date>.txt`

### 1E · Master AIDE repair (P1-1)

- [ ] **R-SEC-4-1** Diagnose: `journalctl -u aide.service -n 50 > evidence/master_aide_failure_<date>.txt`
- [ ] **R-SEC-4-2** Sanity: `debsums -c 2>/dev/null | head -20`
- [ ] **R-SEC-4-3** `aideinit` (long-running)
- [ ] **R-SEC-4-4** `mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db`
- [ ] **R-SEC-4-5** `systemctl enable --now aide.timer`
- [ ] **R-SEC-4-6** `systemctl list-timers aide.timer` → confirm active
- [ ] **R-SEC-4-7** First check: `aide --check 2>&1 | tee evidence/master_aide_check_<date>.txt`
- [ ] **R-SEC-4-8** Investigate any unexpected changes before closing

**Gate-A acceptance:**
- `apt list --upgradable` (security) empty on Lady
- `ss -tlnp | grep 0.0.0.0` on Lady matches expected list only
- No 172.16.0.0/12 or 10.0.0.0/8 broad rules in `ufw status`
- `aide.timer` active on Master, `aide --check` clean
- Three residual FQDNs return 403/redirect from non-VPN
- Sign `gates/GATE_A_SECURITY.md`

---

## PHASE 2 — BACKUP & DR (P0)

### 2A · Lady backup implementation

- [ ] **R-BKP-1-1** `ssh lady "mkdir -p /backup/lady"`
- [ ] **R-BKP-1-2** Mailcow: `cd /opt/mailcow-dockerized && bash helper-scripts/backup_and_restore.sh backup all` → verify `/var/mailcow/backup/`
- [ ] **R-BKP-1-3** Nextcloud DB: `docker exec nextcloud-db mysqldump -u root --all-databases > /backup/lady/nextcloud_db_<date>.sql`; `wc -l`
- [ ] **R-BKP-1-4** Nextcloud files: `occ maintenance:mode --on` → `rsync -av <nc_data>/ /backup/lady/nextcloud_files/` → `--off`
- [ ] **R-BKP-1-5** Odoo: `docker exec odoo-db pg_dumpall -U odoo > /backup/lady/odoo_<date>.sql`
- [ ] **R-BKP-1-6** UniFi: `docker exec unifi-db mongodump --out /backup/lady/unifi_<date>/`
- [ ] **R-BKP-1-7** HA config: `rsync -av <ha_config>/ /backup/lady/homeassistant/`
- [ ] **R-BKP-1-8** Install restic; init offsite S3 repo; password in `~/.secrets/restic-lady` (600)
- [ ] **R-BKP-1-9** First push: `restic -r <repo> backup /backup/lady/` → `restic snapshots`
- [ ] **R-BKP-1-10** Cron daily 02:00 via `/usr/local/bin/lady-backup.sh` (all 6 + restic + prune)
- [ ] **R-BKP-1-11** `crontab -l > evidence/lady_crontab_<date>.txt`
- [ ] **R-BKP-1-12** `restic snapshots > evidence/lady_restic_snapshots_<date>.txt`

### 2B · Master backup verification

- [ ] **R-BKP-2-1** `crontab -l; systemctl list-timers | grep -i backup` → `evidence/master_backup_state_<date>.txt`
- [ ] **R-BKP-2-2** Confirm Contabo daily 00:00 snapshot → `evidence/contabo_snapshots_state_<date>.txt`
- [ ] **R-BKP-2-3** Headscale DB: `ls -lh /var/lib/headscale/` covered by backup path?
- [ ] **R-BKP-2-4** If missing: restic job for `~/projects/ ~/.docs/ ~/.github/ ~/.docker-compose/ ~/.docker/` + separate encrypted for `~/.secrets/`
- [ ] **R-BKP-2-5** Schedule + evidence

### 2C · Restore drills (mandatory)

- [ ] **R-BKP-3-1** Lady — Nextcloud DB drill (temp schema, table count verified)
- [ ] **R-BKP-3-2** Lady — Mailcow drill (non-destructive subset)
- [ ] **R-BKP-3-3** Master — `restic restore latest --target /tmp/restore_test/`; diff
- [ ] **R-BKP-3-4** Record RTO + RPO each → `evidence/restore_drills_<date>.txt`

**Gate-B acceptance:** 6 Lady artifacts fresh (≤24h); restic remote confirmed; cron logged; ≥3 drills within targets (Mailcow/Nextcloud ≤4h, Odoo/UniFi ≤8h, HA ≤24h, Master configs ≤2h). Sign `gates/GATE_B_RESILIENCE.md`.

---

## PHASE 3 — PLATFORM STABILITY (P1)

### 3A · Baseline + RCA

- [ ] **R-STB-1-1** `nproc` both → `evidence/cpu_count_<date>.txt`
- [ ] **R-STB-1-2** `docker stats --no-stream` both → `evidence/<node>_docker_stats_before_<date>.txt`
- [ ] **R-STB-1-3** `ps -eo pid,cmd,%cpu --sort=-%cpu | head -15` both
- [ ] **R-STB-1-4** Nextcloud RestartCount: `docker inspect nextcloud | jq '.[0].State'` → evidence
- [ ] **R-STB-1-5** Lady traefik 2-month uptime check

### 3B · Resource limits — Master

- [ ] **R-STB-2-1** Apply Utility class (node-exporter, cadvisor, blackbox, promtail)
- [ ] **R-STB-2-2** Monitor 30 min; no OOM
- [ ] **R-STB-2-3** Apply Apps class
- [ ] **R-STB-2-4** Monitor 30 min
- [ ] **R-STB-2-5** Apply Critical infra
- [ ] **R-STB-2-6** Monitor 1 hour
- [ ] **R-STB-2-7** Apply Monitoring (prometheus LAST, test runtime memory first)
- [ ] **R-STB-2-8** Post → `evidence/master_docker_stats_after_<date>.txt` + `evidence/master_limits_applied_<date>.txt`

### 3C · Resource limits — Lady

- [ ] **R-STB-3-1** Utility → Apps → DBs → Mail → AV → OnlyOffice (test 4 GB first)
- [ ] **R-STB-3-2** Post → `evidence/lady_docker_stats_after_<date>.txt` + `evidence/lady_limits_applied_<date>.txt`

### 3D · Traefik hardening verification (P1-3)

- [ ] **R-STB-4-1** Export static: `docker exec traefik cat /etc/traefik/traefik.yaml` → `evidence/traefik_static_<node>_<date>.txt`
- [ ] **R-STB-4-2** Export dynamic → `evidence/traefik_dynamic_<node>_<date>.txt`
- [ ] **R-STB-4-3** `api.insecure: false` + dashboard protected by Authelia
- [ ] **R-STB-4-4** `curl -s http://127.0.0.1:8080/api/http/routers | jq '.[] | {name,rule,middlewares,service}'` → `evidence/traefik_routers_<node>_<date>.txt`
- [ ] **R-STB-4-5** Every router has authelia@docker / vpn-only@file / public@file + crowdsec-bouncer@file + default-security-headers@file
- [ ] **R-STB-4-6** Curl 3 public HTTPS → HSTS + X-Frame-Options + X-Content-Type-Options → `evidence/traefik_headers_<date>.txt`
- [ ] **R-STB-4-7** Fix gaps; redeploy; re-evidence

### 3E · Healthcheck gaps

- [ ] **R-STB-5-1** Add healthchecks in compose: cloudflared, headscale-admin, headscale-ui, it-tools, default-landing, portainer, node-exporter (Master)
- [ ] **R-STB-5-2** `docker compose up -d <svc>`; verify healthy
- [ ] **R-STB-5-3** `evidence/master_healthchecks_<date>.txt`

**Gate-C acceptance:** No zero-Memory critical/stateful; no OOM; load ≤ nproc; Traefik evidence complete. Sign `gates/GATE_C_STABILITY.md`.

---

## PHASE 4 — MONITORING E2E

- [ ] **R-MON-1** Fire test alert via Alertmanager API
- [ ] **R-MON-2** Confirm Ntfy push received
- [ ] **R-MON-3** Confirm Gotify received
- [ ] **R-MON-4** Record time-to-notify < 5 min → `evidence/alert_pipeline_test_<date>.txt`
- [ ] **R-MON-5** Resolve test alert (endsAt)
- [ ] **R-MON-6** List rules → `evidence/prometheus_rules_<date>.txt`
- [ ] **R-MON-7** Add missing: NodeDown, HighMemory, HighDisk, CriticalDisk, ContainerOOM, TargetDown, CertExpiry30d, BackupStale
- [ ] **R-MON-8** Loki retention bounded (90d); `docker exec loki cat /etc/loki/loki.yml | grep -A2 retention`
- [ ] **R-MON-9** Blackbox coverage complete
- [ ] **R-MON-10** Pin uptime-kuma to named tag
- [ ] **R-MON-11** Grafana "Perfection KPI" dashboard

**Gate-E acceptance:** pipeline tested with timing; mandatory rules present; Loki bounded; uptime-kuma tagged. Sign `gates/GATE_E_MONITORING.md`.

---

## PHASE 5 — DOCUMENTATION + GATE-F

### 5A · Fill evidence gaps

- [ ] **R-DOC-1** sysctl both nodes → `evidence/<node>_sysctl_<date>.txt`
- [ ] **R-DOC-2** `docker inspect` full (RestartPolicy, Memory, PidsLimit, User, Mounts) → `evidence/<node>_container_inspect_<date>.txt`
- [ ] **R-DOC-3** `docker volume ls` + `docker system df` → `evidence/<node>_volumes_<date>.txt`
- [ ] **R-DOC-4** `find ~/.secrets/ -type f -printf '%m %u:%g %p\n'` — all 600 → `evidence/<node>_secrets_perms_<date>.txt`
- [ ] **R-DOC-5** `iptables -L -n -v` → `evidence/<node>_iptables_<date>.txt`

### 5B · Sysctl alignment (P2-1)

- [ ] **R-DOC-6** Deploy `/etc/sysctl.d/99-hardening.conf` both nodes:
  - `net.ipv4.conf.all.accept_redirects = 0`
  - `net.ipv4.conf.default.accept_redirects = 0`
  - `net.ipv4.conf.all.send_redirects = 0`
  - `net.ipv4.conf.all.rp_filter = 1`
  - `net.ipv4.tcp_syncookies = 1`
  - `kernel.kptr_restrict = 2`
  - `kernel.dmesg_restrict = 1`
  - `kernel.randomize_va_space = 2`
- [ ] **R-DOC-7** `sysctl --system` + re-capture → `evidence/<node>_sysctl_after_<date>.txt`

### 5C · Image refresh (P2-3, one at a time)

- [ ] **R-DOC-8** cloudflared: pull → verify tunnel + DNS through tunnel
- [ ] **R-DOC-9** homeassistant: pull → verify UI
- [ ] **R-DOC-10** prometheus: pull — test memory at runtime first; restart; verify targets
- [ ] **R-DOC-11** grafana: pull → verify dashboards

### 5D · Doc reconciliation

- [ ] **R-DOC-12** Update `~/projects/qui3tly.cloud/README.md` if counts changed
- [ ] **R-DOC-13** Update `BASELINE/INFRASTRUCTURE_BASELINE.md` to post-perfection state
- [ ] **R-DOC-14** FQDN service matrix → `evidence/fqdn_service_matrix_<date>.md`
- [ ] **R-DOC-15** Change log Feb → Apr → `evidence/change_log_feb_to_apr.md`
- [ ] **R-DOC-16** Mark preproduction `DOCUMENTATION_COVERAGE_MATRIX.md` DR = VERIFIED
- [ ] **R-DOC-17** `git add -A && git commit -m "perfection: phase-5 evidence + doc reconciliation" && git push`

**Gate-D acceptance:** All evidence captured; FQDN matrix exists; drifted docs updated; git clean. Sign `gates/GATE_D_DOCUMENTATION.md`.

### 5E · Final Go/No-Go

- [ ] **R-FINAL-1** Review all signed gates (A/B/C/D/E) PASS
- [ ] **R-FINAL-2** List open risks, accepted risks, rollback plan in `gates/GATE_F_GO_NOGO.md`
- [ ] **R-FINAL-3** Issue signed Go/No-Go
- [ ] **R-FINAL-4** Announce production lock (if Go) or next-sprint plan (if No-Go)

---

## Immediate next 10 commands (operator runbook)

```bash
# 1. [MANUAL] Contabo snapshots Lady + Master → label perfection-2026-04-21-pre

# 2. Record snapshot IDs
echo "lady_snapshot_id=<id>"   >> ~/projects/qui3tly.cloud/perfection/evidence/00_snapshot_log.txt
echo "master_snapshot_id=<id>" >> ~/projects/qui3tly.cloud/perfection/evidence/00_snapshot_log.txt

# 3. Git baseline
cd ~ && git add -A && git commit -m "perfection: pre-phase-0 freeze" && git push

# 4. Fix 3 residual public@file bugs on Master (5 min, zero risk)
for svc in pihole headscale-ui headscale-admin; do
  cp ~/.docker-compose/$svc/docker-compose.yaml ~/.docker-compose/$svc/docker-compose.yaml.pre-perfection
  sed -i 's/,public@file/,vpn-only@file/g' ~/.docker-compose/$svc/docker-compose.yaml
  (cd ~/.docker-compose/$svc && docker compose up -d)
done

# 5. Lady pre-patch evidence
ssh lady "uname -r; apt list --upgradable 2>/dev/null" > ~/projects/qui3tly.cloud/perfection/evidence/lady_pre_patch_$(date +%Y%m%d).txt

# 6. Patch Lady
ssh lady "apt update && apt upgrade -y"

# 7. Reboot Lady
ssh lady "reboot"

# 8. Post-reboot verify (wait 3 min)
ssh lady "uname -r; uptime; docker ps | wc -l"

# 9. Identify python3:5000 on Lady
ssh lady "PID=\$(ss -tlnp | grep ':5000' | grep -oP 'pid=\\K[0-9]+' | head -1); ls -la /proc/\$PID/exe 2>/dev/null; cat /proc/\$PID/cmdline 2>/dev/null | tr '\\0' ' '"

# 10. Fix AIDE on Master (while Lady reboots)
journalctl -u aide.service -n 30
aideinit && mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db && systemctl enable --now aide.timer
aide --check 2>&1 | tail -20
```

---

## Acceptance summary

| Gate | File | Status |
|---|---|---|
| Gate-0 Safety net | `gates/GATE_0_SAFETY_NET.md` | `[ ]` |
| Gate-A Security | `gates/GATE_A_SECURITY.md` | `[ ]` |
| Gate-B Resilience | `gates/GATE_B_RESILIENCE.md` | `[ ]` |
| Gate-C Stability | `gates/GATE_C_STABILITY.md` | `[ ]` |
| Gate-D Documentation | `gates/GATE_D_DOCUMENTATION.md` | `[ ]` |
| Gate-E Monitoring | `gates/GATE_E_MONITORING.md` | `[ ]` |
| Gate-F Final Go/No-Go | `gates/GATE_F_GO_NOGO.md` | `[ ]` |

All `[ ]` must flip to `[x] · <date> · gates/<file>` with PASS before production lock.

---

## APPENDIX · Admin-panel specific remediation (added 2026-04-21 after focused review)

Listed here rather than inlined because admin-panel spans multiple phases (security + hardening + docs).

### A1 · Code + secrets review (P1, before any other admin-panel change)

- [ ] **R-ADM-1-1** Read `~/.docker/admin-panel/app_simple.py` line-by-line. Record every endpoint, every shell-exec, every SSH call → `evidence/admin_panel_code_review_<date>.md`
- [ ] **R-ADM-1-2** Audit `~/.secrets/admin-panel/.env` contents (600 perms, rotation age, scope) → `evidence/admin_panel_env_audit_<date>.md` (redact values)
- [ ] **R-ADM-1-3** Identify exactly **where** the mounted SSH key connects to. Document the target(s) and the commands executed → `evidence/admin_panel_ssh_scope_<date>.md`
- [ ] **R-ADM-1-4** Decision: can SSH from admin-panel be replaced by Docker API over a UNIX socket, Semaphore API calls, or Ansible-pull? SSH-from-container-as-root is a persistence jackpot — minimize scope

### A2 · Kill the build-on-boot anti-pattern (P1)

- [ ] **R-ADM-2-1** Create `~/.docker-compose/admin-panel/Dockerfile` — FROM python:3.11.9-slim (pinned), RUN apt-get install with --no-install-recommends and pinned versions, pip install flask==X.Y.Z --require-hashes
- [ ] **R-ADM-2-2** Add `USER appuser` (non-root, UID ≥ 10000) and corresponding `RUN adduser --system --uid 10001 appuser`
- [ ] **R-ADM-2-3** Switch compose to `build: .` (or build + image tag), remove the long `command:` override
- [ ] **R-ADM-2-4** Build, `docker compose up -d`, verify healthy + dashboard loads via VPN
- [ ] **R-ADM-2-5** Evidence: `docker inspect admin-panel | jq '.[0].Config.User'` ≠ "" → `evidence/admin_panel_user_after_<date>.txt`

### A3 · Drop root + mount footprint (P1)

- [ ] **R-ADM-3-1** SSH key mount path must follow target user home — re-mount at `/home/appuser/.ssh/id_ed25519:ro` with correct uid/gid
- [ ] **R-ADM-3-2** Ensure key file host perms are 600 and `chown qui3tly:qui3tly`; document access
- [ ] **R-ADM-3-3** Consider read-only root filesystem (`read_only: true`) + tmpfs for `/tmp`
- [ ] **R-ADM-3-4** Add `cap_drop: [ALL]` and only `cap_add` what Flask needs (probably nothing)

### A4 · Resource limits (P1-2 roll-in)

- [ ] **R-ADM-4-1** Class "Apps" limits: mem 256 MB, cpus 0.25, pids 100 — admin-panel is a small Flask dashboard, not heavy
- [ ] **R-ADM-4-2** Verify healthy after limits; save stats → `evidence/admin_panel_stats_after_<date>.txt`

### A5 · Middleware + auth layer (P1)

- [ ] **R-ADM-5-1** Decide: keep CrowdSec + vpn-only (current) OR add Authelia 2FA OR add basicauth as [.docs/03-services/ADMIN_PANEL.md](.docs/03-services/ADMIN_PANEL.md) originally specified
- [ ] **R-ADM-5-2** Recommendation: since the panel can exec SSH as root, require **Authelia 2FA** on top of vpn-only. Middleware chain: `crowdsec-bouncer@file,authelia@docker,vpn-only@file`
- [ ] **R-ADM-5-3** Apply; verify auth flow from VPN; `evidence/admin_panel_auth_chain_<date>.txt`

### A6 · Documentation reconciliation (P2)

- [ ] **R-ADM-6-1** Update [.docs/03-services/ADMIN_PANEL.md](.docs/03-services/ADMIN_PANEL.md): correct image (python:3.11-slim, soon-to-be Dockerfile-built), correct middleware chain, correct auth layer, memory 10 MB → real measured value with limit
- [ ] **R-ADM-6-2** Document SSH scope + target hosts explicitly
- [ ] **R-ADM-6-3** Commit → `evidence/admin_panel_doc_reconciliation_<date>.md`

**Acceptance:**
- admin-panel runs as non-root user (uid ≥ 10000)
- No build-on-boot; image is built from a pinned Dockerfile
- SSH key scope documented and minimized
- Resource limits applied (256 MB / 0.25 CPU / 100 pids)
- Authelia 2FA on route
- Doc matches live
- All evidence captured

---

# SUPPLEMENT (added 2026-04-21 after full-source sweep)

Scope expansion from FINDINGS_INDEX.md §4 (30 items) + §5 (new phases). The original Phase 0–5 + Gates remain valid; the sections below add what was missed.

---

## PHASE 1F · CREDENTIALS SWEEP (Audit 13)

No rotation in this sprint — **inventory + perms + git-history only**. Rotation plan goes into Phase 5 docs. Work on both nodes.

### Master

- [ ] **R-CRED-1-1** `find ~/.secrets/ -type f -printf '%m %u:%g %p\n' | sort > evidence/master_secrets_perms_<date>.txt` → every file 600, dir 700
- [ ] **R-CRED-1-2** `ls -la ~/.docker/traefik/acme.json; sudo ls -la /etc/headscale/config.yaml; sudo ls -la /etc/wireguard/wg0.conf` → evidence
- [ ] **R-CRED-1-3** `grep -rn -iE "(password|passwd|secret|token|api.key|apikey|credential|private.key|CF_)" ~/.docker/ ~/.docker-compose/ ~/.copilot/ ~/.ansible/ 2>/dev/null | grep -v ".git/" | grep -v "Binary file" > evidence/master_creds_plaintext_<date>.txt`
- [ ] **R-CRED-1-4** For every running container: `docker inspect $c --format '{{range .Config.Env}}{{.}}{{"\n"}}{{end}}' | grep -iE "password|secret|token|key|auth|CF_"` → `evidence/master_container_env_creds_<date>.txt`
- [ ] **R-CRED-1-5** Git history: `cd ~ && git log --all -p -- '**/docker-compose*' '**/.env' '**/*.yml' '**/*.yaml' 2>/dev/null | grep -iE "password|secret|token|CF_" | head -50 > evidence/master_git_history_creds_<date>.txt`
- [ ] **R-CRED-1-6** Sudoers: `sudo cat /etc/sudoers /etc/sudoers.d/* 2>/dev/null > evidence/master_sudoers_<date>.txt` → no NOPASSWD outside documented scope
- [ ] **R-CRED-1-7** SSH keys: `ls -la ~/.ssh/; sudo ls -la /root/.ssh/ 2>/dev/null > evidence/master_ssh_keys_<date>.txt`; for each `authorized_keys` list who can come in

### Lady (same set via ssh)

- [ ] **R-CRED-2-1** secrets perms
- [ ] **R-CRED-2-2** compose plaintext sweep
- [ ] **R-CRED-2-3** container env sweep
- [ ] **R-CRED-2-4** git history on the lady repo
- [ ] **R-CRED-2-5** sudoers
- [ ] **R-CRED-2-6** SSH keys

### Known high-value specifics (verify each)

- [ ] **R-CRED-3-1** Lady `mailcow/docker-compose.override.yml` — CF API token present?
- [ ] **R-CRED-3-2** Master `alertmanager/config/alertmanager.yml` — Ntfy password plaintext (×4)?
- [ ] **R-CRED-3-3** Master WireGuard `/etc/wireguard/wg0.conf` — private key perms
- [ ] **R-CRED-3-4** Master Headscale `/etc/headscale/config.yaml` — OIDC secret + noise private key
- [ ] **R-CRED-3-5** Authelia `configuration.yml` — JWT / session / OIDC secrets
- [ ] **R-CRED-3-6** Grafana `datasources.yml` — provisioning passwords
- [ ] **R-CRED-3-7** Nextcloud / Odoo compose — DB passwords
- [ ] **R-CRED-3-8** Admin-panel `app_simple.py` + `.env` — any hardcoded tokens
- [ ] **R-CRED-3-9** `~/.copilot/scripts/gotify-notify.sh` — token location and perms

### Output

- [ ] **R-CRED-4** Consolidated inventory table → `evidence/credentials_inventory_<date>.md` with columns: Node | File | Line | Type | Classification (CRIT/HIGH/MED/LOW) | Storage (plaintext/env/secret) | Rotation priority

**Acceptance (folds into Gate-A):** every credential found is catalogued, every sensitive file has 600 perms, no git history leak remains un-investigated, rotation plan seeded for Phase 5.

---

## PHASE 1G · FEB-17 MITIGATIONS VERIFICATION

Prove the Feb 17 outage cannot recur the same way.

- [ ] **R-F17-1** `grep -A2 'accessLog:' ~/.docker/traefik/traefik.yaml` → `bufferingSize: 100` present → `evidence/master_traefik_bufferingSize_<date>.txt`
- [ ] **R-F17-2** Same on Lady (`ssh lady ...`) → evidence
- [ ] **R-F17-3** `stat -c '%a %n' ~/.docker/traefik/acme.json` → `600` → `evidence/master_acme_perms_<date>.txt`
- [ ] **R-F17-4** Same on Lady → evidence
- [ ] **R-F17-5** `grep -n 'ISSUES_FOUND' ~/.copilot/scripts/service-monitor.sh` → wrap `((ISSUES_FOUND++))` with `|| true`, or use `ISSUES_FOUND=$((ISSUES_FOUND+1))` → evidence of fix
- [ ] **R-F17-6** Simulate: run `bash -x ~/.copilot/scripts/service-monitor.sh` with artificial failure → confirm alert fires → `evidence/service_monitor_dryrun_<date>.txt`
- [ ] **R-F17-7** Verify Traefik `restart: always` (not `unless-stopped`) per DOMAIN_STRATEGY v5 Phase 3 correction → evidence
- [ ] **R-F17-8** Confirm `/etc/systemd/system/docker.service.d/wait-for-vpn.conf` + `/etc/systemd/system/wait-for-tailscale-ip.service` presence OR accepted absence with Ansible capture → evidence

**Acceptance (folds into Gate-A):** every Feb-17 root cause shown fixed or shown not reintroducible.

---

## PHASE 1H · COMPOSE-LEVEL R05/R06/R07 + HOUSEKEEPING

Cross-cuts Phase 3 but captures rules from `DOCKER_ORGANIZATION_MANDATORY.md` explicitly.

- [ ] **R-DOX-1-1** Pin `ghcr.io/blakeblackshear/frigate:stable` → `frigate:0.15.x` (pick current stable release) → redeploy → verify camera streams + recording
- [ ] **R-DOX-1-2** Remove or document `~/.docker-compose/crowdsec.bak/` — confirm not running via `docker ps -a` → either delete or move under `~/backups/`
- [ ] **R-DOX-1-3** `security-tools` (trivy) — verify running OR retire. If running: where does scan output go? Hook into Prometheus? → document in service doc
- [ ] **R-DOX-1-4** Verify pihole compose image line — dedicated inspect since my quick grep caught a confusing first-image match
- [ ] **R-DOX-1-5** Full R05 check: `for f in ~/.docker-compose/*/docker-compose.yaml; do grep -H 'image:' "$f" | grep -vE ':[a-z0-9._-]+(@sha256:[a-f0-9]+)?\s*$' ; done > evidence/master_unpinned_images_<date>.txt` → must be empty
- [ ] **R-DOX-1-6** Same on Lady
- [ ] **R-DOX-1-7** R06 check: `for c in $(docker ps --format '{{.Names}}'); do hc=$(docker inspect $c | jq -r '.[0].Config.Healthcheck'); echo "$c: $hc"; done > evidence/<node>_healthcheck_audit_<date>.txt` → no `null` on services that should have one
- [ ] **R-DOX-1-8** Add missing healthchecks identified in 1H-7 (intersects R-STB-5 in Phase 3)

---

## PHASE 4+ · MONITORING COVERAGE MATRIX (Audit 07 expansion)

Beyond "alert pipeline works", prove EVERY service meets 4-pillar coverage:

| Pillar | Check | Evidence |
|---|---|---|
| Logs | Shipped to Loki? | `curl -s http://loki:3100/loki/api/v1/labels/job/values` must include service |
| Metrics | Prom target UP? | `curl -s http://localhost:9090/api/v1/targets | jq` |
| Alert | At least one rule referencing the service? | `curl -s http://localhost:9090/api/v1/rules | jq` |
| Dashboard | Grafana has one? | Grafana API `/api/search` |

- [ ] **R-COV-1** Build matrix per service → `evidence/monitoring_coverage_matrix_<date>.md`
- [ ] **R-COV-2** Identify gaps → prioritize fill
- [ ] **R-COV-3** For critical services with gaps, create minimal rule + dashboard panel
- [ ] **R-COV-4** Mandatory alert rules list (external recommendation + `ALERT_RULES.md`): `NodeDown`, `HighMemory`, `HighDisk`, `CriticalDisk`, `ContainerOOM`, `TargetDown`, `CertExpiringSoon<7d`, `CertExpiring<30d`, `ContainerRestarting>5/h`, `ContainerNotHealthy`, `BackupStale>26h`
- [ ] **R-COV-5** Loki retention bounded (90d) → evidence

---

## PHASE 6 · DNS VERIFICATION (Audit 02 condensed)

Pre-lock checks — not full A+++ DNS audit, just production-readiness proof.

### Per domain: quietly.its.me, quietly.online, qui3tly.cloud

- [ ] **R-DNS-1-1** WHOIS: expiration >6 months, auto-renew on, privacy on → `evidence/dns_whois_<domain>_<date>.txt`
- [ ] **R-DNS-1-2** DNSSEC enabled: `dig +dnssec <domain>` → `evidence/dns_dnssec_<domain>_<date>.txt`
- [ ] **R-DNS-1-3** CAA record: `dig CAA <domain> +short` → `letsencrypt.org` or `cloudflare` → evidence
- [ ] **R-DNS-1-4** NS propagation: `dig NS <domain> @1.1.1.1 / @8.8.8.8 / @9.9.9.9` consistent
- [ ] **R-DNS-1-5** A/AAAA for primary FQDN: matches public IP → evidence

### Mail (quietly.online)

- [ ] **R-DNS-2-1** MX: `dig MX quietly.online +short` → priority 10 `mail.quietly.online` → evidence
- [ ] **R-DNS-2-2** SPF: `dig TXT quietly.online +short | grep spf1` → evidence; validate with `https://mxtoolbox.com/` (or equivalent offline)
- [ ] **R-DNS-2-3** DKIM: `dig TXT dkim._domainkey.quietly.online +short` → valid key → evidence
- [ ] **R-DNS-2-4** DMARC: `dig TXT _dmarc.quietly.online +short` → policy quarantine/reject → evidence
- [ ] **R-DNS-2-5** PTR: `dig -x 207.180.251.111 +short` → `mail.quietly.online` → evidence
- [ ] **R-DNS-2-6** MTA-STS + TLS-RPT present → evidence
- [ ] **R-DNS-2-7** Autoconfig + autodiscover FQDNs resolve → evidence

### CF API token scope (known v5 blocker)

- [ ] **R-DNS-3-1** Test CF token can issue a cert for `*.qui3tly.cloud`: dry-run DNS-01 → document result → `evidence/cf_token_qui3tly_cloud_test_<date>.txt`

**Acceptance (Gate-F prerequisite):** all three domains DNSSEC+CAA+proper mail DNS; PTR matches forward; CF token test result logged (pass or fail).

---

## PHASE 7 · MAIL VERIFICATION (Audit 06 condensed)

- [ ] **R-MAIL-1** 18 Mailcow containers → `docker compose ps` + per-container Health + RestartCount → `evidence/mailcow_health_<date>.txt`
- [ ] **R-MAIL-2** Queue health: `docker exec postfix-mailcow postqueue -p | tail` → normally <50
- [ ] **R-MAIL-3** Rspamd: scan ratio + scores → evidence
- [ ] **R-MAIL-4** ClamAV: definitions current, scan healthy → evidence
- [ ] **R-MAIL-5** Blacklist check: lookup public IP on 5+ DNSBLs (Spamhaus, SORBS, Barracuda, SpamCop, Invaluement) → evidence
- [ ] **R-MAIL-6** Send test from test account to `check-auth@verifier.port25.com` and/or `mail-tester.com` → score ≥9/10 → evidence
- [ ] **R-MAIL-7** IMAP/SMTP TLS version + cert validity (certbot output) → evidence
- [ ] **R-MAIL-8** SOGo load time <2s → evidence
- [ ] **R-MAIL-9** DKIM signature validation on outbound sample → evidence
- [ ] **R-MAIL-10** Mailcow backup tested (ties to Phase 2A-2)

**Acceptance (Gate-F prerequisite):** deliverability ≥95% documented; 18/18 containers healthy; no blacklist hits.

---

## GATE-D ENHANCEMENT — governance self-check (Audit 09)

Add to `GATE_D_DOCUMENTATION.md` acceptance:

- [ ] **R-GOV-1** `~/.copilot/START_HERE.md` present, accurate (infrastructure facts match live) → evidence
- [ ] **R-GOV-2** `~/.copilot/PRE_FLIGHT_CHECKLIST.md` present, updated to reference this perfection program's snapshots → evidence
- [ ] **R-GOV-3** `MEMORY_DISCIPLINE.md` reflects current practice
- [ ] **R-GOV-4** `GITHUB_ORGANIZATION_MANDATORY.md` symlinks still correct: `find ~ -maxdepth 1 -type l -ls > evidence/master_symlinks_<date>.txt`
- [ ] **R-GOV-5** Recent "lessons learned" from this sprint appended to `~/.docs/04-monitoring/LESSONS-LEARNED.md`

---

## PHASE 8 (POST-GATE-F ROADMAP — does not block production lock)

Listed so nothing is lost:

- Audit 08 — Branding consistency across 54 services (page titles, favicons, error pages, documentation branding, email templates)
- Audit 10 — DOMAIN_STRATEGY v5 migration to `*.qui3tly.cloud` + CF cert for zone
- Audit 12 — Full FQDN inventory (inputs from Phase 5 M20/M21/M22)
- Audit 13 Phase 2 — Credential rotation based on Phase-1F inventory
- Audit 01 — Business roadmap items: DSC Powermanage integration, mobile app, Pegasus-style unified SSO/dashboard, Home Assistant deepening
- Montefish multi-site readiness
- Project Norma

None of these are required to sign Gate-F; all of them are required to reach the stated A+++ end state.

