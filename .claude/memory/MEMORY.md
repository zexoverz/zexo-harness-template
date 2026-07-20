# Memory index — starter

Cross-session memory. Auto-populated by the harness as you work.

## What goes here

- **User facts** — role, preferences, working style (auto-detected)
- **Feedback** — corrections + confirmations you've given
- **Project facts** — decisions, context, why-not-what
- **References** — links to external systems (Linear, Notion, Jira)

## What does NOT go here

- Code patterns / conventions (grep-derivable)
- Git history (git log is authoritative)
- Debugging fix recipes (commit messages have the context)
- Anything in CLAUDE.md or AGENTS.md
- Ephemeral in-progress state (use TaskCreate for that)

## Rules

- One line per memory in this index — link to detail file
- Detail files use frontmatter with `type: user | feedback | project | reference`
- Index truncates after line 200 — keep entries tight
- Verify facts before recommending — memory is a hypothesis, not truth
- Update or delete stale memories, don't accrete

## Starter entries

- [Rules for adding memories](rules_for_adding_memories.md) — read before writing any new memory entry.

<!-- Add new memories above as: `- [Title](filename.md) — one-line hook` -->
