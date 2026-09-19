#!/bin/bash

set -e

echo "=============================================="
echo "   IntelliJ IDEA CE Complete Uninstaller"
echo "=============================================="
echo
echo "This will remove IntelliJ IDEA Community Edition"
echo "and its related local files from this Mac."
echo
read -r -p "Continue? [y/N]: " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo
echo "Stopping IntelliJ IDEA..."
pkill -f "IntelliJ IDEA" 2>/dev/null || true
pkill -f "idea" 2>/dev/null || true

echo "Removing IntelliJ IDEA application..."

rm -rf "/Applications/IntelliJ IDEA CE.app"
rm -rf "/Applications/IntelliJ IDEA Community Edition.app"

echo "Removing IntelliJ IDEA preferences..."

rm -rf "$HOME/Library/Preferences/IntelliJIdea"* 2>/dev/null || true
rm -rf "$HOME/Library/Preferences/com.jetbrains.intellij"* 2>/dev/null || true

echo "Removing caches..."

rm -rf "$HOME/Library/Caches/JetBrains/IntelliJIdea"* 2>/dev/null || true
rm -rf "$HOME/Library/Caches/com.jetbrains.intellij"* 2>/dev/null || true

echo "Removing application support files..."

rm -rf "$HOME/Library/Application Support/JetBrains/IntelliJIdea"* 2>/dev/null || true
rm -rf "$HOME/Library/Application Support/IntelliJIdea"* 2>/dev/null || true

echo "Removing logs..."

rm -rf "$HOME/Library/Logs/JetBrains/IntelliJIdea"* 2>/dev/null || true
rm -rf "$HOME/Library/Logs/IntelliJIdea"* 2>/dev/null || true

echo "Removing saved application state..."

rm -rf "$HOME/Library/Saved Application State/com.jetbrains.intellij"* 2>/dev/null || true
rm -rf "$HOME/Library/Saved Application State/com.intellij"* 2>/dev/null || true

echo "Removing web browser support..."

rm -rf "$HOME/Library/WebKit/com.jetbrains.intellij"* 2>/dev/null || true
rm -rf "$HOME/Library/WebKit/IntelliJIdea"* 2>/dev/null || true

echo "Removing HTTP caches..."

rm -rf "$HOME/Library/HTTPStorages/com.jetbrains.intellij"* 2>/dev/null || true

echo "Removing JetBrains Toolbox IntelliJ installations..."

rm -rf "$HOME/Library/Application Support/JetBrains/Toolbox/apps/IDEA-C"* 2>/dev/null || true
rm -rf "$HOME/Library/Application Support/JetBrains/Toolbox/apps/IDEA"* 2>/dev/null || true

echo "Removing JetBrains Toolbox IntelliJ metadata..."

rm -rf "$HOME/Library/Application Support/JetBrains/Toolbox/apps/IDEA-C"* 2>/dev/null || true

echo "Removing IntelliJ desktop entries..."

rm -f "$HOME/Desktop/IntelliJ IDEA CE.app" 2>/dev/null || true
rm -f "$HOME/Desktop/IntelliJ IDEA Community Edition.app" 2>/dev/null || true

echo
echo "Cleaning Launch Services database..."

/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
    -kill \
    -r \
    -domain local \
    -domain system \
    -domain user \
    >/dev/null 2>&1 || true

echo
echo "=============================================="
echo " IntelliJ IDEA CE has been removed."
echo "=============================================="
echo
echo "Your source-code projects were NOT removed."
echo
echo "Recommended:"
echo "  • Restart your Mac"
echo "  • Reinstall IntelliJ IDEA CE if needed"
echo