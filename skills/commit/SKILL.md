---
name: commit
description: Stage changed files and create a well-formatted git commit. Use when the user says "commit", "/commit", wants to commit current changes, or asks to create a git commit.
model: haiku
---

# Commit

## Step 1: Gather context

Run the context script first — it prints status, recent commits, and any staged/unstaged diffs:

```bash
python3 /Users/steven.null/.claude/skills/commit/scripts/gather-context.py
```

## Step 2: Stage files

Use `git add <file> ...` targeting specific changed files.
Never use `git add -A` or stage `.env`, credentials, or unrelated files.

## Step 3: Compose the commit message

- **Subject** (line 1): ≤50 characters, imperative mood, no trailing period
  - `fix stale thumbnail after first save` ✓
  - `Fixed the thumbnail generation bug in useAutoSave.ts` ✗
- **Blank line** (line 2): required when a body follows
- **Body** (line 3+): wrap at 72 chars, explain *what* and *why* — omit if subject is self-explanatory

## Step 4: Commit

Use a HEREDOC to avoid quoting issues:

```bash
git commit -m "$(cat <<'EOF'
Subject line here

Optional body explaining motivation or non-obvious decisions.
EOF
)"
```

## Rules

- Never skip hooks (`--no-verify`) or bypass signing unless explicitly asked
- Never amend a published commit unless asked
- If a pre-commit hook fails, fix the issue and create a NEW commit — do not `--amend`
