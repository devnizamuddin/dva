#!/bin/bash

#* ┏==================================================================================================┓
#* ┃                              📖 Comments Generator: Options & Actions                             ┃
#* ┗==================================================================================================┛

function print_generated_file_header() {
  # Get current date in format "07 March 2025"
  current_date=$(date +"%d %B %Y")
  
  # Get current time in format "12:38:26 AM"
  current_time=$(date +"%I:%M:%S %p")
  # Output the header
  echo "/*"
  echo " * ╔═══════════════════════════════════════════════════════════════╗"
  echo " * ║                                                               ║"
  echo " * ║ 🙎‍♂️ Author    : Nizam Uddin Shamrat                            ║"
  echo " * ║                                                               ║"
  echo " * ║ 📧 Email     : dev.nizamuddin@gmail.com                       ║"
  echo " * ║                                                               ║"
  echo " * ║ 🌍 Portfolio : https://devnizamuddin.github.io                ║"
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
  # Get current date in format "07 March 2025"
  current_date=$(date +"%d %B %Y")
  
  # Get current time in format "12:38:26 AM"
  current_time=$(date +"%I:%M:%S %p")
  {
  # Output the header
  echo "/*"
  echo " * ╔═══════════════════════════════════════════════════════════════╗"
  echo " * ║                                                               ║"
  echo " * ║ 🙎‍♂️ Author    : Nizam Uddin Shamrat                            ║"
  echo " * ║                                                               ║"
  echo " * ║ 📧 Email     : dev.nizamuddin@gmail.com                       ║"
  echo " * ║                                                               ║"
  echo " * ║ 🌍 Portfolio : https://devnizamuddin.github.io                ║"
  echo " * ║                                                               ║"
  echo " * ║ 🗓️ Date      : $current_date        🕰 Time : $current_time       ║"
  echo " * ║                                                               ║"
  echo " * ╚═══════════════════════════════════════════════════════════════╝"
  echo " */"
  } | pbcopy
}