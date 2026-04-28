# perfect/ — Production Readiness Dossier

> **Project**: qui3tly.cloud  
> **Author**: GitHub Copilot (Claude) under qui3tly ownership  
> **Opened**: 2026-04-23  
> **Status**: 🟡 IN PROGRESS — DO NOT use for production sign-off until `10-PRODUCTION_READINESS/GO_NO_GO.md` is marked ✅  
> **Standard**: `~/.docs/00-standards/DOCUMENTATION_STANDARD.md` (Rule #0: NEVER ASSUME — ALWAYS CHECK)

---

## 🎯 PURPOSE

Single source of truth for the question:

> **"Is qui3tly.cloud ready to go to production?"**

Everything in this folder is derived from **real command output**, recorded as raw evidence under `09-EVIDENCE/`, then synthesised into the numbered analysis folders. No assumptions. No guesses.

## 📂 STRUCTURE

| Folder | Contents |
|---|---|
| `00-EXECUTIVE_SUMMARY.md` | Single-page status for the owner |
| `01-INFRASTRUCTURE_ANALYSIS/` | Topology, services, interfaces, certs, systemd |
| `02-SECURITY_ANALYSIS/` | UFW, port exposure, SSH, secrets, CVE, Crowdsec, OWASP |
| `03-PENETRATION_TESTS/` | External + internal nmap, testssl, HTTP headers, mail & DNS probes |
| `04-MONITORING_ALERTING/` | Prometheus targets, alert rules, Alertmanager, Gotify delivery, log coverage, Uptime-kuma |
| `05-BACKUP_DR/` | Backup inventory, **restore test**, Contabo snapshots, RTO/RPO |
| `06-GOVERNANCE_COMPLIANCE/` | Docs-vs-reality, Ansible reproducibility, Docker layout, FQDN sweep, governance drift |
| `07-FINDINGS/` | P0/P1/P2/P3 findings + master CSV tracker |
| `08-TODO/` | Master TODO, blockers, open questions for owner |
| `09-EVIDENCE/` | Raw command outputs (timestamped `.txt`) |
| `10-PRODUCTION_READINESS/` | Scorecard, final go/no-go, owner sign-off template |
| `PLAN.md` | Execution plan + phase status |

## 🧭 NAVIGATION

- Owner reads first: [`00-EXECUTIVE_SUMMARY.md`](00-EXECUTIVE_SUMMARY.md) → [`10-PRODUCTION_READINESS/GO_NO_GO.md`](10-PRODUCTION_READINESS/GO_NO_GO.md) → [`08-TODO/BLOCKERS.md`](08-TODO/BLOCKERS.md)
- Engineer reads: [`PLAN.md`](PLAN.md) → phase folders → `07-FINDINGS/`
- Auditor reads: `09-EVIDENCE/` raw data → numbered folders for synthesis

## 📋 ACCESS RULES

1. **No mutations** are executed from within this dossier without explicit L2 owner approval.
2. **All raw evidence** lives under `09-EVIDENCE/` with UTC timestamp in the filename.
3. **Every mutating step** performed during remediation is logged to `~/.copilot/memories.jsonl`.
4. **Secrets never appear** in this tree — only paths, patterns, and counts.

## 🔗 CANONICAL REFERENCES

- Rules: `~/.governance/RULES.md`, `PRINCIPLES.md`, `ENFORCEMENT.md`
- Docs standard: `~/.docs/00-standards/DOCUMENTATION_STANDARD.md`
- Phase template: `~/.docs/00-standards/PHASE_COMPLETION_TEMPLATE.md`
- Existing audits: `~/personal/audits/01..13_AUDIT_REQUEST_*.md`
- Prior work: `~/projects/qui3tly.cloud/BASELINE/`, `preproduction/`, `perfection/`

---

**This dossier replaces ad-hoc summaries in chat. If it's not here, it hasn't been verified.**
