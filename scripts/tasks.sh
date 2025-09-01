#!/bin/bash

TASK_DIR="$HOME/.dva/scripts/tasks"

shopt -s nullglob  # make *.sh expand to nothing if no match
for file in "$TASK_DIR"/*.sh; do
  [ -f "$file" ] && source "$file"
done
shopt -u nullglob  # restore default behavior
