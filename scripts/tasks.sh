#!/bin/bash
# Automation tasks for DVA CLI
# MIT License (c) 2025 Nizam Uddin Shamrat

function start_dev() {
    echo -e "🚀 Starting development environment..."
    code .
    echo -e "✅ Dev environment started."
}

function clean_project() {
    echo -e "🧹 Cleaning project..."
    if confirm "Are you sure you want to delete build/ and .dart_tool/?"; then
        rm -rf build/ .dart_tool/
        echo -e "✅ Project cleaned."
    else
        echo -e "⚠️  Clean canceled."
    fi
}

function git_sync() {
    echo -e "🔄 Syncing git branches..."
    git fetch --all
    git pull --all
    echo -e "✅ Git branches synced."
}
