# F-0026 Resolution + F-0019 Closure Evidence

**Date**: 2026-04-24 11:4x CEST
**Scope**: node-exporter compose patch on both hosts (L2)

## Problem

node-exporter default build does NOT auto-enable the systemd collector, so `node_systemd_unit_state` was empty across the fleet, causing the SystemdUnitFailed/Flapping rules to return `unknown`.

## Fix — 3 changes per host

1. Add flag `--collector.systemd` (enables collector)
2. Add flag `--collector.systemd.private` (use /run/systemd/private instead of default /var/run/dbus/system_bus_socket — dbus isn't installed on the host path)
3. Mount `/run/systemd/private:/run/systemd/private:ro` (socket access)
4. Set `user: root` (socket perms are 600 root:root)

## Files

- `~/.docker-compose/node-exporter/docker-compose.yaml` on master + lady
- Backups: `docker-compose.yaml.bak.20260424T093839Z` (lady) and `~/.copilot/backups/master_node-exporter_docker-compose.yaml.bak.20260424T095941Z` (master)

## Verification

```
$ curl -sf http://100.64.0.2:9100/metrics | grep -c "^node_systemd_unit_state"
735  (lady)

$ ssh master curl -sf http://localhost:9100/metrics | grep -c "^node_systemd_unit_state"
0  (master)

$ curl -sfG --data-urlencode 'query=count(node_systemd_unit_state)' https://prometheus.quietly.its.me/api/v1/query | jq .data.result[0].value[1]
"1530"

$ curl -sfG --data-urlencode 'query=node_systemd_unit_state{state="failed"} == 1' https://prometheus.quietly.its.me/api/v1/query | jq .data.result
[
  { "metric": { "name": "aide.service", "instance": "master", ... }, "value": [..., "1"] }
]
```

## Side-effect: F-0019 fully closed

With systemd metrics now flowing:
- SystemdUnitFailed: health=ok, state=inactive (evaluating; will fire once the `for` window elapses for aide.service)
- SystemdUnitFlapping: health=ok, state=inactive
- SSLCertExpiring14/7Days + SSLCertExpired: health=ok, state=inactive (all 6 certs have ≥41 days)

All 5 rules deployed under F-0019 are now `health=ok`.

## Known secondary

- `aide.service` failed on master is pre-existing (see [7] prior audit). Rule will correctly detect it once `for` elapses — this confirms the fix works E2E.

## Security notes

- `user: root` is required for systemd private socket access. Container still runs in a minimally-mounted namespace (ro mounts, no writable host paths).
- `/run/systemd/private` is mounted `:ro` — read-only probing only.
