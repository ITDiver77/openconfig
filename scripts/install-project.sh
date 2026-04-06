#!/bin/bash
set -e

PROJECT_OPENCODE="$(pwd)/.opencode"
SKILLS_DIR="${PROJECT_OPENCODE}/skills"

echo "Setting up project-specific OpenCode configuration..."

mkdir -p "${PROJECT_OPENCODE}"
mkdir -p "${SKILLS_DIR}"

if [ ! -f "${PROJECT_OPENCODE}/AGENTS.md" ]; then
    cat > "${PROJECT_OPENCODE}/AGENTS.md" << 'EOF'
# Project-Specific Rules

## Session Start Protocol

At the start of EVERY session, FIRST read these files:
1. `product.md` - Full project overview
2. `todo.md` - Current tasks and plans
3. `context.md` - Important patterns and decisions
4. `changelog.md` - Recent changes in previous sessions
5. `deployment.md` - Deployment procedure

## Project Overrides

Add project-specific rules below this line.
These take precedence over global config.

EOF
    echo "  Created .opencode/AGENTS.md"
else
    echo "  Skipped .opencode/AGENTS.md (exists)"
fi

if [ ! -f "$(pwd)/product.md" ]; then
    cat > "$(pwd)/product.md" << 'EOF'
# Project Name

## Overview
[Brief description of the project]

## Tech Stack
- Language: [Python/JavaScript/TypeScript]
- Framework: [Django/FastAPI/React/Next.js/etc.]
- Database: [PostgreSQL/MongoDB/etc.]
- Cache: [Redis/Memcached]

## Architecture
[High-level architecture description]

## Project Structure
```
project/
├── src/              # Source code
├── tests/            # Tests
├── scripts/          # Utility scripts
└── config/           # Configuration
```

## Commands
| Command | Purpose |
|---------|---------|
| `npm run dev` | Start development server |
| `npm test` | Run tests |

## Environment Variables
| Variable | Description | Required |
|----------|-------------|----------|
| `DATABASE_URL` | Database connection string | Yes |
| `SECRET_KEY` | Application secret | Yes |
EOF
    echo "  Created product.md"
else
    echo "  Skipped product.md (exists)"
fi

if [ ! -f "$(pwd)/todo.md" ]; then
    cat > "$(pwd)/todo.md" << 'EOF'
# TODO

## Roadmap

### In Progress
- [ ] [Task being worked on]

### Pending
- [ ] [Pending task 1]
- [ ] [Pending task 2]

### Done
- [x] [Completed task]
EOF
    echo "  Created todo.md"
else
    echo "  Skipped todo.md (exists)"
fi

if [ ! -f "$(pwd)/context.md" ]; then
    cat > "$(pwd)/context.md" << 'EOF'
# Context

## Project Conventions

### Naming
- Files: [naming convention]
- Classes: [PascalCase]
- Functions: [snake_case/camelCase]

### Patterns
- Error handling: [How exceptions are handled]
- Logging: [Logging library and format]

## Important Decisions

### [Decision 1]
- Date: YYYY-MM-DD
- Decision: [What was decided]
- Rationale: [Why]

## Gotchas

### [Issue 1]
- Problem: [Description]
- Workaround: [Solution]

## Important Files
| File | Purpose |
|------|---------|
| `src/config.py` | Configuration management |
| `tests/conftest.py` | Test fixtures |
EOF
    echo "  Created context.md"
else
    echo "  Skipped context.md (exists)"
fi

if [ ! -f "$(pwd)/changelog.md" ]; then
    cat > "$(pwd)/changelog.md" << 'EOF'
# Changelog

All notable changes to this project are documented here.

---

## Session - YYYY-MM-DD

### Completed
- [Task 1]: [What was done]

### Changes
- Modified `file.py`: [What changed]
EOF
    echo "  Created changelog.md"
else
    echo "  Skipped changelog.md (exists)"
fi

if [ ! -f "$(pwd)/deployment.md" ]; then
    cat > "$(pwd)/deployment.md" << 'EOF'
# Deployment Procedure

## Project-Specific Deployment

This project uses the universal deployment paradigm from the global config.
Override or add project-specific deployment steps below.

### Services
| Service | Internal Port | Dev External | Prod External |
|---------|--------------|-------------|--------------|
| app | 8000 | 58000 | 8000 |
| nginx | 80 | 580 | 80 |
| db | 5432 | 55432 | 5432 |

### Health Check
```bash
curl -f http://localhost:8000/health || echo "HEALTH CHECK FAILED"
```

### Project-Specific Steps
<!-- Add any project-specific deploy steps here -->
EOF
    echo "  Created deployment.md"
else
    echo "  Skipped deployment.md (exists)"
fi

if [ ! -f "$(pwd)/finding.md" ]; then
    cat > "$(pwd)/finding.md" << 'EOF'
# Findings

Unresolved issues and reviewer comments from completed tasks.

---

<!-- Add new sessions below this line -->
EOF
    echo "  Created finding.md"
else
    echo "  Skipped finding.md (exists)"
fi

echo ""
echo "Done. Project files created."
echo ""
echo "Next steps:"
echo "  1. Edit product.md with your project details"
echo "  2. Update todo.md with initial tasks"
echo "  3. Edit deployment.md with your service ports"
echo "  4. For stateful projects, create docker-compose.dev.yml"
