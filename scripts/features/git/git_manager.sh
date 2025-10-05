#!/bin/bash

#* ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
#* ║                                   💰 Imported Files                                              ║
#* ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝

source "$DVA_HOME/scripts/features/git/stage_manager.sh"

source "$DVA_HOME/scripts/features/git/commit_manager.sh"

source "$DVA_HOME/scripts/features/git/push_manager.sh"

source "$DVA_HOME/scripts/features/git/pull_manager.sh"

source "$DVA_HOME/scripts/features/git/branch_manager.sh"

source "$DVA_HOME/scripts/features/git/history_manager.sh"

#* ┏==================================================================================================┓
#* ┃                                  🔧 Git Menu: Options & Actions                                 ┃
#* ┗==================================================================================================┛
#*

# Menu Title
GIT_TITLE="Git Commands"

# Menu Options
GIT_OPTIONS=(
  "Stage Choosen Files" # MENU_1
  "Stage All Files" # MENU_2
  "Unstage Choosen Files" # MENU_3
  "Unstage All File" # MENU_4
  "Commit All Staged Files" # MENU_5
  "Push Unpushed Commits" # MENU_6
  "Pull From Choosen Branch" # MENU_7
  "Show Commit History" # MENU_8
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



#* ┏==================================================================================================┓
#* ┃                            📖 Exit script added for upcomming use                                ┃
#* ┗==================================================================================================┛

#!/bin/bash

# ==========================================
# 🚀 Launch Project Git URL in Browser
# ==========================================

function launch_source() {
  # Read optional branch argument
  BRANCH_NAME="$1"

  # Ensure inside a git repo
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "❌ Not a git repository!"
    return 1
  fi

  # Get remote repo URL
  GIT_URL=$(git config --get remote.origin.url)
  if [ -z "$GIT_URL" ]; then
    echo "❌ No remote origin found!"
    return 1
  fi

  # Convert SSH → HTTPS if needed
  if [[ "$GIT_URL" == git@* ]]; then
    GIT_URL=$(echo "$GIT_URL" | sed -E 's#git@(.*):(.*)#https://\1/\2#')
  fi

  # Remove .git suffix
  GIT_URL=${GIT_URL%.git}

  # If branch provided, append to URL
  if [ -n "$BRANCH_NAME" ]; then
    GIT_URL="${GIT_URL}/tree/${BRANCH_NAME}"
  fi

  echo "🌐 Opening: $GIT_URL"

  # Open in default browser (macOS/Linux)
  if command -v open >/dev/null 2>&1; then
    open "$GIT_URL"
  elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$GIT_URL"
  else
    echo "⚠️ Please open manually: $GIT_URL"
  fi
}

# Run function




function exit_script() {
  echo -e "\n${RED}============================================${RESET}"
  echo -e "${RED}        -                                     ${RESET}"
  echo -e "${RED}       / \\                                   ${RESET}"
  echo -e "${RED}      /   \\                                  ${RESET}"
  echo -e "${RED}     /     \\        Exiting now...           ${RESET}"
  echo -e "${RED}    /_______\\                                ${RESET}"
  echo -e "${RED}    |       |                                 ${RESET}"
  echo -e "${RED}    |       |            o                    ${RESET}"
  echo -e "${RED}    |  Git  |          /|\\  -- -- -- -- - -  ${RESET}"
  echo -e "${RED}    |       |          / \\  -- -- -- - - -   ${RESET}"
  echo -e "${RED}    |_______|  -- -- -- -- -- -- -- - - -     ${RESET}"
  echo -e "${RED}==============================================${RESET}"
  echo ""
  exit 0
}