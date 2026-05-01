---
description: Clean up code on the current branch — DRY duplications, remove dead code, relocate misplaced utils, and fix code hygiene
---

Review all code changes on the current branch and clean up code hygiene issues. The feature works — now make the code production-quality.

## Step 1: Identify what changed

Run `git diff main...HEAD --name-only` to see all files changed on this branch. These are the files to focus on.

For each changed file, read the FULL file (not just the diff) — many issues are only visible in the context of the whole file.

## Step 2: Find duplicated code (DRY violations)

Look for code that was duplicated across the branch's changes:

1. **Within changed files** — Are there functions or blocks that do nearly the same thing? Could they share a common helper?
2. **Across changed files** — Did the same pattern get copy-pasted into multiple files?
3. **Against existing code** — Search the broader codebase for existing utilities that do the same thing as newly written code. Check these common locations:
   - `lib/utils/` and `lib/` — Frontend shared utilities
   - `core/` — Core logic and helpers
   - `hooks/` — Shared React hooks
   - `backend/app/utils/` — Backend shared utilities
   - `backend/app/services/` — Backend shared services

For each duplication found: extract the shared logic into a single function/helper and reuse it everywhere.

## Step 3: Remove dead code and unused imports

For each changed file:

1. **Unused imports** — Check every import at the top of the file. Is it actually used? Remove any that aren't.
2. **Unused variables/functions** — Look for variables, functions, or constants that were defined but never referenced. Sometimes leftover from iteration.
3. **Commented-out code** — Remove it. That's what git history is for.
4. **Unreachable code** — Code after early returns, impossible branches, etc.
5. **Leftover debug code** — `console.log`, `print()`, `debugger`, temporary hardcoded values.

Run `npm run lint` and `cd backend && make lint` — linters will catch many unused imports and variables automatically.

## Step 4: Relocate misplaced utilities

This is common: the agent writes a general-purpose helper but places it in a feature-specific file. For each changed file, check:

1. **Does this file contain a utility function that isn't specific to this feature?** For example:
   - Color manipulation helpers → should be in a color-related util file
   - String formatting/parsing → should be in a string-related util file
   - Math/geometry helpers → should be in a math-related util file
   - Date/time helpers → should be in a date-related util file
   - Type guards or type helpers → should be near the types they guard
   - API/fetch helpers → should be in an API-related util file

2. **Find the RIGHT home for it.** Search the codebase for existing files that contain similar utilities:
   - `grep -r "similar function names or patterns"` across `lib/`, `core/`, `utils/`, `hooks/`
   - If an appropriate file exists, move the function there
   - If no appropriate file exists but the utility is clearly general-purpose, create one in the logical location

3. **Update all imports** after moving. Search for every import of the moved function and update the paths.

## Step 5: Check for missed abstractions

Look at the branch's changes holistically:

1. **Repeated patterns** — Is there a pattern used 3+ times that should be a shared function or hook?
2. **Long functions** — Are there functions doing too many things that should be split up?
3. **Magic numbers/strings** — Should any hardcoded values be named constants?
4. **Inconsistent naming** — Do new functions/variables follow the naming conventions used in surrounding code?
5. **Over-abstraction** — Did the agent create unnecessary wrappers or abstractions? Remove abstraction layers that don't add value.

## Step 6: Verify nothing broke

After all cleanup, run checks to make sure everything still works:

**Frontend:**
1. `npm run typecheck`
2. `npm run lint`
3. `npm run test:run`

**Backend (if backend files were changed):**
1. `cd backend && make check`

Fix any failures. Cleanup should never change behavior — if a test breaks, you moved or renamed something incorrectly.

## Step 7: Format

Run `make total-format` to format all changed files.

## Output Summary

### Duplications removed
| # | What | Where it was duplicated | Consolidated to |
|---|------|------------------------|-----------------|
| 1 | Brief description | `file1.ts`, `file2.ts` | `lib/utils/shared.ts` |

### Dead code removed
| # | File | What was removed | Why |
|---|------|-----------------|-----|
| 1 | `path/to/file.ts` | Unused import / dead function / etc. | Explanation |

### Utils relocated
| # | Function/Helper | Moved from | Moved to | Reason |
|---|----------------|------------|----------|--------|
| 1 | `formatColor()` | `features/charts/renderer.ts` | `lib/utils/color.ts` | General-purpose color utility |

### Other improvements
- List any other changes (naming fixes, extracted constants, simplified logic, etc.)

### Verification
- TypeCheck: ✅/❌
- Lint: ✅/❌
- Tests: ✅/❌
- Backend: ✅/❌ (if applicable)
- Behavior unchanged: ✅ (no test failures from cleanup)
