# Changelog

All notable changes to this project are documented here.

---

## Session - 2026-04-06

### Completed
- Complete rework of orchestrator system with TDD pipeline, debate protocol, and escalation

### Changes
- opencode.json: Switched main model to GLM-5.1 (zai-coding-plan/glm-5.1), review mode uses Minimax M2.5
- opencode.json: Added /start, /deploy, /review commands
- opencode.json: Added docker compose, node, npx jest/vitest permissions
- AGENTS.md: Complete rewrite as orchestrator brain — defines delegation, TDD flow (Red-Green-Refactor), debate protocol, escalation with question tool, deployment trigger, memory checkpoints
- GLOBAL_WORKFLOW.md: Complete rewrite — full orchestrator loop with ASCII diagrams, memory checkpoints, error recovery procedures
- agents/code-reviewer.md: NEW — severity-based review (P0-P3), structured verdict format (APPROVED/ISSUES_FOUND/DEBATE_NEEDED), debate protocol with evidence requirements, escalation argument format
- agents/tester.md: NEW — two-phase TDD agent (Red: write failing tests from spec, Validate: run tests + add edge cases), coverage requirements, Python and JS/TS test templates
- agents/js-ts-dev.md: NEW — strict TypeScript standards, Biome tooling, functional React components, named exports, debate protocol, return format
- agents/python-dev.md: Refined — added TDD awareness (receive tests, implement to pass), debate protocol with counter-argument format, review feedback handling
- deployment.md: NEW — pre-deploy CI checks, docker compose build --no-cache with ../Dockerfile, health check, rollback plan, reporting format
- finding.md: NEW — template for unresolved reviewer findings (P2/P3) and escalation details
- context.md: Updated with new architecture, agent assignments, TDD flow, debate/escalation conventions
- CLAUDE.md: Removed (redundant with AGENTS.md)

### Architecture Changes
- Model: GLM-5.1 for orchestrator + developer + tester
- Model: Minimax M2.5 for code reviewer (review mode)
- Pipeline: Tester → Developer → Tester → Reviewer → Document → Commit
- Debates: Max 2 rounds, then escalation to user via radio buttons
- Deployment: Automatic after all tasks complete (docker compose build --no-cache && up -d)

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
