# 🎯 PHASE-01 EXECUTION BRIEF
**For External Agent**  
**Week**: 1 (2026-02-03 to 2026-02-09)  
**Duration**: 10-15 hours  
**Target**: 87/100 → 90/100

---

## 📊 CURRENT STATE (You Start Here)

**Infrastructure Status**:
- ✅ 56 containers running (24 Master + 32 Lady)
- ✅ Servers stable (2% disk Master, 3% Lady)
- ✅ Monitoring operational (Prometheus/Grafana/Loki)
- ⚠️ Grade: **B+ (87/100)**

**Critical Gaps to Fix This Week**:
1. ❌ Security issues (file permissions, systemd failures)
2. ❌ Office suite missing (no document editing)
3. ❌ Service inventory incomplete (drift in docs)
4. ❌ Documentation low (10.7% coverage)
5. ❌ HTTP routing errors (502/404 on some endpoints)

**Phase 1 Audit Results**: `.reports/audits/project/20260129-154914/`

---

## 🎯 YOUR MISSION (Week 1)

Fix the 5 critical gaps above. After completion:
- ✅ Security score: A+ (15/15)
- ✅ Office productivity operational
- ✅ Service inventory accurate
- ✅ Documentation: 17.9%
- ✅ All endpoints working
- ✅ **Grade: 90/100 (B++)**

---

## 📋 EXECUTION CHECKLIST

### Task 1: Security Hardening (2-3h) 🔴
**Priority**: Execute FIRST

```bash
# 1.1 Fix file permissions (all secrets → 600)
find ~ -type f \( -name "*.key" -o -name "*.pem" -o -name "*.secret" -o -name "*.env" -o -name "*secret*" -o -name "*token*" \) ! -path "./.cache/*" ! -path "./.local/*" -exec chmod 600 {} \;

# Verify (should return nothing)
find ~ -type f \( -name "*.key" -o -name "*.pem" -o -name "*.secret" -o -name "*.env" \) ! -perm 600 -ls

# 1.2 Fix systemd failures
# Master: Disable PCP services
sudo systemctl disable pmcd pmie pmlogger pmproxy
sudo systemctl stop pmcd pmie pmlogger pmproxy
sudo systemctl mask pmcd pmie pmlogger pmproxy

# Verify
systemctl list-units --state=failed  # Should show 0 failed

# Lady: Fix networkd-wait-online
ssh lady "sudo systemctl disable systemd-networkd-wait-online"
ssh lady "sudo systemctl mask systemd-networkd-wait-online"
ssh lady "systemctl list-units --state=failed"  # Should show 0 failed

# 1.3 Document cAdvisor privilege (decision: keep privileged for metrics)
# See detailed commands in main README.md
```

**Success Criteria**:
- [ ] All secrets have 600 permissions
- [ ] Zero systemd failed units (both servers)
- [ ] cAdvisor privilege documented

---

### Task 2: Nextcloud + OnlyOffice (4-6h) 🔴
**Priority**: Execute SECOND (unlocks office productivity)

**Architecture Decision**: Deploy OnlyOffice on **Lady** (same server as Nextcloud)

```bash
# 2.1 SSH to Lady
ssh lady

# 2.2 Finalize Nextcloud config
docker exec -u www-data nextcloud php occ config:system:set trusted_domains 1 --value=nextcloud.quietly.online
docker exec -u www-data nextcloud php occ config:system:set overwrite.cli.url --value=https://nextcloud.quietly.online
docker exec -u www-data nextcloud php occ config:system:set overwriteprotocol --value=https

# Enable recommended apps
docker exec -u www-data nextcloud php occ app:enable files_external
docker exec -u www-data nextcloud php occ app:enable files_sharing
docker exec -u www-data nextcloud php occ app:enable activity
docker exec -u www-data nextcloud php occ app:enable notifications

# Run maintenance
docker exec -u www-data nextcloud php occ maintenance:mode --on
docker exec -u www-data nextcloud php occ db:add-missing-indices
docker exec -u www-data nextcloud php occ db:convert-filecache-bigint
docker exec -u www-data nextcloud php occ maintenance:mode --off

# 2.3 Add OnlyOffice to Nextcloud docker-compose
cd ~/.docker-compose/nextcloud/
cp docker-compose.yaml docker-compose.yaml.backup

# Add OnlyOffice service (see detailed config in main README.md Task 2.3)
# Key points:
# - image: onlyoffice/documentserver:8.2.0
# - JWT authentication enabled
# - Traefik labels for office.quietly.online
# - Network: nextcloud-internal + traefik

# Generate JWT secret
ONLYOFFICE_JWT_SECRET=$(openssl rand -base64 48)
echo "ONLYOFFICE_JWT_SECRET=$ONLYOFFICE_JWT_SECRET" >> .env

# Start OnlyOffice
docker compose up -d onlyoffice-documentserver

# Wait and verify
sleep 30
docker ps | grep onlyoffice

# 2.4 Install OnlyOffice app in Nextcloud
docker exec -u www-data nextcloud php occ app:install onlyoffice

# Configure integration
docker exec -u www-data nextcloud php occ config:app:set onlyoffice DocumentServerUrl --value="https://office.quietly.online/"
docker exec -u www-data nextcloud php occ config:app:set onlyoffice jwt_secret --value="$ONLYOFFICE_JWT_SECRET"
docker exec -u www-data nextcloud php occ config:app:set onlyoffice jwt_header --value="Authorization"

# Test integration
docker exec -u www-data nextcloud php occ onlyoffice:documentserver --check
```

**Success Criteria**:
- [ ] OnlyOffice container running on Lady
- [ ] Integration test passes
- [ ] Can create document in Nextcloud web UI
- [ ] OnlyOffice editor opens and works
- [ ] https://office.quietly.online returns 200

---

### Task 3: Service Inventory (2-3h) 🔴
**Priority**: Execute THIRD (foundation for docs)

```bash
# Create inventory
mkdir -p ~/.reports/inventory/$(date +%Y%m%d)
cd ~/.reports/inventory/$(date +%Y%m%d)

# Capture live state
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}' > master-containers.txt
ssh lady "docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}'" > lady-containers.txt

# Create SERVICE_INVENTORY.md
# Full template available in PHASE-00/01_CRITICAL_IMMEDIATE_ACTIONS.md Section 2
# Must document all 56 containers categorized by function
```

**Success Criteria**:
- [ ] Complete 56-service inventory created
- [ ] Categorized by function (Monitoring, Security, Mail, etc.)
- [ ] Live verification commands included
- [ ] Saved in ~/.reports/inventory/YYYYMMDD/SERVICE_INVENTORY.md

---

### Task 4: Critical Service Docs (4-6h) 🔴
**Priority**: Execute FOURTH

Create these 4 service documentation files in `~/.docs/03-services/`:

1. **AUTHELIA.md** (SSO - most critical)
2. **PORTAINER.md** (Container management)
3. **SEMAPHORE.md** (Ansible automation)
4. **NEXTCLOUD.md** (Cloud + Office - updated with OnlyOffice)

**Templates**: See PHASE-00/01_CRITICAL_IMMEDIATE_ACTIONS.md Section 3 for complete templates.

**Success Criteria**:
- [ ] 4 service docs created with standardized format
- [ ] Each includes: Purpose, Configuration, Verification commands
- [ ] Last verified timestamps added
- [ ] Documentation coverage: 10/56 = 17.9%

---

### Task 5: HTTP Routing Fixes (30-60min) 🔴
**Priority**: Execute FIFTH

**Issues to fix**:
- `cloud.quietly.online` → 502 Bad Gateway
- `nextcloud.quietly.online` → 404 Not Found

```bash
# Check Traefik logs on Lady
ssh lady "docker logs traefik --tail 100 | grep nextcloud"

# Verify Traefik labels on Nextcloud container
ssh lady "docker inspect nextcloud | jq '.[0].Config.Labels'"

# Expected labels:
# - traefik.http.routers.nextcloud.rule=Host(`nextcloud.quietly.online`)
# - traefik.http.services.nextcloud.loadbalancer.server.port=80

# Fix if incorrect (edit docker-compose.yaml and restart)

# Test
curl -I https://nextcloud.quietly.online  # Should return 200
curl -I https://cloud.quietly.online      # Should return 200
```

**Success Criteria**:
- [ ] Both endpoints return 200
- [ ] Root cause documented
- [ ] Fix verified and stable

---

## ✅ FINAL VERIFICATION

After completing all 5 tasks:

```bash
# Security check
find ~ -type f \( -name "*.key" -o -name "*.env" \) ! -perm 600 | wc -l  # Should be 0
systemctl list-units --state=failed | grep failed  # Should be 0
ssh lady "systemctl list-units --state=failed | grep failed"  # Should be 0

# OnlyOffice check
ssh lady "docker ps | grep onlyoffice"  # Should be running
ssh lady "docker exec -u www-data nextcloud php occ onlyoffice:documentserver --check"  # Should pass
curl -I https://office.quietly.online/healthcheck  # Should return 200

# Inventory check
ls -lh ~/.reports/inventory/$(date +%Y%m%d)/SERVICE_INVENTORY.md  # Should exist

# Documentation check
ls ~/.docs/03-services/ | grep -E "AUTHELIA|PORTAINER|SEMAPHORE|NEXTCLOUD" | wc -l  # Should be 4

# HTTP routing check
curl -I https://nextcloud.quietly.online | head -1  # Should be 200
curl -I https://cloud.quietly.online | head -1     # Should be 200
```

**Expected Results**:
- ✅ Security score: A+ (15/15)
- ✅ Office productivity operational
- ✅ Service inventory accurate (56 containers)
- ✅ Documentation: 17.9% (10/56)
- ✅ All HTTP endpoints working
- ✅ **Grade: 90/100 (B++)**

---

## 📝 REPORTING

After completion, create: `~/.reports/phase-01/COMPLETION_REPORT.md`

Include:
1. Tasks completed (5/5)
2. Time spent per task
3. Issues encountered and solutions
4. Verification results (all checks passed)
5. Grade improvement: 87/100 → 90/100
6. Recommendations for PHASE-02

---

## 🚨 IF YOU GET STUCK

**Detailed documentation available in**:
- Main plan: `~/projects/preproduction/PHASE-01/README.md` (570 lines, complete commands)
- Templates: `~/projects/preproduction/PHASE-00/01_CRITICAL_IMMEDIATE_ACTIONS.md` (770 lines)

**Key decisions made**:
- ✅ OnlyOffice on Lady (not Master) - better architecture
- ✅ Security first (protect what we have)
- ✅ JWT authentication enabled for OnlyOffice
- ✅ PCP services disabled (using Prometheus instead)

**Servers**:
- Master: 213.136.68.108
- Lady: 207.180.251.111

---

## 🎯 YOU ARE READY

Everything you need is in this brief:
- ✅ Current state understood
- ✅ Clear objectives defined
- ✅ 5 tasks with exact commands
- ✅ Success criteria per task
- ✅ Final verification checklist
- ✅ Reporting template

**No need to read PHASE-00** unless you want additional context or alternative approaches.

**Start with**: Task 1 (Security Hardening)  
**End with**: Completion report showing 90/100 grade

**Questions?** Refer to main `README.md` in PHASE-01 folder for complete details.

---

**Ready to execute!** 🚀
