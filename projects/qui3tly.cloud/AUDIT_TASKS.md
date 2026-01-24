# Audit Polish Tasks - Optional Enhancements

> **Phase**: Phase II  
> **Priority**: Low (Infrastructure already A+++)  
> **Total Estimate**: ~3 hours  
> **Status**: Not Started

---

## Overview

These are optional enhancements identified during the Excellence Initiative audit. The infrastructure already achieved **A+++ (10/10) certification**, so these tasks are nice-to-have improvements that can be completed whenever time permits.

**Note**: These are NOT blockers for Phase III (Documentation Consolidation) or Phase IV (Infrastructure Expansion).

---

## 1. Update Monitoring Versions

**Estimate**: ~10 minutes  
**Priority**: Low  
**Complexity**: Trivial

### Current State
MONITORING.md may have outdated version numbers for monitoring stack components.

### Task
- Read current versions from running containers: `docker inspect <container> | grep -i version`
- Update MONITORING.md with accurate versions
- Lady needs version bumps to match Master

### Specific Updates Needed

**Lady Monitoring Stack**:
- node-exporter: v1.8.2 → v1.9.0
- cadvisor: v0.49.1 → v0.52.1
- promtail: 3.0.0 → 3.4.2

**Master**: Already current
- node-exporter: v1.9.0 ✅
- cadvisor: v0.52.1 ✅
- promtail: 3.4.2 ✅

### Files to Update
- `~/.docs/operations/MONITORING.md`

### Commands
```bash
# Check versions on Master
docker inspect node-exporter --format '{{.Config.Image}}'
docker inspect cadvisor --format '{{.Config.Image}}'
docker inspect promtail --format '{{.Config.Image}}'

# Check versions on Lady
ssh lady "docker inspect node-exporter --format '{{.Config.Image}}'"
ssh lady "docker inspect cadvisor --format '{{.Config.Image}}'"
ssh lady "docker inspect promtail --format '{{.Config.Image}}'"
```

### Success Criteria
- [ ] All version numbers in MONITORING.md match reality
- [ ] Documentation committed to git

---

## 2. Run Playbook Check-Mode Verification

**Estimate**: ~30 minutes  
**Priority**: Low  
**Complexity**: Easy

### Current State
41 Ansible playbooks exist but haven't been systematically tested in check mode (dry-run).

### Task
- Run each playbook in check mode: `ansible-playbook playbook.yml --check`
- Document any warnings or suggestions
- Create verification report
- Identify any playbooks that need updates

### Approach
```bash
# Test all playbooks in check mode
cd ~/.ansible/playbooks
for playbook in *.yml; do
  echo "=== Testing $playbook ==="
  ansible-playbook "$playbook" --check -i ../inventory.ini
done
```

### Expected Outcomes
- Most playbooks should pass check mode cleanly
- Some warnings expected (e.g., "would create file X")
- No errors expected (infrastructure already validated)

### Files to Create
- `~/.ansible/PLAYBOOK_VERIFICATION.md` - Report with results

### Report Format
```markdown
# Ansible Playbook Verification Report
Date: YYYY-MM-DD
Total Playbooks: 41

## Summary
- ✅ Passed: XX playbooks
- ⚠️ Warnings: XX playbooks
- ❌ Errors: XX playbooks

## Details
[Playbook-by-playbook results]
```

### Success Criteria
- [ ] All 41 playbooks tested in check mode
- [ ] Report created with results
- [ ] Any identified issues documented (not necessarily fixed)

---

## 3. Create WireGuard Status Check Script

**Estimate**: ~30 minutes  
**Priority**: Low  
**Complexity**: Easy

### Current State
WireGuard tunnel to EdgeRouter exists but no automated health check script.

### Task
Create script to verify WireGuard tunnel health:
- Check tunnel interface exists (`wg show wg0`)
- Verify peer connection
- Test ping to EdgeRouter (10.10.0.2)
- Verify routes
- Report status

### Script Location
`~/.copilot/scripts/check-wireguard.sh`

### Script Features
```bash
#!/bin/bash
# WireGuard Tunnel Health Check

# Check interface
if ! ip link show wg0 &>/dev/null; then
  echo "❌ wg0 interface not found"
  exit 1
fi

# Check peer
if ! wg show wg0 | grep -q "peer:"; then
  echo "❌ No peer configured"
  exit 1
fi

# Check handshake
HANDSHAKE=$(wg show wg0 latest-handshakes | awk '{print $2}')
if [ "$HANDSHAKE" -eq 0 ]; then
  echo "❌ No handshake (peer unreachable)"
  exit 1
fi

# Test connectivity
if ! ping -c 1 -W 2 10.10.0.2 &>/dev/null; then
  echo "⚠️ Ping to EdgeRouter (10.10.0.2) failed"
  exit 1
fi

echo "✅ WireGuard tunnel healthy"
exit 0
```

### Optional: Add to Monitoring
- Could add to cron for periodic checks
- Could integrate with Prometheus (textfile collector)
- Could add to Grafana dashboard

### Files to Create/Update
- Create: `~/.copilot/scripts/check-wireguard.sh`
- Update: `~/.docs/runbooks/wireguard.md` (add health check section)

### Success Criteria
- [ ] Script created and executable
- [ ] Script tested on Master
- [ ] Documented in runbook
- [ ] Optional: Added to monitoring

---

## 4. Document Grafana Dashboards

**Estimate**: ~45 minutes  
**Priority**: Low  
**Complexity**: Easy

### Current State
Grafana has multiple dashboards but no central documentation describing them.

### Task
Create comprehensive Grafana dashboard documentation:
- List all current dashboards
- Describe purpose of each
- Document key metrics shown
- Screenshot main dashboards (optional)
- Create reference guide

### Dashboards to Document

**Expected Dashboards** (verify actual list):
- Node Exporter Full
- Docker Container Monitoring (cAdvisor)
- Traefik Dashboard
- Prometheus Stats
- Loki Logs
- System Overview
- [Any custom dashboards]

### File to Create
`~/.docs/services/GRAFANA_DASHBOARDS.md`

### Format
```markdown
# Grafana Dashboards Reference

## Dashboard Inventory

### 1. Node Exporter Full
- **Purpose**: Complete system metrics for all servers
- **Metrics**: CPU, RAM, disk, network, load
- **Datasource**: Prometheus
- **URL**: https://grafana.quietly.its.me/d/node-exporter

### 2. Docker Container Monitoring
- **Purpose**: Per-container resource usage
- **Metrics**: CPU, memory, network per container
- **Datasource**: Prometheus (cAdvisor)
- **URL**: https://grafana.quietly.its.me/d/cadvisor

[etc...]
```

### Process
1. Login to Grafana: https://grafana.quietly.its.me
2. List all dashboards
3. For each dashboard:
   - Open and explore
   - Note purpose and key metrics
   - Optional: Screenshot
   - Document in reference guide

### Success Criteria
- [ ] All dashboards listed and described
- [ ] Purpose and metrics documented
- [ ] URLs included for quick access
- [ ] File committed to git

---

## 5. Deploy Security-Tools Stack

**Estimate**: ~1 hour  
**Priority**: Low  
**Complexity**: Medium

### Current State
Basic security stack exists (CrowdSec, fail2ban), but could add dedicated security audit tools.

### Task
Identify, deploy, and document 2 additional security audit tools:
- Research suitable tools
- Create docker-compose.yaml
- Deploy to Master
- Deploy to Lady
- Configure integration
- Document usage

### Suggested Tools

**Option 1: Trivy** (Container vulnerability scanner)
- Scans Docker images for vulnerabilities
- Integrates with CI/CD
- Lightweight

**Option 2: Lynis** (System auditor)
- Security audit tool for Linux
- Checks hardening status
- Generates reports

**Option 3: OSSEC** (Host-based IDS)
- Intrusion detection
- File integrity monitoring
- Log analysis

**Option 4: Wazuh** (Security monitoring platform)
- Comprehensive security platform
- Integrates with many tools
- More complex setup

### Recommended: Trivy + Lynis
Both are lightweight, well-documented, and provide clear value without complexity.

### Implementation

#### Trivy Deployment
```yaml
# ~/.docker-compose/security-tools/docker-compose.yaml
services:
  trivy:
    image: aquasec/trivy:0.48.0
    container_name: trivy
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - trivy-cache:/root/.cache/trivy
    command: ["server", "--listen", "0.0.0.0:8080"]
    restart: unless-stopped
```

#### Lynis Setup
Lynis doesn't need Docker - runs directly on host:
```bash
# Install on both servers
sudo apt install lynis

# Run audit
sudo lynis audit system

# Schedule weekly scan
echo "0 2 * * 0 root lynis audit system --cronjob > /var/log/lynis-weekly.log" | sudo tee /etc/cron.d/lynis-weekly
```

### Files to Create/Update
- Create: `~/.docker-compose/security-tools/docker-compose.yaml`
- Update: `~/.docs/security/SECURITY.md` (add tools section)
- Create: `~/.docs/runbooks/security-tools.md`
- Update: `~/.ansible/playbooks/security-tools.yml` (automation)

### Success Criteria
- [ ] Tools selected and justified
- [ ] Docker compose created (if applicable)
- [ ] Deployed to Master
- [ ] Deployed to Lady
- [ ] Integration tested
- [ ] Documentation updated
- [ ] Ansible playbook created

---

## Summary

| Task | Estimate | Priority | Complexity |
|------|----------|----------|------------|
| 1. Update monitoring versions | 10 min | Low | Trivial |
| 2. Playbook check-mode | 30 min | Low | Easy |
| 3. WireGuard health check | 30 min | Low | Easy |
| 4. Document Grafana dashboards | 45 min | Low | Easy |
| 5. Deploy security-tools | 1 hour | Low | Medium |
| **TOTAL** | **~3 hours** | **Low** | **Easy-Medium** |

---

## Notes

- **Not blocking anything** - Infrastructure is already A+++
- **Can be done anytime** - No urgency
- **Can be split up** - Do one task at a time when convenient
- **Low risk** - All read-only or non-critical additions
- **Good for learning** - Chance to explore tools without pressure

---

**Phase**: Phase II (Optional Enhancements)  
**Status**: Ready to start whenever convenient  
**Prerequisite**: None (can do anytime)  
**Next Phase**: Phase III (Documentation Consolidation) - Higher priority
