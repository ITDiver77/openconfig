---
name: code-review
description: Structured code review with severity-based findings
---

# Code Review Guidelines

## Session Start Protocol

**FIRST:** Read these files at the start of EVERY session:
1. `project.md` - Full project overview
2. `todo.md` - Current tasks and plans
3. `context.md` - Important patterns and decisions
4. `changelog.md` - Recent changes in previous sessions

## Review Priorities

### P0 - Critical (Must Fix)
- Security vulnerabilities
- Data loss potential
- Breaking changes
- Race conditions
- Unhandled exceptions

### P1 - High (Should Fix)
- Logic errors
- Performance issues
- Missing error handling
- Memory leaks
- Incorrect assumptions

### P2 - Medium (Suggested)
- Code duplication
- Poor naming
- Missing tests
- Incomplete documentation
- Complex logic

### P3 - Low (Optional)
- Style inconsistencies
- Minor optimizations
- Preference-based
- Nits

## Review Checklist

### Correctness
- [ ] Does the code do what it's supposed to?
- [ ] Are edge cases handled?
- [ ] Are boundaries correct?
- [ ] Are there off-by-one errors?
- [ ] Is concurrency handled properly?

### Security
- [ ] Is user input validated?
- [ ] Are secrets protected?
- [ ] Is authorization checked?
- [ ] Is SQL injection prevented?
- [ ] Are files sanitized?

### Performance
- [ ] Are there N+1 queries?
- [ ] Are caches used appropriately?
- [ ] Are loops efficient?
- [ ] Is memory handled correctly?
- [ ] Are indexes used?

### Error Handling
- [ ] Are exceptions caught specifically?
- [ ] Are errors logged?
- [ ] Is error context preserved?
- [ ] Are resources cleaned up?
- [ ] Is retry logic appropriate?

### Testing
- [ ] Are happy paths tested?
- [ ] Are edge cases tested?
- [ ] Are error cases tested?
- [ ] Is coverage adequate?
- [ ] Are tests maintainable?

### Maintainability
- [ ] Is code readable?
- [ ] Are names descriptive?
- [ ] Is complexity reasonable?
- [ ] Is DRY followed?
- [ ] Are changes localized?

## Output Format

### For Each Finding

```
File: src/services/auth.py:45
Priority: P1
Issue: Missing error handling for database connection failure

The code doesn't handle the case where the database is unavailable.
If this happens, users will see a cryptic error message.

Suggestion:
```python
try:
    result = await db.query(...)
except DatabaseError as e:
    logger.error(f"Database error: {e}")
    raise ServiceUnavailableError("Authentication service temporarily unavailable")
```

Why: Users should get a helpful error message, not a crash.
```

### Summary Template

```markdown
## Review Summary

### Files Changed
- [List of files]

### Critical Issues (P0)
- [ ] None
- [ ] Issue 1
- [ ] Issue 2

### High Priority (P1)
- [ ] Issue 1
- [ ] Issue 2

### Medium Priority (P2)
- [ ] Issue 1
- [ ] Issue 2

### Low Priority (P3)
- [ ] Nits

### Recommendations
- [ ] General suggestions

### Approval Status
- [ ] Approved
- [ ] Request Changes
- [ ] Needs Discussion
```

## Self-Review Before Submitting

1. Have I tested my changes?
2. Have I run the linter?
3. Have I run the type checker?
4. Are tests passing?
5. Is the commit message clear?
6. Did I update documentation?
7. Are there any debug prints?
8. Are secrets hardcoded?

## Questions to Ask

1. Would I want to maintain this code?
2. Is this the simplest solution?
3. What would break this?
4. How would I test this manually?
5. Is the error message helpful?
