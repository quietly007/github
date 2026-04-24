# P1 Findings — High severity

## F-0002 — Alerting pipeline silent failure
- `SSLCertExpiring14Days` rule is loaded but did not reach owner
- `mailcow-tlsa.service` failures never generated a page
- Entire chain (rule → Prometheus → Alertmanager → Gotify → phone) unverified
- Action: Phase 04C synthetic-alert test, including T-010/T-011
- Blocks: **every** "green" inference in this dossier until proven

## F-0003 — Gotify credential leaked in `~/.governance/MONITORING.md`
- Plaintext admin password in a committed doc
- Violates `~/.governance/SECRETS.md` ("never in docs, repo, or logs")
- Action: rotate password, scrub doc, notify owner to re-pair mobile app
- Blocks: governance compliance

## F-0009 — UniFi public port exposure
- `0.0.0.0:6789/tcp` + `0.0.0.0:10001/udp` (throughput test + device discovery)
- Violates `SECURITY_STANDARDS.md` port-binding rule
- Action: compose edit → rebind to `100.64.0.2:` or remove (L2 approval, B-004)

## F-0010 — `mailcow-tlsa.service` postfix reload bug
- `docker exec postfix-mailcow postfix reload` → exit 1 every run
- Second bug in the same unit; even after F-0001 fix, cert pickup in Mailcow won't happen
- Action: investigate inside container (config syntax, master.cf, or unit perms)
