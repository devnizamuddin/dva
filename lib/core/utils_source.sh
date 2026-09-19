#!/bin/bash

# Source all utils files
for file in "$DVA_HOME/scripts/utils/"*.sh; do
    source "$file"
done