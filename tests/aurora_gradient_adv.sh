#!/bin/bash

# Truecolor gradients for Aurora effect
GRADIENT=(
  "\033[38;2;128;0;255m"   # purple
  "\033[38;2;0;128;255m"   # blue
  "\033[38;2;0;255;128m"   # teal
  "\033[38;2;255;128;0m"   # orange
  "\033[38;2;255;0;128m"   # pink
)

# Glass background shades (frosted effect)
GLASS_BG_LIGHT="\033[48;2;60;60;60m"   # light gray glass
GLASS_BG_DARK="\033[48;2;40;40;40m"    # darker glass for non-selected

# Highlight colors for selection (glowing)
HIGHLIGHT_BG="\033[48;2;0;180;255m"    # neon aurora blue
HIGHLIGHT_FG="\033[38;2;255;255;255m"  # white text

BOLD="\033[1m"
NC="\033[0m"

show_menu() {
    options=("$@")
    selected=0

    while true; do
        clear

        # Header box
        echo -e "${BOLD}${GRADIENT[0]}╔══════════════════════════════════════╗${NC}"
        echo -e "${GRADIENT[1]}║      🌌 Aurora Glass CLI Menu 🌌     ║${NC}"
        echo -e "${GRADIENT[2]}╚══════════════════════════════════════╝${NC}"
        echo

        for i in "${!options[@]}"; do
            color_index=$((i % ${#GRADIENT[@]}))
            color="${GRADIENT[$color_index]}"

            if [[ $i -eq $selected ]]; then
                # Selected glowing box
                echo -e "${HIGHLIGHT_BG}${HIGHLIGHT_FG}  ▸ ${options[$i]}  ${NC}"
            else
                # Glass-style box
                echo -e "${GLASS_BG_DARK}${color}  ○ ${options[$i]}  ${NC}"
            fi
            echo
        done

        echo -e "${BOLD}${GRADIENT[3]}Use ↑ ↓ arrows to navigate | Press Enter to select${NC}"

        # Raw input
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
            echo -e "✅ You selected: ${BOLD}${options[$selected]}${NC}"
            return 0
        fi

        stty sane
    done
}

# Example menu
show_menu "Start Server" "Stop Server" "Restart Server" "Exit" "Status" "Logs"
