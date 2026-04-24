# 08 — Systemd Units (both hosts)

> **Source**: `09-EVIDENCE/systemd_both_20260423T202005Z.txt` (2026-04-23 20:20 UTC)  
> **Method**: `systemctl --failed`, `list-unit-files --state=enabled`, `list-timers`, `journalctl`  
> **Standard**: `~/.docs/06-security/SYSTEMD_SERVICES.md`

## 🟢 Master — failed units

```
0 loaded units listed.
```
✅ Clean.

## 🔴 Lady — failed units

```
● mailcow-tlsa.service   loaded failed failed   Update Mailcow TLSA and MTA-STS DNS records
```

Root cause confirmed from journal (2026-04-23 14:10:50 CEST):

```json
{"success": false,
 "errors": [{"code": 9109, "message": "Invalid access token"}]}
```

**F-0001 updated**: exact CF error code is **9109**, not 1000.

Additional failure observed same run:

```
Warning: Failed to reload services:
  Command '['docker', 'exec', 'postfix-mailcow', 'postfix', 'reload']'
  returned non-zero exit status 1
```

→ **F-0010** (new): Even after fixing CF token, `mailcow-tlsa.service`'s post-renewal `postfix reload` inside the container also fails. Pipeline won't complete end-to-end until both bugs are addressed.

## 📌 `systemd-networkd-wait-online.service` drift

Doc (`SYSTEMD_SERVICES.md` 2026-01-29) claims masked on **Lady only**. Evidence:

| Host | Current state | Drop-in | Notes |
|---|---|---|---|
| Master | masked (inactive dead) | `override.conf` present | "Unit file changed on disk → `daemon-reload` needed" |
| Lady | masked (inactive dead) | none | fine |

→ **F-0004 DOWNGRADED to P3**: unit IS masked on both hosts (better than doc claims). Only housekeeping:
- Master: `sudo systemctl daemon-reload`
- Doc: update to "both hosts"

## ⏰ Enabled timers (Lady — representative)

| Timer | Next run | Last run | Service |
|---|---|---|---|
| `man-db.timer` | Fri 2026-04-24 11:09 CEST | 11 h ago | `man-db.service` |
| `mailcow-tlsa.timer` | Fri 2026-04-24 14:10 CEST | 8 h ago ❌ | `mailcow-tlsa.service` |
| `systemd-tmpfiles-clean.timer` | Fri 2026-04-24 14:15 CEST | 8 h ago | `systemd-tmpfiles-clean.service` |
| `e2scrub_all.timer` | Sun 2026-04-26 | 4 d ago | `e2scrub_all.service` |
| `fstrim.timer` | Mon 2026-04-27 | 3 d ago | `fstrim.service` |

## ✅ Enabled native services (Master)

| Unit | State | Since |
|---|---|---|
| `docker.service` | active | 10 d |
| `headscale.service` | active; drop-in `dns-bootstrap.conf` | 10 d |
| `tailscaled.service` | active; drop-ins `after-headscale.conf`, `no-dns.conf` | 10 d |
| `ssh.service` | active (`0.0.0.0:1006`) | 10 d |
| `ufw.service` | active; rules loaded | — |
| `cron.service` | active | — |
| `fail2ban.service` | active; 3 IPs currently rejected | — |

Lady similar (verified from inventory).

## 🧭 Reboot history — Lady

```
Thu 2026-04-23 14:00  reboot (still running) → kernel 6.1.0-44, rel 6.1.164-1
Fri 2026-04-17 23:45  prior boot (ended Thu 2026-04-23 13:56)
```

Reboot of 14:00 = P1B kernel patch (intentional). Previous uptime window 6 days.

The 11.73 / 7.44 / 7.05 load observed is post-reboot warm-up — crowdsec + uisp + promtail + mailcow-watchdog are the top CPU contributors (all <20%, no runaway). Re-check planned at Phase 04A.

## 📝 Derived actions

| ID | Action | Phase |
|---|---|---|
| T-016 | Reconcile `SYSTEMD_SERVICES.md` with "masked on BOTH hosts" | 06A |
| T-022 | `sudo systemctl daemon-reload` on Master | 02B |
| T-023 | F-0010: fix post-renewal `postfix reload` step | 1F follow-up |
