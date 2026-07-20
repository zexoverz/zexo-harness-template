---
name: deploy
description: "Deploy the current branch to the configured cloud (GCP Cloud Run / Vercel / Fly.io — auto-detected from .env). Pre-flight checks. Refuses on dirty tree, unverified CI, or missing env vars."
---

# /deploy

Deploy to whichever cloud is configured in `.env`. Pre-flight guards prevent shipping broken builds.

## Instructions

1. **Detect target.** In order:
   - `GCP_PROJECT_ID` set → GCP Cloud Run
   - `VERCEL_TOKEN` set → Vercel
   - `FLY_API_TOKEN` set → Fly.io
   - None → STOP + tell user to configure one target in `.env`.

2. **Pre-flight (all targets):**
   - `git status` — clean (no uncommitted changes)
   - Latest commit pushed and CI green (`gh run list --branch <branch> --limit 1`)
   - All `.env.example` keys present in the deploy target's env / secrets
   - `bun run verify` passes locally

If any check fails, STOP and report which. Do NOT deploy.

## GCP Cloud Run

```bash
gcloud run deploy <service> \
  --source . \
  --region=$GCP_REGION \
  --project=$GCP_PROJECT_ID \
  --allow-unauthenticated \
  --set-secrets=ANTHROPIC_API_KEY=anthropic-key:latest \
  --min-instances=0 \
  --max-instances=10
```

- **Never** use `--set-env-vars` for real secrets. Use `--set-secrets` referencing Secret Manager.
- Create secrets once: `gcloud secrets create <name> --replication-policy=automatic`
- Rotate: `gcloud secrets versions add <name> --data-file=path/to/value`

## Vercel

```bash
vercel --prod --token=$VERCEL_TOKEN
```

Env vars via Vercel dashboard or `vercel env pull`.

## Fly.io

```bash
fly deploy --strategy immediate
```

Secrets via `fly secrets set KEY=value`.

## Post-deploy (all targets)

1. Fetch first 60s of logs. Flag startup errors.
2. Smoke check the deployed URL: one HTTP GET to `/healthz`. Expect 200.
3. Update `LOG.md`: date, commit SHA, service, deploy URL, warnings.

## Refuse to deploy if

- Branch is not pushed
- CI is red or pending
- Uncommitted changes exist
- User hasn't explicitly said "deploy" this session
- `.env` contains real secrets that would leak (double-check `.gitignore`)

## Cost estimate

- GCP Cloud Run: source deploys ~90s, ~$0 (free tier)
- Vercel: ~30s, ~$0 (hobby)
- Fly.io: ~45s, ~$0 (free tier)
