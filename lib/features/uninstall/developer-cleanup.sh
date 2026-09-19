#!/bin/bash

# ============================================================
# macOS Developer Environment Cleanup
# ============================================================
#
# Removes:
#   • IntelliJ IDEA Community Edition
#   • Android Studio
#   • Visual Studio Code
#   • Antigravity IDE
#   • Xcode
#   • Flutter
#   • CocoaPods
#   • Android SDK / Emulator
#   • iOS Simulator data
#   • Gradle / Maven caches
#   • Node package caches
#   • JetBrains caches
#   • Developer application caches/logs
#
# IMPORTANT:
#   • Source-code projects are NOT removed.
#   • macOS system Ruby is NOT removed.
#   • Homebrew itself is NOT removed.
#   • Git configuration is NOT removed.
#
# ============================================================

set -u

# ------------------------------------------------------------
# Colors
# ------------------------------------------------------------

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'

# ------------------------------------------------------------
# Helpers
# ------------------------------------------------------------

info() {
    echo -e "${BLUE}➜${RESET} $1"
}

success() {
    echo -e "${GREEN}✓${RESET} $1"
}

warning() {
    echo -e "${YELLOW}⚠${RESET} $1"
}

error() {
    echo -e "${RED}✗${RESET} $1"
}

section() {
    echo
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${CYAN}$1${RESET}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}

confirm() {
    local message="$1"

    read -r -p "$message [y/N]: " answer

    [[ "$answer" =~ ^[Yy]$ ]]
}

remove_path() {
    local path="$1"

    if [ -e "$path" ] || [ -L "$path" ]; then
        rm -rf "$path"
        success "Removed: $path"
    fi
}

remove_glob() {
    local pattern="$1"

    for path in $pattern; do
        if [ -e "$path" ] || [ -L "$path" ]; then
            rm -rf "$path"
            success "Removed: $path"
        fi
    done
}

# ------------------------------------------------------------
# Root check
# ------------------------------------------------------------

if [ "$(id -u)" -eq 0 ]; then
    error "Do not run this script as root."
    error "Run it from your normal macOS user account."
    exit 1
fi

# ------------------------------------------------------------
# Banner
# ------------------------------------------------------------

clear

echo
echo "============================================================"
echo "        macOS Developer Environment Cleanup"
echo "============================================================"
echo
echo "This script can remove development IDEs, SDKs, caches,"
echo "simulators, emulators, package caches and related data."
echo
warning "Your source-code projects will NOT be removed."
warning "Review the selected components carefully."
echo

# ------------------------------------------------------------
# Stop development processes
# ------------------------------------------------------------

stop_processes() {
    section "Stopping Developer Processes"

    local processes=(
        "IntelliJ IDEA"
        "idea"
        "Android Studio"
        "studio"
        "Visual Studio Code"
        "Code"
        "Antigravity"
        "Xcode"
        "Simulator"
        "dart"
        "flutter"
        "gradle"
        "java"
        "adb"
    )

    for process in "${processes[@]}"; do
        pkill -f "$process" 2>/dev/null || true
    done

    success "Developer processes stopped."
}

# ============================================================
# IntelliJ IDEA
# ============================================================

remove_intellij() {

    section "Removing IntelliJ IDEA"

    remove_path "/Applications/IntelliJ IDEA.app"
    remove_path "/Applications/IntelliJ IDEA CE.app"
    remove_path "/Applications/IntelliJ IDEA Community Edition.app"

    remove_glob "$HOME/Library/Preferences/IntelliJIdea*"
    remove_glob "$HOME/Library/Caches/JetBrains/IntelliJIdea*"
    remove_glob "$HOME/Library/Application Support/JetBrains/IntelliJIdea*"
    remove_glob "$HOME/Library/Logs/JetBrains/IntelliJIdea*"

    remove_glob "$HOME/Library/Saved Application State/com.jetbrains.intellij*"
    remove_glob "$HOME/Library/WebKit/com.jetbrains.intellij*"
    remove_glob "$HOME/Library/HTTPStorages/com.jetbrains.intellij*"

    # JetBrains Toolbox IDEA installations
    remove_glob "$HOME/Library/Application Support/JetBrains/Toolbox/apps/IDEA*"

    success "IntelliJ IDEA cleanup complete."
}

# ============================================================
# Android Studio
# ============================================================

remove_android_studio() {

    section "Removing Android Studio"

    remove_path "/Applications/Android Studio.app"

    remove_path "$HOME/Library/Application Support/Google/AndroidStudio"
    remove_glob "$HOME/Library/Application Support/Google/AndroidStudio*"

    remove_glob "$HOME/Library/Caches/Google/AndroidStudio*"
    remove_glob "$HOME/Library/Logs/AndroidStudio*"

    remove_glob "$HOME/Library/Preferences/AndroidStudio*"
    remove_glob "$HOME/Library/Saved Application State/com.google.android.studio*"

    remove_path "$HOME/.android"

    # Android SDK
    if [ -d "$HOME/Library/Android/sdk" ]; then
        if confirm "Remove Android SDK ($HOME/Library/Android/sdk)?"; then
            remove_path "$HOME/Library/Android/sdk"
        fi
    fi

    # Emulator data
    remove_path "$HOME/.android/avd"

    # Gradle
    if [ -d "$HOME/.gradle" ]; then
        if confirm "Remove Gradle cache (~/.gradle)?"; then
            remove_path "$HOME/.gradle"
        fi
    fi

    success "Android Studio cleanup complete."
}

# ============================================================
# Visual Studio Code
# ============================================================

remove_vscode() {

    section "Removing Visual Studio Code"

    remove_path "/Applications/Visual Studio Code.app"

    # User settings / extensions
    remove_path "$HOME/Library/Application Support/Code"
    remove_path "$HOME/Library/Application Support/Code - Insiders"

    # Caches
    remove_path "$HOME/Library/Caches/com.microsoft.VSCode"
    remove_path "$HOME/Library/Caches/com.microsoft.VSCode.ShipIt"

    remove_path "$HOME/Library/Caches/Code"
    remove_path "$HOME/Library/Caches/Code - Insiders"

    # Preferences
    remove_path "$HOME/Library/Preferences/com.microsoft.VSCode.plist"
    remove_path "$HOME/Library/Preferences/com.microsoft.VSCodeInsiders.plist"

    # Saved state
    remove_path "$HOME/Library/Saved Application State/com.microsoft.VSCode.savedState"
    remove_path "$HOME/Library/Saved Application State/com.microsoft.VSCodeInsiders.savedState"

    # Logs
    remove_path "$HOME/Library/Logs/Code"
    remove_path "$HOME/Library/Logs/Code - Insiders"

    success "Visual Studio Code cleanup complete."
}

# ============================================================
# Antigravity
# ============================================================

remove_antigravity() {

    section "Removing Antigravity IDE"

    remove_path "/Applications/Antigravity.app"

    remove_path "$HOME/Library/Application Support/Antigravity"
    remove_path "$HOME/Library/Caches/Antigravity"
    remove_path "$HOME/Library/Logs/Antigravity"

    remove_path "$HOME/Library/Preferences/com.antigravity.plist"
    remove_path "$HOME/Library/Saved Application State/com.antigravity.savedState"

    # Electron-style storage
    remove_path "$HOME/Library/Application Support/antigravity"
    remove_path "$HOME/Library/Caches/antigravity"
    remove_path "$HOME/Library/Logs/antigravity"

    success "Antigravity cleanup complete."
}

# ============================================================
# Xcode
# ============================================================

remove_xcode() {

    section "Removing Xcode"

    remove_path "/Applications/Xcode.app"

    # Xcode developer data
    remove_path "$HOME/Library/Developer/Xcode/DerivedData"
    remove_path "$HOME/Library/Developer/Xcode/Archives"
    remove_path "$HOME/Library/Developer/Xcode/iOS DeviceSupport"
    remove_path "$HOME/Library/Developer/Xcode/watchOS DeviceSupport"
    remove_path "$HOME/Library/Developer/Xcode/tvOS DeviceSupport"
    remove_path "$HOME/Library/Developer/Xcode/macOS DeviceSupport"

    remove_path "$HOME/Library/Developer/CoreSimulator"

    # Xcode caches
    remove_path "$HOME/Library/Caches/com.apple.dt.Xcode"
    remove_path "$HOME/Library/Logs/CoreSimulator"

    # Xcode preferences
    remove_path "$HOME/Library/Preferences/com.apple.dt.Xcode.plist"

    # Archives / developer data
    remove_path "$HOME/Library/Developer/Xcode"

    # iOS Simulator
    if command -v xcrun >/dev/null 2>&1; then
        xcrun simctl shutdown all 2>/dev/null || true
    fi

    success "Xcode cleanup complete."
}

# ============================================================
# Flutter
# ============================================================

remove_flutter() {

    section "Removing Flutter"

    # Common Flutter SDK locations
    local flutter_paths=(
        "$HOME/flutter"
        "$HOME/development/flutter"
        "$HOME/dev/flutter"
        "$HOME/tools/flutter"
        "$HOME/SDK/flutter"
        "$HOME/fvm"
    )

    for path in "${flutter_paths[@]}"; do
        if [ -d "$path" ]; then
            if confirm "Remove Flutter directory: $path?"; then
                remove_path "$path"
            fi
        fi
    done

    # FVM
    remove_path "$HOME/.fvm"

    # Flutter / Dart caches
    remove_path "$HOME/.flutter"
    remove_path "$HOME/.dart"
    remove_path "$HOME/.dart-tool"

    # Pub cache
    if [ -d "$HOME/.pub-cache" ]; then
        if confirm "Remove Dart/Flutter Pub cache (~/.pub-cache)?"; then
            remove_path "$HOME/.pub-cache"
        fi
    fi

    success "Flutter cleanup complete."
}

# ============================================================
# CocoaPods
# ============================================================

remove_cocoapods() {

    section "Removing CocoaPods"

    # CocoaPods cache
    if command -v pod >/dev/null 2>&1; then
        info "CocoaPods detected: $(pod --version 2>/dev/null || echo unknown)"
    fi

    remove_path "$HOME/.cocoapods"

    # CocoaPods cache locations
    remove_path "$HOME/Library/Caches/CocoaPods"
    remove_path "$HOME/Library/Developer/Xcode/DerivedData"

    # Homebrew CocoaPods
    if command -v brew >/dev/null 2>&1; then
        if brew list --formula 2>/dev/null | grep -qx "cocoapods"; then
            if confirm "Uninstall CocoaPods installed via Homebrew?"; then
                brew uninstall cocoapods
            fi
        fi
    fi

    # Ruby gem installation
    if command -v gem >/dev/null 2>&1; then
        if gem list --local 2>/dev/null | grep -q "^cocoapods "; then
            if confirm "Remove CocoaPods Ruby gems?"; then
                gem uninstall cocoapods cocoapods-core -aIx 2>/dev/null || true
            fi
        fi
    fi

    success "CocoaPods cleanup complete."
}

# ============================================================
# Developer Package Caches
# ============================================================

remove_package_caches() {

    section "Removing Developer Package Caches"

    # Node.js / npm
    if command -v npm >/dev/null 2>&1; then
        if confirm "Clean npm cache?"; then
            npm cache clean --force 2>/dev/null || true
            success "npm cache cleaned."
        fi
    fi

    # Yarn
    if command -v yarn >/dev/null 2>&1; then
        if confirm "Clean Yarn cache?"; then
            yarn cache clean 2>/dev/null || true
            success "Yarn cache cleaned."
        fi
    fi

    # pnpm
    if command -v pnpm >/dev/null 2>&1; then
        if confirm "Clean pnpm store?"; then
            pnpm store prune 2>/dev/null || true
            success "pnpm store cleaned."
        fi
    fi

    # Maven
    if [ -d "$HOME/.m2/repository" ]; then
        if confirm "Remove Maven dependency cache (~/.m2/repository)?"; then
            remove_path "$HOME/.m2/repository"
        fi
    fi

    # Gradle
    if [ -d "$HOME/.gradle" ]; then
        if confirm "Remove Gradle cache (~/.gradle)?"; then
            remove_path "$HOME/.gradle"
        fi
    fi

    success "Developer package caches cleaned."
}

# ============================================================
# Homebrew Developer Packages
# ============================================================

remove_homebrew_dev_tools() {

    section "Removing Homebrew Developer Packages"

    if ! command -v brew >/dev/null 2>&1; then
        warning "Homebrew is not installed."
        return
    fi

    local packages=(
        cocoapods
        flutter
        dart
        gradle
        maven
        android-platform-tools
    )

    for package in "${packages[@]}"; do

        if brew list --formula 2>/dev/null | grep -qx "$package"; then

            if confirm "Uninstall Homebrew package: $package?"; then
                brew uninstall "$package" 2>/dev/null || true
                success "Removed Homebrew package: $package"
            fi

        fi

    done

    # Homebrew cache
    if confirm "Clean Homebrew download/cache files?"; then
        brew cleanup -s 2>/dev/null || true
        success "Homebrew caches cleaned."
    fi
}

# ============================================================
# Global Developer Cache Cleanup
# ============================================================

remove_global_caches() {

    section "Removing Global Developer Caches"

    local paths=(
        "$HOME/Library/Caches/JetBrains"
        "$HOME/Library/Logs/JetBrains"
        "$HOME/Library/Application Support/JetBrains"
        "$HOME/Library/Caches/com.google.android.studio"
        "$HOME/Library/Caches/Google"
        "$HOME/Library/Logs/Google"
        "$HOME/Library/Caches/com.microsoft.VSCode"
        "$HOME/Library/Caches/com.microsoft.VSCode.ShipIt"
        "$HOME/Library/Logs/VSCode"
        "$HOME/Library/Caches/org.videolan"
    )

    for path in "${paths[@]}"; do
        remove_path "$path"
    done

    success "Global developer caches cleaned."
}

# ============================================================
# PATH Cleanup
# ============================================================

show_path_cleanup() {

    section "PATH Cleanup Check"

    echo
    echo "This script will NOT automatically modify your shell configuration."
    echo
    echo "Review these files manually for old entries:"
    echo
    echo "  ~/.zshrc"
    echo "  ~/.zprofile"
    echo "  ~/.bash_profile"
    echo "  ~/.bashrc"
    echo
    echo "Look for entries containing:"
    echo
    echo "  flutter"
    echo "  dart"
    echo "  android-sdk"
    echo "  Android/sdk"
    echo "  cmdline-tools"
    echo "  platform-tools"
    echo "  cocoapods"
    echo "  gradle"
    echo
}

# ============================================================
# Launch Services
# ============================================================

refresh_launch_services() {

    section "Refreshing macOS Launch Services"

    local lsregister

    lsregister="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"

    if [ -x "$lsregister" ]; then
        "$lsregister" \
            -kill \
            -r \
            -domain local \
            -domain system \
            -domain user \
            >/dev/null 2>&1 || true

        success "Launch Services database refreshed."
    fi
}

# ============================================================
# Disk Usage
# ============================================================

show_disk_usage() {

    section "Developer Directory Disk Usage"

    echo

    du -sh \
        "$HOME/Library/Developer" \
        "$HOME/Library/Application Support/JetBrains" \
        "$HOME/Library/Android" \
        "$HOME/.gradle" \
        "$HOME/.pub-cache" \
        "$HOME/.m2" \
        "$HOME/.android" \
        "$HOME/.cocoapods" \
        2>/dev/null || true

    echo
}

# ============================================================
# Menu
# ============================================================

show_menu() {

    echo
    echo "============================================================"
    echo "                  Developer Cleanup Menu"
    echo "============================================================"
    echo
    echo "  1) IntelliJ IDEA"
    echo "  2) Android Studio"
    echo "  3) Visual Studio Code"
    echo "  4) Antigravity"
    echo "  5) Xcode"
    echo "  6) Flutter"
    echo "  7) CocoaPods"
    echo "  8) Developer Package Caches"
    echo "  9) Homebrew Developer Tools"
    echo " 10) Global Developer Caches"
    echo " 11) Show PATH Cleanup"
    echo " 12) Show Developer Disk Usage"
    echo
    echo "  A) Remove ALL developer environments"
    echo "  Q) Quit"
    echo
}

# ============================================================
# Remove All
# ============================================================

remove_all() {

    section "REMOVE ALL DEVELOPER ENVIRONMENTS"

    echo
    warning "This is the destructive option."
    echo
    echo "It can remove:"
    echo
    echo "  • IntelliJ IDEA"
    echo "  • Android Studio"
    echo "  • Android SDK + Emulator data"
    echo "  • Visual Studio Code"
    echo "  • Antigravity"
    echo "  • Xcode"
    echo "  • iOS Simulator data"
    echo "  • Flutter SDK"
    echo "  • Dart / Pub cache"
    echo "  • CocoaPods"
    echo "  • Gradle / Maven caches"
    echo "  • npm / Yarn / pnpm caches"
    echo "  • Homebrew developer packages"
    echo "  • JetBrains / Google / Microsoft caches"
    echo

    warning "SOURCE CODE PROJECTS ARE NOT REMOVED."
    echo

    read -r -p "Type REMOVE to continue: " confirmation

    if [ "$confirmation" != "REMOVE" ]; then
        warning "Operation cancelled."
        return
    fi

    stop_processes

    remove_intellij
    remove_android_studio
    remove_vscode
    remove_antigravity
    remove_xcode
    remove_flutter
    remove_cocoapods
    remove_package_caches
    remove_homebrew_dev_tools
    remove_global_caches

    refresh_launch_services
    show_path_cleanup

    section "Cleanup Complete"

    success "Developer environment cleanup completed."
    echo
    warning "Restart macOS for the cleanest result."
    echo
}

# ============================================================
# Main
# ============================================================

while true; do

    show_menu

    read -r -p "Select an option: " choice

    case "$choice" in

        1)
            stop_processes
            remove_intellij
            ;;

        2)
            stop_processes
            remove_android_studio
            ;;

        3)
            stop_processes
            remove_vscode
            ;;

        4)
            stop_processes
            remove_antigravity
            ;;

        5)
            stop_processes
            remove_xcode
            ;;

        6)
            stop_processes
            remove_flutter
            ;;

        7)
            remove_cocoapods
            ;;

        8)
            remove_package_caches
            ;;

        9)
            remove_homebrew_dev_tools
            ;;

        10)
            remove_global_caches
            ;;

        11)
            show_path_cleanup
            ;;

        12)
            show_disk_usage
            ;;

        [Aa])
            remove_all
            ;;

        [Qq])
            echo
            info "Goodbye."
            exit 0
            ;;

        *)
            warning "Invalid option."
            ;;

    esac

    echo
    read -r -p "Press Enter to return to the menu..."

done