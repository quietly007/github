# Docker Layout (Policy of Record)

> **Last Updated**: 2026-01-24

Canonical Docker layout and path conventions for this infrastructure. This document is the policy-of-record for Docker structure.

---

## Required Directory Layout

```
/home/qui3tly/
├── .docker-compose/{service}/docker-compose.yaml   # Compose files (source of truth)
├── .docker/{service}/config/                       # Service configuration
└── .docker/{service}/data/                         # Persistent data
```

---

## Path Rules

- **No `:latest` tags** — pin versions for every service.
- **Healthchecks required** for all services.
- **Resource limits** where appropriate.
- **Configs live in repos** (`.docker-compose/` and `.docker/`), not in playbooks.
- **Secrets never in repo** — use `/home/qui3tly/.secrets/` only.

---

## Compose Location Standard

All services must have their compose file at:

```
/home/qui3tly/.docker-compose/{service}/docker-compose.yaml
```

---

## Data & Config Separation

```
/home/qui3tly/.docker/{service}/config/   # Versioned configuration files
/home/qui3tly/.docker/{service}/data/     # Runtime data (volumes)
```

---

## Example

```
/home/qui3tly/.docker-compose/traefik/docker-compose.yaml
/home/qui3tly/.docker/traefik/config/
/home/qui3tly/.docker/traefik/data/
```

---

## Enforcement Notes

- Playbooks must **verify required files exist** before deploy.
- Any drift from this layout requires explicit owner approval.
