#!/bin/bash

[[ -n "${_DVA_MAC_OS_MANAGER_LOADED+x}" ]] && return 0
_DVA_MAC_OS_MANAGER_LOADED=1

#* ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
#* ║                                   💰 Imported Files                                              ║
#* ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝

source "$DVA_HOME/lib/features/mac_os/icloud_manager.sh"

#* ┏==================================================================================================┓
#* ┃                                       🍎 MacOS: Options & Actions                                ┃
#* ┗==================================================================================================┛
#*


# Menu Title
MAC_OS_PAGE_TITLE="Mac Operating System"

# Menu Options
MAC_OS_OPTIONS=(
  "SYNC Folder With iCloud"
  "Show All Reminders"
  "Add New Reminder"
  "Delete Specific Reminder"
  "Delete All Completed Reminders"
)


#* ┏==================================================================================================┓
#* ┃                              📖 MacOS Action Functions                                          ┃
#* ┗==================================================================================================┛
#*

function mac_os_action_1() {
  sync_with_icloud
}

function mac_os_action_2() {
  echo "Showing all reminders..."
  # Add your logic to show all reminders here
}

function mac_os_action_3() {
  echo "Adding new reminder..."
  # Add your logic to add a new reminder here
}

function mac_os_action_4() {
  echo "Deleting specific reminder..."
  # Add your logic to delete a specific reminder here
}

function mac_os_action_5() {
  echo "Deleting all completed reminders..."
  # Add your logic to delete all completed reminders here
}


#* ┏==================================================================================================┓
#* ┃                               📖 Text Case Menu Loop                                            ┃
#* ┗==================================================================================================┛
#*

function run_mac_os_menu() {
  local ACTION_PREFIX="mac_os"
  menu_loop "$ACTION_PREFIX" "$MAC_OS_PAGE_TITLE" "${MAC_OS_OPTIONS[@]}"
}
