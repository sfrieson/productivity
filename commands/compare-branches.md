---
description: Compare two branch implementations, pick the best one, merge in the other's strengths, and produce a single improved result
---

Compare two branches that solve the same problem, pick the winner, and synthesize the best of both into one polished branch.

The user will provide two branch names after this command. Parse them from the input. Call them BRANCH_A and BRANCH_B.

**IMPORTANT:** Both branches were forked from `main` to implement the same feature. You are comparing only the **new work on each branch relative to main** — NOT the branches against each other, and NOT the entire contents of each branch. Always use the three-dot diff (`main...branch`) to see only what each branch changed.

## Step 1: Fetch and inspect both branches

Run `git fetch origin` to ensure you have the latest remote state.

Then gather the **changes each branch made relative to main** (NOT the full branch contents):

1. `git log main..origin/BRANCH_A --oneline` — new commits on Branch A since main
2. `git log main..origin/BRANCH_B --oneline` — new commits on Branch B since main
3. `git diff main...origin/BRANCH_A --stat` — files Branch A changed vs main
4. `git diff main...origin/BRANCH_B --stat` — files Branch B changed vs main
5. `git diff main...origin/BRANCH_A` — Branch A's full diff vs main (the new feature code)
6. `git diff main...origin/BRANCH_B` — Branch B's full diff vs main (the new feature code)

These diffs show ONLY the new feature work — not the hundreds of shared files from main. This is what you are comparing.

If diffs are very large, use `git diff main...origin/BRANCH_A --name-only` to list changed files, then read them individually with `git show origin/BRANCH_A:path/to/file` and compare against `git show main:path/to/file`.

## Step 2: Evaluate code architecture — pick a winner

Compare the two implementations **purely on code quality**. Ignore tests, docs, and comments for this decision. Evaluate:

1. **Correctness** — Which implementation is more likely to actually work? Are there logic errors or missed cases?
2. **Architecture** — Which fits better with the existing codebase patterns? Read the surrounding code in `main` to understand conventions.
3. **Robustness** — Which handles edge cases and failure modes better?
4. **Simplicity** — Which is cleaner and easier to understand, with less unnecessary complexity?
5. **Bug risk** — Which is less likely to introduce regressions?

Pick a **WINNER** branch. This is the branch you will check out and build on. Call the other the **DONOR** branch (you'll cherry-pick its best ideas).

Briefly explain your reasoning: why the winner is better, and what (if anything) the donor does better.

## Step 3: Check out the winner branch

```
git checkout -b merged-result origin/WINNER_BRANCH
```

This creates a new local branch based on the winner.

## Step 4: Merge in main and resolve conflicts

```
git merge main
```

If there are merge conflicts:
1. Read each conflicting file
2. Resolve conflicts intelligently — prefer the winner branch's approach but incorporate any main changes that are clearly needed
3. Stage resolved files with `git add`
4. Complete the merge with `git commit --no-edit`

If the merge is clean, move on.

## Step 5: Incorporate the best of the donor branch

Now review the DONOR branch's diff again. Identify anything valuable that the winner branch is missing:

- **Better function implementations** — If the donor has a cleaner or more correct version of a specific function, port it over.
- **Test suites** — If the donor wrote tests and the winner didn't, bring those tests over and adapt them to the winner's code (e.g. update imports, function signatures, expected values).
- **Additional edge case handling** — If the donor handles cases the winner misses, add that handling.
- **Useful helpers or utilities** — If the donor extracted a useful helper function, bring it in.
- **Better naming or API design** — If the donor renamed something more clearly, consider adopting that.

To port changes from the donor, use `git show origin/DONOR_BRANCH:path/to/file` to read the donor's version of files, then manually apply the relevant parts.

**Do NOT blindly merge the donor branch.** Be surgical — only take what's genuinely better.

## Step 6: Holistic review of the merged result

Now review the complete state of your `merged-result` branch:

1. `git diff main --stat` to see all files changed
2. Read through every changed file end-to-end
3. Check for:
   - **Regressions** — Did merging break anything? Are there inconsistencies?
   - **Missed edge cases** — Now that you've seen both approaches, is there something neither branch handled?
   - **Dead code** — Any leftover code from the merge that's no longer needed?
   - **Consistency** — Do naming conventions, patterns, and styles match across all changes?
   - **Import issues** — Are all imports correct after combining code from both branches?

Fix any issues you find.

## Step 7: Verify everything works

Run the appropriate checks based on what files were changed:

**If frontend files changed:**
1. `npm run typecheck`
2. `npm run lint`
3. `npm run test:run`

**If backend files changed:**
1. `cd backend && make check`

Fix any failures and iterate until everything passes.

## Step 8: Format and finalize

Run `make total-format` to format all changed files.

## Output Summary

### Winner: Branch [A/B] (`branch-name`)
**Why:** Brief explanation of why this branch was chosen as the base.

### Incorporated from donor Branch [A/B] (`branch-name`):
- List each thing you brought over and why

### Additional improvements made during review:
- List any extra fixes or improvements you made in Step 6

### Final verification:
- TypeCheck: ✅/❌
- Lint: ✅/❌
- Tests: ✅/❌
- Backend: ✅/❌ (if applicable)

### Next steps:
The merged result is on the local `merged-result` branch. To push it:
```
git push origin merged-result
```
