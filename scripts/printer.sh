#!/usr/bin/env bash

# Import styles
source ./style.sh

print_header() {
    echo -e "${BOLD}${BLUE}┌───────────────────────────┐${NC}"
    echo -e "${BOLD}${BLUE}│   $1   │${NC}"
    echo -e "${BOLD}${BLUE}└───────────────────────────┘${NC}"
}

print_title() {
    echo -e "${BOLD}${GREEN}$1${NC}"
}

print_body() {
    echo -e "${WHITE}$1${NC}"
}

choose_menu_or_back() {
    echo -e "${YELLOW}1) Menu${NC}"
    echo -e "${YELLOW}2) Back${NC}"
}

choose_from_multiple_choice_options() {
    local -n options=$1  # Pass array by reference
    echo -e "${BOLD}Choose an option:${NC}"
    local i=1
    for opt in "${options[@]}"; do
        echo -e "${CYAN}$i)${NC} $opt"
        ((i++))
    done
}
