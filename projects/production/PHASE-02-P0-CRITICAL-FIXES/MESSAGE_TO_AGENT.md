# MESSAGE TO EXTERNAL AGENT: NEW PHASE 02

**Status:** Plan restructured. Nuke postponed.

---

## WHAT CHANGED

**Old plan:** Governance on broken system  
**New plan:** Fix everything FIRST, then governance  

**You already completed:**
- ✅ Phase 01: Infrastructure Audit
- ✅ Phase 02 attempt: Governance (but services broken)

**New sequence:**
- Phase 02 (NEW): P0 Critical Fixes - Get to 100% working
- Phase 03: Governance (was Phase 02)
- Phase 04+: Improvements

---

## YOUR NEW TASK: PHASE 02 - P0 CRITICAL FIXES

**Goal:** Fix ALL broken services → 17/17 working (100%)

**Current state:** 11/17 working (65% - from your baseline report)

---

## WHAT TO FIX:

### 1. Prometheus (DOWN - Exit 255)

**ROOT CAUSE INVESTIGATION REQUIRED FIRST:**
```bash
# 1. Check why it crashed
docker inspect prometheus --format '{{json .State}}' | jq
docker logs prometheus 2>&1 | grep -E "panic|fatal|error|corruption" | head -50
sudo dmesg -T | grep -i "prometheus\|oom\|killed" | tail -20

# 2. Check system uptime and reboot history
uptime
last reboot | head -5
sudo journalctl --list-boots

# 3. Check resource usage and limits
docker inspect prometheus --format '{{.HostConfig.Memory}}'
docker stats prometheus --no-stream

# 4. Check WAL corruption details
docker exec prometheus ls -lh /prometheus/wal/
```

**ONLY AFTER INVESTIGATION, THEN FIX:**
```bash
cd ~/.docker-compose/prometheus
docker compose down
docker compose up -d
docker logs prometheus --tail 100 | grep -E "corruption|repair|WAL"
curl http://localhost:9090/-/healthy
```

**PERMANENT FIX REQUIREMENTS:**
- Add `stop_grace_period: 30s` to docker-compose.yaml
- Document root cause in report (server reboot? OOM? crash?)
- Verify 2GB memory limit is sufficient for 30d retention
- Test graceful shutdown: `docker compose stop prometheus && docker compose up -d`

**Success:** 
- ✅ Returns "Prometheus Server is Healthy"
- ✅ No corruption errors in logs
- ✅ WAL segments intact
- ✅ Root cause documented

### 2. Alertmanager (Timeout)

**ROOT CAUSE INVESTIGATION FIRST:**
```bash
# Check why it's timing out
docker logs alertmanager 2>&1 | tail -200 | grep -iE "error|timeout|connection|prometheus"
docker inspect alertmanager --format '{{json .State}}'
netstat -tulpn | grep 9093
curl -v --max-time 5 http://localhost:9093/-/healthy

# Check if it depends on Prometheus
grep -r "prometheus" ~/.docker/alertmanager/config/
```

**THEN FIX:**
```bash
cd ~/.docker-compose/alertmanager
docker compose restart
sleep 10
docker logs alertmanager --tail 50
curl --max-time 10 http://localhost:9093/-/healthy
```

**PERMANENT FIX:**
- Document why timeout occurred (Prometheus down? config issue?)
- Verify alertmanager.yml config valid
- Add healthcheck timeout to compose if missing

**Success:**
- ✅ Returns healthy status within 5 seconds
- ✅ No timeout errors in logs
- ✅ Root cause documented

### 3. Nextcloud (109 errors - Not installed)

**ROOT CAUSE INVESTIGATION FIRST:**
```bash
ssh lady
cd ~/.docker-compose/nextcloud

# Count and categorize errors
docker logs nextcloud 2>&1 | grep -i "not installed" | wc -l
docker logs nextcloud 2>&1 | tail -50 | grep -iE "error|fail|database"

# Check database status
docker ps --filter name=nextcloud
docker exec nextcloud-db mariadb -u root -p -e "SHOW DATABASES;"
docker exec nextcloud-db mariadb -u root -p -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='nextcloud';"

# Check Nextcloud install status
docker exec nextcloud cat /config/www/nextcloud/config/config.php | grep installed
```

**THEN FIX (choose based on findings):**
```bash
# Option A: Database exists but Nextcloud not configured
docker exec nextcloud php /config/www/nextcloud/occ maintenance:install \
  --database="mysql" --database-name="nextcloud" \
  --database-host="nextcloud-db" --database-user="nextcloud" \
  --database-pass="<password>" --admin-user="admin" --admin-pass="<admin_password>"

# Option B: Database missing - recreate
# (Only if Option A fails)

# Verify fix
docker logs nextcloud --tail 50 | grep -i "error"
curl -sk https://nextcloud.quietly.online -o /dev/null -w "%{http_code}\n"
```

**PERMANENT FIX:**
- Document why Nextcloud was uninstalled (DB dropped? config corruption?)
- Backup config.php and database regularly
- Add database persistence verification to monitoring

**Success:**
- ✅ Returns 200 OK
- ✅ Login page loads
- ✅ ZERO "Not installed" errors in logs
- ✅ Database has tables
- ✅ Root cause documented

### 4. Redis (Connection errors to 172.28.1.249:6379)

**ROOT CAUSE INVESTIGATION FIRST:**
```bash
ssh lady

# Check Redis status and logs
docker ps --filter name=redis
docker logs nextcloud-redis 2>&1 | tail -100 | grep -iE "error|warn|connection"
docker exec nextcloud-redis redis-cli ping

# Check network connectivity
docker inspect nextcloud --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
docker inspect nextcloud-redis --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
docker exec nextcloud ping -c 3 172.28.1.249
docker exec nextcloud nc -zv 172.28.1.249 6379

# Check Nextcloud config
docker exec nextcloud cat /config/www/nextcloud/config/config.php | grep redis
```

**THEN FIX:**
```bash
# If IP wrong in Nextcloud config
# Update config.php with correct Redis IP

# If Redis not in same network
cd ~/.docker-compose/nextcloud
docker compose down
docker compose up -d

# Verify
docker exec nextcloud-redis redis-cli ping
docker logs nextcloud --tail 50 | grep -i redis
```

**PERMANENT FIX:**
- Document why IP changed or connection broke
- Use DNS names instead of IPs (redis:6379 not 172.28.1.249:6379)
- Verify both containers in same Docker network
- Add redis connection healthcheck

**Success:**
- ✅ Redis responds to PING
- ✅ Nextcloud connects without errors
- ✅ ZERO connection errors in logs
- ✅ Using DNS name not hardcoded IP
- ✅ Root cause documented

### 5. Routing Issues (Odoo, HomeAssistant, Frigate, Ntfy)

**ROOT CAUSE INVESTIGATION FIRST:**
```bash
# From baseline report: Odoo, HomeAssistant, Frigate (Lady) + Ntfy (Master) = 404

# Check Traefik routing
docker logs traefik --tail 100 | grep -iE "error|404|router"
curl -sk https://traefik.quietly.its.me/api/http/routers | jq '.[] | select(.name | contains("odoo"))'

# Check service labels
ssh lady
docker inspect odoo --format '{{range $k,$v := .Config.Labels}}{{$k}}={{$v}}{{"\n"}}{{end}}' | grep traefik
docker inspect homeassistant --format '{{range $k,$v := .Config.Labels}}{{$k}}={{$v}}{{"\n"}}{{end}}' | grep traefik
docker inspect frigate --format '{{range $k,$v := .Config.Labels}}{{$k}}={{$v}}{{"\n"}}{{end}}' | grep traefik

exit
docker inspect ntfy --format '{{range $k,$v := .Config.Labels}}{{$k}}={{$v}}{{"\n"}}{{end}}' | grep traefik

# Check DNS resolution
dig +short odoo.quietly.online
dig +short homeassistant.quietly.its.me
dig +short frigate.quietly.its.me
dig +short ntfy.quietly.its.me
```

**THEN FIX (based on findings):**
```bash
# Option A: Missing traefik.enable=true label
# Add to docker-compose.yaml

# Option B: Wrong network (not in traefik network)
# Add service to traefik network

# Option C: DNS not pointing to correct IP
# Update Cloudflare DNS records

# Apply fixes
ssh lady "cd ~/.docker-compose/odoo && docker compose up -d --force-recreate"
ssh lady "cd ~/.docker-compose/homeassistant && docker compose up -d --force-recreate"
ssh lady "cd ~/.docker-compose/frigate && docker compose up -d --force-recreate"
cd ~/.docker-compose/ntfy && docker compose up -d --force-recreate

# Verify
curl -sk https://odoo.quietly.online -o /dev/null -w "%{http_code}\n"
curl -sk https://homeassistant.quietly.its.me -o /dev/null -w "%{http_code}\n"
curl -sk https://frigate.quietly.its.me -o /dev/null -w "%{http_code}\n"
curl -sk https://ntfy.quietly.its.me -o /dev/null -w "%{http_code}\n"
```

**PERMANENT FIX:**
- Document exact cause (missing labels? wrong network? DNS?)
- Verify ALL services have correct Traefik labels
- Create template docker-compose for new services
- Add Traefik routing validation to monitoring

**Success:**
- ✅ Odoo: 200 or 302 (not 404)
- ✅ HomeAssistant: 200 or 302 (not 404)
- ✅ Frigate: 200 or 302 (not 404)
- ✅ Ntfy: 200 or 302 (not 404)
- ✅ All services registered in Traefik dashboard
- ✅ Root cause documented for each service

---

## DELIVERABLE

**Create:** `P0_FIXES_REPORT.md` in `PHASE-02-P0-CRITICAL-FIXES/` folder

**Report must include:**

### For each fix:
1. **Problem:** What was broken
2. **Commands executed:** Full command history
3. **Output:** Command results
4. **Result:** FIXED or STILL BROKEN
5. **Verification:** curl test + HTTP code

### Final verification table:
```
Service | Before | After | Status
--------|--------|-------|-------
Prometheus | DOWN | UP | ✅
Alertmanager | Timeout | 200 OK | ✅
Nextcloud | 503 | 200 OK | ✅
Redis | Error | Connected | ✅
... all 17 services ...
```

### Summary:
- Services working before: 11/17
- Services working after: __/17
- Target: 17/17 (100%)
- Grade after fixes: __/100

---

## ⚠️ CRITICAL: LOG VERIFICATION MANDATORY

**BEFORE MARKING ANY FIX COMPLETE:**

```bash
# 1. Check ALL container logs for errors
docker logs <container> 2>&1 | grep -iE "error|fatal|panic|warn|fail" | tail -50

# 2. Check system logs
sudo dmesg -T | grep -iE "error|oom|killed" | tail -30
sudo journalctl -u docker.service --since "1 hour ago" | grep -iE "error|fatal"

# 3. Verify no active errors in error summary
find /tmp -name "*ERRORS*" -mtime -1 -exec wc -l {} \;

# 4. Check Docker container health
docker ps -a | grep -v "Up.*healthy"
```

**NO VERIFICATION WITHOUT CLEAN LOGS**
- Every "error" line must be investigated
- Every "warn" line must be documented
- Every "fatal" or "panic" = FAILED fix
- Document all findings in P0_FIXES_REPORT.md

---

## SUCCESS CRITERIA

**MUST achieve:** 17/17 services working (100%)

**Test ALL services:**
```bash
# Master (11 services)
curl -sk https://ntfy.quietly.its.me -w "%{http_code}\n"
curl -sk https://pihole.quietly.its.me/admin/ -w "%{http_code}\n"
curl -sk https://grafana.quietly.its.me -w "%{http_code}\n"
curl -sk http://100.64.0.1:9090/-/healthy  # Prometheus
curl -sk http://100.64.0.1:9093/-/healthy  # Alertmanager
# ... all Master services

# Lady (6 services)
curl -sk https://nextcloud.quietly.online -w "%{http_code}\n"
curl -sk https://mail.quietly.online -w "%{http_code}\n"
curl -sk https://odoo.quietly.online -w "%{http_code}\n"
# ... all Lady services
```

---

## AFTER COMPLETION

**Ask user:** "Phase 02 complete. All P0 issues fixed. 17/17 services working (100%). Good? (Y/N)"

**If approved:** User sends you PHASE-03-GOVERNANCE folder

---

## WHY THIS MATTERS

Cannot do governance (secrets, versions) on broken services. Must have 100% working baseline FIRST.

**Fix everything → THEN governance → THEN improvements**

---

**Start with Prometheus. Report back after each fix.**
