#!/bin/bash

#* ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
#* ┃                                   📥 Pull Manager                                                ┃
#* ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝

__stash_and_pull() {
    local target_branch="$1"
    
    local has_changes=false
    if [[ -n $(git status -s) ]]; then
        has_changes=true
    fi

    if [ "$has_changes" = true ]; then
        print_status_warning "Uncommitted changes detected. Auto-stashing..."
        git stash push -m "Auto-stash before pull by DVA" >/dev/null
    fi

    print_status_info "Pulling latest changes for ${target_branch}..."
    if git pull origin "${target_branch}"; then
        print_status_success "Successfully pulled from ${target_branch}!"
    else
        print_status_error "Failed to pull from ${target_branch}!"
    fi

    if [ "$has_changes" = true ]; then
        print_status_info "Restoring stashed changes..."
        if git stash pop >/dev/null; then
            print_status_success "Stash restored successfully!"
        else
            print_status_error "Stash pop resulted in conflicts. Please resolve manually."
        fi
    fi
}

function pull_from_choosen_branch() {
    show_all_active_branches

    echo ""
    print_card "📝 Entering Branch Selection:" "$CYAN"
    read -p "$(echo -e "  ${GREEN}🖌   Enter the branch number: ${RESET}")" choosen_branch

    if ! [[ "$choosen_branch" =~ ^[0-9]+$ ]] || [ "$choosen_branch" -lt 1 ] || [ "$choosen_branch" -gt "${#BRANCHES[@]}" ]; then
        echo ""
        print_status_error "Invalid selection! Please enter a valid number."
        echo ""
        exit 1
    fi

    SELECTED_BRANCH="${BRANCHES[$((choosen_branch - 1))]}"
    echo ""
    __stash_and_pull "$SELECTED_BRANCH"
}

function pull_current_branch() {
    branch_name=$(git rev-parse --abbrev-ref HEAD)
    echo ""
    print_card "⬇️ Pulling Changes\nBranch: $branch_name" "$BOLD$CYAN"
    echo ""
    __stash_and_pull "$branch_name"
    echo ""
}