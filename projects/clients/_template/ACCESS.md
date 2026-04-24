# Access — <CLIENT>

Credentials and sensitive contacts live in `~/.secrets/clients/<slug>/`:

- `ssh-keys/`        — private keys (400)
- `admin-passwords`  — age-encrypted
- `api-tokens`       — age-encrypted
- `contacts.yaml`    — phone numbers, emergency contacts

**Never** copy secrets into this file, git, memories.jsonl, or any shipped artifact.
