#!/bin/bash


function print_note_task_list() {
  local WHITE="\033[1;37m"
  local BG_WHITE="\033[47m"

  echo -e "${BG_WHITE}${WHITE}${BOLD}┌───────────────────────────────────────────────┐${NC}"
  echo -e "${BG_WHITE}${WHITE}${BOLD}│                                               │${NC}"
  echo -e "${BG_WHITE}${WHITE}${BOLD}│ 1. Remote Url                                 │${NC}"
  echo -e "${BG_WHITE}${WHITE}${BOLD}│                                               │${NC}"
  echo -e "${BG_WHITE}${WHITE}${BOLD}│ 2. Active Branches                            │${NC}"
  echo -e "${BG_WHITE}${WHITE}${BOLD}│                                               │${NC}"
  echo -e "${BG_WHITE}${WHITE}${BOLD}└───────────────────────────────────────────────┘${NC}"
}