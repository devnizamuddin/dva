#!/bin/bash

function create_asset_constants() {
  local PROJECT_DIR=$(pwd)
  local CONSTANTS_DIR="$PROJECT_DIR/lib/app/core/constants"
  local FILE_NAME="asset_path.dart"
  local ASSETS_DIR="$PROJECT_DIR/assets"

  mkdir -p "$CONSTANTS_DIR"

  # Start Dart file
  echo "/// Auto-generated Asset Path constants" > "$CONSTANTS_DIR/$FILE_NAME"
  echo "/// Do not edit manually" >> "$CONSTANTS_DIR/$FILE_NAME"
  echo "" >> "$CONSTANTS_DIR/$FILE_NAME"
  echo "class AssetPath {" >> "$CONSTANTS_DIR/$FILE_NAME"

  # Loop through subfolders of assets
  for dir in $(find "$ASSETS_DIR" -type d | sort); do
    folder_name=$(basename "$dir")
    if [ "$folder_name" != "assets" ]; then
      class_name=$(echo "$folder_name" | sed -E 's/[^a-zA-Z0-9]/_/g' | sed -E 's/^(.)/\U\1/')
      echo "  static class $class_name {" >> "$CONSTANTS_DIR/$FILE_NAME"

      # Loop through files in this folder
      find "$dir" -maxdepth 1 -type f | while read -r file; do
        rel_path="${file#$PROJECT_DIR/}"
        const_name=$(echo "$file" \
          | sed -E "s|.*/$folder_name/||; s/\.[^.]+$//" \
          | sed -E 's/[^a-zA-Z0-9]/_/g' \
          | tr '[:lower:]' '[:upper:]')
        echo "    static const String $const_name = '$rel_path';" >> "$CONSTANTS_DIR/$FILE_NAME"
      done

      echo "  }" >> "$CONSTANTS_DIR/$FILE_NAME"
    fi
  done

  echo "}" >> "$CONSTANTS_DIR/$FILE_NAME"

  echo "✅ AssetPath file created at: $CONSTANTS_DIR/$FILE_NAME"
}
