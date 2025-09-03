#!/bin/bash

function show_all_active_branches() {
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