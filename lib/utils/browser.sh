#!/bin/bash

[[ -n "${_DVA_BROWSER_LOADED+x}" ]] && return 0
_DVA_BROWSER_LOADED=1

# ==========================================
# * 🚀 Launch Project Git URL in Browser
# ==========================================

function launch_source() {
  # Read optional branch argument
  BRANCH_NAME="$1"

  # Ensure inside a git repo
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "❌ Not a git repository!"
    return 1
  fi

  # Get remote repo URL
  GIT_URL=$(git config --get remote.origin.url)
  if [ -z "$GIT_URL" ]; then
    echo "❌ No remote origin found!"
    return 1
  fi

  # Convert SSH → HTTPS if needed
  if [[ "$GIT_URL" == git@* ]]; then
    GIT_URL=$(echo "$GIT_URL" | sed -E 's#git@(.*):(.*)#https://\1/\2#')
  fi

  # Remove .git suffix
  GIT_URL=${GIT_URL%.git}

  # If branch provided, append to URL
  if [ -n "$BRANCH_NAME" ]; then
    GIT_URL="${GIT_URL}/commits/${BRANCH_NAME}"
  fi

  echo "🌐 Opening: $GIT_URL"

  # Open in default browser (macOS/Linux)
  if command -v open >/dev/null 2>&1; then
    open "$GIT_URL"
  elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$GIT_URL"
  else
    echo "⚠️ Please open manually: $GIT_URL"
  fi
}
