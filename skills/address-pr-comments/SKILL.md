---
description: Find the GitHub PR for this branch, review all comments, and address valid ones. Also fix failing tests/lint/typecheck.
---

Address all open PR review comments and fix CI failures for the current branch.

## Step 1: Find the PR

Run `gh pr view --json number,title,url,state,reviewDecision,statusCheckRollup` to find the PR associated with the current branch. If no PR exists, stop and tell the user.

## Step 2: Gather PR comments

Run ALL of these commands to get the full picture:

1. **Review comments (inline code comments):**
   `gh pr view --json reviews --jq '.reviews[] | {author: .author.login, state: .state, body: .body}'`

2. **Review thread comments (line-level discussions):**
   `gh api repos/{owner}/{repo}/pulls/{number}/comments --jq '.[] | {id: .id, path: .path, line: .line, body: .body, author: .user.login, in_reply_to_id: .in_reply_to_id}'`
   (Get owner/repo from `gh repo view --json owner,name`)

3. **Top-level PR conversation comments:**
   `gh pr view --json comments --jq '.comments[] | {author: .author.login, body: .body}'`

## Step 3: Analyze each comment

For each comment/review thread:

1. **Read the referenced file and surrounding code** to understand the context
2. **Determine if the comment is actionable** — is it requesting a code change, asking a question, or just an approval/acknowledgment?
3. **Classify it:**
   - ✅ **Valid & actionable** — The comment identifies a real issue or improvement. Address it.
   - ❓ **Question/clarification** — Note it but don't change code. Suggest a response.
   - 👍 **Already addressed / not applicable** — Explain why no change is needed.
   - ❌ **Disagree** — Explain your reasoning for why the current code is correct.

## Step 4: Address valid comments

For each valid & actionable comment:
1. Make the code change
2. Briefly note what you changed and why

**Do NOT over-engineer.** Make the minimal change that addresses the feedback.

## Step 5: Fix CI failures

After addressing comments, run the following and fix any failures:

1. `npm run typecheck` — Fix type errors
2. `npm run lint` — Fix lint issues (try `npm run lint -- --fix` first)
3. `npm run test:run` — Fix failing tests
4. `cd backend && make check` — Fix backend lint/type/test issues (if backend files were changed)

Iterate until everything passes.

## Step 6: Format

Run `make total-format` to format all changed files.

## Output Summary

End with a summary:

### Comments Addressed
| # | File | Comment | Action Taken |
|---|------|---------|-------------|
| 1 | `path/to/file` | Summary of comment | What you did |

### Comments Not Addressed
| # | File | Comment | Reason |
|---|------|---------|--------|
| 1 | `path/to/file` | Summary of comment | Why no change needed |

### CI Status
- TypeCheck: ✅/❌
- Lint: ✅/❌
- Tests: ✅/❌
- Backend: ✅/❌ (if applicable)
