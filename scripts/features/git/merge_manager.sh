#!/usr/bin/env bash

merge_branches() {
  local SOURCE_BRANCH=$1
  local TARGET_BRANCH=$2

  # Check for fzf
  if ! command -v fzf &>/dev/null; then
    echo "❌ 'fzf' is required for interactive branch selection. Install it first (e.g., 'brew install fzf')."
    exit 1
  fi

  echo "🔍 Checking Git repository..."
  if [[ ! -d .git ]]; then
    echo "❌ Not a Git repository!"
    exit 1
  fi

  # Get current branch
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

  # Fetch all remote branches
  echo "📥 Fetching latest branches from origin..."
  git fetch origin --prune

  # Get list of remote branches, remove HEAD and duplicates
  BRANCHES=($(git branch -r | grep -v HEAD | sed 's|origin/||' | sort -u))

  # ===== TARGET BRANCH =====
  if [[ -z "$TARGET_BRANCH" ]]; then
    echo "⚡ Select the target branch (default: current branch $CURRENT_BRANCH):"
    TARGET_BRANCH=$(printf "%s\n" "${BRANCHES[@]}" | fzf --prompt="Target branch: " --height=10 --border)
    # If user pressed Enter without selection, use current branch
    TARGET_BRANCH=${TARGET_BRANCH:-$CURRENT_BRANCH}
  fi

  # ===== SOURCE BRANCH =====
  if [[ -z "$SOURCE_BRANCH" ]]; then
    echo "⚡ Select the source branch to merge from:"
    # exclude target branch
    SOURCE_OPTIONS=()
    for b in "${BRANCHES[@]}"; do
      [[ "$b" != "$TARGET_BRANCH" ]] && SOURCE_OPTIONS+=("$b")
    done
    SOURCE_BRANCH=$(printf "%s\n" "${SOURCE_OPTIONS[@]}" | fzf --prompt="Source branch: " --height=10 --border)
  fi

  echo "🌿 Switching to target branch: $TARGET_BRANCH"
  if ! git checkout "$TARGET_BRANCH"; then
    echo "❌ Target branch '$TARGET_BRANCH' does not exist locally!"
    exit 1
  fi

  echo "⬇️ Pulling latest changes for $TARGET_BRANCH..."
  git pull origin "$TARGET_BRANCH"

  echo "🌿 Ensuring source branch exists: $SOURCE_BRANCH"
  if ! git rev-parse --verify "$SOURCE_BRANCH" >/dev/null 2>&1; then
    echo "⚡ Source branch does not exist locally. Checking out from origin..."
    git checkout -b "$SOURCE_BRANCH" "origin/$SOURCE_BRANCH" || {
      echo "❌ Source branch '$SOURCE_BRANCH' does not exist remotely!"
      exit 1
    }
  else
    git checkout "$SOURCE_BRANCH"
  fi

  echo "⬇️ Pulling latest changes for $SOURCE_BRANCH..."
  git pull origin "$SOURCE_BRANCH"

  echo "🔄 Switching back to target branch: $TARGET_BRANCH"
  git checkout "$TARGET_BRANCH"

  echo "🔀 Merging $SOURCE_BRANCH into $TARGET_BRANCH..."
  if git merge --no-ff "$SOURCE_BRANCH"; then
    echo "✅ Merge completed successfully!"
  else
    echo "⚠️ Merge conflicts detected!"
    echo "-----------------------------------------"
    git status --short | grep "^UU" || echo "No conflicted files found."

    echo ""
    echo "❓ How would you like to resolve conflicts?"
    echo "   1) Keep TARGET branch version (--ours)"
    echo "   2) Keep SOURCE branch version (--theirs)"
    echo "   3) Cancel merge and resolve manually"
    read -p "Enter choice [1-3]: " choice

    case $choice in
      1)
        echo "🔧 Keeping TARGET branch version..."
        git checkout --ours .
        git add .
        git commit -m "Auto-resolved conflicts: kept TARGET branch ($TARGET_BRANCH)"
        ;;
      2)
        echo "🔧 Keeping SOURCE branch version..."
        git checkout --theirs .
        git add .
        git commit -m "Auto-resolved conflicts: kept SOURCE branch ($SOURCE_BRANCH)"
        ;;
      3)
        echo "🛑 Merge stopped. Please resolve conflicts manually."
        exit 1
        ;;
      *)
        echo "❌ Invalid choice. Exiting..."
        exit 1
        ;;
    esac
  fi

  echo "📤 Pushing merged branch '$TARGET_BRANCH' to origin..."
  git push origin "$TARGET_BRANCH"
  echo "✅ Branch pushed successfully!"
}


