# Context

## Project Conventions

### Naming
- Files: kebab-case
- Directories: kebab-case
- Scripts: kebab-case.sh

### Patterns
- Installation: Symlink-based (not copy)
- Config: JSON + Markdown
- Plugins: TypeScript with package.json

## Architecture

### Orchestrator Pattern
- Orchestrator delegates to sub-agents via Task tool
- Pipeline order: Setup Dev Docker → Tester (Red) → Developer (Green) → Tester (Validate) → Reviewer → Document → Commit
- All agents use GLM-5.1, except Code Reviewer which uses Minimax M2.5

### Dev Docker Environment
- TDD phases run inside `docker-compose.dev.yml` (separate from production)
- Same Dockerfile as production, but external ports have 5-prefix (443→5443, 80→580, 8000→58000)
- Internal Docker network ports are unchanged — services communicate normally
- Dev nginx (580/5443) does NOT conflict with production nginx (80/443)
- If no docker-compose.dev.yml exists → stateless project, skip Docker setup

### Agent Assignments

| Agent | File | Model | Role |
|-------|------|-------|------|
| Orchestrator | AGENTS.md, GLOBAL_WORKFLOW.md | GLM-5.1 | Coordinates all tasks |
| Python Dev | agents/python-dev.md | GLM-5.1 | Implements Python code |
| JS/TS Dev | agents/js-ts-dev.md | GLM-5.1 | Implements JS/TS code |
| Tester | agents/tester.md | GLM-5.1 | TDD: writes and validates tests |
| Code Reviewer | agents/code-reviewer.md | Minimax M2.5 | Reviews quality, severity-based |

### TDD Flow (Red-Green-Refactor)
1. Tester writes failing tests from specification
2. Developer implements to make tests pass
3. Tester validates, adds edge cases
4. Reviewer checks quality (Minimax M2.5)
5. Up to 2 review/debate rounds, then escalate to user
6. Document + commit

### Debate & Escalation
- Max 2 review rounds between developer and reviewer
- If unresolved after 2 rounds → orchestrator asks user via question tool (radio buttons)
- Both sides provide detailed arguments with proof
- Decision logged to finding.md

## Important Decisions

### Installation Method
- Date: 2026-03-22
- Decision: Symlink instead of copy
- Rationale: Single source of truth, easy updates

### Project Files Location
- Date: 2026-03-22
- Decision: product.md, todo.md, context.md, changelog.md in project root
- Rationale: OpenCode reads these automatically

### Orchestrator Pattern
- Date: 2026-04-06
- Decision: Task tool sub-agents, not mode switching
- Rationale: Each agent gets focused context, better results

### Code Review Model
- Date: 2026-04-06
- Decision: Minimax M2.5 for review mode
- Rationale: Different model perspective catches more issues

## Gotchas

### Symlinks and Git
- Problem: Git doesn't track symlinks the same as regular files
- Workaround: Use `ln -sf` in install script, force recreate

### Plugins Path
- Problem: Plugins need package.json for OpenCode to load
- Workaround: Each plugin has its own package.json

### Memory Degradation
- Problem: Long sessions cause context drift in orchestrator
- Workaround: Memory checkpoints before each task, /start command for full refresh

### Sub-agent Context
- Problem: Sub-agents don't inherit orchestrator's full context
- Workaround: Orchestrator provides ONLY relevant context to each agent

## Important Files
| File | Purpose |
|------|---------|
| `opencode.json` | Main config: models, permissions, MCP, plugins |
| `AGENTS.md` | Orchestrator instructions (loaded every session) |
| `GLOBAL_WORKFLOW.md` | Detailed workflow with memory checkpoints |
| `deployment.md` | Docker rebuild/restart procedure |
| `finding.md` | Unresolved reviewer findings |
| `agents/python-dev.md` | Python developer agent instructions |
| `agents/js-ts-dev.md` | JS/TS developer agent instructions |
| `agents/tester.md` | TDD tester agent instructions |
| `agents/code-reviewer.md` | Code reviewer agent instructions |

## Learned Lessons

### OpenCode Config Hierarchy
- Global: `~/.config/opencode/`
- Project: `.opencode/`
- Project settings override global

### Skills Loading
- Skills in `skills/<name>/SKILL.md`
- Must have YAML frontmatter with name/description

### Plugins vs Hooks
- Plugins: TypeScript in `plugins/`
- Hooks: Can be in plugins with tool.execute.before/after

### Task Tool Usage
- subagent_type "general" → for tester and reviewer
- subagent_type "python-dev" → for Python developer
- Orchestrator provides prompt with role, task, context, constraints, return format
