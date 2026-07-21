#!/usr/bin/env bash
# =====================================================
# Update vendored ECC rules from affaan-m/ECC upstream.
# Fetches common/*.md and typescript/*.md ONLY.
# =====================================================

set -euo pipefail

r=$'\033[31m'; g=$'\033[32m'; y=$'\033[33m'; b=$'\033[34m'; d=$'\033[0m'
ok()   { echo "${g}✓${d} $1"; }
warn() { echo "${y}⚠${d} $1"; }
info() { echo "${b}→${d} $1"; }

# Move to script's directory
cd "$(dirname "$0")"

UPSTREAM="https://api.github.com/repos/affaan-m/ECC"
COMMON_URL_BASE="https://raw.githubusercontent.com/affaan-m/ECC"
BRANCH="main"

# Get latest SHA on main
info "resolving latest SHA on ${BRANCH}..."
SHA=$(curl -sSf "${UPSTREAM}/commits/${BRANCH}" | python3 -c "import json,sys; print(json.load(sys.stdin)['sha'])")
ok "SHA=${SHA}"

# Fetch the tree for that SHA to enumerate rules/*
info "listing files..."
TREE=$(curl -sSf "${UPSTREAM}/git/trees/${SHA}?recursive=1")

# Extract just the paths we care about
COMMON_FILES=$(echo "$TREE" | python3 -c "
import json,sys
d = json.load(sys.stdin)
for t in d['tree']:
  p = t['path']
  if p.startswith('rules/common/') and p.endswith('.md'):
    print(p)
")
TS_FILES=$(echo "$TREE" | python3 -c "
import json,sys
d = json.load(sys.stdin)
for t in d['tree']:
  p = t['path']
  if p.startswith('rules/typescript/') and p.endswith('.md'):
    print(p)
")

mkdir -p rules/common rules/typescript

# Fetch each file
count=0
for f in $COMMON_FILES $TS_FILES; do
  curl -sSf "${COMMON_URL_BASE}/${SHA}/${f}" -o "$f"
  count=$((count + 1))
done
ok "fetched ${count} rule files"

# Update VERSION.md with the new SHA
if command -v python3 >/dev/null; then
  today=$(python3 -c "import datetime; print(datetime.date.today().isoformat())")
else
  today=$(date +%Y-%m-%d)
fi
sed -i.bak -E "s|Pinned SHA:.*|Pinned SHA:\`${SHA}\`|; s|Fetched at:.*|Fetched at: ${today}|" VERSION.md
rm -f VERSION.md.bak

ok "VERSION.md updated"
info "review the diff (git diff) and commit if the changes are acceptable"
