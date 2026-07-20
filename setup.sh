#!/usr/bin/env bash
# =====================================================
# foru-harness-template — bootstrap script
# One-command environment check + setup for team members.
# =====================================================

set -euo pipefail

# Colors
r=$'\033[31m'; g=$'\033[32m'; y=$'\033[33m'; b=$'\033[34m'; d=$'\033[0m'
ok()   { echo "${g}✓${d} $1"; }
warn() { echo "${y}⚠${d} $1"; }
err()  { echo "${r}✗${d} $1"; exit 1; }
info() { echo "${b}→${d} $1"; }

echo ""
info "foru-harness-template setup"
echo ""

# ------------------------------------------------------
# 1. Bun
# ------------------------------------------------------
if command -v bun >/dev/null 2>&1; then
  ok "bun $(bun --version)"
else
  warn "bun not found — installing..."
  curl -fsSL https://bun.sh/install | bash
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
  ok "bun installed"
fi

# ------------------------------------------------------
# 2. RTK (Rust Token Killer)
# ------------------------------------------------------
if command -v rtk >/dev/null 2>&1; then
  # Verify it's the right RTK (not reachingforthejack/rtk name collision)
  if rtk gain --help >/dev/null 2>&1; then
    ok "rtk $(rtk --version 2>&1 | head -1)"
  else
    warn "wrong 'rtk' binary in PATH — expected rtk-ai/rtk, got something else"
    warn "  → uninstall the other 'rtk', then reinstall from https://github.com/rtk-ai/rtk"
  fi
else
  warn "rtk not found — installing from https://github.com/rtk-ai/rtk"
  # RTK installer (adjust if the canonical install method changes)
  if command -v cargo >/dev/null 2>&1; then
    cargo install rtk-cli || err "cargo install rtk-cli failed"
    ok "rtk installed via cargo"
  else
    err "rtk requires cargo (Rust). Install Rust first: https://rustup.rs"
  fi
fi

# ------------------------------------------------------
# 3. GitHub CLI
# ------------------------------------------------------
if command -v gh >/dev/null 2>&1; then
  if gh auth status >/dev/null 2>&1; then
    login=$(gh api /user --jq .login)
    ok "gh authenticated as ${login}"
    # Check Foru-Engineering org membership
    if gh api /orgs/Foru-Engineering/members/${login} >/dev/null 2>&1; then
      ok "  member of Foru-Engineering ✓"
    else
      warn "  not a member of Foru-Engineering — ask Faisal to invite you"
    fi
  else
    warn "gh installed but not authenticated — run: gh auth login"
  fi
else
  warn "gh not found — install: brew install gh (macOS) or https://cli.github.com"
fi

# ------------------------------------------------------
# 4. gcloud CLI (GCP deploy target)
# ------------------------------------------------------
if command -v gcloud >/dev/null 2>&1; then
  if gcloud auth application-default print-access-token >/dev/null 2>&1; then
    ok "gcloud authenticated (ADC)"
  else
    warn "gcloud installed but no application-default creds — run: gcloud auth application-default login"
  fi
else
  warn "gcloud not found — install: brew install --cask google-cloud-sdk (macOS) or https://cloud.google.com/sdk/docs/install"
fi

# ------------------------------------------------------
# 5. ECC (Everything Claude Code) rules
# ------------------------------------------------------
if [[ -d "${HOME}/.claude/rules/ecc" ]]; then
  ok "ECC rules present at ~/.claude/rules/ecc/"
else
  warn "ECC rules not found at ~/.claude/rules/ecc/"
  warn "  ask Faisal for the ECC bundle, then extract to ~/.claude/rules/ecc/"
fi

# ------------------------------------------------------
# 5. .env
# ------------------------------------------------------
if [[ ! -f .env ]]; then
  cp .env.example .env
  ok "created .env from .env.example — fill in real keys before running"
else
  ok ".env exists"
fi

# ------------------------------------------------------
# 6. Post-edit hook
# ------------------------------------------------------
if [[ -f .claude/hooks/post-edit-lint.sh ]]; then
  chmod +x .claude/hooks/post-edit-lint.sh
  ok "post-edit hook executable"
fi

# ------------------------------------------------------
# 7. Bun install (if package.json exists)
# ------------------------------------------------------
if [[ -f package.json ]]; then
  info "running bun install..."
  bun install
  ok "dependencies installed"
else
  warn "no package.json yet — run 'bun init' when ready to start coding"
fi

echo ""
ok "setup complete"
echo ""
info "next steps:"
echo "  1. fill in .env"
echo "  2. read README.md + docs/ONBOARDING.md"
echo "  3. open Claude Code: claude"
echo "  4. try: /work-on \"your first task\""
echo ""
