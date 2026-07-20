#!/usr/bin/env bash
# PostToolUse hook — runs after Edit/Write.
# Reads the tool's JSON input from stdin, extracts the edited file path,
# and runs oxfmt --write + oxlint --fix on just that file.
#
# Silently exits 0 if the file isn't a .ts/.tsx/.js/.jsx/.vue (nothing to lint),
# or if the oxlint/oxfmt binaries aren't installed yet (project not bootstrapped).

set -euo pipefail

payload=$(cat)
file=$(echo "$payload" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null || true)

if [[ -z "$file" ]]; then
  exit 0
fi

# Only lint recognized file types
case "$file" in
  *.ts|*.tsx|*.js|*.jsx|*.vue|*.mjs|*.cjs) ;;
  *) exit 0 ;;
esac

# Skip if tools not installed (project not bootstrapped yet)
command -v bunx >/dev/null 2>&1 || exit 0

# Fmt first, then lint --fix. Errors are advisory (exit 0 no matter what).
bunx --bun oxfmt --write "$file" 2>&1 | tail -5 || true
bunx --bun oxlint --fix "$file" 2>&1 | tail -5 || true

exit 0
