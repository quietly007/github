# ORCHESTRATION AND RELIABILITY REVIEW — EXTERNAL AUDIT

Date: 2026-04-21
Auditor: External / Independent

---

## Master — Container Health

25 containers, all Up 7 days (consistent with last reboot).
Health check coverage: 18/25 containers report (healthy). 7 without healthcheck.

Missing healthchecks on critical services:
  - cloudflared: tunnel connectivity is production-critical; should probe DNS through tunnel
  - headscale-admin / headscale-ui: VPN control plane
  - portainer: management plane

---

## Lady — Container Health (Uptime Anomalies)

38 containers. Mixed uptime — requires investigation.

Key anomalies:
  - traefik: Up 2 months — NOT restarted with recent container group. Running for entire 61-day period.
    If config changes were applied in interim, they may not have taken effect without a Traefik restart.
  - nextcloud: Up 5 hours — recently restarted. Unexplained. Could be crash-restart cycle.
  - portainer-agent, mysqld-exporter, cadvisor, node-exporter, crowdsec: Up 6 days — recently restarted as a group.
  - Most Mailcow: Up 2 months — not restarted in 2 months (same as host uptime).

Investigation required:
  docker inspect nextcloud | jq '.[0].State | {StartedAt, FinishedAt, RestartCount}'
  docker inspect traefik | jq '.[0].State.StartedAt'
  docker logs nextcloud --since 6h | tail -50

---

## Docker Networks

Master: bridge, host, monitoring, none, pihole_internal, traefik
  Assessment: Good segmentation. Each function has its own bridge. PASS.

Lady: bridge, host, mailcowdockerized_mailcow-network, monitoring, nextcloud_nextcloud,
      none, odoo-internal, portainer-agent_default, traefik, unifi_unifi
  Assessment: Excellent per-app isolation. Each major stack (Mailcow, Nextcloud, Odoo, UniFi) isolated. PASS.

---

## Restart Policies — Needs Validation

Not captured in evidence. Must confirm all production containers have restart: unless-stopped or restart: always.

Validation:
  docker inspect $(docker ps -q) | jq -r '.[] | "\(.Name): \(.HostConfig.RestartPolicy.Name)"'
  # Any "no" restart policy on production containers = reliability gap

---

## Volume Types — Needs Validation

Anonymous Docker volumes (type: volume, random hash name) are destroyed on docker compose down -v.
All stateful services must use named volumes or host bind mounts.

Validation:
  docker inspect $(docker ps -q) | jq '.[].Mounts[] | {Type:.Type, Source:.Source, Destination:.Destination, Name:.Name}'
  # Look for Type: "volume" with Name matching a random hash — those are anonymous

---

## Reliability Risk Summary

| Risk                                  | Severity | Nodes  |
|---------------------------------------|----------|--------|
| Nextcloud unexplained restart         | Medium   | Lady   |
| Traefik 2-month-old process           | Medium   | Lady   |
| Restart policies unknown              | Medium   | Both   |
| No container resource limits          | High     | Both   |
| Healthcheck gaps (cloudflared, etc.)  | Medium   | Master |
| Anonymous volume risk (unconfirmed)   | High     | Lady   |

---

## Recommendations

1. Restart Traefik on Lady after config review — 2-month process may not reflect current config.
2. Investigate Nextcloud restart cause before production lock.
3. Confirm all production containers have unless-stopped restart policy.
4. Audit volume types for all stateful services.
5. Add HEALTHCHECK to cloudflared, headscale-admin, headscale-ui, portainer.
