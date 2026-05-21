#!/bin/bash


# * ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
# * ║                                   💰 Imported Files                                              ║
# * ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝



source "$DVA_HOME/scripts/features/flutter/file_manager.sh"
source "$DVA_HOME/scripts/features/flutter/asset_manager.sh"
source "$DVA_HOME/scripts/features/flutter/release_application.sh"
source "$DVA_HOME/scripts/features/flutter/config_manager.sh"

#* ┏==================================================================================================┓
#* ┃                           📖 Flutter Menu: Options & Actions                                    ┃
#* ┗==================================================================================================┛
#*


# Menu Title
FLUTTER_TITLE="Flutter Features"

# Menu Options
FLUTTER_OPTIONS=(
  "Clean Unnessery Resources"
  "Upgrade Project Version"
  "Release Android App"
  "Release iOS App"
  "Create Project In CLEAN Architecture"
  "Create Project In MVVM Architecture"
  "Create Asset Constants"
)


#* ┏==================================================================================================┓
#* ┃                                   📖 Fuction for Options                                         ┃
#* ┗==================================================================================================┛


function flutter_action_1() {
  clean_unnessery_resources
}
function flutter_action_2() { 
  upgradeProjectVersion
 }

function flutter_action_3() { 
  echo "📦 Releasing Android app..."; }

function flutter_action_4() { 
  echo "🍎 Releasing iOS app..."; }

function flutter_action_5() { 
  echo "📂 Creating CLEAN Architecture project..."; }

function flutter_action_6() { 
  echo "📂 Creating MVVM Architecture project..."; }

function flutter_action_7() { 
  create_asset_constants; 
}


#* ┏==================================================================================================┓
#* ┃                                 📖 Flutter Menu Loop                                           ┃
#* ┗==================================================================================================┛
#*


function execute_flutter_menu() {
  local ACTION_PREFIX="flutter"
  menu_loop "$ACTION_PREFIX" "$FLUTTER_TITLE" "${FLUTTER_OPTIONS[@]}"
}

