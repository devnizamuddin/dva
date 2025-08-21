#!/bin/bash
# DVA CLI - Developer Workflow Automation
# Enhanced with colors, emojis, logging
# MIT License (c) 2025 Nizam Uddin Shamrat

# Set DVA home directory
DVA_HOME="$HOME/.dva"

# Colors
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
BLUE="\033[1;34m"
NC="\033[0m"

# Log file
LOG_FILE="$DVA_HOME/logs/dva.log"
mkdir -p "$(dirname "$LOG_FILE")"

# Import tasks and helpers
source "$DVA_HOME/scripts/utils.sh"
source "$DVA_HOME/scripts/tasks.sh"

function log_task() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

echo -e "${BLUE}==============================="
echo -e "         DVA CLI Menu           "
echo -e "===============================${NC}"

PS3="Select a task: "
options=("🚀 Start Dev Environment" "🧹 Clean Project" "🔄 Sync Git Branches" "❌ Quit")

select opt in "${options[@]}"
do
    case $opt in
        "🚀 Start Dev Environment")
            log_task "Start Dev Environment selected"
            start_dev
            ;;
        "🧹 Clean Project")
            log_task "Clean Project selected"
            clean_project
            ;;
        "🔄 Sync Git Branches")
            log_task "Sync Git Branches selected"
            git_sync
            ;;
        "❌ Quit")
            echo -e "${YELLOW}Goodbye!${NC}"
            log_task "CLI exited"
            break
            ;;
        *)
            echo -e "${RED}Invalid option.${NC}"
            ;;
    esac
done
