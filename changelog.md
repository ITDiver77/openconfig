# Changelog

All notable changes to this project are documented here.

## [Unreleased]

### Added
- Initial implementation with 25 files

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
