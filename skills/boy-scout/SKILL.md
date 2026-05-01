---
name: boy-scout
description: Leave the code better than you found it. Review files edited on the current branch and make small-to-medium improvements to legibility, organization, correctness, cognitive load, composition, and test coverage. Use when asked to "boy scout", "polish this branch", "improve what I touched", "leave it cleaner", or when wrapping up a feature before PR. Complements cleanup-branch (which focuses on DRY/dead code) by focusing on readability and structural improvements within the files.
---

Apply the Boy Scout Rule to files edited on the current branch: leave each touched file a little better than you found it. Make small-to-medium improvements — not a rewrite, not a refactor epic. If a change feels bigger than ~50 lines or risks behavior changes, stop and flag it instead of doing it.

## Scope guardrails

- **Only touch files already edited on this branch.** Get the list with `git diff main...HEAD --name-only`. Do not expand scope to neighboring files unless a rename requires it.
- **Do not change behavior.** Every improvement must be a pure refactor or an additive test. If a change alters observable behavior, stop and ask.
- **Prefer small wins.** Many 5–30 line improvements beat one 300-line rewrite. If it looks like a rewrite, flag it in the summary and skip it.
- **This is not cleanup-branch.** Skip DRY consolidation, dead code removal, and util relocation — that skill handles those. Focus on the items below.

## Step 1: Survey the branch

1. `git diff main...HEAD --name-only` — get the edited files
2. `git diff main...HEAD --stat` — get a sense of size per file; prioritize files with the most churn
3. For each file, read the FULL file (not just the diff). Boy-scout improvements require whole-file context.

## Step 2: Look for improvements

Walk through each edited file with the following lens. When you find something, make the fix immediately (unless it's too big — see guardrails).

### Legibility
- **Unclear names** — Rename variables/functions whose purpose isn't obvious from the name. `data`, `item`, `tmp`, `handleClick2` are red flags.
- **Nested conditionals** — Flatten with early returns / guard clauses.
- **Long parameter lists (4+)** — Consider an options object, especially when several are booleans.
- **Boolean traps** — `doThing(true, false, true)` is unreadable at call sites. Use named fields.
- **Missing "why" comments** — If the branch added non-obvious logic (a workaround, a product decision, a performance trick), add a brief comment explaining *why*. Do not add comments that restate *what* the code does.

### Cognitive load
- **Large functions (>~60 lines or juggling multiple concerns)** — Extract helpers with clear names. The helper's name should describe intent, not mechanics.
- **Mixed abstraction levels** — If a function alternates between high-level steps and low-level fiddling, extract the low-level bits.
- **Too many local variables** — Often a sign that a chunk should be extracted.
- **Deep chains of optional chaining / ternaries** — Break into steps with explanatory names.

### React composition (when applicable)
- **Prop drilling >2 levels** — Consider context, or compose with children/slots.
- **Boolean prop proliferation** — Refer to the `vercel-composition-patterns` skill. Convert to compound components or variants.
- **Giant components** — Split into presentational + container, or extract subcomponents when a logical section has its own state or markup block.
- **Inline handlers doing real work** — Hoist to named functions above the return.
- **Effects that really aren't effects** — Derived state, event handlers, and initialization don't belong in `useEffect`. Move them.
- **Keys using array index** where items reorder — Use a stable id.

### Organization
- **File too long (>~400 lines) and mixing concerns** — Split only if the seam is obvious and low-risk. Otherwise flag, don't do.
- **Helpers defined below their only caller** — Hoist for top-down readability, or move private helpers to the bottom consistently (match file/module convention).
- **Types/interfaces far from their use** — Colocate when it reduces jumping.
- **Imports not grouped** — Let the formatter handle it; don't hand-shuffle.

### Correctness (low-risk only)
- **Loose equality `==`** in TS/JS — Tighten to `===`.
- **Missing `await`** on a promise whose result is used.
- **Unchecked array access** where the index could be out of bounds.
- **Exhaustiveness gaps** — `switch` on a union without a `default` / `never` check.
- **Error swallowing** — `catch {}` that silently drops errors. At minimum log; better, handle.
- Anything more invasive than the above: **flag, do not fix.** It belongs in its own PR.

### Tests
- Did this branch add a new non-trivial function, hook, or pure utility that has **no** test?
  - If a test file already exists alongside, add 1–3 focused cases for the golden path + one edge case.
  - If no test file exists and the surrounding area has tests, create one following the same pattern.
  - If the area has no tests at all, do not introduce a lone test file. Flag it instead.
- Do not add tests for React components whose only behavior is rendering — not worth the maintenance.

## Step 3: Verify nothing broke

Improvements must not change behavior. After changes:

- Frontend: `npm run typecheck`, `npm run lint`, `npm run test:run`
- Backend (if touched): `cd backend && make check`

If a test breaks, something was renamed or moved incorrectly — fix it, don't delete the test.

## Step 4: Format

Run `make total-format` (or the repo's formatter) so diffs stay clean.

## Output summary

Group changes by the lens they came from. Keep it terse.

```
### Legibility
- `components/Foo.tsx`: renamed `data` → `rowsByDate`, flattened nested if into guard clauses
- `lib/format.ts`: split 90-line `formatReport()` into 3 helpers

### Cognitive load
- `hooks/useBar.ts`: extracted `computeLayout()` so the hook body reads as steps

### React composition
- `components/Switcher.tsx`: replaced 5 boolean props with `variant` union

### Correctness
- `api/handler.ts`: added `default: assertNever(x)` to the status switch

### Tests added
- `lib/parseRange.ts`: added 3 cases covering empty input, single value, and inverted range

### Flagged but NOT changed (too big / risky)
- `components/Canvas.tsx` is 1200 lines and mixes 3 concerns — suggest a dedicated split PR
- `backend/app/services/export.py` has a suspicious error swallow at line 412 — needs product input before changing

### Verification
- TypeCheck: ✅  Lint: ✅  Tests: ✅  Backend: ✅/n-a
```

The "flagged but not changed" section is important — boy-scouting is about small wins, so surfacing the bigger issues without attempting them is part of the job.

## Step 5: File tickets for flagged items

If the "flagged but NOT changed" list is non-empty, offer to file them as tickets so they don't get lost. Read the `beads` skill (`~/.claude/skills/beads/SKILL.md`) for the project's `br` CLI conventions — issue types, prefix, how to set parents, etc. — and then create one ticket per flagged item using `br create` (or `br q` for quick captures).

Default to asking the user for confirmation before creating tickets unless they've already told you to go ahead. Include the file path and a brief description of the concern in each ticket so it's actionable later.
