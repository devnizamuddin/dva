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
source "$DVA_HOME/scripts/sources/utils_source.sh"
# Tasks Import
source "$DVA_HOME/scripts/sources/tasks_source.sh"
# Components Import
source "$DVA_HOME/scripts/components/main_menu_ui.sh"
#* Main CLI Import
source "$DVA_HOME/scripts/dva_cli.sh"

clear

#*
#* ┏==================================================================================================┓
#* ┃                                   📖 CLI Starting Point                                          ┃
#* ┗==================================================================================================┛
#*


    run_dva_cli

