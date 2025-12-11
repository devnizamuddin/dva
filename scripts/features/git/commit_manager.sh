#!/bin/bash

function commit_all_staged_files() {
    # Get staged file list
    staged_files=$(git diff --name-only --cached)

    # If no staged files, stop execution and exit the function
    if [[ -z "$staged_files" ]]; then
      echo -e "${YELLOW}No staged files to commit.${RESET}"
      echo ""
      return 1
    fi

    # Print the staged files
    echo -e "${BOLD}${CYAN}📂 Staged Files:${RESET}"
    echo -e "${BOLD}${CYAN}═════════════════════════════════════════════════════════════════════${RESET}"
    echo ""

    while IFS= read -r file; do
      echo -e " - ${GREEN}$file${RESET}"
      echo ""  # Add a blank line for better readability
    done <<< "$staged_files"

    # Prompt for commit prefix selection
    echo ""
    echo -e "\n📌${BOLD}${CYAN} Choose a commit prefix${RESET} || ${RED}0 → Back${RESET} \n"
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════════════════════${RESET}"
    echo ""
    echo "  1 → 🚀 Add       - New Implementation           2 → 🔧 Fix       - Bug Solving"
    echo ""
    echo "  3 → 🔨 Refactor  - Better Implementation        4 → ⏪ Revert    - Back to Previous"
    echo ""
    echo "  5 → 🧹 Cleanup   - Formatting Code              6 → ⚙️  Config    - Project Config"
    echo ""
    echo "  7 → 📚 Docs      - Project Documentation        8 → ✅ Test      - Testing code"
    echo ""
    echo "  9 → 📲 Deploy    - Apps Deployment              * → © Custom     - Custom Prefix"
    echo ""
    echo ""
    echo -e "👉 ${GREEN}Enter your choice (1-9)${RESET} || ${GOLDEN}✏️ Custom (Any)${RESET}: \c"
    read -r prefix_choice

    if [[ -z "$prefix_choice" ]]; then
      prefix_choice="2"
    fi
    echo ""

    # Check if any files were selected
    if [ ${#prefix_choice[@]} -eq 0 ]; then
      echo ""
      echo ""
      echo -e "${BLUE}Back to Main...${RESET}"
    else

      # Set the prefix based on user choice
      case $prefix_choice in
          1) prefix="🚀 Add" ;;
          2) prefix="🔧 Fix" ;;
          3) prefix="🔨 Refactor" ;;
          4) prefix="⏪ Revert" ;;
          5) prefix="🧹 Cleanup" ;;
          6) prefix="⚙️ Config" ;;
          7) prefix="📚 Docs" ;;
          8) prefix="✅ Test" ;;
          9) prefix="📲 Deploy" ;;
          *)
            read -p "$(echo -e "\n${GOLDEN}✏️ Enter custom prefix: ${RESET}")" prefix
            echo ""
            ;;
      esac

      # Get commit message
      if [ -z "$1" ]; then
          read -p "$(echo -e "\n${BOLD}${GOLDEN} 🖋️  Enter commit message: ${RESET}")" commit_message
      else
          commit_message="$1"
      fi

      # Combine the prefix with the message if applicable
      if [ -n "$prefix" ]; then
          commit_message="$prefix: $commit_message"
      fi

      # Commit the changes
      git commit -m "$commit_message"

      echo -e "\n✅ Commit successful!\n"

      # Display Staged Files (Already Staged)
      echo -e "${BOLD}${CYAN}✅ Commited Files:${RESET}"
      echo -e "${BOLD}${CYAN}═════════════════════════════════════════════════════════════════════${RESET}"
      echo ""
      
      if [[ -z "$staged_files" ]]; then
          echo -e "${YELLOW}  No files commited.${RESET}"
      else
          i=1
          for file in $staged_files; do
              echo -e "${GREEN}  $i. $file${RESET}"
              echo ""
              staged_list+=("$file")
              ((i++))
          done
      fi
      echo ""
    fi
}