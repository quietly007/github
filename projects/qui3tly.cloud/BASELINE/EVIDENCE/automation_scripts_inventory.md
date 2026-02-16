# AUTOMATION SCRIPTS INVENTORY
**Location**: `/root/.copilot/scripts/` on Master server  
**Date**: February 15, 2026  
**Total Scripts**: 29  
**Total Lines of Code**: ~3,500

## REPORTS (3 scripts)

### daily_report.sh
- **Lines**: 145
- **Purpose**: Daily system health check and status report
- **Schedule**: Cron daily at 6:00 AM
- **Output**: `/var/log/daily_report.log`
- **Features**:
  - Container status check (docker ps)
  - Disk usage report (df -h)
  - Memory usage (free -h)
  - CPU load average (uptime)
  - Network connectivity test
  - Service endpoint checks
  - Gotify notification on completion
  - Critical alerts if issues found

### weekly_security.sh
- **Lines**: 203
- **Purpose**: Comprehensive weekly security audit
- **Schedule**: Cron every Sunday at 2:00 AM
- **Output**: `/var/log/weekly_security.log`
- **Features**:
  - CrowdSec statistics and ban review
  - Fail2ban jail status
  - CVE vulnerability scan (apt list --upgradable)
  - TLS certificate expiry check
  - Firewall rule audit (iptables -L)
  - Open port scan (ss -tulpn)
  - User account audit
  - Failed login attempts review
  - Gotify security summary

### monthly_report.sh
- **Lines**: 178
- **Purpose**: Monthly metrics summary and billing data
- **Schedule**: Cron 1st of month at 3:00 AM
- **Output**: `/var/log/monthly_report.log`
- **Features**:
  - Prometheus metrics aggregation
  - Bandwidth usage summary
  - Container uptime statistics
  - Backup size and success rate
  - Resource utilization trends
  - Cost analysis (Contabo billing)
  - Business metrics (if available)
  - PDF report generation

## BACKUPS (9 scripts)

### docker_backup.sh
- **Lines**: 312
- **Purpose**: Comprehensive Docker backup (volumes, databases, configs)
- **Schedule**: Cron daily at 3:00 AM
- **Output**: `/var/log/docker_backup.log`, `/backup/`
- **Features**:
  - All Docker volumes backup
  - MySQL/MariaDB dumps
  - PostgreSQL dumps
  - Redis RDB snapshots
  - Container configs export
  - Compression (gzip -9)
  - Retention policy (30 days)
  - Gotify notification
  - Email on failure

### prometheus_snapshot.sh
- **Lines**: 91
- **Purpose**: Prometheus TSDB snapshot
- **Schedule**: Daily at 6:00 AM (after daily_report)
- **Retention**: 7 days

### grafana_backup.sh
- **Lines**: 103
- **Purpose**: Grafana dashboard and datasource export
- **Schedule**: Daily at 6:00 AM
- **Retention**: 30 days

### headscale_backup.sh
- **Lines**: 87
- **Purpose**: Headscale SQLite database dump
- **Schedule**: Daily at 3:00 AM
- **Retention**: 30 days

### mysql_backup.sh
- **Lines**: 167
- **Purpose**: All MySQL/MariaDB databases
- **Schedule**: Daily at 3:00 AM
- **Retention**: 30 days

### postgres_backup.sh
- **Lines**: 154
- **Purpose**: All PostgreSQL databases
- **Schedule**: Daily at 3:00 AM
- **Retention**: 30 days

### redis_snapshot.sh
- **Lines**: 82
- **Purpose**: Redis RDB save and AOF backup
- **Schedule**: Daily at 3:00 AM
- **Retention**: 30 days

### config_sync.sh
- **Lines**: 198
- **Purpose**: Git commit and push all configs
- **Schedule**: On change (manual + weekly backup)
- **Features**:
  - Collects all /etc/ configs
  - Docker compose files
  - Shell scripts
  - Git commit with timestamp
  - Push to GitHub private repo

### mailcow_backup.sh
- **Purpose**: Mailcow native backup (via Mailcow script)
- **Schedule**: Daily at 2:00 AM
- **Location**: `/opt/mailcow-dockerized/helper-scripts/backup_and_restore.sh`
- **Retention**: 60 days

## MONITORING (7 scripts)

### container_health.sh
- **Lines**: 89
- **Purpose**: Check all container health status
- **Schedule**: Every 5 minutes (cron)
- **Features**:
  - docker ps health check
  - Restart count monitoring
  - Memory/CPU threshold alerts
  - Gotify alerts on issues

### tailscale_check.sh
- **Lines**: 72
- **Purpose**: Tailscale VPN mesh status
- **Schedule**: Every 15 minutes
- **Features**:
  - headscale node list
  - Ping all VPN nodes
  - DERP relay check
  - DNS resolution test

### wireguard_monitor.sh
- **Lines**: 65
- **Purpose**: WireGuard tunnel monitoring
- **Schedule**: Every 15 minutes
- **Features**:
  - wg show status
  - Ping through tunnel
  - Bandwidth monitoring
  - Auto-restart if down

### network_test.sh
- **Lines**: 134
- **Purpose**: Comprehensive network connectivity test
- **Schedule**: Every 30 minutes
- **Features**:
  - External IP verification
  - DNS resolution (1.1.1.1, 8.8.8.8)
  - HTTP/HTTPS connectivity
  - VPN mesh reachability
  - Latency measurements
  - Traceroute to key targets

### alert_test.sh
- **Lines**: 48
- **Purpose**: Test alert system
- **Schedule**: Daily at 8:00 AM
- **Features**:
  - Fire test alert to Prometheus
  - Verify Alertmanager routing
  - Check Gotify notification
  - Email delivery test

### ssl_report.sh
- **Lines**: 108
- **Purpose**: TLS/SSL certificate audit
- **Schedule**: Daily at 7:00 AM
- **Features**:
  - Check all domains (wildcard *.quietly.its.me)
  - Expiry date verification
  - SSL Labs API check
  - Certificate chain validation
  - Alert if < 30 days to expiry

### dns_update.sh
- **Lines**: 121
- **Purpose**: Update DNS records (dynamic IP if needed)
- **Schedule**: Hourly
- **Features**:
  - Get current public IP
  - Compare with DNS records
  - Update via Cloudflare API
  - Verify propagation

## MAINTENANCE (8 scripts)

### disk_cleanup.sh
- **Lines**: 67
- **Purpose**: Disk space management
- **Schedule**: Weekly
- **Features**:
  - Find and delete old logs
  - Docker prune (images, volumes)
  - Temp file cleanup
  - Old backup removal

### log_rotate.sh
- **Lines**: 54
- **Purpose**: Log rotation for custom logs
- **Schedule**: Daily midnight
- **Features**:
  - Rotate /var/log/custom logs
  - Compress old logs
  - Delete logs > 90 days

### memory_cleanup.sh
- **Lines**: 59
- **Purpose**: RAM optimization
- **Schedule**: Weekly
- **Features**:
  - Clear system cache (sync; echo 3 > /proc/sys/vm/drop_caches)
  - Find memory leaks
  - Container memory limit check

### docker_prune.sh
- **Lines**: 71
- **Purpose**: Docker cleanup
- **Schedule**: Weekly
- **Features**:
  - docker system prune -a
  - Remove dangling images
  - Clean build cache
  - Space report

### loki_retention.sh
- **Lines**: 93
- **Purpose**: Loki log retention enforcement
- **Schedule**: Daily
- **Features**:
  - Delete logs > 30 days
  - Compact Loki database
  - Verify storage size

### service_restart.sh
- **Lines**: 156
- **Purpose**: Service recovery automation
- **Schedule**: On alert trigger
- **Features**:
  - Detect failed containers
  - Attempt restart (max 3 times)
  - Escalate to admin if fails
  - Log restart reason

### traefik_reload.sh
- **Lines**: 38
- **Purpose**: Reload Traefik configuration
- **Schedule**: On config change
- **Features**:
  - Validate config syntax
  - docker kill -s SIGUSR1 traefik
  - Verify reload success

### pihole_update.sh
- **Lines**: 45
- **Purpose**: Pi-hole gravity database update
- **Schedule**: Daily at 2:00 AM
- **Features**:
  - pihole -g (update gravity)
  - Update blocklists
  - Restart DNS service

## SECURITY (5 scripts)

### cert_renewal.sh
- **Lines**: 43
- **Purpose**: Force TLS certificate renewal if needed
- **Schedule**: Daily check
- **Features**:
  - Check cert expiry
  - Trigger Traefik ACME renewal
  - Verify new certificate

### update_crowdsec.sh
- **Lines**: 76
- **Purpose**: CrowdSec rule updates
- **Schedule**: Daily at 4:00 AM
- **Features**:
  - docker exec crowdsec cscli hub update
  - Pull latest community rules
  - Upgrade scenarios
  - Restart CrowdSec

### authelia_sync.sh
- **Lines**: 112
- **Purpose**: Authelia user database synchronization
- **Schedule**: On change
- **Features**:
  - Sync users from LDAP (future)
  - Update user roles
  - Refresh sessions
  - Backup user DB

### fail2ban_check.sh
- **Included in**: weekly_security.sh
- **Purpose**: Fail2ban jail status and ban review

### vulnerability_scan.sh
- **Included in**: weekly_security.sh
- **Purpose**: CVE scan and package vulnerability check

## COMMON FEATURES (All Scripts)

1. **Error Handling**:
   - set -euo pipefail
   - Trap errors
   - Log all output
   - Gotify notification on failure

2. **Logging**:
   - Timestamp every entry
   - Separate log files per script
   - Log rotation compatible
   - Error vs info levels

3. **Notification**:
   - Gotify push on completion
   - Error alerts to admin
   - Summary in notification

4. **Dependencies**:
   - Check for required commands
   - Exit gracefully if missing
   - Documentation of requirements

5. **Configuration**:
   - Variables at top of script
   - Easy to customize
   - Version tracking

## EXECUTION STATISTICS (Last 30 Days)

- **Total Executions**: ~450
- **Success Rate**: 99.2%
- **Failed Executions**: 4
  - Feb 10: disk_cleanup.sh (false positive disk full)
  - Feb 7: network_test.sh (temporary DNS issue)
  - Feb 3: docker_backup.sh (destination full)
  - Jan 29: ssl_report.sh (SSL Labs API timeout)
- **Average Duration**: 2.3 minutes per script
- **Longest Running**: docker_backup.sh (45 minutes)
- **Shortest Running**: container_health.sh (8 seconds)

## GOTIFY INTEGRATION

All scripts send notifications to Gotify:
- **Success**: Priority 5 (normal)
- **Warning**: Priority 7 (high)
- **Error**: Priority 10 (critical) + email

## IMPROVEMENT IDEAS (Phase 03)

- [ ] Centralize logging (send to Loki)
- [ ] Prometheus metrics export (script success/failure)
- [ ] Parallel execution for independent scripts
- [ ] Web UI for manual trigger (Semaphore integration)
- [ ] Script versioning in Git with tags
- [ ] Unit tests for critical scripts
- [ ] Dry-run mode for testing
- [ ] Ansible refactor for cross-server execution
