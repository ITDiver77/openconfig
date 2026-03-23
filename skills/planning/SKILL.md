---
name: planning
description: Structured planning workflow for complex features
---

# Planning Workflow

## Session Start Protocol

**FIRST:** Read these files at the start of EVERY session:
1. `project.md` - Full project overview
2. `todo.md` - Current tasks and plans
3. `context.md` - Important patterns and decisions
4. `changelog.md` - Recent changes in previous sessions

## Planning Workflow

### Step 1: Requirements Analysis

Before writing any code, understand:

- **Goal**: What problem does this feature solve?
- **Success criteria**: How do we know it's done?
- **Scope**: What's in and out of scope?
- **Dependencies**: What does this depend on?
- **Constraints**: Time, tech stack, existing patterns

### Step 2: Data Model

- What state needs to be stored?
- What are the entities and relationships?
- What validations are needed?
- Are migrations required?

### Step 3: API/Function Design

For each function/module:

- **Input**: Parameters and types
- **Output**: Return values and types
- **Side effects**: Database, API calls, file I/O
- **Error cases**: What can go wrong?

### Step 4: Implementation Phases

Break into atomic commits:

1. **Foundation**: Data models, types, interfaces
2. **Core logic**: Main business logic
3. **Integration**: API endpoints, event handlers
4. **Polish**: Error handling, logging, edge cases

### Step 5: Verification

Before declaring done:

- Are success criteria met?
- Are edge cases handled?
- Is error handling appropriate?
- Are there performance concerns?

## Task Breakdown Template

```markdown
## Feature: [Name]

### Requirements
- [Requirement 1]
- [Requirement 2]

### Data Model
- Entity: [Name]
  - Fields: [list]
  - Validations: [list]

### API Design
- Endpoint: [path]
- Method: [GET/POST/etc]
- Input: [schema]
- Output: [schema]
- Errors: [list]

### Implementation Phases
1. [ ] Phase 1: [description]
2. [ ] Phase 2: [description]
3. [ ] Phase 3: [description]

### Verification
- [ ] Unit tests for core logic
- [ ] Integration tests for API
- [ ] Error cases covered
- [ ] Documentation updated
```

## Todo.md Updates

After planning, update `todo.md`:

```markdown
## Current Sprint

### In Progress
- [ ] [Task 1]

### Pending
- [ ] [Task 2]
- [ ] [Task 3]

### Done
- [x] [Completed task]

## Feature: [Name]
1. [ ] Requirement analysis
2. [ ] Data model design
3. [ ] API design
4. [ ] Implementation
5. [ ] Testing
6. [ ] Documentation
```

## Questions to Ask

1. What's the simplest thing that could work?
2. How will this be tested?
3. What could go wrong?
4. Is this reusable?
5. What did we learn from similar features?
