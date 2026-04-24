# P3 Findings — Low / cosmetic

## F-0004 — Wait-online masking doc drift
- Doc: "masked on Lady only" — actual: masked on BOTH hosts
- Master has "unit file changed on disk" warning
- Actions: `systemctl daemon-reload` on Master + update doc

## F-0006 — Lady container count drift
- Doc: 39, actual: 38. Count off by one.
- Action: update `INFRASTRUCTURE_OVERVIEW.md`

## F-0007 — EdgeRouter WAN IP drift
- Doc: `178.20.30.40`, observed: `62.4.55.119`
- IP is ISP-dynamic but doc doesn't say so
- Action: mark as dynamic in network doc
