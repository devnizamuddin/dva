#!/bin/bash

[[ -n "${_DVA_LOGGER_LOADED+x}" ]] && return 0
_DVA_LOGGER_LOADED=1

# Logs
LOG_FILE="$DVA_DATA_DIR/logs/dva.log"
mkdir -p "$(dirname "$LOG_FILE")"

function log_task() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}
