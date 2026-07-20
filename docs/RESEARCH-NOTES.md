# Research notes — why this harness looks like this

Field research (as of mid-2026) grounding the design choices in `zexo-harness-template`. Each choice cites the source.

## What's new in Claude Code since early 2026

From the [official changelog](https://code.claude.com/docs/en/changelog):

- **Plugins are the distribution unit.** A plugin = versioned bundle of skills / agents / commands / hooks / MCP configs, installable via `/plugin install`. The [official marketplace](https://github.com/anthropics/claude-plugins-official) has ~101 plugins.
- **Subagent primitives leveled up:** nested subagents (5 deep, v2.1.172), background-by-default (v2.1.198), implicit agent teams via `name` param (v2.1.178), `isolation: 'worktree'` (v2.1.212+).
- **New hooks:** `Notification` hook (`agent_needs_input` / `agent_completed`), `PostSession` lifecycle hook, hooks can invoke MCP tools directly (`type: "mcp_tool"`), parameterized matchers.
- **Session management:** `/fork` into background sessions, `/resume`, `/rewind` past `/clear`, searchable `claude agents` dashboard.
- **MCP context fix:** deferred tool schemas via ToolSearch cut MCP context bloat ~47% (51K → 8.5K tokens).
- **Sandbox hardening:** `sandbox.credentials` blocks sandboxed commands from reading secrets.
- **Ralph loop native:** `/loop`, `/goal`, `/batch` now supported.

## Top templates people are actually using

1. **[affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code)** (~163K stars) — the ECC upstream. v2.0.0 (June 2026) added an instincts system, AgentShield security, manifest-driven selective install.
2. **[obra/superpowers](https://github.com/obra/superpowers)** — skills-as-methodology. Composable skills enforcing brainstorm → plan → TDD → worktree → review → finish.
3. **[hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code)** — the canonical curated index.
4. **[VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents)** — 154+ subagents. Mine as reference, don't bulk-import.
5. **[anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official)** — plugin structure to study.

## MCP servers this harness adopts

- **Context7** — fresh library docs. Kills training-data hallucinations for API calls.
- **GitHub MCP** — PR / issue automation in-flow.
- **Playwright MCP** — E2E test scaffolding + UI verification.
- **Chrome DevTools MCP** — live browser control, performance traces, network inspection. Fixes "agent programs with a blindfold on" for frontend debugging. [Repo](https://github.com/ChromeDevTools/chrome-devtools-mcp) · [Chrome blog](https://developer.chrome.com/blog/chrome-devtools-mcp).

**Counter-trend to respect:** the field is *removing* MCP servers in favor of CLIs — [~40% token savings reported](https://docs.bswen.com/blog/2026-04-03-token-usage-cli-optimization/). Keep 3-6 servers max. RTK already embodies this thesis.

## Emerging quality patterns adopted

- **Ralph loop / loop-until-done** — wins on well-specified, verifiable backlogs. Fresh context each iteration, progress lives in files + git. Now native (`/loop`). Prereq: machine-checkable DONE (our `bun run verify` Stop hook is exactly this).
- **Builder / critic separation (adversarial code review)** — a *separate session* reviews the diff against the spec, breaking the self-validation echo chamber. [ASDLC pattern](https://asdlc.io/patterns/adversarial-code-review/). Wins on compliance / security / payment code.
- **Council over cage-match** — [council-review](https://github.com/ngmeyer/council-review) cites M3MADBench 2026: collaborative multi-advisor + anonymous peer review + chairman synthesis outperforms pure adversarial debate. Use council for decisions/plans, a single critic for diffs.
- **Subagents as context firewalls** — the deeper use isn't role division; it's spawning a fresh-context agent to Grep/Read and return a summary so raw output never pollutes the main window.
- **Judge-panel caveat:** LLM judgments show [weak alignment with formal verification](https://arxiv.org/pdf/2606.06523) on ambiguous SWE tasks. Councils advise; executable checks decide.

## Anti-patterns explicitly avoided

- **CLAUDE.md bloat** — past ~200 lines, instructions dilute each other. Rule: "twice = pattern, once = noise"; convert enforceable rules into hooks; push scoped guidance into subdirectory CLAUDE.md files. [Deep dive](https://redreamality.com/blog/claude-md-agents-md-deep-dive/) · [Anti-patterns](https://www.aicodex.to/articles/claude-code-antipatterns).
- **Subagent zoos** — most effective repos define 1-2 subagents. 135-agent packs are catalogs, not harnesses. Our 6 is near the sweet spot.
- **MCP maximalism** — every idle server taxes every prompt.
- **Rule-per-error accretion** — committing a CLAUDE.md rule on every mistake collapses signal-to-noise.
- **Trusting LLM judges as gates** — panels for perspective, hooks + tests for verdicts.
- **Wholesale toolkit installs** — even ECC upstream moved to manifest-driven selective install.

## Design decisions specific to this template

| Choice                                   | Rationale                                                                                       |
| ---------------------------------------- | ----------------------------------------------------------------------------------------------- |
| **6 subagents, not 50+**                 | Sweet spot per field research. Add more only when a specific pattern demands it.                |
| **Plugin bundle format**                 | 2026 distribution standard. One `/plugin install` command.                                      |
| **`critic` + `/verify-adversarial`**     | Cheapest quality jump for compliance-critical code. Bypasses self-validation.                   |
| **Ralph loop as first-class skill**      | Long-running backlogs burn down against `bun run verify` overnight.                             |
| **Worktree swarms**                      | Parallel independent tasks without conflicts. Each opens a draft PR.                            |
| **Notification hooks**                   | Background subagents need to ping when done. No polling.                                        |
| **`sandbox.credentials`**                | Free security hardening most templates skip.                                                    |
| **RTK PreToolUse**                       | 60-90% Bash-output compression. Ahead of the "CLI over MCP" curve.                              |
| **`bun run verify` Stop hook**           | Deterministic gate at session end. Catches what per-file linting misses.                        |
| **AGENTS.md as first-class citizen**     | Same rules across Claude Code / Cursor / Cline / Windsurf.                                      |
| **ECC inheritance, selective**           | Take the rules, skip the 300-agent zoo.                                                         |
| **Chrome DevTools MCP over Playwright** (for debugging) | Live browser inspection > screenshot-driven guessing. Playwright stays for E2E.       |

## Verdict on baseline choices retained from earlier templates

The RTK + minimal-MCP + hook-trio approach was already ahead of the curve — the community spent 2026 rediscovering "CLI output compression > MCP maximalism." Keep it.

Biggest gaps this template fills vs. an earlier baseline:

1. **Distribution as a plugin** — was unpublishable format before.
2. **Adversarial verification** — everything else was generation-side.
3. **Learning loop** — memory is manual; instincts / evolve patterns automate.
4. **Exploiting background / worktree / team primitives** — turns Claude Code from pair-programmer into fleet manager.

## Where the template deliberately doesn't go

- **AgentShield-style security auditing** — install separately from ECC v2 if needed. Not baked in because most projects don't need it, and the ones that do want to tune it.
- **Continuous-learning `/instinct-*` skills** — ECC v2 has these. Not copied here because they overlap with memory + they need adjustment per project. Install manually from ECC upstream when you want them.
- **100+ subagent zoo** — deliberately capped at 6. Add project-specific ones inside your project's `.claude/agents/`, not the template.
- **Language-specific agents** (Rust reviewer, Go reviewer, etc.) — ECC has these under `~/.claude/rules/ecc/<language>/`. Include as needed per project.

## Sources cited above

- Claude Code changelog: https://code.claude.com/docs/en/changelog
- ECC: https://github.com/affaan-m/everything-claude-code
- Superpowers: https://github.com/obra/superpowers
- Awesome Claude Code: https://github.com/hesreallyhim/awesome-claude-code
- Chrome DevTools MCP: https://github.com/ChromeDevTools/chrome-devtools-mcp
- ASDLC adversarial pattern: https://asdlc.io/patterns/adversarial-code-review/
- Council review: https://github.com/ngmeyer/council-review
- CLAUDE.md deep dive: https://redreamality.com/blog/claude-md-agents-md-deep-dive/
- Anti-patterns: https://www.aicodex.to/articles/claude-code-antipatterns
- RTK: https://github.com/rtk-ai/rtk
- Token-usage CLI optimization: https://docs.bswen.com/blog/2026-04-03-token-usage-cli-optimization/
- Ralph Wiggum loop origin: https://linearb.io/dev-interrupted/podcast/inventing-the-ralph-wiggum-loop
- Ralph loop case study: https://amplitude.com/blog/ralph-loop
- Awesome Claude AI (Ralph loop reference): https://awesomeclaude.ai/ralph-wiggum
- LLM judge alignment: https://arxiv.org/pdf/2606.06523
