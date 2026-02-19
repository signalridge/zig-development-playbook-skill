# zig-development-playbook-skill

A standalone repository for the `zig-development-playbook` skill.

This repository follows a plugin-style layout similar to common Claude ecosystem projects.

## Repository Layout

- `plugins/zig-development-playbook/.claude-plugin/plugin.json`
- `plugins/zig-development-playbook/skills/zig-development-playbook/SKILL.md`
- `plugins/zig-development-playbook/skills/zig-development-playbook/references/*`
- `plugins/zig-development-playbook/skills/zig-development-playbook/scripts/*`
- `scripts/install-claude-plugin.sh`
- `scripts/install-claude-skill.sh`
- `scripts/install-codex-skill.sh`

## Install

### Claude plugin install

```bash
git clone https://github.com/signalridge/zig-development-playbook-skill.git
cd zig-development-playbook-skill
./scripts/install-claude-plugin.sh
```

### Claude skill install (direct)

```bash
./scripts/install-claude-skill.sh
```

### Codex skill install

```bash
./scripts/install-codex-skill.sh
```

## Dotfiles / chezmoi integration

If you manage shared skills via `chezmoi external`, extract:

- `plugins/zig-development-playbook/skills/zig-development-playbook/**`

into your destination skill path (for example `.agents/skills/local/zig-development-playbook`).
