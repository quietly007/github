# qui3tly.cloud — what it is

> A sovereign, self-hosted cloud for humans and small businesses.
> Mail, collaboration, identity, monitoring — all on infrastructure you control.

---

## The one-liner

**qui3tly.cloud is a European-hosted, audit-ready private cloud that replaces Google Workspace, Microsoft 365, and "another SaaS we don't trust" — running on hardened infrastructure owned by the engineer who built it.**

---

## Who it is for

- **Small businesses** (5–50 users) who need email + file sync + office suite + a phone to call when something breaks.
- **Independent professionals** — lawyers, architects, doctors — who legally cannot leave client data in US SaaS.
- **Privacy-minded individuals** who want Gmail-quality UX without the Gmail-quality surveillance.

Not for: Fortune 500s, anyone who wants to click-buy SaaS and forget about a human being on the other end.

---

## What you get

| Capability | Powered by | Access |
|---|---|---|
| Email + calendar + contacts | Mailcow (Postfix + Dovecot + SOGo) | `mail.<your-domain>` |
| File sync + share + photos  | Nextcloud                         | `cloud.<your-domain>` |
| Online office (docx/xlsx/pptx compatible) | OnlyOffice              | `office.<your-domain>` |
| Single sign-on              | Authelia                          | `auth.<your-domain>` |
| Monitoring + status page    | Prometheus + Grafana + Uptime Kuma | `status.<your-domain>` |
| Push notifications          | Gotify + ntfy                     | mobile app |
| Secure remote access        | Tailscale / Headscale VPN         | invitation |
| Audit & governance          | `.governance/` 16-file policy base + immutable audit trail | on request |

Everything with **automatic Let's Encrypt certificates**, **DNSSEC-protected domains**, **daily offsite backups**, and **SPF + DKIM + DMARC + MTA-STS + TLSA** on mail.

---

## What makes us different

1. **Actually operated.** Most "self-hosted clouds" are a weekend GitHub repo. This one runs 64 containers across 2 hosts, 24/7, with documented policy, live-verified CCIE topology, and a mutation audit trail.

2. **Documented to CCIE standard.** Every IP, every interface, every port, every FQDN written in a way that a blind engineer with a screen reader, a new-hire, and an AI agent all get identical correct answers. See `~/.docs/01-architecture/CCIE_TOPOLOGY.md`.

3. **Governance first.** Before any change: backup → plan → approval → implement → verify → document. Seven steps. No exceptions. (Ask any client IT team the last time they saw that on a hosted service.)

4. **Transparency by design.** Every mutation lands in an append-only JSONL log. Clients get quarterly access to that log on request.

5. **European jurisdiction.** Physical infrastructure in EU; authoritative DNS on Cloudflare; no US shadow processor on data paths.

6. **One phone number.** You call an engineer. Not a ticketing queue. Not a chatbot.

---

## Proof points (as of 2026-04-24)

| Metric | Value |
|---|---|
| Production hosts | 2 (master + lady) |
| Running containers | ~64 |
| Mail deliverability | SPF + DKIM + DMARC + MTA-STS + DNSSEC + TLSA all valid, 100% inbox on Google/Outlook/Yahoo |
| TLS certificates | 14/14 valid, auto-renew |
| Prometheus targets healthy | 20/20 |
| Alert rules active | 53, fleet health = ok |
| Mean time between user-facing incidents | > 60 days |
| Recovery time objective | 15 minutes (documented, to be test-verified) |
| Open security findings | 15 (all P2/P3, all tracked in public-per-client tracker) |
| Governance policies | 16 mandatory, all enforced |

---

## Engagement model

| Stage | Duration | What happens |
|---|---|---|
| **Discovery** | 30 min free | What do you have, what do you need, is qui3tly.cloud a fit? |
| **Proposal** | 1 week  | Fixed-scope SOW + pricing + timeline |
| **Onboarding** | 2–4 weeks | DNS cutover, user provisioning, data migration, training |
| **Live** | ongoing | Monthly check-ins, quarterly reports, 24/7 on-call |
| **Offboarding** | 2 weeks (optional) | Full data export in open formats, no lock-in |

---

## Reference clients

- **Norma** — Nextcloud + OnlyOffice for a small team. Live since Feb 2026.
- **Montefish** — Proposal in 3 languages (EN/SR/RU), pending signature.

(Case studies available on request.)

---

## Next step

Email [hello@quietly.online](mailto:hello@quietly.online) with:
- rough user count
- current stack you want to replace
- any compliance requirement (GDPR, sector-specific)

Discovery call scheduled within 48 h.

---

**qui3tly.cloud — calm infrastructure for people who have work to do.**
