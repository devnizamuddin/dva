#!/bin/bash

function convert_to_title_case() {
    echo ""
    read -p "Enter your text: " input
    echo ""

    # 1️⃣ Replace underscores and dashes with spaces
    local temp="${input//[_-]/ }"

    # 2️⃣ Split camelCase or PascalCase words
    temp=$(echo "$temp" | sed -E 's/([a-z0-9])([A-Z])/\1 \2/g')

    # 3️⃣ Normalize multiple spaces
    temp=$(echo "$temp" | tr -s ' ')

    local title_case=""

    # 4️⃣ Capitalize each word
    for word in $temp; do
        title_case+=$(echo "$word" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')
        title_case+=" "
    done

    # 5️⃣ Trim trailing space
    title_case=$(echo "${title_case%" "}")

    echo "📝 Title case: $title_case"
}
