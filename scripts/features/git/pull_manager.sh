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
    print_status_info "Fetching active branches..."
    git fetch --prune >/dev/null 2>&1

    local BRANCHES=($(git branch -r | grep -v '\->' | sed 's/origin\///'))

    if [ ${#BRANCHES[@]} -eq 0 ]; then
        print_status_error "No remote branches found!"
        return 1
    fi

    echo ""
    print_card "📝 Select a branch to pull from" "$CYAN"
    local selected_branch=$(printf "%s\n" "${BRANCHES[@]}" | fzf --prompt="Branch: " --height=10 --border)

    if [[ -z "$selected_branch" ]]; then
        print_status_info "Branch selection cancelled."
        return 1
    fi

    echo ""
    __stash_and_pull "$selected_branch"
}

function pull_current_branch() {
    branch_name=$(git rev-parse --abbrev-ref HEAD)
    echo ""
    print_card "⬇️ Pulling Changes\nBranch: $branch_name" "$BOLD$CYAN"
    echo ""
    __stash_and_pull "$branch_name"
    echo ""
}