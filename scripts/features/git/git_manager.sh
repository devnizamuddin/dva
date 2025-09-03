#!/bin/bash


#* ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
#* ║                                   💰 Imported Files                                              ║
#* ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝


source "$DVA_HOME/scripts/features/git/stage_manager.sh"
source "$DVA_HOME/scripts/features/git/commit_manager.sh"

#* ┏==================================================================================================┓
#* ┃                                  🔧 Git Menu: Options & Actions                                 ┃
#* ┗==================================================================================================┛
#*

# Menu Title
GIT_TITLE="Git Commands"

# Menu Options
GIT_OPTIONS=(
  "Stage Choosen Files"
  "Stage All Files"
  "Unstage Choosen Files"
  "Unstage All File"
  "Commit All Staged Files"
  "Push Unpushed Commits"
  "Back"
)

#* ┏==================================================================================================┓
#* ┃                              📖 Git Action Functions                                            ┃
#* ┗==================================================================================================┛
#*

function git_action_1() {
  stage_choosen_files
}

function git_action_2() {
  stage_all_files
}

function git_action_3() {
  unstage_choosen_files
}

function git_action_4() {
  unstage_all_files
}

function git_action_5() {
  commit_all_staged_files
}

function git_action_6() {
  push_unpushed_commits
}

function git_action_7() {
  echo "🔙 Going back to previous menu..."
  return 1   # Go back without exiting script
}

#* ┏==================================================================================================┓
#* ┃                               📖 Git Menu Loop                                                  ┃
#* ┗==================================================================================================┛
#*

function run_git_commands() {

  show_all_file_changes_as_numbered_list
  # printf "${RESET} "
  line_gap

  local ACTION_PREFIX="git"
  menu_loop "$ACTION_PREFIX" "$GIT_TITLE" "${GIT_OPTIONS[@]}"
}
