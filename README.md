# OpenCode Universal Configuration

Universal configuration for Python and JavaScript/TypeScript development with OpenCode AI.

## Features

- **Python**: ruff (linting/formatting), mypy (type checking), pytest (testing), src/ layout
- **Frontend**: Biome (ESLint + Prettier alternative for JS/TS)
- **Multi-Session**: project.md, todo.md, context.md, changelog.md for persistent project knowledge
- **Global Workflow**: Structured development workflow for all sessions
- **Skills**: Planning, code review, test generation, project analysis
- **Plugins**: Auto-format after edits, pre-test setup hook
- **MCP**: Context7 for up-to-date library documentation

## Installation

### 1. Global Install

```bash
git clone <repo-url> openconfig
cd openconfig
./scripts/install-global.sh
```

This symlinks the configuration to `~/.config/opencode/`.

### 2. New Project Setup

```bash
cd your-project
./path/to/openconfig/scripts/install-project.sh
```

Creates:
- `project.md` - Project description template
- `todo.md` - Tasks template
- `context.md` - Patterns & decisions template
- `changelog.md` - Session log template
- `.opencode/AGENTS.md` - Project-specific rules link

### 3. Stateful Project (Optional)

```bash
./path/to/openconfig/scripts/bootstrap.sh --stateful
```

Creates `scripts/setup-dev.sh` template with:
- Dependencies installation
- Database migrations
- Docker services
- Health check

**Important:** For stateless projects, `setup-dev.sh` should just activate dev env.

## Usage

### Commands

| Command | Description |
|---------|-------------|
| `/lint` | Run ruff (Python) or biome (JS/TS) |
| `/format` | Format code |
| `/typecheck` | Run mypy (Python) |
| `/test` | Run tests (setup-dev.sh runs automatically) |
| `/ci` | Full CI pipeline |

### Session Workflow

1. **Session Start**: Read project files (project.md, todo.md, context.md, changelog.md)
2. **Setup**: `setup-dev.sh` runs automatically (if exists)
3. **Analyze**: Understand project state
4. **Plan**: Review/update todo.md
5. **Implement**: Atomic changes with lint → format → typecheck → test
6. **Review**: Self-code-review before commit
7. **Commit**: Detailed commit messages
8. **Repeat**: Until all tasks done
9. **Session End**: Update changelog.md, context.md

### Atomic Commits

```
feat: add user authentication via JWT

Implemented JWT-based authentication with refresh tokens.
- Added PyJWT dependency
- Created AuthService with login/logout methods
- Token expires in 24h, refresh in 7 days

Before: No auth, all endpoints public
After: Protected endpoints require valid JWT

Closes #123
```

## Project Files

| File | Purpose | Updated By |
|------|---------|------------|
| `project.md` | Full project overview, architecture, tech stack | Analyst |
| `todo.md` | Current tasks, roadmap, priorities | Planner |
| `context.md` | Patterns, conventions, gotchas | All agents |
| `changelog.md` | Session summaries, what changed | All agents |
| `decisions.md` | Architecture Decision Records | Analyst |

## Customization

### Global Config
`~/.config/opencode/` - Applied to all projects

### Project Overrides
`.opencode/` in project root - Takes precedence over global

### Per-Branch
Create git branch with project-specific overrides

## File Structure

```
openconfig/
├── opencode.json          # Main config
├── AGENTS.md              # Universal rules
├── GLOBAL_WORKFLOW.md      # Detailed workflow
├── agents/
│   └── python-dev.md      # Python agent
├── skills/
│   ├── planning/
│   ├── code-review/
│   ├── test-generation/
│   └── project-analysis/
├── plugins/
│   ├── ruff-auto-fix/
│   ├── biome-auto-fix/
│   └── setup-dev-hook/
└── configs/
    ├── python/
    └── frontend/
```

## Requirements

- Python 3.9+
- Node.js 18+ (for Biome)
- ruff: `pip install ruff`
- mypy: `pip install mypy`
- pytest: `pip install pytest`
- Biome: `npm install -g @biomejs/biome`

## License

MIT
