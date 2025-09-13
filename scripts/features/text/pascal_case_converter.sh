#!/bin/bash

function convert_to_pascal_case() {
    echo ""
    read -p "Enter your text: " input
    echo ""
    # Replace underscores, dashes, and spaces with spaces
    local temp="${input//[_-]/ }"

    local pascal_case=""

    for word in $temp; do
        # Capitalize first letter, lowercase the rest
        pascal_case+=$(echo "$word" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')
    done

    echo "$pascal_case"
}
