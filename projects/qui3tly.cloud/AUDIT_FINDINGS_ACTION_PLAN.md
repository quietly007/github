# AUDIT FINDINGS ACTION PLAN - Jan 27 Audit
**Date**: 2026-01-28  
**Source**: External audit report (.reports/audit-20260127/)  
**Status**: Tracking and resolution

---

## 🔴 IMMEDIATE (Fix Today)

### 1. Secret File Permissions ⚠️ HIGH PRIORITY
**Issue**: Files in `.secrets/` are `0644` (world-readable), should be `0600`  
**Risk**: Sensitive credentials readable by all users  
**Time**: 5 minutes

```bash
find ~/.secrets -type f -exec chmod 0600 {} \;
find ~/.secrets -type f -exec ls -l {} \; | grep -v "^-rw-------"
```

**Success**: All secret files show `-rw-------` permissions

---

### 2. Failed Systemd Units 🔧 MEDIUM PRIORITY
**Issue**: `aide.service` failed; `pmlogger_*` and `podman-restart` units missing  
**Time**: 15 minutes

```bash
# Check failed units
systemctl --failed

# Fix or disable
sudo systemctl disable aide.service
sudo systemctl reset-failed
sudo systemctl daemon-reload
```

**Success**: `systemctl --failed` shows 0 failed units

---

### 3. CrowdSec Broken Symlinks 🔗 MEDIUM PRIORITY
**Issue**: Many broken symlinks under `.docker/crowdsec/`  
**Time**: 10 minutes

```bash
# Find broken symlinks
find ~/.docker/crowdsec -xtype l

# Regenerate hub content or clean up
cd ~/.docker-compose/crowdsec
docker compose exec crowdsec cscli hub update
docker compose exec crowdsec cscli hub upgrade
```

**Success**: No broken symlinks in CrowdSec directories

---

## 🟡 HIGH PRIORITY (This Week)

### 4. DNS Health Warnings 🌐 INVESTIGATE
**Issue**: Tailscale DNS health warning; Docker DNS timeouts to 1.1.1.1/8.8.8.8  
**Time**: 30 minutes investigation

```bash
# Check Tailscale DNS
tailscale status
tailscale ping 100.64.0.2

# Check Docker DNS
docker run --rm alpine nslookup google.com
docker run --rm alpine ping -c 3 1.1.1.1

# Check system DNS
systemd-resolve --status
cat /etc/resolv.conf
```

**Questions**:
- Is this a transient issue or persistent?
- Does it affect actual service operation?
- Are there firewall rules blocking DNS?

---

### 5. cAdvisor Privileged Container 🔒 SECURITY REVIEW
**Issue**: `cadvisor` runs with `Privileged=true`  
**Risk**: Elevated container privileges  
**Time**: 30 minutes

**Research**:
- Can cAdvisor run without privileged mode?
- What specific capabilities does it need?
- Alternative: Use `cap_add` with specific capabilities

```bash
# Check current config
docker inspect cadvisor | jq '.[0].HostConfig.Privileged'
docker inspect cadvisor | jq '.[0].HostConfig.CapAdd'

# Review compose file
cat ~/.docker-compose/monitoring/compose.yaml | grep -A5 cadvisor
```

**Decision**: Keep privileged if required for metrics, or reduce to specific capabilities

---

### 6. Missing Service Documentation 📚 DOCUMENTATION
**Issue**: Only 6 service docs exist for 23+ services  
**Priority Services Missing Docs**:
- Portainer (critical)
- Authelia (critical)
- Semaphore
- Grafana, Prometheus, Alertmanager, Loki, Promtail
- Gotify, Ntfy, Uptime Kuma
- Node-exporter, cAdvisor
- Cloudflared
- Headscale UI/Admin
- IT-Tools, Admin Panel
- fuckoff-page

**Time**: 4-8 hours total

**Approach**: Create one doc per day
- Day 1: PORTAINER.md
- Day 2: AUTHELIA.md  
- Day 3: SEMAPHORE.md
- Week 2: Monitoring stack components

---

## 🟢 MEDIUM PRIORITY (Next Week)

### 7. Project Plan Metadata Update 📊 DOCUMENTATION
**Issue**: MASTER_PLAN states ~43 containers; actual = 23 Master + 31 Lady = 54 total  
**Time**: 30 minutes

Update these files:
- `.github/projects/qui3tly.cloud/MASTER_PLAN.md`
- `.github/projects/qui3tly.cloud/RFP.md`
- `.docs/00-standards/INFRASTRUCTURE_OVERVIEW.md`

**Correction**: Document actual current state, not projected future state

---

## 📊 TRACKING

| Task | Priority | Status | Time | ETA |
|------|----------|--------|------|-----|
| Secret permissions | 🔴 Immediate | ⚪ Not started | 5 min | Today |
| Failed systemd units | 🔴 Immediate | ⚪ Not started | 15 min | Today |
| CrowdSec symlinks | 🔴 Immediate | ⚪ Not started | 10 min | Today |
| DNS investigation | 🟡 High | ⚪ Not started | 30 min | This week |
| cAdvisor review | 🟡 High | ⚪ Not started | 30 min | This week |
| Missing docs | 🟡 High | ⚪ Not started | 4-8 hrs | 2 weeks |
| Plan metadata | 🟢 Medium | ⚪ Not started | 30 min | Next week |

**Total Immediate Time**: 30 minutes  
**Total High Priority**: 5-9 hours  
**Total Medium Priority**: 30 minutes

---

## 🎯 DAILY PLAN

### Today (Jan 28)
- [ ] Fix secret permissions (5 min)
- [ ] Clean failed systemd units (15 min)
- [ ] Fix CrowdSec symlinks (10 min)
- **Total**: 30 minutes

### Tomorrow (Jan 29)
- [ ] Investigate DNS health warnings (30 min)
- [ ] Review cAdvisor privileges (30 min)
- **Total**: 1 hour

### This Week (Jan 30 - Feb 2)
- [ ] Create PORTAINER.md (1 hour)
- [ ] Create AUTHELIA.md (1 hour)
- [ ] Update project plan metadata (30 min)
- **Total**: 2.5 hours

---

## 📁 RELATED FILES

**Audit Reports**:
- [AUDIT_REPORT.md](../../.reports/audit-20260127/AUDIT_REPORT.md)
- [SECURITY_FINDINGS.md](../../.reports/audit-20260127/SECURITY_FINDINGS.md)
- [DOCUMENTATION_GAPS.md](../../.reports/audit-20260127/DOCUMENTATION_GAPS.md)
- [RECOMMENDATIONS.md](../../.reports/audit-20260127/RECOMMENDATIONS.md)

**Project Plans**:
- [WEEK1_ACTION_PLAN.md](./WEEK1_ACTION_PLAN.md)
- [MASTER_PLAN.md](./MASTER_PLAN.md)
- [UPDATED_STATUS_2026-01-28.md](./UPDATED_STATUS_2026-01-28.md)

---

## ✅ COMPLETION CHECKLIST

**Immediate Tasks Complete When**:
- [ ] All secret files have 0600 permissions
- [ ] No failed systemd units
- [ ] No broken symlinks in CrowdSec

**High Priority Complete When**:
- [ ] DNS health warnings understood and resolved/documented
- [ ] cAdvisor privilege requirements documented and justified
- [ ] PORTAINER.md and AUTHELIA.md created

**Medium Priority Complete When**:
- [ ] Project plan container counts match reality
- [ ] All service documentation created

---

**Next Update**: After completing immediate tasks (today EOD)
