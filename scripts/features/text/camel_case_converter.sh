#!/bin/bash

function convert_to_camel_case() {
    echo ""
    read -p "Enter your text: " input
    echo ""
    # Replace underscores, dashes, and spaces with spaces
    local temp="${input//[_-]/ }"

    local camel_case=""
    local first_word=true

    for word in $temp; do
        if $first_word; then
            # Lowercase the first word
            camel_case=$(echo "$word" | awk '{print tolower($0)}')
            first_word=false
        else
            # Capitalize first letter, lowercase the rest
            camel_case+=$(echo "$word" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')
        fi
    done

    echo "$camel_case"
}
