#!/usr/bin/env python3
"""
Setup Uptime Kuma monitors for qui3tly.cloud infrastructure.
Run on Master server: python3 setup-uptime-kuma.py

Creates monitors organized by group:
  1. Master Infrastructure (12 monitors)
  2. Master Monitoring (7 monitors)
  3. Master Security (3 monitors)
  4. Lady Applications (7 monitors)
  5. Lady Mail (6 monitors)
  6. Lady Exporters (3 monitors)
  7. Network (4 monitors)
Total: 42 monitors

Requirements: pip3 install uptime-kuma-api
"""

import sys
import time
from uptime_kuma_api import UptimeKumaApi, MonitorType

KUMA_URL = "http://172.30.0.9:3001"  # Docker internal IP (no host port binding)
USERNAME = "qui3tly"
PASSWORD = "RaMpulstilckin123!"

# Lady IPs
LADY_PUBLIC = "207.180.251.111"
LADY_TAILSCALE = "100.64.0.2"

def create_group(api, name, description=""):
    """Create a monitor group and return its ID."""
    result = api.add_monitor(
        type=MonitorType.GROUP,
        name=name,
    )
    gid = result["monitorID"]
    print(f"  ✓ Group '{name}' (id={gid})")
    return gid


def create_http(api, name, url, parent, interval=60, accepted=None, ignore_tls=False, keyword=None, maxretries=3):
    """Create an HTTP(S) monitor."""
    if accepted is None:
        accepted = ["200-299"]

    mon_type = MonitorType.KEYWORD if keyword else MonitorType.HTTP

    kwargs = dict(
        type=mon_type,
        name=name,
        url=url,
        interval=interval,
        retryInterval=30,
        maxretries=maxretries,
        accepted_statuscodes=accepted,
        ignoreTls=ignore_tls,
        parent=parent,
    )
    if keyword:
        kwargs["keyword"] = keyword

    result = api.add_monitor(**kwargs)
    mid = result["monitorID"]
    print(f"    ✓ [{mid}] {name} → {url}")
    return mid


def create_tcp(api, name, hostname, port, parent, interval=60, maxretries=3):
    """Create a TCP port monitor."""
    result = api.add_monitor(
        type=MonitorType.PORT,
        name=name,
        hostname=hostname,
        port=port,
        interval=interval,
        retryInterval=30,
        maxretries=maxretries,
        parent=parent,
    )
    mid = result["monitorID"]
    print(f"    ✓ [{mid}] {name} → {hostname}:{port}")
    return mid


def create_ping(api, name, hostname, parent, interval=60):
    """Create a ping monitor."""
    result = api.add_monitor(
        type=MonitorType.PING,
        name=name,
        hostname=hostname,
        interval=interval,
        retryInterval=30,
        maxretries=3,
        parent=parent,
    )
    mid = result["monitorID"]
    print(f"    ✓ [{mid}] {name} → {hostname}")
    return mid


def create_dns(api, name, hostname, resolver, parent, interval=120):
    """Create a DNS monitor."""
    result = api.add_monitor(
        type=MonitorType.DNS,
        name=name,
        hostname=hostname,
        dns_resolve_server=resolver,
        port=53,
        interval=interval,
        retryInterval=30,
        maxretries=3,
        parent=parent,
    )
    mid = result["monitorID"]
    print(f"    ✓ [{mid}] {name} → {hostname} @{resolver}")
    return mid


def main():
    print(f"Connecting to Uptime Kuma at {KUMA_URL}...")
    api = UptimeKumaApi(KUMA_URL)

    try:
        api.login(USERNAME, PASSWORD)
    except Exception as e:
        print(f"ERROR: Login failed: {e}")
        sys.exit(1)
    print("  ✓ Logged in\n")

    # Check existing monitors
    existing = api.get_monitors()
    if existing:
        print(f"WARNING: {len(existing)} monitors already exist. Aborting to prevent duplicates.")
        print("Delete existing monitors first if you want to recreate them.")
        api.disconnect()
        sys.exit(1)

    total = 0

    # ═══════════════════════════════════════════
    # GROUP 1: Master Infrastructure
    # ═══════════════════════════════════════════
    print("Creating Group 1: Master — Infrastructure")
    g1 = create_group(api, "Master — Infrastructure")

    create_http(api, "Traefik (Master)", "http://traefik:8080/api/overview", g1, interval=30)
    create_http(api, "Portainer", "https://portainer:9443", g1, ignore_tls=True)
    create_http(api, "Pi-hole", "http://pihole:80/admin/", g1, keyword="Pi-hole")
    create_http(api, "Headscale", "https://headscale.quietly.its.me/health", g1, interval=30,
                accepted=["200-299"])
    create_http(api, "Headscale UI", "http://headscale-ui:8080", g1,
                accepted=["200-299", "301", "302"])
    create_http(api, "Headscale Admin", "http://headscale-admin:80", g1)
    create_http(api, "IT Tools", "http://it-tools:80", g1, interval=120)
    create_http(api, "Semaphore", "http://semaphore:3000", g1, interval=120)
    create_http(api, "Gotify", "http://gotify:80", g1)
    create_http(api, "ntfy", "http://ntfy:80", g1)
    create_http(api, "Admin Panel", "http://admin-panel:8080", g1, interval=120)
    create_http(api, "Landing Page", "https://quietly.its.me", g1,
                accepted=["200-299", "301", "302", "303"], interval=120)
    total += 12
    print()

    # ═══════════════════════════════════════════
    # GROUP 2: Master Monitoring
    # ═══════════════════════════════════════════
    print("Creating Group 2: Master — Monitoring")
    g2 = create_group(api, "Master — Monitoring")

    create_http(api, "Grafana", "http://grafana:3000/api/health", g2, interval=30,
                keyword="ok")
    create_http(api, "Prometheus", "http://prometheus:9090/-/ready", g2, interval=30)
    create_http(api, "Alertmanager", "http://alertmanager:9093/-/ready", g2, interval=30)
    create_http(api, "Loki", "http://loki:3100/ready", g2, interval=30,
                keyword="ready")
    create_http(api, "Node Exporter (Master)", "http://node-exporter:9100/metrics", g2, interval=120)
    create_http(api, "cAdvisor (Master)", "http://cadvisor:8080/healthz", g2, interval=120)
    create_http(api, "Blackbox Exporter", "http://blackbox:9115/metrics", g2, interval=120)
    total += 7
    print()

    # ═══════════════════════════════════════════
    # GROUP 3: Master Security
    # ═══════════════════════════════════════════
    print("Creating Group 3: Master — Security")
    g3 = create_group(api, "Master — Security")

    create_http(api, "Authelia", "http://authelia:9091/api/health", g3, interval=30)
    create_http(api, "CrowdSec (Master)", "http://crowdsec:8080/health", g3)
    create_http(api, "CrowdSec Bouncer", "http://bouncer-traefik:8080/api/v1/forwardAuth", g3,
                accepted=["200-299", "403"])
    total += 3
    print()

    # ═══════════════════════════════════════════
    # GROUP 4: Lady Applications
    # ═══════════════════════════════════════════
    print("Creating Group 4: Lady — Applications")
    g4 = create_group(api, "Lady — Applications")

    # Lady services through public Traefik - accept auth redirects as "up"
    lady_accepted = ["200-299", "301", "302", "303", "401", "403"]

    create_http(api, "Nextcloud", "https://nextcloud.quietly.online", g4,
                accepted=lady_accepted)
    create_http(api, "OnlyOffice", "https://office.quietly.online", g4,
                accepted=lady_accepted, interval=120)
    create_http(api, "Odoo", "https://odoo.quietly.online", g4,
                accepted=lady_accepted)
    create_http(api, "Home Assistant", "https://home.quietly.online", g4,
                accepted=lady_accepted)
    create_http(api, "UISP", "https://uisp.quietly.online", g4,
                accepted=lady_accepted, interval=120)
    create_http(api, "Frigate", "https://cctv.quietly.online", g4,
                accepted=lady_accepted, interval=120)
    create_http(api, "Traefik (Lady)", f"http://{LADY_TAILSCALE}:8082/metrics", g4,
                interval=30)
    total += 7
    print()

    # ═══════════════════════════════════════════
    # GROUP 5: Lady Mail
    # ═══════════════════════════════════════════
    print("Creating Group 5: Lady — Mail")
    g5 = create_group(api, "Lady — Mail")

    create_http(api, "Mailcow Web", "https://mail.quietly.online", g5,
                accepted=["200-299", "301", "302", "303", "403"])
    create_tcp(api, "SMTP (25)", LADY_PUBLIC, 25, g5, interval=120)
    create_tcp(api, "SMTPS (465)", LADY_PUBLIC, 465, g5, interval=120)
    create_tcp(api, "Submission (587)", LADY_PUBLIC, 587, g5, interval=120)
    create_tcp(api, "IMAPS (993)", LADY_PUBLIC, 993, g5)
    create_http(api, "MTA-STS", "https://mta-sts.quietly.online/.well-known/mta-sts.txt", g5,
                interval=300)
    total += 6
    print()

    # ═══════════════════════════════════════════
    # GROUP 6: Lady Exporters
    # ═══════════════════════════════════════════
    print("Creating Group 6: Lady — Exporters")
    g6 = create_group(api, "Lady — Exporters")

    create_http(api, "Node Exporter (Lady)", f"http://{LADY_TAILSCALE}:9100/metrics", g6, interval=120)
    create_http(api, "cAdvisor (Lady)", f"http://{LADY_TAILSCALE}:8081/healthz", g6, interval=120)
    create_http(api, "CrowdSec (Lady)", f"http://{LADY_TAILSCALE}:6060/metrics", g6, interval=120)
    total += 3
    print()

    # ═══════════════════════════════════════════
    # GROUP 7: Network
    # ═══════════════════════════════════════════
    print("Creating Group 7: Network")
    g7 = create_group(api, "Network")

    create_ping(api, "Master (public)", "213.136.68.108", g7, interval=30)
    create_ping(api, "Lady (public)", LADY_PUBLIC, g7, interval=30)
    create_ping(api, "Lady (Tailscale VPN)", LADY_TAILSCALE, g7, interval=30)
    create_dns(api, "DNS — Pi-hole", "quietly.its.me", "100.64.0.1", g7, interval=60)
    total += 4
    print()

    # ═══════════════════════════════════════════
    print(f"{'='*50}")
    print(f"DONE: {total} monitors + 7 groups created")
    print(f"View at: https://status.quietly.its.me")
    print(f"{'='*50}")

    api.disconnect()


if __name__ == "__main__":
    main()
