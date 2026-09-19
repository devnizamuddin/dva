#!/bin/bash

function commit_all_staged_files() {
    # Get staged file list
    staged_files=$(git diff --name-only --cached)

    # If no staged files, stop execution and exit the function
    if [[ -z "$staged_files" ]]; then
      print_status_warning "No staged files to commit."
      echo ""
      return 1
    fi

    # Print the staged files
    echo ""
    print_card "📂 Staged Files:\n\n$staged_files" "$CYAN"
    echo ""

    local PREFIX_OPTIONS=(
      "🆕 Feature"
      "🧩 Fix"
      "🌟 Refactor"
      "⏪ Revert"
      "🔄 Cleanup"
      "⚙️ Config"
      "📝 Docs"
      "🔬 Test"
      "🚀 Deploy"
      "🏷️ Custom Prefix"
    )

    print_card "📌 Select a Commit Prefix (Use arrows)" "$CYAN"
    local prefix=$(printf "%s\n" "${PREFIX_OPTIONS[@]}" | fzf --prompt="Prefix: " --height=12 --border)

    echo ""
    # Check if back/esc was selected
    if [[ -z "$prefix" ]]; then
      print_status_info "Cancelled commit."
      return 0
    fi

    if [[ "$prefix" == "🏷️ Custom Prefix" ]]; then
      read -p "$(echo -e "  ${GOLDEN}🏷️  Enter custom prefix (e.g., \"🚑 Hotfix\"): ${RESET}")" prefix
      echo ""
    fi

    # Get commit message
    if [ -z "$1" ]; then
        read -p "$(echo -e "  ${BOLD}${GOLDEN}🖋️  Enter commit message (e.g., \"fix bug in layout shift\"): ${RESET}")" commit_message
    else
        commit_message="$1"
    fi

    # Combine the prefix with the message if applicable
    if [ -n "$prefix" ]; then
        commit_message="$prefix: $commit_message"
    fi

    echo ""
    # Commit the changes
    if git commit -m "$commit_message" >/dev/null 2>&1; then
        print_status_success "Commit successful!"
    else
        print_status_error "Commit failed."
        return 1
    fi

    # Display Staged Files (Already Staged)
    echo ""
    print_card "✅ Committed Files:\n\n$staged_files" "$GREEN"
    echo ""
}