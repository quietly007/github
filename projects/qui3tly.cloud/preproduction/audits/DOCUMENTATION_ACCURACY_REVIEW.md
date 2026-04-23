# DOCUMENTATION ACCURACY REVIEW — EXTERNAL AUDIT

Date: 2026-04-21
Auditor: External / Independent

---

## Confirmed Accurate Claims

| Claim                                    | Evidence Confirmation                        |
|------------------------------------------|----------------------------------------------|
| Twin-server architecture (Master + Lady) | Both snapshots confirm                       |
| Master: Debian 12 Bookworm               | VERSION_ID="12" confirmed                    |
| Lady: Debian 12 Bookworm                 | VERSION_ID="12" confirmed                    |
| Master: 25 containers running            | running_count=25 confirmed                   |
| Lady: 38 containers running              | running_count=38 confirmed                   |
| Both nodes: Traefik v3.6.6               | Confirmed in docker quick output             |
| Both nodes: crowdsec v1.6.8              | Confirmed                                    |
| Both nodes: Fail2ban with 3 jails        | Confirmed: recidive, sshd, traefik-auth      |
| UFW active with deny-incoming on both    | Confirmed in security sections               |
| Master: 20/20 Prometheus targets up      | targets_up=20/20 confirmed                   |
| Master: 0 active alerts                  | alerts=0 confirmed                           |
| Monitoring stack recovered               | All monitoring containers healthy            |
| Authelia on Master                       | authelia/authelia:4.39.15 confirmed          |
| Headscale on Master                      | headscale containers confirmed               |
| Mailcow on Lady                          | 14+ mailcow containers confirmed             |
| Nextcloud on Lady                        | nextcloud + nextcloud-db + nextcloud-redis   |
| Lady 61-day uptime                       | up 61 days, 21:42 confirmed                  |
| Lady kernel older than Master            | 6.1.0-42 vs 6.1.0-44 confirmed              |

Documentation accuracy rate: HIGH. The internal team accurately represented runtime state.

---

## Confirmed Drift / Gaps

| Claim in Docs                   | Reality                                     | Drift Type        |
|---------------------------------|---------------------------------------------|-------------------|
| HTCondor exposure mentioned     | 7 specific 0.0.0.0 listeners confirmed      | Under-quantified  |
| Lady backup "unreliable"        | No backup tooling visible at all            | Understated       |
| AIDE failed on Master           | Only in merged report text, not raw evidence| Traceability gap  |
| "Secrets permissions mostly 600"| Cannot verify — no stat output in evidence  | Evidence gap      |
| Traefik hardening noted         | No config output captured                   | Evidence gap      |

---

## Claims Requiring Additional Evidence

| Claim                                | Missing Evidence                    | Risk  |
|--------------------------------------|-------------------------------------|-------|
| AIDE service failed on Master        | systemctl status aide not in snapshot | HIGH |
| Traefik no insecure/debug mode       | Traefik config not captured         | HIGH  |
| Sysctl hardening state on both nodes | sysctl output not captured          | MED   |
| Secrets file permissions (600)       | stat output not captured            | MED   |
| Container restart policies           | docker inspect not in snapshot      | LOW   |
| Container resource limits explicitly 0| docker inspect not in snapshot     | LOW   |
| Volume types (named vs anonymous)    | docker volume ls not captured       | HIGH  |
| Backup cron/timer existence          | crontab -l not captured             | CRIT  |
| Traefik middleware chain completeness| Router/middleware output not captured| HIGH |
| Docker iptables vs UFW interaction   | iptables -L not captured            | HIGH  |

---

## Additional Evidence Commands (Add to Next Collection Run)

  # Security
  sysctl net.ipv4.conf.all.accept_redirects net.ipv4.conf.all.send_redirects \
         kernel.kptr_restrict kernel.dmesg_restrict net.ipv4.tcp_syncookies \
         kernel.randomize_va_space
  systemctl status aide.service aide.timer
  journalctl -u aide.service -n 30

  # Container governance
  docker inspect $(docker ps -q) | jq '.[] | {Name:.Name, RestartPolicy:.HostConfig.RestartPolicy, Memory:.HostConfig.Memory, User:.Config.User}'
  docker volume ls
  docker system df

  # Backup state
  crontab -l
  systemctl list-timers | grep -i backup
  ls -lh /backup/ 2>/dev/null || echo "NO BACKUP DIR"

  # Traefik
  docker exec traefik cat /etc/traefik/traefik.yml
  curl -s http://127.0.0.1:8080/api/http/routers | jq '.[].middlewares'

  # Network / process
  docker network inspect $(docker network ls -q) | jq -r '.[].IPAM.Config[0].Subnet'
  iptables -L -n -v | head -60
  ls -la /proc/$(ss -tlnp | grep ':5000' | grep -oP 'pid=\K[0-9]+' | head -1)/exe 2>/dev/null

---

## Documentation Structure Assessment

Strengths:
  - MASTER_DOCUMENTATION_INDEX.md provides clear navigation
  - Evidence register maps each file to its purpose
  - VERIFIED / INFERRED / PENDING tiering is the right framework
  - Preproduction package structure is well-organized

Weaknesses:
  1. No FQDN service matrix — no document maps each hostname to service, auth type, expected response, last tested
  2. No config conformity report — no diff between expected and actual compose/env configuration
  3. AIDE failure not directly evidenced in raw snapshots (only in merged report text)
  4. No change log from Feb baseline to April snapshot — audit trail gap
  5. TODO items lack completion dates and evidence file references

---

## Required Documentation Actions

| Action                                          | Priority | Effort |
|-------------------------------------------------|----------|--------|
| Add AIDE systemctl/journal output to evidence   | P1       | 0.5h   |
| Add sysctl output to evidence                   | P1       | 0.5h   |
| Add Traefik config to evidence                  | P1       | 0.5h   |
| Add backup cron/timer to evidence               | P0       | 0.5h   |
| Add docker inspect output to evidence           | P1       | 0.5h   |
| Create FQDN service matrix                      | P1       | 2h     |
| Create change log (Feb to Apr)                  | P2       | 1h     |
| Create config conformity diff                   | P2       | 4h     |

---

## Summary

| Domain                  | Accuracy        | Notes                                           |
|-------------------------|-----------------|-------------------------------------------------|
| Architecture/topology   | HIGH            | Twin-server, networks, services all confirmed   |
| Security posture        | MEDIUM-HIGH     | UFW, Fail2ban, CrowdSec confirmed; AIDE, Traefik, sysctl gaps |
| Container inventory     | HIGH            | Counts, names, versions confirmed               |
| Backup / DR             | ACCURATE ON GAP | Correctly identified as missing — no false "done" |
| Monitoring state        | HIGH            | 20/20 targets, 0 alerts confirmed               |
| Evidence traceability   | MEDIUM          | AIDE P1 claim not directly evidenced in raw snapshots |
| Plan completeness       | HIGH            | Execution plan and TODO accurately reflect open work |
