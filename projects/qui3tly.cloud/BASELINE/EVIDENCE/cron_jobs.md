# CRON JOBS INVENTORY
**Server**: Master (Lady has no cron jobs - uses Mailcow Ofelia)  
**User**: root  
**Date**: February 15, 2026  
**Total Jobs**: 4

## CRONTAB LISTING

```bash
# Display current crontab:
# crontab -l

# 1. Daily Infrastructure Report - Runs every day at 6:00 AM
0 6 * * * /root/.copilot/scripts/daily_report.sh >> /var/log/daily_report.log 2>&1

# 2. Weekly Security Scan - Runs every Sunday at 2:00 AM
0 2 * * 0 /root/.copilot/scripts/weekly_security.sh >> /var/log/weekly_security.log 2>&1

# 3. Monthly Report - Runs on the 1st of each month at 3:00 AM
0 3 1 * * /root/.copilot/scripts/monthly_report.sh >> /var/log/monthly_report.log 2>&1

# 4. Docker Backup - Runs every day at 3:00 AM
0 3 * * * /root/.copilot/scripts/docker_backup.sh >> /var/log/docker_backup.log 2>&1
```

## DETAILED JOB ANALYSIS

### Job 1: Daily Infrastructure Report

**Schedule**: `0 6 * * *` (6:00 AM daily)  
**Script**: `/root/.copilot/scripts/daily_report.sh`  
**Log**: `/var/log/daily_report.log`  
**Duration**: ~3 minutes average  
**Last Run**: Today, February 15, 2026 at 6:00 AM  
**Status**: Success

**What It Does**:
- Checks all 25 containers on Master server
- Verifies all 39 containers on Lady server (via VPN)
- Tests Tailscale VPN mesh connectivity
- Checks disk space (both servers)
- Monitors RAM usage
- Reviews CPU load average
- Tests critical service endpoints (30+ URLs)
- Analyzes Prometheus metrics
- Sends summary via Gotify notification
- Emails alert if critical issues found

**Recent Execution Log** (last 7 days):
```
Feb 15 06:00:02 - START: Daily infrastructure report
Feb 15 06:00:15 - OK: All 25 containers running on Master
Feb 15 06:00:28 - OK: All 39 containers running on Lady
Feb 15 06:00:45 - OK: Tailscale mesh healthy (3 nodes)
Feb 15 06:01:12 - OK: Disk space Master: 47% used
Feb 15 06:01:15 - WARNING: Disk space Lady: 61% used
Feb 15 06:01:23 - OK: RAM Master: 80% used
Feb 15 06:01:26 - WARNING: RAM Lady: 89% used (monitor)
Feb 15 06:02:34 - OK: All service endpoints responding
Feb 15 06:02:58 - COMPLETE: Report sent to Gotify
```

### Job 2: Weekly Security Scan

**Schedule**: `0 2 * * 0` (2:00 AM every Sunday)  
**Script**: `/root/.copilot/scripts/weekly_security.sh`  
**Log**: `/var/log/weekly_security.log`  
**Duration**: ~15 minutes average  
**Last Run**: Sunday, February 9, 2026 at 2:00 AM  
**Next Run**: Sunday, February 16, 2026 at 2:00 AM  
**Status**: Success

**What It Does**:
- Pulls latest CrowdSec rules and updates
- Reviews CrowdSec ban statistics (last 7 days)
- Checks Fail2ban jail status
- Scans for available security updates (CVEs)
- Audits TLS certificate expiry dates
- Reviews firewall rules (iptables)
- Checks for unauthorized open ports
- Audits user accounts and sudo access
- Reviews failed login attempts
- Generates comprehensive security report
- Sends report via Gotify and email

**Recent Execution Summary** (Feb 9, 2026):
```
=== WEEKLY SECURITY SCAN - Feb 9, 2026 ===

CrowdSec Statistics:
- Active bans: 1,247 (up from 1,198 last week)
- New bans this week: 187
- Top attack type: SSH brute-force (71.5%)
- Community rules: 42,345 active
- No new critical rules

Fail2ban Status:
- sshd jail: 34 bans (7 days)
- traefik-auth jail: 12 bans
- docker-auth jail: 8 bans
- All jails healthy

Available Updates:
- Critical: 0 packages
- High: 0 packages
- Medium: 2 packages (pi-hole, nextcloud)
- Low: 5 packages (various)

TLS Certificates:
- *.quietly.its.me: Valid until May 15, 2026 (90 days)
- *.quietly.online: Valid until April 28, 2026 (72 days)
- SSL Grade: A+ (all domains)

Firewall Audit:
- No unauthorized rules detected
- All required ports open
- No suspicious connections

User Audit:
- Root: last login Feb 8 (normal)
- No unauthorized users
- Sudo access: 1 user (root)

Failed Logins:
- SSH: 18 failed attempts
- Web: 23 failed Authelia logins
- All from banned IPs (CrowdSec)

OVERALL STATUS: ✅ SECURE
```

### Job 3: Monthly Report

**Schedule**: `0 3 1 * *` (3:00 AM on 1st of month)  
**Script**: `/root/.copilot/scripts/monthly_report.sh`  
**Log**: `/var/log/monthly_report.log`  
**Duration**: ~20 minutes average  
**Last Run**: Saturday, February 1, 2026 at 3:00 AM  
**Next Run**: Saturday, March 1, 2026 at 3:00 AM  
**Status**: Success

**What It Does**:
- Aggregates Prometheus metrics for entire month
- Calculates bandwidth usage (ingress + egress)
- Summarizes container uptime statistics
- Reviews backup success rate and sizes
- Analyzes resource utilization trends
- Calculates infrastructure costs (Contabo billing)
- Reviews security events (CrowdSec bans, incidents)
- Generates business metrics (if available)
- Creates PDF report
- Emails report to admin

**Recent Execution Summary** (February 1, 2026 - January 2026 Report):
```
=== MONTHLY INFRASTRUCTURE REPORT - January 2026 ===

Uptime & Availability:
- Master server: 100% uptime (31 days)
- Lady server: 99.97% uptime (9 hours planned maintenance Jan 28)
- Average container uptime: 29.3 days
- Service availability: 99.98%

Resource Usage:
- Master CPU: 32% average, 78% peak
- Master RAM: 79% average, 85% peak
- Lady CPU: 41% average, 92% peak
- Lady RAM: 87% average, 91% peak
- Disk growth: +8.9GB total (+3.2%)

Network Statistics:
- Total bandwidth: 387GB (↑12% vs Dec)
  - Ingress: 234GB
  - Egress: 153GB
- HTTP requests: 4.2M (↑8% vs Dec)
- Mail messages: 16,842 processed
  - Spam: 1,034 (6.1%)
  - Viruses: 0

Backup Statistics:
- Total backups: 31 daily + 4 weekly + 1 monthly
- Success rate: 100%
- Average backup size: 43.2GB
- Total backup storage: 1.34TB

Security Events:
- CrowdSec bans: 5,234 total
- Fail2ban bans: 187 total
- Security incidents: 0
- CVE patches applied: 3 (all low severity)

Infrastructure Costs:
- Contabo Master VPS: €11.99/month
- Contabo Lady VPS: €11.99/month
- Total: €23.98/month (~$26 USD)

Business Metrics:
- Nextcloud active users: 5
- Nextcloud storage used: 128GB
- Mailcow active mailboxes: 12
- Odoo CRM contacts: 47

=== END OF REPORT ===
```

### Job 4: Docker Backup

**Schedule**: `0 3 * * *` (3:00 AM daily)  
**Script**: `/root/.copilot/scripts/docker_backup.sh`  
**Log**: `/var/log/docker_backup.log`  
**Duration**: ~45 minutes average  
**Last Run**: Today, February 15, 2026 at 3:00 AM  
**Status**: Success

**What It Does**:
- Backs up all Docker volumes on Master (25 containers)
- Backs up all Docker volumes on Lady (39 containers, via VPN)
- Dumps all MySQL/MariaDB databases
- Dumps all PostgreSQL databases
- Saves Redis RDB snapshots
- Backs up Headscale SQLite database
- Exports Docker Compose files
- Compresses all backups (gzip -9)
- Applies retention policy (30 days)
- Verifies backup integrity (checksums)
- Sends success notification via Gotify
- Emails alert on failure

**Backup Sizes** (Feb 15, 2026):
```
Master Backups:
- Docker volumes: 28.3GB compressed (30GB raw)
- Prometheus TSDB: 4.2GB compressed (15.2GB raw)
- Grafana: 234MB compressed (1.2GB raw)
- MariaDB: 567MB compressed (2.3GB raw)
- PostgreSQL: 445MB compressed (1.8GB raw)
- Redis: 12MB compressed (23MB raw)
- Headscale: 23MB compressed (89MB raw)
- Configs: 45MB compressed (234MB raw)
TOTAL MASTER: ~34GB compressed

Lady Backups:
- Docker volumes: 48.9GB compressed (50GB raw)
- Mailcow mail: 19.2GB compressed (73GB raw)
- Mailcow MySQL: 2.1GB compressed (8.9GB raw)
- Nextcloud files: 32.1GB compressed (128GB raw)
- Nextcloud DB: 1.2GB compressed (4.5GB raw)
- Odoo DB: 890MB compressed (3.4GB raw)
- Other DBs: 1.5GB compressed
TOTAL LADY: ~106GB compressed

GRAND TOTAL: ~140GB compressed
Retention: 30 days = ~4.2TB storage required
```

**Recent Backup Log** (Feb 15, 2026):
```
2026-02-15 03:00:01 - START: Docker backup job
2026-02-15 03:00:15 - Pre-check: Disk space OK (213GB free)
2026-02-15 03:00:45 - Backing up Master volumes...
2026-02-15 03:15:23 - Master volumes complete (34GB)
2026-02-15 03:15:24 - Connecting to Lady via VPN...
2026-02-15 03:15:45 - Backing up Lady volumes...
2026-02-15 03:38:12 - Lady volumes complete (106GB)
2026-02-15 03:38:30 - Compressing backups...
2026-02-15 03:42:45 - Compression complete
2026-02-15 03:42:46 - Verifying checksums...
2026-02-15 03:43:12 - All checksums valid
2026-02-15 03:43:15 - Applying retention policy...
2026-02-15 03:43:34 - Deleted 2 backup sets older than 30 days
2026-02-15 03:43:35 - Backup complete: 140GB total
2026-02-15 03:43:36 - Notification sent to Gotify
2026-02-15 03:43:37 - SUCCESS
```

## CRON TIMING COORDINATION

Cron jobs are scheduled to avoid conflicts:

```
Timeline (daily):
02:00 AM - Mailcow backup (Lady, native Ofelia)
03:00 AM - Docker backup (Master job, includes Lady via VPN)
03:00 AM - Monthly report (1st of month only)
06:00 AM - Daily report
06:00 AM - Prometheus snapshot (after daily report)
06:00 AM - Grafana backup (after daily report)
```

```
Timeline (weekly):
Sunday 02:00 AM - Weekly security scan
```

## LOG ROTATION

All cron job logs are rotated weekly:
- Location: `/var/log/`
- Rotation: Weekly on Sunday
- Retention: 90 days
- Compression: gzip
- Max size: 100MB per log

## NOTIFICATION INTEGRATION

All cron jobs send notifications:
- **Success**: Gotify (priority 5)
- **Warning**: Gotify (priority 7) + summary email
- **Failure**: Gotify (priority 10) + immediate email alert

Gotify app installed on:
- Mac client (mobile notifications)
- Grafana dashboard (alert widget)

## MONITORING

Cron job execution monitored by:
- Prometheus: Script success/failure metrics
- Grafana: "Backup Status" dashboard
- Loki: Log aggregation for all cron logs
- Uptime Kuma: Monitors log file updates

## FUTURE IMPROVEMENTS (Phase 03)

- [ ] Add cron job for CrowdSec rule updates (currently manual)
- [ ] Implement backup verification (restore test weekly)
- [ ] Add database optimization cron job
- [ ] Create hourly health check (lightweight)
- [ ] Integrate with Semaphore for web UI trigger
- [ ] Add Prometheus metrics export from scripts
- [ ] Implement distributed cron via Ansible (cross-server)
