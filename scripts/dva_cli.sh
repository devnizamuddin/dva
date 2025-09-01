#!/bin/bash

#*
#* ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
#* ║                                   💰 Imported Files                                              ║
#* ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝
#*

source "$DVA_HOME/scripts/components/welcome_ui.sh"
source "$DVA_HOME/scripts/components/main_menu_ui.sh"

#*
#* ┏==================================================================================================┓
#* ┃                                   📖 Drawing Main Screen                                         ┃
#* ┗==================================================================================================┛
#*



 function load_main_screen(){
   
   
   #*
   #* ✌️ Welcome User
   #*

  log_task "Dev Cli Started"
   
   print_welcome_message

   main_menu

  # flutter_screen

 }


