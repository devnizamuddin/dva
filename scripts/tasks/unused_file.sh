!/bin/bash
==============================================
Find Unused Dart Files in a Flutter Project
MIT License (c) 2025
==============================================

set -e

PROJECT_DIR=$(pwd)
LIB_DIR="$PROJECT_DIR/lib"

echo "🔍 Scanning Flutter project for unused files..."

# Get all dart files inside lib/
ALL_FILES=$(find "$LIB_DIR" -type f -name "*.dart" | sort)

# Extract all imports used in lib/ (only relative project imports, not packages)
USED_FILES=$(grep -rhoP "import\s+['\"]package:[^'\"]+['\"]|import\s+['\"](lib/[^'\"]+)['\"]|import\s+['\"]\./[^'\"]+['\"]" "$LIB_DIR" \
  | sed -E "s/import ['\"](lib\/|\.\/)?([^'\"]+)['\"];/\2/g" \
  | sort -u)

# Build absolute paths for used files
USED_PATHS=""
for f in $USED_FILES; do
  USED_PATHS="$USED_PATHS $LIB_DIR/$f"
done

# Compare all vs used
echo ""
echo "⚠️  Unused files found:"
echo "------------------------------------"
for file in $ALL_FILES; do
  if ! echo "$USED_PATHS" | grep -q "$file"; then
    echo "🗑️  $file"
  fi
done

echo ""
echo "✅ Done!"
