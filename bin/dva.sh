#!/bin/bash
# DVA CLI - Developer Workflow Automation
# MIT License (c) 2025 Nizam Uddin Shamrat

DVA_HOME="$HOME/.dva"

# Import helpers
source "$DVA_HOME/scripts/utils.sh"
source "$DVA_HOME/scripts/tasks.sh"

echo -e "${BLUE}==============================="
echo -e "         DVA CLI Menu           "
echo -e "===============================${NC}"

while true; do
  echo "0) ❌ Quit"
  echo "1) 🚀 Start Dev Environment"
  echo "2) 🧹 Clean Project"
  echo "3) 🔄 Sync Git Branches"
  read -p "Select an option [0-3]: " choice

  case "$choice" in
    1) start_dev_menu ;;
    2) clean_project_menu ;;
    3) git_sync_menu ;;
    0) echo -e "${YELLOW}Goodbye!${NC}"; log_task "CLI exited"; break ;;
    *) echo -e "${RED}Invalid option. Enter 0–3.${NC}" ;;
  esac
done
