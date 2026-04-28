# Norma — Operator Runbook

**Live since**: 2026-02-03 · **VPN rollout**: 2026-04-24 (HQ first)

## 1 — Access map

| What | Where | How |
|------|-------|-----|
| Nextcloud (end users) | https://nextcloud.quietly.online | public HTTPS |
| OnlyOffice (editing) | https://office.quietly.online | VPN required |
| Norma HQ router | `ssh norma-hq` | WireGuard `10.10.0.3` |
| Nextcloud container | on `lady` (see `~/.docker-compose/nextcloud/`) | `ssh lady` |

## 2 — Per-branch LAN plan

| Branch | Location | LAN | VPN endpoint | Alias |
|--------|----------|-----|--------------|-------|
| HQ | Budva, Lazi bb | `192.168.110.0/24` | WireGuard `10.10.0.3` | `norma-hq` |
| Retail | Budva, Lazi bb | `192.168.111.0/24` | TBD | `norma-retail` |
| Ceramics | Obilaznica | `192.168.112.0/24` | TBD | `norma-ceramics` |
| Warehouse | Lastva Grbaljska | `192.168.113.0/24` | TBD | `norma-warehouse` |

Non-overlapping. HQ currently uses WireGuard site-to-site. Future branches may use WireGuard or Tailscale-capable hardware.

## 3 — Common operations

**Rotate Nextcloud admin password**: on `lady`, `docker exec -u www-data <nextcloud-container> php occ user:resetpassword norma_admin`

**Add a VPN endpoint (new MikroTik branch)**: current production path is WireGuard on MikroTik hAP ac lite (mipsbe).

**Critical DHCP rule for HQ**: keep DHCP DNS on `192.168.110.0/24` set to reachable resolvers only (`10.10.0.1,1.1.1.1`). Wrong DNS (for example `192.168.88.1`) causes "internet down" symptoms even when WAN and WireGuard are healthy.

**If deploying Tailscale-capable branch hardware**: on `master`,
```bash
sudo headscale preauthkeys create --user norma --expiration 2h --reusable=false
# give key to installer, they paste on MikroTik /interface/tailscale/up
sudo headscale nodes rename -i <id> norma-<branch>
sudo headscale routes enable -r <route-id>   # after branch advertises-routes
```

**Known incident (Feb 16, 2026)**: truncated Nextcloud uploads for `norma_admin` — resolved. Full report: `~/.reports/Norma/nextcloud/INCIDENT_NEXTCLOUD_UPLOAD_FAILURE.md`.

## 4 — Pending / TODO

- [ ] Fill `primary_contact` in `status.yaml`
- [ ] Headscale ACL before 2nd Norma node joins (currently unrestricted mesh)
- [ ] MikroTik firewall: restrict VPN→LAN to specific ports (not any/any)
- [ ] Onboard remaining 3 branches (Retail, Ceramics, Warehouse)
