#!/usr/bin/env bash
# Notification hook — fires on agent_completed / agent_needs_input events.
# Reads the hook event JSON from stdin and pings the user (macOS notification
# by default; Slack webhook if SLACK_WEBHOOK_URL is set; both if both are set).
#
# Wire in .claude/settings.json under hooks.Notification.

set -euo pipefail

payload=$(cat)
event=$(echo "$payload" | jq -r '.event // "unknown"' 2>/dev/null || echo "unknown")
summary=$(echo "$payload" | jq -r '.summary // .message // ""' 2>/dev/null || echo "")
agent=$(echo "$payload" | jq -r '.agent // ""' 2>/dev/null || echo "")

title="Claude Code"
case "$event" in
  agent_completed) title="✓ Agent done"; ;;
  agent_needs_input) title="? Agent waiting"; ;;
esac

body="${agent:+[$agent] }${summary:-<no summary>}"

# macOS notification
if command -v osascript >/dev/null 2>&1; then
  osascript -e "display notification \"$body\" with title \"$title\"" 2>/dev/null || true
fi

# Slack webhook (optional)
if [[ -n "${SLACK_WEBHOOK_URL:-}" ]]; then
  curl -sS -X POST -H 'Content-Type: application/json' \
    -d "{\"text\": \"*$title*\n$body\"}" \
    "$SLACK_WEBHOOK_URL" >/dev/null 2>&1 || true
fi

# Linux notify-send (fallback)
if command -v notify-send >/dev/null 2>&1; then
  notify-send "$title" "$body" 2>/dev/null || true
fi

exit 0
