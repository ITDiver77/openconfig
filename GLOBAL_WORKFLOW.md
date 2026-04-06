# Global Development Workflow

## Session Start

### Step 1: Read Project Files (REQUIRED)

Before ANY other work, read these files:

```
1. product.md      - Project overview, architecture, tech stack
2. todo.md         - Current tasks, roadmap, priorities
3. context.md      - Patterns, conventions, gotchas
4. changelog.md    - What changed in previous sessions
5. deployment.md   - Deployment procedure for this project
```

### Step 2: Read Agent Definitions (REQUIRED)

Read all agent files so you know how to instruct each agent:

```
agents/python-dev.md      - Python developer agent
agents/js-ts-dev.md       - JS/TS developer agent
agents/tester.md          - Tester agent (TDD)
agents/code-reviewer.md   - Code reviewer agent
```

### Step 3: Setup Environment

If `scripts/setup-dev.sh` exists:
- **Do NOT run manually**
- Hook will run it automatically before tests
- Verify it completes successfully

### Step 4: Analyze State

From project files, understand:
- What is the project about?
- What needs to be done?
- Any blockers or dependencies?
- What changed since last session?

Then confirm: "Orchestrator ready. N tasks pending in todo.md."

---

## Main Workflow Loop

```
┌─────────────────────────────────────────────────────────────────┐
│                      ANALYZE PROJECT                            │
│  • Read product.md for context                                 │
│  • Review todo.md for pending tasks                           │
│  • Check changelog.md for recent changes                       │
│  • Read deployment.md for deploy procedure                     │
│  • Identify blockers or dependencies                           │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    PICK NEXT TASK                               │
│  • Select top pending task from todo.md                        │
│  • Verify no blockers                                          │
│  • Determine language: Python → python-dev, JS/TS → js-ts-dev │
│  • Prepare task SPECIFICATION (WHAT, not HOW)                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  PHASE 0: SETUP DEV DOCKER (if docker-compose.dev.yml exists)  │
│                                                                 │
│  • docker compose -f docker-compose.dev.yml build --no-cache   │
│  • docker compose -f docker-compose.dev.yml up -d              │
│  • Wait for services ready (sleep 5, check health)             │
│                                                                 │
│  If dev compose file doesn't exist → skip (stateless project)  │
│  If build fails → report to user, do NOT proceed               │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  PHASE 1: RED — Tester writes tests from spec                  │
│                                                                 │
│  Task tool → subagent_type: "general"                           │
│  Prompt must include:                                           │
│    • Task specification (inputs, outputs, behavior)             │
│    • Edge cases to test                                         │
│    • Error scenarios to test                                    │
│    • Project language                                           │
│    • Existing code patterns (from context.md)                   │
│    • "Write tests that WILL FAIL (no impl exists yet)"          │
│                                                                 │
│  Track: test file path, test case names                         │
│  ⚠ Run tests in dev Docker to confirm they FAIL:               │
│    docker compose -f docker-compose.dev.yml exec app pytest     │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  PHASE 2: GREEN — Developer implements                         │
│                                                                 │
│  Task tool → subagent_type: "python-dev" or "general"           │
│  Prompt must include:                                           │
│    • Same task specification                                    │
│    • Test file path + all test case names                       │
│    • "Make ALL tests pass. Do NOT modify tests."                │
│    • Project conventions from context.md                        │
│    • Relevant existing code for context                         │
│                                                                 │
│  Track: implementation file paths, test results                 │
│  ⚠ Developer must run tests inside dev Docker:                  │
│    docker compose -f docker-compose.dev.yml exec app pytest     │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  PHASE 3: VALIDATE — Tester verifies in dev Docker              │
│                                                                 │
│  Task tool → subagent_type: "general"                           │
│  Prompt must include:                                           │
│    • Original task specification                                │
│    • Test file paths                                            │
│    • Implementation file paths                                  │
│    • "Run all tests in dev Docker. Add edge cases if needed."   │
│                                                                 │
│  Results:                                                       │
│    PASS → Phase 4                                               │
│    FAIL → back to Phase 2 with failure details                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  PHASE 4: REVIEW — Code Reviewer                               │
│                                                                 │
│  Task tool → subagent_type: "general" (review mode)             │
│  Prompt must include:                                           │
│    • Task description                                           │
│    • ALL changed files (implementation + tests)                 │
│    • Project conventions                                        │
│    • Review criteria from agents/code-reviewer.md               │
│                                                                 │
│  Reviewer returns structured verdict:                           │
│    APPROVED → Phase 5                                           │
│    ISSUES_FOUND (P0/P1/P2) → Phase 2 with fix list             │
│    DEBATE_NEEDED → Phase 4a                                     │
│                                                                 │
│  ⚠ Track review round count. Max 2 rounds total.               │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  PHASE 4a: DEBATE (optional, when reviewer requests)           │
│                                                                 │
│  Round 1:                                                       │
│    1. Send reviewer's concern to developer                      │
│    2. Collect developer's counter-argument with proof           │
│    3. Send developer's argument to reviewer                     │
│    4. Collect reviewer's response                               │
│                                                                 │
│  If reviewer still rejects → Round 2:                           │
│    5. Send remaining concerns to developer                      │
│    6. Collect developer's final argument                        │
│    7. Send to reviewer                                          │
│    8. Collect reviewer's final verdict                          │
│                                                                 │
│  If still rejected after 2 rounds → ESCALATE (Phase 4b)        │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  PHASE 4b: ESCALATION — Ask user via question tool             │
│                                                                 │
│  Present BOTH arguments with full detail:                       │
│                                                                 │
│  Developer's position:                                          │
│    • What they implemented and why                              │
│    • Code references and proof of correctness                   │
│    • Performance/complexity trade-offs considered               │
│                                                                 │
│  Reviewer's position:                                           │
│    • What issues they found (with severity)                     │
│    • Risk assessment and potential failure modes                │
│    • Suggested alternative with rationale                       │
│                                                                 │
│  User chooses from options. Log to finding.md.                  │
│  Implement user's choice. Continue to Phase 5.                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  PHASE 5: DOCUMENT + COMMIT                                    │
│                                                                 │
│  a) Tear down dev Docker:                                       │
│     docker compose -f docker-compose.dev.yml down               │
│                                                                 │
│  b) Update todo.md:                                             │
│     - Move task from "In Progress" to "Done"                   │
│     - Note any new tasks discovered                             │
│                                                                 │
│  c) Update changelog.md:                                        │
│     - Add session entry with what changed                       │
│     - List all files modified/created                           │
│                                                                 │
│  d) Update finding.md:                                          │
│     - Log any P2/P3 issues reviewer flagged but didn't fix     │
│     - Log escalation details if any                             │
│                                                                 │
│  e) Commit:                                                     │
│     - Run quality gates first                                   │
│     - Commit with detailed message (see AGENTS.md format)       │
│                                                                 │
│  Then → Pick next task from todo.md → back to Phase 0.         │
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
               │ PHASE 0  │      │  DEPLOY     │
               │ (DEV     │      │             │
               │ DOCKER)  │      │ From deployment.md:                │
               └──────────┘      │ 1. Tear down dev Docker             │
                                 │ 2. Full CI pipeline in dev Docker   │
                                 │ 3. docker compose build --no-cache  │
                                 │ 4. docker compose up -d             │
                                 │ 5. Health check                     │
                                 │ 6. Report status to user            │
                                 └─────────────┘
```

---

## Memory Checkpoints

### Before Each Task (Silent Check)
Ask yourself:
1. What is my role? → Orchestrator, not coder
2. What is the current task? → Check todo.md
3. What phase am I in? → 0-Setup, 1-Red, 2-Green, 3-Validate, 4-Review, 5-Commit
4. How many review rounds so far? → Track count
5. What agents are available? → python-dev, js-ts-dev, tester, code-reviewer

### Context Refresh Triggers
Re-read AGENTS.md and GLOBAL_WORKFLOW.md when:
- Starting a new session
- After 3+ tasks completed (context drift)
- When confused about pipeline phase
- After a long debate or escalation
- When switching between Python and JS/TS tasks

### Information to Preserve Across Tasks
- Project type (stateful / stateless / multi-repo)
- Primary language (Python / JS/TS / mixed)
- Review round count for current task
- Files created/modified in current task
- Any unresolved issues from previous tasks

---

## Error Recovery

### Developer Fails Tests (Phase 2)
1. Collect failure output from developer
2. If same failure 3 times → simplify task or split into subtasks
3. Send back to developer with clearer instructions

### Tester Finds New Issues (Phase 3)
1. Collect test failure details
2. Send to developer with specific failure messages
3. If developer fails 3 times → flag in todo.md, move to next task

### Reviewer Rejects (Phase 4)
1. Collect fix list with severity levels
2. Send P0, P1, and P2 fixes to developer
3. Log P3 to finding.md
4. Track review round count
5. After 2 rounds → escalate to user

### Deployment Fails
1. Log the error
2. Do NOT retry automatically
3. Report to user with error details
4. Wait for user instruction

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
tsc --noEmit
npm test
```

### Before Deployment

```bash
# Full CI pipeline
# 1. All tests pass
# 2. No lint errors
# 3. No type errors
# 4. All code formatted
# Then: follow deployment.md
```

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
