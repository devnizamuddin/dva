#!/bin/bash

function convert_to_pascal_case() {
    echo ""
    read -p "Enter your text: " input
    echo ""

    # 1️⃣ Normalize input
    # Replace underscores and dashes with spaces
    local temp="${input//[_-]/ }"

    # 2️⃣ Insert space before uppercase letters in camelCase or PascalCase
    # Example: "helloWorld" → "hello World", "MyAppName" → "My App Name"
    temp=$(echo "$temp" | sed -E 's/([a-z])([A-Z])/\1 \2/g')

    # 3️⃣ Convert multiple spaces to a single space
    temp=$(echo "$temp" | tr -s ' ')

    # 4️⃣ Capitalize each word and join together (PascalCase)
    local pascal_case=""
    for word in $temp; do
        pascal_case+=$(echo "$word" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')
    done

    echo "🔤 Pascal case: $pascal_case"
}
