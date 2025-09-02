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
  "Back"
)

#* ┏==================================================================================================┓
#* ┃                              📖 Notes Action Functions                                         ┃
#* ┗==================================================================================================┛
#*

action_1() {
  read -p "Enter note name: " note_name
  read -p "Enter note content: " note_content
  echo "$note_content" > "$NOTES_DIR/$note_name.txt"
  echo "✅ Note '$note_name' saved!"
}

action_2() {
  echo "📝 Listing all notes:"
  ls -1 "$NOTES_DIR"
}

action_3() {
  read -p "Enter note name to view: " note_name
  if [[ -f "$NOTES_DIR/$note_name.txt" ]]; then
    echo "📄 Content of '$note_name':"
    cat "$NOTES_DIR/$note_name.txt"
  else
    echo "❌ Note '$note_name' not found!"
  fi
}

action_4() {
  read -p "Enter note name to delete: " note_name
  if [[ -f "$NOTES_DIR/$note_name.txt" ]]; then
    rm "$NOTES_DIR/$note_name.txt"
    echo "🗑️  Note '$note_name' deleted!"
  else
    echo "❌ Note '$note_name' not found!"
  fi
}

action_5() {
  echo "🔙 Going back to previous menu..."
  return 1  # Go back to previous menu
}

#* ┏==================================================================================================┓
#* ┃                               📖 Notes Menu Loop                                               ┃
#* ┗==================================================================================================┛
#*

function run_note_menu() {
  menu_loop "$NOTE_TITLE" "${NOTE_OPTIONS[@]}"
}
