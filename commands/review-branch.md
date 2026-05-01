---
description: Review all code on this branch for bugs, regressions, and edge cases before merging
---

Review all code changes on the current branch compared to main. Your job is to identify issues—**do NOT fix anything yourself**.

## Process

1. First, run `git diff main...HEAD --name-only` to see all changed files
2. For each changed file, run `git diff main...HEAD -- <filepath>` to see the actual changes
3. Analyze each change carefully for issues

## What to Look For

1. **Bugs** - Logic errors, off-by-one errors, null/undefined checks, type mismatches
2. **Regressions** - Code that might break existing functionality or violate existing patterns
3. **Edge cases** - Unhandled scenarios, boundary conditions, error states
4. **Security issues** - Injection vulnerabilities, auth bypasses, data exposure
5. **Performance concerns** - N+1 queries, unnecessary re-renders, memory leaks
6. **Missing tests** - New code paths without test coverage

## Output Format

For each issue found, report:

```
### [SEVERITY] File: `path/to/file.ts` (lines X-Y)

**Issue:** Brief description of the problem

**Details:** Why this is a problem and what could go wrong

**Suggestion:** How to fix it (but don't implement)
```

Severity levels:
- **CRITICAL** - Will cause crashes, data loss, or security vulnerabilities
- **HIGH** - Likely to cause bugs in production
- **MEDIUM** - Could cause issues in edge cases
- **LOW** - Code quality/style concerns

## Final Summary

End with a summary:
- Total issues found by severity
- Files with the most issues
- Recommendation: Safe to merge / Needs fixes before merge / Needs major rework
