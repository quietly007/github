#!/usr/bin/env python3
import json
import os
import sys
import time
import urllib.parse
import urllib.request

TOKEN_FILE = "/home/qui3tly/.secrets/traefik/cf-token"
ZONE_NAME = "quietly.online"
RECORD_NAME = "_mta-sts.quietly.online"
TTL = 300

def die(msg):
  print(msg, file=sys.stderr)
  sys.exit(1)

if not os.path.exists(TOKEN_FILE):
  die(f"Cloudflare token missing: {TOKEN_FILE}")

token = open(TOKEN_FILE, "r", encoding="utf-8").read().strip()
if not token:
  die("Cloudflare token is empty")

# Generate new ID (ISO 8601 timestamp with Z suffix)
new_id = time.strftime("%Y%m%d%H%M%SZ", time.gmtime())

def cf_request(method, path, payload=None):
  url = "https://api.cloudflare.com/client/v4" + path
  data = None
  if payload is not None:
    data = json.dumps(payload).encode("utf-8")
  req = urllib.request.Request(
    url,
    data=data,
    method=method,
    headers={
      "Authorization": f"Bearer {token}",
      "Content-Type": "application/json",
    },
  )
  try:
    with urllib.request.urlopen(req) as resp:
      return json.loads(resp.read().decode("utf-8"))
  except Exception as exc:
    try:
      body = exc.read().decode("utf-8")
    except Exception:
      body = str(exc)
    die(f"Cloudflare API error: {body}")

# Get zone ID
zone_q = urllib.parse.quote(ZONE_NAME)
zones = cf_request("GET", f"/zones?name={zone_q}&status=active")
if not zones.get("success") or not zones.get("result"):
  die("Failed to resolve Cloudflare zone ID")
zone_id = zones["result"][0]["id"]

# Get existing record
qname = urllib.parse.quote(RECORD_NAME)
existing = cf_request("GET", f"/zones/{zone_id}/dns_records?type=TXT&name={qname}")

# Update TXT record with new ID
payload = {
  "type": "TXT",
  "name": RECORD_NAME,
  "content": f"v=STSv1; id={new_id}",
  "ttl": TTL,
}

if existing.get("success") and existing.get("result"):
  record_id = existing["result"][0]["id"]
  cf_request("PUT", f"/zones/{zone_id}/dns_records/{record_id}", payload)
  print(f"MTA-STS TXT record updated: id={new_id}")
else:
  cf_request("POST", f"/zones/{zone_id}/dns_records", payload)
  print(f"MTA-STS TXT record created: id={new_id}")
