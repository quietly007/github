# Secrets

Storage, rotation, and access control for secrets.

## Storage

| Attribute | Value |
|-----------|-------|
| Location | `.secrets/` only |
| Directory perms | 700 |
| File perms | 600 |
| Owner | `qui3tly` |

## Discovery & Mitigation

1. Report path + pattern (**never value**).
2. Backup to `.copilot/backups/`.
3. Present options to user; on approval move to `.secrets/`, `chmod 600`.
4. Record in `.copilot/memories.jsonl` and dated report.

## Rotation Schedule

| Credential Class | Period |
|------------------|--------|
| High-value (API keys, private keys) | 90 days |
| Lower-risk | 180 days |

### Rotation Steps

1. Create new credential in service.
2. Update `.secrets/<service>_<date>`.
3. Reload service (with approval).
4. Revoke old credential.
5. Audit: memory entry + dated report.

## Access Control

- Only `qui3tly` and `root` access secrets directly.
- Automations use tightly-scoped service accounts or mounted secrets with minimal privileges.

## Prohibited

- **Never** write secrets to repo, docs, logs, or memory entries.
- **Never** print secret values to stdout/stderr.

## Owner Credentials (Absolute Off-Limits)

The following are **owner-only knowledge** and must **never** be:
- Requested by any agent
- Handled by any automation
- Stored in any file (including secrets/)
- Transmitted in any form

| Credential Type | Status |
|-----------------|--------|
| Owner password | OFF-LIMITS |
| Owner SSH private key | OFF-LIMITS |
| Owner VPN certificates/keys | OFF-LIMITS |
| Owner personal auth tokens | OFF-LIMITS |
| Owner 2FA seeds/backup codes | OFF-LIMITS |

Agents may work with **service credentials** (API keys, container secrets) but never owner personal credentials.

## Retention Policy

| Backup Type | Duration |
|-------------|----------|
| Daily backups | 30 days |
| Weekly backups | 90 days |
| Monthly archives | 365 days |
| Audit logs | 2 years |
