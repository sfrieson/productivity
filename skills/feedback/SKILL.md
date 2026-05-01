---
name: feedback
description: Reflect on the current session to surface friction (failed commands, repeated searches, dead-ends, surprising repo behavior, inefficient workflows) and propose concrete harness improvements — CLAUDE.md additions, new/updated skills, hooks, permission allowlist entries, MCP tools, scripts, or auto-memory entries. Use when the user runs /feedback, asks for a session retro, or asks "what could we improve about how you work".
---

# Feedback

Goal: turn friction observed in *this session* into concrete, actionable harness changes the user can approve.

## Process

### 1. Scan the session for friction signals

Look back across the conversation. Concrete signals to flag:

- **Failed commands** — non-zero exits, "command not found", typecheck/lint errors from wrong invocation, permission prompts that blocked work.
- **Repeated or wide searches** — multiple Grep/Glob/Explore calls hunting for the same symbol, file, or convention. Indicates undocumented structure.
- **Dead-ends and rework** — code written then deleted, wrong approach corrected by user, edits reverted.
- **User corrections** — "no, do X instead", "stop doing Y", "we use npm not bun". Each correction is a candidate for memory or CLAUDE.md.
- **Surprising repo behavior** — server already running, unusual build commands, custom test runners, non-obvious file locations.
- **Tool gaps** — places where a missing script/MCP/CLI forced a clumsy workaround (e.g. shelling out to curl when an MCP would do, hand-writing a query repeatedly).
- **Permission churn** — the same Bash command pattern prompting repeatedly.
- **Context bloat** — large file reads or tool outputs that could have been narrower (a fork, an Explore agent, a more targeted grep).

Skip trivial noise (one typo'd command, normal exploration). Focus on patterns and anything the user explicitly reacted to.

### 2. Categorize each finding into a remediation bucket

For each piece of friction, propose the *cheapest* change that prevents recurrence:

| Bucket | When to use | Where it lives |
|---|---|---|
| **CLAUDE.md (project)** | Repo conventions, tooling commands, "we use X not Y", non-obvious file layout | `<repo>/.claude/CLAUDE.md` |
| **CLAUDE.md (global)** | Cross-project preferences (style, tone, defaults) | `~/.claude/CLAUDE.md` |
| **Auto-memory** | User-specific facts, preferences, validated approaches, prior incidents — things that wouldn't make sense as repo docs | `~/.claude/projects/<proj>/memory/` |
| **Hook** | Automated behavior ("each time X", "before/after Y"). Delegate to the `update-config` skill. | `settings.json` |
| **Permission allowlist** | Recurring read-only Bash/MCP prompts. Delegate to the `fewer-permission-prompts` skill. | `.claude/settings.json` |
| **New/updated skill** | Multi-step workflow that recurred or is likely to recur. Delegate to `skill-creator`. | `~/.claude/skills/` |
| **New script / MCP** | Repeated code rewriting, or capability gap a server would close (figma, context7, devtools, etc.) | skill `scripts/` or MCP install |
| **Tool habit** | No config change — just a reminder for Claude (e.g. "use Explore for surveys"). Worth noting if the user wants the behavior reinforced. | (call out in report) |

### 3. Report

Output a single structured report. Keep it tight — punchy bullets, not paragraphs.

```
## Friction observed
- <one-line description> — <evidence: which turn / what failed>
- ...

## Suggested changes

### CLAUDE.md (project)
- Add: "<exact line>" — addresses <which friction>

### Auto-memory
- New `feedback_<topic>.md`: <rule>. Why: <reason>. Triggered by: <which friction>.

### Hooks (via update-config)
- <event>: <command> — addresses <which friction>

### Permissions (via fewer-permission-prompts)
- Allow `Bash(<pattern>)` — prompted N times this session

### New/updated skill (via skill-creator)
- `<name>`: <one-line purpose>

### MCP / tooling
- Install <server> — would have replaced <clumsy workaround>

## Nothing-to-do notes
- <patterns that looked like friction but are fine as-is>
```

### 4. Offer to apply

End the report with a prompt like: "Want me to apply any of these? Tell me which buckets — hooks/permissions go through their dedicated skills, auto-memory and CLAUDE.md edits I'll do directly."

Do **not** apply changes without explicit approval. Each bucket has a different blast radius (global config, repo-checked-in files, etc.) and the user should pick.

## Calibration

- Be honest. If the session was smooth, say so and produce a short report — don't manufacture findings.
- Distinguish *one-time* friction (a flaky command) from *systemic* friction (a pattern). Only systemic friction warrants a config change.
- Prefer the lightest remediation. A CLAUDE.md line beats a hook; a hook beats a new skill.
- Don't propose changes that duplicate existing CLAUDE.md, memory, or skill content. Check first.
- Memory entries must follow the auto-memory rules in the system prompt (frontmatter, MEMORY.md index entry, why/how-to-apply for feedback type).
