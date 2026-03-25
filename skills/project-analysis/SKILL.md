---
name: project-analysis
description: Codebase structure discovery and analysis
---

# Project Analysis Guidelines

## Session Start Protocol

**FIRST:** Read these files at the start of EVERY session:
1. `product.md` - Full project overview
2. `todo.md` - Current tasks and plans
3. `context.md` - Important patterns and decisions
4. `changelog.md` - Recent changes in previous sessions

## Analysis Workflow

### 1. Project Overview

Before exploring, understand:

- What is this project?
- What language(s) and frameworks?
- What is the project structure?
- What are the main components?

### 2. Architecture Discovery

#### Find Entry Points
```bash
# Python
glob pattern: "**/main.py", "**/__main__.py", "**/app.py"
grep pattern: "if __name__"

# JavaScript/TypeScript
glob pattern: "**/index.ts", "**/index.js", "**/server.ts"
grep pattern: "createApp", "new App"
```

#### Identify Modules/Services
```bash
# Find service directories
glob pattern: "**/services/**"
glob pattern: "**/modules/**"
glob pattern: "**/features/**"

# Find API routes
glob pattern: "**/routes/**"
glob pattern: "**/endpoints/**"
glob pattern: "**/controllers/**"
```

#### Find Data Models
```bash
# Python
glob pattern: "**/models/**"
glob pattern: "**/schemas/**"
grep pattern: "class.*Model", "dataclass"

# TypeScript
glob pattern: "**/types/**"
glob pattern: "**/interfaces/**"
grep pattern: "interface.*", "type.*="
```

### 3. Dependencies

```bash
# Python - requirements, setup.py, pyproject.toml
glob pattern: "requirements*.txt"
glob pattern: "**/pyproject.toml"

# JavaScript - package.json files
glob pattern: "**/package.json"
```

### 4. Configuration Discovery

```bash
# Find config files
glob pattern: "**/*.toml"
glob pattern: "**/*.yaml", "**/*.yml"
glob pattern: "**/*.json"
glob pattern: "**/.env*"
glob pattern: "**/config*"
```

### 5. Testing Structure

```bash
# Find test directories
glob pattern: "**/tests/**"
glob pattern: "**/__tests__/**"
glob pattern: "**/test_*.py"
glob pattern: "**/*.test.ts"
```

## Analysis Checklist

### Project Structure
- [ ] Entry point(s) identified
- [ ] Main modules/packages discovered
- [ ] Directory structure understood
- [ ] Build/test commands identified

### Architecture
- [ ] Architecture pattern (MVC, microservices, etc.)
- [ ] How components interact
- [ ] Data flow understood
- [ ] External services identified

### Dependencies
- [ ] All dependencies listed
- [ ] Version constraints identified
- [ ] Development vs production deps
- [ ] Optional dependencies noted

### Testing
- [ ] Test framework identified
- [ ] Test patterns understood
- [ ] Fixtures/factories located
- [ ] Coverage expectations known

### Configuration
- [ ] Environment variables identified
- [ ] Config file locations found
- [ ] Secrets handling understood
- [ ] Default values noted

## Documentation Checklist

After analysis, update `product.md`:

```markdown
## Project Structure

### Directory Layout
```
project/
├── src/              # Source code
│   ├── api/         # API endpoints
│   ├── services/    # Business logic
│   └── models/      # Data models
├── tests/           # Tests
├── scripts/         # Utility scripts
└── config/          # Configuration
```

### Key Files
| File | Purpose |
|------|---------|
| `src/main.py` | Application entry point |
| `src/config.py` | Configuration management |
| `tests/conftest.py` | Test fixtures |

### Architecture
- Pattern: [MVC/REST/Event-driven/etc.]
- Database: [Type]
- Caching: [Type]
- Background Jobs: [Type]

### Dependencies
- Framework: [Name, Version]
- ORM: [Name, Version]
- Testing: [pytest/jest/etc.]

### Commands
| Command | Purpose |
|---------|---------|
| `npm run dev` | Start development server |
| `npm test` | Run tests |
| `npm run build` | Build for production |
```

## Context.md Updates

After analysis, update `context.md`:

```markdown
## Project Conventions

### Naming
- Files: [kebab-case/snake_case/camelCase]
- Classes: [PascalCase]
- Functions: [snake_case/camelCase]

### Patterns
- Error handling: [How exceptions are handled]
- Logging: [Logging library and format]
- Configuration: [How config is loaded]

### Gotchas
- [Issue 1] - [Description and workaround]
- [Issue 2] - [Description and workaround]

### Important Files
- `src/utils/helpers.py` - Shared utilities
- `tests/fixtures.py` - Test data factories
```

## Questions to Ask

1. What problem does this project solve?
2. What is the data model?
3. How do components communicate?
4. Where is business logic located?
5. How is state managed?
6. What are the external dependencies?
7. How is error handling done?
8. What testing patterns are used?
9. Are there any non-obvious conventions?
10. What would break if I change X?

## Analysis Commands

```bash
# Count files by type
find . -name "*.py" | wc -l
find . -name "*.ts" | wc -l

# Find largest files
find . -name "*.py" -exec wc -l {} + | sort -rn | head -20

# Find complexity hotspots
grep -r "def " --include="*.py" | cut -d: -f2 | sort | uniq -c | sort -rn

# Find TODO/FIXME
grep -rn "TODO\|FIXME\|HACK" --include="*.py"
```
