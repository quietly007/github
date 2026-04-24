# qui3tly.cloud — the flagship project

**What it is**: a sovereign, self-hosted cloud for humans and small businesses.
Running production infrastructure behind every document in this folder.

**Grade today**: B+ (78/100, 15 open findings, all P2/P3). Last audit: 2026-04-23.

---

## Ship-ready artifacts

| Artifact | For | Path |
|----------|-----|------|
| **Pitch (1-pager)**   | prospects, intros        | [`PITCH.md`](PITCH.md) |
| **Sales deck (HTML)** | sales meetings, print    | [`presentation/deck.html`](presentation/deck.html) |
| **System of record**  | engineers, auditors, AIs | `~/.docs/SYSTEM_OF_RECORD.md` |
| **CCIE topology**     | engineers, auditors      | `~/.docs/01-architecture/CCIE_TOPOLOGY.md` |

## Internal (operational)

| Folder | Purpose |
|--------|---------|
| [`audit/`](audit/)           | Current audit dossier (10 sections, findings tracker, evidence) |
| [`audit/_archive/`](audit/_archive/) | Previous audit programs (BASELINE 2026-02-16, perfection, preproduction) |
| [`PLAN.md`](PLAN.md)         | Active roadmap |
| [`TODO.md`](TODO.md)         | Short-term tasks |

## Audit dossier (live)

- [`audit/00-EXECUTIVE_SUMMARY.md`](audit/00-EXECUTIVE_SUMMARY.md) — what's green / yellow / red
- [`audit/07-FINDINGS/TRACKER.md`](audit/07-FINDINGS/TRACKER.md) — open findings (authoritative)
- [`audit/09-EVIDENCE/`](audit/09-EVIDENCE/) — immutable evidence files per mutation
- [`audit/10-PRODUCTION_READINESS/`](audit/10-PRODUCTION_READINESS/) — go-live criteria per service

## Current live status (2026-04-24)

| Metric | Value |
|--------|-------|
| Hosts | 2 (master + lady) |
| Containers | ~64 |
| Certificates | 14/14 valid, auto-renewing |
| Monitoring targets | 20/20 up |
| Alert rules | 53, health = ok |
| Active alerts | 0 |
| Open findings | 15 (was 17 before 2026-04-24 sprint) |
| Mail deliverability | 100% to Gmail / Outlook / Yahoo |

## Entry points by role

- **New engineer** → `~/.copilot/START_HERE.md` → `~/.docs/SYSTEM_OF_RECORD.md`
- **AI agent** → `~/.copilot/NEXT_AI.md` (first, always) → then the 7-step reading order inside
- **Prospect** → [`PITCH.md`](PITCH.md) or [`presentation/deck.html`](presentation/deck.html)
- **Client** → their file under `~/.github/projects/clients/<slug>/`
- **Auditor** → [`audit/README.md`](audit/README.md) + `~/.governance/`
