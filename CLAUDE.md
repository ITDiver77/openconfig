# OpenCode Fallback Rules

If no `AGENTS.md` is found, these rules apply:

## Basic Guidelines

1. **Read project files** at session start (product.md, todo.md, context.md, changelog.md)
2. **Follow the workflow** defined in GLOBAL_WORKFLOW.md
3. **Use type hints** in Python, strict TypeScript in JS/TS
4. **Run quality checks** before commits (lint, format, typecheck, test)
5. **Commit atomically** with detailed messages

## Default Behavior

- Ask before making destructive changes
- Explain major decisions
- Update project documentation when relevant
- Run tests after implementation

## Restrictions

- No commits without running tests first
- No secrets or credentials in code
- No debug code in final commits
