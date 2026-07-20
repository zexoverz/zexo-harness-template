---
name: deploy
description: "Deploy the current branch to GCP Cloud Run with pre-flight checks. Halts on env-var mismatch, unverified CI, or dirty tree."
---

# /deploy

Deploy to GCP Cloud Run (region `asia-southeast2` Jakarta, matching foru-invest). Pre-flight guards prevent shipping broken builds.

## Instructions

Before deploying:

1. `git status` — must be clean (no uncommitted changes).
2. Current branch's latest commit must be pushed and CI green (`gh run list --branch <branch> --limit 1`).
3. All `.env.example` keys must be present as Cloud Run secrets or env vars for the service:
   ```bash
   gcloud run services describe <service> --region=$GCP_REGION --format='value(spec.template.spec.containers[0].env[].name)'
   ```
4. `bun run verify` must pass locally.
5. `gcloud auth application-default print-access-token` succeeds (user is authenticated).

If any pre-flight fails, STOP and report which check failed. Do NOT deploy.

## Deploy step

```bash
gcloud run deploy <service-name> \
  --source . \
  --region=$GCP_REGION \
  --project=$GCP_PROJECT_ID \
  --allow-unauthenticated \  # remove for internal-only services
  --set-secrets=ANTHROPIC_API_KEY=anthropic-key:latest \
  --min-instances=0 \
  --max-instances=10
```

Confirm with the user before triggering — deploys are visible, hard to reverse. Use the `mcp__gcloud__run_gcloud_command` MCP tool when available; fall back to shell `gcloud` otherwise.

## Post-deploy

- Fetch deploy logs: `gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=<service>" --limit=50 --format=json`
- Run smoke check against the deployed URL — one HTTP request to `/healthz`.
- Update `LOG.md` with: date, commit SHA, service name, deploy URL, any warnings.

## Secrets handling

- **Never** put real secrets in `--set-env-vars`. Use `--set-secrets` referencing Secret Manager entries.
- Create secrets once: `gcloud secrets create <name> --replication-policy=automatic`
- Update secrets: `gcloud secrets versions add <name> --data-file=path/to/value`
- Rotate by creating a new version, then updating the service to reference `:latest`.

## Refuse to deploy if

- Branch is not pushed
- CI is red or pending
- Uncommitted changes exist
- User hasn't explicitly said "deploy" this session (deploy is not an implicit action)
- `.env` contains real secrets that would leak if committed (double-check `.gitignore` is respected)
