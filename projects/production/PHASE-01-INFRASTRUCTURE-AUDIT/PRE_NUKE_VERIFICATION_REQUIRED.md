# URGENT: PRE-NUKE VERIFICATION REQUIRED

**External Agent: Complete this BEFORE nuke happens!**

---

## ACCESS VERIFICATION CHECKLIST

Test EVERY web service and document:

### Master Server Services:
- [ ] Pihole: http://100.64.0.1:8053/admin → HTTP code? Login works?
- [ ] Grafana: https://grafana.quietly.its.me → HTTP code? Login works?
- [ ] Portainer: http://100.64.0.1:9000 → HTTP code? Login works?
- [ ] Traefik: http://100.64.0.1:8080 → HTTP code? Login works?
- [ ] Prometheus: http://100.64.0.1:9090 → HTTP code? (currently DOWN)
- [ ] Alertmanager: http://100.64.0.1:9093 → HTTP code?
- [ ] Loki: http://100.64.0.1:3100/ready → HTTP code?
- [ ] Uptime-kuma: https://uptime.quietly.its.me → HTTP code? Login works?
- [ ] Ntfy: https://ntfy.quietly.its.me → HTTP code?
- [ ] Gotify: https://gotify.quietly.its.me → HTTP code? Login works?
- [ ] IT-Tools: https://it-tools.quietly.its.me → HTTP code?
- [ ] Headscale-UI: https://headscale.quietly.its.me → HTTP code?
- [ ] Headscale-Admin: https://headscale-admin.quietly.its.me → HTTP code? Login works?
- [ ] Semaphore: https://semaphore.quietly.its.me → HTTP code? Login works?
- [ ] Authelia: Internal service → Status?

### Lady Server Services:
- [ ] Mailcow: https://mail.quietly.online → HTTP code? Login works?
- [ ] Nextcloud: https://nextcloud.quietly.online → HTTP code? Login works? (currently broken)
- [ ] OnlyOffice: https://onlyoffice.quietly.online → HTTP code?
- [ ] Odoo: https://odoo.quietly.online → HTTP code? Login works?
- [ ] Home Assistant: https://homeassistant.quietly.its.me → HTTP code? Login works?
- [ ] Frigate: https://frigate.quietly.its.me → HTTP code? Login works?
- [ ] Portainer Agent: http://100.64.0.2:9001 → Status?

---

## DOCKER-COMPOSE VERIFICATION

For EACH service that works, verify:
- [ ] Compose file exists in `~/.docker-compose/SERVICE/`
- [ ] All volumes defined (named or bind mounts)
- [ ] All configs externalized (not hardcoded)
- [ ] All secrets in `~/.secrets/` not in compose file
- [ ] .env file exists if needed

---

## CREDENTIALS DOCUMENTATION

Document working credentials for:
1. Pihole admin
2. Grafana
3. Portainer
4. Mailcow admin
5. Nextcloud (if working)
6. All other admin interfaces

**This is critical! After nuke, these MUST still work!**

---

## SAVE REPORT AS:

`PHASE-01-INFRASTRUCTURE-AUDIT/ACCESS_VERIFICATION_REPORT.md`

**DO NOT proceed with nuke until this verification is complete and approved!**
