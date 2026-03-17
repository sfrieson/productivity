---
name: beads
description: "Load beads (br) issue tracker reference. Use when working with tickets, issues, epics, dependencies, or project planning. Covers important br CLI commands, workflows, and this project's conventions."
argument-hint: '[command or topic]'
---

# Beads Issue Tracker (`br`) — Quick Reference

`br` (beads_rust) is the project's issue tracker. Issues live in `.beads/beads.db` (SQLite) with a JSONL export at `.beads/issues.jsonl` for git-friendly diffing.

## Project conventions

- **Issue prefix**: `mall` (e.g., `mall-105`, `mall-3va`)
- **Issue types**: `epic` or `task`
- **Statuses**: `open` → `in_progress` → `closed` (also `deferred`)
- **Epics** have child tasks via parent-child dependencies
- **No auth** — single user, no assignee conventions needed

## Everyday commands

```bash
# See what's ready to work on (unblocked + not deferred)
br ready

# List all open issues (-a to include closed)
br list

# List open epics
br list -t epic

# Show full details for an issue, TOON (token-optimized, good for LLM context)
br show mall-105 --format toon

# JSON (for piping/scripting)
br list --json
br show mall-105 --json

# Search issues by keyword
br search "research agent"

# Quick capture a new task (just prints the ID)
br q Fix the broken login button

# Create with full details
br create "Add dark mode toggle" -t task -p 2 -d "Description here" --parent mall-105

# Close a ticket
br close mall-105 -r "Completed in commit abc123"

# Close and see what's unblocked next
br close mall-105 --suggest-next

# Claim a task (sets assignee + status=in_progress atomically)
br update mall-105 --claim
```

## Dependencies

```bash
# Add: mall-105 depends on (is blocked by) mall-100
br dep add mall-105 mall-100

# Remove a dependency
br dep remove mall-105 mall-100

# List what blocks an issue
br dep list mall-105

# Show full dependency tree
br dep tree mall-105
```

Dependency types: `blocks` (default), `parent-child`, `conditional-blocks`, `waits-for`.

## Epics

```bash
# See progress across all epics
br epic status

# Auto-close epics where all children are done
br epic close-eligible

# List children of an epic (-r for recursive)
br ready --parent mall-105
```

## Labels & comments

```bash
# Add labels
br label add mall-105 frontend,urgent

# See all labels in use
br label list-all

# Add a comment
br comments add mall-105 "Started working on this, blocked by API changes"

# List comments
br comments mall-105
```

## Other useful commands

```bash
br create -f issues.md   # Create multiple issues from a markdown file
br blocked               # All blocked issues
br changelog             # Generate changelog from closed issues
br --help                # Learn about commands
br q                     # fastest way to capture — just type the title words after it
```

$ARGUMENTS
