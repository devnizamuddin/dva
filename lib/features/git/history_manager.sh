#!/bin/bash

function show_commit_history() {
  echo ""
  print_status_info "Showing the commit history..."
  echo ""
  # Add a padded border effect to the git log output
  git log --graph --decorate --pretty=format:"%C(yellow)%ad%C(reset)  %C(cyan)%d%C(reset) %C(green)◉ %an%n   %C(white)%s%C(reset)%n" --date=format:'%Y-%m-%d %I:%M %p' -n 15 | while read line; do
    echo -e "    $line"
  done
  echo ""
  echo -e "    ${DIM}Press 'q' if paginated, or use 'dva log' ...${NC}"
  echo ""
}

function showBranchUpdatesByComparingMine() {
  BRANCH=$1
  echo ""

  local conflict_files=$(git diff --name-only --diff-filter=U origin/"$BRANCH"...HEAD)
  if [ -n "$conflict_files" ]; then
    conflict_files=$(echo "$conflict_files" | sed 's/^/  - /')
    print_card "🚨 Conflict Files with ${BRANCH}:\n\n$conflict_files" "$RED"
  fi

  local changed_files=$(git diff --name-only --diff-filter=M origin/"$BRANCH"...HEAD)
  if [ -n "$changed_files" ]; then
    changed_files=$(echo "$changed_files" | sed 's/^/  - /')
    print_card "📝 Changed Files with ${BRANCH}:\n\n$changed_files" "$CYAN"
  fi

  local new_files=$(git diff --name-only --diff-filter=A origin/"$BRANCH"...HEAD)
  if [ -n "$new_files" ]; then
    new_files=$(echo "$new_files" | sed 's/^/  - /')
    print_card "✨ New Files with ${BRANCH}:\n\n$new_files" "$BLUE"
  fi

  echo ""
}

function show_commit_changes() {
  branch_name=$(git rev-parse --abbrev-ref HEAD)

  local changes=$(git log -n 5 --name-only --oneline)
  local formatted_changes=""
  
  while read line; do
    if [[ $line =~ ^[a-f0-9]{7} ]]; then
      formatted_changes+="\n\n  ${BOLD}${WHITE}${line}${RESET}"
    else
      formatted_changes+="\n    ${GREEN}${line}${RESET}"
    fi
  done <<< "$changes"

  # Remove leading newlines
  formatted_changes="${formatted_changes#\\n\\n}"

  print_card "📂 Files Changed in the Last 5 Commits:\n\n$formatted_changes" "$CYAN"
  echo ""
}

function git_diff_branches() {
  print_card "🔄 Diff Between Branches" "$CYAN"
  
  local branches=($(git branch --format="%(refname:short)"))
  local source_branch=$(printf "%s\n" "${branches[@]}" | fzf --prompt="Source Branch: " --height=10 --border)
  
  if [[ -z "$source_branch" ]]; then
      print_status_info "Diff cancelled."
      return
  fi

  local target_branch=$(printf "%s\n" "${branches[@]}" | grep -v "^${source_branch}$" | fzf --prompt="Target Branch: " --height=10 --border)
  
  if [[ -z "$target_branch" ]]; then
      print_status_info "Diff cancelled."
      return
  fi

  echo ""
  print_status_info "Showing diff between $source_branch and $target_branch..."
  echo ""
  git diff "$source_branch" "$target_branch" | while read -r line; do
    echo "    $line"
  done
  echo ""
}
