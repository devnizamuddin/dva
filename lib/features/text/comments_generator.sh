#!/bin/bash

#* ┏==================================================================================================┓
#* ┃                              📖 Comments Generator: Options & Actions                             ┃
#* ┗==================================================================================================┛

function get_author_info() {
  AUTHOR_NAME=$(git config user.name 2>/dev/null || echo "Your Name")
  AUTHOR_EMAIL=$(git config user.email 2>/dev/null || echo "your.email@example.com")
}

function print_generated_file_header() {
  get_author_info
  current_date=$(date +"%d %B %Y")
  current_time=$(date +"%I:%M:%S %p")
  
  local width=64
  local name_pad=$((width - 25 - ${#AUTHOR_NAME}))
  local email_pad=$((width - 25 - ${#AUTHOR_EMAIL}))
  
  echo "/*"
  echo " * ╔═══════════════════════════════════════════════════════════════╗"
  echo " * ║                                                               ║"
  printf " * ║ 🙎‍♂️ Author    : %s%*s║\n" "$AUTHOR_NAME" $name_pad ""
  echo " * ║                                                               ║"
  printf " * ║ 📧 Email     : %s%*s║\n" "$AUTHOR_EMAIL" $email_pad ""
  echo " * ║                                                               ║"
  echo " * ║ 🗓️ Date      : $current_date        🕰 Time : $current_time       ║"
  echo " * ║                                                               ║"
  echo " * ╚═══════════════════════════════════════════════════════════════╝"
  echo " */"
}

#* copy_generated_file_header()
#*                                                                                       Utilities # 1c
#* Generate a file header with author information and datetime information
# =====================================================================================================
#

function copy_generated_file_header() {
  get_author_info
  current_date=$(date +"%d %B %Y")
  current_time=$(date +"%I:%M:%S %p")
  
  local width=64
  local name_pad=$((width - 25 - ${#AUTHOR_NAME}))
  local email_pad=$((width - 25 - ${#AUTHOR_EMAIL}))

  {
  echo "/*"
  echo " * ╔═══════════════════════════════════════════════════════════════╗"
  echo " * ║                                                               ║"
  printf " * ║ 🙎‍♂️ Author    : %s%*s║\n" "$AUTHOR_NAME" $name_pad ""
  echo " * ║                                                               ║"
  printf " * ║ 📧 Email     : %s%*s║\n" "$AUTHOR_EMAIL" $email_pad ""
  echo " * ║                                                               ║"
  echo " * ║ 🗓️ Date      : $current_date        🕰 Time : $current_time       ║"
  echo " * ║                                                               ║"
  echo " * ╚═══════════════════════════════════════════════════════════════╝"
  echo " */"
  } | pbcopy
}