#!/bin/bash

# ============================================================
# macOS Complete App & Leftover Cleanup Tool
#
# Targets:
#   • Figma Agent
#   • Kahf Browser
#
# Searches for and removes:
#   • Applications
#   • Application Support
#   • Caches
#   • Preferences
#   • Logs
#   • Saved Application State
#   • WebKit / HTTP Storage
#   • Containers
#   • Group Containers
#   • Crash reports
#   • LaunchAgents / LaunchDaemons
#
# Your personal documents and source projects are NOT targeted.
# ============================================================

set -u

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'

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
    echo -e "${CYAN}============================================================${RESET}"
    echo -e "${CYAN}$1${RESET}"
    echo -e "${CYAN}============================================================${RESET}"
}

confirm() {
    local message="$1"

    read -r -p "$message [y/N]: " answer

    [[ "$answer" =~ ^[Yy]$ ]]
}

remove_item() {
    local path="$1"

    if [[ -e "$path" || -L "$path" ]]; then
        rm -rf "$path"
        success "Removed: $path"
    fi
}

# ------------------------------------------------------------
# Safety Check
# ------------------------------------------------------------

if [[ "$(id -u)" -eq 0 ]]; then
    error "Do not run this script with sudo."
    error "Run it from your normal macOS user account."
    exit 1
fi

# ------------------------------------------------------------
# Banner
# ------------------------------------------------------------

clear

echo
echo "============================================================"
echo "         macOS Complete Application Cleanup Tool"
echo "============================================================"
echo
echo "This tool searches for leftover files from:"
echo
echo "  1) Figma Agent"
echo "  2) Kahf Browser"
echo
warning "You will review discovered files before deletion."
echo

# ------------------------------------------------------------
# Stop Related Processes
# ------------------------------------------------------------

stop_processes() {

    section "Stopping Related Processes"

    local processes=(
        "Figma"
        "Figma Agent"
        "Kahf"
        "Kahf Browser"
    )

    for process in "${processes[@]}"; do
        pkill -f "$process" 2>/dev/null || true
    done

    success "Related processes stopped."
}

# ------------------------------------------------------------
# Search Function
# ------------------------------------------------------------

search_app_files() {

    local keyword="$1"

    section "Searching for: $keyword"

    local locations=(
        "/Applications"
        "$HOME/Applications"
        "$HOME/Library/Application Support"
        "$HOME/Library/Caches"
        "$HOME/Library/Preferences"
        "$HOME/Library/Logs"
        "$HOME/Library/Saved Application State"
        "$HOME/Library/WebKit"
        "$HOME/Library/HTTPStorages"
        "$HOME/Library/Containers"
        "$HOME/Library/Group Containers"
        "$HOME/Library/LaunchAgents"
        "$HOME/Library/Preferences"
        "$HOME/Library/DiagnosticReports"
    )

    FOUND_ITEMS=()

    for location in "${locations[@]}"; do

        if [[ -d "$location" ]]; then

            while IFS= read -r item; do
                FOUND_ITEMS+=("$item")
            done < <(
                find "$location" \
                    -maxdepth 3 \
                    -iname "*${keyword}*" \
                    2>/dev/null
            )

        fi

    done

    if [[ ${#FOUND_ITEMS[@]} -eq 0 ]]; then
        warning "No files found containing: $keyword"
        return
    fi

    echo
    info "Found ${#FOUND_ITEMS[@]} item(s):"
    echo

    local index=1

    for item in "${FOUND_ITEMS[@]}"; do
        echo "  [$index] $item"
        ((index++))
    done

    echo
}

# ------------------------------------------------------------
# Delete Found Items
# ------------------------------------------------------------

delete_found_items() {

    if [[ ${#FOUND_ITEMS[@]} -eq 0 ]]; then
        return
    fi

    echo

    if ! confirm "Remove ALL listed items?"; then
        warning "Deletion cancelled."
        return
    fi

    echo

    for item in "${FOUND_ITEMS[@]}"; do
        remove_item "$item"
    done
}

# ============================================================
# Figma Agent Cleanup
# ============================================================

cleanup_figma() {

    stop_processes

    section "Figma Agent Cleanup"

    FOUND_ITEMS=()

    search_app_files "figma"

    echo
    warning "Review the list carefully."
    warning "This may include other Figma-related components."

    delete_found_items

    # Additional common locations
    section "Removing Known Figma Locations"

    local paths=(
        "/Applications/Figma.app"
        "$HOME/Applications/Figma.app"

        "$HOME/Library/Application Support/Figma"
        "$HOME/Library/Application Support/FigmaAgent"

        "$HOME/Library/Caches/Figma"
        "$HOME/Library/Caches/com.figma.Desktop"

        "$HOME/Library/Logs/Figma"

        "$HOME/Library/Preferences/com.figma.Desktop.plist"

        "$HOME/Library/Saved Application State/com.figma.Desktop.savedState"

        "$HOME/Library/WebKit/com.figma.Desktop"
        "$HOME/Library/HTTPStorages/com.figma.Desktop"

        "$HOME/Library/LaunchAgents/com.figma.agent.plist"
    )

    for path in "${paths[@]}"; do
        remove_item "$path"
    done

    success "Figma cleanup finished."
}

# ============================================================
# Kahf Browser Cleanup
# ============================================================

cleanup_kahf() {

    stop_processes

    section "Kahf Browser Cleanup"

    FOUND_ITEMS=()

    search_app_files "kahf"

    delete_found_items

    success "Kahf Browser cleanup finished."
}

# ============================================================
# Search by Bundle Identifier
# ============================================================

search_bundle_ids() {

    section "Searching Application Bundle Identifiers"

    echo

    for app in \
        "/Applications/Figma.app" \
        "$HOME/Applications/Figma.app" \
        "/Applications/Kahf Browser.app" \
        "$HOME/Applications/Kahf Browser.app"
    do

        if [[ -d "$app" ]]; then

            info "Application: $app"

            bundle_id=$(
                /usr/libexec/PlistBuddy \
                -c "Print :CFBundleIdentifier" \
                "$app/Contents/Info.plist" \
                2>/dev/null || true
            )

            if [[ -n "$bundle_id" ]]; then
                echo "Bundle ID: $bundle_id"
            fi

            echo
        fi

    done
}

# ============================================================
# Search Entire User Library
# ============================================================

deep_search() {

    local keyword="$1"

    section "Deep Search: $keyword"

    echo
    warning "Searching your user Library. This may take a moment."
    echo

    find "$HOME/Library" \
        -iname "*${keyword}*" \
        2>/dev/null
}

# ============================================================
# Disk Usage
# ============================================================

show_size() {

    local keyword="$1"

    section "Checking Disk Usage: $keyword"

    find "$HOME/Library" \
        -iname "*${keyword}*" \
        -print0 2>/dev/null |
    while IFS= read -r -d '' item; do

        du -sh "$item" 2>/dev/null

    done
}

# ============================================================
# Refresh Launch Services
# ============================================================

refresh_launch_services() {

    section "Refreshing macOS Application Database"

    local lsregister

    lsregister="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"

    if [[ -x "$lsregister" ]]; then

        "$lsregister" \
            -kill \
            -r \
            -domain local \
            -domain system \
            -domain user \
            >/dev/null 2>&1 || true

        success "Launch Services refreshed."
    fi
}

# ============================================================
# Menu
# ============================================================

while true; do

    echo
    echo "============================================================"
    echo "                    CLEANUP MENU"
    echo "============================================================"
    echo
    echo "  1) Completely remove Figma / Figma Agent"
    echo "  2) Completely remove Kahf Browser"
    echo
    echo "  3) Search for Figma leftovers"
    echo "  4) Search for Kahf leftovers"
    echo
    echo "  5) Deep search user Library"
    echo "  6) Check leftover disk usage"
    echo
    echo "  7) Refresh macOS Launch Services"
    echo
    echo "  A) Remove BOTH"
    echo "  Q) Quit"
    echo

    read -r -p "Select an option: " choice

    case "$choice" in

        1)
            cleanup_figma
            ;;

        2)
            cleanup_kahf
            ;;

        3)
            FOUND_ITEMS=()
            search_app_files "figma"
            ;;

        4)
            FOUND_ITEMS=()
            search_app_files "kahf"
            ;;

        5)
            echo
            read -r -p "Enter app name or keyword: " keyword

            if [[ -n "$keyword" ]]; then
                deep_search "$keyword"
            fi
            ;;

        6)
            echo
            read -r -p "Enter app name or keyword: " keyword

            if [[ -n "$keyword" ]]; then
                show_size "$keyword"
            fi
            ;;

        7)
            refresh_launch_services
            ;;

        [Aa])
            section "REMOVE BOTH APPLICATIONS"

            warning "This will remove Figma and Kahf-related files."
            echo

            if confirm "Continue"; then

                cleanup_figma
                cleanup_kahf

                refresh_launch_services

                section "Cleanup Complete"

                success "Selected application remnants have been removed."
            else
                warning "Cancelled."
            fi
            ;;

        [Qq])
            echo
            success "Cleanup tool closed."
            exit 0
            ;;

        *)
            error "Invalid option."
            ;;

    esac

    echo
    read -r -p "Press Enter to return to the menu..."

done