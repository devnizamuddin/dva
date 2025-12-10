#!/bin/bash

#* ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
#* ║                                   💰 Imported Files                                              ║
#* ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝

source "$DVA_HOME/scripts/features/clean/add_feature.sh"
source "$DVA_HOME/scripts/features/clean/add_usecase.sh"

#* ┏==================================================================================================┓
#* ┃                           📖 Clean Menu: Options & Actions                                      ┃
#* ┗==================================================================================================┛

CLEAN_TITLE="CLEAN Architecture"

CLEAN_OPTIONS=(
  "Add Feature"
  "Add UseCase"
  "Add Domain"
  "Add Presentation"
  "Add Shared"
  "Add UI"
  "Add Asset Constants"
)

#* ┏==================================================================================================┓
#* ┃                                   📖 Fuction for Options                                         ┃
#* ┗==================================================================================================┛

function clean_action_1() {
  add_feature_structure
}

function clean_action_2() {
  add_usecase_structure
}

function clean_action_3() {
  echo "Add Domain"
}

function clean_action_4() {
  echo "Add Presentation"
}

function clean_action_5() {
  echo "Add Shared"
}

function clean_action_6() {
  echo "Add UI"
}

function clean_action_7() {
  echo "Add Asset Constants"
}

#* ┏==================================================================================================┓
#* ┃                                 📖 Clean Menu Loop                                               ┃
#* ┗==================================================================================================┛

function execute_clean_manager() {
  local ACTION_PREFIX="clean"
  menu_loop "$ACTION_PREFIX" "$CLEAN_TITLE" "${CLEAN_OPTIONS[@]}"
}
