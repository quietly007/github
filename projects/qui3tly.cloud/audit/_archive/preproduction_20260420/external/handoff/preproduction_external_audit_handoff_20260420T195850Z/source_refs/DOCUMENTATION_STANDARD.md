# DOCUMENTATION STANDARD - MANDATORY FOR ALL AGENTS

> **Author**: qui3tly (One of the first CCIE in the region)  
> **Effective Date**: 2026-01-24  
> **Status**: MANDATORY - ALL documentation MUST follow this standard  
> **Violation**: Results in document rejection and rework

---

## 🚨 RULE #0: NEVER ASSUME - ALWAYS CHECK THE SYSTEM!

**THIS IS THE MOST IMPORTANT RULE!**

Before documenting ANYTHING:
1. **Run the actual commands** to get real data
2. **Read the actual config files** - don't guess
3. **Check the actual system state** - don't assume

### Critical Commands:

```bash
# Network interfaces - GET REAL DATA!
ip addr show           # Real IPs, masks, broadcast
ip route show          # Real gateway, routes
ip link show           # Real MTU, MAC, state
ip -s link             # Real traffic stats

# Firewall - GET REAL RULES!
iptables -L -n -v      # Real firewall rules
ufw status verbose     # Real UFW config

# DNS - GET REAL CONFIG!
cat /etc/resolv.conf   # Real DNS servers
cat /etc/hosts         # Real host entries

# Services - GET REAL STATUS!
systemctl status <service>  # Real service state
docker ps -a                # Real container state
docker inspect <container>  # Real container config

# Config files - READ THEM!
cat /path/to/config    # Read actual config
ls -la /path/          # Check actual files exist
```

### ❌ NEVER DO THIS:
- ❌ "Probably uses /18 subnet" → NO! Check with `ip addr show`
- ❌ "Should be /10" → NO! Check the actual mask
- ❌ "Gateway is probably..." → NO! Check `ip route show`
- ❌ "MTU should be 1500" → NO! Check `ip link show`
- ❌ "Config probably says..." → NO! `cat` the actual file!

### ✅ ALWAYS DO THIS:
- ✅ Check system FIRST, document SECOND
- ✅ Copy exact values from actual commands
- ✅ If unsure, run the command
- ✅ Document what IS, not what "should be"

**A real CCIE doesn't guess. A real CCIE checks!**

---

## 🎯 THE STANDARD

**Every technical document in qui3tly.cloud infrastructure MUST include:**

### 1. Modern Visual Diagrams (Mermaid)
- Colorful, cloud-style visual representations
- Shows relationships and data flow
- Easy to understand at a glance
- Good for presentations and quick reference

### 2. OLD SCHOOL ASCII ART DIAGRAMS (MANDATORY!)
- **Cisco CCIE-level detail** - interface specifications with:
  - Interface names with dots/circles (●)
  - IP addresses with subnet masks (/32, /24, etc.)
  - Gateway addresses
  - MTU sizes
  - MAC addresses (where applicable)
  - Speeds (1 Gbps, 10 Gbps, etc.)
  - Encapsulation types (WireGuard, Ethernet, etc.)
- **Decision trees** with boxes (┌─┐), diamonds (╔═╗), arrows (→▼)
- **Algorithm flowcharts** like ResearchGate research papers
- **Packet tracing** with step-by-step interface traversal
- **Routing tables** with complete entries (Destination, Gateway, Interface, Metric)
- **NEVER** vague statements like "packet arrives" - ALWAYS specify:
  - "Packet arrives on interface ● eth0 (IP: 213.136.68.108/32, Gateway: 213.136.68.1)"

### 3. Complete Specifications
- Every IP address documented
- Every subnet mask documented
- Every port documented
- Every configuration file location documented
- No ambiguity, no assumptions

### 4. Decision Matrices
- Troubleshooting selection tables
- Method comparison tables
- Symptom → Diagnosis → Fix tables

### 5. Real-World Examples
- Packet flow scenarios with interface-level detail
- Configuration examples with actual values
- Command outputs with explanations

---

## ❌ UNACCEPTABLE (Will be REJECTED)

```
BAD EXAMPLE - AMATEUR HOUR:
┌─────────────────┐
│  PACKET ARRIVES │  ← NO! Where? Which interface? What IP?
└─────────────────┘

┌─────────────────┐
│  Route to host  │  ← NO! Via which interface? Next-hop IP?
└─────────────────┘
```

---

## ✅ ACCEPTABLE (CCIE Level)

```
GOOD EXAMPLE - CISCO CCIE LEVEL:
┌──────────────────────────────────────────────────────────┐
│  PACKET ARRIVES ON PHYSICAL INTERFACE                    │
│  (Layer 2 frame received)                                │
└──────────────────────┬───────────────────────────────────┘
                       │
                       ▼
┌───────────────────────────────────────────────────────────┐
│ ● eth0 (Physical WAN Interface)                          │
│ ─────────────────────────────────────────────────────────│
│ IP Address:     213.136.68.108/32                        │
│ Subnet Mask:    255.255.255.255 (Host route)             │
│ Gateway:        213.136.68.1                             │
│ MAC Address:    00:50:56:xx:xx:xx                        │
│ MTU:            1500 bytes                               │
│ Speed:          1 Gbps (1000Base-T)                      │
│ Duplex:         Full                                     │
│ Provider:       Contabo Germany (Frankfurt)              │
│ VLAN:           Untagged (Native)                        │
│ Status:         UP/UP (Physical + Protocol)              │
└───────────────────────┬───────────────────────────────────┘
                        │
                        ▼
              ╔═════════════════════════╗
              ║ DESTINATION IP ADDRESS? ║
              ╚═══════════┬═════════════╝
```

**See the difference?** EVERY detail specified! This is CCIE-level documentation!

---

## 📐 REQUIRED INTERFACE SPECIFICATION FORMAT

When documenting ANY network interface, include ALL of these:

```
● <interface_name> (<Type>)
─────────────────────────────────────────
IP Address:     <IP>/<CIDR>
Subnet Mask:    <mask> 
Gateway:        <gateway_ip>
MAC Address:    <mac> (if applicable)
MTU:            <size> bytes
Speed:          <speed> Mbps/Gbps
Duplex:         Full/Half
Encapsulation:  <type> (Ethernet, WireGuard, etc.)
VLAN:           <vlan_id> or Untagged
Provider:       <isp/datacenter> (if WAN)
Status:         UP/UP or DOWN
Purpose:        <brief description>
```

### Examples:

**Physical Interface:**
```
● eth0 (Physical Ethernet - WAN)
─────────────────────────────────────────
IP Address:     213.136.68.108/32
Subnet Mask:    255.255.255.255
Gateway:        213.136.68.1
MAC Address:    00:50:56:3f:2a:1b
MTU:            1500 bytes
Speed:          1 Gbps (1000Base-T)
Duplex:         Full
Provider:       Contabo Germany
Status:         UP/UP
Purpose:        Public internet access
```

**Virtual Interface:**
```
● wg0 (Virtual WireGuard Tunnel)
─────────────────────────────────────────
IP Address:     10.10.0.1/30
Subnet Mask:    255.255.255.252
Peer IP:        10.10.0.2 (EdgeRouter)
MTU:            1420 bytes (overhead for crypto)
Encapsulation:  WireGuard
Endpoint:       178.20.30.40:51820
Public Key:     [MASTER_PUB_KEY]
Listen Port:    51820/udp
Allowed IPs:    0.0.0.0/0 (full routing)
Status:         UP
Purpose:        P2P tunnel to home network
```

**VPN Interface:**
```
● tailscale0 (Virtual WireGuard Mesh)
─────────────────────────────────────────
IP Address:     100.64.0.1/10
Subnet Mask:    255.192.0.0
MTU:            1280 bytes
Encapsulation:  WireGuard (Tailscale overlay)
Control Plane:  Headscale (localhost:8080)
Peers:          100.64.0.2 (Lady), 100.64.0.3 (Mac)
Encryption:     ChaCha20-Poly1305
Status:         UP
Purpose:        Secure mesh VPN between servers
```

---

## 📊 ROUTING TABLE FORMAT

When documenting routing tables, use this format:

```
═══════════════════════════════════════════════════════════════════════
                        ROUTING TABLE
                     (ip route show output)
═══════════════════════════════════════════════════════════════════════

Destination          Gateway          Interface     Metric   Protocol
───────────────────────────────────────────────────────────────────────
0.0.0.0/0            213.136.68.1     ● eth0        100      static
100.64.0.0/10        0.0.0.0          ● tailscale0  0        kernel
10.10.0.0/30         0.0.0.0          ● wg0         0        kernel
192.168.99.0/24       10.10.0.2        ● wg0         50       static
172.17.0.0/16        0.0.0.0          ● docker0     0        kernel
127.0.0.0/8          0.0.0.0          ● lo          0        kernel

═══════════════════════════════════════════════════════════════════════
```

---

## 🔀 PACKET FLOW DOCUMENTATION

When tracing packet flows, document EVERY interface traversal:

```
SCENARIO: Home user accessing Grafana via VPN
──────────────────────────────────────────────────────────────────────

[Mac Mini]                    [EdgeRouter]              [Master]
192.168.99.100                 10.10.0.2                 213.136.68.108
     │                             │                           │
     │ 1. DNS Query                │                           │
     │    grafana.quietly.its.me   │                           │
     │    OUT: ● en0 (192.168.99.100)│                          │
     │    ────────────────────────▶ │                           │
     │                             │ 2. Forward to Pi-hole     │
     │                             │    IN:  ● eth1.0          │
     │                             │    OUT: ● wg0 (10.10.0.2) │
     │                             │    ──────────────────────▶│
     │                             │                           │ 3. Pi-hole lookup
     │                             │                           │    IN: ● wg0 (10.10.0.1)
     │                             │                           │    Query: docker exec pihole
     │                             │                           │    Result: 100.64.0.1
     │                             │    DNS Response            │
     │                             │◀────────────────────────── │
     │    DNS Response             │                           │
     │◀─────────────────────────── │                           │
     │    IN: ● en0                │                           │
```

**EVERY interface specified! EVERY IP documented!**

---

## 🏆 WHO SETS THIS STANDARD?

**qui3tly** - One of the first CCIE (Cisco Certified Internetwork Expert) in the region.

When a CCIE says "document the interfaces," you document EVERY detail:
- Interface name with dot (●)
- IP with subnet mask
- Gateway
- MTU
- Speed
- MAC (if physical)
- Encapsulation type
- Provider (if WAN)
- Status
- Purpose

**NO SHORTCUTS. NO AMATEUR DOCUMENTATION.**

---

## 📝 DOCUMENT HEADERS

Every architecture/operations document MUST have this header:

```markdown
# Document Title

> **Author**: qui3tly (One of the first CCIE in the region)  
> **Last Updated**: YYYY-MM-DD  
> **Status**: Production/Draft  
> **Standard**: Cisco CCIE-level documentation
```

---

## ✅ CHECKLIST FOR DOCUMENT REVIEW

Before committing ANY documentation, verify:

- [ ] Header includes CCIE credential
- [ ] Modern Mermaid diagrams present
- [ ] OLD SCHOOL ASCII art diagrams with FULL interface details
- [ ] Every interface has: name (●), IP/mask, gateway, MTU
- [ ] Routing tables show destination, gateway, interface, metric
- [ ] Packet flows specify IN/OUT interfaces at each hop
- [ ] NO vague statements like "packet arrives" or "route to host"
- [ ] Decision trees with proper boxes/diamonds/arrows
- [ ] Complete specifications (no assumptions)
- [ ] Real-world examples with actual IPs

---

## 🚫 ENFORCEMENT

**Any document that violates this standard will be:**
1. **REJECTED** by qui3tly
2. **Removed** from production docs
3. **Rewritten** to meet CCIE-level standards

**No exceptions. This is PROFESSIONAL infrastructure documentation.**

---

*"If you can't document it like a CCIE, you're not ready to implement it."*  
— qui3tly, 2026
