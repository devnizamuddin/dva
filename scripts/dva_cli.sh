#!/bin/bash 

source "$DVA_HOME/scripts/features/clean/clean_manager.sh"
source "$DVA_HOME/scripts/components/menu_ui.sh"
source "$DVA_HOME/scripts/features/custom_commands/custom_commands_manager.sh"

# Truecolor Aurora gradient colors
GRADIENT_BASE=(
  "128;0;255"   # purple
  "0;128;255"   # blue
  "0;255;128"   # teal
  "255;128;0"   # orange
  "255;0;128"   # pink
)

BOLD="\033[1m"
NC="\033[0m"

# Menu options
options=("🐙  GIT"
         "🗂️  CLEAN Architecture"
         "💙 FLUTTER"
         "📝 NOTE BOOK"
         "🔠 CASE CONVERTER"
         "✨ CUSTOM COMMANDS"
         "🍎 MacOS")

selected=0
shift_index=0  # For rotating gradient

function animate_menu(){
    local key=""
    while true; do
        clear

        # Rotate gradient
        local colors=("${GRADIENT_BASE[@]}")
        colors=("${colors[@]:$shift_index}" "${colors[@]:0:$shift_index}")

        # Header
        printf "${BOLD}\033[38;2;%sm╔═════════════════════════════════════════════════════╗${NC}\n" "${colors[0]}"
        printf "\033[38;2;%sm║            🌌  DVA CLI - Parent Menu 🌌             ║${NC}\n" "${colors[1]}"
        printf "\033[38;2;%sm╚═════════════════════════════════════════════════════╝${NC}\n\n" "${colors[2]}"

        # Menu items
        for i in "${!options[@]}"; do
            color_index=$(( (i + shift_index) % 5 ))
            color="${GRADIENT_BASE[$color_index]}"

            if [[ $i -eq $selected ]]; then
                printf "\033[48;2;0;180;255m\033[38;2;255;255;255m  ▸ %s  \033[0m\n\n" "${options[$i]}"
            else
                printf "\033[48;2;40;40;40m\033[38;2;%sm  ○ %s  \033[0m\n\n" "$color" "${options[$i]}"
            fi
        done

        printf "${BOLD}\033[2mUse ↑ ↓ arrows to navigate | Press Enter to select${NC}\n"

        # Read arrow keys
        stty -icanon -echo
        key=$(dd bs=1 count=1 2>/dev/null || echo "")
        if [[ $key == $'\x1b' ]]; then
            key2=$(dd bs=2 count=1 2>/dev/null || echo "")
            case "$key2" in
                "[A") ((selected--)); ((selected<0)) && selected=$((${#options[@]}-1)) ;;
                "[B") ((selected++)); ((selected>=${#options[@]})) && selected=0 ;;
                "[C") key="";; # Right arrow -> Enter
                "[D") # Left arrow -> Exit
                    printf "\n\n👋 Exiting DVA CLI...\n"
                    exit 0
                    ;;
            esac
        elif [[ $key == "" ]]; then
            # Enter pressed, execute selected function
            case $selected in
                0) run_git_commands ;;
                1) execute_clean_manager ;;
                2) execute_flutter_menu ;;
                3) run_note_menu ;;
                4) run_text_case_converter ;;
                5) run_custom_commands ;;
                6) run_mac_os_menu ;;
            esac

            printf "\nPress Enter to return to Main Menu..."
            read
        fi
        stty sane

        # Shift gradient for animation
        ((shift_index++))
        ((shift_index>=${#GRADIENT_BASE[@]})) && shift_index=0

        sleep 0.2  # Smooth animation
    done
}

# Run CLI
function run_dva_cli(){
    log_task "DVA CLI Started"
    animate_menu
}
