# Runbook 01 — P0 Security Residual (Master public@file → vpn-only@file)

**Target:** 3 admin panels wrongly exposed since Feb-16 commit c150f84
**Time:** ~5 minutes
**Risk:** Zero (middleware label change, no container restart)
**Prereq:** Phase 0 snapshot completed

---

## Why

Per `~/.docs/01-architecture/DOMAIN_STRATEGY.md` §0 and `TAILSCALE_OUTAGE_INVESTIGATION_2026-02-18.md`, commit c150f84 changed middleware for three admin panels from `vpn-only@file` to `public@file`. Only CrowdSec stands between the public internet and these control panels. Must revert.

---

## Commands

```bash
set -euo pipefail
TS=$(date -u +%Y%m%dT%H%M%SZ)
EV=~/projects/qui3tly.cloud/perfection/evidence

# 1. Backup current compose files
for svc in pihole headscale-ui headscale-admin; do
  cp ~/.docker-compose/$svc/docker-compose.yaml \
     ~/.docker-compose/$svc/docker-compose.yaml.pre-perfection-$TS
done

# 2. Inspect middleware BEFORE
grep -H "middleware" ~/.docker-compose/pihole/docker-compose.yaml \
                    ~/.docker-compose/headscale-ui/docker-compose.yaml \
                    ~/.docker-compose/headscale-admin/docker-compose.yaml \
  | tee "$EV/master_residual_middleware_before_$TS.txt"

# 3. Patch (only replace ",public@file" in middleware chains)
for svc in pihole headscale-ui headscale-admin; do
  sed -i 's/,public@file/,vpn-only@file/g' \
    ~/.docker-compose/$svc/docker-compose.yaml
done

# 4. Inspect middleware AFTER
grep -H "middleware" ~/.docker-compose/pihole/docker-compose.yaml \
                    ~/.docker-compose/headscale-ui/docker-compose.yaml \
                    ~/.docker-compose/headscale-admin/docker-compose.yaml \
  | tee "$EV/master_residual_middleware_after_$TS.txt"

# 5. Apply (labels-only, no recreate)
for svc in pihole headscale-ui headscale-admin; do
  (cd ~/.docker-compose/$svc && docker compose up -d)
done

# 6. Verify from NON-VPN network (phone hotspot / cloud VM):
#    Expected: 403 / redirect, NOT admin HTML
curl -sI https://pihole.quietly.its.me/admin/    | head -5 | tee -a "$EV/master_residual_public_fix_$TS.txt"
curl -sI https://headscale-ui.quietly.its.me/    | head -5 | tee -a "$EV/master_residual_public_fix_$TS.txt"
curl -sI https://headscale-admin.quietly.its.me/ | head -5 | tee -a "$EV/master_residual_public_fix_$TS.txt"

# 7. Verify from VPN (Mac on Tailscale):
#    curl -sI https://pihole.quietly.its.me/admin/    # expect 200 via Authelia
```

## Acceptance

- `evidence/master_residual_middleware_after_$TS.txt` shows no `public@file` on these three services
- From NON-VPN: all three FQDNs return 4xx, not admin HTML
- From VPN: all three FQDNs behave normally

## Rollback

```bash
for svc in pihole headscale-ui headscale-admin; do
  cp ~/.docker-compose/$svc/docker-compose.yaml.pre-perfection-$TS \
     ~/.docker-compose/$svc/docker-compose.yaml
  (cd ~/.docker-compose/$svc && docker compose up -d)
done
```

## Why safe

- Label-only change → Docker does not recreate
- No volume/network/image change
- Traefik reads labels on next config refresh (seconds)
- Revert in 10s via timestamped backup
