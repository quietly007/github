# WEEK 1 ACTION PLAN - qui3tly.cloud
**Period**: January 28 - February 3, 2026  
**Total Time**: ~8-10 hours  
**Status**: Ready to Execute

---

## CRITICAL PRIORITY (P1) - MUST FIX IMMEDIATELY

### ❌ Task 1: Investigate Mailcow Outage
**Priority**: P1 - CRITICAL  
**Duration**: 1-2 hours  
**Status**: Not Started

**Steps**:
```bash
# 1. Check if Mailcow directory exists
ssh lady "ls -la ~/.docker-compose/ | grep -i mail"

# 2. Check for docker compose file
ssh lady "test -f ~/.docker-compose/mailcow/docker-compose.yml && echo 'EXISTS' || echo 'MISSING'"

# 3. Check git status
ssh lady "cd ~/.docker-compose/mailcow 2>/dev/null && git status || echo 'Not a git repo'"

# 4. If exists, check why not running
ssh lady "cd ~/.docker-compose/mailcow 2>/dev/null && docker compose ps"
ssh lady "cd ~/.docker-compose/mailcow 2>/dev/null && docker compose logs --tail 100"

# 5. If missing, check backups
ssh lady "ls -la /backup/mailcow* 2>/dev/null || echo 'No backups found'"
```

**Success Criteria**:
- [ ] Mailcow containers running (20+ containers)
- [ ] Mail sending/receiving works
- [ ] SOGo webmail accessible
- [ ] All mail ports operational (25, 587, 993, etc.)

---

## HIGH PRIORITY (P2) - FIX THIS WEEK

### ❌ Task 2: Fix Pihole Database
**Priority**: P2 - HIGH  
**Duration**: 30 minutes  
**Status**: Not Started

**Steps**:
```bash
# 1. Check current state
docker exec pihole ls -lh /etc/pihole/

# 2. Stop Pihole
docker stop pihole

# 3. Remove corrupted database
docker exec pihole rm -f /etc/pihole/pihole-FTL.db*
# OR if stopped:
sudo rm -f /var/lib/docker/volumes/pihole_pihole/_data/pihole-FTL.db*

# 4. Restart Pihole (will recreate DB)
docker start pihole

# 5. Verify
docker exec pihole pihole status
docker logs pihole --tail 50 | grep -i database

# 6. Test DNS
dig @100.64.0.1 google.com
```

**Success Criteria**:
- [ ] Database recreated
- [ ] No corruption errors in logs
- [ ] Query logging working
- [ ] DNS resolution functional

---

### ❌ Task 3: Fix Failing Services on Lady
**Priority**: P2 - HIGH  
**Duration**: 1 hour  
**Status**: Not Started

**Authelia Investigation**:
```bash
# Check logs
ssh lady "docker logs authelia --tail 100"

# Common issues:
# - Configuration file errors (check /config/configuration.yml)
# - Database connection issues
# - Certificate problems
# - Redis connection

# Get full status
ssh lady "cd ~/.docker-compose/authelia && docker compose ps"
ssh lady "cd ~/.docker-compose/authelia && docker compose config"

# Fix and restart
ssh lady "cd ~/.docker-compose/authelia && docker compose restart"
```

**Semaphore Investigation**:
```bash
# Check logs
ssh lady "docker logs semaphore --tail 100"

# Common issues:
# - Database not ready
# - Configuration errors
# - Port conflicts
# - Missing environment variables

# Get status
ssh lady "cd ~/.docker-compose/semaphore && docker compose ps"
ssh lady "cd ~/.docker-compose/semaphore && docker compose logs --tail 50"

# Fix and restart
ssh lady "cd ~/.docker-compose/semaphore && docker compose restart"
```

**Success Criteria**:
- [ ] Both services running stable (no restarts for 1+ hour)
- [ ] No errors in logs
- [ ] Web interfaces accessible
- [ ] Authentication works

---

### ⚪ Task 4: Setup Automated Backups
**Priority**: HIGH  
**Duration**: 2 hours  
**Status**: Not Started

**Implementation**:
```bash
# Install restic
sudo apt update && sudo apt install restic -y

# Create backup directory
sudo mkdir -p /backup/qui3tly-master
sudo chown qui3tly:qui3tly /backup/qui3tly-master

# Create password file
mkdir -p ~/.secrets
echo "$(openssl rand -base64 32)" > ~/.secrets/restic-password
chmod 600 ~/.secrets/restic-password

# Initialize repository
restic -r /backup/qui3tly-master -p ~/.secrets/restic-password init

# Create backup script
cat > ~/.scripts/backup-master.sh << 'EOFSCRIPT'
#!/bin/bash
set -e

BACKUP_REPO="/backup/qui3tly-master"
RESTIC_PASSWORD_FILE="$HOME/.secrets/restic-password"
LOG_FILE="/var/log/qui3tly-backup.log"

echo "$(date): Starting backup..." | tee -a "$LOG_FILE"

# Backup Docker volumes
docker volume ls -q | while read volume; do
    echo "Backing up volume: $volume"
    docker run --rm \
        -v "$volume:/data:ro" \
        -v "$BACKUP_REPO:/backup" \
        -v "$RESTIC_PASSWORD_FILE:/password:ro" \
        restic/restic \
        -r /backup \
        -p /password \
        backup /data \
        --tag "docker-volume" \
        --tag "$volume"
done

# Backup configurations
restic -r "$BACKUP_REPO" -p "$RESTIC_PASSWORD_FILE" backup \
    "$HOME/.docker-compose" \
    "$HOME/.docs" \
    "$HOME/.ansible" \
    /etc/systemd/system/headscale.service \
    --tag "config"

# Prune old backups
restic -r "$BACKUP_REPO" -p "$RESTIC_PASSWORD_FILE" forget \
    --keep-daily 30 \
    --keep-monthly 12 \
    --prune

echo "$(date): Backup completed successfully" | tee -a "$LOG_FILE"
EOFSCRIPT

chmod +x ~/.scripts/backup-master.sh

# Test backup
~/.scripts/backup-master.sh

# Schedule backup (daily at 02:00)
(crontab -l 2>/dev/null; echo "0 2 * * * $HOME/.scripts/backup-master.sh") | crontab -
```

**Success Criteria**:
- [ ] Restic installed and configured
- [ ] Initial backup completed successfully
- [ ] Cron job scheduled
- [ ] Test restore works
- [ ] Documentation updated

---

### ⚪ Task 5: Test Backup Restore
**Priority**: HIGH  
**Duration**: 1 hour  
**Status**: Not Started

**Steps**:
```bash
# 1. Create test environment
mkdir -p /tmp/restore-test
cd /tmp/restore-test

# 2. List available snapshots
restic -r /backup/qui3tly-master -p ~/.secrets/restic-password snapshots

# 3. Restore latest snapshot
restic -r /backup/qui3tly-master -p ~/.secrets/restic-password \
    restore latest --target /tmp/restore-test

# 4. Verify files
ls -la /tmp/restore-test
find /tmp/restore-test -type f | head -20

# 5. Test specific restore (docker-compose files)
restic -r /backup/qui3tly-master -p ~/.secrets/restic-password \
    restore latest --target /tmp/restore-test \
    --include "home/qui3tly/.docker-compose/grafana"

# 6. Document findings
vi ~/.docs/02-operations/DISASTER_RECOVERY.md
```

**Success Criteria**:
- [ ] Can list snapshots
- [ ] Can restore files
- [ ] Restored files are correct
- [ ] DR procedures updated

---

## MEDIUM PRIORITY (P3) - NICE TO HAVE

### ⚪ Task 6: Configure Nextcloud
**Priority**: MEDIUM  
**Duration**: 30 minutes  
**Status**: Not Started (Nextcloud already running, just needs setup)

**Steps**:
```bash
# 1. Access setup wizard
open https://cloud.quietly.online

# 2. Create admin account
# Username: admin
# Password: [generate strong password]
# Save to ~/.secrets/nextcloud-admin.txt

# 3. Configure database
# Type: MySQL/MariaDB
# Database: nextcloud
# User: nextcloud
# Password: [from docker-compose.yml]
# Host: nextcloud-db:3306

# 4. Set data directory
# Path: /data

# 5. Install recommended apps
# - Calendar
# - Contacts
# - Tasks
# - Deck (project management)
# - Notes
# - Talk (optional)

# 6. Configure external storage (if needed)

# 7. Test file upload/download

# 8. Configure mobile app
# iOS: Install Nextcloud from App Store
# Android: Install Nextcloud from Play Store
```

**Success Criteria**:
- [ ] Admin can login
- [ ] Files upload successfully
- [ ] Calendar/contacts work
- [ ] Mobile app syncs
- [ ] Credentials documented

---

### ⚪ Task 7: Deploy Promtail to Lady
**Priority**: MEDIUM  
**Duration**: 1 hour  
**Status**: Not Started

**Implementation**:
```bash
# SSH to lady
ssh lady

# Create Promtail directory
mkdir -p ~/.docker-compose/promtail

# Create configuration
cat > ~/.docker-compose/promtail/config.yaml << 'EOFCONFIG'
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://100.64.0.1:3100/loki/api/v1/push

scrape_configs:
  - job_name: docker
    static_configs:
      - targets:
          - localhost
        labels:
          job: docker
          host: lady
          __path__: /var/lib/docker/containers/*/*-json.log

  - job_name: system
    static_configs:
      - targets:
          - localhost
        labels:
          job: syslog
          host: lady
          __path__: /var/log/syslog
EOFCONFIG

# Create docker-compose.yaml
cat > ~/.docker-compose/promtail/docker-compose.yaml << 'EOFCOMPOSE'
services:
  promtail:
    image: grafana/promtail:3.4.2
    container_name: promtail
    restart: unless-stopped
    volumes:
      - ./config.yaml:/etc/promtail/config.yaml:ro
      - /var/log:/var/log:ro
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
    command: -config.file=/etc/promtail/config.yaml
    networks:
      - monitoring

networks:
  monitoring:
    external: true
EOFCOMPOSE

# Deploy
docker compose up -d

# Verify
docker logs promtail

# Test in Grafana
# Go to Explore → Loki → {host="lady"}
```

**Success Criteria**:
- [ ] Promtail container running
- [ ] Logs visible in Grafana
- [ ] Both docker and system logs flowing
- [ ] No errors in promtail logs

---

### ⚪ Task 8: Update Documentation
**Priority**: MEDIUM  
**Duration**: 1 hour  
**Status**: Not Started

**Tasks**:
```bash
# Update service counts
vi ~/.docs/00-standards/INFRASTRUCTURE_OVERVIEW.md
# - Master: 24 containers (correct)
# - Lady: 21 containers running (should be 40+)

# Update service status
vi ~/.docs/03-services/MAILCOW.md
# - Mark status as DOWN
# - Add investigation notes
# - Document when it went down

# Add new services
vi ~/.docs/03-services/NEXTCLOUD.md  # Create if missing
vi ~/.docs/03-services/HOME_ASSISTANT.md  # Create if missing

# Update MASTER_PLAN
vi ~/.github/projects/qui3tly.cloud/MASTER_PLAN.md
# - Mark completed tasks
# - Update infrastructure grade
# - Add lessons learned

# Commit changes
cd ~ && git add -A && git commit -m "Docs: Update after Week 1 repairs" && git push
```

**Success Criteria**:
- [ ] All service counts accurate
- [ ] Mailcow status documented
- [ ] New services documented
- [ ] Master Plan updated
- [ ] Changes committed to git

---

## PROGRESS TRACKING

**Completed**: 0/8 tasks (0%)  
**In Progress**: 0/8 tasks  
**Not Started**: 8/8 tasks  

**Estimated Total Time**: ~8-10 hours  
**Time Spent**: 0 hours  

**Target Completion**: February 3, 2026 (6 days)

---

## QUICK START

To begin, execute tasks in this order:

1. **START HERE**: Task 1 - Mailcow investigation (P1)
2. **THEN**: Task 2 - Pihole database fix (P2)
3. **THEN**: Task 3 - Fix failing services (P2)
4. **PARALLEL**: Tasks 4-5 - Backups (can do while waiting)
5. **FINISH**: Tasks 6-8 - Nice to have items

---

**Last Updated**: 2026-01-28 11:00 CET  
**Next Review**: After completing P1 tasks
