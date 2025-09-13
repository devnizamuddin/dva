#!/bin/bash

function convert_to_title_case() {
    echo ""
    read -p "Enter your text: " input
    echo ""
    # Replace underscores, dashes, and camelCase with spaces
    local temp="${input//[_-]/ }"
    temp=$(echo "$temp" | sed 's/\([a-z]\)\([A-Z]\)/\1 \2/g') # separate camelCase

    local title_case=""

    for word in $temp; do
        # Capitalize first letter, lowercase the rest
        title_case+=$(echo "$word" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')
        title_case+=" "
    done

    # Remove trailing space
    echo "${title_case%" "}"
}
