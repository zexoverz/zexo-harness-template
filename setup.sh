#!/usr/bin/env bash
# =====================================================
# zexo-harness-template — bootstrap script
# One-command environment check + setup.
# =====================================================

set -euo pipefail

r=$'\033[31m'; g=$'\033[32m'; y=$'\033[33m'; b=$'\033[34m'; d=$'\033[0m'
ok()   { echo "${g}✓${d} $1"; }
warn() { echo "${y}⚠${d} $1"; }
err()  { echo "${r}✗${d} $1"; exit 1; }
info() { echo "${b}→${d} $1"; }

echo ""
info "zexo-harness-template setup"
echo ""

# ------------------------------------------------------
# Bun
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
# RTK (Rust Token Killer) — https://github.com/rtk-ai/rtk
# ------------------------------------------------------
if command -v rtk >/dev/null 2>&1; then
  if rtk gain --help >/dev/null 2>&1; then
    ok "rtk $(rtk --version 2>&1 | head -1)"
  else
    warn "wrong 'rtk' binary in PATH — expected rtk-ai/rtk"
    warn "  → uninstall the other 'rtk', reinstall from https://github.com/rtk-ai/rtk"
  fi
else
  warn "rtk not found — see install instructions at https://github.com/rtk-ai/rtk"
  if command -v cargo >/dev/null 2>&1; then
    info "  cargo detected — try: cargo install rtk-cli"
  else
    info "  cargo required — install Rust first: https://rustup.rs"
  fi
fi

# ------------------------------------------------------
# GitHub CLI
# ------------------------------------------------------
if command -v gh >/dev/null 2>&1; then
  if gh auth status >/dev/null 2>&1; then
    login=$(gh api /user --jq .login)
    ok "gh authenticated as ${login}"
  else
    warn "gh installed but not authenticated — run: gh auth login"
  fi
else
  warn "gh not found — install: brew install gh (macOS) or https://cli.github.com"
fi

# ------------------------------------------------------
# gcloud (optional — only if deploying to GCP)
# ------------------------------------------------------
if command -v gcloud >/dev/null 2>&1; then
  if gcloud auth application-default print-access-token >/dev/null 2>&1; then
    ok "gcloud authenticated (ADC)"
  else
    warn "gcloud installed but no ADC — run: gcloud auth application-default login (only needed for GCP deploy)"
  fi
else
  info "gcloud not found — install if you'll deploy to GCP: brew install --cask google-cloud-sdk"
fi

# ------------------------------------------------------
# ECC (Everything Claude Code)
# Two layers:
#   1. VENDORED rules (15 files, ~30KB) — drives @-imports in CLAUDE.md
#   2. REQUIRED plugin (ecc@ecc from affaan-m/ECC marketplace) — 67 agents, 278 skills, 94 commands
# The full ECC repo is a multi-tool distribution; cloning it wholesale blows
# Claude Code's memory-file scan past its context limit (~5.8M tokens).
# ------------------------------------------------------
if [[ -f .claude/rules/ecc/rules/common/coding-style.md ]]; then
  file_count=$(find .claude/rules/ecc/rules -type f -name "*.md" | wc -l | tr -d ' ')
  ok "ECC vendored rules present (${file_count} files, ~30KB)"
else
  warn "ECC vendored rules missing at .claude/rules/ecc/rules/"
  warn "  run: ./.claude/rules/ecc/update.sh"
fi

# ecc@ecc plugin is REQUIRED. .claude/settings.json declares it under
# enabledPlugins so Claude Code will report it missing on session start.
# We can't install it from shell (plugin install is a Claude Code /command),
# but we can loudly remind the user to do it once.
echo ""
echo "${y}⚠ REQUIRED: install the ecc@ecc plugin in Claude Code (one-time).${d}"
echo "   When you open Claude Code the first time, run these two commands:"
echo ""
echo "     /plugin marketplace add affaan-m/ECC"
echo "     /plugin install ecc@ecc"
echo ""
echo "   This ships ECC's 67 subagents + 278 skills + 94 commands globally."
echo "   Skipping this leaves the harness half-configured."
echo ""

# ------------------------------------------------------
# .env
# ------------------------------------------------------
if [[ ! -f .env ]]; then
  cp .env.example .env
  ok "created .env from .env.example — fill in real keys before running"
else
  ok ".env exists"
fi

# ------------------------------------------------------
# Hooks executable
# ------------------------------------------------------
find .claude/hooks -type f -name "*.sh" -exec chmod +x {} \;
ok "hooks made executable"

# ------------------------------------------------------
# Bun install (if package.json exists)
# ------------------------------------------------------
if [[ -f package.json ]]; then
  info "running bun install..."
  bun install
  ok "dependencies installed"
else
  info "no package.json yet — run 'bun init' when ready to start coding"
fi

echo ""
ok "setup complete"
echo ""
info "next steps:"
echo "  1. fill in .env with real API keys"
echo "  2. read CLAUDE.md + docs/ONBOARDING.md"
echo "  3. open Claude Code: claude"
echo "  4. try: /work-on \"your first task\""
echo ""
