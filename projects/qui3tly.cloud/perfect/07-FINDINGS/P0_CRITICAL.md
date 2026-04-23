# P0 Findings — Time-Bombs

> **Definition**: A P0 finding causes, or will imminently cause, partial or total production outage without intervention.  
> **SLA**: Begin remediation **immediately**. Owner-approval required but should be treated as interrupt.

---

## F-0001 — Cloudflare DNS-01 token invalid (all cert renewals blocked)

### Summary

The Cloudflare API token used by Traefik's DNS-01 challenge and by `mailcow-tlsa.service` is rejected by Cloudflare with **error code 9109 "Invalid access token"** (verified from journal, 2026-04-23 14:10:50 CEST). As a result, **no TLS certificate on either host can renew**. Sixteen certificates — including the mail server — begin expiring on **2026-04-28** (≈4 days from discovery).

### Impact matrix (certs ordered by expiry)

| FQDN | Host | Expires (UTC) | Days | Consequence at expiry |
|---|---|---:|---:|---|
| `quietly.online` | lady | 2026-04-28 02:43 | 4 | Root vhost TLS error |
| `mail.quietly.online` | lady | 2026-04-28 02:43 | 4 | **Total mail outage** (SMTP+IMAP+submission+webmail) |
| `mta-sts.quietly.online` | lady | 2026-04-28 02:43 | 4 | MTA-STS policy unreachable, mail deliverability degrades |
| `autoconfig.quietly.online` (+autodiscover SAN) | lady | 2026-04-28 02:43 | 4 | Mobile / desktop mail autoconfig fails |
| `cloud.quietly.online` | lady | 2026-04-28 03:58 | 4 | Nextcloud down for users |
| `home.quietly.online` | lady | 2026-04-28 04:00 | 4 | Home Assistant remote access down |
| `office.quietly.online` (+nextcloud SAN) | lady | 2026-04-29 18:36 | 5 | Nextcloud branded vhost down |
| `odoo.quietly.online` | lady | 2026-04-29 20:58 | 6 | ERP down |
| `unifi.quietly.online` | lady | 2026-05-04 12:28 | 10 | UniFi controller UI TLS error |
| `cctv.quietly.online` | lady | 2026-05-11 02:44 | 17 | Frigate down |
| `*.quietly.online` | lady | 2026-05-11 03:30 | 17 | Wildcard fallback |
| `quietly.online` | master copy | 2026-05-13 03:30 | 19 | Master copy fallback |
| `qui3tly.cloud` (+`*.qui3tly.cloud`) | master | 2026-05-19 04:26 | 25 | Internal VPN backbone vhosts (mgmt UIs) |
| `quietly.its.me` (+`*.quietly.its.me`) | master | 2026-06-04 04:26 | 41 | Master public vhosts lose SAN coverage |
| `quietly.its.me` (+`*.quietly.its.me`) | lady copy | 2026-06-04 04:55 | 41 | — |

### Root cause

Actual payload captured from `mailcow-tlsa.service` on Lady, run at 2026-04-23 14:10:50 CEST:

```json
{"success": false,
 "errors": [{"code": 9109, "message": "Invalid access token"}],
 "messages": [],
 "result": null}
```

- CF error **9109** = token value unknown / revoked (not merely scope-limited).
- Token worked previously; either expired, revoked, or zone scope narrowed.
- Nightly failures since at least 2026-04-18.

### Dependent services also failing

- `mailcow-tlsa.service` — failing nightly since ≥ 2026-04-18. Visible symptom that led to discovery.
- **F-0010 (new, P1)**: the script also fails to reload postfix inside Mailcow container (`docker exec postfix-mailcow postfix reload` → exit 1). Two bugs in one service; both need fixing.

### Remediation (requires owner)

1. Owner creates new Cloudflare API token, scopes:
   - Permissions: `Zone → DNS → Edit`
   - Zone Resources: `Include → Specific zone →` **quietly.online**, **quietly.its.me**, **qui3tly.cloud** (one row per zone)
   - Client IP filtering: blank
   - TTL: blank (no expiration) preferred
2. Owner delivers token via owner-controlled channel (not chat log).
3. Agent verifies via CF API `/user/tokens/verify` → `success:true`.
4. Agent atomically replaces `~/.secrets/traefik/cf-token` on **both hosts** (600, `qui3tly:qui3tly`), backup old → `~/.copilot/backups/cf-token_<ts>/`.
5. Traefik reload on both hosts; force-renew `mail.quietly.online` first as smoke test.
6. Run `mailcow-tlsa.service` manually; expect green (after F-0010 fix).
7. Wait 24 h; confirm all 16 certs refreshed via `openssl s_client` + `acme.json` decode.

### Evidence

- `09-EVIDENCE/systemd_both_20260423T202005Z.txt` (exact CF error payload)
- `09-EVIDENCE/01F_full_fleet_sweep_20260423T192842Z.txt` (full cert list + expirations)
- `09-EVIDENCE/01F_master_sweep_20260423T192943Z.txt`

### Status

**OPEN — blocked on owner providing new token. Deadline: 2026-04-27 23:59 UTC.**
