#!/bin/bash

 #* Text Style
 
 NC="\033[0m" 
 BOLD="\033[1m"



# *
# * ---> Git
# *
function print_flutter_card() {
  local BLUE="\033[1;34m"
  echo -e "${BLUE}${BOLD}┌───────────────────────────────────────────────┐${NC}"
  echo -e "${BLUE}${BOLD}│ ┌───────────────────────────────────────────┐ │${NC}"
  echo -e "${BLUE}${BOLD}│ │                                           │ │${NC}"
  echo -e "${BLUE}${BOLD}│ │              🖥️  1. FLUTTER   🖥️            │ │${NC}"
  echo -e "${BLUE}${BOLD}│ │                                           │ │${NC}"
  echo -e "${BLUE}${BOLD}│ └───────────────────────────────────────────┘ │${NC}"
  echo -e "${BLUE}${BOLD}└───────────────────────────────────────────────┘${NC}"
}
# *
# * ---> Flutter
# *

function print_git_card() {
  echo -e "${BLUE}${BOLD}┌───────────────────────────────────────────────┐${NC}"
  echo -e "${BLUE}${BOLD}│ ┌───────────────────────────────────────────┐ │${NC}"
  echo -e "${BLUE}${BOLD}│ │                                           │ │${NC}"
  echo -e "${BLUE}${BOLD}│ │              🖥️  2. GIT     🖥️              │ │${NC}"
  echo -e "${BLUE}${BOLD}│ │                                           │ │${NC}"
  echo -e "${BLUE}${BOLD}│ └───────────────────────────────────────────┘ │${NC}"
  echo -e "${BLUE}${BOLD}└───────────────────────────────────────────────┘${NC}"
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
}