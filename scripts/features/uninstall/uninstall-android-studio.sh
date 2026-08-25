#!/bin/bash

set -Eeuo pipefail

# ============================================================
# Android Studio Complete Uninstaller for macOS
# ============================================================
#
# Removes:
#   • Android Studio application
#   • Android Studio settings
#   • Preferences
#   • Caches
#   • Logs
#   • Plugins
#   • Android SDK
#   • Android Emulator / AVDs
#   • .android
#   • .gradle
#   • Android Studio-related Library files
#
# WARNING:
# This permanently deletes Android development data.
# ============================================================

APP_NAME="Android Studio.app"

# Get the actual logged-in user.
CURRENT_USER="${SUDO_USER:-$(stat -f '%Su' /dev/console)}"
USER_HOME="$(dscl . -read "/Users/$CURRENT_USER" NFSHomeDirectory | awk '{print $2}')"

echo
echo "================================================"
echo " Android Studio COMPLETE Uninstaller"
echo "================================================"
echo
echo "User: $CURRENT_USER"
echo "Home: $USER_HOME"
echo
echo "This will permanently remove:"
echo
echo "  • Android Studio"
echo "  • Android SDK"
echo "  • Android Emulator / AVDs"
echo "  • Android Studio settings"
echo "  • Android Studio plugins"
echo "  • Android Studio caches and logs"
echo "  • ~/.android"
echo "  • ~/.gradle"
echo
echo "⚠️  THIS ACTION CANNOT BE UNDONE."
echo

read -r -p "Type DELETE to continue: " CONFIRM

if [[ "$CONFIRM" != "DELETE" ]]; then
    echo
    echo "Cancelled."
    exit 0
fi

echo
echo "Starting complete removal..."
echo

# ------------------------------------------------------------
# Stop Android Studio processes
# ------------------------------------------------------------

echo "Stopping Android Studio..."

pkill -u "$CURRENT_USER" -f "Android Studio" 2>/dev/null || true
pkill -u "$CURRENT_USER" -f "studio" 2>/dev/null || true
pkill -u "$CURRENT_USER" -f "emulator" 2>/dev/null || true
pkill -u "$CURRENT_USER" -f "adb" 2>/dev/null || true

sleep 2

# ------------------------------------------------------------
# Helper function
# ------------------------------------------------------------

remove_path() {
    local path="$1"

    if [[ -e "$path" ]]; then
        echo "Removing:"
        echo "  $path"

        rm -rf "$path"
    fi
}

# ------------------------------------------------------------
# Remove Android Studio application
# ------------------------------------------------------------

echo
echo "Removing Android Studio application..."

remove_path "/Applications/Android Studio.app"
remove_path "$USER_HOME/Applications/Android Studio.app"

# ------------------------------------------------------------
# Remove Android Studio configuration
# ------------------------------------------------------------

echo
echo "Removing Android Studio configuration..."

for path in \
    "$USER_HOME/Library/Application Support/Google/AndroidStudio"* \
    "$USER_HOME/Library/Application Support/Google/AndroidStudioPreview"* \
    "$USER_HOME/Library/Application Support/JetBrains/AndroidStudio"* \
    "$USER_HOME/Library/Caches/Google/AndroidStudio"* \
    "$USER_HOME/Library/Caches/JetBrains/AndroidStudio"* \
    "$USER_HOME/Library/Logs/Google/AndroidStudio"* \
    "$USER_HOME/Library/Logs/JetBrains/AndroidStudio"* \
    "$USER_HOME/Library/Preferences/com.google.android.studio.plist" \
    "$USER_HOME/Library/Saved Application State/com.google.android.studio.savedState"
do
    remove_path "$path"
done

# ------------------------------------------------------------
# Search ~/Library for Android Studio leftovers
# ------------------------------------------------------------

echo
echo "Searching ~/Library for Android Studio leftovers..."

while IFS= read -r -d '' path; do
    echo "Removing:"
    echo "  $path"

    rm -rf "$path"
done < <(
    find "$USER_HOME/Library" \
        -depth \
        \( \
            -iname "*androidstudio*" \
            -o -iname "*android studio*" \
            -o -iname "*com.google.android.studio*" \
        \) \
        -print0 2>/dev/null
)

# ------------------------------------------------------------
# Remove Android SDK
# ------------------------------------------------------------

echo
echo "Removing Android SDK..."

remove_path "$USER_HOME/Library/Android/sdk"
remove_path "$USER_HOME/Android/Sdk"

# ------------------------------------------------------------
# Remove Android Emulator / AVDs
# ------------------------------------------------------------

echo
echo "Removing Android Emulator data..."

remove_path "$USER_HOME/.android"

# ------------------------------------------------------------
# Remove Gradle
# ------------------------------------------------------------

echo
echo "Removing Gradle configuration and caches..."

remove_path "$USER_HOME/.gradle"

# ------------------------------------------------------------
# Remove Android command-line tools if installed separately
# ------------------------------------------------------------

echo
echo "Checking common Android development directories..."

remove_path "$USER_HOME/Library/Android"
remove_path "$USER_HOME/Android"

# ------------------------------------------------------------
# Remove preference files
# ------------------------------------------------------------

echo
echo "Removing Android Studio preferences..."

find "$USER_HOME/Library/Preferences" \
    -maxdepth 1 \
    -type f \
    \( \
        -iname "*androidstudio*" \
        -o -iname "*android.studio*" \
        -o -iname "*com.google.android.studio*" \
    \) \
    -print0 2>/dev/null |
while IFS= read -r -d '' path; do
    remove_path "$path"
done

# ------------------------------------------------------------
# Remove Android Studio package receipts
# ------------------------------------------------------------

echo
echo "Removing package receipts..."

while IFS= read -r package; do
    [[ -z "$package" ]] && continue

    echo "Forgetting package:"
    echo "  $package"

    sudo pkgutil --forget "$package" >/dev/null 2>&1 || true

done < <(
    pkgutil --pkgs 2>/dev/null |
    grep -iE 'android.*studio|studio.*android' || true
)

# ------------------------------------------------------------
# Refresh Launch Services
# ------------------------------------------------------------

echo
echo "Refreshing Launch Services..."

LSREGISTER="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"

if [[ -x "$LSREGISTER" ]]; then
    "$LSREGISTER" \
        -kill \
        -r \
        -domain local \
        -domain system \
        -domain user \
        >/dev/null 2>&1 || true
fi

# ------------------------------------------------------------
# Verification
# ------------------------------------------------------------

echo
echo "================================================"
echo " Verification"
echo "================================================"

CHECK_PATHS=(
    "/Applications/Android Studio.app"
    "$USER_HOME/Library/Android"
    "$USER_HOME/.android"
    "$USER_HOME/.gradle"
)

LEFTOVERS=0

for path in "${CHECK_PATHS[@]}"; do
    if [[ -e "$path" ]]; then
        echo "⚠️ Still exists: $path"
        LEFTOVERS=1
    fi
done

echo

if [[ "$LEFTOVERS" -eq 0 ]]; then
    echo "✅ Android Studio and major related files removed."
else
    echo "⚠️ Some files may still remain."
fi

echo
echo "================================================"
echo " Complete uninstall finished"
echo "================================================"
echo
echo "Restart your Mac to complete the cleanup."