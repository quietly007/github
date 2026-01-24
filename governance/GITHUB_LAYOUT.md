# GitHub Layout

Canonical GitHub organization structure for quietly007 and the on-host working copies.

## Organization Structure (quietly007)

```
quietly007/
├── quietly.its.me   ── Master home repo (~/)
├── quietly.online   ── Lady home repo (~/)
├── ansible          ── Shared playbooks (~/.ansible/)
├── governance       ── Policies (~/.governance/)
├── github-config    ── Copilot instructions (~/.github/)
├── projects         ── Business docs (~/projects/)
└── copilot          ── Shared memories (~/.copilot-shared/)
```

## Local Working Copy Mapping

| Repo | Master Path | Lady Path | Push Source |
|------|-------------|-----------|-------------|
| quietly.its.me | ~/ | - | Master only |
| quietly.online | - | ~/ | Lady only |
| ansible | ~/.ansible/ | ~/.ansible/ (read-only) | Master only |
| governance | ~/.governance/ | ~/.governance/ (read-only) | Master only |
| github-config | ~/.github/ | ~/.github/ (read-only) | Master only |
| projects | ~/projects/ | ~/projects/ (read-only) | Master only |
| copilot | ~/.copilot-shared/ | ~/.copilot-shared/ (read-only) | Master only |

## GitHub Entry Points

- Copilot instructions are hosted in the github-config repo and mirrored into `/home/qui3tly/.github/` on servers.
- Authority remains `/home/qui3tly/.governance/` for policy-of-record.

## Governance Files (policy-of-record)

- PRINCIPLES.md
- RULES.md
- WORKFLOWS.md
- SECRETS.md
- ENFORCEMENT.md
- CHANGELOG.md
- REPOS.md
- ANSIBLE.md
- GITHUB_LAYOUT.md
- DOCKER_LAYOUT.md

## Project Layout (projects repo)

```
projects/
└── qui3tly.cloud/
    ├── README.md
    ├── RFP.md
    ├── plans/
    ├── reports/
    └── todo/
```

## Enforcement Notes

- Main branch is protected; no force pushes.
- Sensitive paths require owner review (CODEOWNERS).
- Commit signing is recommended.
