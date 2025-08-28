#!/bin/bash

#* Text Style
NC="\033[0m"
BOLD="\033[1m"

#* ────────────── Flutter Card ──────────────
function print_flutter_card() {
  local BLUE="\033[1;34m"
  local BG_BLUE='\033[44m'
  echo -e "${BG_BLUE}${BLUE}${BOLD}┌───────────────────────────────────────────────┐${NC}"
  echo -e "${BG_BLUE}${BLUE}${BOLD}│ ┌───────────────────────────────────────────┐ │${NC}"
  echo -e "${BG_BLUE}${BLUE}${BOLD}│ │                                           │ │${NC}"
  echo -e "${BG_BLUE}${BLUE}${BOLD}│ │              🖥️  1. FLUTTER   🖥️            │ │${NC}"
  echo -e "${BG_BLUE}${BLUE}${BOLD}│ │                                           │ │${NC}"
  echo -e "${BG_BLUE}${BLUE}${BOLD}│ └───────────────────────────────────────────┘ │${NC}"
  echo -e "${BG_BLUE}${BLUE}${BOLD}└───────────────────────────────────────────────┘${NC}"
}

#* ────────────── Git Card ──────────────
function print_git_card() {
  local ORANGE="\033[38;5;208m"
  local BG_ORANGE="\033[48;5;208m"
  echo -e "${BG_ORANGE}${ORANGE}${BOLD}┌───────────────────────────────────────────────┐${NC}"
  echo -e "${BG_ORANGE}${ORANGE}${BOLD}│ ┌───────────────────────────────────────────┐ │${NC}"
  echo -e "${BG_ORANGE}${ORANGE}${BOLD}│ │                                           │ │${NC}"
  echo -e "${BG_ORANGE}${ORANGE}${BOLD}│ │              🖥️  2. GIT     🖥️              │ │${NC}"
  echo -e "${BG_ORANGE}${ORANGE}${BOLD}│ │                                           │ │${NC}"
  echo -e "${BG_ORANGE}${ORANGE}${BOLD}│ └───────────────────────────────────────────┘ │${NC}"
  echo -e "${BG_ORANGE}${ORANGE}${BOLD}└───────────────────────────────────────────────┘${NC}"
}

#* ────────────── Note Book Card ──────────────
function print_note_book_card() {
  local WHITE="\033[1;37m"
  local BG_WHITE="\033[47m"
  echo -e "${BG_WHITE}${WHITE}${BOLD}┌───────────────────────────────────────────────┐${NC}"
  echo -e "${BG_WHITE}${WHITE}${BOLD}│ ┌───────────────────────────────────────────┐ │${NC}"
  echo -e "${BG_WHITE}${WHITE}${BOLD}│ │                                           │ │${NC}"
  echo -e "${BG_WHITE}${WHITE}${BOLD}│ │           🖥️  3. NOTE BOOK     🖥️           │ │${NC}"
  echo -e "${BG_WHITE}${WHITE}${BOLD}│ │                                           │ │${NC}"
  echo -e "${BG_WHITE}${WHITE}${BOLD}│ └───────────────────────────────────────────┘ │${NC}"
  echo -e "${BG_WHITE}${WHITE}${BOLD}└───────────────────────────────────────────────┘${NC}"
}

#* ────────────── Main Menu UI + Chooser ──────────────
function main_menu(){

    clear
    echo ""
    print_flutter_card
    echo -e "\n\n"
    print_git_card
    echo -e "\n\n"
    print_note_book_card
    echo -e "\n\n"

    #* Prompt user to choose
    while true; do
      read -p "Select an option [1-3] or 0 to Exit: " choice
      case $choice in
        1) echo "🖥️  You selected FLUTTER"; flutter_screen ;;  # call your flutter screen function
        2) echo "🖥️  You selected GIT"; git_screen ;;          # call your git screen function
        3) echo "🖥️  You selected NOTE BOOK"; notebook_screen ;; # call your notebook screen
        0) echo "👋 Exiting..."; break ;;
        *) echo "❌ Invalid option, try again!" ;;
      esac
      echo -e "\nPress Enter to return to Main Menu..."
      read
      clear
      print_flutter_card
      echo -e "\n\n"
      print_git_card
      echo -e "\n\n"
      print_note_book_card
      echo -e "\n\n"
    done
}
