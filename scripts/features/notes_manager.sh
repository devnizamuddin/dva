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
  "Delete Note"
)

#* ┏==================================================================================================┓
#* ┃                              📖 Notes Action Functions                                         ┃
#* ┗==================================================================================================┛
#*

function note_action_1() {
  read -p "Enter note name: " note_name
  read -p "Enter note content: " note_content
  echo "$note_content" > "$NOTES_DIR/$note_name.txt"
  echo "✅ Note '$note_name' saved!"
}

function note_action_2() {
  echo "📝 Listing all notes:"
  ls -1 "$NOTES_DIR"
}

function note_action_3() {
  # Get list of notes
  local notes=("$NOTES_DIR"/*.txt)
  
  # Check if any notes exist
  if [ ${#notes[@]} -eq 0 ]; then
    echo "❌ No notes found!"
    return
  fi

  echo "📝 Notes List:"
  local i=1
  for note in "${notes[@]}"; do
    echo "$i) $(basename "$note" .txt)"
    ((i++))
  done

  # Prompt user to select by number
  read -p "Enter note number to view: " choice

  # Validate input
  if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#notes[@]} )); then
    echo "❌ Invalid choice!"
    return
  fi

  # Show selected note
  local selected_note="${notes[$((choice-1))]}"
  echo "📄 Content of '$(basename "$selected_note" .txt)':"
  echo "-------------------------"
  cat "$selected_note"
  echo "-------------------------"
}


function note_action_4() {
  read -p "Enter note name to delete: " note_name
  if [[ -f "$NOTES_DIR/$note_name.txt" ]]; then
    rm "$NOTES_DIR/$note_name.txt"
    echo "🗑️  Note '$note_name' deleted!"
  else
    echo "❌ Note '$note_name' not found!"
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