# 00 — EXECUTIVE SUMMARY

> **For**: qui3tly (owner)  
> **Date**: 2026-04-23  
> **Reading time**: 2 minutes  
> **Full dossier**: this folder (`perfect/`)

---

## 🟥 TL;DR

**Current verdict**: 🔴 **NO-GO for production**.  
**Why**: two disqualifying findings (one P0 time-bomb, one P1 silent control failure), plus several P1/P2 drift items.  
**What unblocks**: one new Cloudflare API token + end-to-end alert pipeline test.

## ⏰ The 4-day cliff

Starting **2026-04-28** (≈4 days from now), TLS certificates will begin expiring on:

- `mail.quietly.online` → total mail outage
- `cloud.quietly.online` → Nextcloud down
- `home.quietly.online` → Home Assistant remote down
- 10 more domains over the next 17 days (full list: [`07-FINDINGS/P0_CRITICAL.md`](07-FINDINGS/P0_CRITICAL.md))

Root cause: the Cloudflare DNS-01 API token used by Traefik has become invalid. Cloudflare now returns **error code 9109 "Invalid access token"** (verified 2026-04-23 14:10:50 CEST). No Let's Encrypt renewal can succeed.

**Action required from owner**: issue a new CF token scoped to DNS Edit on the three zones (`quietly.online`, `quietly.its.me`, `qui3tly.cloud`).

## 🔕 The silent alarm

An alert rule for this very scenario (`SSLCertExpiring14Days`) **exists** in Prometheus. It **did not reach you**. The nightly `mailcow-tlsa.service` failure has also run silent for 5+ days. The whole alerting chain is unverified:

```
Rule (OK)  →  Prometheus fires  ?  →  Alertmanager routes  ?  →  Gotify delivers  ?  →  Phone app rings  ?
```

At least one of those `?` is broken. Until we prove the full chain end-to-end, every other "green" indicator is untrusted.

## 📈 New findings this session (P1/P2)

| ID | Sev | One-liner |
|---|---|---|
| F-0009 | P1 | UniFi container binds `0.0.0.0:6789/tcp` + `0.0.0.0:10001/udp` — violates port-binding standard |
| F-0010 | P1 | `mailcow-tlsa.service` also fails `postfix reload` inside container — second bug; pipeline won't recover even after CF fix |
| F-0008 | P2 | Master headscale binary listens on `0.0.0.0:8085/tcp`; UFW intent unclear; needs external probe |
| F-0005 | P2 | AIDE exclusions still incomplete (`service-monitor.log` hashed) |
| F-0006 | P3 | Container count drift: Lady 38, docs claim 39 |
| F-0007 | P3 | EdgeRouter WAN IP drift in docs (observed `62.4.55.119`, doc `178.20.30.40`) |
| F-0004 | P3 | `SYSTEMD_SERVICES.md` says wait-online masked on Lady only; actually masked on BOTH; Master needs `daemon-reload` |

Full list: [`07-FINDINGS/TRACKER.md`](07-FINDINGS/TRACKER.md).

## 🧾 What this dossier contains

- Complete infrastructure analysis (topology, 63 containers, interfaces, certs, systemd)
- Complete security analysis (UFW, port exposure, secrets sweep, CVE scan) — *in progress*
- Penetration tests (external + internal nmap, testssl, mail + DNS probes) — **pending your approval on scope**
- Monitoring & alerting audit — pipeline test included — **requires your phone for Gotify leg**
- Backup & DR — **one real restore test planned** — **requires L2 approval**
- Governance compliance — docs-vs-reality, Ansible reproducibility, FQDN sweep
- Raw evidence under `09-EVIDENCE/` for every claim
- Findings ranked P0/P1/P2/P3 in `07-FINDINGS/`
- Master TODO + open questions in `08-TODO/`
- Scorecard + go/no-go verdict in `10-PRODUCTION_READINESS/`

## 👉 What I need from you (in order)

1. Answer the 7 open questions in [`08-TODO/OPEN_QUESTIONS_FOR_OWNER.md`](08-TODO/OPEN_QUESTIONS_FOR_OWNER.md).
2. Provide the new Cloudflare API token (unblocks the 4-day cliff).
3. Be available for ~5 minutes during Phase 04C to confirm the Gotify test alert lands on your phone.

Everything else the agent will execute read-only and report back under this folder.

---

**This summary auto-updates when findings change. Check the git log of this file.**
