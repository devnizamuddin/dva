#!/bin/bash

# Function: clean_unnessery_resources
# Purpose : Find unused Dart files in Flutter project under lib/
clean_unnessery_resources() {
  set -e

  PROJECT_DIR=$(pwd)
  LIB_DIR="$PROJECT_DIR/lib"

  echo "🔍 Scanning Flutter project for unused files..."

  # Get all dart files inside lib/ (ignore generated files)
  ALL_FILES=$(find "$LIB_DIR" -type f -name "*.dart" \
    ! -name "*.g.dart" \
    ! -name "*.freezed.dart" \
    | sort)

  # Extract all project imports and parts (relative imports only)
  USED_FILES=$(grep -rhoE "(import|part)\s+['\"](package:[^'\"]+|lib/[^'\"]+|\.{1,2}/[^'\"]+)['\"]" "$LIB_DIR" \
    | sed -E "s/(import|part)\s+['\"](lib\/|\.\/|..\/)?([^'\"]+)['\"]/\3/g" \
    | sort -u)

  # Build absolute paths for used files
  USED_PATHS=""
  for f in $USED_FILES; do
    if [[ -f "$LIB_DIR/$f" ]]; then
      USED_PATHS="$USED_PATHS $LIB_DIR/$f"
    fi
  done

  echo ""
  echo "⚠️  Unused files found:"
  echo "------------------------------------"

  UNUSED_COUNT=0
  for file in $ALL_FILES; do
    if ! echo "$USED_PATHS" | grep -q "$file"; then
      echo "🗑️  $file"
      UNUSED_COUNT=$((UNUSED_COUNT + 1))
    fi
  done

  if [[ $UNUSED_COUNT -eq 0 ]]; then
    echo "✨ No unused files found!"
  else
    echo "🚨 Total unused files: $UNUSED_COUNT"
  fi

  echo ""
  echo "✅ Done!"
}
