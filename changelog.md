# Changelog

All notable changes to this project are documented here.

## [Unreleased]

### Added
- Initial implementation with 25 files

---

## Session - 2026-03-24

### Completed
- Fixed invalid OpenCode config keys causing service startup failure
- Removed broken self-referencing symlinks
- Updated scripts to not overwrite existing files

### Changes
- opencode.json: Removed `$comment`, `disabled_hooks`, `mcpServers` (invalid keys)
- opencode.json: Changed `agent.*` to `mode.*` to match OpenCode schema
- Removed symlinks: agents/agents, configs/configs, plugins/plugins, skills/skills
- install-project.sh: Now checks if files exist before creating
- bootstrap.sh: Now checks if setup-dev.sh exists before creating

### Notes
- OpenCode was failing with: "Unrecognized keys: $comment, disabled_hooks, mcpServers"
- Config now validates successfully against OpenCode schema
- Scripts now safe to run multiple times without losing customizations

---

## Session - 2026-03-22

### Completed
- Created universal OpenCode configuration
- Implemented 4 skills: planning, code-review, test-generation, project-analysis
- Created 3 plugins: ruff-auto-fix, biome-auto-fix, setup-dev-hook
- Added Python configurations: ruff.toml, mypy.ini, pyproject.toml
- Added JS/TS configuration: biome.json
- Created installation scripts

### Changes
- Created README.md with full documentation
- Created AGENTS.md with universal rules
- Created GLOBAL_WORKFLOW.md with detailed workflow
- Created python-dev.md agent with best practices

### Notes
- This project IS the configuration, not a typical app
- Uses its own rules for other projects
- Symlinked to ~/.config/opencode/ for global use
