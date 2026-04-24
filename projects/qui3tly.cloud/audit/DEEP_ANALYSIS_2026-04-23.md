# Deep Analysis — project-wide reconciliation of open work

> **Note [2026-04-24]**: this document reasons about `perfect/` as it existed on 2026-04-23. The folder was renamed to `audit/` on 2026-04-24 — all paths below should be read with that substitution. Historic content preserved verbatim.


> **Date**: 2026-04-23 22:45 UTC  (post-kernel-reboot both hosts)
> **Purpose**: Answer the owner's question: *"we have too many opened situations and uncleared jobs — investigate properly."*
> **Scope**: Every tracker, plan, audit request, finding, TODO, memory note, session file across the entire workspace is reconciled into **one** list here.
> **Verdict**: Owner is right. There are **three parallel audit programs** that never got merged, **4 session-memory plans**, **13 audit requests largely unexecuted**, and **212 TODO checkboxes in one tracker alone are unchecked even though 5 of those phases were demonstrably executed** (evidence on disk). This document is the reconciliation.

---

## 1. TL;DR for the owner

| Question | Answer |
|---|---|
| Is the fleet *running* right now? | ✅ Yes. Both hosts rebooted cleanly onto kernel **6.1.0-44-cloud-amd64**; 25 + 38 containers up; 0 failed units on Master; 1 expected failure on Lady (`mailcow-tlsa.service` — F-0001, see §4). |
| Is there an imminent production emergency? | ⚠️ Yes — **1 P0**. `mail.quietly.online` cert expires **Apr 28 02:43:40 GMT (≈ 4.3 days)**. Root cause = invalid CF API token. **Blocks on owner supplying new token.** |
| Is there a process emergency? | ⚠️ Yes. Three parallel audit dossiers (`preproduction/`, `perfection/`, `perfect/`) contain overlapping findings under different IDs. **Work is being done but not visibly tracked** — risk of missing something or double-doing it. |
| How many *genuinely* open items? | **11 findings** (de-duplicated; see §3). Plus **5 class-level hygiene gaps** (backups, resource limits, secrets sweep, CVE scan, restore drill) that apply to many services, not single items. |
| What's the single most valuable next action? | Consolidate all trackers into **one** (`perfect/`), close the 5 `perfection/` phases that are actually done, get the CF token, then execute Phase 04 (alerting pipeline) — because F-0002 means we may be flying blind on everything else. |

---

## 2. The sprawl — why the owner feels overwhelmed

### 2.1 Three parallel "roadmap to production" dossiers

| Dossier | Created | Author | Size | Current state |
|---|---|---|---|---|
| `preproduction/` | 2026-04-20 | External audit prep | 31 files | TODO has 6 phases, checkboxes all `[ ]`; **external audit tarball `handoff/preproduction_external_audit_handoff.tar.gz` was delivered** |
| `perfection/` | 2026-04-21 | Unified merge of preproduction+external+outage+audits01-13 | 47 files (36 evidence) | `PLAN.md` 5 phases, `TODO.md` **212 unchecked items, 0 checked** — yet evidence folder contains **01A, 01B, 01C, 01D, 01E, 01F all executed** |
| `perfect/` | 2026-04-23 (today) | Post-reboot fresh start | 34 files (11 evidence) | Phases 01 complete, 10 findings tracked, rest scaffolded |

All three cover the same ground. None supersedes the others explicitly. Cross-references are inconsistent.

### 2.2 Four session-memory plans

| File | Scope | Status |
|---|---|---|
| `/memories/session/audit_plan.md` | Docker compose file audit (23 files) | Never executed |
| `/memories/session/docs_audit_progress.md` | Documentation extraction (22 docs) | Incomplete — only `DOCUMENTATION_STANDARD.md` extracted |
| `/memories/session/prod_readiness_plan.md` | 10-phase prod-readiness (1F-3) | Outdated — written before `perfect/` existed |
| `/memories/session/perfect_dossier_status.md` | Today's dossier | Current |

### 2.3 13 external audit requests (`~/personal/audits/01..13`)

| # | Request | Executed? | Where is the output? |
|---|---|---|---|
| 01 | Project audit | ❌ Not executed | — |
| 02 | DNS | ❌ Not executed | — |
| 03 | Services | ⚠️ Partial via `perfection/FINDINGS_INDEX.md §3` | `perfection/FINDINGS_INDEX.md` |
| 04 | Performance | ⚠️ Partial (external audit Apr-21 touched it) | `preproduction/audits/PERFORMANCE_CAPACITY_REVIEW.md` |
| 05 | Security & permissions | ⚠️ Partial | `preproduction/audits/SECURITY_HARDENING_REVIEW.md` + `perfection/REPORT.md §3` |
| 06 | Mail system | ❌ Not executed | — |
| 07 | Monitoring system | ⚠️ Partial | `preproduction/audits/MONITORING_ALERTING_REVIEW.md` |
| 08 | Branding & design | ❌ Not executed | — |
| 09 | Governance | ⚠️ Partial | `preproduction/audits/DOCUMENTATION_ACCURACY_REVIEW.md` |
| 10 | Domain strategy | ✅ Complete | `~/.docs/01-architecture/DOMAIN_STRATEGY.md` v4 (owner-approved Feb-18) |
| 11 | Audit of audit | ✅ Complete | `memories.jsonl` (2026-02-18 `AUDIT_OF_AUDIT_COMPLETE`) |
| 12 | FQDN sweep | ❌ Not executed | — |
| 13 | Credentials sweep | ❌ **Explicitly flagged "NEVER executed"** in `perfection/REPORT.md §9C` | — |

**Score: 2/13 complete, 5/13 partial, 6/13 not executed.**

### 2.4 Stale "all done, maintenance mode" at the top

`~/projects/qui3tly.cloud/TODO.md` (Feb 17 2026) says:
> *"Active: No active blockers. All steps complete. Next: Plan complete. Maintenance mode."*

This was **true at Feb 17** but is now **grossly incorrect**. A reader who lands there first will believe the infra is in maintenance mode, when in reality there's a P0 cert cliff in 4 days.

---

## 3. Consolidated finding ledger (de-duplicated)

Every finding across **all** sources, mapped to one canonical ID.

| ID | One-line | Severity | Source IDs (for traceability) | State |
|---|---|---|---|---|
| **F-0001** | Invalid Cloudflare API token (err 9109) → 16 certs cannot renew; `mail.quietly.online` expires 2026-04-28 02:43 UTC | **P0** | perfect/F-0001, perfection/P0-residual+1F, memory `CF API token invalid` | **OPEN — 4.3 days** |
| **F-0002** | Alerting pipeline never delivered F-0001 (unit failure + cert-warning rule) — pipeline Prom→AM→Gotify→phone unverified end-to-end | **P1** | perfect/F-0002, perfection/P1-3 + Phase 4, prod_readiness_plan §2A | **OPEN** |
| **F-0003** | Gotify admin password leaked in `~/.governance/MONITORING.md` (plaintext) | **P1** | perfect/F-0003, memory `known-governance-violations #1` | **OPEN** |
| **F-0009** | UniFi container binds `0.0.0.0:6789/tcp` + `0.0.0.0:10001/udp` on Lady (violates port-binding standard) | **P1** | perfect/F-0009, perfection/FINDINGS §3B, ufw audit | **OPEN** |
| **F-0010** | `docker exec postfix-mailcow postfix reload` returns exit 1 (even independent of F-0001) | **P1** | perfect/F-0010 (new today) | **OPEN** |
| **F-0011** | `admin-panel` container: hot-installs packages on each boot, runs as root, SSH private key mounted, unreviewed Flask code | **P1** | perfection/REPORT §8 | **OPEN** |
| **F-0012** | Zero container resource limits on **both** nodes (21 Master + 14+ Lady without `mem_limit`) | **P1** | perfection/P1-2, perfection/REPORT §9B | **OPEN** |
| **F-0013** | Lady has **no evidenced backup chain** for app data (Mailcow, Nextcloud, Odoo, UniFi, HA, Frigate — 215 GB live data) | **P1** | perfection/P0-2, preproduction audit §C | **OPEN** |
| **F-0014** | No restore drill ever executed on either host (backups without restore = untested backups) | **P1** | perfection/2C, preproduction §C | **OPEN** |
| **F-0015** | 13-audit-requests execution: 6/13 never started, 5/13 only partial | **P2** | perfection/REPORT §9G | **OPEN** |
| **F-0005** | AIDE exclusions incomplete (`service-monitor.log` still triggers diff) | **P2** | perfect/F-0005, perfection/1E | **OPEN — partial fix** |
| **F-0008** | Master `0.0.0.0:8085/tcp` headscale listener — UFW allow-list is CIDR-based; Docker bypass risk to be probed | **P2** | perfect/F-0008 | **OPEN** |
| **F-0016** | `~/projects/qui3tly.cloud/TODO.md` says "maintenance mode, all done" — stale by 67 days; misleads any reader | **P3** | this analysis | **OPEN (doc fix)** |
| **F-0004** | Docs say `systemd-networkd-wait-online` masked only on Lady — actually masked on BOTH | **P3** | perfect/F-0004 | **OPEN (doc fix)** |
| **F-0006** | Lady container count: doc says 39, actual 38 | **P3** | perfect/F-0006 | **OPEN (doc fix)** |
| **F-0007** | EdgeRouter WAN IP drift in doc (`178.20.30.40` vs observed `62.4.55.119`) | **P3** | perfect/F-0007 | **OPEN (doc fix)** |
| **F-0017** | `repo-memory qui3tly_cloud_core.md` claims *"Alertmanager at 10.10.0.1:9093"* — actually AM is **only** on Docker bridge, reachable via Traefik VPN route `alertmanager.quietly.its.me`. Stale/incorrect memory. | **P3** | this analysis (live-verified today) | **OPEN (memory fix)** |

### Closed / reconciled below threshold

- Feb-16 `public@file` residual bugs (pihole, headscale-ui, headscale-admin) → **CLOSED 2026-04-23** by perfection phase 01A (evidence: `perfection/evidence/01A_*`)
- Lady kernel patch backlog (P0-1) → **CLOSED 2026-04-23** by P1B + reboot today
- Lady UFW broad RFC1918 rules (P1-4) → **CLOSED 2026-04-23** by P1D
- Pegasus/Condor/Pelican unscoped listeners (P0-3) → **CLOSED 2026-04-23** by P1C (purged)
- Master AIDE failure (P1-1) → **PARTIALLY CLOSED** by P1E (baseline regenerated; F-0005 remains)
- pihole unhealthy alerts (Mar-19) → **STALE** — 2 months old, current `docker ps` shows pihole healthy. **Not a current finding.**
- acme.json git-history leak (01A `git_secret_leak`) → documented in `perfection/evidence/01A_git_secret_leak_20260423T113912Z.md` — action: history-rewrite still pending. Adding as **F-0018** below.
- **F-0018** *New from reconciliation:* acme.json exposed in git history (even though `.gitignore` now excludes it). History rewrite pending. | **P2** | perfection/01A finding | **OPEN** |

**Net open count: 17 findings** (1 P0 · 6 P1 · 4 P2 · 5 P3 + 1 P2 just reclassified from "documented but no ticket"). The earlier sprawl made this count look like ~30+.

---

## 4. Live system state — verified 2026-04-23 22:39 UTC

Raw evidence: `09-EVIDENCE/deep_analysis_live_20260423T223923Z.txt`

| Check | Master | Lady |
|---|---|---|
| Uptime | 20 min (post-reboot today) | 26 min (post-reboot today) |
| Kernel | 6.1.0-44-cloud-amd64 ✅ | 6.1.0-44-cloud-amd64 ✅ |
| Failed units | **0** | **1** — `mailcow-tlsa.service` (expected; = F-0001) |
| Unhealthy containers | 0 / 25 | 0 / 38 |
| Exited (non-zero) | 0 | 0 |
| Journal priority err+ since boot | none | 1 line — the same mailcow-tlsa failure |
| Load average | 1.28 / 2.40 / 2.26 (normal) | 6.67 / 9.91 / 9.92 (still warming up; expected to settle to ~2-3 within 1 hour based on pre-reboot data) |
| `mail.quietly.online` cert expiry | **2026-04-28 02:43:40 GMT → 4.3 days** | — |
| Prometheus (via Traefik) | https://prometheus.quietly.its.me/ = HTTP 200 ✅ | — |
| Alertmanager (via Traefik) | https://alertmanager.quietly.its.me/ = HTTP 200 ✅ | — |

The fleet is healthy *except* for the expected single symptom of F-0001. No new post-reboot surprises.

---

## 5. Actually-executed work ledger (what's TRULY done vs tracker status)

This reconciles **checkboxes vs evidence on disk**.

| Phase / task | Tracker status | Evidence says | Reality |
|---|---|---|---|
| `perfection/` Phase 1A — public@file residuals | TODO `[ ]` | `evidence/01A_*` — 10 files | ✅ DONE — tracker not updated |
| `perfection/` 1B — Lady patch+reboot | `[ ]` | `evidence/01B_lady_{pre,post,final}_*` | ✅ DONE |
| `perfection/` 1C — HTCondor/Pegasus purge | `[ ]` | `evidence/01C_pegasus_{inventory,deps,purge,post}_*` | ✅ DONE |
| `perfection/` 1D — UFW broad rule fix | `[ ]` | `evidence/01D_lady_ufw_{pre,post}_*` | ✅ DONE |
| `perfection/` 1E — AIDE baseline | `[ ]` | `evidence/01E_master_aideinit_*` | ⚠️ PARTIAL (F-0005 residual) |
| `perfection/` 1F — mailcow-tlsa / cert pipeline | implicit | `evidence/01F_{full,master}_*` + deep analysis today | 🔴 BLOCKED on F-0001 (CF token) |
| `preproduction/` Phase B security hardening | `[ ]` × 6 | Many overlap with perfection 1A-E | ⚠️ MOSTLY DONE via perfection |
| `preproduction/` Phase C backup+DR | `[ ]` × 5 | Nothing on disk | 🔴 NOT STARTED |
| Audit 11 (audit-of-audit) | implied | `memories.jsonl AUDIT_OF_AUDIT_COMPLETE` 2026-02-18 | ✅ DONE (Feb-18) |
| Audit 10 (domain strategy) | implied | `.docs/01-architecture/DOMAIN_STRATEGY.md v4` | ✅ DONE (Feb-18) |
| Audit 13 (credentials sweep) | TODO | `perfection/REPORT §9C` self-flagged as NEVER executed | 🔴 NOT STARTED |

**Root cause of the sprawl**: evidence was saved but **checkboxes were never flipped**. The act of writing `evidence/<file>` was treated as completion, but the tracker UI still shows all `[ ]`.

---

## 6. Recommendation — canonicalize

### 6.1 One tracker only

Promote **`perfect/`** (this folder) to the single authoritative dossier. Retire the other two:

1. `perfection/` → keep as **archive** under `perfect/_archive/perfection_20260421/` (evidence preserved, PLAN/TODO frozen).
2. `preproduction/` → keep as **archive** under `perfect/_archive/preproduction_20260420/`. The external-audit handoff tarball stays.
3. The 4 session-memory plan files → collapse into the existing `perfect_dossier_status.md`.

### 6.2 Fix the stale top-level signals

- Replace `~/projects/qui3tly.cloud/TODO.md` content with a **pointer** to `perfect/PLAN.md` (and note that "maintenance mode" was Feb-17 reality, not current).
- Replace `~/projects/qui3tly.cloud/README.md` container count (claims 64; actual Master 25 + Lady 38 = **63**) and point to `perfect/`.

### 6.3 Close what's already proven done

Mark these phases DONE with evidence pointers in `perfect/PLAN.md`:
- 01A residuals · 01B Lady patch · 01C Pegasus purge · 01D Lady UFW · 01E AIDE (partial) · 10 domain strategy · 11 audit-of-audit.

### 6.4 Keep the pending bar short

After canonicalization, the **owner's worry list shrinks to 17 named findings**, structured:
- **P0 (1)**: F-0001 — token then certs
- **P1 (6)**: F-0002 alerting, F-0003 gotify pw, F-0009 unifi, F-0010 postfix reload, F-0011 admin-panel, F-0012 resource limits (class), F-0013 Lady backup (class), F-0014 restore drill (class)
  - *(yes that's 8 items; F-0012/13/14 are class-level — will open a ticket per affected service as Phase 02 executes)*
- **P2 (4)**: F-0005 AIDE excl, F-0008 Master 8085 probe, F-0015 audit-requests completion, F-0018 acme.json git history
- **P3 (5)**: F-0004, F-0006, F-0007, F-0016, F-0017 (all doc/memory drift, one sitting to fix together)

### 6.5 Execution order after canonicalization

1. **F-0001** (blocks on owner: new CF token) → closes P0 cert risk
2. **F-0002** (me, Phase 04 of `perfect/`) → proves monitoring can be trusted
3. **F-0003 + F-0017** (me + owner) → rotate Gotify password, scrub doc, fix memory
4. **F-0009** (me, L2 approval needed) → UniFi port rebind
5. **F-0010** (me, inside container) → postfix reload bug
6. **F-0013 / F-0014** (me + owner) → Phase 05 backup+restore — needs Q-004, Q-007 answered
7. All P3 doc drift in one commit

---

## 7. Owner questions (new since `perfect/` opened — additive)

Original 7 in `08-TODO/OPEN_QUESTIONS_FOR_OWNER.md` still valid. Adding:

- **Q-008** — Do you agree to canonicalize on `perfect/` and archive `perfection/` + `preproduction/`? (If yes, I'll execute §6.1-6.3 in one commit, L1.)
- **Q-009** — Of the 6 un-started audit requests (01, 02, 06, 08, 12, 13), which do you want executed before go-live? (13 Credentials sweep is the one flagged by prior agents as non-negotiable.)
- **Q-010** — The `preproduction/external/handoff/` tarball was delivered to an external auditor Apr-20. Did they return a report? If so, where? If not, is it still active?

---

## 8. What this analysis *did not* touch (deliberate scope limit, and why)

These stay out so the reconciliation doesn't metastasize again:

- Pen-test-style probing (Phase 03) — needs Q-001 answered
- DNSSEC / MTA-STS / SPF / DKIM / DMARC deep validation — Phase 03E scope
- Per-service Ansible playbook reproducibility check — Phase 06B
- CVE scan per image — Phase 02E
- OWASP Top-10 per public service — Phase 02G

All already tracked in `perfect/PLAN.md`. This deep-analysis does not add new phases — it consolidates the existing ones.

---

## 9. Sign-off

- **Analyst**: GitHub Copilot (Claude Opus 4.7), session 2026-04-23
- **Evidence file**: `09-EVIDENCE/deep_analysis_live_20260423T223923Z.txt`
- **Sources consulted**: `/memories/` (5 files), `~/.copilot/memories.jsonl` (996 entries), `~/personal/audits/` (17 docs), `~/projects/qui3tly.cloud/{preproduction,perfection,perfect,README,PLAN,TODO}`, live-system on both hosts.
- **L0 read-only**. Zero production state changes.
- **No mutations proposed without L1/L2 approval**: §6.1-6.3 (archive + redirect top-level docs) await owner nod; individual finding fixes wait per §6.5.

