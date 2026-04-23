# EXTERNAL AUDIT REQUEST: DOMAIN_STRATEGY.md v5 Review

**Date**: 2026-02-18  
**Requestor**: qui3tly (30yr network veteran, AS8585 operator)  
**Type**: Read-Only Critical Review  
**Subject**: Domain Strategy v4 — Migration Plan Verification  
**Report Location**: `.reports/audits/domain-strategy/$(date +%Y%m%d-%H%M%S)/`

---

## CRITICAL: READ-ONLY AUDIT

**YOU DO NOT MODIFY ANYTHING.**

Your role:
- READ all referenced files and live configurations
- RUN read-only commands to verify claims
- ANALYZE the strategy for correctness, completeness, risks
- IDENTIFY anything missed, any wrong assumptions, any hidden dependencies
- PRODUCE v5 of DOMAIN_STRATEGY.md with corrections and improvements
- WRITE audit report with findings

You DO NOT:
- Modify any running services
- Restart containers or systemd units
- Change firewall rules
- Edit docker-compose files (except writing the v5 document)

---

## CONTEXT

On Feb 17 2026, Traefik crashed on Master and took down the entire VPN mesh (Headscale, Tailscale, all inter-server communication). Root cause: Headscale depended on Traefik for TLS termination and routing.

A domain strategy was developed to fix this. It is now at v4 (approved by owner). Before implementation begins, we need an independent review to catch anything missed.

**The document to review**: `~/.docs/01-architecture/DOMAIN_STRATEGY.md`

**The governing principle (owner-confirmed)**:
```
qui3tly.cloud      = Internal / Corp     → VPN-ONLY, NEVER public
quietly.online     = Public              → Client services (Nextcloud, mail, OnlyOffice)
quietly.its.me     = Public              → Client services (currently Master, may sunset)
quietly.co.me      = Reserved            → Parked for future
```

---

## WHAT WAS AUDITED TO BUILD V4

Live audit of 50+ containers across 2 servers:

### Master Server (213.136.68.108 / 100.64.0.1)
- 26 containers audited (docker labels, middlewares, port bindings)
- Headscale native install (systemd, /etc/headscale/config.yaml)
- Traefik static config, dynamic file-provider config, docker-compose ports
- Pi-hole dnsmasq split-horizon DNS (01-local-dns.conf)
- UFW (23 rules analyzed individually)
- WireGuard (wg0.conf, PostUp iptables, peer config)
- iptables Docker NAT chains (DNAT, MASQUERADE, ts-postrouting)
- Systemd boot order (headscale → tailscaled → docker dependency chain)
- Tailscale debug prefs (ControlURL, Hostname, AdvertiseRoutes)
- Cloudflare DNS zones (qui3tly.cloud, quietly.its.me)

### Lady Server (207.180.251.111 / 100.64.0.2)
- 32+ containers audited (Mailcow 18 containers, Nextcloud stack, Odoo, UniFi, UISP, Frigate, Home Assistant)
- Traefik dynamic config (file-provider routers, middlewares)
- Every docker-compose file checked for Host rules and middleware
- UFW (14 rules)
- Public ports (SMTP/IMAP: 25, 465, 587, 993, 995, 4190)

---

## YOUR AUDIT SCOPE

### 1. VERIFY ALL CLAIMS (Priority: CRITICAL)

The v4 document makes specific technical claims. Verify EACH ONE against live state:

```bash
# Headscale capabilities — can it actually bind port 443?
systemctl cat headscale | grep -i cap

# Docker NAT rules — does 0.0.0.0 DNAT actually conflict?
sudo iptables -t nat -L DOCKER -n -v | head -15

# Boot order — does docker.service.d/ really not exist?
ls -la /etc/systemd/system/docker.service.d/ 2>&1

# Tailscale ControlURL — is it really 127.0.0.1:8085?
tailscale debug prefs 2>/dev/null | grep ControlURL

# Pi-hole bindings — does it really use 100.64.0.1?
docker inspect pihole --format '{{range $p, $conf := .HostConfig.PortBindings}}{{$p}}: {{range $conf}}{{.HostIp}}:{{.HostPort}} {{end}}{{"\n"}}{{end}}'

# Headscale listen address
grep listen_addr /etc/headscale/config.yaml

# WireGuard PostUp rules
sudo cat /etc/wireguard/wg0.conf | grep PostUp

# All Traefik DNAT
sudo iptables -t nat -L DOCKER -n | grep -E "dpt:443|dpt:80"
```

### 2. FIND WHAT WE MISSED (Priority: CRITICAL)

Look for dependencies and impacts we may have overlooked:

- **Cloudflared**: Master runs cloudflared as DNS-over-HTTPS proxy. Does it depend on Traefik? Does it depend on the public IP? Will it break?
- **CrowdSec/Bouncer**: CrowdSec decisions are synced. Does the bouncer communicate via Traefik? Does the LAPI use any of the FQDNs being changed?
- **Promtail/Loki**: Promtail ships logs to Loki at `100.64.0.1:3100`. If boot order changes, does Promtail lose logs during startup?
- **Portainer agent on Lady**: Does it connect back to Master Portainer via an FQDN that's changing?
- **Authelia**: SSO provider. Uses `auth.quietly.its.me`. When this changes to `auth.qui3tly.cloud`, do ALL service configs (Traefik labels) need to reference the new Authelia domain? Is there a session cookie domain issue?
- **Grafana datasources**: Do Grafana's Prometheus/Loki datasource configs reference FQDNs that will change?
- **Semaphore**: Does Ansible/Semaphore have inventory files or playbooks with hardcoded FQDNs?
- **Gotify/Ntfy**: Are there notification URLs hardcoded in monitoring configs (Alertmanager, Prometheus alerting rules)?
- **Docker networks**: Are any Docker bridge networks referenced by IP in configs? Will container IP changes after recreate break anything?
- **Let's Encrypt rate limits**: Headscale issuing a new cert via TLS-ALPN-01 for `headscale.qui3tly.cloud` — is there a rate limit concern for the domain?
- **Headscale ACLs**: Does Headscale have ACL policy that references hostnames or ips that will change?
- **Headscale pre-auth keys / API keys**: Will changing `server_url` invalidate existing API keys used by headscale-ui and headscale-admin?
- **Cron jobs / systemd timers**: Are there scheduled tasks that reference FQDNs being changed?
- **SSH config**: Does `~/.ssh/config` reference any FQDNs being changed?
- **Git remotes**: Do repos reference any of the changing FQDNs?
- **Browser bookmarks / client configs**: Document which client-side changes are needed (bookmarks, Pi-hole admin URL, etc.)
- **Fail2Ban**: Does it reference any FQDNs?
- **TLS certificate chain**: When Traefik moves to VPN IPs and gets `*.qui3tly.cloud` cert via CF DNS-01, will the cert work from the Office LAN (192.168.99.0/24)? Those clients resolve via Pi-hole but do they trust the cert?

### 3. VALIDATE PHASE 3 ATOMIC WINDOW (Priority: CRITICAL)

Phase 3 (Headscale Independence) is the most dangerous operation. Stress-test it:

- What happens if step 5 (Traefik recreate) succeeds but step 8 (Headscale restart) fails?
  - Is the rollback path actually safe?
  - How long is the mesh down during the window?
- What happens if TLS-ALPN-01 cert issuance takes 30+ seconds? Is there a gap where Headscale is up but has no cert?
- Can you verify Headscale supports `listen_addr: 213.136.68.108:443` (specific IP, not 0.0.0.0)?
- After Master's Tailscale re-registers on `https://headscale.qui3tly.cloud`, does it resolve that via Pi-hole (which needs tailscale0) or via system DNS? Potential circular dependency?
- What is Lady's EXACT Tailscale re-registration process? Does `tailscale up --login-server=...` require re-authentication (headscale preauthkey)?

### 4. VALIDATE OPTION D ASSUMPTIONS (Priority: HIGH)

- **"Zero public services on Master"** — Is this actually true after checking the live `default-landing` and `fuckoff-page` routers? The fuckoff-page catches `*.quietly.its.me` and IS served to the public internet. Does this break?
- **"Docker creates per-IP DNAT rules"** — Verify this is actually how Docker behaves with `100.64.0.1:443:443` binding. Run a test or find Docker documentation.
- **"Kernel local routes handle wg0→tailscale0"** — Trace an actual packet from `10.10.0.2` (Office client) trying to reach `100.64.0.1:443`. Does it work?
- **"Headscale on 213.136.68.108:443 is reachable while Docker DNAT to 100.64.0.1:443 exists"** — Are you SURE Docker's PREROUTING chain doesn't interfere? Check iptables chain order.

### 5. REVIEW LADY MIGRATION (Priority: HIGH)

- Lady's 7 VPN-only services move to `*.qui3tly.cloud`. Lady's Traefik currently binds `0.0.0.0:443`.
- How does Lady's Traefik serve BOTH `*.quietly.online` (public) AND `*.qui3tly.cloud` (vpn-only) on the same port?
- Does SNI routing handle this automatically?
- Does the `vpn-only@file` middleware on Lady match the same IP ranges as Master? Compare both.
- Lady needs `*.qui3tly.cloud` TLS cert. Same CF DNS-01 token question applies.

### 6. SECURITY REVIEW (Priority: HIGH)

- The 3 `public@file` bugs (headscale-ui, headscale-admin, pihole) — are they exploitable NOW? What's the actual exposure?
- `CF_Token` plaintext in Lady mailcow compose — what's the blast radius if compromised?
- After migration, `headscale.qui3tly.cloud` resolves to `213.136.68.108` publicly. Is the Headscale API surface appropriate for public internet exposure? What endpoints does it expose?
- WireGuard private key is in `/etc/wireguard/wg0.conf` — file permissions OK?

### 7. DOCUMENTATION CROSS-CHECK (Priority: MEDIUM)

Cross-reference DOMAIN_STRATEGY.md v4 against these docs for consistency:

```
~/.docs/01-architecture/NETWORK_ARCHITECTURE.md
~/.docs/01-architecture/RFP.md
~/.docs/03-services/HEADSCALE.md
~/.docs/03-services/TRAEFIK.md
~/.docs/03-services/PIHOLE.md
~/.docs/03-services/CROWDSEC.md
~/.docs/03-services/MONITORING.md
~/personal/audits/AUDIT_REQUESTS_SUMMARY.md
```

Are there contradictions? Stale information? Missing updates that should be planned?

---

## OUTPUT REQUIREMENTS

### Report Files

Save to `.reports/audits/domain-strategy/$(date +%Y%m%d-%H%M%S)/`:

| File | Content |
|------|---------|
| `VERIFICATION_REPORT.md` | Every claim from v4 verified against live state (PASS/FAIL/WARNING) |
| `MISSED_DEPENDENCIES.md` | Dependencies and impacts not covered in v4 |
| `PHASE3_STRESS_TEST.md` | Atomic window analysis, failure modes, timing |
| `SECURITY_FINDINGS.md` | Current exposure from bugs + migration risks |
| `RECOMMENDATIONS.md` | Prioritized list of things to fix/add before implementation |

### DOMAIN_STRATEGY.md v5

**Produce** `~/.docs/01-architecture/DOMAIN_STRATEGY.md` with:
- All v4 content preserved (don't remove anything that's correct)
- Corrections for any verified errors
- Missing dependencies added to impact analysis
- Missing risks added to risk register
- Phase 3 procedure refined if needed
- Any new phases or steps identified
- Authelia session domain issue documented (if applicable)
- Client-side change checklist added
- Version bumped to v5 with change log entry

---

## REFERENCE: INFRASTRUCTURE QUICK FACTS

```
Master (213.136.68.108):
  Headscale: native systemd, 0.0.0.0:8085, server_url=headscale.quietly.its.me
  Traefik:   Docker, 0.0.0.0:443, CF DNS-01 certs
  Pi-hole:   Docker, 100.64.0.1:53 + 10.10.0.1:53
  WireGuard: native, 0.0.0.0:51820/udp, peer=EdgeRouter
  Tailscale: native, ControlURL=http://127.0.0.1:8085
  UFW:       23 rules (SSH 1006, HTTP/S, WG, TS, STUN, forwarding)
  Boot:      headscale → tailscaled → docker (no explicit ordering for docker)

Lady (207.180.251.111):
  Traefik:   Docker, 0.0.0.0:443
  Mailcow:   Docker, 18 containers, SMTP/IMAP on 0.0.0.0
  Nextcloud:  Docker, cloud.quietly.online (public)
  Tailscale: native, ControlURL=https://headscale.quietly.its.me
  UFW:       14 rules (SSH, HTTP/S, SMTP/IMAP, Tailscale)

Network:
  Tailnet:   100.64.0.0/10 (Master .1, Lady .2, Mac .3)
  WireGuard: 10.10.0.0/30 (Master .1 ↔ EdgeRouter .2)
  Office:    192.168.99.0/24 (via EdgeRouter → WireGuard → Master)
  
Domains:
  qui3tly.cloud    → CF nameservers: aarav, sarah    → internal/corp
  quietly.its.me   → CF nameservers: ernest, daniella → public
  quietly.online   → CF nameservers: ?                → public (Lady)
  quietly.co.me    → parked
```

---

## MOTIVATION

This is a major infrastructure change affecting every service across two servers. The document has been through 4 revisions but was authored by the same team (owner + Lucky Luke). A fresh pair of eyes is needed to catch blind spots, verify assumptions, and stress-test the migration plan before we touch production.

**Get it right. We get one shot at Phase 3.**
