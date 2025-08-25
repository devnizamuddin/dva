#!/bin/bash
# UI Helpers for DVA CLI - ASCII iPad Layout
# MIT License (c) 2025 Nizam Uddin Shamrat

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
NC="\033[0m"

# Styles
BOLD="\033[1m"
DIM="\033[2m"

# ────────── ASCII Layout FUNCTIONS ────────── #

function print_app_header() {
  echo -e "${BLUE}${WHITE}${BOLD}┌────────────────────────────────────────────┐${NC}"
  echo -e "${BLUE}${WHITE}${BOLD}│               🖥️  DVA CLI  🖥️               │${NC}"
  echo -e "${BLUE}${WHITE}${BOLD}└────────────────────────────────────────────┘${NC}"
}

# Print header banner
function print_header() {
  echo -e "${BLUE}${WHITE}${BOLD}┌────────────────────────────────────────────┐${NC}"
  echo -e "${BLUE}${WHITE}${BOLD}│        🖥️  $1  🖥️          │${NC}"
  echo -e "${BLUE}${WHITE}${BOLD}└────────────────────────────────────────────┘${NC}"
}

# Print a card (menu option)
function print_card() {
  local number="$1"
  local title="$2"
  local symbol="$3"
  local color="$4"

  echo -e "${color}┌──────────────────────────────┐${NC}"
  echo -e "${color}│ [$number] $symbol  $title${NC}"
  echo -e "${color}└──────────────────────────────┘${NC}"
}

# Print info box
function print_info() {
  echo -e "${CYAN}ℹ $1${NC}"
}

# Print success box
function print_success() {
  echo -e "${GREEN}✔ $1${NC}"
}

# Print error box
function print_error() {
  echo -e "${RED}✖ $1${NC}"
}

# Divider
function print_divider() {
  echo -e "${DIM}────────────────────────────────────────────${NC}"
}
