#!/bin/bash

#*
#* ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
#* ║                                   💰 Imported Files                                              ║
#* ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝
#*

source "$DVA_HOME/scripts/presentation/components/welcome_ui.sh"
source "$DVA_HOME/scripts/presentation/components/main_menu_ui.sh"

source "$DVA_HOME/scripts/presentation/screens/flutter_screen.sh"

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


