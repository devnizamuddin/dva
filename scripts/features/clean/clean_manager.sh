#!/bin/bash

#* ╔═══════════════════════════════════════════════════════════════════════════════════════════════════╗
#* ║                                       💎 Clean Manager                                            ║
#* ╚═══════════════════════════════════════════════════════════════════════════════════════════════════╝

#* ======================================== Imported Scripts ========================================

source "$DVA_HOME/scripts/features/clean/add_feature.sh"

#* ======================================== Menu Configuration ======================================

CLEAN_TITLE="CLEAN Architecture"

CLEAN_OPTIONS=(
  "Add Feature"
  "Add Data Source"
  "Add Domain"
  "Add Presentation"
  "Add Shared"
  "Add UI"
  "Add Asset Constants"
)

#* ======================================== Action Functions ========================================

clean_action_1() {
  generate_feature_structure
}

clean_action_2() {
  echo "Add Data Source"
}

clean_action_3() {
  echo "Add Domain"
}

clean_action_4() {
  echo "Add Presentation"
}

clean_action_5() {
  echo "Add Shared"
}

clean_action_6() {
  echo "Add UI"
}

clean_action_7() {
  echo "Add Asset Constants"
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
