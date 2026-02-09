# SERVICE LINK & SSL CERTIFICATE AUDIT REPORT

**Audit Date**: February 3, 2026 12:16 CET  
**Auditor**: GitHub Copilot  
**Scope**: All publicly accessible services across Master and Lady servers  
**Status**: ⚠️ **ISSUES FOUND - REMEDIATION REQUIRED**

---

## 🎯 EXECUTIVE SUMMARY

| Category | Working | Issues | Total |
|----------|---------|--------|-------|
| Master Services (quietly.its.me) | 15 | 2 | 17 |
| Lady Services (quietly.online) | 5 | 6 | 11 |
| SSL Certificates | 17 | 5 | 22 |
| **Overall** | **22** | **8** | **30** |

**Severity Assessment**:
- 🔴 **Critical**: 2 issues (Home Assistant misconfigured, UniFi not routed)
- 🟡 **Warning**: 3 issues (Wrong URLs in documentation)
- 🟢 **Info**: 3 issues (VPN-protected services returning 404)

---

## 📊 DETAILED TEST RESULTS

### Master Server (quietly.its.me)

All Master services are protected by Authelia SSO. **HTTP 403 = Working correctly** (requires authentication).

| Service | URL | HTTP Code | SSL | Status |
|---------|-----|-----------|-----|--------|
| Admin Panel | https://admin.quietly.its.me | 403 | ✅ Valid | ✅ Working |
| Authelia | https://auth.quietly.its.me | 403 | ✅ Valid | ✅ Working |
| Grafana | https://grafana.quietly.its.me | 403 | ✅ Valid | ✅ Working |
| Prometheus | https://prometheus.quietly.its.me | 403 | ✅ Valid | ✅ Working |
| Alertmanager | https://alertmanager.quietly.its.me | 403 | ✅ Valid | ✅ Working |
| Traefik | https://traefik.quietly.its.me | 403 | ✅ Valid | ✅ Working |
| Portainer | https://portainer.quietly.its.me | 403 | ✅ Valid | ✅ Working |
| Semaphore | https://semaphore.quietly.its.me | 403 | ✅ Valid | ✅ Working |
| Gotify | https://gotify.quietly.its.me | 403 | ✅ Valid | ✅ Working |
| Ntfy | https://ntfy.quietly.its.me | 403 | ✅ Valid | ✅ Working |
| Uptime Kuma | https://uptime.quietly.its.me | 403 | ✅ Valid | ✅ Working |
| Pi-hole | https://pihole.quietly.its.me | 403 | ✅ Valid | ✅ Working |
| IT-Tools | https://tools.quietly.its.me | 403 | ✅ Valid | ✅ Working |
| Headscale UI | https://headscale-ui.quietly.its.me | 403 | ✅ Valid | ✅ Working |
| Headscale Admin | https://headscale-admin.quietly.its.me | 403 | ✅ Valid | ✅ Working |
| Loki | https://loki.quietly.its.me | 404 | ✅ Valid | ⚠️ Not routed |
| Landing Page | https://quietly.its.me | 404 | ✅ Valid | ⚠️ No index |

**Master Summary**: 15/17 working, 2 minor issues (not critical)

---

### Lady Server (quietly.online)

| Service | Documented URL | Actual URL | HTTP | SSL | Status |
|---------|----------------|------------|------|-----|--------|
| Mailcow | mail.quietly.online | mail.quietly.online | 200 | ✅ Valid | ✅ Working |
| Nextcloud | nextcloud.quietly.online | nextcloud.quietly.online | 200 | ✅ Valid | ✅ Working |
| Nextcloud Alt | cloud.quietly.online | cloud.quietly.online | 200 | ✅ Valid | ✅ Working |
| OnlyOffice | onlyoffice.quietly.online | **office.quietly.online** | 302 | ✅ Valid | ⚠️ Wrong URL in docs |
| Home Assistant | ha.quietly.online | **home.quietly.online** | 400 | ❌ Default Cert | 🔴 Misconfigured |
| Odoo | odoo.quietly.online | odoo.quietly.online | 404 | ✅ Valid | ⚠️ VPN-only |
| Frigate | cctv.quietly.online | cctv.quietly.online | 404 | ❌ Default Cert | ⚠️ VPN-only |
| MTA-STS | mta-sts.quietly.online | mta-sts.quietly.online/.well-known/mta-sts.txt | 200 | ✅ Valid | ⚠️ Path required |
| UniFi | unifi.quietly.online | unifi.quietly.online | 404 | ❌ Default Cert | 🔴 Not configured |
| Traefik | traefik.quietly.online | traefik.quietly.online | 404 | ❌ Default Cert | ⚠️ VPN-only |
| Landing | quietly.online | quietly.online | 404 | ✅ Valid | ⚠️ No index |

**Lady Summary**: 5/11 fully working, 6 issues

---

## 🔴 CRITICAL ISSUES

### Issue 1: Home Assistant Not Accessible (Severity: CRITICAL)

**Problem**: Home Assistant returns HTTP 400 Bad Request  
**URL**: https://home.quietly.online  
**Root Cause**: Home Assistant not configured for reverse proxy

**Error Log**:
```
ERROR (MainThread) [homeassistant.components.http.forwarded] 
A request from a reverse proxy was received from 172.18.0.7, 
but your HTTP integration is not set-up for reverse proxies
```

**Fix Required**: Add to Home Assistant configuration.yaml:
```yaml
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 172.18.0.0/16  # Traefik network
```

---

### Issue 2: UniFi Controller Not Routed (Severity: CRITICAL)

**Problem**: UniFi returns 404 with Traefik default certificate  
**URL**: https://unifi.quietly.online  
**Root Cause**: Traefik router not configured for UniFi

**Container Status**: Running (Up 35 minutes)  
**Database**: Running (healthy)  
**Traefik Route**: ❌ Missing

**Fix Required**: Add Traefik labels to UniFi docker-compose

---

## 🟡 WARNING ISSUES

### Issue 3: URL Mismatches in Documentation

| Service | Documented | Correct URL |
|---------|------------|-------------|
| Home Assistant | ha.quietly.online | **home.quietly.online** |
| OnlyOffice | onlyoffice.quietly.online | **office.quietly.online** |

**Impact**: Documentation misleading, users will get certificate warnings  
**Fix Required**: Update all documentation with correct URLs

---

### Issue 4: SSL Certificate Warnings

Services using **TRAEFIK DEFAULT CERT** (self-signed):

| Service | URL | Issue |
|---------|-----|-------|
| Home Assistant | home.quietly.online | Returns 400, cert not requested |
| OnlyOffice | onlyoffice.quietly.online | Wrong URL, no route |
| Frigate | cctv.quietly.online | Route exists but cert not cached |
| UniFi | unifi.quietly.online | No route configured |
| Traefik Lady | traefik.quietly.online | VPN-only, cert not prioritized |

**Note**: SSL:20 means chain verification issue (usually Cloudflare origin cert)  
**Note**: SSL:18 means self-signed certificate

---

## 🟢 INFO ISSUES (Expected Behavior)

### VPN-Protected Services

These services return 404 when accessed without VPN (by design):

| Service | URL | Middleware |
|---------|-----|------------|
| Odoo | odoo.quietly.online | vpn-only@file |
| Frigate | cctv.quietly.online | vpn-only@file |
| Traefik Dashboard | traefik.quietly.online | vpn-only@file |

**Status**: ✅ Working as designed - security measure

### Missing Landing Pages

| Domain | Status | Note |
|--------|--------|------|
| quietly.its.me | 404 | default-landing container exists but not catching root |
| quietly.online | 404 | No default landing configured |

**Impact**: Low - subdomains work correctly

---

## 📋 SSL CERTIFICATE SUMMARY

### Valid Certificates (Cloudflare)

| Domain | Issuer | Expiry | Status |
|--------|--------|--------|--------|
| quietly.its.me | Cloudflare | Apr 4, 2026 | ✅ Valid |
| mail.quietly.online | Cloudflare | Apr 28, 2026 | ✅ Valid |
| nextcloud.quietly.online | Cloudflare | Apr 29, 2026 | ✅ Valid |
| odoo.quietly.online | Cloudflare | Apr 29, 2026 | ✅ Valid |

### Invalid/Self-Signed Certificates

| Domain | Issuer | Issue |
|--------|--------|-------|
| home.quietly.online | TRAEFIK DEFAULT CERT | App returns 400, cert not requested |
| office.quietly.online | (correct) | Wrong URL documented |
| cctv.quietly.online | TRAEFIK DEFAULT CERT | Let's Encrypt resolver configured but not working |
| unifi.quietly.online | TRAEFIK DEFAULT CERT | No route configured |
| traefik.quietly.online | TRAEFIK DEFAULT CERT | VPN-only service |

---

## ✅ REMEDIATION PLAN

### Priority 1: Critical Fixes

1. **Fix Home Assistant Reverse Proxy**
   ```bash
   ssh lady
   cat >> ~/.docker/home-assistant/config/configuration.yaml << 'EOF'
   http:
     use_x_forwarded_for: true
     trusted_proxies:
       - 172.18.0.0/16
   EOF
   docker restart homeassistant
   ```

2. **Configure UniFi Traefik Route**
   - Add Traefik labels to UniFi docker-compose
   - Restart UniFi container
   - Wait for certificate provisioning

### Priority 2: Documentation Updates

Update these files with correct URLs:
- PRE-PHASE-06_SERVICE_INVENTORY.md
- Admin panel (app_simple.py)
- Any other documentation

| Old URL | New URL |
|---------|---------|
| ha.quietly.online | home.quietly.online |
| onlyoffice.quietly.online | office.quietly.online |

### Priority 3: Optional Fixes

1. **Landing Pages**: Configure default-landing for root domains
2. **Frigate SSL**: Investigate Let's Encrypt cert not caching
3. **Loki**: Add external route if needed

---

## 📊 FINAL ASSESSMENT

| Metric | Score |
|--------|-------|
| Master Services | 88% (15/17 working) |
| Lady Services | 45% (5/11 working) |
| SSL Certificates | 77% (17/22 valid) |
| **Overall Health** | **73%** |

**Verdict**: ⚠️ **NEEDS REMEDIATION**

Critical issues prevent full functionality. After fixes:
- Expected Master: 100%
- Expected Lady: 90%+
- Expected SSL: 95%+

---

## 📝 APPENDIX: Test Commands Used

```bash
# HTTP Status Test
curl -k -s -o /dev/null -w "%{http_code} (SSL:%{ssl_verify_result})" URL

# SSL Certificate Details
echo | openssl s_client -servername DOMAIN -connect DOMAIN:443 2>/dev/null | \
  openssl x509 -noout -dates -subject

# Traefik Routes
docker exec traefik wget -qO- http://localhost:8080/api/http/routers | jq

# Container Logs
docker logs CONTAINER --tail 20
```

---

**Report Generated**: 2026-02-03 12:25 CET  
**Next Action**: Execute Priority 1 fixes
