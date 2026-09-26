#!/bin/bash

[[ -n "${_DVA_RUNNER_LOADED+x}" ]] && return 0
_DVA_RUNNER_LOADED=1

function run_script() {
    local script_path="$1"

    # * Check if file exists
    if [ ! -f "$script_path" ]; then
        echo "❌ Error: File '$script_path' does not exist."
        return 1
    fi

    # * Give execute permission
    chmod +x "$script_path"

    # * Run the script
    echo "▶️ Running $script_path"
    "$script_path"
}
