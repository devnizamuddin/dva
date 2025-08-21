#!/bin/bash
# Define automation tasks
# MIT License (c) 2025 Nizam Uddin Shamrat

function start_dev() {
    echo "Starting development environment..."
    # Example: open VSCode and terminal
    code .
    echo "Dev environment started."
}

function clean_project() {
    echo "Cleaning project..."
    rm -rf build/ .dart_tool/  # Example for Flutter projects
    echo "Project cleaned."
}

function git_sync() {
    echo "Syncing git branches..."
    git fetch --all
    git pull --all
    echo "Git branches synced."
}
