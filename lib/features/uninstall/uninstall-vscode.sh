#!/bin/bash

# ============================================================
# Visual Studio Code — Complete macOS Uninstaller
#
# Removes:
#   • Visual Studio Code.app
#   • VS Code settings
#   • Extensions
#   • Application Support
#   • Caches
#   • Logs
#   • Saved Application State
#   • Containers / Group Containers
#   • WebKit / HTTP storage
#   • VS Code CLI symlinks
#   • VS Code-related user data
#
# Does NOT remove:
#   • Your projects
#   • Source-code repositories
#   • Git configuration
#   • SSH configuration
#   • Node.js / npm
#   • Flutter / Dart
#   • Other development tools
# ============================================================

set -u

APP_PATH="/Applications/Visual Studio Code.app"

echo ""
echo "============================================================"
echo "   Visual Studio Code — Complete macOS Uninstaller"
echo "============================================================"
echo ""

# ------------------------------------------------------------
# 1. Confirmation
# ------------------------------------------------------------

read -r -p "This will completely remove Visual Studio Code and its user data. Continue? [y/N]: " CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo ""
    echo "Cancelled."
    exit 0
fi

echo ""
echo "Starting removal..."
echo ""

# ------------------------------------------------------------
# 2. Quit VS Code
# ------------------------------------------------------------

echo "→ Stopping Visual Studio Code..."

pkill -x "Code" 2>/dev/null || true
pkill -f "/Applications/Visual Studio Code.app" 2>/dev/null || true

sleep 2

# ------------------------------------------------------------
# 3. Remove Application
# ------------------------------------------------------------

echo "→ Removing Visual Studio Code application..."

if [ -d "$APP_PATH" ]; then
    sudo rm -rf "$APP_PATH"
    echo "  ✓ Removed Visual Studio Code.app"
else
    echo "  • Visual Studio Code.app not found"
fi

# ------------------------------------------------------------
# 4. Application Support
# ------------------------------------------------------------

echo "→ Removing Application Support..."

rm -rf \
    "$HOME/Library/Application Support/Code" \
    "$HOME/Library/Application Support/Code - Insiders"

# ------------------------------------------------------------
# 5. VS Code Extensions
# ------------------------------------------------------------

echo "→ Removing VS Code extensions..."

rm -rf \
    "$HOME/.vscode" \
    "$HOME/.vscode-insiders"

# ------------------------------------------------------------
# 6. VS Code CLI
# ------------------------------------------------------------

echo "→ Removing VS Code CLI..."

for BIN in \
    "/usr/local/bin/code" \
    "/usr/local/bin/code-insiders" \
    "/opt/homebrew/bin/code" \
    "/opt/homebrew/bin/code-insiders"
do
    if [ -L "$BIN" ] || [ -f "$BIN" ]; then
        sudo rm -f "$BIN"
        echo "  ✓ Removed $BIN"
    fi
done

# ------------------------------------------------------------
# 7. Preferences
# ------------------------------------------------------------

echo "→ Removing preferences..."

rm -f \
    "$HOME/Library/Preferences/com.microsoft.VSCode.plist" \
    "$HOME/Library/Preferences/com.microsoft.VSCodeInsiders.plist"

find "$HOME/Library/Preferences" \
    -maxdepth 1 \
    \( -iname "*vscode*" -o -iname "*visual*studio*code*" \) \
    -exec rm -f {} \; 2>/dev/null || true

# ------------------------------------------------------------
# 8. Caches
# ------------------------------------------------------------

echo "→ Removing caches..."

rm -rf \
    "$HOME/Library/Caches/com.microsoft.VSCode" \
    "$HOME/Library/Caches/com.microsoft.VSCodeInsiders"

find "$HOME/Library/Caches" \
    -maxdepth 1 \
    \( -iname "*vscode*" -o -iname "*visual*studio*code*" \) \
    -exec rm -rf {} \; 2>/dev/null || true

# ------------------------------------------------------------
# 9. Logs
# ------------------------------------------------------------

echo "→ Removing logs..."

rm -rf \
    "$HOME/Library/Logs/Visual Studio Code" \
    "$HOME/Library/Logs/Code" \
    "$HOME/Library/Logs/Code - Insiders"

find "$HOME/Library/Logs" \
    -maxdepth 1 \
    \( -iname "*vscode*" -o -iname "*visual*studio*code*" -o -iname "*code*" \) \
    -exec rm -rf {} \; 2>/dev/null || true

# ------------------------------------------------------------
# 10. Saved Application State
# ------------------------------------------------------------

echo "→ Removing saved application state..."

rm -rf \
    "$HOME/Library/Saved Application State/com.microsoft.VSCode.savedState" \
    "$HOME/Library/Saved Application State/com.microsoft.VSCodeInsiders.savedState"

find "$HOME/Library/Saved Application State" \
    -maxdepth 1 \
    \( -iname "*vscode*" -o -iname "*visual*studio*code*" \) \
    -exec rm -rf {} \; 2>/dev/null || true

# ------------------------------------------------------------
# 11. Containers
# ------------------------------------------------------------

echo "→ Removing containers..."

find "$HOME/Library/Containers" \
    -maxdepth 1 \
    \( -iname "*vscode*" -o -iname "*microsoft*code*" \) \
    -exec rm -rf {} \; 2>/dev/null || true

# ------------------------------------------------------------
# 12. Group Containers
# ------------------------------------------------------------

echo "→ Removing group containers..."

find "$HOME/Library/Group Containers" \
    -maxdepth 1 \
    \( -iname "*vscode*" -o -iname "*microsoft*code*" \) \
    -exec rm -rf {} \; 2>/dev/null || true

# ------------------------------------------------------------
# 13. WebKit
# ------------------------------------------------------------

echo "→ Removing WebKit data..."

find "$HOME/Library/WebKit" \
    -maxdepth 2 \
    \( -iname "*vscode*" -o -iname "*microsoft*code*" \) \
    -exec rm -rf {} \; 2>/dev/null || true

# ------------------------------------------------------------
# 14. HTTP Storage
# ------------------------------------------------------------

echo "→ Removing HTTP storage..."

find "$HOME/Library/HTTPStorages" \
    -maxdepth 1 \
    \( -iname "*vscode*" -o -iname "*microsoft*code*" \) \
    -exec rm -rf {} \; 2>/dev/null || true

# ------------------------------------------------------------
# 15. Cookies
# ------------------------------------------------------------

echo "→ Removing VS Code cookie data..."

find "$HOME/Library/Cookies" \
    -maxdepth 1 \
    \( -iname "*vscode*" -o -iname "*microsoft*code*" \) \
    -exec rm -rf {} \; 2>/dev/null || true

# ------------------------------------------------------------
# 16. Launch Agents
# ------------------------------------------------------------

echo "→ Checking LaunchAgents..."

find "$HOME/Library/LaunchAgents" \
    -maxdepth 1 \
    \( -iname "*vscode*" -o -iname "*microsoft*code*" \) \
    -exec rm -f {} \; 2>/dev/null || true

# ------------------------------------------------------------
# 17. Recent Documents
# ------------------------------------------------------------

echo "→ Removing recent-document references..."

find "$HOME/Library/Application Support/com.apple.sharedfilelist" \
    -iname "*vscode*" \
    -exec rm -f {} \; 2>/dev/null || true

# ------------------------------------------------------------
# 18. Temporary files
# ------------------------------------------------------------

echo "→ Removing temporary VS Code files..."

find "/tmp" \
    -maxdepth 1 \
    \( -iname "*vscode*" -o -iname "*code*" \) \
    -exec rm -rf {} \; 2>/dev/null || true

find "/private/tmp" \
    -maxdepth 1 \
    \( -iname "*vscode*" -o -iname "*code*" \) \
    -exec rm -rf {} \; 2>/dev/null || true

# ------------------------------------------------------------
# 19. Flush preference / shared-file services
# ------------------------------------------------------------

echo "→ Refreshing macOS services..."

killall cfprefsd 2>/dev/null || true
killall sharedfilelistd 2>/dev/null || true

# ------------------------------------------------------------
# 20. Verification
# ------------------------------------------------------------

echo ""
echo "→ Verifying removal..."
echo ""

REMAINING=0

if [ -d "/Applications/Visual Studio Code.app" ]; then
    echo "  ⚠ Visual Studio Code.app still exists"
    REMAINING=1
fi

if pgrep -x "Code" >/dev/null 2>&1; then
    echo "  ⚠ VS Code process is still running"
    REMAINING=1
fi

for BIN in \
    "/usr/local/bin/code" \
    "/usr/local/bin/code-insiders" \
    "/opt/homebrew/bin/code" \
    "/opt/homebrew/bin/code-insiders"
do
    if [ -e "$BIN" ] || [ -L "$BIN" ]; then
        echo "  ⚠ CLI remains: $BIN"
        REMAINING=1
    fi
done

# ------------------------------------------------------------
# 21. Result
# ------------------------------------------------------------

echo ""
echo "============================================================"

if [ "$REMAINING" -eq 0 ]; then
    echo "   ✓ Visual Studio Code completely removed"
else
    echo "   ⚠ Removal completed with remaining items"
    echo "   Review the warnings above."
fi

echo "============================================================"
echo ""