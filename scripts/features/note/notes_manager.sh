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
    read -p "$(echo -e "  📌 ${BOLD}Enter note name (e.g., \"api-plan\" or \"todo-list\"):${NC} ")" note_name
    echo ""

    if [[ -z "$note_name" ]]; then
       print_status_error "Note name cannot be empty."
       return
    fi

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
  shopt -s nullglob
  local notes=("$NOTES_DIR"/*.txt)
  shopt -u nullglob
  
  if [ ${#notes[@]} -eq 0 ]; then
    print_status_warning "No notes found!"
    return
  fi

  print_card "📝 Select a Note to View" "$CYAN"
  local note_names=()
  for note in "${notes[@]}"; do
    note_names+=("$(basename "$note" .txt)")
  done

  local selected=$(printf "%s\n" "${note_names[@]}" | fzf --prompt="Select Note: " --height=10 --border)
  
  if [[ -z "$selected" ]]; then
    print_status_info "Cancelled."
    return
  fi

  local selected_note="$NOTES_DIR/$selected.txt"
  local note_content=$(cat "$selected_note")
  
  echo ""
  print_card "🪧 $selected\n\n$note_content" "$YELLOW"
  echo ""
}

function note_action_4() {
  print_card "🔍 Search Notes" "$CYAN"
  read -p "$(echo -e "  🎯 ${BOLD}Enter keyword (e.g., \"auth\" or \"bug\"):${NC} ")" keyword
  echo ""
  
  if [[ -z "$keyword" ]]; then
     print_status_error "Search keyword cannot be empty."
     return
  fi

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
  shopt -s nullglob
  local notes=("$NOTES_DIR"/*.txt)
  shopt -u nullglob
  
  if [ ${#notes[@]} -eq 0 ]; then
    print_status_warning "No notes found!"
    return
  fi

  print_card "🗑️  Delete a Note" "$RED"
  local note_names=()
  for note in "${notes[@]}"; do
    note_names+=("$(basename "$note" .txt)")
  done

  local selected=$(printf "%s\n" "${note_names[@]}" | fzf --prompt="Note to delete: " --height=10 --border)
  
  if [[ -z "$selected" ]]; then
    print_status_info "Cancelled."
    return
  fi

  rm "$NOTES_DIR/$selected.txt"
  print_status_success "Note '$selected' deleted!"
}

#* ┏==================================================================================================┓
#* ┃                               📖 Notes Menu Loop                                               ┃
#* ┗==================================================================================================┛
#*

function run_note_menu() {
  local ACTION_PREFIX="note"
  menu_loop "$ACTION_PREFIX" "$NOTE_TITLE" "${NOTE_OPTIONS[@]}"
}