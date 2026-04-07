#!/bin/bash

function push_unpushed_commits() {

  branch_name=$(git rev-parse --abbrev-ref HEAD)

  git fetch origin >/dev/null 2>&1

  changed_files=$(git log --name-only --oneline origin/"$branch_name".."$branch_name")

  #* Push the changes to the remote repository
  show_progress_dots "Pushing commits to origin/$branch_name" git push origin "$branch_name"

  #* Show the files changed between local and remote branch
  echo ""
  
  if [ -z "$changed_files" ]; then
    print_status_info "No changes detected between the local and remote branches."
  else
    # Format changed files slightly
    local formatted_changes=""
    while IFS= read -r line; do
      if [[ "$line" =~ ^[a-f0-9]{7} ]]; then
        formatted_changes+="\n  ${BOLD}${WHITE}${line}${RESET}"  
      else
        formatted_changes+="\n    ${GREEN}${line}${RESET}"
      fi
    done <<< "$changed_files"

    # Remove leading newline
    formatted_changes="${formatted_changes#\\n}"

    print_card "📂 Files Changed in this Push:\n\n$formatted_changes" "$CYAN"
  fi

  echo ""
}