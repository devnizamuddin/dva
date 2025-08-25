#!/bin/bash

# 🚀 Start Dev Environment Tasks
function start_dev_menu() {
  echo -e "${BLUE}--- Start Dev Environment ---${NC}"
  echo "0) 🔙 Back"
  echo "1) 🐳 Start Docker containers"
  echo "2) 🌐 Start local server"
  echo "3) 📦 Install dependencies"
  read -p "Select a subtask [0-3]: " choice

  case "$choice" in
    1) log_task "Docker started"; echo "Starting Docker...";;
    2) log_task "Local server started"; echo "Running server...";;
    3) log_task "Dependencies installed"; echo "Installing...";;
    0) return ;;
    *) echo -e "${RED}Invalid subtask.${NC}" ;;
  esac
}
