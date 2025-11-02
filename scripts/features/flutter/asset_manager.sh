#!/bin/bash

function create_asset_constants() {
  local PROJECT_DIR=$(pwd)
  local CONSTANTS_DIR="$PROJECT_DIR/lib/app/core/constants"
  local FILE_NAME="asset_path.dart"
  local ASSETS_DIR="$PROJECT_DIR/assets"

  # Ensure directory exists
  mkdir -p "$CONSTANTS_DIR"

  # Start Dart file
  echo "/// Auto-generated Asset Path constants" > "$CONSTANTS_DIR/$FILE_NAME"
  echo "/// Do not edit manually" >> "$CONSTANTS_DIR/$FILE_NAME"
  echo "" >> "$CONSTANTS_DIR/$FILE_NAME"
  echo "class AssetPath {" >> "$CONSTANTS_DIR/$FILE_NAME"

  # Loop through all asset files
  find "$ASSETS_DIR" -type f | while read -r file; do
    rel_path="${file#$PROJECT_DIR/}"

    # Build constant name
    const_name=$(echo "$rel_path" \
      | sed -E 's/assets\///; s/\.[^.]+$//' \        # remove extension
      | sed -E 's/[^a-zA-Z0-9]/_/g' \
      | tr '[:lower:]' '[:upper:]')

    echo "  static const String $const_name = '$rel_path';" >> "$CONSTANTS_DIR/$FILE_NAME"
  done

  echo "}" >> "$CONSTANTS_DIR/$FILE_NAME"

  echo "✅ AssetPath file created at: $CONSTANTS_DIR/$FILE_NAME"
}
