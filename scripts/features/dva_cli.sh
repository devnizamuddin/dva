#!/bin/bash

#*
#* ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
#* ║                                   💰 Imported Files                                              ║
#* ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝
#*

source "$DVA_HOME/scripts/features/components/welcome_ui.sh"
source "$DVA_HOME/scripts/features/components/main_menu_ui.sh"

source "$DVA_HOME/scripts/features/screens/flutter_screen.sh"

#*
#* ┏==================================================================================================┓
#* ┃                                   📖 Drawing Main Screen                                         ┃
#* ┗==================================================================================================┛
#*



 function load_main_screen(){
   
   
   #*
   #* ✌️ Welcome User
   #*
   
   print_welcome_message

   main_menu

  # flutter_screen

 }


