# BASELINE

Infrastructure snapshot verified from live systems on 2026-02-15 and 2026-02-16.  
Everything here is FACT — pulled from running configs, not assumptions.

---

## Contents

| File | What | Source |
|------|------|--------|
| [INFRASTRUCTURE_BASELINE.md](INFRASTRUCTURE_BASELINE.md) | Server inventory, all 64 containers, hardware specs, network interfaces | `docker ps`, `ip addr`, `free`, `lsblk` |
| [TECHNICAL_ARCHITECTURE.md](TECHNICAL_ARCHITECTURE.md) | Architecture design, service distribution, network topology, constraints | Live configs, `docker inspect`, Traefik config |

## Diagrams

All CCIE-level diagrams verified from live system data (2026-02-16):

| File | What |
|------|------|
| [CCIE_NETWORK_TOPOLOGY.md](DIAGRAMS/CCIE_NETWORK_TOPOLOGY.md) | Full Cisco/Visio ASCII topology — all interfaces, IPs, MACs, MTUs, 64 containers mapped |
| [CCIE_FIREWALL_DECISION_TREE.md](DIAGRAMS/CCIE_FIREWALL_DECISION_TREE.md) | Complete netfilter chain traversal with real iptables packet/byte counts |
| [CCIE_DATA_VISUALIZATION.md](DIAGRAMS/CCIE_DATA_VISUALIZATION.md) | 9 Mermaid charts — container distribution, memory, disk, ports, networks |
| [CCIE_PACKET_FLOW_ANALYSIS.md](DIAGRAMS/CCIE_PACKET_FLOW_ANALYSIS.md) | 6 packet trace scenarios — IN/OUT at every interface hop |
| [CCIE_SERVICE_DEPENDENCY_MAP.md](DIAGRAMS/CCIE_SERVICE_DEPENDENCY_MAP.md) | All 64 containers with dependencies, cross-server map, blast radius analysis |
| [CCIE_ROUTING_DECISION_ALGORITHM.md](DIAGRAMS/CCIE_ROUTING_DECISION_ALGORITHM.md) | FIB tables, longest-prefix match, NAT/MASQUERADE rules, network isolation |
| [CCIE_DNS_ARCHITECTURE.md](DIAGRAMS/CCIE_DNS_ARCHITECTURE.md) | 5 resolvers, 3 zones, split-horizon DNS, 6 complete resolution chains |
| [CCIE_TLS_CERTIFICATE_MAP.md](DIAGRAMS/CCIE_TLS_CERTIFICATE_MAP.md) | 17 certificates, ACME issuance flow, termination points, security headers |

19 additional Mermaid diagrams (`.mmd` files) — original architecture diagrams by qui3tly.

## Evidence

Raw audit data in [EVIDENCE/](EVIDENCE/) — container inventories, cron jobs, audit reports.
