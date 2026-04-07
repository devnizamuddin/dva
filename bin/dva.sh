#!/bin/bash
# * DVA CLI - Developer Workflow Automation
# * MIT License (c) 2025 Nizam Uddin Shamrat

# * ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
# * ║                                   💰 Imported Files                                              ║
# * ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝

DVA_HOME="$HOME/.dva"

# * ==========================> 🧾 All Source Files <========================== * #

# * Utils Import 
source "$DVA_HOME/scripts/sources/utils_source.sh"
# * Components Import
source "$DVA_HOME/scripts/components/menu_ui.sh"
# * Components Import
source "$DVA_HOME/scripts/sources/menu_source.sh"
# * Main CLI Import
source "$DVA_HOME/scripts/dva_cli.sh"

clear

# * ┏==================================================================================================┓
# * ┃                                   📖 CLI Starting Point                                          ┃
# * ┗==================================================================================================┛

# Metadata
VERSION="1.0.5"


function run_script() {
    local script_path="$1"

    # Check if file exists
    if [ ! -f "$script_path" ]; then
        echo "❌ Error: File '$script_path' does not exist."
        return 1
    fi

    # Give execute permission
    chmod +x "$script_path"

    # Run the script
    echo "▶️ Running $script_path"
    "$script_path"
}


# Help function
function show_help() {
  echo "✨ DVA CLI v$VERSION ✨"
  echo ""
  echo "Usage: dva <command> [options]"
  echo ""
  echo "Commands:"
  echo "  flutter    Manage Flutter tasks"
  echo "  build      Build Flutter targets (web, apk, ios)"
  echo "  note       Manage notes"
  echo "  git        Git related tasks"
  echo "  commit     Commit all changes and push"
  echo "  merge      Merge branches"
  echo "  sync       Sync branches (Pull & Push)"
  echo "  audit      Audit git branches"
  echo "  log        Show commit history"
  echo "  text       Text related tasks"
  echo "  help       Show this help"
  echo ""
  echo "👉 Try: dva flutter build"
}


# * ┏==================================================================================================┓
# * ┃                                 📖 Subcommand dispatcher                                         ┃
# * ┗==================================================================================================┛

case "${1:-}" in
  source)
    shift
    launch_source "$1"
    ;;
  flutter)
    shift
    execute_flutter_menu
    ;;
  deploy)
    shift
    case "${1:-}" in
      web)
        deployingWeb
        ;;
      apk)
        deployingAndroid
        ;;
      ios)
        echo "🚀 Building Flutter iOS..."
        ;;
      *)
        echo "⚠️ Unknown build target. Available: web, apk, ios"
        ;;
    esac
    ;;
  note)
    shift
    run_note_menu
    ;;
  git)
    shift
    run_git_commands
    ;;
  commit)
    shift
    stage_all_files
    commit_all_staged_files
    push_unpushed_commits
    ;;
  merge)
    shift
    merge_branches "$1" "$2"
    ;;
  audit)
    shift
    audit_git_branches "$@"
    ;;
  log)
    shift
    show_commit_history "$@"
    ;;
  sync)
    shift
    pull_current_branch
    push_unpushed_commits
    ;;
  text)
    shift
    run_text_case_converter
    ;;
  run)
    shift
    run_script "$1"
    ;;
  help)
    show_help
    ;;
    "")
    #* If no argument, show dva menus
    run_dva_cli
    ;;
  *)
    #* If the command is not recognized, show help
    show_help
    exit 1
    ;;
esac
