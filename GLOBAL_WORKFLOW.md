# Global Development Workflow

## Session Start

### Step 1: Read Project Files (REQUIRED)

Before ANY other work, read these files:

```
1. product.md      - Project overview, architecture, tech stack
2. todo.md         - Current tasks, roadmap, priorities
3. context.md      - Patterns, conventions, gotchas
4. changelog.md    - What changed in previous sessions
```

### Step 2: Setup Environment

If `scripts/setup-dev.sh` exists:
- **Do NOT run manually**
- Hook will run it automatically before tests
- Verify it completes successfully

### Step 3: Analyze State

From project files, understand:
- What is the project about?
- What needs to be done?
- Any blockers or dependencies?
- What changed since last session?

---

## Main Workflow Loop

```
┌─────────────────────────────────────────────────────────────────┐
│                      ANALYZE PROJECT                            │
│  • Read product.md for context                                 │
│  • Review todo.md for pending tasks                           │
│  • Check changelog.md for recent changes                       │
│  • Identify blockers or dependencies                           │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    PLAN / REVIEW PLAN                           │
│  • Is todo.md up to date?                                      │
│  • What's the priority for today?                             │
│  • Break large tasks into atomic items                        │
│  • Add new tasks if discovered                                │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                   IMPLEMENT TASK (Atomic)                       │
│                                                                 │
│  1. Make ONE focused change                                   │
│  2. Lint:   ruff check / biome check                         │
│  3. Format: ruff format / biome format --write               │
│  4. Typecheck: mypy (Python)                                  │
│  5. Test: Run specific test for this change                  │
│                                                                 │
│  ⚠️ If any step fails → Fix before continuing                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     CODE REVIEW (Self)                          │
│                                                                 │
│  Questions to ask:                                             │
│  • Is logic correct?                                           │
│  • Are edge cases handled?                                     │
│  • Are there tests?                                            │
│  • Is error handling appropriate?                              │
│  • Does it follow project conventions?                         │
│                                                                 │
│  If issues found → Go back to IMPLEMENT                        │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    COMMIT (If Good)                             │
│                                                                 │
│  Message format:                                              │
│  ```                                                          │
│  <type>: <short description>                                   │
│                                                                 │
│  <detailed WHY explanation>                                    │
│                                                                 │
│  - What was added/changed/removed                             │
│  - Before vs after behavior                                    │
│                                                                 │
│  Closes #<issue>                                               │
│  ```                                                          │
│                                                                 │
│  Then:                                                        │
│  • Move task in todo.md to "done"                            │
│  • Add summary to changelog.md                                │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌─────────────────┐
                    │ More tasks?     │
                    └────────┬────────┘
                             │
                    ┌────────┴────────┐
                    │                  │
                   YES                 NO
                    │                  │
                    ▼                  ▼
              ┌──────────┐      ┌─────────────┐
              │ IMPLEMENT │      │  FINAL CI   │
              │   TASK    │      │             │
              └──────────┘      │ • All tests  │
                                │ • Full lint  │
                                │ • Typecheck  │
                                │ • Commit all │
                                │ • Update docs│
                                └─────────────┘
                                           │
                                           ▼
                                  ┌─────────────┐
                                  │ SESSION END │
                                  │             │
                                  │ • Update    │
                                  │   context.md │
                                  │ • Final     │
                                  │   changelog  │
                                  │ • Commit    │
                                  │   if needed │
                                  └─────────────┘
```

---

## Task States in todo.md

```markdown
## Roadmap

### In Progress
- [ ] Task currently being worked on

### Pending
- [ ] Task ready to start
- [ ] Another pending task

### Done (this session)
- [x] Completed task
```

---

## Quality Gates

### Before Any Commit

```bash
# Python
ruff check .
ruff format .
mypy .
pytest -v

# JS/TS
biome check .
biome format --write .
npm test
```

### Before Ending Session

```bash
# Run full CI
# 1. All tests pass
# 2. No lint errors
# 3. No type errors
# 4. All code formatted
```

---

## Atomic Commit Checklist

- [ ] One logical change only
- [ ] Tests pass
- [ ] Lint clean
- [ ] Typecheck passes
- [ ] Formatted
- [ ] Meaningful commit message (WHY, not just WHAT)
- [ ] No debug code
- [ ] No secrets
- [ ] todo.md updated
- [ ] changelog.md updated

---

## Session End Protocol

### If changes were made:

1. **Update changelog.md**
   ```markdown
   ## Session - YYYY-MM-DD
   
   ### Completed
   - Feature X: description
   
   ### Changes
   - Modified file.py: what changed
   ```

2. **Update context.md** (if new patterns discovered)
   - New conventions learned
   - Gotchas to remember
   - Important decisions made

3. **Update todo.md**
   - Mark completed tasks
   - Add any new tasks discovered
   - Re-prioritize if needed

4. **Commit remaining changes**
   - Always leave repo in clean state

### If no changes made:
- Log what was reviewed/considered
- Update changelog.md with session summary
