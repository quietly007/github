# Quick Wins - Easy Improvements

> **Date**: 2026-01-24  
> **Auditor**: External Agent  
> **Scope**: Low-effort, high-impact improvements

---

## Executive Summary

**3 quick wins** identified that can be completed in < 2 hours total.

All are **optional** (infrastructure already at A+++ grade), but provide additional polish and operational efficiency.

---

## Quick Win #1: Install ansible-lint

**Effort**: 5 minutes  
**Impact**: Medium  
**Priority**: 🟡 Medium

### Description
Install ansible-lint for automated playbook linting and best practices enforcement.

### Current State
- Syntax checks: ✅ Passing (`ansible-playbook --syntax-check`)
- ansible-lint: ❌ Command not found

### Benefit
- Catches potential issues earlier
- Enforces Ansible best practices
- CI/CD integration ready

### Implementation
```bash
# On Master
pip3 install ansible-lint

# Test
cd ~/.ansible
ansible-lint playbooks/shared/01-bootstrap.yml
```

### Success Criteria
- ansible-lint installed
- Zero lint errors (or acceptable warnings documented)
- Integrated into `~/.copilot/scripts/verify-ansible.sh`

---

## Quick Win #2: Create WireGuard Status Check Script

**Effort**: 30 minutes  
**Impact**: Low-Medium  
**Priority**: 🟢 Low

### Description
Create simple script to verify WireGuard tunnel status (for future auditors).

### Current State
- WireGuard: ✅ Working (EdgeRouter connectivity confirmed)
- Verification: ⚠️ Requires manual sudo commands

### Benefit
- Quick tunnel health check
- Simplifies troubleshooting
- Documentsexpected output

### Implementation
```bash
#!/bin/bash
# ~/.copilot/scripts/wireguard-check.sh

echo "🔐 WireGuard Tunnel Status"
echo "================================"

# Interface status
if ip link show wg0 &>/dev/null; then
    echo "✅ wg0 interface: UP"
else
    echo "❌ wg0 interface: DOWN"
    exit 1
fi

# Tunnel details (requires sudo)
if sudo wg show wg0 &>/dev/null; then
    echo "✅ WireGuard tunnel: ACTIVE"
    sudo wg show wg0 | grep -E "peer|endpoint|latest handshake"
else
    echo "⚠️  Cannot read tunnel details (sudo required)"
fi

# Ping test
if ping -c 2 -W 2 10.10.0.2 &>/dev/null; then
    echo "✅ EdgeRouter reachable: 10.10.0.2"
else
    echo "❌ EdgeRouter unreachable"
    exit 1
fi

echo "✅ WireGuard tunnel healthy"
```

### Success Criteria
- Script created and executable
- Returns clear status
- Works without sudo (warns if details unavailable)
- Documented in operations docs

---

## Quick Win #3: Document Grafana Dashboards

**Effort**: 45 minutes  
**Impact**: Low  
**Priority**: 🟢 Low

### Description
Create quick reference guide for existing Grafana dashboards.

### Current State
- Dashboards: ✅ Functional
- Documentation: ❌ Not documented

### Benefit
- Faster dashboard navigation
- Clear metric definitions
- Training reference

### Implementation
Create `~/.docs/services/MONITORING_DASHBOARDS.md`:

```markdown
# Grafana Dashboard Reference

## System Overview
- **URL**: https://grafana.quietly.its.me/d/system
- **Purpose**: Server health, resource usage
- **Key Metrics**:
  - CPU usage (target: < 80%)
  - RAM usage (target: < 85%)
  - Disk space (alert: < 20%)
  - Load average

## Docker Containers
- **URL**: https://grafana.quietly.its.me/d/docker
- **Purpose**: Container health and resource usage
- **Key Metrics**:
  - Container status (up/down)
  - CPU per container
  - Memory per container
  - Restart count

## Network Traffic
- **URL**: https://grafana.quietly.its.me/d/network
- **Purpose**: Network throughput and connections
- **Key Metrics**:
  - Bandwidth (in/out)
  - Active connections
  - Tailscale direct connections
  - WireGuard traffic

## Traefik Metrics
- **URL**: https://grafana.quietly.its.me/d/traefik
- **Purpose**: Web traffic and routing
- **Key Metrics**:
  - Requests per second
  - Response time (p50, p95, p99)
  - Error rate (target: < 1%)
  - Backend health

## Alerts
- **URL**: https://grafana.quietly.its.me/alerting
- **Purpose**: Active alerts and history
- **Alert Thresholds**:
  - Disk < 20%: Warning
  - Disk < 10%: Critical
  - Service down > 2 min: Critical
  - High load > 10.0: Warning
```

### Success Criteria
- Document created
- All dashboards listed
- Key metrics explained
- Alert thresholds documented

---

## Quick Win #4: Ansible Playbook Check-Mode Verification

**Effort**: 30 minutes (sampling)  
**Impact**: Medium  
**Priority**: 🟡 Medium

### Description
Run check-mode verification on 10 most critical playbooks.

### Current State
- Playbooks: ✅ Syntax valid
- Check-mode: ⏳ Not systematically tested

### Benefit
- Confirms idempotency
- Validates safety
- CI/CD integration ready

### Implementation
```bash
#!/bin/bash
# Quick check-mode test

CRITICAL_PLAYBOOKS=(
    "shared/01-bootstrap.yml"
    "shared/02-hardening.yml"
    "master/02-headscale.yml"
    "master/04-traefik.yml"
    "master/09-crowdsec.yml"
    "lady/lady-dr.yml"
    "lady/06-tailscale.yml"
)

cd ~/.ansible

for playbook in "${CRITICAL_PLAYBOOKS[@]}"; do
    echo "Testing: $playbook"
    ansible-playbook -i inventory/production.ini \
        "playbooks/$playbook" \
        --check \
        --diff
done
```

### Success Criteria
- 10 critical playbooks tested
- Zero unexpected changes in check mode
- Results documented

---

## Quick Win #5: Update Lady Monitoring Agent Versions in Docs

**Effort**: 10 minutes  
**Impact**: Very Low  
**Priority**: 🟢 Low

### Description
Update documentation to reflect Lady's deployed monitoring agent versions.

### Current State
- Docs: "Latest stable versions"
- Reality: node-exporter v1.8.2, cadvisor v0.49.1, promtail 3.0.0

### Benefit
- Documentation accuracy
- Version tracking

### Implementation
Update `~/.docs/services/MONITORING.md`:

**Before**:
```markdown
Lady: Latest stable versions
```

**After**:
```markdown
Lady:
- node-exporter: v1.8.2
- cadvisor: v0.49.1
- promtail: 3.0.0

(Deployed 2026-01-24 during DR)
```

### Success Criteria
- Docs updated
- Versions match reality
- Note added about deployment date

---

## Summary Table

| Quick Win | Effort | Impact | Priority | Estimated Time |
|-----------|--------|--------|----------|----------------|
| #1: Install ansible-lint | Low | Medium | 🟡 Medium | 5 min |
| #2: WireGuard check script | Low | Low-Med | 🟢 Low | 30 min |
| #3: Grafana dashboard docs | Medium | Low | 🟢 Low | 45 min |
| #4: Playbook check-mode | Low | Medium | 🟡 Medium | 30 min |
| #5: Update monitoring versions | Very Low | Very Low | 🟢 Low | 10 min |
| **TOTAL** | **Low** | **Medium** | | **~2 hours** |

---

## Recommendations

### Do Now (High ROI)
1. ✅ **Install ansible-lint** (5 min, immediate value)
2. ✅ **Update monitoring versions** (10 min, accuracy)

### Do Next Week
3. ⏳ **Playbook check-mode verification** (30 min, validation)
4. ⏳ **WireGuard check script** (30 min, operational)

### Do When Time Permits
5. ⏳ **Grafana dashboard docs** (45 min, reference)

---

## Notes

- **All quick wins are optional** - Infrastructure already A+++ grade
- **Total effort: ~2 hours** for all improvements
- **No downtime required** for any quick win
- **No security impact** - all are documentation/tooling enhancements
- **Can be done incrementally** - no dependencies between items

---

## Implementation Tracking

| Quick Win | Status | Date | Notes |
|-----------|--------|------|-------|
| #1: ansible-lint | ⬜ Not started | - | - |
| #2: WireGuard script | ⬜ Not started | - | - |
| #3: Dashboard docs | ⬜ Not started | - | - |
| #4: Check-mode tests | ⬜ Not started | - | - |
| #5: Version update | ⬜ Not started | - | - |

---

*Generated: 2026-01-24*  
*Owner: qui3tly*  
*Partner: Lucky Luke 🤠*
