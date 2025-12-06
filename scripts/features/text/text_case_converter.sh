#!/bin/bash

# * ┏==================================================================================================┓
# * ┃                           🔠 Text Case Converter: Options & Actions                             ┃
# * ┗==================================================================================================┛


# Menu Title
TEXT_CASE_TITLE="Text Case Converter"

# Menu Options
TEXT_CASE_OPTIONS=(
  "Upper Case (UPPERCASE)"
  "Lower Case (lowercase)"
  "Title Case (Title Case)"
  "Snake Case (snake_case)"
  "Kebab Case (kebab-case)"
  "Camel Case (camelCase)"
  "Pascal Case (PascalCase)"
)


# * ┏==================================================================================================┓
# * ┃                              📖 Text Case Action Functions                                       ┃
# * ┗==================================================================================================┛

function text_case_action_1() {
  read -p "Enter your text: " input
  output=$(printf '%s\n' "$input" | tr '[:lower:]' '[:upper:]')
  copy_and_print "$output"
}

function text_case_action_2() {
  read -p "Enter your text: " input
  output=$(printf '%s\n' "$input" | tr '[:upper:]' '[:lower:]')
  copy_and_print "$output"
}

function text_case_action_3() {
  read -p "Enter your text: " input
  output=$(printf '%s\n' "$input" | perl -pe 's/\b(\w)/\u$1/g')
  copy_and_print "$output"
}

function text_case_action_4() {
  read -p "Enter your text: " input
  output=$(printf '%s\n' "$input" | sed 's/\([a-z]\)\([A-Z]\)/\1_\2/g' | tr ' ' '_' | tr '[:upper:]' '[:lower:]')
  copy_and_print "$output"
}

function text_case_action_5() {
  read -p "Enter your text: " input
  output=$(printf '%s\n' "$input" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
  copy_and_print "$output"
}

function text_case_action_6() {
  read -p "Enter your text: " input
  output=$(printf '%s\n' "$input" | tr '[:upper:]' '[:lower:]' | perl -pe 's/ (\w)/\u$1/g')
  copy_and_print "$output"
}

function text_case_action_7() {
  read -p "Enter your text: " input
  output=$(printf '%s\n' "$input" | perl -pe 's/\b(\w)/\u$1/g; s/ //g')
  copy_and_print "$output"
}



# * ┏==================================================================================================┓
# * ┃                               📖 Text Case Menu Loop                                             ┃
# * ┗==================================================================================================┛

function run_text_case_converter() {
  local ACTION_PREFIX="text_case"
  
  menu_loop "$ACTION_PREFIX" "$TEXT_CASE_TITLE" "${TEXT_CASE_OPTIONS[@]}"
}


function copy_and_print() {
  local text="$1"
  printf "%s\n" "$text" | tee >(pbcopy)
}
