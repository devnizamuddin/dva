#!/bin/bash

function convert_to_snake_case() {
    echo ""
    read -p "Enter your text: " input
    echo ""
    # Replace dashes and spaces with underscores
    local temp="${input//[- ]/_}"

    # Insert underscore before uppercase letters (for camelCase/PascalCase)
    # and convert everything to lowercase
    local snake_case=$(echo "$temp" | awk '
    {
        gsub(/([A-Z])/, "_\\1");  # add underscore before capital letters
        print tolower($0);         # convert to lowercase
    }' | sed 's/^_//')  # remove leading underscore if present

    echo "$snake_case"
}
