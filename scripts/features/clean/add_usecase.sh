#!/bin/bash

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

  # Convert to lowercase and capitalize first letter
  local FEATURE_NAME_LOWER=$(echo "$FEATURE_NAME" | tr '[:upper:]' '[:lower:]')
  local FEATURE_NAME_CAPITALIZED=$(echo "${FEATURE_NAME_LOWER:0:1}" | tr '[:lower:]' '[:upper:]')${FEATURE_NAME_LOWER:1}

  local USECASE_NAME_LOWER=$(echo "$USECASE_NAME" | tr '[:upper:]' '[:lower:]')
  local USECASE_NAME_CAPITALIZED=$(echo "${USECASE_NAME_LOWER:0:1}" | tr '[:lower:]' '[:upper:]')${USECASE_NAME_LOWER:1}

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

  echo "Usecase created successfully!"
}