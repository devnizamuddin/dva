#!/bin/bash

#* ┏==================================================================================================┓
#* ┃                                   📖 Printing Menu (Read-only Box)                               ┃
#* ┗==================================================================================================┛
#*

# Function: print_menu
# Purpose : Draws the menu box with title and options
# Usage   : print_menu "Menu Title" "Option 1" "Option 2" ...
function print_menu() {
  local title="$1"
  shift
  local options=("$@")

  # Define menu box width
  local width=49

  # Borders
  local border_top="┏$(printf '=%.0s' $(seq 1 $width))┓"
  local border_sep="┃$(printf '─%.0s' $(seq 1 $width))┃"
  local border_empty="┃$(printf ' %.0s' $(seq 1 $width))┃"
  local border_bottom="┗$(printf '=%.0s' $(seq 1 $width))┛"

  clear
  echo "$border_top"
  echo "$border_empty"

  # Title centered
  local pad=$(( (width - ${#title}) / 2 ))
  printf "┃%*s%s%*s┃\n" $pad "" "$title" $((width - pad - ${#title}))

  echo "$border_empty"

  # Print options
  local i=1
  for option in "${options[@]}"; do
    echo "$border_sep"
    printf "┃  %-2d. %-*s┃\n" "$i" $((width-6)) "$option"
    i=$((i+1))
  done

  echo "$border_empty"
  echo "$border_bottom"
}

# Function: menu_loop
# Purpose : Handles menu interaction (loop, input, actions)
# Usage   : menu_loop "ActionPrefix" "Menu Title" "Option 1" "Option 2" ...
function menu_loop() {
  local action_prefix="$1"
  local title="$2"
  shift 2
  local options=("$@")

  while true; do
    # Show menu
    print_menu "$title" "${options[@]}"

    # Ask input below menu (outside box)
    echo
    read -p "👉 Select an option [0-${#options[@]}] (0 = Exit): " choice

    # Exit if 0
    if [[ "$choice" -eq 0 ]]; then
      echo "👋 Exiting..."
      exit 0

    # Valid choice
    elif [[ "$choice" -ge 1 && "$choice" -le ${#options[@]} ]]; then
      action_func="${action_prefix}_action_$choice"
      if declare -f "$action_func" > /dev/null; then
        $action_func
      else
        echo "⚠️  No action defined for option $choice"
      fi

    # Invalid input
    else
      echo "❌ Invalid choice!"
    fi

    echo -e "\nPress Enter to continue..."
    read
  done
}
