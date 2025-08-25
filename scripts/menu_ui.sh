#!/bin/bash

 #* Text Style
 
 NC="\033[0m" 
 BOLD="\033[1m"



# *
# * ---> Git
# *
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
# *
# * ---> Flutter
# *

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


function printMenuUi(){

    print_flutter_card
    echo -e "";
    echo -e "";
    echo -e "";
    print_git_card
    echo -e "";
    echo -e "";
    echo -e "";
    print_note_book_card
    echo -e "";
    echo -e "";
    echo -e "";
}