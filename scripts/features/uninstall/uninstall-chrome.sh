#!/bin/bash

set -euo pipefail

# ============================================================
# Google Chrome — Complete macOS Uninstaller
# Removes Chrome and related user/system files.
# ============================================================

APP_NAME="Google Chrome.app"
APP_PATH="/Applications/$APP_NAME"

echo "=============================================="
echo " Google Chrome Complete Uninstaller"
echo "=============================================="
echo

# ------------------------------------------------------------
# Require administrator privileges
# ------------------------------------------------------------

if [[ $EUID -ne 0 ]]; then
    echo "Administrator privileges are required."
    echo "Re-running with sudo..."
    exec sudo "$0" "$@"
fi

CURRENT_USER="${SUDO_USER:-$(stat -f '%Su' /dev/console)}"
USER_HOME="$(dscl . -read "/Users/$CURRENT_USER" NFSHomeDirectory | awk '{print $2}')"

echo "User: $CURRENT_USER"
echo

# ------------------------------------------------------------
# Confirmation
# ------------------------------------------------------------

read -r -p "This will completely remove Google Chrome and its local data. Continue? [y/N]: " CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo
echo "Stopping Google Chrome processes..."

# ------------------------------------------------------------
# Stop Chrome
# ------------------------------------------------------------

pkill -u "$CURRENT_USER" -f "Google Chrome" 2>/dev/null || true
pkill -u "$CURRENT_USER" -f "GoogleSoftwareUpdate" 2>/dev/null || true

sleep 2

# ------------------------------------------------------------
# Remove Chrome application
# ------------------------------------------------------------

echo "Removing Google Chrome application..."

rm -rf "/Applications/$APP_NAME"

# Also check common alternative locations.
rm -rf "$USER_HOME/Applications/$APP_NAME"

# ------------------------------------------------------------
# User-level Chrome data
# ------------------------------------------------------------

echo "Removing Chrome user data..."

USER_PATHS=(
    "$USER_HOME/Library/Application Support/Google/Chrome"
    "$USER_HOME/Library/Application Support/Google/Chrome Beta"
    "$USER_HOME/Library/Application Support/Google/Chrome Dev"
    "$USER_HOME/Library/Application Support/Google/Chrome Canary"

    "$USER_HOME/Library/Caches/Google/Chrome"
    "$USER_HOME/Library/Caches/com.google.Chrome"

    "$USER_HOME/Library/Preferences/com.google.Chrome.plist"
    "$USER_HOME/Library/Preferences/com.google.Chrome.canary.plist"
    "$USER_HOME/Library/Preferences/com.google.Chrome.beta.plist"
    "$USER_HOME/Library/Preferences/com.google.Chrome.dev.plist"

    "$USER_HOME/Library/Saved Application State/com.google.Chrome.savedState"
    "$USER_HOME/Library/WebKit/com.google.Chrome"

    "$USER_HOME/Library/Logs/Google/Chrome"
    "$USER_HOME/Library/Logs/GoogleSoftwareUpdate"

    "$USER_HOME/Library/Google/GoogleSoftwareUpdate"
)

for PATH_TO_REMOVE in "${USER_PATHS[@]}"; do
    if [[ -e "$PATH_TO_REMOVE" ]]; then
        echo "Removing: $PATH_TO_REMOVE"
        rm -rf "$PATH_TO_REMOVE"
    fi
done

# ------------------------------------------------------------
# Chrome-related Google folders
# ------------------------------------------------------------

echo "Removing Chrome-related Google support files..."

GOOGLE_PATHS=(
    "$USER_HOME/Library/Application Support/Google/GoogleSoftwareUpdate"
    "$USER_HOME/Library/LaunchAgents/com.google.keystone.agent.plist"
    "$USER_HOME/Library/LaunchAgents/com.google.keystone.xpcservice.plist"
)

for PATH_TO_REMOVE in "${GOOGLE_PATHS[@]}"; do
    if [[ -e "$PATH_TO_REMOVE" ]]; then
        echo "Removing: $PATH_TO_REMOVE"
        rm -rf "$PATH_TO_REMOVE"
    fi
done

# ------------------------------------------------------------
# System-wide Google Update components
# ------------------------------------------------------------

echo "Removing system-level Google Update components..."

SYSTEM_PATHS=(
    "/Library/Google/GoogleSoftwareUpdate"
    "/Library/Google/GoogleUpdater"
    "/Library/LaunchAgents/com.google.keystone.agent.plist"
    "/Library/LaunchAgents/com.google.keystone.xpcservice.plist"
    "/Library/LaunchDaemons/com.google.keystone.daemon.plist"
    "/Library/LaunchDaemons/com.google.keystone.system.agent.plist"
)

for PATH_TO_REMOVE in "${SYSTEM_PATHS[@]}"; do
    if [[ -e "$PATH_TO_REMOVE" ]]; then
        echo "Removing: $PATH_TO_REMOVE"
        rm -rf "$PATH_TO_REMOVE"
    fi
done

# ------------------------------------------------------------
# Remove Chrome helper applications
# ------------------------------------------------------------

echo "Searching for Chrome helper applications..."

find "$USER_HOME/Library" \
    -iname "*Google Chrome*" \
    -o -iname "*com.google.Chrome*" \
    2>/dev/null |
while IFS= read -r FOUND_PATH; do
    echo "Removing: $FOUND_PATH"
    rm -rf "$FOUND_PATH"
done

# ------------------------------------------------------------
# Remove Chrome-related preferences
# ------------------------------------------------------------

echo "Removing Chrome preference files..."

find "$USER_HOME/Library/Preferences" \
    -maxdepth 1 \
    \( -iname "*chrome*" -o -iname "*google.chrome*" \) \
    -exec rm -rf {} + 2>/dev/null || true

# ------------------------------------------------------------
# Forget package receipts
# ------------------------------------------------------------

echo "Removing Chrome package receipts..."

pkgutil --pkgs 2>/dev/null |
    grep -iE 'google.*chrome|chrome.*google' |
    while IFS= read -r PACKAGE; do
        echo "Forgetting package: $PACKAGE"
        pkgutil --forget "$PACKAGE" >/dev/null 2>&1 || true
    done

# ------------------------------------------------------------
# Refresh Launch Services
# ------------------------------------------------------------

echo "Refreshing Launch Services..."

/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
    -kill \
    -r \
    -domain local \
    -domain system \
    -domain user \
    >/dev/null 2>&1 || true

# ------------------------------------------------------------
# Final verification
# ------------------------------------------------------------

echo
echo "Verifying Chrome removal..."

if [[ -d "/Applications/$APP_NAME" ]]; then
    echo "WARNING: Chrome application still exists."
else
    echo "✓ Google Chrome application removed."
fi

if pgrep -f "Google Chrome" >/dev/null 2>&1; then
    echo "WARNING: Chrome-related processes are still running."
else
    echo "✓ Chrome processes stopped."
fi

echo
echo "=============================================="
echo " Google Chrome removal completed."
echo "=============================================="
echo
echo "A macOS restart is recommended."