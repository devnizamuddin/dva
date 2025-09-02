#!/bin/bash

#* ┏==================================================================================================┓
#* ┃                           📖 Flutter Menu: Options & Actions                                    ┃
#* ┗==================================================================================================┛
#*


# Menu Title
FLUTTER_TITLE="Flutter Features"

# Menu Options
FLUTTER_OPTIONS=(
  "Build Project"
  "Clean Project"
  "Release Android App"
  "Release iOS App"
  "Create Project In CLEAN Architecture"
  "Create Project In MVVM Architecture"
)

# Action functions for each menu option
action_1() { echo "🚀 Building Flutter project..."; }
action_2() { echo "🧹 Cleaning Flutter project..."; }
action_3() { echo "📦 Releasing Android app..."; }
action_4() { echo "🍎 Releasing iOS app..."; }
action_5() { echo "📂 Creating CLEAN Architecture project..."; }
action_6() { echo "📂 Creating MVVM Architecture project..."; }


#* ┏==================================================================================================┓
#* ┃                                 📖 Flutter Menu Loop                                           ┃
#* ┗==================================================================================================┛
#*


function execute_flutter_menu() {
  # Call the generic menu loop function with your title and options
  menu_loop "$FLUTTER_TITLE" "${FLUTTER_OPTIONS[@]}"
}

