# quietly007/github - Shared Infrastructure

This repo contains ALL shared content for qui3tly.cloud infrastructure:

- **governance/** - Infrastructure policies and rules
- **copilot-instructions/** - Agent directives
- **ansible/** - Automation playbooks for all servers
- **copilot-shared/** - Cross-server memories and coordination
- **projects/** - Business planning and documentation

## Usage

Clone to: `~/.github/` on all servers

```bash
git clone https://github.com/quietly007/github.git ~/.github
```

## Symlinks for Convenience

```bash
ln -s ~/.github/governance ~/.governance
ln -s ~/.github/ansible ~/.ansible
ln -s ~/.github/copilot-shared ~/.copilot-shared
ln -s ~/.github/projects ~/projects
```

## Access

- **Master**: Read/Write (only Master pushes)
- **Workers** (Lady, Madam, Beauty): Read-only (git pull only)

## Documentation

See: `governance/GITHUB_STRUCTURE_DEFINITIVE.md` for complete structure guide.
