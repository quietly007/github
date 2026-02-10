# MESSAGE TO EXTERNAL AGENT: NUKE PASS DENIED

**Status:** ❌ **NUKE PASS DENIED**

**Reason:** Wrong sequence. Cannot validate nuke/rebuild when baseline is broken.

---

## THE PROBLEM:

You documented current state:
- 11/17 services working (65%)
- Prometheus: DOWN
- Alertmanager: TIMEOUT
- Nextcloud/Odoo: DB issues
- 3 services: Routing issues

**Your plan:** Nuke broken system → Rebuild → Test

**The flaw:** If issues remain after rebuild, we won't know if it's:
- Old issues that weren't fixed? OR
- New issues from rebuild?

---

## CORRECT SEQUENCE:

### Phase 02 (REVISED): Fix All P0 Issues FIRST

**Tasks:**
1. Restart Prometheus → Verify UP and accessible
2. Fix Alertmanager timeout → Verify responds
3. Fix Nextcloud DB connection → Verify login works
4. Fix Odoo DB issues → Verify accessible
5. Fix 3 routing issues → Verify all URLs work

**Success criteria:** 17/17 services working (100%)

### Then Phase 02.5: Safe Nuke Test

**ONLY AFTER 100% working:**
1. Document all services working (new baseline)
2. Run safe nuke: `docker system prune -a --force`
3. Rebuild all services
4. Verify return to 100% working state
5. If yes → Nuke pass granted
6. If no → Identify rebuild issues, fix, repeat

---

## NEW INSTRUCTIONS:

**Stop nuke preparation.**

**New task:** Fix all P0 issues from AUDIT_REPORT.md:

1. **Prometheus DOWN:**
```bash
cd ~/.docker-compose/prometheus
docker compose down
docker compose up -d
docker logs prometheus
# Verify: curl http://localhost:9090/-/healthy
```

2. **Alertmanager timeout:**
```bash
cd ~/.docker-compose/alertmanager
docker compose restart
docker logs alertmanager
# Verify: curl http://localhost:9093/-/healthy
```

3. **Nextcloud broken (109 errors):**
```bash
ssh lady
cd ~/.docker-compose/nextcloud
docker logs nextcloud --tail 50
docker exec nextcloud-db mariadb -u nextcloud -p -e "SHOW DATABASES;"
# Fix database connection, reinstall if needed
```

4. **Fix routing issues** (3 services)
   - Identify which services
   - Check Traefik config
   - Verify DNS/routing

---

## DELIVERABLE:

**Create:** `P0_FIXES_REPORT.md`

Document for each issue:
- Problem identified
- Commands executed
- Result (FIXED / STILL BROKEN)
- Verification (curl test, login test)

**Target:** 17/17 services working (100%)

**Then ask:** "All P0 issues fixed. 17/17 services working. Ready for safe nuke test? (Y/N)"

---

## SUMMARY:

❌ **Nuke denied** - Baseline is broken  
✅ **New task** - Fix all P0 issues first  
✅ **Then** - Safe nuke test with 100% working baseline  

**Start with Prometheus. Report back when fixed.**
