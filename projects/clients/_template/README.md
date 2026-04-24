<!-- template_version: 1.0.0 -->
# Client template

Copy this folder to `clients/<client-slug>/` for each new engagement.

## Files

- `README.md`         — this file; tracks status + contacts
- `status.yaml`       — machine-parseable engagement state
- `PROPOSAL.md` / `.html` / `print.css` — what you send the client
- `SOW.md`            — Statement of Work (signed before Go-Live)
- `RUNBOOK.md`        — how Ops operates this client's service (internal-ish)
- `ACCESS.md`         — pointer to `~/.secrets/clients/<slug>/` (never inline creds)
- `onboarding/`       — end-user guides (PDFs, Nextcloud/OnlyOffice quickstarts)
- `reports/`          — monthly/quarterly reports
- `_internal/`        — REALITY_ANALYSIS, pricing math, competitor notes — NEVER SHIP

## Status stages

`prospect → proposal → negotiating → signed → live → steady → churned`

Update `status.yaml` on every stage change.
