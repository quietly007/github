# Migration Notes — Domain Strategy Phase 5

## Authelia Session Domain Change

**Issue**: Session cookies are scoped to `quietly.its.me`  
**Location**: `~/.docker/authelia/configuration.yml` (lines 31, 41)  
**Impact**: ALL users will be logged out when domain changes to `qui3tly.cloud`

### Required Actions Before Phase 5:
1. Send notification 24-48h in advance
2. Schedule during low-traffic window
3. Have users bookmark new URLs in advance

### User Notification Template:

Subject: VPN Infrastructure Maintenance - [DATE]

On [DATE] at [TIME], internal VPN services will migrate from 
quietly.its.me to qui3tly.cloud domains.

IMPACT:
- You will be logged out of all VPN services
- Re-authentication required (same credentials)
- Bookmark updates recommended

UPDATED URLs:
- Grafana: grafana.qui3tly.cloud
- Pi-hole: pihole.qui3tly.cloud  
- Portainer: portainer.qui3tly.cloud

Old URLs will redirect for 7 days.

---
**Created**: 2026-02-18
