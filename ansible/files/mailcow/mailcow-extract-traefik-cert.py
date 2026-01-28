#!/usr/bin/env python3
"""
Extract certificate from Traefik acme.json and copy to Mailcow
This allows Mailcow SMTP/IMAP to use Let's Encrypt certs from Traefik
"""
import json
import os
import sys
import subprocess
import base64

ACME_JSON = "/home/qui3tly/.docker/traefik/acme.json"
MAILCOW_DOMAIN = "mail.quietly.online"
MAILCOW_SSL_DIR = f"/home/qui3tly/.docker/mailcow/data/assets/ssl/{MAILCOW_DOMAIN}"

def die(msg):
    print(msg, file=sys.stderr)
    sys.exit(1)

if not os.path.exists(ACME_JSON):
    die(f"Traefik acme.json not found: {ACME_JSON}")

# Read acme.json
try:
    with open(ACME_JSON, 'r') as f:
        acme_data = json.load(f)
except Exception as e:
    die(f"Failed to read acme.json: {e}")

# Find the cloudflare resolver and mail.quietly.online certificate
cert_found = False
cert_pem = None
key_pem = None

if 'cloudflare' in acme_data and 'Certificates' in acme_data['cloudflare']:
    for cert in acme_data['cloudflare']['Certificates']:
        if cert.get('domain', {}).get('main') == MAILCOW_DOMAIN:
            cert_pem = cert.get('certificate')
            key_pem = cert.get('key')
            cert_found = True
            break

if not cert_found or not cert_pem or not key_pem:
    die(f"Certificate for {MAILCOW_DOMAIN} not found in acme.json")

# Create SSL directory if it doesn't exist
os.makedirs(MAILCOW_SSL_DIR, mode=0o755, exist_ok=True)

# Write certificate and key
cert_file = os.path.join(MAILCOW_SSL_DIR, "cert.pem")
key_file = os.path.join(MAILCOW_SSL_DIR, "key.pem")

try:
    # Traefik stores certs as base64-encoded strings, decode them
    cert_data = base64.b64decode(cert_pem) if isinstance(cert_pem, str) else cert_pem
    key_data = base64.b64decode(key_pem) if isinstance(key_pem, str) else key_pem
    
    with open(cert_file, 'wb') as f:
        f.write(cert_data)
    os.chmod(cert_file, 0o644)
    
    with open(key_file, 'wb') as f:
        f.write(key_data)
    os.chmod(key_file, 0o600)
    
    print(f"Certificate extracted to {MAILCOW_SSL_DIR}/")
    print(f"  cert.pem: {os.path.getsize(cert_file)} bytes")
    print(f"  key.pem: {os.path.getsize(key_file)} bytes")
    
except Exception as e:
    die(f"Failed to write certificate files: {e}")

# Reload Postfix and Dovecot
print("Reloading Postfix and Dovecot...")
try:
    subprocess.run(["docker", "exec", "postfix-mailcow", "postfix", "reload"], 
                   check=True, capture_output=True)
    subprocess.run(["docker", "exec", "dovecot-mailcow", "dovecot", "reload"], 
                   check=True, capture_output=True)
    print("Services reloaded successfully")
except Exception as e:
    print(f"Warning: Failed to reload services: {e}", file=sys.stderr)
    print("You may need to restart mailcow containers manually")
