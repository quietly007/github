# SECURITY ANALYSIS — pending execution

> **Status**: ⬜ not started. Each file below is a placeholder; the agent will overwrite it with real findings from `09-EVIDENCE/` once the phase runs.

See `../PLAN.md` for the ordered task list. Prerequisites:

- Files planned:
  - `01_FIREWALL_AUDIT.md` — UFW both hosts, iptables, Docker bypass test
  - `02_PORT_EXPOSURE.md` — all 0.0.0.0 listeners classified
  - `03_SSH_POSTURE.md` — sshd_config, keys, ciphers
  - `04_SECRETS_SWEEP.md` — repo leaks, permissions, rotation list
  - `05_CVE_SCAN.md` — trivy output per image
  - `06_CROWDSEC_FAIL2BAN.md` — bans, decisions, scenarios
  - `07_OWASP_TOP10.md` — per public service

Starts after top-level docs are approved. L0 read-only.
