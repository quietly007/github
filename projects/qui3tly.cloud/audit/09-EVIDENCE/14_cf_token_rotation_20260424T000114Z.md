# F-0001 Resolution — Cloudflare Token Rotation Evidence

**Date**: 2026-04-24 01:45-01:58 CEST (23:45-23:58 UTC 2026-04-23)
**Action**: L2 — Cloudflare DNS-01 token rotation on Master + Lady
**Approval**: Owner-provided new token (chat)
**Blast radius**: 14 Lady certs + mail trust chain

## Pre-state (01:44 UTC)
- Old token sha256_8: `dedb836e` (identical across 3 files, confirming single shared token)
- CF API: err 9109 "Unknown API token" (rotated by owner prior to 2026-02-17)
- LE rate-limiting: `10502: Too many authentication failures` (token failed >100 times)
- `mailcow-tlsa.service` dependent on Traefik cert extraction → had been broken since

## Action sequence
1. CF API verify new token → `success:true`, `status:active`, covers 7 zones (3 needed + 4 extra)
2. Backup: `~/.copilot/backups/cf_token_rotation_20260423T234247Z/`
   - `master_acme.json` (32810 B)
   - `lady_acme.json` (130557 B)
   - 3 × old cf-token files
3. Deploy new token (53 B, newline-stripped) → 3 locations, perms 600, sha256_8 `e8fd278a` on all
4. `docker compose restart traefik` on both hosts
5. Traefik initiates renewals at 01:45:22 CEST
6. Transient 403s on `office`/`cctv` (LE cached stale TXT from old failed attempts) — resolved by second restart at 01:57
7. Triggered `mailcow-tlsa.service` → TLSA + MTA-STS records updated cleanly

## Post-state (01:58 UTC)
All 14 Lady certs at 89 days remaining (fresh 90-day LE):
- quietly.online, mail, autoconfig, autodiscover, home, mta-sts
- cloud, nextcloud, odoo, office
- unifi, cctv, traefik, uisp

Master certs untouched (41 days — will auto-renew at 30).

mailcow-tlsa.service: all 3 steps SUCCESS.
Prometheus blackbox: picking up new expiry dates.

## Residual
- New token scope broader than required (7 zones vs 3 needed) — file F-0025 low-priority
- Old stale `_acme-challenge` records: auto-cleaned by Traefik
- Token NEVER appears in: commits, evidence files, findings docs, memory, shell history (both hosts)

## Rollback (if needed — NOT executed)
```
BDIR=~/.copilot/backups/cf_token_rotation_20260423T234247Z
cp $BDIR/master_traefik_cf-token.old ~/.secrets/traefik/cf-token
scp $BDIR/lady_*.old lady:~/.secrets/...
docker compose restart traefik
# acme.json restore only if corrupted — NOT needed, Traefik writes new certs in place
```

**Result: F-0001 CLOSED. F-0010 (mailcow-tlsa) CLOSED as byproduct.**
