#!/bin/bash

# * ┏==================================================================================================┓
# * ┃                                   📖 Git Branch Audit                                            ┃
# * ┗==================================================================================================┛

function audit_git_branches() {
    # 1. Set Defaults
    local DEFAULT_BRANCH1=$(git rev-parse --abbrev-ref HEAD)
    local DEFAULT_BRANCH2="main"
    local BRANCH1
    local BRANCH2

    # 2. Setup Selection Logic
    if [ "$#" -eq 2 ]; then
        BRANCH1=$1
        BRANCH2=$2
    else
        echo -e "${CYAN}Current Defaults: BRANCH1=${BOLD}$DEFAULT_BRANCH1${NC}${CYAN}, BRANCH2=${BOLD}$DEFAULT_BRANCH2${NC}"
        read -p "Do you want to use these defaults? (y/n): " choice
        
        if [[ "$choice" =~ ^[Yy]$ ]]; then
            BRANCH1=$DEFAULT_BRANCH1
            BRANCH2=$DEFAULT_BRANCH2
        else
            line_gap
            echo -e "${BOLD}${MAGENTA}Available branches:${NC}"
            # List branches starting from index 1
            local branches=($(git branch --format="%(refname:short)"))
            for i in "${!branches[@]}"; do
                echo -e "  ${CYAN}$((i+1)))${NC} ${branches[$i]}"
            done

            line_gap
            read -p "Select number for BRANCH1: " idx1
            read -p "Select number for BRANCH2: " idx2
            
            BRANCH1=${branches[$((idx1-1))]}
            BRANCH2=${branches[$((idx2-1))]}
        fi
    fi

    # Validation
    if ! git rev-parse --verify "$BRANCH1" >/dev/null 2>&1 || ! git rev-parse --verify "$BRANCH2" >/dev/null 2>&1; then
        echo -e "${RED}❌ Error: One or both branches do not exist.${NC}"
        return 1
    fi

    line_gap
    multi_line_divider
    echo -e "${BOLD}${BLUE}Comparing: ${YELLOW}$BRANCH1${NC}${BOLD}${BLUE} vs ${YELLOW}$BRANCH2${NC}"
    multi_line_divider

    # 3. File Change Breakdown
    # A = Added, M = Modified, D = Deleted
    local NEW_FILES=$(git diff --name-only --diff-filter=A $BRANCH1 $BRANCH2 | wc -l | xargs)
    local MODIFIED_FILES=$(git diff --name-only --diff-filter=M $BRANCH1 $BRANCH2 | wc -l | xargs)
    local TOTAL_CHANGES=$((NEW_FILES + MODIFIED_FILES))

    line_gap
    echo -e "${BOLD}${GREEN}File Statistics:${NC}"
    echo -e "  Total Files with Changes: ${BOLD}$TOTAL_CHANGES${NC}"
    echo -e "  New Files:              ${BOLD}$NEW_FILES${NC}"
    echo -e "  Modified Files:         ${BOLD}$MODIFIED_FILES${NC}"
    line_gap

    read -p "Would you like to see the names of all changed files? (y/n): " show_files
    if [[ "$show_files" =~ ^[Yy]$ ]]; then
        line_gap
        echo -e "${BOLD}${MAGENTA}--- Changed Files List ---${NC}"
        git diff --name-status $BRANCH1 $BRANCH2
        echo -e "${BOLD}${MAGENTA}--------------------------${NC}"
    fi

    # 4. Common Point & GitHub Integration
    local MERGE_BASE=$(git merge-base $BRANCH1 $BRANCH2)
    local BASE_SUBJECT=$(git log -1 --format=%s $MERGE_BASE)

    line_gap
    echo -e "${BOLD}${CYAN}Last Common Point (Merge Base):${NC}"
    echo -e "  Hash:    ${YELLOW}$MERGE_BASE${NC}"
    echo -e "  Subject: ${DIM}$BASE_SUBJECT${NC}"

    # Generate GitHub URL
    local REMOTE_URL=$(git config --get remote.origin.url | sed 's/\.git$//' | sed 's/git@github.com:/https:\/\/github.com\//')
    if [[ $REMOTE_URL == *"github.com"* ]]; then
        # Comparison URL: https://github.com/user/repo/compare/base...head
        local GH_URL="$REMOTE_URL/compare/$MERGE_BASE...$BRANCH1"
        
        line_gap
        read -p "Open comparison from Common Point on GitHub? (y/n): " open_gh
        if [[ "$open_gh" =~ ^[Yy]$ ]]; then
            # Detect OS to open browser
            if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                xdg-open "$GH_URL"
            elif [[ "$OSTYPE" == "darwin"* ]]; then
                open "$GH_URL"
            else
                echo -e "${YELLOW}Please open manually: $GH_URL${NC}"
            fi
        fi
    fi
    line_gap
    multi_line_divider
}
