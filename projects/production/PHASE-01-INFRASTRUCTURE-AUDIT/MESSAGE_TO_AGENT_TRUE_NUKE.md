# MESSAGE TO EXTERNAL AGENT: TRUE NUKE INVESTIGATION REQUIRED

**Priority:** 🔴 **CRITICAL**  
**Type:** Nuclear Option - Complete Infrastructure Rebuild  
**Status:** ⏳ **INVESTIGATION PHASE - NO EXECUTION YET**

---

## YOUR MISSION

Investigate the "TRUE NUKE" option - a complete wipe and rebuild of the entire Docker infrastructure from GitHub.

**This is NOT a normal nuke:**
- ❌ NOT `docker system prune -a` (that's baby nuke)
- ✅ DELETE EVERYTHING except ~/.secrets/
- ✅ Rebuild from git repos

**Risk:** 🔴 **PERMANENT DATA LOSS** - Nextcloud files, emails, metrics, logs, databases - ALL DELETED

---

## WHAT YOU MUST DO

### 1. READ THE INVESTIGATION REPORT

**File:** [TRUE_NUKE_INVESTIGATION_REPORT.md](TRUE_NUKE_INVESTIGATION_REPORT.md)

This 546-line report contains EVERYTHING you need to know:
- What TRUE NUKE means
- What gets deleted (with data loss analysis)
- What survives (secrets only)
- Complete execution sequence
- All risks and consequences
- Investigation tasks you must complete

**READ IT COMPLETELY. DO NOT SKIP SECTIONS.**

---

### 2. COMPLETE MANDATORY INVESTIGATIONS

Before even THINKING about executing TRUE NUKE, you MUST complete these investigations:

#### Investigation 1: Git Completeness Check ✓
```bash
# Verify ALL configs are committed to git
cd ~
git status --short  # MUST be empty (except .gitignore changes)

# Check if anything important is uncommitted
find ~/.docker -name "*.yml" -o -name "*.yaml" -o -name "*.conf" | while read f; do
  git ls-files --error-unmatch "$f" 2>/dev/null || echo "❌ NOT IN GIT: $f"
done

find ~/.docker-compose -name "docker-compose.y*ml" | while read f; do
  git ls-files --error-unmatch "$f" 2>/dev/null || echo "❌ NOT IN GIT: $f"
done
```

**Deliverable:** List of files NOT in git (if any)

#### Investigation 2: Volume Inventory ✓
```bash
# Document EVERY volume
docker volume ls --format "{{.Name}}" > volume-list.txt

# For each volume, determine:
cat > volume-inventory.md << 'EOF'
# Docker Volume Inventory

| Volume Name | Service | Can Recreate? | Data Loss Impact | Backup Required? |
|-------------|---------|---------------|------------------|------------------|
| prometheus_data | Prometheus | No | 30 days metrics lost | YES |
| grafana_data | Grafana | No | Dashboards lost | YES |
| nextcloud_data | Nextcloud | No | USER FILES LOST | YES - CRITICAL |
| ... (continue for all 17+ volumes)
EOF
```

**Deliverable:** Complete volume-inventory.md with ALL volumes rated

#### Investigation 3: Critical Data Backup ✓
```bash
# Master - Backup critical volumes
docker run --rm -v prometheus_data:/data -v ~/backups:/backup alpine \
  tar czf /backup/prometheus_data_$(date +%F_%H%M).tar.gz -C /data .

docker run --rm -v grafana_data:/data -v ~/backups:/backup alpine \
  tar czf /backup/grafana_data_$(date +%F_%H%M).tar.gz -C /data .

docker run --rm -v portainer_data:/data -v ~/backups:/backup alpine \
  tar czf /backup/portainer_data_$(date +%F_%H%M).tar.gz -C /data .

# Lady - Backup CRITICAL volumes
ssh lady "docker run --rm -v nextcloud_data:/data -v ~/backups:/backup alpine \
  tar czf /backup/nextcloud_data_\$(date +%F_%H%M).tar.gz -C /data ."

ssh lady "docker run --rm -v nextcloud-db_data:/data -v ~/backups:/backup alpine \
  tar czf /backup/nextcloud-db_\$(date +%F_%H%M).tar.gz -C /data ."

# List all Mailcow volumes and backup EACH ONE
ssh lady "docker volume ls --filter name=mailcow -q"
# Backup ALL of them!

# Verify backups exist and have size > 0
ls -lh ~/backups/*.tar.gz | tail -20
ssh lady "ls -lh ~/backups/*.tar.gz | tail -20"
```

**Deliverable:** Confirmed backup files with sizes

#### Investigation 4: Test Restore Process ✓
```bash
# Pick ONE volume, verify backup/restore works
TEST_VOLUME="test_restore_$(date +%s)"

# Create test data
docker volume create $TEST_VOLUME
docker run --rm -v $TEST_VOLUME:/data alpine sh -c "echo 'test data' > /data/test.txt && cat /data/test.txt"

# Backup
docker run --rm -v $TEST_VOLUME:/data -v ~/backups:/backup alpine \
  tar czf /backup/test_volume.tar.gz -C /data .

# Delete original
docker volume rm $TEST_VOLUME

# Restore
docker volume create ${TEST_VOLUME}_restored
docker run --rm -v ${TEST_VOLUME}_restored:/data -v ~/backups:/backup alpine \
  tar xzf /backup/test_volume.tar.gz -C /data

# Verify
docker run --rm -v ${TEST_VOLUME}_restored:/data alpine cat /data/test.txt
# Should output: "test data"

# Cleanup
docker volume rm ${TEST_VOLUME}_restored
rm ~/backups/test_volume.tar.gz
```

**Deliverable:** Proof that restore works (screenshot or command output)

#### Investigation 5: Uncommitted Changes Check ✓
```bash
# Master
cd ~
git status --short > uncommitted-master.txt
git diff >> uncommitted-master.txt

# Lady
ssh lady "cd ~ && git status --short > uncommitted-lady.txt && git diff >> uncommitted-lady.txt"
scp lady:~/uncommitted-lady.txt ~/backups/

# Review both files
cat uncommitted-master.txt
cat ~/backups/uncommitted-lady.txt

# If ANY files uncommitted - MUST COMMIT BEFORE NUKE
```

**Deliverable:** List of uncommitted changes (commit them or accept loss)

#### Investigation 6: Service Dependency Map ✓
```bash
# Document rebuild order (which services depend on which)
cat > rebuild-order.md << 'EOF'
# Service Rebuild Order

## Master
1. Networks (traefik, monitoring)
2. Traefik (reverse proxy - MUST BE FIRST)
3. Crowdsec (security)
4. Pihole (DNS)
5. Authelia (auth)
6. Monitoring Stack:
   - Prometheus
   - Alertmanager
   - Loki
   - Promtail
7. Grafana (depends on Prometheus + Loki)
8. Exporters (node-exporter, cadvisor)
9. Management (Portainer)
10. Services (uptime-kuma, gotify, ntfy, semaphore, it-tools)
11. Infrastructure (headscale, admin-panel)
12. Static pages (landing, fuckoff-page)

## Lady
1. Networks (traefik, monitoring)
2. Traefik (MUST BE FIRST)
3. Crowdsec
4. Mailcow (29 containers - starts its own stack)
5. Databases:
   - nextcloud-db
   - nextcloud-redis
   - odoo-db
6. Applications:
   - Nextcloud
   - Odoo
   - HomeAssistant
   - Frigate
7. Monitoring (node-exporter, cadvisor, promtail)
EOF
```

**Deliverable:** Complete rebuild order with dependencies noted

#### Investigation 7: Rollback Plan ✓
```bash
# Create detailed rollback plan
cat > TRUE_NUKE_ROLLBACK_PLAN.md << 'EOF'
# TRUE NUKE ROLLBACK PLAN

## If Nuke Fails Mid-Execution

### Scenario 1: Failed After Deletion, Before Git Pull
**Problem:** Everything deleted, git pull fails (network issue, GitHub down)

**Recovery:**
1. Wait for GitHub to come back online
2. Reclone repos:
   ```bash
   cd ~
   git clone https://github.com/quietly007/master.git master-temp
   mv master-temp/.git ~/.git
   git reset --hard HEAD
   ```
3. Continue with rebuild

**Estimated Time:** 15-30 minutes

### Scenario 2: Failed During Compose Up
**Problem:** Some containers won't start (image pull fails, config errors)

**Recovery:**
1. Check logs: `docker logs <container>`
2. Fix compose file errors
3. Retry: `docker compose up -d`
4. If image unavailable, use backup images or alternate versions

**Estimated Time:** 30-60 minutes per broken service

### Scenario 3: Data Lost, Services Running But Empty
**Problem:** Nuke completed but forgot to backup critical data

**Recovery:**
1. Stop services immediately
2. Restore from backup tarballs:
   ```bash
   docker compose down
   docker run --rm -v <volume>:/data -v ~/backups:/backup alpine \
     tar xzf /backup/<volume>_<date>.tar.gz -C /data
   docker compose up -d
   ```
3. Verify data restored

**Estimated Time:** 10-15 minutes per volume

### Scenario 4: Complete Failure
**Problem:** Cannot recover any services

**Recovery:**
1. Provision new servers from scratch
2. Use Ansible playbooks from ~/.github/ansible/
3. Restore data from backups
4. Migrate DNS

**Estimated Time:** 4-8 hours
EOF
```

**Deliverable:** Approved rollback plan

---

### 3. CREATE INVESTIGATION COMPLETE REPORT

**File to create:** `TRUE_NUKE_INVESTIGATION_COMPLETE.md`

Must include:

```markdown
# TRUE NUKE INVESTIGATION - COMPLETE

**Date:** YYYY-MM-DD HH:MM UTC  
**Agent:** Your Name  
**Status:** Investigation Complete

---

## INVESTIGATION RESULTS

### 1. Git Completeness ✓
- [ ] All configs in git (list any missing)
- [ ] No uncommitted changes (or list them)
- [ ] Verified Master repo clean
- [ ] Verified Lady repo clean

**Result:** PASS / FAIL

### 2. Volume Inventory ✓
- [ ] All volumes documented (see volume-inventory.md)
- [ ] Critical volumes identified
- [ ] Backup requirements defined

**Total Volumes:**
- Master: XX volumes
- Lady: XX volumes
- Critical: XX volumes

**Result:** PASS / FAIL

### 3. Backup Strategy ✓
- [ ] Backup script created
- [ ] All critical volumes backed up
- [ ] Backup sizes verified (not empty)
- [ ] Restore process tested

**Backup Size:** XXX GB total

**Result:** PASS / FAIL

### 4. Rebuild Order ✓
- [ ] Service dependencies mapped
- [ ] Rebuild sequence documented
- [ ] Estimated time per service

**Total Rebuild Time:** XX minutes

**Result:** PASS / FAIL

### 5. Rollback Plan ✓
- [ ] Failure scenarios documented
- [ ] Recovery procedures written
- [ ] Backup restoration tested
- [ ] Emergency contacts identified

**Result:** PASS / FAIL

### 6. Risk Assessment ✓

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Data loss | Medium | Critical | Backups created |
| Failed rebuild | Low | High | Rollback plan ready |
| Extended downtime | Medium | Medium | Estimated 60 min |
| GitHub unavailable | Low | Critical | Local git cache |

---

## DATA LOSS ANALYSIS

**Will be permanently deleted:**
- XX GB Prometheus metrics (30 days)
- XX dashboards in Grafana
- XX GB logs in Loki
- XX user files in Nextcloud
- XX emails in Mailcow

**Can be recreated:**
- Container configs (from git)
- Docker images (from Docker Hub)
- Empty databases (re-initialize)

**Cannot be recreated without backup:**
- User data files
- Email archives
- Historical metrics
- Custom dashboards

---

## GO / NO-GO RECOMMENDATION

**My Recommendation:** GO / NO-GO / NEEDS MORE INFO

**Reasoning:**
[Explain your recommendation based on investigation findings]

**Required User Confirmation:**
User must type EXACTLY: "YES, I UNDERSTAND DATA LOSS AND APPROVE TRUE NUKE"

---

**Prepared By:** [Your Name]  
**Date:** [Date]  
**Reviewed By:** [User must review this report]
```

---

### 4. GET USER APPROVAL

**BEFORE EXECUTING TRUE NUKE:**

Show user:
1. Your investigation complete report
2. Data loss analysis (in GB)
3. Estimated downtime (in minutes)
4. Risk assessment

**Ask user to type EXACTLY:**
```
YES, I UNDERSTAND DATA LOSS AND APPROVE TRUE NUKE
```

**If user types anything else → DO NOT NUKE**

---

## EXECUTION PROCEDURE (ONLY AFTER APPROVAL)

**Follow TRUE_NUKE_INVESTIGATION_REPORT.md section "TRUE NUKE EXECUTION SEQUENCE"**

**7 Phases:**
1. Pre-nuke validation (verify backups, VPN, git clean)
2. Nuclear deletion - Master (containers, volumes, images, configs)
3. Nuclear deletion - Lady (containers, volumes, images, configs)
4. Rebuild from GitHub - Master (git pull + compose up all services)
5. Rebuild from GitHub - Lady (git pull + compose up all services)
6. Post-nuke verification (test all services)
7. Data restoration (restore from backups if needed)

**Estimated Total Time:** 1-2 hours

---

## WHAT CAN GO WRONG

### Critical Failures:
1. **GitHub unavailable** during rebuild
   - Impact: Cannot restore configs
   - Mitigation: Use local git cache

2. **Docker Hub rate limit** during image pulls
   - Impact: Cannot start containers
   - Mitigation: Wait or use mirror

3. **VPN drops** during Lady rebuild
   - Impact: Cannot SSH to Lady
   - Mitigation: Physical access or IPMI

4. **Backup corrupted**
   - Impact: Data unrecoverable
   - Mitigation: Test backups BEFORE nuke

5. **Forgot to backup critical volume**
   - Impact: PERMANENT DATA LOSS
   - Mitigation: Double-check backup list

---

## SUMMARY

**TRUE NUKE = Nuclear Option**

- Deletes EVERYTHING (except secrets)
- Rebuilds from GitHub
- 1-2 hour downtime
- Risk of permanent data loss
- Requires extensive investigation
- Must have backups
- Must test restore
- Must have rollback plan

**DO NOT EXECUTE WITHOUT:**
1. ✅ Complete investigation
2. ✅ All backups created and verified
3. ✅ Restore process tested
4. ✅ User approval with exact phrase
5. ✅ VPN active and stable
6. ✅ Rollback plan ready

---

**Current Status:** ⏳ **INVESTIGATION PHASE**

**Next Action:** Complete all 7 investigation tasks

**Report Location:** [TRUE_NUKE_INVESTIGATION_REPORT.md](TRUE_NUKE_INVESTIGATION_REPORT.md)

---

**Prepared For:** External Agent  
**Prepared By:** GitHub Copilot  
**Date:** 2026-02-10 06:00 UTC

🔴 **THIS IS NOT A DRILL - TRUE NUKE IS DESTRUCTIVE**
