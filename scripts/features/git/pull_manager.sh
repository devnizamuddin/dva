#!/bin/bash

function pull_from_choosen_branch() {

    show_all_active_branches

    #*---------------------------> Taking user input(number) to select branch  <---------------------------

    read -p "$(echo -e "\n${GREEN}🖌   Enter the branch number: ${RESET}")" choosen_branch


    if ! [[ "$choosen_branch" =~ ^[0-9]+$ ]] || [ "$choosen_branch" -lt 1 ] || [ "$choosen_branch" -gt "${#BRANCHES[@]}" ]; then
        echo ""
        echo -e "${RED}❌ Invalid selection! Please enter a valid number.${RESET}"
        echo ""
        exit 1
    fi

    SELECTED_BRANCH="${BRANCHES[$((choosen_branch - 1))]}"

    

    #*---------------------------> Pulling commits from selected branch  <---------------------------
    
    line_gap
    echo "Pulling from ${SELECTED_BRANCH}..."
    line_gap
    git pull origin "${SELECTED_BRANCH}"
}