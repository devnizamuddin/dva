#!/usr/bin/env bash

merge_branches() {
  local SOURCE_BRANCH=$1
  local TARGET_BRANCH=$2

  # Check for fzf
  if ! command -v fzf &>/dev/null; then
    echo "❌ 'fzf' is required for interactive branch selection. Install it first (e.g., 'brew install fzf')."
    exit 1
  fi

  print_status_info "Checking Git repository..."
  if [[ ! -d .git ]]; then
    print_status_error "Not a Git repository!"
    exit 1
  fi

  # Get current branch
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

  # Fetch all remote branches
  print_status_info "Fetching latest branches from origin..."
  git fetch origin --prune >/dev/null 2>&1

  # Get list of remote branches, remove HEAD and duplicates
  BRANCHES=($(git branch -r | grep -v HEAD | sed 's|origin/||' | sort -u))

  # ===== TARGET BRANCH =====
  if [[ -z "$TARGET_BRANCH" ]]; then
    print_card "⚡ Selecting Target Branch" "$CYAN"
    TARGET_BRANCH=$(printf "%s\n" "${BRANCHES[@]}" | fzf --prompt="Target branch: " --height=10 --border)
    # If user pressed Enter without selection, use current branch
    TARGET_BRANCH=${TARGET_BRANCH:-$CURRENT_BRANCH}
  fi

  # ===== SOURCE BRANCH =====
  if [[ -z "$SOURCE_BRANCH" ]]; then
    print_card "⚡ Selecting Source Branch" "$CYAN"
    # exclude target branch
    SOURCE_OPTIONS=()
    for b in "${BRANCHES[@]}"; do
      [[ "$b" != "$TARGET_BRANCH" ]] && SOURCE_OPTIONS+=("$b")
    done
    SOURCE_BRANCH=$(printf "%s\n" "${SOURCE_OPTIONS[@]}" | fzf --prompt="Source branch: " --height=10 --border)
  fi

  print_status_info "Switching to target branch: $TARGET_BRANCH"
  if ! git checkout "$TARGET_BRANCH" >/dev/null 2>&1; then
    print_status_error "Target branch '$TARGET_BRANCH' does not exist locally!"
    exit 1
  fi

  print_status_info "Pulling latest changes for $TARGET_BRANCH..."
  git pull origin "$TARGET_BRANCH" >/dev/null 2>&1

  print_status_info "Ensuring source branch exists: $SOURCE_BRANCH"
  if ! git rev-parse --verify "$SOURCE_BRANCH" >/dev/null 2>&1; then
    print_status_warning "Source branch does not exist locally. Checking out from origin..."
    git checkout -b "$SOURCE_BRANCH" "origin/$SOURCE_BRANCH" >/dev/null 2>&1 || {
      print_status_error "Source branch '$SOURCE_BRANCH' does not exist remotely!"
      exit 1
    }
  else
    git checkout "$SOURCE_BRANCH" >/dev/null 2>&1
  fi

  print_status_info "Pulling latest changes for $SOURCE_BRANCH..."
  git pull origin "$SOURCE_BRANCH" >/dev/null 2>&1

  print_status_info "Switching back to target branch: $TARGET_BRANCH"
  git checkout "$TARGET_BRANCH" >/dev/null 2>&1

  print_card "🔀 Merging $SOURCE_BRANCH into $TARGET_BRANCH" "$MAGENTA"
  if git merge --no-ff "$SOURCE_BRANCH" >/dev/null 2>&1; then
    print_status_success "Merge completed successfully!"
  else
    print_status_error "Merge conflicts detected!"
    echo "  -----------------------------------------"
    git status --short | grep "^UU" || echo "  No conflicted files found."
    echo ""
    
    print_card "❓ Conflict Resolution Strategy:\n   1) Keep TARGET branch version (--ours)\n   2) Keep SOURCE branch version (--theirs)\n   3) Cancel merge and resolve manually" "$YELLOW"
    read -p "  Enter choice [1-3]: " choice

    case $choice in
      1)
        print_status_info "Keeping TARGET branch version..."
        git checkout --ours .
        git add .
        git commit -m "Auto-resolved conflicts: kept TARGET branch ($TARGET_BRANCH)" >/dev/null 2>&1
        ;;
      2)
        print_status_info "Keeping SOURCE branch version..."
        git checkout --theirs .
        git add .
        git commit -m "Auto-resolved conflicts: kept SOURCE branch ($SOURCE_BRANCH)" >/dev/null 2>&1
        ;;
      3)
        print_status_error "Merge stopped. Please resolve conflicts manually."
        exit 1
        ;;
      *)
        print_status_error "Invalid choice. Exiting..."
        exit 1
        ;;
    esac
  fi

  print_status_info "Pushing merged branch '$TARGET_BRANCH' to origin..."
  show_progress_dots "Pushing branch" git push origin "$TARGET_BRANCH"
  print_status_success "Branch pushed successfully!"
}


