#!/bin/bash
# DVA CLI - Developer Workflow Automation
# MIT License (c) 2025 Nizam Uddin Shamrat


#*
#* ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
#* ║                                   💰 Imported Files                                              ║
#* ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝
#*


DVA_HOME="$HOME/.dva"

# Utils Import 
source "$DVA_HOME/scripts/utils/logger.sh"
source "$DVA_HOME/scripts/utils/printer.sh"
# Components Import
source "$DVA_HOME/scripts/components/main_menu_ui.sh"
# Tasks Import
source "$DVA_HOME/scripts/tasks/note_task.sh"
#* Main CLI Import
source "$DVA_HOME/scripts/dva_cli.sh"

clear

#*
#* ┏==================================================================================================┓
#* ┃                                   📖 CLI Starting Point                                          ┃
#* ┗==================================================================================================┛
#*


    load_main_screen

