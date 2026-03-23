#!/bin/bash
set -e

PROJECT_OPENCODE="$(pwd)/.opencode"
SKILLS_DIR="${PROJECT_OPENCODE}/skills"

echo "Setting up project-specific OpenCode configuration..."

mkdir -p "${PROJECT_OPENCODE}"
mkdir -p "${SKILLS_DIR}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"

cat > "${PROJECT_OPENCODE}/AGENTS.md" << 'EOF'
# Project-Specific Rules

## Session Start Protocol

At the start of EVERY session, FIRST read these files:
1. `project.md` - Full project overview
2. `todo.md` - Current tasks and plans
3. `context.md` - Important patterns and decisions
4. `changelog.md` - Recent changes in previous sessions

## Project Overrides

Add project-specific rules below this line.
These take precedence over global config.

EOF

cat > "$(pwd)/project.md" << 'EOF'
# Project Name

## Overview
[Brief description of the project]

## Tech Stack
- Language: [Python/JavaScript/TypeScript]
- Framework: [Django/FastAPI/React/Next.js/etc.]
- Database: [PostgreSQL/MongoDB/etc.]
- Cache: [Redis/Memcached]
- Other: [list key technologies]

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

## Key Dependencies
- [Dependency 1]: [Purpose]
- [Dependency 2]: [Purpose]

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

## External Services
- [Service 1]: [Purpose]
- [Service 2]: [Purpose]
EOF

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

## Current Sprint

### This Session
- [ ] [Task for current session]

### Next Steps
- [ ] [Next task]
- [ ] [Following task]

## Backlog
- [ ] [Future task 1]
- [ ] [Future task 2]
EOF

cat > "$(pwd)/context.md" << 'EOF'
# Context

## Project Conventions

### Naming
- Files: [naming convention]
- Classes: [PascalCase/etc.]
- Functions: [snake_case/camelCase]

### Patterns
- Error handling: [How exceptions are handled]
- Logging: [Logging library and format]
- Configuration: [How config is loaded]

## Important Decisions

### [Decision 1]
- Date: YYYY-MM-DD
- Decision: [What was decided]
- Rationale: [Why this approach]

## Gotchas

### [Issue 1]
- Problem: [Description]
- Workaround: [Solution]

### [Issue 2]
- Problem: [Description]
- Workaround: [Solution]

## Important Files
| File | Purpose |
|------|---------|
| `src/config.py` | Configuration management |
| `tests/conftest.py` | Test fixtures |
| `src/utils/` | Shared utilities |

## Learned Lessons
- [Lesson 1]: [Description]
EOF

cat > "$(pwd)/changelog.md" << 'EOF'
# Changelog

All notable changes to this project are documented here.

## [Unreleased]

### Added
- [Feature 1]: [Description]

### Changed
- [Change 1]: [Description]

### Fixed
- [Fix 1]: [Description]

### Deprecated
- [Deprecation]: [Description]

### Removed
- [Removal]: [Description]

---

## Session - YYYY-MM-DD

### Completed
- [Task 1]: [What was done]

### Changes
- Modified `file.py`: [What changed]

### Notes
- [Any observations or notes]
EOF

echo ""
echo "✓ Project setup complete!"
echo ""
echo "Created files:"
echo "  - .opencode/AGENTS.md"
echo "  - project.md"
echo "  - todo.md"
echo "  - context.md"
echo "  - changelog.md"
echo ""
echo "Next steps:"
echo "  1. Edit project.md with your project details"
echo "  2. Update todo.md with initial tasks"
echo "  3. For stateful projects, run: ./path/to/openconfig/scripts/bootstrap.sh --stateful"
