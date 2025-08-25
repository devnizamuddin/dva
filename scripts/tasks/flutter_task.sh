#!/bin/bash

function print_flutter_task_list() {
  local BLUE="\033[1;34m"
  local BG_BLUE='\033[44m'
  echo -e "${BG_BLUE}${BLUE}${BOLD}┌───────────────────────────────────────────────┐${NC}"
  echo -e "${BG_BLUE}${BLUE}${BOLD}│ │                                           │ │${NC}"
  echo -e "${BG_BLUE}${BLUE}${BOLD}│ │              🖥️  1. FLUTTER   🖥️            │ │${NC}"
  echo -e "${BG_BLUE}${BLUE}${BOLD}│ │                                           │ │${NC}"
  echo -e "${BG_BLUE}${BLUE}${BOLD}└───────────────────────────────────────────────┘${NC}"
}