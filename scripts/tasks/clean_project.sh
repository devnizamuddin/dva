#!/bin/bash

# 🧹 Clean Project Tasks
function clean_project_menu() {
  echo -e "${BLUE}--- Clean Project ---${NC}"
  echo "0) 🔙 Back"
  echo "1) Remove build artifacts"
  echo "2) Clear caches"
  echo "3) Reset environment"
  read -p "Select a subtask [0-3]: " choice

  case "$choice" in
    1) log_task "Build artifacts removed"; echo "Cleaning build...";;
    2) log_task "Cache cleared"; echo "Clearing cache...";;
    3) log_task "Environment reset"; echo "Resetting...";;
    0) return ;;
    *) echo -e "${RED}Invalid subtask.${NC}" ;;
  esac
}
