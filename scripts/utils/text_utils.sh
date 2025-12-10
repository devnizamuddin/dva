#!/bin/bash

# Convert to snake_case (e.g., "User Profile" -> "user_profile")
function to_snake_case() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | tr '-' '_'
}

# Convert to PascalCase (e.g., "user_profile" -> "UserProfile")
function to_pascal_case() {
  local input="$1"
  # Replace spaces and hyphens with underscores first to normalize
  local snake=$(echo "$input" | tr ' ' '_' | tr '-' '_')
  
  # Split by underscore and capitalize each word
  IFS='_' read -r -a words <<< "$snake"
  local pascal=""
  for word in "${words[@]}"; do
    # Capitalize first letter of each word
    pascal+="$(echo "${word:0:1}" | tr '[:lower:]' '[:upper:]')${word:1}"
  done
  echo "$pascal"
}
