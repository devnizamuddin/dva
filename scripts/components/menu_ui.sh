#!/bin/bash


#* ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
#* ║                                   💰 Imported Files                                              ║
#* ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝

source "$DVA_HOME/scripts/utils/text_printer.sh"


#* ┏==================================================================================================┓
#* ┃                                   📖 Printing Menu                                               ┃
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

  # Prepare borders and empty lines
  local border_top="┏$(printf '=%.0s' $(seq 1 $width))┓"
  local border_sep="┃$(printf '─%.0s' $(seq 1 $width))┃"
  local border_empty="┃$(printf ' %.0s' $(seq 1 $width))┃"
  local border_bottom="┗$(printf '=%.0s' $(seq 1 $width))┛"

  clear
  echo "$border_top"
  echo "$border_empty"

  # Print the title centered inside the box
  local pad=$(( (width - ${#title}) / 2 ))
  printf "┃%*s%s%*s┃\n" $pad "" "$title" $((width - pad - ${#title}))

  echo "$border_empty"

  # Print each option with a number
  local i=1
  for option in "${options[@]}"; do
    echo "$border_sep"
    printf "┃  %-2d. %-*s┃\n" "$i" $((width-6)) "$option"
    i=$((i+1))
  done

  echo "$border_empty"

  # Print prompt message at the bottom
  local prompt="Select an option [0-$((i-1))] || 0 to Exit:"
  printf "┃  %-*s┃\n" $((width-2)) "$prompt"

  echo "$border_empty"
  echo "$border_bottom"
}

# Function: menu_loop
# Purpose : Handles menu interaction (loop, input, actions)
# Usage   : menu_loop "Menu Title" "Option 1" "Option 2" ...
function menu_loop() {
  local title="$1"; shift
  local options=("$@")

  while true; do
    # Show menu
    print_menu "$title" "${options[@]}"

    # Take user input
    read -p "Enter choice: " choice

    # Exit if user presses 0
    if [[ "$choice" -eq 0 ]]; then
      echo "👋 Exiting..."
      exit 0

    # Check if input is a valid option number
    elif [[ "$choice" -ge 1 && "$choice" -le ${#options[@]} ]]; then
      # Find function with name "action_<choice>"
      action_func="action_$choice"

      # Run the action if defined
      if declare -f "$action_func" > /dev/null; then
        $action_func
      else
        echo "⚠️  No action defined for option $choice"
      fi

    # Handle invalid input
    else
      echo "❌ Invalid choice!"
    fi

    # Pause before showing menu again
    echo -e "\nPress Enter to continue..."
    read
  done
}
