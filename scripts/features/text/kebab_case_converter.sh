#!/bin/bash

function convert_to_kebab_case() {
    echo ""
    read -p "Enter your text: " input
    echo ""

    # Replace underscores and spaces with dashes
    local temp="${input//[_ ]/-}"

    # Insert dash before uppercase letters and convert to lowercase
    local kebab_case=$(echo "$temp" | sed -E 's/([a-z0-9])([A-Z])/\1-\2/g' | tr '[:upper:]' '[:lower:]')

    # Remove possible leading or trailing dashes
    kebab_case=$(echo "$kebab_case" | sed 's/^-//;s/-$//')

    echo "🔤 Kebab case: $kebab_case"
}
