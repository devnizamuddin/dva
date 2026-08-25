#!/bin/bash

set -Eeuo pipefail

# ============================================================
# Flutter COMPLETE Uninstaller for macOS
# ============================================================
#
# Removes:
#   • Flutter SDK installations
#   • Flutter SDK cache/tool data
#   • Dart Pub cache
#   • FVM-managed Flutter SDKs
#   • Flutter-related files in ~/Library
#   • Common Flutter/Dart symlinks
#
# Does NOT remove:
#   • Your Flutter projects
#   • Android Studio
#   • Android SDK
#   • Xcode
#   • CocoaPods
# ============================================================

CURRENT_USER="${SUDO_USER:-$(stat -f '%Su' /dev/console)}"

USER_HOME="$(dscl . -read "/Users/$CURRENT_USER" NFSHomeDirectory |
    awk '{print $2}')"

echo
echo "================================================"
echo " Flutter COMPLETE Uninstaller"
echo "================================================"
echo
echo "User: $CURRENT_USER"
echo "Home: $USER_HOME"
echo
echo "This will permanently remove:"
echo
echo "  • Flutter SDK installations"
echo "  • Flutter cache and tool data"
echo "  • Dart Pub cache"
echo "  • FVM-managed Flutter SDKs"
echo "  • Flutter-related Library files"
echo
echo "⚠️  Your Flutter projects will NOT be deleted."
echo
echo "THIS ACTION CANNOT BE UNDONE."
echo

read -r -p "Type DELETE to continue: " CONFIRM

if [[ "$CONFIRM" != "DELETE" ]]; then
    echo
    echo "Cancelled."
    exit 0
fi

echo
echo "Starting complete Flutter removal..."
echo

# ------------------------------------------------------------
# Helper function
# ------------------------------------------------------------

remove_path() {
    local path="$1"

    if [[ -e "$path" || -L "$path" ]]; then
        echo "Removing:"
        echo "  $path"

        rm -rf "$path"
    fi
}

# ------------------------------------------------------------
# Stop Flutter/Dart processes
# ------------------------------------------------------------

echo "Stopping Flutter and Dart processes..."

pkill -u "$CURRENT_USER" -f "flutter" 2>/dev/null || true
pkill -u "$CURRENT_USER" -f "dart" 2>/dev/null || true

sleep 2

# ------------------------------------------------------------
# Detect installed Flutter location
# ------------------------------------------------------------

echo
echo "Checking installed Flutter location..."

FLUTTER_BINARY="$(command -v flutter 2>/dev/null || true)"

if [[ -n "$FLUTTER_BINARY" ]]; then
    echo "Flutter found:"
    echo "  $FLUTTER_BINARY"

    # Resolve symlink if possible.
    FLUTTER_REAL_PATH="$(python3 -c \
        'import os, sys; print(os.path.realpath(sys.argv[1]))' \
        "$FLUTTER_BINARY" 2>/dev/null || true)"

    if [[ -n "$FLUTTER_REAL_PATH" ]]; then
        FLUTTER_BIN_DIR="$(dirname "$FLUTTER_REAL_PATH")"

        # Flutter SDK root is usually:
        # flutter/bin/flutter
        FLUTTER_SDK="$(dirname "$FLUTTER_BIN_DIR")"

        echo "Detected Flutter SDK:"
        echo "  $FLUTTER_SDK"

        remove_path "$FLUTTER_SDK"
    fi
fi

# ------------------------------------------------------------
# Common Flutter SDK locations
# ------------------------------------------------------------

echo
echo "Removing common Flutter SDK locations..."

COMMON_FLUTTER_PATHS=(
    "$USER_HOME/development/flutter"
    "$USER_HOME/development/flutter_sdk"
    "$USER_HOME/Development/flutter"
    "$USER_HOME/Development/flutter_sdk"
    "$USER_HOME/Documents/flutter"
    "$USER_HOME/Documents/flutter_sdk"
    "$USER_HOME/flutter"
    "$USER_HOME/flutter_sdk"
    "$USER_HOME/SDK/flutter"
    "$USER_HOME/sdk/flutter"
    "/opt/flutter"
    "/usr/local/flutter"
)

for path in "${COMMON_FLUTTER_PATHS[@]}"; do
    remove_path "$path"
done

# ------------------------------------------------------------
# Remove FVM-managed Flutter SDKs
# ------------------------------------------------------------

echo
echo "Removing FVM-managed Flutter SDKs..."

FVM_PATHS=(
    "$USER_HOME/fvm"
    "$USER_HOME/.fvm"
    "$USER_HOME/.fvm_flutter"
    "$USER_HOME/Library/Application Support/fvm"
    "$USER_HOME/Library/Caches/fvm"
)

for path in "${FVM_PATHS[@]}"; do
    remove_path "$path"
done

# ------------------------------------------------------------
# Remove Dart Pub cache
# ------------------------------------------------------------

echo
echo "Removing Dart Pub cache..."

PUB_CACHE_PATHS=(
    "$USER_HOME/.pub-cache"
    "$USER_HOME/Library/Caches/dart"
    "$USER_HOME/Library/Application Support/dart"
)

for path in "${PUB_CACHE_PATHS[@]}"; do
    remove_path "$path"
done

# ------------------------------------------------------------
# Remove Flutter tool/cache directories
# ------------------------------------------------------------

echo
echo "Removing Flutter tool and cache data..."

FLUTTER_DATA_PATHS=(
    "$USER_HOME/.flutter"
    "$USER_HOME/.flutter_tool"
    "$USER_HOME/.dart_tool"
    "$USER_HOME/Library/Caches/Flutter"
    "$USER_HOME/Library/Application Support/Flutter"
    "$USER_HOME/Library/Logs/Flutter"
)

for path in "${FLUTTER_DATA_PATHS[@]}"; do
    remove_path "$path"
done

# ------------------------------------------------------------
# Search ~/Library for Flutter leftovers
# ------------------------------------------------------------

echo
echo "Searching ~/Library for Flutter-related leftovers..."

while IFS= read -r -d '' path; do
    echo "Removing:"
    echo "  $path"

    rm -rf "$path"

done < <(
    find "$USER_HOME/Library" \
        -depth \
        \( \
            -iname "*flutter*" \
            -o -iname "*dart*" \
        \) \
        -print0 2>/dev/null
)

# ------------------------------------------------------------
# Remove common Flutter symlinks
# ------------------------------------------------------------

echo
echo "Removing common Flutter/Dart binaries..."

COMMON_BINARIES=(
    "/usr/local/bin/flutter"
    "/usr/local/bin/dart"
    "/opt/homebrew/bin/flutter"
    "/opt/homebrew/bin/dart"
)

for path in "${COMMON_BINARIES[@]}"; do

    if [[ -L "$path" ]]; then
        echo "Removing symlink:"
        echo "  $path"

        rm -f "$path"
    fi

done

# ------------------------------------------------------------
# Remove package receipts
# ------------------------------------------------------------

echo
echo "Checking package receipts..."

while IFS= read -r package; do

    [[ -z "$package" ]] && continue

    echo "Forgetting package:"
    echo "  $package"

    pkgutil --forget "$package" >/dev/null 2>&1 || true

done < <(
    pkgutil --pkgs 2>/dev/null |
    grep -iE 'flutter|dart' || true
)

# ------------------------------------------------------------
# Verification
# ------------------------------------------------------------

echo
echo "================================================"
echo " Verification"
echo "================================================"

LEFTOVERS=0

CHECK_PATHS=(
    "$USER_HOME/.pub-cache"
    "$USER_HOME/.fvm"
    "$USER_HOME/.fvm_flutter"
)

for path in "${CHECK_PATHS[@]}"; do

    if [[ -e "$path" ]]; then
        echo "⚠️ Still exists:"
        echo "  $path"

        LEFTOVERS=1
    fi

done

if command -v flutter >/dev/null 2>&1; then

    echo
    echo "⚠️ Flutter command is still available:"
    echo "  $(command -v flutter)"

    LEFTOVERS=1

else

    echo
    echo "✓ Flutter command is no longer available."

fi

echo

if [[ "$LEFTOVERS" -eq 0 ]]; then

    echo "✅ Flutter and major related files removed."

else

    echo "⚠️ Some Flutter-related files may still remain."

fi

echo
echo "================================================"
echo " Complete Flutter uninstall finished"
echo "================================================"
echo
echo "Restart your Terminal or Mac."