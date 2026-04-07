#!/bin/bash

#* ┏==================================================================================================┓
#* ┃                                📝 Notes Menu: Options & Actions                                  ┃
#* ┗==================================================================================================┛
#*

# Notes storage directory
NOTES_DIR="$DVA_HOME/notes"
mkdir -p "$NOTES_DIR"

# Menu Title
NOTE_TITLE="Notes Manager"

# Menu Options
NOTE_OPTIONS=(
  "Create Note"
  "List Notes"
  "View Note"
  "Search Notes"
  "Delete Note"
)

#* ┏==================================================================================================┓
#* ┃                              📖 Notes Action Functions                                         ┃
#* ┗==================================================================================================┛
#*

function note_action_1() {
    print_card "📝 Create a New Note" "$CYAN"

    # Ask for note name
    read -p "$(echo -e "  📌 ${BOLD}Enter note name:${NC} ")" note_name
    echo ""

    # Ask for note content
    echo -e "  ✍️  ${BOLD}Enter note content (finish with Ctrl+D or Command+D):${NC}"
    echo -e "  ────────────────────────────────────────────────────────"
    note_content=$(</dev/stdin)
    echo ""

    # Save note
    echo "$note_content" > "$NOTES_DIR/$note_name.txt"
    print_status_success "Note '$note_name' saved successfully!"
}


function note_action_2() {
  print_card "📝 All Notes" "$CYAN"
  local notes=("$NOTES_DIR"/*.txt)
  
  if [ -e "${notes[0]}" ]; then
    for note in "${notes[@]}"; do
      echo -e "  📄 ${GREEN}$(basename "$note" .txt)${NC}"
    done
  else
    print_status_warning "No notes found."
  fi
  echo ""
}

function note_action_3() {
  # Get list of notes
  shopt -s nullglob
  local notes=("$NOTES_DIR"/*.txt)
  shopt -u nullglob
  
  # Check if any notes exist
  if [ ${#notes[@]} -eq 0 ]; then
    print_status_warning "No notes found!"
    return
  fi

  print_card "📝 Select a Note to View" "$CYAN"
  local i=1
  for note in "${notes[@]}"; do
    echo -e "  ${YELLOW}$i)${NC} $(basename "$note" .txt)"
    ((i++))
  done
  echo ""

  read -p "  Enter note number to view: " choice

  # Validate input
  if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#notes[@]} )); then
    print_status_error "Invalid choice!"
    return
  fi

  # Show selected note
  local selected_note="${notes[$((choice-1))]}"
  local note_content=$(cat "$selected_note")
  
  echo ""
  # Use YELLOW for the "sticky note" look
  print_card "🪧 $(basename "$selected_note" .txt)\n\n$note_content" "$YELLOW"
  echo ""
}

function note_action_4() {
  print_card "🔍 Search Notes" "$CYAN"
  read -p "$(echo -e "  🎯 ${BOLD}Enter keyword to search:${NC} ")" keyword
  echo ""
  
  shopt -s nullglob
  local notes=("$NOTES_DIR"/*.txt)
  shopt -u nullglob

  local found=0
  for note in "${notes[@]}"; do
    if grep -ilq "$keyword" "$note"; then
      echo -e "  📄 ${GREEN}$(basename "$note" .txt)${NC} contains matches:"
      # show matched snippet
      local snippet=$(grep -i "$keyword" "$note" | head -n 3 | sed 's/^/      > /')
      echo -e "${DIM}$snippet${NC}"
      ((found++))
    fi
  done
  
  if [ $found -eq 0 ]; then
    print_status_warning "No matches found for '$keyword'."
  fi
  echo ""
}

function note_action_5() {
  print_card "🗑️  Delete Note" "$RED"
  read -p "$(echo -e "  🏷️  ${BOLD}Enter note name to delete:${NC} ")" note_name
  if [[ -f "$NOTES_DIR/$note_name.txt" ]]; then
    rm "$NOTES_DIR/$note_name.txt"
    print_status_success "Note '$note_name' deleted!"
  else
    print_status_error "Note '$note_name' not found!"
  fi
}

#* ┏==================================================================================================┓
#* ┃                               📖 Notes Menu Loop                                               ┃
#* ┗==================================================================================================┛
#*

function run_note_menu() {
  local ACTION_PREFIX="note"
  menu_loop "$ACTION_PREFIX" "$NOTE_TITLE" "${NOTE_OPTIONS[@]}"
}