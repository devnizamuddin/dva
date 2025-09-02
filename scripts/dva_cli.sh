#!/bin/bash

#*
#* ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
#* ║                                   💰 Imported Files                                              ║
#* ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝
#*

source "$DVA_HOME/scripts/components/welcome_ui.sh"
source "$DVA_HOME/scripts/components/dva_menu_ui.sh"

#*
#* ┏==================================================================================================┓
#* ┃                                   📖 Sarting DVA cli.                                            ┃
#* ┗==================================================================================================┛
#*


 function run_dva_cli(){

  log_task "Dva Cli Started"

  multi_line_divider

  welcome_user
  
  multi_line_divider

  line_gap 2

  execute_dva_menu

 }


