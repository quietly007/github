# SECURITY HARDENING REVIEW — EXTERNAL AUDIT

Date: 2026-04-23
Auditor: External / Independent
Scope: Patch posture, firewall, exposed listeners, integrity monitoring, proxy hardening, defensive controls

## Executive Result

Security gate status: FAIL
Reason: active P0 security blockers remain unresolved.

## Confirmed P0 Security Blockers

1. Lady patch backlog and kernel drift
- Evidence: Lady kernel 6.1.0-42, uptime 61 days.
- Risk: internet-facing mail/application node running behind patch cadence.
- Required remediation: patch + reboot + post-reboot health verification.

2. Non-core external listeners on Lady
- Evidence: 0.0.0.0 listeners include 9618, 6789, 6769, 4691, 2529, 30715, and python3 on 5000.
- Risk: unnecessary attack surface and unknown process exposure.
- Required remediation: identify owner of each listener, remove/disable HTCondor/Pegasus services, remove or restrict python3:5000.

3. Unknown python process exposed on Lady (port 5000)
- Evidence: python3 pid(s) bound to 0.0.0.0:5000.
- Risk: possible debug/admin endpoint exposed externally.
- Required remediation: identify process commandline and binary path, kill or bind to localhost/VPN only, document service ownership.

## Confirmed P1 Security Issues

1. Master AIDE integrity monitor failure
- Evidence source: merged audit report references aide.service failure.
- Risk: inability to detect unauthorized file changes on control-plane node.
- Required remediation: diagnose failure, reinitialize if needed, enable timer, collect evidence output.

2. Lady firewall broad internal allow rules
- Evidence: UFW allows inbound 172.16.0.0/12 and 10.0.0.0/8.
- Risk: weak segmentation, easier lateral movement from compromised container space.
- Required remediation: replace broad rules with exact Docker bridge subnets only.

3. Traefik hardening not fully evidenced
- Evidence gap: no static/dynamic Traefik configuration dump in evidence set.
- Risk: inability to confirm middleware/auth/header coverage and dashboard lock-down.
- Required remediation: capture config + router middleware map and validate all public routes.

## Existing Defensive Controls (Positive)

- UFW enabled on both nodes with deny incoming by default.
- Fail2ban active on both nodes with recidive/sshd/traefik-auth jails.
- CrowdSec and Traefik bouncer deployed on both nodes.
- Prometheus targets reported healthy in snapshot (monitoring visibility present).

## Required Validation Commands

Run and archive outputs under preproduction/evidence:

- Lady patch and kernel status:
  - apt list --upgradable 2>/dev/null
  - uname -r
  - uptime

- Listener ownership and cleanup verification:
  - ss -tlnp | grep '0.0.0.0'
  - ls -la /proc/<pid>/exe
  - cat /proc/<pid>/cmdline | tr '\0' ' '

- Firewall correctness:
  - docker network inspect $(docker network ls -q) | jq -r '.[].IPAM.Config[0].Subnet'
  - ufw status verbose

- AIDE health:
  - systemctl status aide.service aide.timer
  - journalctl -u aide.service -n 50
  - aide --check

- Traefik security validation:
  - docker exec traefik cat /etc/traefik/traefik.yml
  - curl -s http://127.0.0.1:8080/api/http/routers | jq '.[] | {name:.name,middlewares:.middlewares}'
  - curl -si https://<public-fqdn>/ | grep -iE 'strict-transport|x-frame|x-content-type'

## Acceptance Criteria for Security Gate PASS

- Lady fully patched and reboot-verified.
- No unexplained non-core 0.0.0.0 listeners.
- python3:5000 removed or constrained with documented owner.
- Master AIDE timer active and clean check run recorded.
- Lady UFW broad allow rules removed and replaced by exact subnets.
- Traefik security middleware and dashboard lock-down verified by evidence.

## Rollback Notes

- Snapshot both nodes before security remediations.
- If service breakage occurs after listener/firewall changes, restore last known-good rule set and reintroduce restrictions incrementally.
- AIDE reinitialization is non-destructive but should be performed only after confirming baseline integrity.
