# zig-development-playbook-skill

Standalone repository for the `zig-development-playbook` skill.

## Layout

- `.claude-plugin/plugin.json`
- `skills/zig-development-playbook/SKILL.md`
- `skills/zig-development-playbook/references/*`
- `skills/zig-development-playbook/scripts/*`
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

### Claude skill install

```bash
./scripts/install-claude-skill.sh
```

### Codex skill install

```bash
./scripts/install-codex-skill.sh
```

## Validation Commands

```bash
./skills/zig-development-playbook/scripts/check-zig-version.sh
./skills/zig-development-playbook/scripts/zig_quality_gate.sh <project-dir>
```

Strictly enforce Zig `0.15.x` (for pinned projects):

```bash
./skills/zig-development-playbook/scripts/zig_quality_gate.sh <project-dir> --strict-0-15
```

## chezmoi external extraction

Extract this path into your destination skill directory:

- `skills/zig-development-playbook/**`
