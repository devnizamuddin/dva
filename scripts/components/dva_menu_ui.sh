#!/bin/bash


#*
#* ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
#* ║                                   💰 Imported Files                                              ║
#* ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝
#*


source "$DVA_HOME/scripts/features/flutter_features.sh"


#*
#* ┏==================================================================================================┓
#* ┃                                   📖 Main DVA Menu                                               ┃
#* ┗==================================================================================================┛
#*



#* ────────────── Flutter Card ──────────────
function show_dva_menu() {
  sleep 2 
  clear
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
  echo -e "${BG_LIGHT_BLUE}${BOLD}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${NC}"
}


function execute_dva_menu(){
    #*
    #* ✌️ Showing Menu 
    #*
    
    show_dva_menu
    
    line_gap 2

    #*
    #* ✌️ Executing menu base on user inputs
    #*
    
    while true; do

      printf "Select an option [${GREEN}1-3${NC}] or ${RED}0${NC} to Exit: "
      read choice
    
      case $choice in
        1) flutter_screen ;;  
        
        2) execute_flutter_menu ;;      
        
        3) notebook_screen ;;
        
        0) echo "👋 Exiting..."; break ;;
        
        *) echo "❌ Invalid option, try again!" ;;
      
      esac
      
      echo -e "\nPress Enter to return to Main Menu..."
      
    done
}
