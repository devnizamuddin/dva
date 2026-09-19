#!/bin/bash

[[ -n "${_DVA_GIT_MANAGER_LOADED+x}" ]] && return 0
_DVA_GIT_MANAGER_LOADED=1

#* ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
#* ║                                   💰 Imported Files                                              ║
#* ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝

source "$DVA_HOME/lib/features/git/stage_manager.sh"
source "$DVA_HOME/lib/features/git/commit_manager.sh"
source "$DVA_HOME/lib/features/git/push_manager.sh"
source "$DVA_HOME/lib/features/git/pull_manager.sh"
source "$DVA_HOME/lib/features/git/branch_manager.sh"
source "$DVA_HOME/lib/features/git/history_manager.sh"
source "$DVA_HOME/lib/features/git/audit_manager.sh"
source "$DVA_HOME/lib/features/git/merge_report_manager.sh"

#* ┏==================================================================================================┓
#* ┃                                  🔧 Git Menu: Options & Actions                                 ┃
#* ┗==================================================================================================┛
#*

# Menu Title
GIT_TITLE="Git Commands"

# Menu Options
GIT_OPTIONS=(
  "Stage Files" # MENU_1
  "Stage All Files" # MENU_2
  "Unstage Files" # MENU_3
  "Unstage All File" # MENU_4
  "Commit Staged Files" # MENU_5
  "Push Commits" # MENU_6
  "Pull From Branch" # MENU_7
  "Commit History" # MENU_8
  "Audit Branches" # MENU_9
  "Merge Report" # MENU_10
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
  pull_from_choosen_branch
}

function git_action_8() {
  show_commit_history
}

function git_action_9() {
  audit_git_branches
}

function git_action_10() {
  run_merge_report
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



# * ┏==================================================================================================┓
# * ┃                            📖 External Scripts loaded via Bootstrap                              ┃
# * ┗==================================================================================================┛