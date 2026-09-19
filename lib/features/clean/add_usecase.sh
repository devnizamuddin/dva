#!/bin/bash

# Define the directory where this script resides to locate utilities relative to it
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../utils/text_utils.sh"

function add_usecase_structure() {
  read -p "Enter your desired feature name: " FEATURE_NAME
  read -p "Enter your desired usecase name: " USECASE_NAME

  if [ -z "$FEATURE_NAME" ]; then
    echo "Feature name is required!"
    return 1
  fi

  if [ -z "$USECASE_NAME" ]; then
    echo "Usecase name is required!"
    return 1
  fi

  # Convert to snake_case and PascalCase
  local FEATURE_NAME_LOWER=$(to_snake_case "$FEATURE_NAME")
  local FEATURE_NAME_CAPITALIZED=$(to_pascal_case "$FEATURE_NAME")

  local USECASE_NAME_LOWER=$(to_snake_case "$USECASE_NAME")
  local USECASE_NAME_CAPITALIZED=$(to_pascal_case "$USECASE_NAME")

  # Base directory
  local BASE_DIR="lib/features/$FEATURE_NAME_LOWER"

  if [ ! -d "$BASE_DIR" ]; then
    echo "Feature directory '$BASE_DIR' does not exist. Please create the feature first."
    return 1
  fi

  echo "Creating usecase: $USECASE_NAME_LOWER for feature: $FEATURE_NAME_LOWER"

  # Create usecase file
  cat <<EOL > "$BASE_DIR/domain/usecases/${USECASE_NAME_LOWER}.dart"
import '../repositories/${FEATURE_NAME_LOWER}_repository.dart';

class ${USECASE_NAME_CAPITALIZED} {
  final ${FEATURE_NAME_CAPITALIZED}Repository repository;

  ${USECASE_NAME_CAPITALIZED}({required this.repository});

  void call() {
    // Add logic here
  }
}
EOL

  echo "Usecase $USECASE_NAME_LOWER ($USECASE_NAME_CAPITALIZED) created successfully!"
}