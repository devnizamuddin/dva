#!/bin/bash
# DVA CLI - Developer Workflow Automation
# MIT License (c) 2025 Nizam Uddin Shamrat

DVA_HOME="$HOME/.dva"

# Import helpers
source "$DVA_HOME/scripts/utils.sh"
source "$DVA_HOME/scripts/ui.sh"
source "$DVA_HOME/scripts/tasks.sh"

clear
printWellcomeMessage "DVA CLI "

# Grid-like cards
print_card "1" "Start Dev Environment" "🚀" "$GREEN"
print_card "2" "Clean Project" "🧹" "$YELLOW"
print_card "3" "𝔽𝕃𝕌𝕋𝕋𝔼ℝ" "⛩︎" "$MAGENTA"
print_card "4" "Git Features" "🔄" "$CYAN"
print_card "0" "Quit" "❌" "$RED"

print_divider
read -p "$(echo -e "${BOLD}👉 Select an option [0-4]: ${NC}") " choice

case "$choice" in
  1) start_dev_menu ;;
  2) clean_project_menu ;;
  3) flutter_menu ;;
  4) git_sync_menu ;;
  0) print_info "Goodbye!"; log_task "CLI exited"; exit 0 ;;
  *) print_error "Invalid option. Enter 0–4." ;;
esac
