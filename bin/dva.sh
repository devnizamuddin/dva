#!/bin/bash

DVA_HOME="$HOME/.dva"
export DVA_DATA_DIR="$DVA_HOME/data"


# * ===========================================================
# * ⚙️ Configuration CLI                                         
# * ===========================================================
[[ -n "${_DVA_MAIN_LOADED+x}" ]] && return 0
_DVA_MAIN_LOADED=1

# * ===========================================================
# * 💰 Importing Bootstrap                                             
# * ===========================================================
source "$DVA_HOME/lib/core/bootstrap.sh"
clear


# * > ┏=┓========================================================================================================================┏=┓
# * > ┃ ┃                                          📖 Starting DVA CLI                                                           ┃ ┃
# * > ┗=┛========================================================================================================================┗=┛

function run_script() {
    local script_path="$1"

    # * Check if file exists
    if [ ! -f "$script_path" ]; then
        echo "❌ Error: File '$script_path' does not exist."
        return 1
    fi

    # * Give execute permission
    chmod +x "$script_path"

    # * Run the script
    echo "▶️ Running $script_path"
    "$script_path"
}
# * ===========================================================
# * 📖 Help command
# * ===========================================================
function show_help() {
  echo ""
  echo -e " ${BOLD}${CYAN}✨ DVA CLI v$VERSION ✨${NC}"
  echo -e " ${DIM}Developer Workflow Automation${NC}"
  echo ""
  echo -e " ${BOLD}Usage:${NC} dva <command> [options]"
  echo ""
  
  echo -e " ${BLUE}╭───────────────────────────────────────────────╮${NC}"
  echo -e " ${BLUE}│${NC}  ${BOLD}${MAGENTA}🐙 GIT COMMANDS${NC}                            ${BLUE}│${NC}"
  echo -e " ${BLUE}│${NC}  ${GREEN}git${NC}      Interactive Git Menu              ${BLUE}│${NC}"
  echo -e " ${BLUE}│${NC}  ${GREEN}commit${NC}   Stage, Select Prefix, Commit      ${BLUE}│${NC}"
  echo -e " ${BLUE}│${NC}  ${GREEN}merge${NC}    Interactive Branch Merge          ${BLUE}│${NC}"
  echo -e " ${BLUE}│${NC}  ${GREEN}sync${NC}     Auto-stash, Pull, & Push          ${BLUE}│${NC}"
  echo -e " ${BLUE}│${NC}  ${GREEN}audit${NC}    Compare & Clean Stale Branches    ${BLUE}│${NC}"
  echo -e " ${BLUE}│${NC}  ${GREEN}log${NC}      Visual Commit History             ${BLUE}│${NC}"
  echo -e " ${BLUE}├───────────────────────────────────────────────┤${NC}"
  echo -e " ${BLUE}│${NC}  ${BOLD}${CYAN}📱 APP & DEPLOYMENT${NC}                        ${BLUE}│${NC}"
  echo -e " ${BLUE}│${NC}  ${GREEN}flutter${NC}  Manage Flutter Tasks              ${BLUE}│${NC}"
  echo -e " ${BLUE}│${NC}  ${GREEN}deploy${NC}   Build app [web, apk, ios]         ${BLUE}│${NC}"
  echo -e " ${BLUE}│${NC}  ${GREEN}cleanup${NC}  Clean project [macos|android|ios|web] ${BLUE}│${NC}"
  echo -e " ${BLUE}├───────────────────────────────────────────────┤${NC}"
  echo -e " ${BLUE}│${NC}  ${BOLD}${YELLOW}🛠️  UTILITIES${NC}                              ${BLUE}│${NC}"
  echo -e " ${BLUE}│${NC}  ${GREEN}note${NC}     Manage Sticky Notes               ${BLUE}│${NC}"
  echo -e " ${BLUE}│${NC}  ${GREEN}text${NC}     Convert Text Case (to clipboard)  ${BLUE}│${NC}"
  echo -e " ${BLUE}│${NC}  ${GREEN}help${NC}     Show this help screen             ${BLUE}│${NC}"
  echo -e " ${BLUE}╰───────────────────────────────────────────────╯${NC}"
  echo ""
  echo -e " 👉 ${BOLD}Try:${NC} dva flutter"
  echo ""
}

# * > ┏=┓=======================================================================================================================┏=┓
# * > ┃ ┃                                          📖 Subcommand dispatcher                                                     ┃ ┃
# * > ┗=┛=======================================================================================================================┗=┛

case "${1:-}" in
# ==============================
# * Core source
# ==============================
  source)
    shift
    launch_source "$1"
    ;;
# ==============================
# * Flutter
# ==============================
  flutter)
    shift
    execute_flutter_menu
    ;;
# ==============================
# * Release
# ==============================
  release)
    shift
    case "${1:-}" in
      apk)
        deployingAndroid
        ;;
      ios)
        echo "🚀 Building Flutter iOS..."
        ;;
      web)
        deployingWeb
        ;;
      macos)
        echo "🚀 Building Flutter macOS..."
        buildingMacOsApp
        ;;
      *)
        echo "⚠️ Unknown build target. Available: web, apk, ios, macos, windows"
        ;;
    esac
    ;;
# ==============================
# * Cleanup
# ==============================
  cleanup)
    shift
    case "${1:-}" in
      macos)
        rm -rf build/macos/Build/Products/Debug/NUS\ Assistant.app
        _cleanup_flutter "macos"
        ;;
      android)
        rm -rf build/app/outputs
        _cleanup_flutter "android"
        ;;
      ios)
        rm -rf build/ios/iphoneos
        rm -rf build/ios/Release-iphoneos
        _cleanup_flutter "ios"
        ;;
      web)
        rm -rf build/web
        _cleanup_flutter "web"
        ;;
      *)
        echo "⚠️ Unknown cleanup target. Available: macos, android, ios, web"
        ;;
    esac
    ;;
# ==============================
# * Note
# ==============================
  note)
    shift
    run_note_menu
    ;;
# ==============================
# * Git
# ==============================
  git)
    shift
    run_git_commands
    ;;
# ==============================
# * Git Commit
# ==============================
  commit)
    shift
    stage_all_files
    commit_all_staged_files
    push_unpushed_commits
    ;;
# ==============================
# * Git Merge
# ==============================
  merge)
    shift
    merge_branches "$1" "$2"
    ;;
# ==============================
# * Git Audit
# ==============================
  audit)
    shift
    audit_git_branches "$@"
    ;;
# ==============================
# * Git Log
# ==============================
  log)
    shift
    show_commit_history "$@"
    ;;
# ==============================
# * Git Sync
# ==============================
  sync)
    shift
    pull_current_branch
    push_unpushed_commits
    ;;
# ==============================
# * Text
# ==============================
  text)
    shift
    run_text_case_converter
    ;;
# ==============================
# * Run script
# ==============================
  run)
    shift
    run_script "$1"
    ;;
# ==============================
# * Help
# ==============================
  help)
    show_help
    ;;
# ==============================
# * No argument
# ==============================
  "")
    run_dva_cli
    ;;
# ==============================
# * Unknown command
# ==============================
  *)
    #* > Show help
    show_help
    exit 1
    ;;
esac
