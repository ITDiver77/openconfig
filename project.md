# OpenConfig - OpenCode Universal Configuration

## Overview
Universal configuration for OpenCode AI assistant, designed for Python and JavaScript/TypeScript development projects. This repo provides consistent development workflow, best practices, and automation across all projects.

## Tech Stack
- **Config format**: JSON (opencode.json), YAML, TOML
- **Languages**: Bash (scripts), TypeScript (plugins)
- **Python tools**: ruff, mypy, pytest
- **JS/TS tools**: Biome
- **OpenCode**: v1.0+

## Architecture

### Directory Structure
```
openconfig/
├── opencode.json         # Main configuration
├── AGENTS.md             # Universal rules
├── GLOBAL_WORKFLOW.md    # Detailed workflow
├── agents/               # Custom agents
│   └── python-dev.md
├── skills/               # Reusable skills
│   ├── planning/
│   ├── code-review/
│   ├── test-generation/
│   └── project-analysis/
├── plugins/              # OpenCode plugins
│   ├── ruff-auto-fix/
│   ├── biome-auto-fix/
│   └── setup-dev-hook/
├── configs/              # Tool configurations
│   ├── python/
│   └── frontend/
└── scripts/              # Installation scripts
    ├── install-global.sh
    ├── install-project.sh
    └── bootstrap.sh
```

## Installation Flow
1. Clone repo → `./scripts/install-global.sh` → symlinks to `~/.config/opencode/`
2. Per-project: `./scripts/install-project.sh` → creates project files
3. Stateful: `./scripts/bootstrap.sh --stateful` → creates setup-dev.sh

## Key Features
- Multi-session project management
- Atomic commits with detailed messages
- Auto-format after edits (ruff/biome)
- Pre-test setup hook
- MCP: context7 for library docs

## Commands
| Command | Purpose |
|---------|---------|
| `./scripts/install-global.sh` | Install globally |
| `./scripts/install-project.sh` | Setup new project |
| `./scripts/bootstrap.sh --stateful` | Create setup-dev.sh |

## External Services
- OpenCode AI: Primary assistant
- Context7 MCP: Library documentation
