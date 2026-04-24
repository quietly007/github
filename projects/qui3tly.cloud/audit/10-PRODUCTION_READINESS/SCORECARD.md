# Production Readiness Scorecard

> **Standard**: based on `~/.docs/00-standards/INFRASTRUCTURE_OVERVIEW.md` (self-assessed 78/100 on 2026-02-17).  
> **This scorecard**: re-assessed from scratch, 2026-04-23, by independent agent with full evidence.  
> **Status**: 🟡 IN PROGRESS — score is provisional until every phase is ✅.

## 📊 CATEGORIES

| Category | Weight | Self-Grade (.docs) | Provisional Grade | Evidence |
|---|---:|---:|---:|---|
| Availability & Uptime | 15 | 85 | TBD | `04-MONITORING_ALERTING/`, `01-INFRASTRUCTURE_ANALYSIS/` |
| Documentation | 10 | 85 | **70 (−15)** | `06-GOVERNANCE_COMPLIANCE/01_DOCS_VS_REALITY.md` — 4 drift items found |
| Security Posture | 20 | 80 | TBD | F-0009 alone already costs points |
| Monitoring & Alerting | 15 | 90 | **30 (−60)** ⚠️ | Pipeline broken — SSLCert alert did not fire despite rule existing |
| Backup & DR | 15 | 95 | TBD | restore test not yet done |
| Change Management | 10 | 70 | TBD | Ansible reproducibility unverified |
| Reliability | 10 | 80 | TBD | `01-INFRASTRUCTURE_ANALYSIS/08_SYSTEMD_UNITS.md` |
| Acceptance Tests | 5 | 70 | TBD | `03-PENETRATION_TESTS/` end-to-end |

**Formula**: `Grade = Σ(weight × category_grade) / 100`

### Running total

Cannot compute yet — too many categories TBD. The two categories scored so far indicate the self-grade of 78 is likely overstated, primarily because **alerting is not actually working** — the single most important production control.

## 🚦 TRAFFIC-LIGHT RULES

| Overall grade | Status |
|---|---|
| ≥ 90 | 🟢 GREEN — production-ready |
| 80–89 | 🟡 YELLOW — pre-prod OK, production with waivers |
| < 80 | 🔴 RED — **not production ready** |

**Any P0 finding open** = automatic RED regardless of arithmetic.

## 📌 KNOWN PROBLEMS BEFORE AUDIT STARTED

1. **P0** — Cloudflare DNS-01 token invalid. 16 certs blocked from renewal.
2. **P1** — Alerting pipeline silent failure.
3. **P1** — UniFi port exposure (F-0009, new).
4. **P1** — `mailcow-tlsa` postfix reload failure (F-0010, new).

See `07-FINDINGS/TRACKER.md`.
