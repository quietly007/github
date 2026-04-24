# BLOCKERS — Items that prevent any GO decision

> **Rule**: nothing here may be waived. If a blocker cannot be resolved, the answer is NO-GO.

## 🚨 Active blockers

### B-001 — Cloudflare DNS-01 token (URGENT)

- **Finding**: F-0001 (P0)
- **Who can unblock**: qui3tly (owner)
- **What's needed**: new CF API token with `Zone:DNS:Edit` on zones `quietly.online`, `quietly.its.me`, `qui3tly.cloud`
- **Delivery channel**: owner-preferred, not chat transcript
- **Deadline**: **2026-04-27 23:59 UTC** — 24 h before first cert expires (Apr 28 02:43 UTC)
- **Unblocks**: Phase 1F; all 16 cert renewals; `mailcow-tlsa.service` recovery

### B-002 — Alerting pipeline end-to-end test (owner device)

- **Finding**: F-0002 (P1)
- **Who can unblock**: qui3tly (owner)
- **What's needed**: confirm that a priority-5 test Gotify message reaches the phone app
- **Delivery channel**: real-time during Phase 04C — agent injects synthetic alert, owner confirms
- **Deadline**: before GO
- **Unblocks**: confidence in every other "healthy" claim

### B-003 — One restore-from-backup test

- **Finding**: to be filed under Phase 05B
- **Who can unblock**: qui3tly (owner approves a non-destructive restore target)
- **What's needed**: owner approval to restore one Mailcow daily backup into a scratch directory on Lady (or Contabo snapshot into a new VPS) and verify contents
- **Deadline**: before GO
- **Unblocks**: validates backups are not only running but actually restorable

### B-004 — UniFi compose change (F-0009)

- **Finding**: F-0009 (P1)
- **Who can unblock**: qui3tly (owner)
- **What's needed**: L2 approval to edit `~/.docker-compose/unifi/docker-compose.yaml` on Lady to rebind `6789/tcp` and `10001/udp` to `100.64.0.2:` (VPN-only) — or approval to remove them
- **Delivery channel**: in chat ("approve")
- **Deadline**: before GO
- **Unblocks**: closes F-0009

## 📋 Resolution log

(append here when a blocker closes)

| ID | Closed | Resolution |
|---|---|---|
| — | — | — |
