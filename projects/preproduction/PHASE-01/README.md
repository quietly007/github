# PHASE-01: Critical Infrastructure Fixes
**Week**: 1 (2026-02-03 to 2026-02-09)  
**Duration**: 10-15 hours  
**Current Grade**: 87/100 (B+)  
**Target Grade**: 90/100 (B++)

---

## 🎯 PHASE OBJECTIVES

This is the foundation week. We address the most critical gaps that are blocking A-grade achievement:

1. **Security hardening** - Fix file permissions, systemd failures, privilege issues
2. **Nextcloud finalization** - Complete setup, add OnlyOffice integration
3. **Service inventory** - Create canonical 56-service documentation
4. **Critical documentation** - Document 4 most important services
5. **HTTP routing fixes** - Resolve 502/404 errors

**Why This Order**:
- Security first (protect what we have)
- Then productivity (Nextcloud + OnlyOffice)
- Then foundation (inventory + docs)
- Enables all future work

---

## 📋 TASKS BREAKDOWN

### Task 1: Security Hardening 🔴
**Priority**: CRITICAL  
**Duration**: 2-3 hours  
**Impact**: +2 points (security score improvement)

#### 1.1 File Permissions Audit & Fix
**Why**: Secrets exposed with wrong permissions = security vulnerability

```bash
# Find all secret files and fix permissions
cd ~

# Check current permissions
find . -type f \( -name "*.key" -o -name "*.pem" -o -name "*.secret" -o -name "*.env" -o -name "*secret*" -o -name "*token*" -o -name "*password*" \) ! -path "./.cache/*" ! -path "./.local/*" -ls > /tmp/secrets-audit.txt

# Review findings
cat /tmp/secrets-audit.txt

# Fix permissions (must be 600)
find . -type f \( -name "*.key" -o -name "*.pem" -o -name "*.secret" -o -name "*.env" -o -name "*secret*" -o -name "*token*" -o -name "*password*" \) ! -path "./.cache/*" ! -path "./.local/*" -exec chmod 600 {} \;

# Verify
find . -type f \( -name "*.key" -o -name "*.pem" -o -name "*.secret" -o -name "*.env" -o -name "*secret*" -o -name "*token*" -o -name "*password*" \) ! -path "./.cache/*" ! -path "./.local/*" ! -perm 600 -ls

# Should return nothing

# Document
cat > ~/.docs/01-infrastructure/SECURITY_FILE_PERMISSIONS.md << 'EOF'
# Security File Permissions Policy

**Policy**: All secrets MUST have 600 permissions (owner read/write only)

## Last Audit: $(date +%Y-%m-%d)

### Verified Files:
- SSH keys (*.key, *.pem)
- Environment files (*.env)
- Secret files (*secret*, *token*, *password*)

### Verification Command:
```bash
find ~ -type f \( -name "*.key" -o -name "*.pem" -o -name "*.secret" -o -name "*.env" \) ! -perm 600
# Should return nothing
```

### Monthly Check:
Add to cron or Semaphore for automated monthly verification.
EOF
```

#### 1.2 Systemd Failures Resolution
**Why**: Clean system state, remove noise from monitoring

```bash
# MASTER: Disable unused PCP services
sudo systemctl disable pmcd pmie pmlogger pmproxy
sudo systemctl stop pmcd pmie pmlogger pmproxy
sudo systemctl mask pmcd pmie pmlogger pmproxy

# Verify
systemctl list-units --state=failed
# Should show no failed units

# LADY: Fix networkd-wait-online
ssh lady "sudo systemctl disable systemd-networkd-wait-online"
ssh lady "sudo systemctl mask systemd-networkd-wait-online"

# Verify
ssh lady "systemctl list-units --state=failed"
# Should show no failed units

# Document
cat >> ~/.docs/01-infrastructure/SYSTEMD_SERVICES.md << 'EOF'

## Disabled Services ($(date +%Y-%m-%d))

### Master:
- **PCP stack** (pmcd, pmie, pmlogger, pmproxy)
  - Reason: Using Prometheus/Grafana instead
  - Status: Disabled and masked

### Lady:
- **systemd-networkd-wait-online**
  - Reason: Static network config, causes boot delays
  - Status: Disabled and masked

### Verification:
```bash
systemctl list-units --state=failed
ssh lady "systemctl list-units --state=failed"
# Both should return 0 failed units
```
EOF
```

#### 1.3 cAdvisor Privilege Review
**Why**: Security audit flagged privileged mode

```bash
# Check current cAdvisor config
docker inspect cadvisor | jq '.[0].HostConfig.Privileged'

# Review docker-compose.yaml
cd ~/.docker-compose/monitoring/
cat docker-compose.yaml | grep -A5 cadvisor

# Decision: Keep privileged for now (needed for full metrics)
# Document the decision
cat > ~/.docs/03-services/CADVISOR_PRIVILEGES.md << 'EOF'
# cAdvisor Privileged Mode

**Status**: Privileged mode ENABLED  
**Reason**: Required for complete container metrics collection

## Why Privileged:
- Access to cgroups
- Network statistics
- Disk I/O metrics
- Memory details

## Mitigation:
- Runs on internal network only
- No public exposure
- Behind Traefik + Authelia
- Monitored by CrowdSec

## Alternative:
Consider node-exporter + docker-socket-proxy for future revision.

**Last Reviewed**: $(date +%Y-%m-%d)
EOF
```

**Deliverable**:
- ✅ All secrets at 600 permissions
- ✅ Zero systemd failed units
- ✅ cAdvisor privilege documented
- ✅ Security policies documented

---

### Task 2: Nextcloud Finalization + OnlyOffice Integration 🔴
**Priority**: CRITICAL  
**Duration**: 4-6 hours  
**Impact**: +3 points (office suite deployed)

#### 2.1 Verify Nextcloud Current State
```bash
# Check Nextcloud containers on Lady
ssh lady "docker ps | grep nextcloud"

# Check Nextcloud status
ssh lady "docker exec -u www-data nextcloud php occ status"

# Check installed apps
ssh lady "docker exec -u www-data nextcloud php occ app:list"

# Check configuration
ssh lady "docker exec -u www-data nextcloud php occ config:list system"
```

#### 2.2 Finalize Nextcloud Setup
```bash
# SSH to Lady
ssh lady

# Set proper configuration
docker exec -u www-data nextcloud php occ config:system:set trusted_domains 1 --value=nextcloud.quietly.online
docker exec -u www-data nextcloud php occ config:system:set overwrite.cli.url --value=https://nextcloud.quietly.online
docker exec -u www-data nextcloud php occ config:system:set overwriteprotocol --value=https

# Enable recommended apps
docker exec -u www-data nextcloud php occ app:enable files_external
docker exec -u www-data nextcloud php occ app:enable files_sharing
docker exec -u www-data nextcloud php occ app:enable files_versions
docker exec -u www-data nextcloud php occ app:enable files_trashbin
docker exec -u www-data nextcloud php occ app:enable activity
docker exec -u www-data nextcloud php occ app:enable notifications

# Run maintenance
docker exec -u www-data nextcloud php occ maintenance:mode --on
docker exec -u www-data nextcloud php occ db:add-missing-indices
docker exec -u www-data nextcloud php occ db:convert-filecache-bigint
docker exec -u www-data nextcloud php occ maintenance:mode --off

# Background jobs
docker exec -u www-data nextcloud php occ background:cron
```

#### 2.3 Deploy OnlyOffice on Lady (Nextcloud Server)
```bash
# SSH to Lady
ssh lady

# Create OnlyOffice directory
mkdir -p ~/.docker-compose/nextcloud/

# Edit docker-compose.yaml to add OnlyOffice
cd ~/.docker-compose/nextcloud/
cp docker-compose.yaml docker-compose.yaml.backup

# Add OnlyOffice service to docker-compose.yaml
cat >> docker-compose.yaml << 'EOFC'

  onlyoffice-documentserver:
    image: onlyoffice/documentserver:8.2.0
    container_name: onlyoffice-documentserver
    restart: unless-stopped
    environment:
      - JWT_ENABLED=true
      - JWT_SECRET=${ONLYOFFICE_JWT_SECRET}
      - JWT_HEADER=Authorization
      - JWT_IN_BODY=true
    volumes:
      - onlyoffice-data:/var/www/onlyoffice/Data
      - onlyoffice-logs:/var/log/onlyoffice
      - onlyoffice-fonts:/usr/share/fonts/truetype/custom
      - onlyoffice-cache:/var/lib/onlyoffice/documentserver/App_Data/cache/files
    networks:
      - traefik
      - nextcloud-internal
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.onlyoffice.rule=Host(`office.quietly.online`)"
      - "traefik.http.routers.onlyoffice.entrypoints=websecure"
      - "traefik.http.routers.onlyoffice.tls.certresolver=letsencrypt"
      - "traefik.http.routers.onlyoffice.middlewares=vpn-only@file"
      - "traefik.http.services.onlyoffice.loadbalancer.server.port=80"

volumes:
  onlyoffice-data:
  onlyoffice-logs:
  onlyoffice-fonts:
  onlyoffice-cache:

networks:
  nextcloud-internal:
    driver: bridge
EOFC

# Generate strong JWT secret
ONLYOFFICE_JWT_SECRET=$(openssl rand -base64 48)
echo "ONLYOFFICE_JWT_SECRET=$ONLYOFFICE_JWT_SECRET" >> .env

# Start OnlyOffice
docker compose up -d onlyoffice-documentserver

# Wait for startup
sleep 30

# Verify
docker ps | grep onlyoffice
docker logs onlyoffice-documentserver --tail 50

# Test health
curl -k http://localhost/healthcheck
```

#### 2.4 Integrate OnlyOffice with Nextcloud
```bash
# Still on Lady

# Install OnlyOffice app in Nextcloud
docker exec -u www-data nextcloud php occ app:install onlyoffice

# Configure OnlyOffice connection
docker exec -u www-data nextcloud php occ config:app:set onlyoffice DocumentServerUrl --value="https://office.quietly.online/"
docker exec -u www-data nextcloud php occ config:app:set onlyoffice jwt_secret --value="$ONLYOFFICE_JWT_SECRET"
docker exec -u www-data nextcloud php occ config:app:set onlyoffice jwt_header --value="Authorization"

# Enable document editing for all users
docker exec -u www-data nextcloud php occ config:app:set onlyoffice customization_goback --value="true"
docker exec -u www-data nextcloud php occ config:app:set onlyoffice customization_help --value="true"

# Test integration
docker exec -u www-data nextcloud php occ onlyoffice:documentserver --check
```

#### 2.5 Verify Integration
```bash
# Test from browser:
# 1. Login to https://nextcloud.quietly.online
# 2. Create new document: Files → + → New document
# 3. Should open OnlyOffice editor
# 4. Test editing, saving
# 5. Test collaboration (if multiple users)

# Verify DNS
dig office.quietly.online

# Test endpoint
curl -I https://office.quietly.online/healthcheck
# Should return 200
```

#### 2.6 Document Nextcloud Stack
```bash
# Create comprehensive Nextcloud documentation
cat > ~/.docs/03-services/NEXTCLOUD.md << 'EOF'
# Nextcloud - Cloud Storage & Collaboration

**Status**: ✅ Operational  
**Server**: Lady  
**URL**: https://nextcloud.quietly.online  
**Version**: Latest (auto-update)

## Stack Components
- **nextcloud**: Main application
- **nextcloud-db**: PostgreSQL database
- **nextcloud-redis**: Cache layer
- **onlyoffice-documentserver**: Office suite integration

## Features
- File storage & sync
- Calendar (CalDAV)
- Contacts (CardDAV)
- Office editing (OnlyOffice)
- Mobile apps (iOS/Android)
- Desktop sync clients
- Share links with expiration
- User management

## OnlyOffice Integration
- **URL**: https://office.quietly.online
- **JWT Authentication**: Enabled
- **Supported formats**: DOCX, XLSX, PPTX
- **Real-time collaboration**: Yes

## Configuration
```bash
# Access OCC command
ssh lady "docker exec -u www-data nextcloud php occ"

# Status check
ssh lady "docker exec -u www-data nextcloud php occ status"

# User management
ssh lady "docker exec -u www-data nextcloud php occ user:list"
ssh lady "docker exec -u www-data nextcloud php occ user:add username"

# App management
ssh lady "docker exec -u www-data nextcloud php occ app:list"
ssh lady "docker exec -u www-data nextcloud php occ app:install app-name"

# OnlyOffice check
ssh lady "docker exec -u www-data nextcloud php occ onlyoffice:documentserver --check"
```

## Verification
```bash
# Check containers
ssh lady "docker ps | grep -E 'nextcloud|onlyoffice'"

# Test endpoints
curl -I https://nextcloud.quietly.online  # Should return 200
curl -I https://office.quietly.online/healthcheck  # Should return 200

# Test document creation
# Login → Files → + → New document → Opens OnlyOffice editor
```

## Maintenance
```bash
# Background jobs (should be cron)
ssh lady "docker exec -u www-data nextcloud php occ background:cron"

# Database maintenance
ssh lady "docker exec -u www-data nextcloud php occ db:add-missing-indices"

# Clear cache
ssh lady "docker exec -u www-data nextcloud php occ files:scan --all"

# Upgrade
ssh lady "cd ~/.docker-compose/nextcloud/ && docker compose pull && docker compose up -d"
```

## Storage
- Data: nextcloud_data volume
- Database: nextcloud-db container
- OnlyOffice: onlyoffice-data volume

## Troubleshooting
- Logs: `ssh lady "docker logs nextcloud -f"`
- DB: `ssh lady "docker exec nextcloud-db psql -U nextcloud"`
- Redis: `ssh lady "docker exec nextcloud-redis redis-cli ping"`
- OnlyOffice: `ssh lady "docker logs onlyoffice-documentserver -f"`

**Last Verified**: $(date +%Y-%m-%d)
EOF
```

**Deliverable**:
- ✅ Nextcloud fully configured
- ✅ OnlyOffice deployed on Lady
- ✅ Integration working (test document creation)
- ✅ Documentation complete
- ✅ Office productivity unlocked

---

### Task 3: Service Inventory 🔴
**Priority**: CRITICAL  
**Duration**: 2-3 hours  
**Impact**: Foundation for all documentation

See PHASE-00/01_CRITICAL_IMMEDIATE_ACTIONS.md Section 2 for detailed commands.

**Quick Summary**:
```bash
# Create inventory directory
mkdir -p ~/.reports/inventory/$(date +%Y%m%d)
cd ~/.reports/inventory/$(date +%Y%m%d)

# Capture live state
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}' > master-containers.txt
ssh lady "docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}'" > lady-containers.txt

# Generate SERVICE_INVENTORY.md (complete list of 56 services)
# See PHASE-00 document for full template
```

**Deliverable**:
- ✅ Complete 56-service inventory
- ✅ Categorized by function
- ✅ Live verification commands

---

### Task 4: Critical Service Documentation 🔴
**Priority**: CRITICAL  
**Duration**: 4-6 hours  
**Impact**: Documentation 10.7% → 17.9%

Document these 4 services (templates in PHASE-00):
1. **Authelia** (SSO - most important)
2. **Portainer** (Container management)
3. **Semaphore** (Ansible automation)
4. **Nextcloud** (already done in Task 2)

See PHASE-00/01_CRITICAL_IMMEDIATE_ACTIONS.md Section 3 for full templates.

**Deliverable**:
- ✅ 4 service docs created
- ✅ Standardized format
- ✅ Verification commands included
- ✅ Documentation: 10/56 = 17.9%

---

### Task 5: HTTP Routing Fixes 🔴
**Priority**: CRITICAL  
**Duration**: 30-60 minutes  
**Impact**: User-facing availability

**Issues**:
1. `cloud.quietly.online` → 502 Bad Gateway
2. `nextcloud.quietly.online` → 404 Not Found

```bash
# Check Traefik routers
ssh lady "docker logs traefik --tail 100 | grep nextcloud"

# Check Nextcloud labels
ssh lady "docker inspect nextcloud | jq '.[0].Config.Labels'"

# Verify DNS
dig nextcloud.quietly.online
dig cloud.quietly.online

# Test from Lady internally
ssh lady "curl -I http://nextcloud:80"

# Check Cloudflare DNS:
# - nextcloud.quietly.online → 207.180.251.111 (Lady IP)
# - cloud.quietly.online → 207.180.251.111 (Lady IP)

# Fix Traefik labels if needed
ssh lady "cd ~/.docker-compose/nextcloud/ && nano docker-compose.yaml"
# Ensure correct labels:
# - traefik.http.routers.nextcloud.rule=Host(`nextcloud.quietly.online`)
# - traefik.http.services.nextcloud.loadbalancer.server.port=80

# Restart if changes made
ssh lady "cd ~/.docker-compose/nextcloud/ && docker compose up -d"

# Verify fix
curl -I https://nextcloud.quietly.online  # Should return 200
curl -I https://cloud.quietly.online  # Should return 200 or redirect
```

**Deliverable**:
- ✅ Both endpoints returning 200
- ✅ Root cause documented
- ✅ Fix verified

---

## 📊 COMPLETION CHECKLIST

After PHASE-01:

- [ ] All secrets have 600 permissions
- [ ] Zero systemd failed units on both servers
- [ ] cAdvisor privilege decision documented
- [ ] Nextcloud fully configured and operational
- [ ] OnlyOffice deployed on Lady
- [ ] OnlyOffice integrated with Nextcloud (test document works)
- [ ] 56-service inventory created
- [ ] 4 critical services documented (Authelia, Portainer, Semaphore, Nextcloud)
- [ ] HTTP routing issues resolved (nextcloud + cloud endpoints)
- [ ] Documentation coverage: 17.9% (10/56)

**Grade Progress**: 87/100 (B+) → **90/100 (B++)**

---

## 🚀 SUCCESS CRITERIA

PHASE-01 is complete when:
1. ✅ Security score: A+ (15/15) - up from A- (14/15)
2. ✅ Office productivity: OPERATIONAL
3. ✅ Service inventory: 100% accurate
4. ✅ Documentation: >15%
5. ✅ HTTP routing: All working
6. ✅ Foundation solid for PHASE-02

---

## 📝 NEXT PHASE

**PHASE-02**: DNS & Documentation (Week 2)
- Execute DNS Audit (audit 02)
- Ramp documentation to 30%
- Perfect email DNS (PTR, DMARC, CAA)
- Target: 91/100 (A-)

---

**Start Date**: 2026-02-03  
**End Date**: 2026-02-09  
**Status**: Ready to execute  
**Estimated Hours**: 10-15h
