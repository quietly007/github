# EXTERNAL AUDIT REQUEST: Complete Security & Permissions Audit

**Date**: 2026-01-29  
**Requestor**: qui3tly  
**Type**: Read-Only Comprehensive Security & Permissions Audit  
**Target Grade**: A+++ (Maximum Security)  
**Report Location**: `.reports/audits/security/$(date +%Y%m%d-%H%M%S)/`

---

## 🎯 AUDIT OBJECTIVE

Perform **complete security and permissions audit** of entire qui3tly.cloud infrastructure:
- System security (OS, kernel, updates)
- File permissions (secrets, configs, data)
- User permissions (system users, service accounts)
- Container security (privileges, capabilities, images)
- Network security (firewall, exposure, segmentation)
- Authentication & authorization (SSO, 2FA, access control)
- Secret management (environment vars, files, vaults)
- SSL/TLS certificates
- Vulnerability assessment
- Compliance (GDPR, security best practices)
- Audit trails and logging

**Goal**: Achieve maximum security posture with proper permissions, zero vulnerabilities, defense in depth.

---

## 🔒 COMPREHENSIVE SECURITY AUDIT

### 1. SYSTEM SECURITY AUDIT

#### OS Security (Master)
```bash
# OS version and patches
lsb_release -a
uname -a
apt list --upgradable 2>/dev/null | wc -l

# Security updates
apt list --upgradable 2>/dev/null | grep -i security

# Kernel security
cat /proc/sys/kernel/dmesg_restrict
cat /proc/sys/kernel/kptr_restrict
cat /proc/sys/kernel/yama/ptrace_scope

# Analyze
- [ ] OS version current? (Debian 12 latest)
- [ ] All security patches applied?
- [ ] Kernel hardening enabled?
- [ ] No EOL packages?
```

#### User & Group Security
```bash
# User accounts
cat /etc/passwd | grep -v nologin | grep -v false
lastlog
faillog -a

# Sudoers
cat /etc/sudoers
ls -la /etc/sudoers.d/

# SSH keys
ls -la ~/.ssh/
cat ~/.ssh/authorized_keys

# Analyze
- [ ] No unnecessary user accounts?
- [ ] qui3tly user properly configured?
- [ ] No passwords allowed (SSH key-only)?
- [ ] Sudo privileges appropriate?
- [ ] No shared accounts?
- [ ] SSH keys secured (permissions 600)?
```

#### Firewall Configuration
```bash
# UFW status
ufw status verbose
ufw status numbered

# iptables rules
iptables -L -n -v
ip6tables -L -n -v

# fail2ban status
fail2ban-client status
fail2ban-client status sshd

# Analyze
- [ ] Firewall active and enabled?
- [ ] Default deny incoming?
- [ ] Only necessary ports open?
  - 22: SSH (restricted?)
  - 80: HTTP (Traefik)
  - 443: HTTPS (Traefik)
  - 1006: Headscale?
  - VPN ports?
- [ ] fail2ban protecting services?
- [ ] No unnecessary rules?
```

---

### 2. FILE & DIRECTORY PERMISSIONS

#### Critical System Files
```bash
# Permissions audit
ls -la /etc/passwd /etc/shadow /etc/group /etc/gshadow
ls -la /etc/ssh/sshd_config
ls -la /root/.ssh/

# Analyze
- [ ] /etc/shadow: 640 or 600? ✅
- [ ] /etc/passwd: 644 ✅
- [ ] SSH config: 644 ✅
- [ ] Root SSH keys: 600 ✅
```

#### Docker & Compose Files
```bash
# Docker socket
ls -la /var/run/docker.sock

# Compose files
find ~/.docker-compose -name "docker-compose.y*ml" -exec ls -la {} \;
find ~/.docker-compose -name ".env" -exec ls -la {} \;

# Analyze
- [ ] docker.sock: 660 (root:docker) - who has docker group?
- [ ] Compose files: 644 (readable but not writable by others)
- [ ] .env files: **600** (CRITICAL - secrets inside)
```

#### Secrets & Credentials
```bash
# Find secret files
find /home/qui3tly -type f -name "*secret*" -o -name "*password*" -o -name "*key*" -o -name "*.key" -o -name "*token*" 2>/dev/null | head -50

# Check permissions
for file in $(find ~/.docker-compose -name "*.key" -o -name "*secret*" -o -name "*token" 2>/dev/null); do
  echo "$file: $(stat -c '%a %U:%G' $file)"
done

# Cloudflare tokens
ls -la ~/.docker-compose/*/cf-token

# API keys
grep -r "api_key\|apikey\|api-key" ~/.docker-compose/*/docker-compose.yml 2>/dev/null

# Analyze
- [ ] All secret files: **600 qui3tly:qui3tly** (MANDATORY)
- [ ] No secrets in git?
- [ ] No secrets in docker-compose (use env vars)?
- [ ] Secrets not world-readable?
- [ ] Encryption at rest for secrets?
```

#### Docker Volumes
```bash
# Volume permissions
for vol in $(docker volume ls -q); do
  echo "=== $vol ==="
  ls -la /var/lib/docker/volumes/$vol/_data | head -5
done

# Analyze
- [ ] Volume ownership correct?
- [ ] No world-writable volumes?
- [ ] Sensitive data volumes: restricted permissions?
```

---

### 3. CONTAINER SECURITY

#### Privileged Containers
```bash
# Check ALL containers for privileged mode
for container in $(docker ps -a --format "{{.Names}}"); do
  priv=$(docker inspect $container | jq -r '.[0].HostConfig.Privileged')
  if [ "$priv" = "true" ]; then
    echo "⚠️ PRIVILEGED: $container"
  fi
done

# Check capabilities
for container in $(docker ps --format "{{.Names}}"); do
  echo "=== $container ==="
  docker inspect $container | jq '.[0].HostConfig.CapAdd'
done

# Analyze
- [ ] cAdvisor privileged? **SECURITY RISK** - necessary?
- [ ] Any other privileged containers? **REVIEW EACH**
- [ ] Extra capabilities needed? (SYS_ADMIN, NET_ADMIN, etc.)
- [ ] Can privileges be reduced?
```

#### Container User (Running as Root?)
```bash
# Check user for each container
for container in $(docker ps --format "{{.Names}}"); do
  user=$(docker inspect $container | jq -r '.[0].Config.User')
  echo "$container: ${user:-root}"
done

# Analyze
- [ ] How many containers run as root?
- [ ] Which SHOULD NOT run as root?
- [ ] User IDs appropriate?
- [ ] No UID 0 unless necessary?
```

#### Image Security
```bash
# Image versions
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.CreatedAt}}"

# Check for "latest" tag (bad practice)
docker images | grep latest

# Base images
for image in $(docker images --format "{{.Repository}}:{{.Tag}}"); do
  docker inspect $image | jq -r '.[0].Config.Image // .[0].RepoTags[0]'
done

# Analyze
- [ ] Using specific versions (not "latest")?
- [ ] Images from trusted sources?
- [ ] Official images preferred?
- [ ] Images up-to-date?
- [ ] Known CVEs in images? (need scanner)
```

#### Network Exposure
```bash
# Port exposure
for container in $(docker ps --format "{{.Names}}"); do
  echo "=== $container ==="
  docker port $container
  docker inspect $container | jq -r '.[0].NetworkSettings.Ports'
done

# Network mode
for container in $(docker ps --format "{{.Names}}"); do
  mode=$(docker inspect $container | jq -r '.[0].HostConfig.NetworkMode')
  echo "$container: $mode"
done

# Analyze
- [ ] Only necessary ports exposed?
- [ ] No ports exposed to 0.0.0.0 unnecessarily?
- [ ] Host network mode: who and why?
- [ ] Internal services not exposed?
```

---

### 4. AUTHENTICATION & AUTHORIZATION

#### SSH Security
```bash
# SSH config
cat /etc/ssh/sshd_config | grep -E "PermitRootLogin|PasswordAuthentication|PubkeyAuthentication|Port|AllowUsers"

# Recent SSH attempts
journalctl -u ssh --since "7 days ago" | grep -i "failed\|invalid" | wc -l
journalctl -u ssh --since "7 days ago" | grep "Accepted publickey" | wc -l

# Analyze
- [ ] PermitRootLogin: **no** ✅
- [ ] PasswordAuthentication: **no** ✅
- [ ] PubkeyAuthentication: **yes** ✅
- [ ] AllowUsers: restricted? (who can SSH?)
- [ ] Non-standard port? (security through obscurity)
- [ ] Failed login attempts reasonable?
```

#### Authelia (SSO) Security
```bash
# Authelia config
docker exec authelia cat /config/configuration.yml | grep -E "secret|password|jwt|session"

# Check 2FA status
docker logs authelia --tail 500 | grep -i "2fa\|totp"

# Analyze
- [ ] JWT secret properly set (not default)?
- [ ] Session secret strong?
- [ ] 2FA enforced for all users?
- [ ] Password requirements strong?
- [ ] Session timeout appropriate?
- [ ] Remember device secure?
```

#### Service Authentication
```bash
# Check each service authentication
# Grafana
docker exec grafana cat /etc/grafana/grafana.ini | grep -E "auth\|admin"

# Portainer
docker logs portainer | grep -i "admin\|password"

# Check default credentials
# List services with web UI
echo "Services to check for default passwords:"
echo "- Grafana (admin:admin?)"
echo "- Portainer (admin:password?)"
echo "- Semaphore (?)"
echo "- UniFi (ubnt:ubnt?)"
echo "- UISP (?)"

# Analyze
- [ ] All default passwords changed?
- [ ] Strong passwords enforced?
- [ ] 2FA enabled where possible?
- [ ] API keys rotated regularly?
- [ ] Admin accounts limited?
```

#### Traefik Middleware Security
```bash
# Check Authelia middleware
docker exec traefik cat /etc/traefik/dynamic/*.yml | grep -A10 "authelia"

# Check IP whitelist (if any)
docker exec traefik cat /etc/traefik/dynamic/*.yml | grep -A5 "ipWhiteList"

# Analyze
- [ ] Authelia protecting sensitive services?
- [ ] Which services require authentication?
- [ ] Which services are public?
- [ ] IP restrictions where needed?
```

---

### 5. SECRET MANAGEMENT

#### Environment Variables (Docker Compose)
```bash
# Check for secrets in environment
for file in $(find ~/.docker-compose -name "docker-compose.y*ml"); do
  echo "=== $file ==="
  grep -E "environment:" -A20 $file | grep -E "PASSWORD|SECRET|KEY|TOKEN" || echo "  None found"
done

# Check .env files
for file in $(find ~/.docker-compose -name ".env"); do
  echo "=== $file ==="
  ls -la $file
  cat $file | wc -l
done

# Analyze
- [ ] Secrets in environment vars (visible in docker inspect)?
- [ ] Using .env files (better but still visible)?
- [ ] Should use Docker secrets or vault?
- [ ] Secrets rotation process?
```

#### Secrets in Git
```bash
# Check git history for secrets
cd ~/.github
git log --all --full-history -- "**/*secret*" "**/*password*" "**/*.key"

# Check current files
git ls-files | xargs grep -l "password\|secret\|api_key" 2>/dev/null | grep -v ".md"

# Analyze
- [ ] No secrets committed to git?
- [ ] .gitignore properly configured?
- [ ] Secret files in .gitignore?
- [ ] Past secrets rotated (if leaked)?
```

#### SSL/TLS Certificates
```bash
# Certificate locations
find /home/qui3tly -name "*.crt" -o -name "*.pem" -o -name "*.key" 2>/dev/null | head -20

# Let's Encrypt certificates
docker exec traefik ls -la /letsencrypt/

# Certificate validity
echo | openssl s_client -servername quietly.its.me -connect quietly.its.me:443 2>/dev/null | openssl x509 -noout -dates

# Analyze
- [ ] All certificates valid?
- [ ] Expiration dates > 30 days?
- [ ] Automatic renewal working (Let's Encrypt)?
- [ ] Private keys secured (600 permissions)?
- [ ] No self-signed certs in production?
```

---

### 6. NETWORK SECURITY

#### Exposed Services Inventory
```bash
# Externally accessible services
curl -s https://quietly.its.me/.well-known/security.txt

# Nmap from outside (if allowed)
# nmap -p 1-65535 213.136.68.108

# Shodan/SecurityTrails check (manual)

# List all Traefik routes
docker exec traefik cat /etc/traefik/dynamic/*.yml | grep "rule:"

# Analyze
- [ ] Only intended services exposed?
- [ ] No admin panels public?
- [ ] No database ports exposed (3306, 5432, 6379)?
- [ ] No Docker API exposed (2375, 2376)?
- [ ] Monitoring endpoints protected?
```

#### Internal Network Segmentation
```bash
# Docker networks
docker network ls
for net in $(docker network ls -q); do
  echo "=== $net ==="
  docker network inspect $net | jq -r '.[0].Name, .[0].Driver, .[0].Containers'
done

# Analyze
- [ ] Services on appropriate networks?
- [ ] Sensitive services isolated?
- [ ] Database networks separate?
- [ ] No unnecessary network connections?
```

#### VPN Security (Tailscale/Headscale)
```bash
# Headscale ACLs
cat /etc/headscale/acl.json

# Connected nodes
headscale nodes list

# Routes
headscale routes list

# Analyze
- [ ] ACLs properly configured?
- [ ] Only authorized nodes?
- [ ] Exit nodes secured?
- [ ] Subnet routing appropriate?
- [ ] No overly permissive rules?
```

---

### 7. LOGGING & AUDIT TRAILS

#### Audit Logging
```bash
# System auth logs
tail -100 /var/log/auth.log

# Docker events
docker events --since 7d --until now --format '{{.Time}} {{.Action}} {{.Actor.Attributes.name}}' | tail -50

# Sudo usage
grep sudo /var/log/auth.log | tail -20

# Analyze
- [ ] All admin actions logged?
- [ ] Logs centralized (Loki)?
- [ ] Retention period adequate (30 days)?
- [ ] Logs protected from tampering?
- [ ] Who accessed what and when visible?
```

#### Security Event Logging
```bash
# Failed login attempts
journalctl -u ssh --since "7 days ago" | grep "Failed password" | wc -l

# fail2ban actions
fail2ban-client status sshd

# CrowdSec decisions
docker exec crowdsec cscli decisions list

# Firewall logs
grep UFW /var/log/syslog | tail -50

# Analyze
- [ ] Failed logins monitored?
- [ ] Brute force attempts blocked?
- [ ] IPS/IDS detecting threats?
- [ ] Alerts on security events?
- [ ] Security logs separate from app logs?
```

---

### 8. VULNERABILITY ASSESSMENT

#### System Vulnerabilities
```bash
# Check for known vulnerabilities
apt list --upgradable 2>/dev/null | grep -i security | head -20

# Lynis security audit (if installed)
# lynis audit system

# Analyze
- [ ] Unpatched vulnerabilities?
- [ ] CVE database up-to-date?
- [ ] Security scanner results?
- [ ] Remediation timeline?
```

#### Container Vulnerabilities
```bash
# Image scanning (manual - use Trivy, Clair, etc.)
# trivy image traefik:latest

# Check Docker bench security
# docker run --rm -it --net host --pid host --userns host --cap-add audit_control \
#   -v /var/lib:/var/lib -v /var/run/docker.sock:/var/run/docker.sock \
#   docker/docker-bench-security

# Analyze
- [ ] Images scanned for vulnerabilities?
- [ ] Known CVEs in running containers?
- [ ] Base images vulnerable?
- [ ] Update plan for vulnerable images?
```

---

### 9. COMPLIANCE & BEST PRACTICES

#### Security Best Practices
- [ ] **Principle of Least Privilege**: Applied everywhere?
- [ ] **Defense in Depth**: Multiple security layers?
- [ ] **Fail Secure**: Defaults deny access?
- [ ] **Separation of Duties**: No single point of control?
- [ ] **Security by Design**: Built-in, not bolted-on?

#### CIS Benchmarks Compliance
- [ ] OS hardening (CIS Debian benchmark)
- [ ] Docker hardening (CIS Docker benchmark)
- [ ] SSH hardening
- [ ] Web server hardening

#### GDPR/Privacy Compliance
- [ ] Personal data identified?
- [ ] Data encryption at rest and transit?
- [ ] Access controls on personal data?
- [ ] Data retention policies?
- [ ] Right to erasure process?
- [ ] Data breach response plan?

---

### 10. MAILCOW SECURITY SPECIFIC

#### Mailcow Security Audit
```bash
ssh lady << 'EOF'
# Mailcow security check
cd ~/.docker-compose/mailcow
docker compose exec mysql-mailcow mysql -u root -p$MYSQL_ROOT_PASSWORD -e "SELECT * FROM mailbox WHERE active=1;" mailcow | wc -l

# Check for open relay
docker compose exec postfix-mailcow postfix check

# DKIM status
docker compose exec rspamd-mailcow rspamadm dkim_keygen -s default -d quietly.online

# SPF/DMARC
dig TXT quietly.online | grep spf
dig TXT _dmarc.quietly.online

# Check open ports
ss -tlnp | grep -E "25|465|587|993|995"
EOF

# Analyze
- [ ] No open relay configuration?
- [ ] DKIM signing working?
- [ ] SPF record correct?
- [ ] DMARC policy configured?
- [ ] TLS enforced for SMTP?
- [ ] Secure passwords for mailboxes?
- [ ] Anti-spam (Rspamd) working?
- [ ] Antivirus (ClamAV) updated?
```

---

## 📊 DELIVERABLES

**🚨 MANDATORY**: After completing this audit, you MUST provide a comprehensive action plan with detailed TODO list saved in `.reports/SECURITY_PERMISSIONS.md/ACTION_PLAN_TODO.md` containing:
- Prioritized tasks (🔴 Critical → 🟡 High → 🟢 Medium → ⚪ Low)
- Exact commands to execute
- Time estimates per task
- Total effort summary
- Dependencies between tasks
- Implementation order

Create in `.reports/audits/security/YYYYMMDD-HHMMSS/`:

### 1. EXECUTIVE_SUMMARY.md
- Overall security grade (A+ to F)
- Critical vulnerabilities (top 10)
- Permission issues (critical)
- Quick wins (immediate fixes)
- Risk assessment
- Compliance status

### 2. SYSTEM_SECURITY_REPORT.md
- OS security status
- User & group security
- Firewall configuration
- SSH security
- System hardening level
- Unpatched vulnerabilities
- Recommendations

### 3. FILE_PERMISSIONS_AUDIT.md
**Complete permissions inventory**:
```markdown
## Critical Files Permission Status

| File/Directory | Current | Required | Status | Risk | Action |
|----------------|---------|----------|--------|------|--------|
| /etc/shadow | 640 | 600-640 | ✅ OK | - | None |
| ~/.docker-compose/traefik/.env | 644 | 600 | ❌ CRITICAL | High | chmod 600 |
| ~/.docker-compose/*/cf-token | 600 | 600 | ✅ OK | - | None |
| ... | ... | ... | ... | ... | ... |
```

**Detailed per-service permissions**

### 4. CONTAINER_SECURITY_ANALYSIS.md
**For each of 54 containers**:
- Privileged mode status
- Running as root or user
- Capabilities granted
- Network exposure
- Image vulnerabilities
- Security score (A-F)
- Recommendations

### 5. AUTHENTICATION_AUTHORIZATION_REPORT.md
- SSH security status
- Authelia/SSO configuration
- 2FA status per service
- Default credentials check
- API key management
- Access control matrix
- Recommendations

### 6. SECRET_MANAGEMENT_AUDIT.md
- Secrets inventory
- Storage methods (env vars, files, vault)
- Permission status
- Git exposure check
- Rotation status
- Recommendations for vault/secrets management

### 7. NETWORK_SECURITY_REPORT.md
- Exposed services inventory
- Firewall rules analysis
- Network segmentation
- VPN security (Tailscale/Headscale)
- IDS/IPS status (CrowdSec)
- DDoS protection (Cloudflare)
- Recommendations

### 8. VULNERABILITY_ASSESSMENT_REPORT.md
- System vulnerabilities (CVEs)
- Container vulnerabilities
- Application vulnerabilities
- Severity classification (Critical/High/Medium/Low)
- Exploitability assessment
- Remediation plan with timelines

### 9. COMPLIANCE_CHECKLIST.md
- CIS Benchmark compliance
- GDPR compliance status
- Security best practices scorecard
- Industry standards (NIST, ISO 27001)
- Gap analysis
- Remediation roadmap

### 10. SECURITY_HARDENING_TODO.md
**Prioritized security action plan**:

#### 🔴 CRITICAL (Fix Immediately - 0-24 hours)
- [ ] File X: chmod 600 (world-readable secret) - 1 min
- [ ] Container Y: Remove privileged mode - 10 min
- [ ] Service Z: Change default password - 5 min
- [ ] Patch CVE-YYYY-XXXXX (critical vulnerability) - 30 min

#### 🟡 HIGH PRIORITY (This Week)
- [ ] Enable 2FA for all admin accounts - 2 hours
- [ ] Rotate API keys - 1 hour
- [ ] Update vulnerable images - 3 hours

#### 🟢 MEDIUM PRIORITY (This Month)
- [ ] Implement secrets vault - 8 hours
- [ ] Harden OS per CIS benchmark - 4 hours

#### ⚪ LOW PRIORITY (This Quarter)
- [ ] Security training documentation - 6 hours

**Total Estimated Effort**: X hours for A+++ security

---

## ✅ AUDIT COMPLETION CRITERIA

- [ ] Both servers fully audited
- [ ] All 54 containers security checked
- [ ] File permissions completely reviewed
- [ ] All secrets inventoried and secured
- [ ] Vulnerabilities identified
- [ ] Compliance assessed
- [ ] All 10 reports created
- [ ] Prioritized action plan with exact commands

---

## 🚫 AUDIT CONSTRAINTS

**READ-ONLY**: Do NOT:
- ❌ Change any permissions
- ❌ Rotate secrets
- ❌ Update systems
- ❌ Restart services
- ❌ Run vulnerability scans that impact production

**DO**:
- ✅ Check all permissions
- ✅ Review all configurations
- ✅ Identify security issues
- ✅ Document vulnerabilities
- ✅ Provide exact fix commands

---

## 🎯 TARGET SECURITY (A+++)

- **No critical vulnerabilities**
- **All secrets: 600 permissions**
- **No containers privileged (unless absolutely necessary)**
- **2FA enforced for all admins**
- **Firewall: default deny, minimal exposure**
- **All patches applied**
- **Audit logging comprehensive**
- **Compliance: 100% CIS, GDPR-ready**
- **Defense in depth: multiple security layers**

---

**AUDIT START**: Ready for external agent  
**EXPECTED DURATION**: 10-14 hours comprehensive security audit  
**REPORT DELIVERY**: All 10 files in `.reports/audits/security/TIMESTAMP/`  
**CRITICAL**: Security is paramount - every issue must be documented with exact fix
