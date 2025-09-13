#!/bin/bash

function convert_to_kebab_case() {
    echo ""
    read -p "Enter your text: " input
    echo ""
    # Replace underscores and spaces with dashes
    local temp="${input//[_ ]/-}"

    # Insert dash before uppercase letters (for camelCase/PascalCase)
    local kebab_case=$(echo "$temp" | awk '
    {
        gsub(/([A-Z])/, "-\\1");  # add dash before capital letters
        print tolower($0);         # convert to lowercase
    }' | sed 's/^-//')  # remove leading dash if present

    echo "$kebab_case"
}
