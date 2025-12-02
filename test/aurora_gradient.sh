#!/bin/bash

# Truecolor ANSI sequences for gradient
GRADIENT=(
  "\033[38;2;128;0;255m"   # purple
  "\033[38;2;0;128;255m"   # blue
  "\033[38;2;0;255;128m"   # teal
  "\033[38;2;255;128;0m"   # orange
  "\033[38;2;255;0;128m"   # pink
)

BOLD="\033[1m"
NC="\033[0m"

# Highlight colors
HIGHLIGHT_BG="\033[48;2;0;0;0m"        # black background
HIGHLIGHT_FG="\033[38;2;255;255;255m"  # white text

show_menu() {
    options=("$@")
    selected=0

    while true; do
        clear
        echo -e "${BOLD}🌌 Aurora Gradient CLI Menu 🌌${NC}\n"

        for i in "${!options[@]}"; do
            color_index=$((i % ${#GRADIENT[@]}))
            color="${GRADIENT[$color_index]}"

            if [[ $i -eq $selected ]]; then
                # Selected item with highlight
                echo -e "${HIGHLIGHT_BG}${HIGHLIGHT_FG}  ▶ ${options[$i]}  ${NC}"
            else
                # Gradient item
                echo -e "${color}  ○ ${options[$i]}  ${NC}"
            fi
            echo
        done

        echo -e "${BOLD}Use ↑ ↓ arrows to navigate | Press Enter to select${NC}"

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

# Example usage
show_menu "Start Server" "Stop Server" "Restart Server" "Exit" "Status" "Logs"
