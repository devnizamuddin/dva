#!/bin/bash


#* ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
#* ║                                   💰 Imported Files                                              ║
#* ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝

source "$DVA_HOME/scripts/features/flutter/file_manager.sh"

#* ┏==================================================================================================┓
#* ┃                           📖 Flutter Menu: Options & Actions                                    ┃
#* ┗==================================================================================================┛
#*


# Menu Title
FLUTTER_TITLE="Flutter Features"

# Menu Options
FLUTTER_OPTIONS=(
  "Clean Unnessery Resources"
  "Clean Project"
  "Release Android App"
  "Release iOS App"
  "Create Project In CLEAN Architecture"
  "Create Project In MVVM Architecture"
)

# Action functions for each menu option
function flutter_action_1() {
   clean_unnessery_resources
}

function flutter_action_2() { echo "🧹 Cleaning Flutter project..."; }

function flutter_action_3() { echo "📦 Releasing Android app..."; }

function flutter_action_4() { echo "🍎 Releasing iOS app..."; }

function flutter_action_5() { echo "📂 Creating CLEAN Architecture project..."; }

function flutter_action_6() { echo "📂 Creating MVVM Architecture project..."; }


#* ┏==================================================================================================┓
#* ┃                                 📖 Flutter Menu Loop                                           ┃
#* ┗==================================================================================================┛
#*


function execute_flutter_menu() {
  local ACTION_PREFIX="flutter"
  menu_loop "$ACTION_PREFIX" "$FLUTTER_TITLE" "${FLUTTER_OPTIONS[@]}"
}

