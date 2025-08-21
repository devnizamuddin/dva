#!/bin/bash
# DVA CLI - Developer Workflow Automation
# MIT License (c) 2025 Nizam Uddin Shamrat

# Import tasks and helpers
source "$(dirname "$0")/../scripts/utils.sh"
source "$(dirname "$0")/../scripts/tasks.sh"

echo "==============================="
echo "         DVA CLI Menu           "
echo "==============================="

PS3="Select a task: "
options=("Start Dev Environment" "Clean Project" "Sync Git Branches" "Quit")

select opt in "${options[@]}"
do
    case $opt in
        "Start Dev Environment")
            start_dev
            ;;
        "Clean Project")
            clean_project
            ;;
        "Sync Git Branches")
            git_sync
            ;;
        "Quit")
            echo "Goodbye!"
            break
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
done
