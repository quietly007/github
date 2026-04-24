# P2 Findings — Medium severity

## F-0005 — AIDE exclusions still incomplete
- `service-monitor.log` still triggers AIDE diff
- Earlier phase 01E partially addressed but not closed
- Action: re-run `aideinit` after verifying exclusion path

## F-0008 — Master `0.0.0.0:8085/tcp` headscale listener
- UFW claims only allow from `172.18.0.0/16` but Docker bypasses UFW when ports use bare form
- Binary listens on 0.0.0.0, so actual exposure depends on UFW vs nftables ordering
- Action: Phase 03A external nmap probe
