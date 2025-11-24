#!/bin/bash

#* ╔═══════════════════════════════════════════════════════════════════════════════════════════════════╗
#* ║                                       💎 Clean Manager                                            ║
#* ╚═══════════════════════════════════════════════════════════════════════════════════════════════════╝

#* ======================================== Imported Scripts ========================================

source "$DVA_HOME/scripts/features/clean/add_feature.sh"

#* ======================================== Menu Configuration ======================================

CLEAN_TITLE="CLEAN Architecture"

CLEAN_OPTIONS=(
  "Clean Unnecessary Resources"
  "Upgrade Project Version"
  "Release Android App"
  "Release iOS App"
  "Create Project in CLEAN Architecture"
  "Create Project in MVVM Architecture"
  "Create Asset Constants"
)

#* ======================================== Action Functions ========================================

clean_action_1() {
  echo "🧹 Cleaning unnecessary resources..."
  clean_unnessery_resources
}

clean_action_1() {
  echo "⚙️ Upgrading project version..."
  upgradeProjectVersion
}

clean_action_1() {
  echo "📦 Releasing Android app..."
  # call your android release logic here
}

clean_action_1() {
  echo "🍎 Releasing iOS app..."
  # call your iOS release logic here
}

clean_action_1() {
  echo "📂 Creating CLEAN Architecture project..."
  # call project creation logic here
}

clean_action_1() {
  echo "📂 Creating MVVM Architecture project..."
  # call project creation logic here
}

clean_action_1() {
  echo "🎨 Creating asset constants..."
  create_asset_constants
}

#* ======================================== Menu Dispatcher ========================================

execute_clean_manager() {
  local ACTION_PREFIX="clean_manager"
  menu_loop "$ACTION_PREFIX" "$CLEAN_TITLE" "${CLEAN_OPTIONS[@]}"
}

#* ======================================== Script Entry ===========================================

# If called directly, run the menu
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  execute_clean_manager
fi
