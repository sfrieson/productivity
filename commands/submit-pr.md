---
description: Review the current branch, generate a PR title and description, and create a GitHub PR
---

Create a well-structured GitHub PR for the current branch.

## Step 1: Gather context

1. Run `git branch --show-current` to get the current branch name.
2. Run `git log main..HEAD --oneline` to see all commits on this branch.
3. Run `git diff main...HEAD --stat` to see the summary of changed files.
4. Run `git diff main...HEAD` to read the full diff. If the diff is very large, use `git diff main...HEAD --name-only` and then read each file's diff individually.

## Step 2: Understand the changes

Read through the diff and understand:
- What feature was built, bug was fixed, or refactor was done
- Which areas of the codebase were touched (frontend, backend, both)
- Whether there are breaking changes, new dependencies, or migration steps needed

## Step 3: Generate PR title and description

**Title format:** A clear, concise summary in imperative mood. Examples:
- `Add company logo fetching for design agent`
- `Fix race condition in canvas selection handler`
- `Refactor scene graph coordinate system`
- `Slim down fetch_company_logo tool output`

**Description format:**

```
## What

One paragraph explaining what this PR does and why.

## Changes

- Bullet point for each meaningful change
- Group by area if touching multiple parts (Frontend, Backend, etc.)
- Don't list every single file — summarize at the right level of abstraction

## Testing

How this was tested (new tests added, manual testing done, etc.)
```

Keep it concise. Don't pad with boilerplate.

## Step 4: Ensure branch is pushed

Run `git push origin HEAD` to make sure the latest commits are on the remote.

## Step 5: Create the PR

Run:
```
gh pr create --base main --title "<TITLE>" --body "<DESCRIPTION>"
```

If the PR was created successfully, show the URL.

If it fails (e.g. branch already has a PR), show the error and suggest alternatives like `gh pr edit`.
