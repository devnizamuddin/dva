#!/bin/bash

# Colors
BOLD="\033[1m"
NC="\033[0m"
BLUE="\033[34m"
GREEN="\033[32m"
BG_BLUE="\033[44m"
BG_WHITE="\033[47m"
BLACK="\033[30m"

show_menu() {
    options=("$@")
    selected=0

    while true; do
        clear
        echo -e "${BOLD}Use ↑ ↓ keys to navigate. Press Enter to select:${NC}"
        echo

        for i in "${!options[@]}"; do
            if [[ $i -eq $selected ]]; then
                # Highlighted box
                echo -e "${GREEN}┌──────────────────────────────┐${NC}"
                echo -e "${GREEN}│ ${BOLD}${options[$i]}${NC}${GREEN} │${NC}"
                echo -e "${GREEN}└──────────────────────────────┘${NC}"
            else
                echo -e "┌──────────────────────────────┐"
                echo -e "│ ${options[$i]} │"
                echo -e "└──────────────────────────────┘"
            fi
            echo
        done

        # Enable raw mode temporarily
        stty -icanon -echo

        key=$(dd bs=1 count=1 2>/dev/null)

        if [[ $key == $'\x1b' ]]; then
            key2=$(dd bs=2 count=1 2>/dev/null)
            case "$key2" in
                "[A") # Up arrow
                    ((selected--))
                    ((selected < 0)) && selected=$((${#options[@]} - 1))
                    ;;
                "[B") # Down arrow
                    ((selected++))
                    ((selected >= ${#options[@]})) && selected=0
                    ;;
            esac

        elif [[ $key == "" ]]; then
            stty sane
            clear
            echo "You selected: ${options[$selected]}"
            return 0
        fi

        stty sane
    done
}

# Example
show_menu "Start Server" "Stop Server" "Restart Server" "Exit"


# ┌──────────────────────────────┐
# │ Start Server                 │
# └──────────────────────────────┘

# ┌──────────────────────────────┐
# │ Stop Server                  │
# └──────────────────────────────┘

# ┌──────────────────────────────┐
# │ Restart Server               │  ← highlighted box (green)
# └──────────────────────────────┘

# ┌──────────────────────────────┐
# │ Exit                         │
# └──────────────────────────────┘
