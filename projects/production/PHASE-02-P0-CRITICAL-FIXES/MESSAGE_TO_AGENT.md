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
```bash
cd ~/.docker-compose/prometheus
docker compose down
docker compose up -d
docker logs prometheus --tail 50
curl http://localhost:9090/-/healthy
```
**Success:** Returns "Prometheus Server is Healthy"

### 2. Alertmanager (Timeout)
```bash
cd ~/.docker-compose/alertmanager
docker compose restart
docker logs alertmanager --tail 50
curl http://localhost:9093/-/healthy
```
**Success:** Returns healthy status, no timeout

### 3. Nextcloud (109 errors - Not installed)
```bash
ssh lady
cd ~/.docker-compose/nextcloud
docker logs nextcloud --tail 100
docker exec nextcloud-db mariadb -u nextcloud -p -e "SHOW DATABASES;"
# Fix database connection or reinstall
curl -sk https://nextcloud.quietly.online -o /dev/null -w "%{http_code}\n"
```
**Success:** Returns 200, login page works

### 4. Redis (Connection errors to 172.28.1.249:6379)
```bash
ssh lady
docker logs nextcloud-redis
docker exec nextcloud-redis redis-cli ping
# Check if redis accessible from nextcloud container
docker exec nextcloud ping -c 3 172.28.1.249
```
**Success:** Redis responds, Nextcloud connects

### 5. Routing Issues (3 services from your baseline)
- Identify which 3 services have routing problems
- Check Traefik config
- Fix routing/DNS

**Success:** All 3 services return correct HTTP codes

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
