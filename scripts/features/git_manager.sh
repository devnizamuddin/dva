#!/bin/bash

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

action_1() {
  echo "📂 Checking Git status..."
  git status
}

action_2() {
  echo "➕ Adding all files..."
  git add .
  echo "✅ Files added"
}

action_3() {
  read -p "Enter commit message: " msg
  git commit -m "$msg"
}

action_4() {
  echo "⬆️  Pushing changes to remote..."
  git push
}

action_5() {
  echo "⬇️  Pulling latest changes..."
  git pull
}

action_6() {
  echo "📜 Showing Git log..."
  git log --oneline --graph --decorate --all | head -20
}

action_7() {
  echo "🔙 Going back to previous menu..."
  return 1   # Go back without exiting script
}

#* ┏==================================================================================================┓
#* ┃                               📖 Git Menu Loop                                                  ┃
#* ┗==================================================================================================┛
#*

function run_git_commands() {
  menu_loop "$GIT_TITLE" "${GIT_OPTIONS[@]}"
}
