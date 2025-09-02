#!/bin/bash

#* ┏==================================================================================================┓
#* ┃                           🔠 Text Case Converter: Options & Actions                             ┃
#* ┗==================================================================================================┛
#*


# Menu Title
TEXT_CASE_TITLE="Text Case Converter"

# Menu Options
TEXT_CASE_OPTIONS=(
  "UPPERCASE (ABC)"
  "lowercase (abc)"
  "Title Case (Abc Def)"
  "Snake Case (abc_def)"
  "Kebab Case (abc-def)"
)


#* ┏==================================================================================================┓
#* ┃                              📖 Text Case Action Functions                                      ┃
#* ┗==================================================================================================┛
#*

text_case_action_1() {
  read -p "Enter your text: " input
  printf '%s\n' "$input" | tr '[:lower:]' '[:upper:]'
}

text_case_action_2() {
  read -p "Enter your text: " input
  printf '%s\n' "$input" | tr '[:upper:]' '[:lower:]'
}

text_case_action_3() {
  read -p "Enter your text: " input
  printf '%s\n' "$input" | perl -pe "\$_=lc(\$_); s/(?<!')\b([[:alpha:]])/\\u\$1/g"
}

text_case_action_4() {
  read -p "Enter your text: " input
  echo "$input" | tr '[:upper:]' '[:lower:]' | tr ' ' '_'
}

text_case_action_5() {
  read -p "Enter your text: " input
  echo "$input" | tr '[:upper:]' '[:lower:]' | tr ' ' '-'
}


#* ┏==================================================================================================┓
#* ┃                               📖 Text Case Menu Loop                                            ┃
#* ┗==================================================================================================┛
#*

function run_text_case_converter() {
  local ACTION_PREFIX="text_case"
  menu_loop "$ACTION_PREFIX" "$TEXT_CASE_TITLE" "${TEXT_CASE_OPTIONS[@]}"
}
