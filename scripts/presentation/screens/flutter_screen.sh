#!/bin/bash
# Import the common menu UI functions
# source ./scripts/presentation/components/menu_ui.sh

# ===============================
# Define Menu Data
# ===============================

function run_flutter(){
# Menu title
TITLE="Flutter Features"

# Menu options (list of strings)
OPTIONS=(
  "Build Project"
  "Clean Project"
  "Release Android App"
  "Release iOS App"
  "Create Project In CLEAN Architecture"
  "Create Project In MVVM Architecture"
)

# ===============================
# Define Actions for Each Option
# ===============================

action_1() { echo "🚀 Building project..."; }
action_2() { echo "🧹 Cleaning project..."; }
action_3() { echo "📦 Releasing Android app..."; }
action_4() { echo "🍎 Releasing iOS app..."; }
action_5() { echo "📂 Creating CLEAN Architecture project..."; }
action_6() { echo "📂 Creating MVVM Architecture project..."; }

# ===============================
# Start Menu Loop
# ===============================
menu_loop "$TITLE" "${OPTIONS[@]}"

}

