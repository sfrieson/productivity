---
name: refinement
description: "Refine a beads (br) ticket via in-depth interview so it's ready to be worked on. Pulls the ticket's current state with `br show --json`, asks targeted questions to flesh out scope, design, acceptance criteria, and edge cases, then writes the refined content back to the ticket. Use when the user runs /refinement <ticket_id> or asks to refine, groom, flesh out, or sharpen a ticket."
argument-hint: "<ticket_id>"
allowed-tools: Bash, AskUserQuestion, Read
---

# Refinement

Take a beads ticket from "rough idea" to "ready to be worked on" by interviewing the user about what's missing, then writing the answers back to the ticket.

## Inputs

`$ARGUMENTS` is the ticket id (e.g. `bd-105`, `bd-3va`). If empty, ask the user for one before continuing.

## Workflow

### 1. Load the ticket

```bash
br show <ticket_id> --json
```

Read every field that's present: `title`, `description`, `design`, `acceptance_criteria`, `notes`, `priority`, `type`, `labels`, `parent`, dependencies, comments. Also run `br dep tree <ticket_id>` if there are blockers/parents to understand context.

If the ticket has a parent, briefly `br show <parent_id> --json` to understand the larger goal — don't refine in a vacuum.

### 2. Diagnose what's missing

Before asking anything, silently assess the ticket against this rubric. A ticket is "ready" when all of these are clear:

- **Problem / motivation** — *why* are we doing this? What user pain or business goal?
- **Scope** — what's in, what's explicitly out
- **Design / approach** — at least one concrete approach, key files/systems touched, data model changes
- **Acceptance criteria** — observable, testable conditions for "done"
- **Edge cases & failure modes** — empty states, errors, concurrency, permissions
- **UX details** (if user-facing) — copy, states (loading/empty/error), responsive/mobile, a11y
- **Dependencies / unknowns** — what blocks this, what we'd need to learn first
- **Test plan** — how we'll verify it works

Identify the 2–4 weakest areas. Don't ask about things already well-specified.

### 3. Interview

Use `AskUserQuestion` to ask **targeted, non-obvious questions** about the weak areas. Guidelines:

- Ask in batches of 2–4 at a time, not one giant question.
- Skip the obvious. If the title says "add dark mode toggle," don't ask "what does this do?" — ask about persistence, system preference, flash-of-wrong-theme, scope of components.
- Surface tradeoffs explicitly. Offer options with implications, not open-ended "what do you want?" prompts.
- Probe edge cases the user likely hasn't thought of yet.
- Keep iterating: each round of answers should reveal the next thing to clarify. Continue until the ticket meets the rubric or the user signals "good enough."

After each answer, briefly restate what you learned and either ask the next round or move on.

### 4. Confirm and write back

Synthesize the conversation into structured updates. Show the user the proposed updates in plain markdown **before** writing — they should be able to redirect.

Then update the ticket using the commands below. Multiline strings work fine inside double quotes; use `$'...\n...'` if you need literal newlines from a shell perspective.

## Beads update reference (embedded — don't load the beads skill)

All commands operate on a single ticket id. Project issue prefix is `bd`.

### Update fields

```bash
# Each flag is independent — set only what you need.
br update <id> --title "New title"
br update <id> --description "Refined problem + scope (markdown ok)"
br update <id> --design "Approach, files touched, data model"
br update <id> --acceptance-criteria "- [ ] criterion 1
- [ ] criterion 2"
br update <id> --notes "Open questions, links, follow-ups"

# Metadata
br update <id> -p 2                 # priority: 0–4 or P0–P4
br update <id> -t feature           # type: epic|task|bug|feature|chore
br update <id> -s open              # status: open|in_progress|closed|deferred
br update <id> --estimate "2d"
br update <id> --due 2026-05-15

# Labels
br update <id> --add-label frontend,needs-design
br update <id> --remove-label stale
br update <id> --set-labels frontend,ux    # replaces all labels

# Parent / hierarchy
br update <id> --parent bd-100      # set parent (epic)
br update <id> --parent ""          # clear parent
```

### Dependencies

```bash
br dep add <id> <blocker_id>        # <id> is blocked by <blocker_id>
br dep remove <id> <blocker_id>
br dep list <id>                    # what blocks this
br dep tree <id>                    # full tree
```

### Comments (audit trail for the refinement)

```bash
br comments add <id> "Refined via /refinement: clarified scope to exclude mobile, added a11y criteria"
br comments <id>                    # list comments
```

### Verify

After writing, re-run `br show <id> --json` and confirm the new fields look right. Report a short summary of what changed.

## Style

- Don't pad the ticket with filler. Terse, concrete bullets beat prose.
- Preserve the user's wording where it's already good — only rewrite what was vague.
- If a user answer contradicts something already on the ticket, flag the conflict and ask which to keep before overwriting.
- Acceptance criteria should be checkbox-style and observable from the outside (behavior, not implementation).
