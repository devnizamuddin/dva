#!/bin/bash


function print_note_task_list() {
  local ORANGE="\033[38;5;208m"
  local BG_ORANGE="\033[48;5;208m"
  echo -e "${BG_ORANGE}${ORANGE}${BOLD}┌───────────────────────────────────────────────┐${NC}"
  echo -e "${BG_ORANGE}${ORANGE}${BOLD}│                                               │${NC}"
  echo -e "${BG_ORANGE}${ORANGE}${BOLD}│ 1. Remote Url                                 │${NC}"
  echo -e "${BG_ORANGE}${ORANGE}${BOLD}│                                               │${NC}"
  echo -e "${BG_ORANGE}${ORANGE}${BOLD}│ 2. Active Branches                            │${NC}"
  echo -e "${BG_ORANGE}${ORANGE}${BOLD}│                                               │${NC}"
  echo -e "${BG_ORANGE}${ORANGE}${BOLD}└───────────────────────────────────────────────┘${NC}"
}