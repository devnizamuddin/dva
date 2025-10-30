#!/bin/bash


function show_commit_history() {
  echo "Showing the commit history..."
  # git log --pretty=oneline
  git log --oneline --graph --decorate \
  --pretty=format:"%C(yellow)%ad%Creset %C(cyan)$(git branch --contains | grep -v 'HEAD' | sed 's/^[[:space:]]*//')%Creset %C(green)* %an%n%n%Creset%s%n%n" --date=format:'%Y-%m-%d %I:%M %p'
}


function showBranchUpdatesByComparingMine() {

  BRANCH=$1
  
  echo ""

  echo -e "${BOLD}${RED}Conflict files with ${BRANCH}:${RESET}"
  echo -e "${BOLD}${RED}═════════════════════════════════════════════════════════════════════${RESET}"
  echo ""
  git diff --name-only --diff-filter=U origin/"$BRANCH"...HEAD | while read -r file; do
    echo "- $file"
    echo ""
  done
  echo ""

  echo -e "${BOLD}${CYAN}Changed files with ${BRANCH}:${RESET}"
  echo -e "${BOLD}${CYAN}═════════════════════════════════════════════════════════════════════${RESET}"
  echo ""
  git diff --name-only --diff-filter=M origin/"$BRANCH"...HEAD | while read -r file; do
      echo "- $file"
      echo ""
  done
  echo ""

  echo -e "${BOLD}${BLUE}New files with ${BRANCH}:${RESET}"
  echo -e "${BOLD}${BLUE}═════════════════════════════════════════════════════════════════════${RESET}"
  echo ""
  git diff --name-only --diff-filter=A origin/"$BRANCH"...HEAD | while read -r file; do
    echo "- $file"
    echo ""
  done
  echo ""


  echo ""
}


function show_commit_changes() {

  branch_name=$(git rev-parse --abbrev-ref HEAD)

  #* Show the files changed in the last 5 commits
  echo -e "${BOLD}${CYAN}📂 Files Changed in the last 5 commit :${RESET}"
  echo ""
  echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════════════════════${RESET}"
  echo ""

  git log -n 5 --name-only --oneline | while read line; do
    if [[ $line =~ ^[a-f0-9]{7} ]]; then
      echo ""
      echo -e "\n${BOLD}${WHITE}$line${RESET}"
      echo -e "${WHITE}═══════════════════════════════════════════════════════════════════════════${RESET}"
    else
      echo ""
      echo -e "${GREEN}$line${RESET}"
    fi
  done
  echo ""
  echo ""
}

function git_diff_branches() {
  echo "Enter the source branch (e.g., master):"
  read -r source_branch
  echo "Enter the target branch (e.g., feature-branch):"
  read -r target_branch

  echo "Showing diff between $source_branch and $target_branch..."
  git diff "$source_branch" "$target_branch"
}

