#!/bin/bash

function convert_to_snake_case() {
    echo ""
    read -p "Enter your text: " input
    echo ""

    # 1️⃣ Normalize input
    # Replace dashes and spaces with underscores
    local temp="${input//[- ]/_}"

    # 2️⃣ Insert underscore before uppercase letters (camelCase or PascalCase)
    temp=$(echo "$temp" | sed -E 's/([a-z0-9])([A-Z])/\1_\2/g')

    # 3️⃣ Convert to lowercase
    local snake_case=$(echo "$temp" | tr '[:upper:]' '[:lower:]')

    # 4️⃣ Remove leading/trailing underscores and compress multiple ones
    snake_case=$(echo "$snake_case" | sed -E 's/^_+//;s/_+$//;s/_+/_/g')

    echo "🔤 Snake case: $snake_case"
}
