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

    # Prompt for commit prefix selection
    print_card "📌 Choose a Commit Prefix\n\n  1 → 🆕 Feature\n  2 → 🧩 Fix\n  3 → 🌟 Refactor\n  4 → ⏪ Revert\n  5 → 🔄 Cleanup\n  6 → ⚙️  Config\n  7 → 📝 Docs\n  8 → 🔬 Test\n  9 → 🚀 Deploy\n\n  0 → Back to Main" "$CYAN"
    
    echo ""
    read -p "$(echo -e "  👉 ${GREEN}Enter your choice (0-9)${RESET} || ${GOLDEN}Press ⏎ for custom${RESET}: ")" prefix_choice
    if [[ -z "$prefix_choice" ]]; then
      prefix_choice="2"
    fi
    echo ""

    # Check if back was selected
    if [[ "$prefix_choice" == "0" ]]; then
      echo ""
      print_status_info "Back to Main..."
      return 0
    else

      # Set the prefix based on user choice
      case $prefix_choice in
          1) prefix="🆕 Feature" ;;
          2) prefix="🧩 Fix" ;;
          3) prefix="🌟 Refactor" ;;
          4) prefix="⏪ Revert" ;;
          5) prefix="🔄 Cleanup" ;;
          6) prefix="⚙️ Config" ;;
          7) prefix="📝 Docs" ;;
          8) prefix="🔬 Test" ;;
          9) prefix="🚀 Deploy" ;;
          *)
            read -p "$(echo -e "  ${GOLDEN}🏷️ Enter custom prefix: ${RESET}")" prefix
            echo ""
            ;;
      esac

      # Get commit message
      if [ -z "$1" ]; then
          read -p "$(echo -e "  ${BOLD}${GOLDEN}🖋️  Enter commit message: ${RESET}")" commit_message
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
    fi
}