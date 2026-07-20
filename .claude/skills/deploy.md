---
name: deploy
description: "Deploy the current branch to Railway (default) with pre-flight checks. Halts on env-var mismatch, unverified CI, or dirty tree."
---

# /deploy

Deploy to Railway. Pre-flight guards prevent shipping broken builds.

## Instructions

Before deploying:

1. `git status` — must be clean (no uncommitted changes).
2. Current branch's latest commit must be pushed and CI green (`gh run list --branch <branch> --limit 1`).
3. `.env.example` keys must all be present in the Railway environment — call the Railway MCP `get-service-variables` (or `railway variables --json`) and diff.
4. `bun run verify` must pass locally.

If any pre-flight fails, STOP and report which check failed. Do NOT deploy.

## Deploy step

Use the Railway MCP (`railway-agent` tool is most capable) or `railway up` CLI. Confirm with the user before triggering — deploys are visible, hard to reverse.

## Post-deploy

- Fetch deploy logs (`get-logs` MCP) — first 60s. If startup errors appear, flag them.
- Run smoke check against the deployed URL — one HTTP request to `/healthz`.
- Update `LOG.md` with: date, commit SHA, service name, deploy URL, any warnings.

## Refuse to deploy if

- Branch is not pushed
- CI is red or pending
- Uncommitted changes exist
- User hasn't explicitly said "deploy" this session (deploy is not an implicit action)
