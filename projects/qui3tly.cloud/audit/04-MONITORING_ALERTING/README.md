# MONITORING ALERTING — pending execution

> **Status**: ⬜ not started. Each file below is a placeholder; the agent will overwrite it with real findings from `09-EVIDENCE/` once the phase runs.

See `../PLAN.md` for the ordered task list. Prerequisites:

- Files planned:
  - `01_PROMETHEUS_TARGETS.md` — `/api/v1/targets` up/down
  - `02_ALERT_RULES_AUDIT.md` — all rules, what's actively firing
  - `03_ALERTMANAGER_ROUTING.md` — route tree + synthetic alert test
  - `04_GOTIFY_DELIVERY.md` — priority 5 → phone (requires owner)
  - `05_LOG_COVERAGE.md` — every container's logs reach Loki
  - `06_UPTIME_KUMA.md` — 42 monitors status

**Priority phase** — proves or disproves F-0002 (silent alerting). Tasks T-007/T-008/T-009 ready now (L0).
