# TRUE NUKE - DEEP INVESTIGATION REPORT

**Date:** 2026-02-10 06:00 UTC  
**Type:** NUCLEAR OPTION - Complete infrastructure wipe & rebuild from GitHub  
**Risk Level:** 🔴 **CRITICAL - DATA LOSS GUARANTEED**

---

## WHAT IS "TRUE NUKE"?

**WRONG DEFINITION (Previously thought):**
```bash
docker system prune -a  # Only removes containers + images
```
❌ This preserves volumes, configs, compose files

**CORRECT DEFINITION (Actual TRUE NUKE):**
```bash
# DELETE EVERYTHING except ~/.secrets/
- All Docker volumes (Grafana, Prometheus, Portainer data)
- All Docker networks
- All Docker containers
- All Docker images
- All configuration files (~/.docker/*)
- All compose files (~/.docker-compose/*)
- Everything in home directory EXCEPT ~/.secrets/

# THEN REBUILD
git pull origin main  # Restore configs from GitHub
# Run docker compose up in each service directory
```

🔴 **THIS IS DESTRUCTIVE - PERMANENT DATA LOSS**

---

## CURRENT INFRASTRUCTURE STATE

### Master Server (100.64.0.1)

**Git Repository:**
```
Remote: https://github.com/quietly007/master.git
Branch: main
Status: 1 uncommitted file (must commit before nuke)
Last commit: c4521f5 "GOVERNANCE CLEANUP"
```

**Docker Resources:**
- Containers: 25 running
- Volumes: 17 named volumes
- Networks: 3 custom (traefik, monitoring, headscale)
- Images: ~30 images

**Critical Data in Volumes:**
1. `portainer_data` - Portainer settings, stacks, users
2. `grafana_data` - Dashboards, datasources, users, history
3. `prometheus_data` - 30 days of metrics (2GB+)
4. `loki_data` - Log history
5. `uptime-kuma_data` - Monitoring history, alerts
6. `pihole_data` - DNS records, blocklists, statistics
7. + 11 more volumes

### Lady Server (100.64.0.2)

**Git Repository:**
```
Remote: https://github.com/quietly007/lady.git
Branch: main
Status: 2 uncommitted files (must commit before nuke)
```

**Docker Resources:**
- Containers: 37 running (includes mailcow stack)
- Volumes: ~40 volumes (estimate)
- Networks: ~5 custom
- Images: ~50 images

**Critical Data in Volumes:**
1. Nextcloud data, database, redis cache
2. Odoo database (114 tables just initialized)
3. HomeAssistant configurations, history
4. Frigate video recordings, events
5. Mailcow mail storage, databases
6. + 30+ more volumes

---

## WHAT GETS DELETED (DATA LOSS)

### ⚠️ PERMANENT DATA LOSS - NO RECOVERY

| Data Type | Master | Lady | Recoverable? |
|-----------|--------|------|--------------|
| **Grafana Dashboards** | ✅ Custom | N/A | ❌ NO (unless exported) |
| **Prometheus Metrics** | ✅ 30 days | N/A | ❌ NO |
| **Loki Logs** | ✅ History | N/A | ❌ NO |
| **Uptime-kuma History** | ✅ Monitors + alerts | N/A | ❌ NO |
| **Pihole Statistics** | ✅ Query logs | N/A | ❌ NO |
| **Portainer Stacks** | ✅ Configs | N/A | ❌ NO (unless in git) |
| **Nextcloud Files** | N/A | ✅ User data | ❌ NO (CRITICAL!) |
| **Nextcloud Database** | N/A | ✅ 103 tables | ❌ NO |
| **Odoo Database** | N/A | ✅ 114 tables | ❌ NO (just initialized!) |
| **Mailcow Emails** | N/A | ✅ All mail | ❌ NO (CRITICAL!) |
| **HomeAssistant History** | N/A | ✅ Automation logs | ❌ NO |
| **Frigate Recordings** | N/A | ✅ Video | ❌ NO |

🔴 **CRITICAL: User files in Nextcloud and emails in Mailcow will be PERMANENTLY DELETED**

---

## WHAT SURVIVES (PRESERVED)

### ✅ Kept in ~/.secrets/

**Master (~/.secrets/):**
- Admin credentials (18 directories)
- API tokens
- JWT secrets
- Database passwords
- Encryption keys

**Lady (~/.secrets/):**
- Admin credentials (14 directories)
- Database passwords
- API keys

**Total:** 32 secret directories preserved

### ✅ Recoverable from GitHub

**From quietly007/master repo:**
- All compose files (~/.docker-compose/*)
- Service configs (~/.docker/*/config/*)
- Scripts (~/.copilot/*)
- Traefik configs
- Crowdsec configs
- Backup scripts

**From quietly007/lady repo:**
- All compose files
- Service configs
- Scripts

### ✅ Rebuild Instructions in Git

- Ansible playbooks (~/.github/ansible/)
- Phase documentation (~/.github/projects/)
- Service manuals (personal/manuals/)

---

## PRE-NUKE REQUIREMENTS (CRITICAL)

### 1. Commit ALL Uncommitted Changes

**Master: 1 file uncommitted**
```bash
cd ~
git status --short  # Show uncommitted file
git add .
git commit -m "PRE-NUKE: Final state before nuclear rebuild"
git push origin main
```

**Lady: 2 files uncommitted**
```bash
ssh lady "cd ~ && git add . && git commit -m 'PRE-NUKE: Final state before nuclear rebuild' && git push origin main"
```

### 2. Backup Critical Data (MANDATORY)

**Before nuke, backup:**
```bash
# Master
docker run --rm -v prometheus_data:/data -v ~/backups:/backup alpine tar czf /backup/prometheus_data_$(date +%F).tar.gz -C /data .
docker run --rm -v grafana_data:/data -v ~/backups:/backup alpine tar czf /backup/grafana_data_$(date +%F).tar.gz -C /data .
docker run --rm -v portainer_data:/data -v ~/backups:/backup alpine tar czf /backup/portainer_data_$(date +%F).tar.gz -C /data .

# Lady
ssh lady "docker run --rm -v nextcloud_data:/data -v ~/backups:/backup alpine tar czf /backup/nextcloud_data_\$(date +%F).tar.gz -C /data ."
ssh lady "docker run --rm -v nextcloud-db_data:/data -v ~/backups:/backup alpine tar czf /backup/nextcloud-db_\$(date +%F).tar.gz -C /data ."
# + Backup ALL mailcow volumes (29 volumes!)
```

**WARNING:** Without backups, data is unrecoverable.

### 3. Export Grafana Dashboards

```bash
# Export all dashboards via API
curl -sk -u admin:RaMpulstilckin123! https://grafana.quietly.its.me/api/dashboards/home | jq . > ~/backups/grafana_dashboards.json
```

### 4. Document Current Services

```bash
# List all running services
docker ps --format "{{.Names}}: {{.Image}}" > ~/backups/pre-nuke-services-master.txt
ssh lady "docker ps --format '{{.Names}}: {{.Image}}'" > ~/backups/pre-nuke-services-lady.txt
```

---

## TRUE NUKE EXECUTION SEQUENCE

### PHASE 1: PRE-NUKE VALIDATION

```bash
# 1. Verify git repos clean
cd ~ && [[ $(git status --short | wc -l) -eq 0 ]] && echo "✅ Master clean" || echo "❌ Uncommitted changes"
ssh lady "[[ \$(cd ~ && git status --short | wc -l) -eq 0 ]] && echo '✅ Lady clean' || echo '❌ Uncommitted changes'"

# 2. Verify backups exist
ls -lh ~/backups/*.tar.gz | tail -10

# 3. Verify on VPN (critical for recovery)
ip addr show tailscale0 && echo "✅ VPN active" || echo "❌ VPN DOWN - ABORT!"
```

### PHASE 2: NUCLEAR DELETION (MASTER)

```bash
# Stop all containers
docker stop $(docker ps -aq)

# Delete containers
docker rm -f $(docker ps -aq)

# Delete volumes (DATA LOSS!)
docker volume rm $(docker volume ls -q)

# Delete networks
docker network rm $(docker network ls --format "{{.Name}}" | grep -v -E "(bridge|host|none)")

# Delete images
docker rmi -f $(docker images -aq)

# Delete configs (EXCEPT secrets!)
cd ~
rm -rf .docker/*/
rm -rf .docker-compose/*/
# Keep: .secrets/, .github/

# Verify secrets preserved
ls -la ~/.secrets/
```

### PHASE 3: NUCLEAR DELETION (LADY)

```bash
ssh lady "
# Stop all containers
docker stop \$(docker ps -aq)

# Delete containers
docker rm -f \$(docker ps -aq)

# Delete volumes (DATA LOSS!)
docker volume rm \$(docker volume ls -q)

# Delete networks
docker network rm \$(docker network ls --format '{{.Name}}' | grep -v -E '(bridge|host|none)')

# Delete images
docker rmi -f \$(docker images -aq)

# Delete configs (EXCEPT secrets!)
cd ~
rm -rf .docker/*/
rm -rf .docker-compose/*/

# Verify secrets preserved
ls -la ~/.secrets/
"
```

### PHASE 4: REBUILD FROM GITHUB (MASTER)

```bash
# Pull latest from GitHub
cd ~
git reset --hard HEAD
git pull origin main --force

# Verify compose files restored
ls -la ~/.docker-compose/

# Create networks
docker network create traefik
docker network create monitoring

# Rebuild services (order matters!)
cd ~/.docker-compose/traefik && docker compose up -d
cd ~/.docker-compose/crowdsec && docker compose up -d
cd ~/.docker-compose/pihole && docker compose up -d
cd ~/.docker-compose/authelia && docker compose up -d
cd ~/.docker-compose/prometheus && docker compose up -d
cd ~/.docker-compose/alertmanager && docker compose up -d
cd ~/.docker-compose/loki && docker compose up -d
cd ~/.docker-compose/promtail && docker compose up -d
cd ~/.docker-compose/grafana && docker compose up -d
cd ~/.docker-compose/node-exporter && docker compose up -d
cd ~/.docker-compose/cadvisor && docker compose up -d
cd ~/.docker-compose/portainer && docker compose up -d
cd ~/.docker-compose/uptime-kuma && docker compose up -d
cd ~/.docker-compose/gotify && docker compose up -d
cd ~/.docker-compose/ntfy && docker compose up -d
cd ~/.docker-compose/semaphore && docker compose up -d
cd ~/.docker-compose/it-tools && docker compose up -d
cd ~/.docker-compose/headscale && docker compose up -d
cd ~/.docker-compose/headscale-ui && docker compose up -d
cd ~/.docker-compose/admin-panel && docker compose up -d
cd ~/.docker-compose/default-landing && docker compose up -d
cd ~/.docker-compose/fuckoff-page && docker compose up -d
cd ~/.docker-compose/cloudflared && docker compose up -d
```

### PHASE 5: REBUILD FROM GITHUB (LADY)

```bash
ssh lady "
# Pull latest from GitHub
cd ~
git reset --hard HEAD
git pull origin main --force

# Verify compose files restored
ls -la ~/.docker-compose/

# Create networks
docker network create traefik
docker network create monitoring

# Rebuild services
cd ~/.docker-compose/traefik && docker compose up -d
cd ~/.docker-compose/crowdsec && docker compose up -d
cd ~/.docker-compose/mailcow && docker compose up -d
cd ~/.docker-compose/nextcloud && docker compose up -d
cd ~/.docker-compose/odoo && docker compose up -d
cd ~/.docker-compose/home-assistant && docker compose up -d
cd ~/.docker-compose/frigate && docker compose up -d
cd ~/.docker-compose/node-exporter && docker compose up -d
cd ~/.docker-compose/cadvisor && docker compose up -d
cd ~/.docker-compose/promtail && docker compose up -d
"
```

### PHASE 6: POST-NUKE VERIFICATION

```bash
# Master
docker ps | wc -l  # Should be 25+ containers
docker ps --filter health=healthy | wc -l  # Should be 14+

# Lady
ssh lady "docker ps | wc -l"  # Should be 37+
ssh lady "docker ps --filter health=healthy | wc -l"  # Should be 10+

# Test services
curl -sk https://grafana.quietly.its.me -o /dev/null -w "%{http_code}\n"
curl -sk https://prometheus.quietly.its.me -o /dev/null -w "%{http_code}\n"
```

### PHASE 7: DATA RESTORATION (If Backed Up)

```bash
# Restore Prometheus data
docker run --rm -v prometheus_data:/data -v ~/backups:/backup alpine tar xzf /backup/prometheus_data_2026-02-10.tar.gz -C /data

# Restore Grafana data
docker run --rm -v grafana_data:/data -v ~/backups:/backup alpine tar xzf /backup/grafana_data_2026-02-10.tar.gz -C /data

# Restart services to use restored data
cd ~/.docker-compose/prometheus && docker compose restart
cd ~/.docker-compose/grafana && docker compose restart
```

---

## RISKS & CONSEQUENCES

### 🔴 CRITICAL RISKS

1. **Permanent Data Loss**
   - All Nextcloud user files DELETED
   - All emails in Mailcow DELETED
   - All Prometheus metrics DELETED
   - All Grafana dashboards DELETED (unless backed up)

2. **Service Downtime**
   - Estimated: 30-60 minutes complete outage
   - No access to any service during nuke
   - Risk of failed rebuild (stuck without services)

3. **Configuration Drift**
   - If local configs not committed to git → LOST FOREVER
   - Secrets must be manually reconfigured if ~/.secrets deleted by mistake

4. **Initialization Required**
   - Nextcloud: Must run `occ install` again
   - Odoo: Must run `-i base` again (lose 114 tables)
   - Grafana: Must recreate dashboards
   - Portainer: Must reconfigure stacks

### ⚠️ MEDIUM RISKS

1. **GitHub unavailable** → Cannot restore configs
2. **VPN down during rebuild** → Cannot SSH to Lady
3. **Docker Hub rate limits** → Cannot pull images
4. **Compose file errors** → Services won't start

### ⚠️ ROLLBACK CHALLENGES

**If nuke fails:**
- Data already deleted (unrecoverable without backup)
- Must restore from backups manually
- May need to rebuild from scratch
- Could take hours to recover

---

## ALTERNATIVES TO TRUE NUKE

### Option 1: Selective Cleanup
```bash
# Remove only unused resources
docker system prune -a --volumes  # Removes unused volumes only
```

### Option 2: Service-by-Service Rebuild
```bash
# Rebuild one service at a time
cd ~/.docker-compose/prometheus
docker compose down -v  # Delete volumes for this service only
git pull  # Update compose file
docker compose up -d
```

### Option 3: Fresh Server Install
```bash
# Instead of nuke, provision new servers
# Migrate data, then switch DNS
# Old servers remain as backup
```

---

## WHEN TO USE TRUE NUKE

### ✅ Good Reasons:
1. Complete infrastructure compromise (security breach)
2. Corrupt system state that cannot be debugged
3. Testing disaster recovery procedures
4. Migrating to new infrastructure

### ❌ Bad Reasons:
1. "Services aren't working" (fix them instead)
2. "Cleanup old images" (use `docker system prune` instead)
3. "Fresh start" (unnecessarily destructive)
4. "Testing" (practice in dev environment first)

---

## INVESTIGATION TASKS FOR EXTERNAL AGENT

### MANDATORY PRE-NUKE INVESTIGATION

1. **Verify Git Completeness**
   ```bash
   # Check ALL configs are in git
   find ~/.docker -name "*.yml" -o -name "*.yaml" -o -name "*.conf"
   find ~/.docker-compose -name "docker-compose.y*ml"
   # Ensure all are committed to git
   ```

2. **Document ALL Volumes**
   ```bash
   docker volume ls > volume-inventory.txt
   # For each volume, document:
   # - Which service uses it
   # - Can it be recreated? (Y/N)
   # - Backup required? (Y/N)
   ```

3. **Test Backup & Restore**
   ```bash
   # Pick ONE volume, backup & restore to verify process works
   docker run --rm -v test_volume:/data -v ~/backups:/backup alpine tar czf /backup/test.tar.gz -C /data .
   docker run --rm -v restored_volume:/data -v ~/backups:/backup alpine tar xzf /backup/test.tar.gz -C /data
   ```

4. **Dry Run on Dev Environment**
   ```bash
   # NEVER nuke production without testing on dev first
   # Create VM, clone infrastructure, run nuke, verify rebuild
   ```

5. **Create Rollback Plan**
   ```bash
   # Document EXACTLY how to restore if nuke fails mid-process
   # Include backup locations, restore commands, emergency contacts
   ```

### INVESTIGATION DELIVERABLE

Create: `TRUE_NUKE_INVESTIGATION_COMPLETE.md`

Must include:
- ✅ All configs verified in git (list any missing)
- ✅ All volumes documented (criticality rated)
- ✅ Backup strategy defined (volume-by-volume)
- ✅ Restore process tested (proof of recovery)
- ✅ Dry run completed in dev (results documented)
- ✅ Rollback plan written (step-by-step)
- ✅ Estimated downtime (with breakdown)
- ✅ Risk assessment (data loss quantified)
- ✅ Go/No-Go recommendation

**DO NOT PROCEED WITH NUKE WITHOUT THIS INVESTIGATION COMPLETE AND APPROVED.**

---

## EXTERNAL AGENT AUTHORIZATION

**Before executing TRUE NUKE:**

1. ✅ Read this entire report
2. ✅ Complete all investigation tasks
3. ✅ Create backups (verify they work)
4. ✅ Get explicit user approval: "YES, EXECUTE TRUE NUKE"
5. ✅ Confirm user understands data loss
6. ✅ Verify VPN active
7. ✅ Have rollback plan ready

**If ANY checkbox unchecked → DO NOT NUKE**

---

**Report Prepared By:** GitHub Copilot  
**Date:** 2026-02-10 06:00 UTC  
**Status:** ⏳ **INVESTIGATION REQUIRED - DO NOT EXECUTE WITHOUT USER APPROVAL**

**Estimated Total Time:** 2-4 hours (investigation + execution + verification)

🔴 **THIS IS NOT A DRILL - TRUE NUKE DELETES EVERYTHING**
