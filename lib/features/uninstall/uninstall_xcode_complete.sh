#!/bin/bash

set -Eeuo pipefail

# ============================================================
# Xcode + iOS Development COMPLETE Uninstaller for macOS
# ============================================================
#
# Removes:
#   • Xcode
#   • Xcode command-line developer directory
#   • DerivedData
#   • Xcode Archives
#   • iOS Simulator devices and data
#   • Simulator runtimes
#   • CoreSimulator data
#   • Xcode caches, logs, preferences
#   • Swift Package Manager caches
#   • CocoaPods user caches
#   • iOS development-related support files
#
# Does NOT remove:
#   • Your projects
#   • Git repositories
#   • Homebrew
#   • Ruby itself
#
# WARNING:
# This permanently deletes downloaded SDKs, simulators,
# archives, build caches, and Xcode data.
# ============================================================

CURRENT_USER="${SUDO_USER:-$(stat -f '%Su' /dev/console)}"

USER_HOME="$(
    dscl . -read "/Users/$CURRENT_USER" NFSHomeDirectory |
    awk '{print $2}'
)"

echo
echo "================================================"
echo " Xcode + iOS Development COMPLETE Uninstaller"
echo "================================================"
echo
echo "User: $CURRENT_USER"
echo "Home: $USER_HOME"
echo
echo "This will permanently remove:"
echo
echo "  • Xcode"
echo "  • iOS Simulators"
echo "  • Simulator runtimes"
echo "  • DerivedData"
echo "  • Xcode Archives"
echo "  • Swift Package caches"
echo "  • CocoaPods caches"
echo "  • CoreSimulator data"
echo "  • Xcode preferences and logs"
echo
echo "⚠️  YOUR PROJECTS WILL NOT BE DELETED."
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
echo "Starting complete Xcode removal..."
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
# Stop Xcode and Simulator processes
# ------------------------------------------------------------

echo
echo "Stopping Xcode and Simulator processes..."

pkill -u "$CURRENT_USER" -f "Xcode" 2>/dev/null || true
pkill -u "$CURRENT_USER" -f "Simulator" 2>/dev/null || true
pkill -u "$CURRENT_USER" -f "CoreSimulator" 2>/dev/null || true
pkill -u "$CURRENT_USER" -f "simctl" 2>/dev/null || true

sleep 3

# ------------------------------------------------------------
# Shut down all simulators
# ------------------------------------------------------------

echo
echo "Shutting down simulators..."

if command -v xcrun >/dev/null 2>&1; then
    xcrun simctl shutdown all 2>/dev/null || true
fi

# ------------------------------------------------------------
# Remove Xcode application
# ------------------------------------------------------------

echo
echo "Removing Xcode application..."

remove_path "/Applications/Xcode.app"
remove_path "$USER_HOME/Applications/Xcode.app"

# ------------------------------------------------------------
# Remove Xcode developer data
# ------------------------------------------------------------

echo
echo "Removing Xcode developer data..."

XCODE_PATHS=(
    "$USER_HOME/Library/Developer/Xcode"

    "$USER_HOME/Library/Caches/com.apple.dt.Xcode"
    "$USER_HOME/Library/Caches/com.apple.dt.XcodePlaygrounds"

    "$USER_HOME/Library/Logs/CoreSimulator"
    "$USER_HOME/Library/Logs/Xcode"

    "$USER_HOME/Library/Preferences/com.apple.dt.Xcode.plist"

    "$USER_HOME/Library/Saved Application State/com.apple.dt.Xcode.savedState"

    "$USER_HOME/Library/Application Support/Xcode"

    "$USER_HOME/Library/Application Support/com.apple.dt.Xcode"
)

for path in "${XCODE_PATHS[@]}"; do
    remove_path "$path"
done

# ------------------------------------------------------------
# Remove DerivedData
# ------------------------------------------------------------

echo
echo "Removing Xcode DerivedData..."

remove_path "$USER_HOME/Library/Developer/Xcode/DerivedData"

# ------------------------------------------------------------
# Remove Xcode Archives
# ------------------------------------------------------------

echo
echo "Removing Xcode Archives..."

remove_path "$USER_HOME/Library/Developer/Xcode/Archives"

# ------------------------------------------------------------
# Remove Xcode device support
# ------------------------------------------------------------

echo
echo "Removing Xcode device support files..."

remove_path "$USER_HOME/Library/Developer/Xcode/iOS DeviceSupport"
remove_path "$USER_HOME/Library/Developer/Xcode/watchOS DeviceSupport"
remove_path "$USER_HOME/Library/Developer/Xcode/tvOS DeviceSupport"

# ------------------------------------------------------------
# Remove CoreSimulator
# ------------------------------------------------------------

echo
echo "Removing iOS Simulator data..."

CORE_SIMULATOR_PATHS=(
    "$USER_HOME/Library/Developer/CoreSimulator"
    "$USER_HOME/Library/Caches/com.apple.CoreSimulator"
    "$USER_HOME/Library/Logs/CoreSimulator"
    "$USER_HOME/Library/Preferences/com.apple.iphonesimulator.plist"
)

for path in "${CORE_SIMULATOR_PATHS[@]}"; do
    remove_path "$path"
done

# ------------------------------------------------------------
# Remove installed Simulator runtimes
# ------------------------------------------------------------

echo
echo "Removing Simulator runtimes..."

remove_path "/Library/Developer/CoreSimulator"

# ------------------------------------------------------------
# Remove Swift Package Manager caches
# ------------------------------------------------------------

echo
echo "Removing Swift Package Manager caches..."

SWIFT_PATHS=(
    "$USER_HOME/Library/Caches/org.swift.swiftpm"
    "$USER_HOME/Library/org.swift.swiftpm"
    "$USER_HOME/.swiftpm"
)

for path in "${SWIFT_PATHS[@]}"; do
    remove_path "$path"
done

# ------------------------------------------------------------
# Remove CocoaPods caches
# ------------------------------------------------------------

echo
echo "Removing CocoaPods caches..."

COCOAPODS_PATHS=(
    "$USER_HOME/Library/Caches/CocoaPods"
    "$USER_HOME/.cocoapods"
)

for path in "${COCOAPODS_PATHS[@]}"; do
    remove_path "$path"
done

# ------------------------------------------------------------
# Search for Xcode-specific leftovers
# ------------------------------------------------------------

echo
echo "Searching ~/Library for Xcode leftovers..."

while IFS= read -r -d '' path; do
    echo "Removing:"
    echo "  $path"

    rm -rf "$path"

done < <(
    find "$USER_HOME/Library" \
        -depth \
        \( \
            -iname "*xcode*" \
            -o -iname "*coreSimulator*" \
            -o -iname "*iphonesimulator*" \
            -o -iname "*com.apple.dt.xcode*" \
        \) \
        -print0 2>/dev/null
)

# ------------------------------------------------------------
# Reset active developer directory
# ------------------------------------------------------------

echo
echo "Resetting active developer directory..."

if command -v xcode-select >/dev/null 2>&1; then

    sudo xcode-select --reset 2>/dev/null || true

fi

# ------------------------------------------------------------
# Remove Xcode-related package receipts
# ------------------------------------------------------------

echo
echo "Checking package receipts..."

while IFS= read -r package; do

    [[ -z "$package" ]] && continue

    echo "Forgetting package:"
    echo "  $package"

    sudo pkgutil --forget "$package" \
        >/dev/null 2>&1 || true

done < <(
    pkgutil --pkgs 2>/dev/null |
    grep -iE 'xcode|coresimulator' || true
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

LEFTOVERS=0

CHECK_PATHS=(
    "/Applications/Xcode.app"
    "$USER_HOME/Library/Developer/Xcode"
    "$USER_HOME/Library/Developer/CoreSimulator"
    "/Library/Developer/CoreSimulator"
)

for path in "${CHECK_PATHS[@]}"; do

    if [[ -e "$path" ]]; then

        echo "⚠️ Still exists:"
        echo "  $path"

        LEFTOVERS=1

    fi

done

echo

if [[ "$LEFTOVERS" -eq 0 ]]; then

    echo "✅ Xcode and major iOS development files removed."

else

    echo "⚠️ Some files may still remain."

fi

echo
echo "================================================"
echo " Complete Xcode + iOS cleanup finished"
echo "================================================"
echo
echo "Restart your Mac before reinstalling Xcode."