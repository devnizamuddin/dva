#!/bin/bash
# Automation tasks for DVA CLI
# MIT License (c) 2025 Nizam Uddin Shamrat

function start_dev() { code .; echo "✅ Dev started."; }
function clean_project() { confirm "Delete build/?" && rm -rf build/; }
function git_sync() { git fetch --all; git pull --all; echo "✅ Git synced."; }