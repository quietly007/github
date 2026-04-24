# Open Questions for Owner

> Answer inline under each question; the agent will act on the answer in the next session.

## Q-001 — Scope of penetration tests

Phase 03 can include:
- (a) Read-only local checks (nmap from Tailscale, testssl against endpoints) — **L1 safe, no impact**
- (b) External nmap from outside (off-net vantage) — **may trigger CrowdSec on your own infra**
- (c) Light fuzzing / path probing on public web services — **possibly noisy**

**Question**: proceed with (a) + (b) only, or include (c)?

> **Answer**:

## Q-002 — Destination for penetration test noise

If (b) or (c) are approved, the scanner IP will briefly show in CrowdSec.

**Question**: add scanner source IPs to a temporary CrowdSec allowlist first, or let CrowdSec block and we verify defences worked?

> **Answer**:

## Q-003 — Gotify password rotation

F-0003: `~/.governance/MONITORING.md` has a plaintext Gotify admin password.

**Question**: rotate now (agent generates new password, stores in `~/.secrets/gotify/admin_<ts>`, updates Gotify, scrubs doc, asks you to re-pair mobile app) — or defer?

> **Answer**:

## Q-004 — Restore test target (B-003)

Options for the single restore test we need before GO:
- (a) Mailcow daily backup → extract to scratch path on Lady, diff one mailbox
- (b) Contabo snapshot → provision new 1-hour VPS, verify boot
- (c) Git-based infra restore → clone on scratch VM, run Ansible

**Question**: which one?

> **Answer**:

## Q-005 — Audit requests 01–13 in `~/personal/audits/`

You authored 13 audit requests in January–February; most were not executed. Many overlap with phases here.

**Question**: should the `audit/` dossier formally close each (cross-link findings, mark as executed here) as part of this work?

> **Answer**:

## Q-006 — Acceptable grade for GO

`SCORECARD.md` uses ≥ 90 = GREEN. Your earlier self-grade was 78.

**Question**: confirm 90 as the GO threshold, or pick a different number?

> **Answer**:

## Q-007 — Contabo panel access for Phase 05C

Verifying Contabo automatic snapshots requires logging into `my.contabo.com`.

**Question**: will you (a) log in and paste a screenshot/list of available snapshots, or (b) grant read-only delegated access?

> **Answer**:
