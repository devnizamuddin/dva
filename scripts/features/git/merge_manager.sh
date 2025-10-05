#!/bin/bash


merge_branches() {
  local SOURCE_BRANCH=$1
  local TARGET_BRANCH=$2

  if [[ -z "$SOURCE_BRANCH" || -z "$TARGET_BRANCH" ]]; then
    echo "❌ Usage: $0 <source_branch> <target_branch>"
    exit 1
  fi

  echo "🔍 Checking Git repository..."
  if [[ ! -d .git ]]; then
    echo "❌ Not a Git repository!"
    exit 1
  fi

  echo "📥 Fetching latest changes..."
  git fetch origin

  echo "🌿 Switching to target branch: $TARGET_BRANCH"
  if ! git checkout "$TARGET_BRANCH"; then
    echo "❌ Target branch '$TARGET_BRANCH' does not exist!"
    exit 1
  fi

  echo "⬇️ Pulling latest changes for $TARGET_BRANCH..."
  git pull origin "$TARGET_BRANCH"

  echo "🌿 Ensuring source branch exists: $SOURCE_BRANCH"
  if ! git rev-parse --verify "$SOURCE_BRANCH" >/dev/null 2>&1; then
    echo "❌ Source branch '$SOURCE_BRANCH' does not exist!"
    exit 1
  fi

  echo "⬇️ Pulling latest changes for $SOURCE_BRANCH..."
  git checkout "$SOURCE_BRANCH"
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

merge_branches "$1" "$2"
