#!/bin/bash

# Source all task files
for file in "$DVA_HOME/scripts/tasks/"*.sh; do
    source "$file"
done