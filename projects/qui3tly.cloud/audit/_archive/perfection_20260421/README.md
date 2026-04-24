# PERFECTION PROGRAM — qui3tly.cloud

**Created:** 2026-04-21
**Owner:** qui3tly
**Mission:** Drive the qui3tly.cloud infrastructure from its current preproduction state (overall grade **C**, per external audit 2026-04-21) to **A+++** production-ready — with every claim evidenced, every gate explicitly signed, and every fix reversible.

---

## Why this folder exists

There are already several layers of work in this repo:

- `~/.docs/` — standards, architecture, operations, security (canonical policy)
- `~/personal/audits/01..13` — 13 domain audit requests + summaries + outage reports
- `~/projects/qui3tly.cloud/BASELINE/` — verified infra snapshot (Feb 16 2026)
- `~/projects/qui3tly.cloud/preproduction/` — Apr 20 preproduction package + external audit (Apr 21)

This folder (`perfection/`) **does not replace** any of them. It is the **single unified execution program** that reconciles all of them into one coherent path to production:

1. One **REPORT** (`REPORT.md`) — what is actually true right now, cross-referenced against every source
2. One **PLAN** (`PLAN.md`) — the phased execution roadmap with gates
3. One **TODO** (`TODO.md`) — the operator checklist with acceptance + rollback per item
4. **Runbooks** (`runbooks/`) — ready-to-paste command sequences
5. **Gates** (`gates/`) — signed pass/fail records for each production gate
6. **Evidence** (`evidence/`) — before/after proof for every mutation

---

## Golden rules (non-negotiable)

1. **Never assume — always check the system.** (DOCUMENTATION_STANDARD.md Rule #0)
2. **Snapshot before any mutation.** Contabo panel, named `perfection-YYYYMMDD-<reason>`.
3. **One change, one verification, one evidence file.** No batched unverified changes.
4. **Do not mark a TODO done without saving evidence under `evidence/`.**
5. **Headscale stays NATIVE systemd.** Do not containerize.
6. **Master `/etc/resolv.conf` stays `chattr +i` on `1.1.1.1` / `8.8.8.8`.**
7. **No OSPF/FRR** (permanently removed Jan 13 2026).
8. **Postfix = only MTA** (Mailcow stack).
9. **Middleware contract:** `public@file` only for services explicitly public. Everything else = `vpn-only@file`.
10. **Security fixes trump convenience.** If in doubt, restrict.

---

## File map

| File | Purpose |
|---|---|
| REPORT.md | Unified audit report — merges internal + external + Feb outage + 13 audit requests |
| PLAN.md | 6-phase execution plan with gate criteria and rollback |
| TODO.md | Operator checklist — ordered, evidenced, signed |
| runbooks/ | Copy-paste command sequences per phase |
| gates/ | Signed Go/No-Go decisions per gate |
| evidence/ | Before/after command output per task |

---

## Current verdict (as of 2026-04-21)

**NO-GO** for production lock. Four P0 blockers open:

1. **P0-1** Lady patch backlog (kernel 6.1.0-42, 61-day uptime)
2. **P0-2** No evidenced backup chain for Lady (215 GB at risk)
3. **P0-3** Seven unscoped `0.0.0.0` listeners on Lady (HTCondor + Pegasus + unknown)
4. **P0-4** Unidentified `python3:5000` process on Lady (external audit finding)

Plus **three Feb 16 security bugs** still uncorrected in Master compose files:

- `pihole.quietly.its.me` middleware = `public@file` (should be `vpn-only@file`)
- `headscale-ui.quietly.its.me` middleware = `public@file` (should be `vpn-only@file`)
- `headscale-admin.quietly.its.me` middleware = `public@file` (should be `vpn-only@file`)

All are fixable in 3–5 focused days. See PLAN.md.

---

## How to use this program

1. Read REPORT.md end-to-end. Do not start work until you understand the full picture.
2. Open PLAN.md. Confirm phase 0 (snapshot) is your first action.
3. Open TODO.md. Work top-to-bottom. Each item has acceptance + evidence + rollback.
4. Save every command output under `evidence/` with a timestamp.
5. When a phase closes, sign the gate under `gates/`.
6. Final gate (Gate-F) issues the Go/No-Go decision.

No item is "done" without an evidence file reference.
