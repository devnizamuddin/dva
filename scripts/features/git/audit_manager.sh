# * ┏==================================================================================================┓
# * ┃                                   💎 UI Helper Functions                                         ┃
# * ┗==================================================================================================┛

function animate_text() {
    local text="$1"
    local delay="${2:-0.01}"
    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep "$delay"
    done
    echo ""
}

function draw_neumorphic_card_header() {
    local title="$1"
    local width=70
    echo -e "  ${WHITE}╭$(printf '─%.0s' $(seq 1 $width))╮${NC}"
    echo -e "  ${WHITE}│${BOLD}${MAGENTA}  🚀 $title $(printf ' %.0s' $(seq 1 $((width - ${#title} - 6)))) ${NC}${WHITE}│${NC}"
    echo -e "  ${WHITE}├$(printf '─%.0s' $(seq 1 $width))┤${NC}"
}

function draw_neumorphic_card_footer() {
    local width=70
    echo -e "  ${WHITE}╰$(printf '─%.0s' $(seq 1 $width))╯${NC}"
    echo -e "   ${DIM}▝$(printf '▀%.0s' $(seq 1 $width))▘${NC}"
}

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
        line_gap
        animate_text "${BOLD}${CYAN}📊 Initializing Git Branch Audit...${NC}"
        echo -e "${DIM}Current Defaults: ${WHITE}BRANCH1=$DEFAULT_BRANCH1, BRANCH2=$DEFAULT_BRANCH2${NC}"
        read -p "Use these defaults? (y/n): " choice
        
        if [[ "$choice" =~ ^[Yy]$ ]]; then
            BRANCH1=$DEFAULT_BRANCH1
            BRANCH2=$DEFAULT_BRANCH2
        else
            line_gap
            echo -e "${BOLD}${MAGENTA}📂 Available branches:${NC}"
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
    draw_neumorphic_card_header "AUDIT REPORT: $BRANCH1 vs $BRANCH2"

    # 3. File Change Breakdown
    local NEW_FILES=$(git diff --name-only --diff-filter=A $BRANCH1 $BRANCH2 | wc -l | xargs)
    local MODIFIED_FILES=$(git diff --name-only --diff-filter=M $BRANCH1 $BRANCH2 | wc -l | xargs)
    local TOTAL_CHANGES=$((NEW_FILES + MODIFIED_FILES))

    echo -e "  ${WHITE}│${NC}  ${BOLD}${GREEN}📈 Statistics:${NC}"
    echo -e "  ${WHITE}│${NC}    Total Files Changed : ${GOLDEN}$TOTAL_CHANGES${NC}"
    echo -e "  ${WHITE}│${NC}    New Files           : ${BOLD}$NEW_FILES${NC}"
    echo -e "  ${WHITE}│${NC}    Modified Files      : ${BOLD}$MODIFIED_FILES${NC}"
    echo -e "  ${WHITE}│${NC}"

    # 4. Merge Safety Analysis (Lead Developer View)
    echo -e "  ${WHITE}│${NC}  ${BOLD}${BLUE}🛡️  Merge Safety Analysis:${NC}"
    
    # Conflict Detection using git merge-tree
    local MERGE_TREE_OUT=$(git merge-tree --write-tree "$BRANCH1" "$BRANCH2" 2>&1)
    local MERGE_EXIT=$?
    
    if [ $MERGE_EXIT -eq 0 ]; then
        echo -e "  ${WHITE}│${NC}    Status: ${BOLD}${BG_GREEN}  SAFE TO MERGE  ${NC} ✅"
        echo -e "  ${WHITE}│${NC}    Detail: No structural conflicts detected."
    else
        echo -e "  ${WHITE}│${NC}    Status: ${BOLD}${BG_RED}  CONFLICT ALERT  ${NC} ⚠️"
        echo -e "  ${WHITE}│${NC}    Detail: Potential conflicts found in the following files:"
        # Extract conflicting files from merge-tree output
        local CONFLICT_FILES=$(echo "$MERGE_TREE_OUT" | grep "CONFLICT" | awk '{print $NF}' | sort -u)
        while read -r file; do
            [ -n "$file" ] && echo -e "  ${WHITE}│${NC}      - ${RED}$file${NC}"
        done <<< "$CONFLICT_FILES"
    fi
    echo -e "  ${WHITE}│${NC}"

    # 5. Context
    local MERGE_BASE=$(git merge-base "$BRANCH1" "$BRANCH2")
    local BASE_SUBJECT=$(git log -1 --format=%s "$MERGE_BASE")
    echo -e "  ${WHITE}│${NC}  ${BOLD}${CYAN}🔗 Merge Base Information:${NC}"
    echo -e "  ${WHITE}│${NC}    Hash   : ${DIM}$MERGE_BASE${NC}"
    echo -e "  ${WHITE}│${NC}    Subject: ${ITALIC}$BASE_SUBJECT${NC}"
    
    draw_neumorphic_card_footer

    line_gap
    read -p "Would you like to see the names of all changed files? (y/n): " show_files
    if [[ "$show_files" =~ ^[Yy]$ ]]; then
        line_gap
        echo -e "${BOLD}${MAGENTA}--- 📄 Changed Files List ---${NC}"
        git diff --name-status "$BRANCH1" "$BRANCH2"
        echo -e "${BOLD}${MAGENTA}----------------------------${NC}"
    fi

    # Generate GitHub URL
    local REMOTE_URL=$(git config --get remote.origin.url | sed 's/\.git$//' | sed 's/git@github.com:/https:\/\/github.com\//')
    if [[ $REMOTE_URL == *"github.com"* ]]; then
        local GH_URL="$REMOTE_URL/compare/$MERGE_BASE...$BRANCH1"
        line_gap
        echo -e "${BOLD}${BLUE}🌐 GitHub Comparison:${NC}"
        echo -e "  $GH_URL"
        line_gap
        read -p "  Open this comparison in browser? (y/n): " open_gh
        if [[ "$open_gh" =~ ^[Yy]$ ]]; then
            if [[ "$OSTYPE" == "darwin"* ]]; then open "$GH_URL"; elif [[ "$OSTYPE" == "linux-gnu"* ]]; then xdg-open "$GH_URL"; fi
        fi
    fi
    line_gap

    # 6. Actionable Dashboard: Stale Branch Cleanup
    read -p "  🧹 Would you like to check for and delete stale branches? (y/n): " clean_stale
    if [[ "$clean_stale" =~ ^[Yy]$ ]]; then
        echo ""
        print_status_info "Scanning for branches already merged into $BRANCH2..."
        
        # Find branches merged into BRANCH2, excluding HEAD and BRANCH2 itself
        local merged_branches=($(git branch --merged "$BRANCH2" | grep -v "\*" | grep -v "^[[:space:]]*$BRANCH2$"))
        
        if [ ${#merged_branches[@]} -eq 0 ]; then
            print_status_success "No stale merged branches found. Your repo is clean!"
        else
            local merged_list=""
            for b in "${merged_branches[@]}"; do
                # Trim spaces
                b=$(echo "$b" | xargs)
                merged_list+="\n    🗑️  ${RED}$b${NC}"
            done
            merged_list="${merged_list#\\n}"
            print_card "⚠️  Stale Branches Detected (Merged into $BRANCH2):\n\n$merged_list" "$YELLOW"
            
            echo ""
            read -p "  Are you sure you want to DELETE all these branches? (y/N): " confirm_delete
            if [[ "$confirm_delete" =~ ^[Yy]$ ]]; then
                for b in "${merged_branches[@]}"; do
                    b=$(echo "$b" | xargs)
                    git branch -d "$b" >/dev/null 2>&1
                    print_status_success "Deleted branch $b"
                done
            else
                print_status_info "Branch deletion cancelled."
            fi
        fi
    fi
    line_gap
}
