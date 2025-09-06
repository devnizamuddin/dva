#!/bin/bash

#* ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
#* ║                                   💰 Imported Files                                              ║
#* ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝

source "$DVA_HOME/scripts/features/flutter/flutter_manager.sh"

source "$DVA_HOME/scripts/features/text/text_case_converter.sh"

source "$DVA_HOME/scripts/features/git/git_manager.sh"

source "$DVA_HOME/scripts/features/note/notes_manager.sh"

source "$DVA_HOME/scripts/features/mac_os/mac_os_manager.sh"

#* ┏==================================================================================================┓
#* ┃                                   📖 Sarting DVA cli.                                            ┃
#* ┗==================================================================================================┛


 function run_dva_cli(){

    log_task "Dva Cli Started"

    #*
    #* ✌️ Showing Menu 
    #*

    show_dva_menu

    line_gap 2

    
    #*
    #* ✌️ Excuse as user input
    #*
    

    execute_dva_menu

 }


function show_dva_menu() {
  echo -e "${BG_LIGHT_BLUE}${BOLD}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┃ ┌───────────────────────────────────────────┐ ┃${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┃ │                                           │ ┃${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┃ │                1. 🗂️  GIT                  │ ┃${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┃ │                                           │ ┃${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┃ └───────────────────────────────────────────┘ ┃${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┃ ┌───────────────────────────────────────────┐ ┃${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┃ │                                           │ ┃${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┃ │              2. 💙 FLUTTER                │ ┃${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┃ │                                           │ ┃${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┃ └───────────────────────────────────────────┘ ┃${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┃ ┌───────────────────────────────────────────┐ ┃${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┃ │                                           │ ┃${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┃ │             3. 📝 NOTE BOOK               │ ┃${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┃ │                                           │ ┃${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┃ └───────────────────────────────────────────┘ ┃${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┃ ┌───────────────────────────────────────────┐ ┃${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┃ │                                           │ ┃${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┃ │       4. 🔠  TEXT CASE CONVERTER          │ ┃${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┃ │                                           │ ┃${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┃ └───────────────────────────────────────────┘ ┃${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┃ ┌───────────────────────────────────────────┐ ┃${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┃ │                                           │ ┃${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┃ │             5. 🍎 MacOS                   │ ┃${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┃ │                                           │ ┃${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┃ └───────────────────────────────────────────┘ ┃${NC}"
  echo -e "${BG_LIGHT_BLUE}${BOLD}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${NC}"
}


function execute_dva_menu(){
    

    #*
    #* ✌️ Executing menu base on user inputs
    #*
    
    while true; do

      printf "Select an option [${GREEN}1-5${NC}] or ${RED}0${NC} to Exit: "
      read choice
    
      case $choice in
        1) run_git_commands ;;  
        
        2) execute_flutter_menu ;;      
        
        3) run_note_menu ;;

        4) run_text_case_converter ;;

        5) run_mac_os_menu ;;

        0) echo "👋 Exiting..."; break ;;
        
        *) echo "❌ Invalid option, try again!" ;;
      
      esac
      
      echo -e "\nPress Enter to return to Main Menu..."
      
    done
}
