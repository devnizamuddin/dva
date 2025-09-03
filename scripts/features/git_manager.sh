#!/bin/bash


#* ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
#* ║                                   💰 Imported Files                                              ║
#* ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝


source "$DVA_HOME/scripts/features/nus_git.sh"

#* ┏==================================================================================================┓
#* ┃                                  🔧 Git Menu: Options & Actions                                 ┃
#* ┗==================================================================================================┛
#*

# Menu Title
GIT_TITLE="Git Commands"

# Menu Options
GIT_OPTIONS=(
  "Git Status"
  "Git Add (all)"
  "Git Commit"
  "Git Push"
  "Git Pull"
  "Git Log"
  "Back"
)

#* ┏==================================================================================================┓
#* ┃                              📖 Git Action Functions                                            ┃
#* ┗==================================================================================================┛
#*

function git_action_1() {
  echo "📂 Checking Git status..."
  run_git_operation
}

function git_action_2() {
  echo "➕ Adding all files..."
  git add .
  echo "✅ Files added"
}

function git_action_3() {
  read -p "Enter commit message: " msg
  git commit -m "$msg"
}

function git_action_4() {
  echo "⬆️  Pushing changes to remote..."
  git push
}

function git_action_5() {
  echo "⬇️  Pulling latest changes..."
  git pull
}

function git_action_6() {
  echo "📜 Showing Git log..."
  git log --oneline --graph --decorate --all | head -20
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
  local ACTION_PREFIX="git"
  menu_loop "$ACTION_PREFIX" "$GIT_TITLE" "${GIT_OPTIONS[@]}"
}
