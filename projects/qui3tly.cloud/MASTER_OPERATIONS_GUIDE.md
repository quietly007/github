# QUI3TLY.CLOUD - MASTER OPERATIONS GUIDE

**Version**: 1.0  
**Last Updated**: January 28, 2026  
**Infrastructure Grade**: A+ (96/100)  
**Status**: Production Ready

---

## QUICK REFERENCE

### Infrastructure Status
- **Master**: 100.64.0.1 (quietly.its.me)
- **Lady**: 100.64.0.2 (quietly.online)
- **Overall Health**: ✅ Excellent
- **Security Grade**: 96/100 (A+)
- **Uptime Target**: 99.5%

### Emergency Contacts
- **Admin**: qui3tly
- **Monitoring**: grafana.qui3tly.cloud
- **Alerts**: Gotify (master), ntfy (both servers)

### Quick Access
```bash
# SSH to servers
ssh master   # 100.64.0.1 or quietly.its.me
ssh lady     # 100.64.0.2 or quietly.online

# Access services
https://grafana.qui3tly.cloud      # Monitoring
https://portainer.quietly.its.me   # Docker management
https://traefik.quietly.its.me     # Traefik dashboard
https://mail.quietly.online        # Webmail
```

---

## TABLE OF CONTENTS

1. [Quick Reference](#quick-reference)
2. [Admin Tools & Services](#admin-tools--services)
3. [Daily Operations](#daily-operations)
4. [Weekly Tasks](#weekly-tasks)
5. [Monthly Tasks](#monthly-tasks)
6. [Incident Response](#incident-response)
7. [Maintenance Procedures](#maintenance-procedures)
8. [Troubleshooting](#troubleshooting)
9. [Next Steps](#next-steps)
10. [Runbooks](#runbooks)

---

## ADMIN TOOLS & SERVICES

**Complete Inventory**: See [ADMIN_TOOLS_INVENTORY.md](file://~/.docs/ADMIN_TOOLS_INVENTORY.md) for full details.

### Master Server (100.64.0.1)

**Core Admin Interfaces**:
- **Grafana**: https://grafana.qui3tly.cloud (Dashboards & visualization)
- **Portainer**: https://portainer.quietly.its.me (Docker management)
- **Traefik**: https://traefik.quietly.its.me (Reverse proxy dashboard)
- **Prometheus**: http://100.64.0.1:9090 (Metrics & queries)
- **Loki**: http://100.64.0.1:3100 (Log aggregation)
- **Alertmanager**: http://100.64.0.1:9093 (Alert management)
- **Pihole**: http://100.64.0.1:8000/admin (DNS & ad blocking)
- **Authelia**: https://auth.quietly.its.me (Authentication/SSO)
- **IT-Tools**: https://tools.quietly.its.me (Admin utilities)
- **Gotify**: https://gotify.quietly.its.me (Notifications)
- **Headscale**: CLI only (`headscale` command)

**Monitoring Endpoints**:
- node-exporter: http://100.64.0.1:9100/metrics
- cAdvisor: http://100.64.0.1:8080/metrics
- Traefik Metrics: http://100.64.0.1:8082/metrics

### Lady Server (100.64.0.2)

**Mail & Web Admin**:
- **Mailcow**: https://mail.quietly.online (Complete mail server management)
- **SOGo Webmail**: https://mail.quietly.online/SOGo (Webmail interface)
- **Nextcloud**: https://cloud.quietly.online (Cloud storage - needs setup)
- **Traefik**: http://100.64.0.2:8080 (Reverse proxy)
- **Portainer Agent**: http://100.64.0.2:9001 (Managed from Master)
- **CrowdSec**: CLI only (`docker exec crowdsec cscli`)

**Monitoring Endpoints**:
- node-exporter: http://100.64.0.2:9100/metrics
- cAdvisor: http://100.64.0.2:8081/metrics
- Traefik Metrics: http://100.64.0.2:8082/metrics

### API Endpoints

- **Mailcow API**: https://mail.quietly.online/api/v1 (API key required)
- **Traefik API**: http://localhost:8080/api (Localhost only)
- **Prometheus API**: http://100.64.0.1:9090/api/v1 (Tailscale only)
- **Grafana API**: https://grafana.qui3tly.cloud/api (API key or session)

### Quick Access Commands

```bash
# SSH to servers
ssh master  # or ssh qui3tly@100.64.0.1
ssh lady    # or ssh qui3tly@100.64.0.2

# Check service status
ssh master "docker ps"
ssh lady "docker ps"

# Mail queue
ssh lady "docker exec mailcow-postfixd postqueue -p"

# Security status
ssh lady "docker exec crowdsec cscli decisions list | head -20"
ssh master "sudo fail2ban-client status"

# View logs
docker logs -f <container_name>
ssh master "docker logs grafana --tail 100"
```

---

## DAILY OPERATIONS

### Morning Checks (5 minutes)

**1. Check Monitoring Dashboard**
```bash
# Open Grafana
open https://grafana.qui3tly.cloud
```

**What to check**:
- [ ] All services showing "UP" status
- [ ] CPU usage < 80%
- [ ] Memory usage < 90%
- [ ] Disk usage < 85%
- [ ] No firing alerts

**2. Check Mail Server**
```bash
ssh lady "docker exec -it mailcow-postfixd postqueue -p"
```

**What to look for**:
- [ ] Mail queue < 50 messages
- [ ] No error messages
- [ ] Spam filtering working

**3. Review Security Alerts**
```bash
# Check CrowdSec decisions
ssh lady "docker exec crowdsec cscli decisions list"

# Check fail2ban
ssh master "sudo fail2ban-client status sshd"
ssh lady "sudo fail2ban-client status sshd"
```

**What to look for**:
- [ ] No suspicious ban patterns
- [ ] CrowdSec decisions reasonable
- [ ] No successful breach attempts

### Evening Checks (2 minutes)

**Quick Status Check**:
```bash
# Check all services
ssh master "docker ps --format 'table {{.Names}}\t{{.Status}}'"
ssh lady "docker ps --format 'table {{.Names}}\t{{.Status}}'"
```

**Expected**: All containers "Up X hours/days"

---

## WEEKLY TASKS

### Every Monday (15 minutes)

**1. Review Logs**
```bash
# Check authentication logs
ssh master "sudo tail -100 /var/log/auth.log | grep -i failed"
ssh lady "sudo tail -100 /var/log/auth.log | grep -i failed"

# Check system logs
ssh master "sudo journalctl -p err -n 50"
ssh lady "sudo journalctl -p err -n 50"
```

**2. Update Threat Intelligence**
```bash
# CrowdSec updates automatically, verify:
ssh lady "docker exec crowdsec cscli hub update"
ssh lady "docker exec crowdsec cscli hub upgrade"
```

**3. Backup Configuration**
```bash
# Commit any changes
cd /home/qui3tly
git status
git add -A
git commit -m "Weekly backup: $(date +%Y-%m-%d)"
git push origin main
```

### Every Sunday (10 minutes)

**1. Check SSL Certificates**
```bash
# Verify certificates are valid
echo | openssl s_client -connect quietly.its.me:443 2>/dev/null | openssl x509 -noout -dates
echo | openssl s_client -connect quietly.online:443 2>/dev/null | openssl x509 -noout -dates
echo | openssl s_client -connect mail.quietly.online:443 2>/dev/null | openssl x509 -noout -dates
```

**Expected**: Valid until ~April 2026 (90 days ahead)

**2. Review Metrics**
```bash
# Generate weekly report (if configured)
# Or manually review in Grafana
```

---

## MONTHLY TASKS

### First Monday of Month (30-45 minutes)

**1. Security Audit**
```bash
# Run comprehensive security audit
# (Use the audit procedures from today's session)

# Check all ports
ssh master "ss -tlnp"
ssh lady "ss -tlnp"

# Review UFW rules
ssh master "sudo ufw status numbered"
ssh lady "sudo ufw status numbered"

# Check for security updates
ssh master "sudo apt update && sudo apt list --upgradable"
ssh lady "sudo apt update && sudo apt list --upgradable"
```

**2. Update Documentation**
```bash
# Update service inventory
# Update any changed configurations
# Review and update this guide

cd /home/qui3tly
vi .docs/MASTER_OPERATIONS_GUIDE.md
```

**3. Backup Review**
```bash
# Verify backups exist and are recent
# Test restore procedure (quarterly)
ls -lh /home/qui3tly/.backups/
```

**4. Performance Review**
```bash
# Check disk usage
ssh master "df -h"
ssh lady "df -h"

# Check Docker disk usage
ssh master "docker system df"
ssh lady "docker system df"

# Clean up if needed
ssh master "docker system prune -a --volumes -f"
ssh lady "docker system prune -a --volumes -f"
```

### System Updates (Schedule during low-traffic)

**Procedure**:
```bash
# 1. Check for updates
ssh master "sudo apt update && sudo apt list --upgradable"

# 2. If critical security updates, apply immediately
ssh master "sudo apt upgrade -y"
ssh master "sudo reboot" # if kernel updated

# 3. Verify services after reboot
# Wait 2 minutes, then:
ssh master "docker ps"

# 4. Repeat for lady
ssh lady "sudo apt update && sudo apt upgrade -y"
```

---

## INCIDENT RESPONSE

### Severity Levels

**P1 - Critical (Immediate Response)**
- Complete service outage
- Security breach detected
- Data loss in progress

**P2 - High (Response within 1 hour)**
- Partial service outage
- Degraded performance affecting users
- Security vulnerability discovered

**P3 - Medium (Response within 4 hours)**
- Single service down
- Minor performance issues
- Non-critical security findings

**P4 - Low (Response within 24 hours)**
- Cosmetic issues
- Documentation errors
- Enhancement requests

### Incident Response Procedure

**1. Identify and Assess**
```bash
# Check service status
ssh master "docker ps"
ssh lady "docker ps"

# Check logs
ssh master "docker logs --tail 100 <container_name>"

# Check system resources
ssh master "top -bn1 | head -20"
ssh master "df -h"
```

**2. Contain**
```bash
# If security incident:
# - Block attacking IP
ssh master "sudo ufw insert 1 deny from <IP>"

# If service issue:
# - Restart affected container
docker restart <container_name>

# If resource exhaustion:
# - Kill offending process
kill -9 <PID>
```

**3. Resolve**
```bash
# Follow specific runbook for the issue
# Document steps taken
# Verify resolution
```

**4. Document**
```bash
# Create incident report
vi /home/qui3tly/.reports/incidents/incident-$(date +%Y-%m-%d).md
```

### Emergency Procedures

**Complete Master Outage**:
1. SSH to master via IP if DNS is down
2. Check `/var/log/syslog` for errors
3. Check disk space: `df -h`
4. Restart services: `docker compose up -d`
5. If persistent, restore from backup

**Mail Server Down**:
1. SSH to lady
2. Check Mailcow status: `cd ~/.docker-compose/mailcow && docker compose ps`
3. Check logs: `docker compose logs --tail 100`
4. Restart if needed: `docker compose restart`

**Security Breach**:
1. Disconnect affected server from internet
2. Capture memory dump (if forensics needed)
3. Review all logs
4. Check for unauthorized changes
5. Restore from known-good backup
6. Investigate root cause
7. Implement additional security measures

---

## MAINTENANCE PROCEDURES

### Scheduled Maintenance Window

**Recommended**: Sunday 02:00-04:00 CET (lowest traffic)

**Procedure**:
```bash
# 1. Announce maintenance (if users affected)
# Send notification via mail/Gotify

# 2. Create backup
cd /home/qui3tly
git add -A
git commit -m "Pre-maintenance backup"
git push

# 3. Perform maintenance task
# (follow specific procedure for task)

# 4. Verify services
ssh master "docker ps"
ssh lady "docker ps"

# 5. Monitor for 30 minutes
# Watch Grafana dashboards

# 6. Document changes
vi .docs/changelog.md
```

### Docker Container Updates

```bash
# 1. Pull new images
cd ~/.docker-compose/<service>
docker compose pull

# 2. Recreate containers
docker compose up -d

# 3. Remove old images
docker image prune -f

# 4. Verify
docker compose ps
docker compose logs --tail 50
```

### Certificate Renewal

**Automatic**: Traefik handles this via Let's Encrypt

**Manual verification**:
```bash
# Check certificate expiry
echo | openssl s_client -connect quietly.its.me:443 2>/dev/null | openssl x509 -noout -dates

# Force renewal if needed
docker restart traefik
```

---

## TROUBLESHOOTING

### Service Won't Start

**Diagnosis**:
```bash
# 1. Check logs
docker logs <container_name>

# 2. Check configuration
docker inspect <container_name>

# 3. Check port conflicts
ss -tlnp | grep <port>

# 4. Check resources
free -h
df -h
```

**Common fixes**:
```bash
# Port already in use
sudo lsof -i :<port>
# Kill the process or change container port

# Out of disk space
docker system prune -a

# Out of memory
docker restart <container_name>
# Or increase container memory limit
```

### DNS Not Resolving

**Check Pihole**:
```bash
ssh master "docker logs pihole | tail -50"
ssh master "dig @127.0.0.1 google.com"
```

**Fix**:
```bash
# Restart Pihole
docker restart pihole

# Flush DNS cache
docker exec pihole pihole restartdns

# Check DNS configuration
cat /etc/resolv.conf
```

### Mail Not Sending

**Diagnosis**:
```bash
# Check Postfix queue
ssh lady "docker exec mailcow-postfixd postqueue -p"

# Check logs
ssh lady "docker logs mailcow-postfixd | tail -100"

# Check connectivity
ssh lady "telnet gmail.com 25"
```

**Common fixes**:
```bash
# Flush queue
docker exec mailcow-postfixd postqueue -f

# Restart mail services
cd ~/.docker-compose/mailcow
docker compose restart postfix-mailcow dovecot-mailcow
```

### High CPU Usage

**Identify culprit**:
```bash
# Check processes
top -bn1 | head -20

# Check Docker containers
docker stats --no-stream

# Check specific container
docker exec <container> top -bn1
```

**Fix**:
```bash
# Restart container
docker restart <container>

# Limit container resources
# Edit docker-compose.yaml, add:
# resources:
#   limits:
#     cpus: '2'
#     memory: 2G
```

---

## NEXT STEPS

### Immediate (This Week)

**1. Configure Nextcloud** (30 minutes)
```bash
# Access Nextcloud
open https://cloud.quietly.online

# Follow setup wizard
# Create admin account
# Configure storage
```

**2. Test Backup Restore** (1 hour)
```bash
# Create test restore environment
# Restore from git backup
# Verify services start correctly
# Document procedure
```

**3. Set Up Automated Backups** (2 hours)
```bash
# Install restic or borg
# Configure S3-compatible storage
# Create backup script
# Schedule via cron
# Test restore
```

### Short-term (Next 2 Weeks)

**1. Deploy Promtail to Lady**
```bash
# Install Promtail
# Configure to send to master's Loki
# Create log parsing rules
# Verify logs appearing in Grafana
```

**2. Create Additional Dashboards**
- Mail server metrics dashboard
- Security events dashboard
- Cost tracking dashboard

**3. Implement Alert Tuning**
- Review alert thresholds
- Add application-specific alerts
- Configure alert routing

### Medium-term (1-3 Months)

**1. Migrate Headscale to Docker**
- Export existing configuration
- Create docker-compose.yaml
- Add Traefik labels for SSL
- Test with one client
- Migrate all clients
- Remove system service

**2. Implement High Availability** (if needed)
- Evaluate requirements
- Design HA architecture
- Implement load balancing
- Test failover procedures

**3. GDPR Compliance**
- Create privacy policy
- Document data flows
- Implement data retention policies
- Create GDPR procedures

### Long-term (3-6 Months)

**1. Evaluate Kubernetes Migration**
- Test K3s on master
- Migrate monitoring stack
- Evaluate benefits vs complexity
- Decision: migrate or stay Docker

**2. Implement Disaster Recovery**
- Off-site backups
- DR site setup (optional)
- Automated DR testing
- Recovery time optimization

**3. Infrastructure Expansion**
- Evaluate need for additional servers
- Consider specialized services
- Plan capacity growth

---

## RUNBOOKS

### Runbook: Complete Server Failure

**Objective**: Restore server to operational state

**Time**: 30-60 minutes (depending on cause)

**Steps**:
1. Attempt SSH connection
2. If no response, check hosting provider dashboard
3. If server down, start server via provider
4. If server responds but services down:
   ```bash
   # Check Docker
   sudo systemctl status docker
   
   # Start Docker if stopped
   sudo systemctl start docker
   
   # Start all services
   cd /home/qui3tly/.docker-compose
   for dir in */; do
     cd "$dir"
     docker compose up -d
     cd ..
   done
   ```
5. Verify all services: `docker ps`
6. Check Grafana dashboards
7. Document incident

### Runbook: Security Breach Response

**Objective**: Contain and remediate security breach

**Time**: Varies (2-8 hours typical)

**Steps**:
1. **Immediate containment**:
   - Disconnect affected server if active attack
   - Block attacking IPs in UFW
   - Change all passwords

2. **Assessment**:
   - Check `/var/log/auth.log` for unauthorized access
   - Check `.bash_history` for suspicious commands
   - Check `docker ps -a` for unauthorized containers
   - Check crontab: `crontab -l` and `/etc/cron.d/`

3. **Evidence collection**:
   - Copy all relevant logs
   - Take memory dump if needed: `sudo dd if=/dev/mem of=/tmp/memory.dump`
   - Document timeline

4. **Remediation**:
   - Remove unauthorized access
   - Patch vulnerability
   - Restore from known-good backup if needed
   - Implement additional security controls

5. **Verification**:
   - Full security audit
   - Monitor for 48 hours
   - Verify no persistent access

6. **Documentation**:
   - Create detailed incident report
   - Update security procedures
   - Share lessons learned

### Runbook: Certificate Expiry

**Objective**: Renew expired or expiring certificate

**Time**: 15 minutes

**Steps**:
1. Check certificate status:
   ```bash
   echo | openssl s_client -connect <domain>:443 2>/dev/null | openssl x509 -noout -dates
   ```

2. If expired or <30 days:
   ```bash
   # Restart Traefik to force renewal
   docker restart traefik
   
   # Check logs
   docker logs traefik | grep -i certificate
   ```

3. If renewal fails:
   - Check DNS is pointing to server
   - Check port 80/443 are accessible
   - Check Cloudflare proxy settings
   - Check Let's Encrypt rate limits

4. Manual renewal (if automatic fails):
   ```bash
   # Use certbot directly
   sudo certbot certonly --standalone -d <domain>
   # Then copy cert to Traefik
   ```

### Runbook: Disk Space Full

**Objective**: Free up disk space

**Time**: 15-30 minutes

**Steps**:
1. Identify large files/directories:
   ```bash
   du -sh /* | sort -h | tail -20
   du -sh /var/* | sort -h | tail -20
   ```

2. Clean Docker:
   ```bash
   docker system prune -a --volumes -f
   docker image prune -a -f
   ```

3. Clean logs:
   ```bash
   sudo journalctl --vacuum-time=7d
   find /var/log -name "*.log" -mtime +30 -delete
   ```

4. Clean package cache:
   ```bash
   sudo apt-get clean
   sudo apt-get autoclean
   ```

5. If still full, identify and move/delete:
   - Old backups
   - Large log files
   - Unused Docker volumes
   - Old mail archives (Mailcow)

---

## CONTACTS & RESOURCES

### Internal Resources

- **Monitoring**: https://grafana.qui3tly.cloud
- **Docker Management**: https://portainer.quietly.its.me
- **Mail Admin**: https://mail.quietly.online/admin
- **Documentation**: `/home/qui3tly/.docs/`
- **Git Repository**: https://github.com/quietly007/

### External Resources

- **Traefik Docs**: https://doc.traefik.io/traefik/
- **Mailcow Docs**: https://docs.mailcow.email/
- **Prometheus Docs**: https://prometheus.io/docs/
- **Grafana Docs**: https://grafana.com/docs/

### Useful Commands Cheatsheet

```bash
# Quick service restart
docker restart <container>

# View logs
docker logs -f <container>

# Check resource usage
docker stats

# Shell into container
docker exec -it <container> bash

# Restart all services
docker compose restart

# Update container
docker compose pull && docker compose up -d

# Check open ports
ss -tlnp

# Check firewall
sudo ufw status numbered

# Check failed logins
sudo grep "Failed password" /var/log/auth.log

# Check disk usage
df -h
du -sh /var/*
```

---

## CHANGE LOG

**2026-01-28**: Initial version 1.0
- Created master operations guide
- Documented all procedures
- Added runbooks for common scenarios
- Security grade: 96/100 (A+)

---

## APPENDIX: KEY METRICS TO MONITOR

### System Health
- [ ] CPU usage < 80%
- [ ] Memory usage < 90%
- [ ] Disk usage < 85%
- [ ] Network latency < 50ms
- [ ] Service uptime > 99.5%

### Security
- [ ] No critical CVEs unpatched
- [ ] All services using TLS
- [ ] SSH key-only authentication
- [ ] Firewall rules current
- [ ] No suspicious login attempts

### Mail Server
- [ ] Mail queue < 50 messages
- [ ] Spam rejection rate > 85%
- [ ] No viruses detected
- [ ] DKIM/SPF/DMARC passing
- [ ] No blacklist listings

### Monitoring
- [ ] All targets scraped successfully
- [ ] No firing critical alerts
- [ ] Dashboards loading < 3s
- [ ] Logs being ingested
- [ ] Alert notifications working

---

**END OF MASTER OPERATIONS GUIDE**

*This is a living document. Update regularly with new procedures and lessons learned.*
