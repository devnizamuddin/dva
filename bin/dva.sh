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
VERSION="1.0.5"

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
  echo "  text       Text related tasks"
  echo "  help       Show this help"
  echo ""
  echo "👉 Try: dva flutter build"
}

function deployingWeb() {
  upgradeProjectVersion

  current_version=$(grep '^version:' pubspec.yaml | awk '{print $2}')

  version_name=$(echo "$current_version" | cut -d'+' -f1)
  version_code=$(echo "$current_version" | cut -d'+' -f2)
  echo ""
  echo "🆕 Commit files git"
  echo ""
  git add .
  git commit -m "📲 Deploy: v-$version_name+$version_code"
  echo ""
  echo "🏷️  Adding Tag-$version_name"
  echo ""
  git tag "release-$version_name"
  echo ""
  echo "🚀 Pushing commit and tag to origin"
  echo ""
  git push origin HEAD         # push the commit
  git push origin "release-$version_name"  # push the tag
  echo ""
  echo -e "✅ Pushed Flutter Web with tag: release-$version_name"
  echo ""
}


# Subcommand dispatcher
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
        echo "🚀 Building Flutter APK..."
        # flutter build apk
        ;;
      ios)
        echo "🚀 Building Flutter iOS..."
        # flutter build ios
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
