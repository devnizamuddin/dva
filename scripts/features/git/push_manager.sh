#!/bin/bash

function push_unpushed_commits() {

  branch_name=$(git rev-parse --abbrev-ref HEAD)

  git fetch origin

  changed_files=$(git log --name-only --oneline origin/"$branch_name".."$branch_name")

  #* Push the changes to the remote repository
  git push origin "$branch_name"

  #* Show the files changed between local and remote branch
  echo ""
  echo -e "${BOLD}${CYAN}📂 Files Changed in this Push :${RESET}"
  echo ""
  echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════════════════════${RESET}"
  echo ""

  if [ -z "$changed_files" ]; then
    echo -e "${RED}No changes detected between the local and remote branches.${RESET}"
  else
    echo "$changed_files" | while read line; do
      if [[ "$line" =~ ^[a-f0-9]{7} ]]; then
        echo -e "${BOLD}${WHITE}$line${RESET}"  
      else
        echo -e "${GREEN}$line${RESET}"
      fi
    done
  fi

  echo ""
  echo ""

}