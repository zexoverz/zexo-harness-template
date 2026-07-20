# zexo-harness-template

**A best-in-world personal harness for Claude Code development.** Fork it, run one command, and get a battle-tested `.claude/` setup — subagents, slash commands, MCP servers, hooks, memory scaffolding, code-review gates, and CI — all pre-wired.

Built + maintained by [@zexoverz](https://github.com/zexoverz). Free to use, fork, and adapt.

---

## Why

Every new repo eats the same setup dance — draft a CLAUDE.md, pick subagents, remember which hooks catch which bugs, wire MCP servers, argue about lint, forget to install RTK. That dance eats 2–4 hours per repo. For a team, it multiplies.

This template collapses the dance into `./setup.sh`. Every repo starts from the same battle-tested baseline. Improvements to the baseline flow back here.

## What's inside

| Layer                 | Contents                                                                                            |
| --------------------- | --------------------------------------------------------------------------------------------------- |
| **6 subagents**       | `planner` · `code-reviewer` · `security-reviewer` · `tdd-guide` · `critic` (adversarial) · `build-error-resolver` |
| **9 slash commands**  | `/work-on` · `/ship` · `/review` · `/verify-adversarial` · `/loop` · `/swarm` · `/deploy` · `/adr` · `/prune-claude-md` |
| **Hooks**             | RTK PreToolUse (60–90% token savings) · PostToolUse lint on Edit/Write · Stop-hook `bun run verify` · Notification hook (Slack/push on `agent_completed`) |
| **MCP servers**       | Context7 (fresh docs), GitHub, Playwright, Chrome DevTools (2026 hit — live browser control) — via `.mcp.json`, auto-loaded |
| **Cross-tool rules**  | `AGENTS.md` for Cursor / Cline / Windsurf compat                                                    |
| **Memory scaffold**   | `.claude/memory/MEMORY.md` — auto-memory index seeded ready                                         |
| **Session-start doc** | `CLAUDE.md` — the file Claude reads before every turn                                               |
| **Onboarding**        | `docs/ONBOARDING.md` — first-hour walkthrough                                                       |
| **Recipes**           | `docs/AGENT-RECIPES.md` — 10 copy-paste prompts for common moves                                    |
| **ADR template**      | `docs/ADR/` with template + numbering convention                                                    |
| **CI**                | GitHub Actions running `bun run verify` on every PR                                                 |
| **Plugin bundle**     | `.claude-plugin/plugin.json` + `.claude-plugin/marketplace.json` — installable via `/plugin install` |

## Quickstart

### Option A — GitHub template (recommended)

```bash
gh repo create <owner>/<my-new-project> --template zexoverz/zexo-harness-template --private
cd <my-new-project>
./setup.sh
```

### Option B — direct clone

```bash
git clone https://github.com/zexoverz/zexo-harness-template.git my-new-project
cd my-new-project
rm -rf .git && git init -b main
./setup.sh
```

### Option C — install as a plugin (into any repo)

```bash
# Inside Claude Code, once registered as a marketplace
/plugin install zexo-harness@zexoverz/zexo-harness-template
```

`setup.sh` verifies:

- **Bun** installed (installs if missing)
- **RTK** installed from https://github.com/rtk-ai/rtk
- **gh** authenticated
- **gcloud** installed (only if you'll deploy to GCP)
- **ECC rules** present at `~/.claude/rules/ecc/`
- **`.env`** created from `.env.example`

## The 6 subagents

| Subagent               | When to invoke                                                              |
| ---------------------- | --------------------------------------------------------------------------- |
| `planner`              | Before any non-trivial feature. No code without a plan.                     |
| `tdd-guide`            | While implementing. Enforces test-first, 80% coverage.                      |
| `code-reviewer`        | After writing code. Quality, style, error handling, immutability.           |
| `security-reviewer`    | Touching auth / input / DB / secrets / crypto. OWASP-focused.               |
| `critic` (**new**)     | Adversarial reviewer. Reads spec + diff, tries to find why it's wrong. Cheapest quality jump for compliance-critical code. |
| `build-error-resolver` | CI or `bun run verify` failing. Reads error output, applies minimal fix. Never disables the check. |

## The 9 slash commands

| Command                | Purpose                                                                              |
| ---------------------- | ------------------------------------------------------------------------------------ |
| `/work-on <task>`      | Full feature pipeline: plan → TDD → parallel review → ready to ship                  |
| `/ship`                | Verify + commit + push + PR                                                          |
| `/review`              | Parallel `code-reviewer` + `security-reviewer` over current diff                     |
| `/verify-adversarial`  | Builder/critic separation — fresh session verifies the diff against the spec         |
| `/loop`                | Ralph loop — burn down a backlog file until DONE criteria hit                        |
| `/swarm`               | Fan out N independent tasks to worktree-isolated subagents in parallel               |
| `/deploy`              | Pre-flight checks + deploy to configured cloud (GCP / Vercel / Fly)                  |
| `/adr <topic>`         | Scaffold new Architectural Decision Record                                           |
| `/prune-claude-md`     | Enforce 200-line CLAUDE.md ceiling — move enforceable rules to hooks                 |

## What makes this best-in-world (mid-2026)

Grounded in field research (see [`docs/RESEARCH-NOTES.md`](./docs/RESEARCH-NOTES.md) for citations):

1. **Plugin-format distribution** — the 2026 standard, installable via one command.
2. **Builder/critic separation** — a fresh-context adversary catches what the builder rationalized past.
3. **Ralph-loop native support** — long-running verifiable backlogs burn down autonomously against `bun run verify`.
4. **Worktree-parallel swarms** — N independent tasks run in isolated worktrees, each opens a draft PR.
5. **Notification hooks wired** — background agents ping you when they finish. No more polling.
6. **Sandbox-credentials hardening** — free security default that most templates skip.
7. **Subdirectory CLAUDE.md convention** — scoped guidance beats a monolithic 500-line CLAUDE.md.
8. **RTK + minimal MCP** — 60-90% token compression, 3-4 servers not 15. The field converged on "less is more."
9. **Cross-tool AGENTS.md** — same rules whether you use Claude Code, Cursor, Cline, or Windsurf.
10. **ECC upstream** — inherits [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) v2, selectively.

## Not for you if

- You want a kitchen-sink 100+ subagent zoo (fights context, hurts more than helps)
- You dislike opinionated defaults (this is opinionated — Bun, oxlint/oxfmt, Drizzle, TDD-first)
- You need a language other than TypeScript out of the box (adapt `setup.sh` — everything else is language-agnostic)

## Contributing

Learned something during a project that would help future projects? Open a PR. Improvements compound.

**Bug reports and feature ideas:** [GitHub Issues](https://github.com/zexoverz/zexo-harness-template/issues)

## Credits

- **[Everything Claude Code](https://github.com/affaan-m/everything-claude-code)** — the rules foundation
- **[Rust Token Killer](https://github.com/rtk-ai/rtk)** — the token compression that makes this affordable
- **[Anthropic Claude Code](https://code.claude.com/)** — the harness this is built for
- **[obra/superpowers](https://github.com/obra/superpowers)** — skills-as-methodology inspiration
- **[ChromeDevTools/chrome-devtools-mcp](https://github.com/ChromeDevTools/chrome-devtools-mcp)** — the MCP that fixed frontend agent blindness

## License

MIT. Use it, fork it, adapt it. Credit appreciated but not required.
