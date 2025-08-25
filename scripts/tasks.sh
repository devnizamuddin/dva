#!/bin/bash

# Source all task files
for file in "$HOME/.dva/scripts/tasks/"*.sh; do
    source "$file"
done
