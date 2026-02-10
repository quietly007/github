# REQUEST FOR EXTERNAL AGENT: NUKE PASS CERTIFICATION

**Objective:** Earn "NUKE PASS" by proving safe rebuild is possible

**Type:** Safe nuke (containers + images only, NO volumes)

---

## YOUR MISSION

Verify that after `docker system prune -a` (WITHOUT --volumes), all services can be rebuilt and accessed with existing credentials.

---

## STEP 1: PRE-NUKE BASELINE

### Test ALL web services accessibility:

**Master Server:**
```bash
curl -sk --resolve ntfy.quietly.its.me:443:100.64.0.1 "https://ntfy.quietly.its.me" -o /dev/null -w "%{http_code}\n"
curl -sk --resolve pihole.quietly.its.me:443:100.64.0.1 "https://pihole.quietly.its.me/admin/" -o /dev/null -w "%{http_code}\n"
curl -sk --resolve grafana.quietly.its.me:443:100.64.0.1 "https://grafana.quietly.its.me" -o /dev/null -w "%{http_code}\n"
curl -sk --resolve uptime.quietly.its.me:443:100.64.0.1 "https://uptime.quietly.its.me" -o /dev/null -w "%{http_code}\n"
curl -sk http://100.64.0.1:9000 -o /dev/null -w "%{http_code}\n"  # Portainer
curl -sk http://100.64.0.1:8080 -o /dev/null -w "%{http_code}\n"  # Traefik
# ... test ALL services
```

**Lady Server:**
```bash
curl -sk https://mail.quietly.online -o /dev/null -w "%{http_code}\n"
curl -sk https://nextcloud.quietly.online -o /dev/null -w "%{http_code}\n"
curl -sk https://odoo.quietly.online -o /dev/null -w "%{http_code}\n"
curl -sk https://homeassistant.quietly.its.me -o /dev/null -w "%{http_code}\n"
# ... test ALL services
```

### Document in `PRE_NUKE_BASELINE.md`:
- Service URL
- HTTP response code
- Status (200=OK, 404=Not found, 503=Down, etc.)
- Login tested? (Y/N)
- Current credentials work? (Y/N)

---

## STEP 2: COMPOSE FILE AUDIT

For EVERY working service, verify compose file ready:

```bash
# Check compose exists
ls ~/.docker-compose/grafana/docker-compose.yaml

# Check has volumes defined
grep -A5 "volumes:" ~/.docker-compose/grafana/docker-compose.yaml

# Check no hardcoded passwords
grep -i "password:" ~/.docker-compose/grafana/docker-compose.yaml
```

### Document in `COMPOSE_AUDIT.md`:
- Service name
- Compose file path
- Volumes: Named or bind mounts?
- Secrets: Externalized or hardcoded?
- Ready for rebuild? (Y/N)

**RED FLAG:** If any service has hardcoded passwords/secrets → FIX BEFORE NUKE

---

## STEP 3: BACKUP VERIFICATION

```bash
# Run backup manually
/home/qui3tly/.copilot/cron/docker_backup.sh

# Verify backup created
ls -lh /home/qui3tly/backups/backup_*.tar.gz

# Check backup has all critical data
tar -tzf /home/qui3tly/backups/backup_*.tar.gz | grep -E "grafana|portainer|prometheus"
```

### Document in `BACKUP_VERIFICATION.md`:
- Backup file size
- Date created
- Contains which volumes?
- Restore tested? (optional but recommended)

---

## STEP 4: SAFE NUKE PLAN

Create `SAFE_NUKE_PLAN.md`:

```markdown
# Safe Nuke Execution Plan

## 1. Pre-nuke checklist:
- [ ] Baseline documented (all services HTTP codes)
- [ ] Compose files verified (all services)
- [ ] Backup created and verified
- [ ] User approval received

## 2. Nuke command (SAFE):
docker system prune -a

## 3. Post-nuke rebuild sequence:
1. cd ~/.docker-compose/traefik && docker compose up -d
2. cd ~/.docker-compose/pihole && docker compose up -d
3. cd ~/.docker-compose/grafana && docker compose up -d
... (all 24 services)

## 4. Post-rebuild verification:
- Test same URLs as baseline
- Verify same HTTP response codes
- Test login with same credentials
- Document any failures

## 5. Success criteria:
✅ All services return same HTTP codes as baseline
✅ All logins work with existing credentials
✅ No data loss (volumes preserved)
✅ Grade remains 59/100 or better

## 6. Rollback plan (if rebuild fails):
- Restore from backup: tar -xzf backup_*.tar.gz
- Rebuild services: docker compose up -d
```

---

## STEP 5: EARN NUKE PASS

### Submit these 4 reports:

1. **PRE_NUKE_BASELINE.md** - All services tested, HTTP codes documented
2. **COMPOSE_AUDIT.md** - All compose files verified ready
3. **BACKUP_VERIFICATION.md** - Backup created and verified
4. **SAFE_NUKE_PLAN.md** - Complete execution plan with success criteria

### Nuke Pass Criteria:

✅ All 20+ web services baseline documented  
✅ All 24 compose files verified  
✅ Backup verified (>100MB)  
✅ Nuke plan has success criteria  
✅ Rollback plan documented  
✅ No hardcoded secrets found  

**If all ✅ → NUKE PASS GRANTED**

---

## WHAT NOT TO DO:

❌ Do NOT run nuke command yet  
❌ Do NOT use `--volumes` flag  
❌ Do NOT proceed without user approval  
❌ Do NOT skip baseline verification  

---

**Save all reports in:** `PHASE-01-INFRASTRUCTURE-AUDIT/`

**Ask user:** "4 reports complete. Ready for nuke pass review. Should I submit? (Y/N)"
