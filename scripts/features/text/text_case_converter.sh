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

function get_input() {
  echo ""
  read -p "$(echo -e "  ${GREEN}🖌   Enter your text (e.g., \"make this relaxing\"): ${NC}")" input
  echo ""
}

function normalize_text() {
  local input="$1"
  # 1️⃣ Replace underscores and dashes with spaces
  local temp="${input//[_-]/ }"
  # 2️⃣ Split camelCase or PascalCase words
  temp=$(echo "$temp" | sed -E 's/([a-z0-9])([A-Z])/\1 \2/g')
  # 3️⃣ Normalize multiple spaces and convert to lowercase
  temp=$(echo "$temp" | tr -s ' ' | tr '[:upper:]' '[:lower:]')
  # 4️⃣ Trim leading/trailing spaces
  temp=$(echo "$temp" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  echo "$temp"
}

function text_case_action_1() {
  get_input
  output=$(printf '%s\n' "$input" | tr '[:lower:]' '[:upper:]')
  copy_and_print "$output"
}

function text_case_action_2() {
  get_input
  output=$(printf '%s\n' "$input" | tr '[:upper:]' '[:lower:]')
  copy_and_print "$output"
}

function text_case_action_3() {
  get_input
  local norm=$(normalize_text "$input")
  output=$(printf '%s\n' "$norm" | perl -pe 's/\b(\w)/\u$1/g')
  copy_and_print "$output"
}

function text_case_action_4() {
  get_input
  local norm=$(normalize_text "$input")
  output=$(printf '%s\n' "$norm" | tr ' ' '_')
  copy_and_print "$output"
}

function text_case_action_5() {
  get_input
  local norm=$(normalize_text "$input")
  output=$(printf '%s\n' "$norm" | tr ' ' '-')
  copy_and_print "$output"
}

function text_case_action_6() {
  get_input
  local norm=$(normalize_text "$input")
  output=$(printf '%s\n' "$norm" | perl -pe 's/ (\w)/\u$1/g')
  copy_and_print "$output"
}

function text_case_action_7() {
  get_input
  local norm=$(normalize_text "$input")
  output=$(printf '%s\n' "$norm" | perl -pe 's/\b(\w)/\u$1/g; s/ //g')
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
  printf "%s" "$text" | pbcopy
  print_card "📋 Converted Text (Copied to Clipboard):\n\n$text" "$BLUE"
  echo ""
}
