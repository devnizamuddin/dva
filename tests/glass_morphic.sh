#!/bin/bash

# Colors (TrueColor)
NC="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"

# Glass background (semi-transparent look)
GLASS_BG="\033[48;2;40;40;40m"           # dark glass
GLASS_BG_LIGHT="\033[48;2;60;60;60m"     # slightly lighter glass

# Text colors
FG_GLASS="\033[38;2;220;220;220m"        # soft white
FG_DIM="\033[38;2;180;180;180m"

# Glow highlight
GLOW_BG="\033[48;2;0;120;255m"           # neon blue glow
GLOW_FG="\033[38;2;255;255;255m"         # pure white

show_menu() {
    options=("$@")
    selected=0

    while true; do
        clear

        echo -e "${BOLD}${FG_GLASS}╔══════════════════════════════════════════════╗${NC}"
        echo -e "${FG_GLASS}║             Glassmorphic CLI Menu            ║${NC}"
        echo -e "${FG_GLASS}╚══════════════════════════════════════════════╝${NC}"
        echo ""

        for i in "${!options[@]}"; do
            if [[ $i -eq $selected ]]; then
                # 🌟 Selected - Neon Glow + Subtle Blur Effect
                echo -e "${GLOW_BG}${GLOW_FG}   ● ${options[$i]}   ${NC}"
            else
                # Normal - Glass Card
                echo -e "${GLASS_BG_LIGHT}${FG_DIM}   ○ ${options[$i]}   ${NC}"
            fi
            echo
        done

        echo -e "${DIM}${FG_DIM}Use ↑ ↓ to navigate | Enter to select${NC}"

        # Enable raw mode
        stty -icanon -echo

        key=$(dd bs=1 count=1 2>/dev/null)

        if [[ $key == $'\x1b' ]]; then
            key2=$(dd bs=2 count=1 2>/dev/null)
            case "$key2" in
                "[A")
                    ((selected--))
                    ((selected < 0)) && selected=$((${#options[@]} - 1))
                    ;;
                "[B")
                    ((selected++))
                    ((selected >= ${#options[@]})) && selected=0
                    ;;
            esac

        elif [[ $key == "" ]]; then
            stty sane
            clear
            echo -e "${FG_GLASS}${BOLD}You selected:${NC} ${options[$selected]}"
            return 0
        fi

        stty sane
    done
}

# Example usage
show_menu "Start Server" "Stop Server" "Restart Server" "Exit"



# ╔══════════════════════════════════════════════╗
# ║             Glassmorphic CLI Menu            ║
# ╚══════════════════════════════════════════════╝

#   ○ Start Server          (glass card)
#   ○ Stop Server           (glass card)
#   ● Restart Server        (neon glowing selection)
#   ○ Exit                  (glass card)

# Use ↑ ↓ to navigate | Enter to select
