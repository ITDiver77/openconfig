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

## Important Decisions

### Installation Method
- Date: 2026-03-22
- Decision: Symlink instead of copy
- Rationale: Single source of truth, easy updates

### Project Files Location
- Date: 2026-03-22
- Decision: project.md, todo.md, context.md, changelog.md in project root
- Rationale: OpenCode reads these automatically

## Gotchas

### Symlinks and Git
- Problem: Git doesn't track symlinks the same as regular files
- Workaround: Use `ln -sf` in install script, force recreate

### Plugins Path
- Problem: Plugins need package.json for OpenCode to load
- Workaround: Each plugin has its own package.json

## Important Files
| File | Purpose |
|------|---------|
| `opencode.json` | Main config, model, permissions, MCP |
| `AGENTS.md` | Universal rules |
| `GLOBAL_WORKFLOW.md` | Detailed workflow |
| `scripts/install-global.sh` | Global installation |

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
