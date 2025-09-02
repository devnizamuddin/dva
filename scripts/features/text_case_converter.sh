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
  "Exit"
)


#* ┏==================================================================================================┓
#* ┃                              📖 Text Case Action Functions                                      ┃
#* ┗==================================================================================================┛
#*

action_1() {
  read -p "Enter your text: " input
  printf '%s\n' "$input" | tr '[:lower:]' '[:upper:]'
}

action_2() {
  read -p "Enter your text: " input
  printf '%s\n' "$input" | tr '[:upper:]' '[:lower:]'
}

action_3() {
  read -p "Enter your text: " input
  printf '%s\n' "$input" | perl -pe "\$_=lc(\$_); s/(?<!')\b([[:alpha:]])/\\u\$1/g"
}

action_4() {
  read -p "Enter your text: " input
  echo "$input" | tr '[:upper:]' '[:lower:]' | tr ' ' '_'
}

action_5() {
  read -p "Enter your text: " input
  echo "$input" | tr '[:upper:]' '[:lower:]' | tr ' ' '-'
}

action_6() {
  echo "👋 Bye!"
  return 1   # signal exit from menu loop
}


#* ┏==================================================================================================┓
#* ┃                               📖 Text Case Menu Loop                                            ┃
#* ┗==================================================================================================┛
#*

function run_text_case_converter() {
  menu_loop "$TEXT_CASE_TITLE" "${TEXT_CASE_OPTIONS[@]}"
}
