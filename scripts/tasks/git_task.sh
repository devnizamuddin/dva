#!/bin/bash


function print_git_task_list() {
  local ORANGE="\033[38;5;208m"
  local BG_ORANGE="\033[48;5;208m"
  echo -e "${BG_ORANGE}${ORANGE}${BOLD}┌───────────────────────────────────────────────┐${NC}"
  echo -e "${BG_ORANGE}${ORANGE}${BOLD}│                                               │${NC}"
  echo -e "${BG_ORANGE}${ORANGE}${BOLD}│ 1. Remote Url                                 │${NC}"
  echo -e "${BG_ORANGE}${ORANGE}${BOLD}│                                               │${NC}"
  echo -e "${BG_ORANGE}${ORANGE}${BOLD}│ 2. Active Branches                            │${NC}"
  echo -e "${BG_ORANGE}${ORANGE}${BOLD}│                                               │${NC}"
  echo -e "${BG_ORANGE}${ORANGE}${BOLD}└───────────────────────────────────────────────┘${NC}"
}

function print_git_remote_url() {
  echo ""
  echo "🔗 Git Remote URLs"
  echo "═══════════════════════════════════════════════"

  # Print Fetch URLs
  echo -e "\n📥 Fetch URLs:"
  git remote -v | grep '(fetch)' | awk '{print "📦 " $1 ": " $2}'

  # Print Push URLs
  echo -e "\n📤 Push URLs:"
  git remote -v | grep '(push)' | awk '{print "📦 " $1 ": " $2}'

  echo -e "\n═══════════════════════════════════════════════"
  echo ""
}

function showActiveBranches() {

    echo ""
    echo -e "${YELLOW}🔄 Fetching active branches...${RESET}"
    echo ""
    git fetch --prune

    BRANCHES=($(git branch -r | grep -v '\->' | sed 's/origin\///'))

    if [ ${#BRANCHES[@]} -eq 0 ]; then
        echo -e "${RED}❌ No remote branches found!${RESET}"
        exit 1
    fi
    echo ""
    echo -e "${BOLD}${CYAN}📂 Available Active Branches:${RESET}"
    echo -e "${BOLD}${CYAN}═════════════════════════════════════════════════════════════════════${RESET}"
    echo ""
    COLUMN_WIDTH=20
    for i in "${!BRANCHES[@]}"; do
        printf "%-2d. %-*s" "$(($i + 1))" "$COLUMN_WIDTH" "${BRANCHES[$i]}"
        if (( ($i + 1) % 2 == 0 )); then
            echo ""
            echo ""
        fi
    done
    echo ""
}

