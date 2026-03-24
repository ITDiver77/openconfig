# OpenCode Universal Rules

## Session Start Protocol

**FIRST:** Read these files at the start of EVERY session:
1. `project.md` - Full project overview
2. `todo.md` - Current tasks and plans
3. `context.md` - Important patterns and decisions
4. `changelog.md` - Recent changes in previous sessions

## Global Workflow

Follow the workflow defined in `GLOBAL_WORKFLOW.md`.

## Project Type Detection

### Stateless Projects
- No external dependencies (database, cache, etc.)
- Tests run directly in development environment
- `setup-dev.sh` can simply activate venv or run dev services

### Stateful Projects
- Require database, cache, or external services
- MUST run `setup-dev.sh` before any tests
- Setup script handles: migrations, docker-compose, service startup

### Multi-Repository Projects
When working with projects that contain git submodules or child repositories:
- Each child project has its own `context.md`, `todo.md`, `changelog.md`
- Check child project docs before main project docs
- Quality gates should be run within each child project directory
- Link cross-project tasks in parent `todo.md`

## Development Workflow

1. **Analyze** → Understand current state from project files
2. **Plan** → Review todo.md, identify next task
3. **Implement** → Atomic change (lint → format → typecheck → test)
4. **Review** → Self-code-review the change
5. **Commit** → Detailed commit message
6. **Repeat** → Until task done
7. **CI** → Run full test suite
8. **Session End** → Update changelog.md, context.md

## Atomic Commit Standards

### One Logical Change Per Commit
Each commit should represent a single, complete, testable change.

### Commit Message Format
```
<type>: <short description>

<detailed body explaining WHY, not just WHAT>

- Added X for Y reason
- Fixed Z by doing W
- Changed behavior: before... after...

Related to: #<issue-number>
```

### Types
- `feat:` - New feature
- `fix:` - Bug fix
- `refactor:` - Code refactoring (no behavior change)
- `docs:` - Documentation changes
- `test:` - Test changes
- `chore:` - Build, tooling, dependencies
- `perf:` - Performance improvement

### Never Commit
- Debug prints or logging
- Commented-out code
- TODO placeholders
- Secrets, API keys, credentials
- Generated files (node_modules, __pycache__, etc.)

## Quality Gates

Before any commit:
1. `ruff check .` (Python) or `biome check .` (JS/TS)
2. `ruff format .` (Python) or `biome format --write .` (JS/TS)
3. `mypy .` (Python)
4. All tests pass

## Setup Hook (Stateful Projects)

For projects with `scripts/setup-dev.sh`:
- **NEVER run manually**
- Automatically executed by hook before tests
- If setup fails, DO NOT proceed with tests
- Fix the setup script first

## Code Standards

### Python
- Type hints on ALL functions (parameters AND return)
- Google-style docstrings
- `src/` layout for packages
- Import order: stdlib → third-party → local

### JavaScript/TypeScript
- Strict TypeScript
- Functional components (React)
- Named exports preferred
- Biome for formatting and linting

## Tooling Commands by Language

### Python
| Tool | Check | Fix | Config |
|------|-------|-----|--------|
| ruff | `ruff check .` | `ruff check --fix .` | `pyproject.toml` |
| mypy | `mypy .` | N/A | `pyproject.toml` |
| pytest | `pytest` | N/A | `pyproject.toml` |

### TypeScript/JavaScript
| Tool | Check | Fix | Config |
|------|-------|-----|--------|
| biome | `biome check .` | `biome check --write .` | `biome.json` |
| tsc | `tsc --noEmit` | N/A | `tsconfig.json` |

## Documentation Standards

### Required Project Files
Each project should have:
- `project.md` - What the project is and does
- `todo.md` - Current and planned work
- `context.md` - Technical patterns and conventions
- `changelog.md` - Change history

### Documentation Updates
- Update `changelog.md` at end of each session
- Move completed items from `todo.md` to `changelog.md`
- Update `context.md` when adopting new patterns

## Multi-Project Session Workflow

1. **Identify scope**: Is the task within one project or cross-project?
2. **Check dependencies**: Are required endpoints/fields available?
3. **Update parent docs**: If cross-project, update parent `todo.md`
4. **Implement in order**: Start with dependencies, then dependents
5. **Test integration**: Verify projects work together

## Skills

Available skills for enhanced workflows:
- `planning` - Structured feature planning
- `code-review` - Severity-based review
- `test-generation` - Comprehensive test patterns
- `project-analysis` - Codebase structure discovery
