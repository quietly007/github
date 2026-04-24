# PENETRATION TESTS — pending execution

> **Status**: ⬜ not started. Each file below is a placeholder; the agent will overwrite it with real findings from `09-EVIDENCE/` once the phase runs.

See `../PLAN.md` for the ordered task list. Prerequisites:

- Files planned:
  - `01_EXTERNAL_NMAP.md` — from off-net vantage point
  - `02_INTERNAL_NMAP.md` — from Tailscale
  - `03_TLS_TESTSSL.md` — testssl.sh on every HTTPS endpoint
  - `04_HTTP_HEADERS.md` — security header audit
  - `05_MAIL_PROBES.md` — SPF/DKIM/DMARC/MTA-STS/TLSA/RBL/DNSSEC
  - `06_DNS_PROBES.md` — zone transfer, open resolver, caa, dnssec
  - `07_WEB_APP_FUZZ.md` — deferred, needs owner approval Q-001(c)
  - `08_FINDINGS_RANKED.md` — CVSS-scored output

Blocked on `08-TODO/OPEN_QUESTIONS_FOR_OWNER.md` Q-001 + Q-002.
