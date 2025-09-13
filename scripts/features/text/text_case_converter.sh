#!/bin/bash


#* ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
#* ║                                   💰 Imported Files                                              ║
#* ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝

source "$DVA_HOME/scripts/features/text/camel_case_converter.sh"
source "$DVA_HOME/scripts/features/text/kebab_case_converter.sh"
source "$DVA_HOME/scripts/features/text/pascal_case_converter.sh"
source "$DVA_HOME/scripts/features/text/snake_case_converter.sh"
source "$DVA_HOME/scripts/features/text/title_case_converter.sh"

#* ┏==================================================================================================┓
#* ┃                           🔠 Text Case Converter: Options & Actions                             ┃
#* ┗==================================================================================================┛
#*


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


#* ┏==================================================================================================┓
#* ┃                              📖 Text Case Action Functions                                      ┃
#* ┗==================================================================================================┛
#*

function text_case_action_1() {
  read -p "Enter your text: " input
  printf '%s\n' "$input" | tr '[:lower:]' '[:upper:]'
}

function text_case_action_2() {
  read -p "Enter your text: " input
  printf '%s\n' "$input" | tr '[:upper:]' '[:lower:]'
}

function text_case_action_3() {
  convert_to_title_case
}

function text_case_action_4() {
  convert_to_snake_case
}

function text_case_action_5() {
  convert_to_kebab_case
}

function text_case_action_6() {
  convert_to_camel_case
}

function text_case_action_7() {
  convert_to_pascal_case
}



#* ┏==================================================================================================┓
#* ┃                               📖 Text Case Menu Loop                                            ┃
#* ┗==================================================================================================┛
#*

function run_text_case_converter() {
  local ACTION_PREFIX="text_case"
  
  menu_loop "$ACTION_PREFIX" "$TEXT_CASE_TITLE" "${TEXT_CASE_OPTIONS[@]}"
}
