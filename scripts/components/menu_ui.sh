#!/bin/bash

#* ┏==================================================================================================┓
#* ┃                                   📖 Printing Menu (Read-only Box)                               ┃
#* ┗==================================================================================================┛
#*

#* ┏===============================================================┓
#* ┃ Function: Print Menu                                          ┃
#* ┃ Purpose : Draws the menu box with title and options           ┃
#* ┃ Usage   : print_menu "Menu Title" "Option 1" "Option 2" ...   ┃
#* ┗===============================================================┛
function print_menu() {
  local title="$1"
  shift
  local options=("$@")
  #*=====================================
  #* Define menu box width  
  #*=====================================
  local width=49

  #*=====================================
  #* Borders
  #*=====================================
  local border_top="┏$(printf '━%.0s' $(seq 1 $width))┓"
  local border_sep="┃$(printf '─%.0s' $(seq 1 $width))┃"
  local border_empty="┃$(printf ' %.0s' $(seq 1 $width))┃"
  local border_bottom="┗$(printf '━%.0s' $(seq 1 $width))┛"

  echo "$border_top"
  echo "$border_empty"

  #*=====================================
  #* Title centered
  #*=====================================
  local pad=$(( (width - ${#title}) / 2 ))
  printf "┃%*s%s%*s┃\n" $pad "" "$title" $((width - pad - ${#title}))

  echo "$border_empty"

  #*=====================================
  #* Print options
  #*=====================================
  local i=1
  for option in "${options[@]}"; do
    echo "$border_sep"
    printf "┃  %-2d. %-*s┃\n" "$i" $((width-6)) "$option"
    i=$((i+1))
  done

  echo "$border_empty"
  echo "$border_bottom"
}

#* ┏==============================================================================┓
#* ┃ Function: Menu Loop                                                          ┃
#* ┃ Purpose : Handles menu interaction (loop, input, actions)                    ┃
#* ┃ Usage   : menu_loop "ActionPrefix" "Menu Title" "Option 1" "Option 2" ...    ┃
#* ┗==============================================================================┛

function menu_loop() {
  local action_prefix="$1"
  local title="$2"
  shift 2
  local options=("$@")
  local selected=0
  local key=""

  # Hide cursor
  printf "\033[?25l"

  while true; do
    # Clear screen (optional, or just redraw menu)
    # clear # Better to just redraw or use tput to move cursor up

    #*=====================================
    #* Draw Menu
    #*=====================================
    # We will redraw the menu with the selected item highlighted
    
    # Move cursor to top left (if clearing) or just reprint
    # For simplicity in this script, we'll clear screen to avoid artifacts
    clear 

    local width=49
    local border_top="┏$(printf '━%.0s' $(seq 1 $width))┓"
    local border_sep="┃$(printf '─%.0s' $(seq 1 $width))┃"
    local border_empty="┃$(printf ' %.0s' $(seq 1 $width))┃"
    local border_bottom="┗$(printf '━%.0s' $(seq 1 $width))┛"

    echo "$border_top"
    echo "$border_empty"

    # Title
    local pad=$(( (width - ${#title}) / 2 ))
    printf "┃%*s%s%*s┃\n" $pad "" "$title" $((width - pad - ${#title}))

    echo "$border_empty"

    # Options
    for i in "${!options[@]}"; do
      echo "$border_sep"
      if [[ $i -eq $selected ]]; then
        # Highlight selected
        printf "┃\033[7m  %-2d. %-*s\033[0m┃\n" $((i+1)) $((width-6)) "${options[$i]}"
      else
        printf "┃  %-2d. %-*s┃\n" $((i+1)) $((width-6)) "${options[$i]}"
      fi
    done

    echo "$border_empty"
    echo "$border_bottom"
    
    echo -e "\nUse ↑ ↓ to navigate, → or Enter to select, ← to Back"

    #*=====================================
    #* Read Input
    #*=====================================
    stty -icanon -echo
    key=$(dd bs=1 count=1 2>/dev/null || echo "")
    if [[ $key == $'\x1b' ]]; then
        key2=$(dd bs=2 count=1 2>/dev/null || echo "")
        case "$key2" in
            "[A") # Up
                ((selected--))
                ((selected<0)) && selected=$((${#options[@]}-1))
                ;;
            "[B") # Down
                ((selected++))
                ((selected>=${#options[@]})) && selected=0
                ;;
            "[C") # Right -> Select
                key="" # Treat as enter
                ;;
            "[D") # Left -> Back
                stty sane
                printf "\033[?25h" # Show cursor
                return 0
                ;;
        esac
    fi
    stty sane

    #*=====================================
    #* Execute Action
    #*=====================================
    if [[ $key == "" ]]; then
      # Enter pressed (or Right arrow treated as Enter)
      local choice=$((selected + 1))
      local action_func="${action_prefix}_action_$choice"
      
      printf "\033[?25h" # Show cursor before running action
      
      if declare -f "$action_func" > /dev/null; then
        clear
        $action_func
        
        # Pause after action if needed, or let the action handle it.
        # Most existing actions seem to return immediately or have their own pauses.
        # We'll add a pause here just in case, consistent with previous behavior
        echo -e "\nPress Enter to continue..."
        read
      else
        echo "⚠️  No action defined for option $choice"
        sleep 1
      fi
      
      # Re-hide cursor for menu loop
      printf "\033[?25l"
    fi
  done
  
  printf "\033[?25h" # Ensure cursor is visible on exit
}
