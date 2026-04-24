## Eight capabilities. One operator. One bill.

| Capability                                 | Powered by                          | You access it at       |
|--------------------------------------------|-------------------------------------|------------------------|
| Email + calendar + contacts                | Mailcow (Postfix + Dovecot + SOGo)  | `mail.your-domain`     |
| File sync + share + photos                 | Nextcloud                           | `cloud.your-domain`    |
| Online office — docx / xlsx / pptx         | OnlyOffice                          | `office.your-domain`   |
| Single sign-on + 2FA                       | Authelia                            | `auth.your-domain`     |
| Monitoring + status page                   | Prometheus + Grafana + Uptime Kuma  | `status.your-domain`   |
| Push notifications                         | Gotify + ntfy                       | mobile app             |
| Private VPN / remote access                | Tailscale / Headscale               | invitation             |
| Audit + governance evidence                | Immutable JSONL trail               | quarterly report       |

All behind Traefik with automatic Let's Encrypt certificates. DNSSEC on every domain. SPF + DKIM + DMARC + MTA-STS + TLSA on every mail server.
