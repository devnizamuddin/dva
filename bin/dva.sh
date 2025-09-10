#!/bin/bash
# DVA CLI - Developer Workflow Automation
# MIT License (c) 2025 Nizam Uddin Shamrat


#*
#* ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
#* ║                                   💰 Imported Files                                              ║
#* ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝
#*


DVA_HOME="$HOME/.dva"


#* ==========================> 🧾 All Source Files
# Utils Import 
source "$DVA_HOME/scripts/sources/utils_source.sh"
# Tasks Import
source "$DVA_HOME/scripts/sources/tasks_source.sh"
# Components Import
source "$DVA_HOME/scripts/components/menu_ui.sh"
# Components Import
source "$DVA_HOME/scripts/sources/menu_source.sh"
#* ===========================> 🧾 Main CLI Import
source "$DVA_HOME/scripts/dva_cli.sh"

clear

#*
#* ┏==================================================================================================┓
#* ┃                                   📖 CLI Starting Point                                          ┃
#* ┗==================================================================================================┛
#*

# Metadata
VERSION="1.0.1"

# Help function
function show_help() {
  echo "✨ DVA CLI v$VERSION ✨"
  echo ""
  echo "Usage: dva <command> [options]"
  echo ""
  echo "Commands:"
  echo "  flutter    Manage Flutter tasks"
  echo "  note       Manage notes"
  echo "  git        Git related tasks"
  echo "  text       Text related tasks"
  echo "  help       Show this help"
  echo ""
  echo "👉 Try: dva flutter build"
}

# Subcommand dispatcher
case "${1:-}" in
  flutter)
    shift
    execute_flutter_menu
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
    ;;
  text)
    shift
    run_text_case_converter
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


    

