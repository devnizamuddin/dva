#!/bin/bash

# Colors
BOLD="\033[1m"
NC="\033[0m"
DIM="\033[2m"
GREEN="\033[32m"
CYAN="\033[36m"
WHITE="\033[97m"
BG_SELECTED="\033[48;5;24m"    # Deep blue highlight
BG_NORMAL="\033[48;5;236m"      # Dark gray background
FG_SELECTED="\033[38;5;255m"    # White text
FG_NORMAL="\033[38;5;252m"      # Gray text

show_menu() {
    options=("$@")
    selected=0

    while true; do
        clear
        echo -e "${BOLD}${WHITE}Use ↑ ↓ keys to navigate  |  Press Enter to select${NC}\n"

        for i in "${!options[@]}"; do
            if [[ $i -eq $selected ]]; then
                # Selected menu item (rounded edges + highlight)
                echo -e "${BG_SELECTED}${FG_SELECTED}  ◉ ${options[$i]}  ${NC}"
            else
                # Normal menu item
                echo -e "${BG_NORMAL}${FG_NORMAL}  ○ ${options[$i]}  ${NC}"
            fi
            echo
        done

        # Enable raw mode
        stty -icanon -echo

        key=$(dd bs=1 count=1 2>/dev/null)

        if [[ $key == $'\x1b' ]]; then
            key2=$(dd bs=2 count=1 2>/dev/null)
            case "$key2" in
                "[A")  # Up
                    ((selected--))
                    ((selected < 0)) && selected=$((${#options[@]} - 1))
                    ;;
                "[B")  # Down
                    ((selected++))
                    ((selected >= ${#options[@]})) && selected=0
                    ;;
            esac

        elif [[ $key == "" ]]; then
            stty sane
            clear
            echo -e "${GREEN}✔ You selected:${NC} ${BOLD}${options[$selected]}${NC}"
            return 0
        fi

        stty sane
    done
}

# Example usage
show_menu "Start Server" "Stop Server" "Restart Server" "Exit"


# Use ↑ ↓ keys to navigate  |  Press Enter to select

#   ○ Start Server  

#   ○ Stop Server  

#   ◉ Restart Server  

#   ○ Exit
