# EXTERNAL AUDIT REQUEST: Complete Mail System Audit - Mailcow

**Date**: 2026-01-29  
**Requestor**: qui3tly  
**Type**: Read-Only Comprehensive Mail System Functional Audit  
**Target Grade**: A+++ (Perfect Mail Functionality)  
**Report Location**: `.reports/audits/mail/$(date +%Y%m%d-%H%M%S)/`

---

## 🎯 AUDIT OBJECTIVE

Perform **complete functional audit** of Mailcow email system:
- Mail sending/receiving functionality
- All 18 Mailcow containers health
- SMTP/IMAP/POP3 services
- Webmail (SOGo) functionality
- DNS records (SPF, DKIM, DMARC, MX, PTR)
- Anti-spam (Rspamd) effectiveness
- Antivirus (ClamAV) status
- Mail queue health
- Database integrity
- Certificate validity
- Performance and deliverability
- User accounts and quotas
- Backup and recovery
- Mobile sync (ActiveSync)
- Compliance (GDPR, email best practices)

**Goal**: Ensure perfect email functionality, deliverability, security, and user experience.

---

## 📧 COMPREHENSIVE MAIL AUDIT

### 1. MAILCOW INFRASTRUCTURE

#### All 18 Containers Status
```bash
ssh lady << 'EOF'
cd ~/.docker-compose/mailcow

# Container status
docker compose ps

# Detailed health
for container in $(docker compose ps --format json | jq -r '.Name'); do
  status=$(docker inspect $container | jq -r '.[0].State.Health.Status // "no healthcheck"')
  echo "$container: $status"
done

# Restart count
for container in $(docker compose ps -q); do
  name=$(docker inspect $container | jq -r '.[0].Name')
  restarts=$(docker inspect $container | jq -r '.[0].RestartCount')
  echo "$name: $restarts restarts"
done
EOF

# Analyze each container
- [ ] **acme-mailcow**: Cert renewal working?
- [ ] **clamd-mailcow**: Antivirus running, signatures updated?
- [ ] **dockerapi-mailcow**: API responding?
- [ ] **dovecot-mailcow**: IMAP/POP3 working?
- [ ] **ipv6nat-mailcow**: IPv6 NAT functional (if needed)?
- [ ] **memcached-mailcow**: Cache working?
- [ ] **mysql-mailcow**: Database healthy?
- [ ] **netfilter-mailcow**: Firewall rules applied?
- [ ] **nginx-mailcow**: Web UI accessible?
- [ ] **ofelia-mailcow**: Cron jobs running?
- [ ] **olefy-mailcow**: Office doc scanning?
- [ ] **php-fpm-mailcow**: PHP processing?
- [ ] **postfix-mailcow**: SMTP send/receive?
- [ ] **redis-mailcow**: Cache/sessions working?
- [ ] **rspamd-mailcow**: Spam filtering, DKIM signing?
- [ ] **sogo-mailcow**: Webmail UI working?
- [ ] **solr-mailcow**: Email search indexing?
- [ ] **watchdog-mailcow**: Monitoring and auto-healing?
```

---

### 2. MAIL FUNCTIONALITY TESTS

#### Send Test Email
```bash
ssh lady << 'EOF'
# Send test email from command line
echo "Test email from qui3tly.cloud mailcow - $(date)" | mail -s "Test Email $(date +%Y%m%d-%H%M%S)" test@example.com

# Check if sent
docker compose exec postfix-mailcow mailq
docker compose exec postfix-mailcow tail -f /var/log/syslog | grep "test@example.com"
EOF

# Analyze
- [ ] Email sent successfully?
- [ ] No errors in Postfix logs?
- [ ] Delivery time acceptable (<30s)?
- [ ] DKIM signature applied?
```

#### Receive Test Email
```bash
# Send email TO qui3tly.online address from external service (Gmail, etc.)
# Then check receipt

ssh lady << 'EOF'
# Check received email
docker compose exec dovecot-mailcow doveadm search -u youruser@quietly.online ALL | tail -5

# Check logs
docker compose exec postfix-mailcow tail -100 /var/log/syslog | grep "from=.*to=.*status=sent"
EOF

# Analyze
- [ ] Email received successfully?
- [ ] Spam filtering working?
- [ ] Delivered to correct mailbox?
- [ ] Indexed by Solr for search?
```

#### Webmail Access Test
```bash
# Access webmail UI
curl -I https://mail.quietly.online

# Login test (manual)
# https://mail.quietly.online

# Analyze
- [ ] Webmail accessible?
- [ ] Login working?
- [ ] Inbox loading?
- [ ] Can compose and send?
- [ ] Contacts working?
- [ ] Calendar working (if needed)?
```

#### SMTP Authentication Test
```bash
# Test SMTP AUTH
openssl s_client -connect mail.quietly.online:465 -crlf << EOF
EHLO test
AUTH LOGIN
<base64 username>
<base64 password>
MAIL FROM:<sender@quietly.online>
RCPT TO:<recipient@example.com>
DATA
Subject: Test

Test message.
.
QUIT
EOF

# Analyze
- [ ] SMTP authentication working?
- [ ] TLS connection established?
- [ ] AUTH LOGIN supported?
- [ ] Mail accepted?
```

#### IMAP/POP3 Test
```bash
# IMAP test
openssl s_client -connect mail.quietly.online:993 -crlf << EOF
a1 LOGIN user@quietly.online password
a2 LIST "" "*"
a3 SELECT INBOX
a4 FETCH 1:5 (FLAGS)
a5 LOGOUT
EOF

# POP3 test (if enabled)
openssl s_client -connect mail.quietly.online:995 -crlf << EOF
USER user@quietly.online
PASS password
STAT
LIST
QUIT
EOF

# Analyze
- [ ] IMAP working?
- [ ] Folders accessible?
- [ ] Messages fetched correctly?
- [ ] POP3 working (if needed)?
```

---

### 3. DNS CONFIGURATION AUDIT

#### MX Records
```bash
dig MX quietly.online +short
dig MX quietly.its.me +short

# Analyze
- [ ] MX records point to correct server (mail.quietly.online)?
- [ ] Priority correct (10)?
- [ ] Multiple MX for redundancy (if needed)?
```

#### A/AAAA Records
```bash
dig A mail.quietly.online +short
dig AAAA mail.quietly.online +short

# Analyze
- [ ] A record points to Lady IP: 207.180.251.111?
- [ ] AAAA record (IPv6) if used?
- [ ] Records match server IP?
```

#### PTR (Reverse DNS)
```bash
dig -x 207.180.251.111 +short

# Analyze
- [ ] PTR record exists?
- [ ] PTR matches hostname (mail.quietly.online)?
- [ ] Critical for deliverability
```

#### SPF Record
```bash
dig TXT quietly.online +short | grep spf
dig TXT quietly.its.me +short | grep spf

# Expected: "v=spf1 mx a ~all" or similar

# Analyze
- [ ] SPF record exists?
- [ ] Authorizes mail server?
- [ ] Policy appropriate (soft fail ~all or hard fail -all)?
- [ ] Not overly permissive?
```

#### DKIM Record
```bash
dig TXT default._domainkey.quietly.online +short
dig TXT dkim._domainkey.quietly.online +short

# Analyze
- [ ] DKIM record published?
- [ ] Public key present (v=DKIM1; k=rsa; p=...)?
- [ ] Matches Mailcow generated key?
```

#### DMARC Record
```bash
dig TXT _dmarc.quietly.online +short
dig TXT _dmarc.quietly.its.me +short

# Expected: "v=DMARC1; p=quarantine; rua=mailto:..."

# Analyze
- [ ] DMARC record exists?
- [ ] Policy (p=) set? (none/quarantine/reject)
- [ ] Reporting email (rua=) configured?
- [ ] Subdomain policy (sp=)?
```

#### DNSBL Check
```bash
# Check if IP blacklisted
for bl in zen.spamhaus.org b.barracudacentral.org bl.spamcop.net; do
  result=$(dig +short $(echo 207.180.251.111 | awk -F. '{print $4"."$3"."$2"."$1}').$bl)
  if [ -n "$result" ]; then
    echo "⚠️ LISTED in $bl: $result"
  else
    echo "✅ Not listed in $bl"
  fi
done

# Analyze
- [ ] IP not blacklisted?
- [ ] If listed, delisting process?
```

---

### 4. ANTI-SPAM & ANTIVIRUS

#### Rspamd (Anti-Spam) Status
```bash
ssh lady << 'EOF'
# Rspamd status
docker compose exec rspamd-mailcow rspamadm stat

# Spam statistics
docker compose exec rspamd-mailcow rspamadm stat | grep -E "Messages|Ham|Spam"

# DKIM signing status
docker compose exec rspamd-mailcow rspamadm dkim_keygen -l -s default -d quietly.online

# Check Bayes database
docker compose exec rspamd-mailcow rspamadm statfile
EOF

# Analyze
- [ ] Rspamd running and processing mail?
- [ ] Ham/Spam ratio reasonable?
- [ ] DKIM signing working?
- [ ] Bayes filter trained?
- [ ] Rules up-to-date?
```

#### ClamAV (Antivirus) Status
```bash
ssh lady << 'EOF'
# ClamAV status
docker compose exec clamd-mailcow clamdscan --version

# Signature database
docker compose exec clamd-mailcow sigtool --info /var/lib/clamav/main.cvd
docker compose exec clamd-mailcow sigtool --info /var/lib/clamav/daily.cld

# Recent scans
docker compose logs clamd-mailcow --tail 100 | grep -i "scan\|virus"
EOF

# Analyze
- [ ] ClamAV running?
- [ ] Signatures updated (daily)?
- [ ] Scanning incoming/outgoing mail?
- [ ] Viruses detected (count)?
- [ ] Performance acceptable?
```

#### Greylisting
```bash
ssh lady << 'EOF'
# Check greylisting status
docker compose exec postfix-mailcow postconf | grep greylist
EOF

# Analyze
- [ ] Greylisting enabled?
- [ ] Effective against spam?
- [ ] Delay acceptable for users?
```

---

### 5. MAIL QUEUE & DELIVERY

#### Postfix Queue
```bash
ssh lady << 'EOF'
# Queue status
docker compose exec postfix-mailcow mailq

# Queue count
docker compose exec postfix-mailcow qshape

# Stuck emails?
docker compose exec postfix-mailcow postqueue -p | grep MAILER-DAEMON
EOF

# Analyze
- [ ] Queue empty or small (<100 emails)?
- [ ] No stuck emails (days old)?
- [ ] Delivery working?
- [ ] Bounce rate acceptable?
```

#### Mail Logs Analysis
```bash
ssh lady << 'EOF'
# Sent emails (last 24h)
docker compose exec postfix-mailcow grep "status=sent" /var/log/syslog | tail -50

# Rejected emails
docker compose exec postfix-mailcow grep "reject" /var/log/syslog | tail -50

# Deferred emails
docker compose exec postfix-mailcow grep "status=deferred" /var/log/syslog | tail -20

# Bounce rate
sent=$(docker compose exec postfix-mailcow grep -c "status=sent" /var/log/syslog)
bounced=$(docker compose exec postfix-mailcow grep -c "status=bounced" /var/log/syslog)
echo "Sent: $sent, Bounced: $bounced, Rate: $(echo "scale=2; $bounced*100/$sent" | bc)%"
EOF

# Analyze
- [ ] Delivery success rate >95%?
- [ ] Rejection reasons valid?
- [ ] Deferrals temporary (retry working)?
- [ ] Bounce rate <5%?
```

---

### 6. USER ACCOUNTS & MAILBOXES

#### User Management
```bash
ssh lady << 'EOF'
# List mailboxes
docker compose exec mysql-mailcow mysql -u mailcow -p$DBPASS mailcow -e "SELECT username, domain, quota, active FROM mailbox;"

# Quota usage
docker compose exec dovecot-mailcow doveadm quota get -A

# Active users (logged in recently)
docker compose exec dovecot-mailcow doveadm who
EOF

# Analyze
- [ ] All expected users exist?
- [ ] User quotas appropriate?
- [ ] No users over quota?
- [ ] Active/inactive status correct?
- [ ] No unauthorized accounts?
```

#### Mailbox Integrity
```bash
ssh lady << 'EOF'
# Check mailbox errors
docker compose exec dovecot-mailcow doveadm -A mailbox status -t all INBOX

# Repair if needed
# docker compose exec dovecot-mailcow doveadm force-resync -A INBOX
EOF

# Analyze
- [ ] All mailboxes accessible?
- [ ] No corruption?
- [ ] Message counts reasonable?
```

---

### 7. WEBMAIL (SOGo) FUNCTIONALITY

#### SOGo Status
```bash
ssh lady << 'EOF'
# SOGo logs
docker compose logs sogo-mailcow --tail 200 | grep -i error

# Access test
curl -I https://mail.quietly.online
EOF

# Manual testing needed
- [ ] Login page accessible?
- [ ] User can login?
- [ ] Inbox loads and displays correctly?
- [ ] Can read emails?
- [ ] Can compose and send emails?
- [ ] Attachments work (send/receive)?
- [ ] Contacts accessible?
- [ ] Calendar functional (if needed)?
- [ ] Search working (Solr)?
- [ ] Settings accessible?
- [ ] Multi-folder support?
- [ ] Mobile view responsive?
```

#### ActiveSync (Mobile)
```bash
ssh lady << 'EOF'
# ActiveSync logs
docker compose logs sogo-mailcow --tail 100 | grep -i activesync

# Check enabled
docker compose exec mysql-mailcow mysql -u mailcow -p$DBPASS mailcow -e "SELECT username, active, sogo_access FROM mailbox WHERE sogo_access = 1;"
EOF

# Manual testing
- [ ] ActiveSync enabled for accounts?
- [ ] Can add account to mobile (iOS/Android)?
- [ ] Emails sync to mobile?
- [ ] Contacts sync (if enabled)?
- [ ] Calendar sync (if enabled)?
- [ ] Push notifications working?
```

---

### 8. DATABASE & STORAGE

#### MySQL Health
```bash
ssh lady << 'EOF'
# Database size
docker compose exec mysql-mailcow mysql -u root -p$MYSQL_ROOT_PASSWORD -e "
SELECT 
  table_schema as 'Database',
  ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'Size (MB)'
FROM information_schema.tables
WHERE table_schema = 'mailcow'
GROUP BY table_schema;"

# Table status
docker compose exec mysql-mailcow mysql -u root -p$MYSQL_ROOT_PASSWORD mailcow -e "SHOW TABLE STATUS;"

# Connection stats
docker compose exec mysql-mailcow mysql -u root -p$MYSQL_ROOT_PASSWORD -e "SHOW STATUS LIKE '%connect%';"
EOF

# Analyze
- [ ] Database size reasonable?
- [ ] Tables healthy (no crashes)?
- [ ] Connections stable?
- [ ] No slow queries?
```

#### Mail Storage
```bash
ssh lady << 'EOF'
# Mail volume size
du -sh ~/.docker-compose/mailcow/vmail-vol-1/

# Per-domain storage
du -sh ~/.docker-compose/mailcow/vmail-vol-1/*/*/

# Growth rate
# (compare with last week)
EOF

# Analyze
- [ ] Storage usage acceptable?
- [ ] Growth rate sustainable?
- [ ] Quota enforcement working?
- [ ] Cleanup policy (delete old mail)?
```

---

### 9. CERTIFICATES & TLS

#### SSL Certificates
```bash
ssh lady << 'EOF'
# Check certificate validity
docker compose exec nginx-mailcow openssl x509 -in /etc/ssl/mail/cert.pem -noout -dates -subject

# ACME renewal status
docker compose logs acme-mailcow --tail 100

# Test TLS
openssl s_client -connect mail.quietly.online:443 -servername mail.quietly.online < /dev/null | grep -E "subject|issuer|Verify"
EOF

# Analyze
- [ ] Certificate valid (not expired)?
- [ ] Certificate covers all needed domains?
- [ ] Issued by Let's Encrypt?
- [ ] Auto-renewal working?
- [ ] TLS version appropriate (1.2+)?
- [ ] Cipher suite secure?
```

#### SMTP TLS
```bash
# Test STARTTLS
openssl s_client -connect mail.quietly.online:25 -starttls smtp

# Test implicit TLS (port 465)
openssl s_client -connect mail.quietly.online:465

# Analyze
- [ ] STARTTLS available on port 25/587?
- [ ] Implicit TLS on port 465?
- [ ] TLS enforced (not optional)?
- [ ] Certificate valid for SMTP?
```

---

### 10. BACKUP & RECOVERY

#### Backup Status
```bash
ssh lady << 'EOF'
# Check backup script/cron
crontab -l | grep mailcow

# Recent backups
ls -lh /path/to/mailcow/backups/ | head -10

# Backup size
du -sh /path/to/mailcow/backups/
EOF

# Analyze
- [ ] Automated backups configured?
- [ ] Backup frequency (daily?)?
- [ ] Backup includes:
  - [ ] MySQL database?
  - [ ] Mail volumes (vmail)?
  - [ ] Configuration files?
  - [ ] Rspamd data?
- [ ] Backup retention appropriate?
- [ ] Offsite backup (to Master)?
```

#### Recovery Testing
```bash
# Test restore procedure (read-only audit)
# Document the restore process

# Analyze
- [ ] Recovery procedure documented?
- [ ] Recovery tested recently?
- [ ] RTO (Recovery Time Objective) acceptable?
- [ ] RPO (Recovery Point Objective) acceptable?
- [ ] Restore from backup works?
```

---

## 📊 DELIVERABLES

**🚨 MANDATORY**: After completing this audit, you MUST provide a comprehensive action plan with detailed TODO list saved in `.reports/MAIL_SYSTEM.md/ACTION_PLAN_TODO.md` containing:
- Prioritized tasks (🔴 Critical → 🟡 High → 🟢 Medium → ⚪ Low)
- Exact commands to execute
- Time estimates per task
- Total effort summary
- Dependencies between tasks
- Implementation order

Create in `.reports/audits/mail/YYYYMMDD-HHMMSS/`:

### 1. EXECUTIVE_SUMMARY.md
- Overall mail system grade (A+ to F)
- Functionality status (sending/receiving)
- Deliverability score
- Critical issues
- User impact assessment
- Quick wins

### 2. INFRASTRUCTURE_HEALTH_REPORT.md
**All 18 Mailcow containers**:
- Status (running/stopped/unhealthy)
- Restart count
- Resource usage
- Logs analysis (errors, warnings)
- Health check status
- Recommendations per container

### 3. FUNCTIONALITY_TEST_REPORT.md
- Send test results
- Receive test results
- Webmail test results
- SMTP AUTH test results
- IMAP/POP3 test results
- ActiveSync test results
- Each test: ✅ Pass or ❌ Fail with details

### 4. DNS_CONFIGURATION_AUDIT.md
```markdown
## DNS Records Status

| Record Type | Domain | Expected | Actual | Status | Fix |
|-------------|--------|----------|--------|--------|-----|
| MX | quietly.online | mail.quietly.online | mail.quietly.online | ✅ | - |
| A | mail.quietly.online | 207.180.251.111 | 207.180.251.111 | ✅ | - |
| PTR | 207.180.251.111 | mail.quietly.online | (missing) | ❌ | Contact provider |
| SPF | quietly.online | v=spf1... | (correct) | ✅ | - |
| DKIM | default._domainkey | p=MII... | (correct) | ✅ | - |
| DMARC | _dmarc.quietly.online | v=DMARC1 | (missing) | ⚠️ | Add record |
```

### 5. SPAM_ANTIVIRUS_REPORT.md
- Rspamd statistics
- Spam/Ham ratio
- DKIM signing status
- ClamAV status
- Signature update frequency
- Detection effectiveness
- False positive rate
- Recommendations

### 6. DELIVERABILITY_ANALYSIS.md
- Mail queue status
- Delivery success rate
- Bounce rate
- Rejection reasons
- Blacklist check results
- Deliverability score (0-100)
- ISP-specific deliverability (Gmail, Outlook, Yahoo)
- Improvement recommendations

### 7. USER_EXPERIENCE_REPORT.md
- Webmail (SOGo) functionality
- Mobile sync (ActiveSync)
- User account status
- Quota management
- Search functionality
- Performance (load times)
- Issues reported by users
- UX improvements needed

### 8. SECURITY_COMPLIANCE_REPORT.md
- TLS/SSL status
- Certificate validity
- Authentication methods
- Encryption at rest/transit
- Access controls
- GDPR compliance
- Email best practices compliance
- Security recommendations

### 9. BACKUP_RECOVERY_ASSESSMENT.md
- Backup configuration
- Backup frequency and retention
- Backup completeness (what's backed up)
- Recovery procedure documented
- Recovery tested (when, result)
- RTO/RPO analysis
- Offsite backup status
- Recommendations

### 10. MAIL_IMPROVEMENT_TODO.md
**Prioritized action plan**:

#### 🔴 CRITICAL (Fix Immediately)
- [ ] PTR record missing - deliverability impacted (Contact provider - 1 day)
- [ ] DMARC record missing - add now (5 minutes)
- [ ] Certificate expires in 5 days - renew (30 minutes)

#### 🟡 HIGH PRIORITY (This Week)
- [ ] Mailbox X over quota - increase or clean (30 min)
- [ ] ActiveSync not working for iOS - fix (2 hours)

#### 🟢 MEDIUM PRIORITY (This Month)
- [ ] Improve spam filter training (4 hours)
- [ ] Set up offsite backup (3 hours)

#### ⚪ LOW PRIORITY (When Time Permits)
- [ ] Add greylisting for additional spam protection (1 hour)
- [ ] Optimize SOGo performance (2 hours)

**Total Effort**: X hours for A+++ mail system

---

## ✅ AUDIT COMPLETION CRITERIA

- [ ] All 18 containers audited
- [ ] Send/receive tests completed
- [ ] DNS records verified
- [ ] Spam/antivirus checked
- [ ] Deliverability assessed
- [ ] User experience tested
- [ ] Backup/recovery reviewed
- [ ] All 10 reports created
- [ ] Action plan with exact commands

---

## 🚫 AUDIT CONSTRAINTS

**READ-ONLY**: Do NOT:
- ❌ Send actual mail to production addresses
- ❌ Change DNS records
- ❌ Modify user accounts
- ❌ Restart mail services
- ❌ Change configurations

**DO**:
- ✅ Test with designated test accounts
- ✅ Check all statuses
- ✅ Review all logs
- ✅ Verify all DNS records (read-only)
- ✅ Document every finding

---

## 🎯 TARGET METRICS (A+++ Mail System)

- **Deliverability**: >95% (not blacklisted, proper DNS)
- **Uptime**: 99.9%+
- **Queue**: <50 emails normally
- **Spam detection**: >95% accuracy, <1% false positives
- **Virus detection**: 100% of known viruses
- **Webmail response**: <2s load time
- **SMTP response**: <5s delivery acceptance
- **Backup**: Daily, tested recovery
- **User satisfaction**: No complaints

---

**AUDIT START**: Ready for external agent  
**EXPECTED DURATION**: 8-12 hours comprehensive mail audit  
**REPORT DELIVERY**: All 10 files in `.reports/audits/mail/TIMESTAMP/`  
**CRITICAL**: Mail is business-critical - perfect functionality required
