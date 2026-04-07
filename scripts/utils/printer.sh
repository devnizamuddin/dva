#!/bin/bash

#* ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
#* ║                                   💰 Imported Files                                              ║
#* ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝

source "$DVA_HOME/scripts/utils/style.sh"

#* ┏==================================================================================================┓
#* ┃                                   📖 Printing Header                                              ┃
#* ┗==================================================================================================┛

function print_header() {
    local title="$1"
    echo -e "${BOLD}${BLUE}┌───────────────────────────┐${NC}"
    echo -e "${BOLD}${BLUE}│   $title   │${NC}"
    echo -e "${BOLD}${BLUE}└───────────────────────────┘${NC}"
}

#* ┏==================================================================================================┓
#* ┃                                   📖 Printing Title                                              ┃
#* ┗==================================================================================================┛

function print_title() {
    local title="$1"
    echo -e "${BOLD}${GREEN}== $title ==${NC}"
}

#* ┏==================================================================================================┓
#* ┃                                         📖 Print Body                                            ┃
#* ┗==================================================================================================┛

function print_body() {
    echo -e "${WHITE}$1${NC}"
}


#* ┏==================================================================================================┓
#* ┃                                   📖 Choose Menu or Back                                         ┃
#* ┗==================================================================================================┛

function choose_menu_or_back() {
    echo -e "${YELLOW}1) Menu${NC}"
    echo -e "${YELLOW}2) Back${NC}"
}

#* ┏==================================================================================================┓
#* ┃                                 📖 Choose From Multiple Choice                                   ┃
#* ┗==================================================================================================┛

function choose_from_multiple_choice_options() {
    local -n options=$1  # Pass array by reference
    echo -e "${BOLD}Choose an option:${NC}"
    local i=1
    for opt in "${options[@]}"; do
        echo -e "${CYAN}$i)${NC} $opt"
        ((i++))
    done
}


#* ┏==================================================================================================┓
#* ┃                                   📖 Progress Dot Loader                                         ┃
#* ┗==================================================================================================┛


function show_progress_dots() {
    local message="${1}"
    shift
    local cmd=("$@")  # Command passed as arguments

    local delay=0.5
    local count=0

    # Hide cursor during animation
    tput civis
    echo ""
    echo ""

    # Start spinner in background
    (
    while :; do
        count=$(( (count + 1) % 4 ))
        dots=$(printf "%*s" "$count" | tr ' ' '.')
        printf "\r${CYAN}${BOLD}⏳ %s${dots}${RESET}" "$message"
        sleep "$delay"
    done
    ) &
    local spinner_pid=$!

    # Run the actual command silently
    "${cmd[@]}" >/dev/null 2>&1

    # Stop spinner
    kill "$spinner_pid" >/dev/null 2>&1
    wait "$spinner_pid" 2>/dev/null

    # Clean up output and print done message
    printf "\r${GREEN}✅ %s... Done!${RESET}\n" "$message"
    echo ""
    echo ""
    tput cnorm  # Show cursor again
}

#* ┏==================================================================================================┓
#* ┃                                   📖 Prints Line Gap                                             ┃
#* ┗==================================================================================================┛

function line_gap() {
    local lines=${1:-1}  # Default to 1 line if no argument given
    for ((i=0; i<lines; i++)); do
        echo -e ""
    done
}


#* ┏==================================================================================================┓
#* ┃                                   📖 Dividers                                                    ┃
#* ┗==================================================================================================┛


function divider() {
    
    echo -e "------------------------------------------------------------------------------------------------------------------------------"

}

function multi_line_divider() {
    
    echo -e "============================================================================================="

}

#* ┏==================================================================================================┓
#* ┃                                   📖 Premium UI Cards                                            ┃
#* ┗==================================================================================================┛

function print_card() {
    local content="$1"
    local color="${2:-$BLUE}"
    
    echo -e "  ${color}╭────────────────────────────────────────────────────────╮${NC}"
    # Read multiline content and print with borders
    while IFS= read -r line; do
        # We use printf to ensure consistent width, padded to 54 chars
        # Subtracting length of actual content could be tricky with ANSI codes, 
        # so we'll just print it loosely or use a padded format.
        # For simplicity, we just print the line with a bit of space.
        echo -e "  ${color}│${NC}  ${line}"
    done <<< "$content"
    echo -e "  ${color}╰────────────────────────────────────────────────────────╯${NC}"
}

function print_status_info() {
    echo -e "  ${BLUE}ℹ ${BOLD}$1${NC}"
}

function print_status_success() {
    echo -e "  ${GREEN}✔ ${BOLD}$1${NC}"
}

function print_status_warning() {
    echo -e "  ${YELLOW}⚠ ${BOLD}$1${NC}"
}

function print_status_error() {
    echo -e "  ${RED}✖ ${BOLD}$1${NC}"
}
