#!/bin/bash

function pull_from_choosen_branch() {

    # local variables 
    local chose_branch=-1

    # Fetch all branches from the remote
    show_progress_dots "Fetching active branches" git fetch --prune

    BRANCHES=($(git branch -r | grep -v '\->' | sed 's/origin\///'))

    if [ ${#BRANCHES[@]} -eq 0 ]; then
    #!---------------------------> No remote branches found! <---------------------------
    
        echo -e "${RED}❌ No remote branches found!${RESET}"
        exit 1
    fi

    #---------------------------> Having remote branches found! <---------------------------

    echo -e "\n${CYAN}📂 Available Active Branches:${RESET}"
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

    #*---------------------------> Taking user input(number) to select branch  <---------------------------

    read -p "$(echo -e "\n${GREEN}🖌   Enter the branch number: ${RESET}")" chose_branch


    if ! [[ "$chose_branch" =~ ^[0-9]+$ ]] || [ "$chose_branch" -lt 1 ] || [ "$chose_branch" -gt "${#BRANCHES[@]}" ]; then
        echo ""
        echo -e "${RED}❌ Invalid selection! Please enter a valid number.${RESET}"
        echo ""
        exit 1
    fi

    SELECTED_BRANCH="${BRANCHES[$((chose_branch - 1))]}"


    #*---------------------------> Pulling commits from selected branch  <---------------------------
    show_progress_dots "Pulling latest changes from ${SELECTED_BRANCH}" git pull origin "$SELECTED_BRANCH"
    echo ""
}