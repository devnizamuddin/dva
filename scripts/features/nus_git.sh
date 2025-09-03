#!/bin/bash

#_|_|                                                                                                                                                       
#_|_| ╔-Console Text Style Elements Start-════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗  
#_|_|                                                                                                                                                       

#* Text Color
#
RED='\033[31m'
GREEN='\033[32m'
BLUE='\033[34m'
YELLOW='\033[33m'
MAGENTA='\033[35m'
CYAN='\033[36m'
WHITE='\033[97m'
GOLDEN='\033[38;5;214m'
#
#* Text Style
#
BOLD='\033[1m'
DIM='\033[2m'
UNDERLINE='\033[4m'
BLINK='\033[5m'
REVERSE='\033[7m'
STRIKETHROUGH='\033[9m'
#
#* Background Color Variables
#
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
BG_MAGENTA='\033[45m'
BG_CYAN='\033[46m'
BG_WHITE='\033[47m'
BG_GOLDEN='\033[48;5;214m'  # Extended color for golden background

#* Reset the style
RESET='\033[0m'

#→                                                                                                                                                           
#→ ╚═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════-Console Text Style Elements End-╝  
#→                                                                                                                                                           


#!═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════



##                                                                                                                                                       
## Main Activities - Option # 9                                                                                                                          
##                                                                                                                                                       
## ╔═ Utilities Activities Execution Start ════════════════════════════════════════════════════════════════════════════════════════════════════════════╗  
##                                                                                                                                                       


#* utilitiesTask()
#*                                                                                    Utilities - Start
#* Do list of utilities activities
# =====================================================================================================
#

function utilitiesTask() {

  local choosenUtil=-1

  while [[ "$choosenUtil" != "0" ]]; do
    
    show_utilities_options

    read -p "$(echo -e "\n${BOLD}${GREEN}Enter your choice 1-4${RESET} || ${YELLOW}0 ⏎ Main : ${RESET}")" choosenUtil
    echo ""

    if [[ "$choosenUtil" == "0" ]]; then
      echo -e "${YELLOW}Returning to Main functionalities...${RESET}"
      echo ""
      echo ""
      return 0
    fi

    exetcute_choosen_utilities $choosenUtil

  done

  exit 0
}


#* show_utilities_options()
#*                                                                                   # Utilities - View
#* Shows all available utilities options
# =====================================================================================================
#

function show_utilities_options() {
  echo ""
  echo -e "${BOLD}${BG_BLUE}                                                                                                       ${RESET}"
  echo -e "${BOLD}${BG_BLUE}                                   ╔══════════════════════════════╗                                    ${RESET}"
  echo -e "${BOLD}${BG_BLUE}                                   ║                              ║                                    ${RESET}"
  echo -e "${BOLD}${BG_BLUE}                                   ║   Select An Utility   👨‍💼   ║                                    ${RESET}"
  echo -e "${BOLD}${BG_BLUE}                                   ║                              ║                                    ${RESET}"
  echo -e "${BOLD}${BG_BLUE}                                   ╚══════════════════════════════╝                                    ${RESET}"
  echo -e "${BOLD}${BG_BLUE}                                                                                                       ${RESET}"
  echo ""
  echo ""
  echo -e "  1 → File Header ㊉ ${CYAN}${BOLD}(c → Copy)${RESET}                  2 → Upgrade Project Version"
  echo "" 
  echo -e "  3 → Git Source Link                           4 → ${GOLDEN}Undecided${RESET}"
  echo ""
}


#* exetcute_choosen_utilities()
#*                                                                              # Utilities - Execution
#* Executes the chosen git operation
# =====================================================================================================
#

function exetcute_choosen_utilities(){
 local choosenUtil="$1"

  if [[ "$choosenUtil" =~ ^[0-9a-zA-Z]+$ ]]; then

    case $choosenUtil in
      1)
        print_generated_file_header
        ;;
      1c)
        copy_generated_file_header
        ;;
      2)
        upgradeProjectVersion
        ;;
      3)
        showSourceCodeLink
        ;;
      4)
        printUnimplementedMessage
        ;;
      *)
        echo -e "${GOLDEN}Option not recognized${RESET}"
        echo ""
        ;;
    esac
  else
    echo ""
    echo -e "${RED}Invalid option. Please select a valid option.${RESET}"
    echo ""
  exit 0
  fi
}



#?
#? ╔-Function of Utilities Activities-══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
#?


#* show_progress_dots()
#*                                                                                        Utilities ###
#* Show progress dots while running a long running task
# =====================================================================================================
#

# Function: 


# Function: Show progress dots with colored text while running a command
show_progress_dots() {
  local message="${1}"
  shift
  local cmd=("$@")  # Command passed as arguments

  local delay=0.5
  local count=0

  # Hide cursor during animation
  tput civis
  echo ""
  echo ""

  # Start spinner in background
  (
    while :; do
      count=$(( (count + 1) % 4 ))
      dots=$(printf "%*s" "$count" | tr ' ' '.')
      printf "\r${CYAN}${BOLD}⏳ %s${dots}${RESET}" "$message"
      sleep "$delay"
    done
  ) &
  local spinner_pid=$!

  # Run the actual command silently
  "${cmd[@]}" >/dev/null 2>&1

  # Stop spinner
  kill "$spinner_pid" >/dev/null 2>&1
  wait "$spinner_pid" 2>/dev/null

  # Clean up output and print done message
  printf "\r${GREEN}✅ %s... Done!${RESET}\n" "$message"
  echo ""
  echo ""
  tput cnorm  # Show cursor again
}

#* print_generated_file_header()
#*                                                                                        Utilities # 1
#* Generate a file header with author information and datetime information
# =====================================================================================================
#

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

#* upgradeProjectVersion()
#*                                                                                        Utilities # 2
#* Upgrade the project version
# =====================================================================================================
#

function upgradeProjectVersion(){

  # Extract the current version from pubspec.yaml
  current_version=$(grep '^version:' pubspec.yaml | awk '{print $2}')

  # Extract version name and version code separately
  version_name=$(echo "$current_version" | cut -d'+' -f1)
  version_code=$(echo "$current_version" | cut -d'+' -f2)

  # Increment version code
  new_version_code=$((version_code + 1))

  # Increment patch version (last digit of version name)
  IFS='.' read -r major minor patch <<< "$version_name"
  new_patch=$((patch + 1))

  # Generate the new version
  new_version_name="$major.$minor.$new_patch"

  # Update pubspec.yaml with the new version
  sed -i '' "s/^version: .*/version: $new_version_name+$new_version_code/" pubspec.yaml

  echo -e "\n✅ Version updated to: $new_version_name+$new_version_code"

}

#* showSourceCodeLink()
#*                                                                                        Utilities # 3
#* Show the source code link
# =====================================================================================================
#

function showSourceCodeLink() {
  echo ""
  echo "🔗 Git Remote URLs"
  echo "═══════════════════════════════════════════════"

  # Print Fetch URLs
  echo -e "\n📥 Fetch URLs:"
  git remote -v | grep '(fetch)' | awk '{print "📦 " $1 ": " $2}'

  # Print Push URLs
  echo -e "\n📤 Push URLs:"
  git remote -v | grep '(push)' | awk '{print "📦 " $1 ": " $2}'

  echo -e "\n═══════════════════════════════════════════════"
  echo ""
}


#? printUnimplementedMessage()
#?                                                                                       Utilities # -1
#? Print a message indicating that the feature is not implemented yet
#? =====================================================================================================
#?

function printUnimplementedMessage() {
  echo -e "${BLINK}${RED}⚠️  This feature is not implemented yet.!${RESET}"
  echo ""
}


#!
#! ╚════════════════════════════════════════════════════════════════════════════════════════════════════════════════════-Function of Utilities Activities-╝
#!


#→                                                                                                                                                           
#→ ╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════════-Utilities Activities Execution End-╝  
#→                                                                                                                                                           



#!═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════



#_|_|                                                                                                                                                       
#_|_| ╔-Main Activities - Helper Function-══════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗  
#_|_|                                                                                                                                                       


#*                                                                             Main Activities - Helper Function # 1
#* This function display all untracked and modified files by categories.
#* Categories → 1. Staged files 2. Unstaged files 3 Untracked files
#*
#* =====================================================================================================
#*
function showAllFileChangesAsNumberedList() {
    echo ""
    
    # Get staged, unstaged, and untracked files
    staged_files=$(git diff --name-only --cached)
    unstaged_files=$(git diff --name-only)
    untracked_files=$(git ls-files --others --exclude-standard)  # Show new files

    # Display Staged Files (Already Staged)
    echo -e "${BOLD}${CYAN}✅ Staged files (Already added):${RESET}"
    echo -e "${BOLD}${CYAN}═════════════════════════════════════════════════════════════════════${RESET}"
    echo ""
    
    staged_list=()

    if [[ -z "$staged_files" ]]; then
        echo -e "${YELLOW}  No staged files.${RESET}"
    else
        i=1
        for file in $staged_files; do
            echo -e "${GREEN}  $i. $file${RESET}"
            echo ""
            staged_list+=("$file")
            ((i++))
        done
    fi
    echo ""

    # Display Unstaged Files (Modified but not staged)
    echo -e "${BOLD}${CYAN}⚠️  Unstaged files (Modified but not staged):${RESET}"
    echo -e "${BOLD}${CYAN}═════════════════════════════════════════════════════════════════════${RESET}"
    echo ""
    unstaged_list=()
    i=1
    if [[ -n "$unstaged_files" ]]; then
        for file in $unstaged_files; do
            echo -e "${BOLD}${WHITE}  $i. $file${RESET}"
            echo ""
            unstaged_list+=("$file")
            ((i++))
        done
    else
        echo -e "${YELLOW}  No unstaged files.${RESET}"
    fi
    echo ""

    # Display Untracked Files (New files)
    echo -e "${BOLD}${CYAN}🆕 Untracked files (Not in Git yet):${RESET}"
    echo -e "${BOLD}${CYAN}═════════════════════════════════════════════════════════════════════${RESET}"
    echo ""
    
    if [[ -n "$untracked_files" ]]; then
        for file in $untracked_files; do
            echo -e "${WHITE}  $i. $file${RESET}"
            echo ""
            unstaged_list+=("$file")
            ((i++))
        done
    else
        echo -e "${YELLOW}  No untracked files.${RESET}"
    fi
    echo ""
}


#*                                                                             Main Activities - Helper Function # 2
#* This function display all staged files.
#*
#* =====================================================================================================
#*
function showAllStagesFileAsNumberedList(){

  local staged_files=$(git diff --name-only --cached)

  # Display Staged Files
    echo ""
    echo ""
    echo -e "${BOLD}${CYAN}✅ Staged files:${RESET}"
    echo -e "${BOLD}${CYAN}═════════════════════════════════════════════════════════════════════${RESET}"
    echo ""
    

    if [[ -z "$staged_files" ]]; then
        echo -e "${YELLOW}  No staged files.${RESET}"
    else
        i=1
        for file in $staged_files; do
            echo -e "${GREEN}  $i. $file${RESET}"
            echo ""
            ((i++))
        done
    fi
}


#*                                                                             Main Activities - Helper Function # 3
#* Take number list by (comma separation) as input from numbered list
#* Stage number list and display 
#*
#* =====================================================================================================
#*
function inputFileNumbersToStageAndDisplay(){
  
      read -r -p $'\n📌 \033[1;32mEnter the numbers of files to stage (comma-separated)\033[0m \033[1;31m0 to Back:\033[0m ' selected_numbers

      IFS=',' read -ra selected_indices <<< "$selected_numbers"

      # Stage selected files

      # Check if any files were selected
      if [ ${#selected_numbers[@]} -eq 0 ]; then
      echo ""
      echo ""
      echo -e "${BLUE}Back to Main...${RESET}"
      else
        # Convert input to an array of selected files
        # Stage selected files
        for index in "${selected_indices[@]}"; do
            file_to_stage="${unstaged_list[$((index-1))]}"
            if [[ -n "$file_to_stage" ]]; then
                git add "$file_to_stage"
                files_to_add+=("$file_to_stage")
            fi
        done
        # Display the list of files that were added
        showAllStagesFileAsNumberedList
      fi

}


#*                                                                             Main Activities - Helper Function # 4
#* Take number list by (comma separation) as input from numbered list
#! UnStage number list and display 
#*
#* =====================================================================================================
#*
function inputFileNumbersToUnStageAndDisplay(){
  
      echo -e "\n📌 ${BOLD}${CYAN}Enter the numbers of files to unstage (comma-separated):${RESET}"
      echo -e "${BOLD}${CYAN}Example:${RESET} 1,3,5"
      echo -e "\n➡️ Your selection: \c"
      read -r selected_numbers

      # Convert input to an array
      IFS=',' read -ra selected_indices <<< "$selected_numbers"

      # Stage selected files
      for index in "${selected_indices[@]}"; do
          file_to_unstage="${staged_list[$((index-1))]}"
          if [[ -n "$file_to_unstage" ]]; then
              git reset "$file_to_unstage"
              files_to_remove+=("$file_to_unstage")
          fi
      done

      # Check if any files were selected
      if [ ${#files_to_remove[@]} -eq 0 ]; then
          echo -e "${RED}❌ No files selected. Exiting...${RESET}"
          exit 1
      fi

  # Display the list of files that were added
  echo ""
  echo -e "\n📚 ${BOLD}${CYAN}UnStaged Files:${RESET}\n"
  echo -e "${BOLD}${CYAN}═════════════════════════════════════════════════════════════════════${RESET}"
  for file in "${files_to_remove[@]}"; do
      echo -e "${GREEN}  - $file${RESET}"
  done
}


#*                                                                             Main Activities - Helper Function # 5
#* Execute the git push operation
#* =====================================================================================================
#*
function git_push() {

  branch_name=$(git rev-parse --abbrev-ref HEAD)

  git fetch origin

  changed_files=$(git log --name-only --oneline origin/"$branch_name".."$branch_name")

  #* Push the changes to the remote repository
  git push origin "$branch_name"

  #* Show the files changed between local and remote branch
  echo ""
  echo -e "${BOLD}${CYAN}📂 Files Changed in this Push :${RESET}"
  echo ""
  echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════════════════════${RESET}"
  echo ""

  if [ -z "$changed_files" ]; then
    echo -e "${RED}No changes detected between the local and remote branches.${RESET}"
  else
    echo "$changed_files" | while read line; do
      if [[ "$line" =~ ^[a-f0-9]{7} ]]; then
        echo -e "${BOLD}${WHITE}$line${RESET}"  
      else
        echo -e "${GREEN}$line${RESET}"
      fi
    done
  fi

  echo ""
  echo ""

}


#*                                                                             Main Activities - Helper Function # 6
#* Execute the git pull operation
#* =====================================================================================================
#*
function git_pull() {

    # local variables 
    local chose_branch=-1

    # Fetch all branches from the remote
    show_progress_dots "Fetching active branches" git fetch --prune

    BRANCHES=($(git branch -r | grep -v '\->' | sed 's/origin\///'))

    if [ ${#BRANCHES[@]} -eq 0 ]; then
    #!---------------------------> No remote branches found! <---------------------------
    
        echo -e "${RED}❌ No remote branches found!${RESET}"
        exit 1
    fi

    #---------------------------> Having remote branches found! <---------------------------

    echo -e "\n${CYAN}📂 Available Active Branches:${RESET}"
    echo -e "${BOLD}${CYAN}═════════════════════════════════════════════════════════════════════${RESET}"
    echo ""

    COLUMN_WIDTH=20
    for i in "${!BRANCHES[@]}"; do
        printf "%-2d. %-*s" "$(($i + 1))" "$COLUMN_WIDTH" "${BRANCHES[$i]}"
        if (( ($i + 1) % 2 == 0 )); then
            echo "" 
            echo "" 
        fi
    done
    echo ""

    #*---------------------------> Taking user input(number) to select branch  <---------------------------

    read -p "$(echo -e "\n${GREEN}🖌   Enter the branch number: ${RESET}")" chose_branch


    if ! [[ "$chose_branch" =~ ^[0-9]+$ ]] || [ "$chose_branch" -lt 1 ] || [ "$chose_branch" -gt "${#BRANCHES[@]}" ]; then
        echo ""
        echo -e "${RED}❌ Invalid selection! Please enter a valid number.${RESET}"
        echo ""
        exit 1
    fi

    SELECTED_BRANCH="${BRANCHES[$((chose_branch - 1))]}"


    #*---------------------------> Pulling commits from selected branch  <---------------------------
    show_progress_dots "Pulling latest changes from ${SELECTED_BRANCH}" git pull origin "$SELECTED_BRANCH"
    echo ""
}


#*                                                                             Main Activities - Helper Function # 7
#* Show Branch Updates By Comparing Mine
#*
#* =====================================================================================================
#*
function showBranchUpdatesByComparingMine() {

  BRANCH=$1
  
  echo ""

  echo -e "${BOLD}${RED}Conflict files with ${BRANCH}:${RESET}"
  echo -e "${BOLD}${RED}═════════════════════════════════════════════════════════════════════${RESET}"
  echo ""
  git diff --name-only --diff-filter=U origin/"$BRANCH"...HEAD | while read -r file; do
    echo "- $file"
    echo ""
  done
  echo ""

  echo -e "${BOLD}${CYAN}Changed files with ${BRANCH}:${RESET}"
  echo -e "${BOLD}${CYAN}═════════════════════════════════════════════════════════════════════${RESET}"
  echo ""
  git diff --name-only --diff-filter=M origin/"$BRANCH"...HEAD | while read -r file; do
      echo "- $file"
      echo ""
  done
  echo ""

  echo -e "${BOLD}${BLUE}New files with ${BRANCH}:${RESET}"
  echo -e "${BOLD}${BLUE}═════════════════════════════════════════════════════════════════════${RESET}"
  echo ""
  git diff --name-only --diff-filter=A origin/"$BRANCH"...HEAD | while read -r file; do
    echo "- $file"
    echo ""
  done
  echo ""


  echo ""
}


#*                                                                             Main Activities - Helper Function # 8
#* Execute the git pull operation
#* =====================================================================================================
#*
function showActiveBranches() {
    echo ""
    echo -e "${YELLOW}🔄 Fetching active branches...${RESET}"
    echo ""
    git fetch --prune 

    BRANCHES=($(git branch -r | grep -v '\->' | sed 's/origin\///'))

    if [ ${#BRANCHES[@]} -eq 0 ]; then
        echo -e "${RED}❌ No remote branches found!${RESET}"
        exit 1
    fi
    echo ""
    echo -e "${BOLD}${CYAN}📂 Available Active Branches:${RESET}"
    echo -e "${BOLD}${CYAN}═════════════════════════════════════════════════════════════════════${RESET}"
    echo ""
    COLUMN_WIDTH=20
    for i in "${!BRANCHES[@]}"; do
        printf "%-2d. %-*s" "$(($i + 1))" "$COLUMN_WIDTH" "${BRANCHES[$i]}"
        if (( ($i + 1) % 2 == 0 )); then
            echo "" 
            echo "" 
        fi
    done
    echo ""
}

function selectBranch(){

  read -p "$(echo -e "\n${GREEN}✅ Enter the branch number: ${RESET}")" CHOICE


  if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ "$CHOICE" -lt 1 ] || [ "$CHOICE" -gt "${#BRANCHES[@]}" ]; then
      echo -e "${RED}❌ Invalid selection! Please enter a valid number.${RESET}"
      exit 1
  fi

  SELECTED_BRANCH="${BRANCHES[$((CHOICE - 1))]}"

  echo "$SELECTED_BRANCH"
}


#→                                                                                                                                                           
#→ ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════-Main Activities - Helper Function End-╝  
#→                                                                                                                                                           




#!═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════





#_|_|                                                                                                                                                       
#_|_| ╔-Main Activities Execution Start-══════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗  
#_|_|                                                                                                                                                       



#?
#? ╔-Function of Main Activities-═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
#?




#*                                                                                    Main Activity # 1
#* Show all files by category
#* Stage files from user input
#
# =====================================================================================================
#
function stage_choosen_files () {
  showAllFileChangesAsNumberedList

  if [ ${#unstaged_list[@]} -eq 0 ]; then
    echo -e "\n${RED}❌  No file to stage...${RESET}\n"
  else
    inputFileNumbersToStageAndDisplay
  fi
}


#*                                                                                   Main Activity # 1a
#* Stage all file changes and display
#
# =====================================================================================================
#
function stage_all_files() {
  # Get staged, unstaged, and untracked files
  local unstaged_files=$(git diff --name-only)
  local untracked_files=$(git ls-files --others --exclude-standard)  # Show new files
  local all_files_to_add=()  # Declare local variable

  # Stage selected files
  for unstagedFile in $unstaged_files; do
        all_files_to_add+=("$unstagedFile")
  done
  # Stage selected files
  for untrackedFile in $untracked_files; do
        all_files_to_add+=("$untrackedFile")
  done

  if [ ${#all_files_to_add[@]} -gt 0 ]; then
    git add .
    echo -e "\n✅ All unstaged & untracked files have been staged...\n"
    showAllStagesFileAsNumberedList
  else
    echo -e "\n❌ No files to stage.\n"
  fi
}

#*                                                                                    Main Activity # 2
#* Show all stage files as as numbered List
#! UnStage files from user input
#
# =====================================================================================================
#
function unstage_choosen_files(){
  staged_files=$(git diff --name-only --cached)

  echo ""

  if [[ -z "$staged_files" ]]; then
      echo -e "${YELLOW}  No staged files to unstage.${RESET}"
      return
      fi

  showAllStagesFileAsNumberedList
  inputFileNumbersToUnStageAndDisplay
}


#*                                                                                   Main Activity # 2a
#* Show all stage files as as numbered List
#! UnStage files from user input
#
# =====================================================================================================
#
function unstage_All_changed_file(){

  staged_files=$(git diff --name-only --cached)

  echo ""

  if [[ -z "$staged_files" ]]; then
      echo -e "${YELLOW}  No staged files to unstage.${RESET}"
      return
  else
      i=1
      echo -e "${BOLD}${CYAN}⚠️ Currently Unstaged files:${RESET}"
      echo -e "${BOLD}${CYAN}═════════════════════════════════════════════════════════════════════${RESET}"
      echo ""
      for file in $staged_files; do
          echo -e "${GREEN}  $i. $file${RESET}"
          echo ""
          staged_list+=("$file")
          ((i++))
      done
      git reset > /dev/null 2>&1
  fi
  staged_files=()
}


#*                                                                                    Main Activity # 3
#* Execute the git commit operation
#* Commit the staged files with a choosen prefix.
#
# =====================================================================================================
#
function commit_changes() {
    # Get staged file list
    staged_files=$(git diff --name-only --cached)

    # If no staged files, stop execution and exit the function
    if [[ -z "$staged_files" ]]; then
      echo -e "${YELLOW}No staged files to commit.${RESET}"
      echo ""
      return 1
    fi

    # Print the staged files
    echo -e "${BOLD}${CYAN}📂 Staged Files:${RESET}"
    echo -e "${BOLD}${CYAN}═════════════════════════════════════════════════════════════════════${RESET}"
    echo ""

    while IFS= read -r file; do
      echo -e " - ${GREEN}$file${RESET}"
      echo ""  # Add a blank line for better readability
    done <<< "$staged_files"

    # Prompt for commit prefix selection
    echo ""
    echo -e "\n📌${BOLD}${CYAN} Choose a commit prefix${RESET} || ${RED}0 → Back${RESET} \n"
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════════════════════${RESET}"
    echo ""
    echo "  1 → ✨ Feat      - New Impl                     2 → 🐛 Fix       - Bug fixes"
    echo ""
    echo "  3 → ⏪ Revert    - Changing Impl                4 → 🔨 Refactor  - Improving Impl"
    echo ""
    echo "  5 → 🎨 Style     - Format Code                  6 → 🧹 Chore     - Non-functional"
    echo ""
    echo "  7 → 📚 Docs      - Documentation                8 → ✅ Test      - Testing code"
    echo ""
    echo "  9 → 🚀 Deploy    - Deployment                   * → © Custom     - Custom Prefix"
    echo ""
    echo ""
    echo -e "👉 ${GREEN}Enter your choice (1-9)${RESET} || ${GOLDEN}✏️ Custom (Any)${RESET}: \c"
    read -r prefix_choice
    echo ""

    # Check if any files were selected
    if [ ${#prefix_choice[@]} -eq 0 ]; then
      echo ""
      echo ""
      echo -e "${BLUE}Back to Main...${RESET}"
    else

      # Set the prefix based on user choice
      case $prefix_choice in
          1) prefix="✨ Feat" ;;
          2) prefix="🐛 Fix" ;;
          3) prefix="⏪ Revert" ;;
          4) prefix="🔨 Refactor" ;;
          5) prefix="🎨 Style" ;;
          6) prefix="🧹 Chore" ;;
          7) prefix="📚 Docs" ;;
          8) prefix="✅ Test" ;;
          9) prefix="🚀 Deploy" ;;
          *)
            read -p "$(echo -e "\n${GOLDEN}✏️ Enter custom prefix: ${RESET}")" prefix
            echo ""
            ;;
      esac

      # Get commit message
      if [ -z "$1" ]; then
          read -p "$(echo -e "\n${BOLD}${GOLDEN} 🖋️  Enter commit message: ${RESET}")" commit_message
      else
          commit_message="$1"
      fi

      # Combine the prefix with the message if applicable
      if [ -n "$prefix" ]; then
          commit_message="$prefix: $commit_message"
      fi

      # Commit the changes
      git commit -m "$commit_message"

      echo -e "\n✅ Commit successful!\n"

      # Display Staged Files (Already Staged)
      echo -e "${BOLD}${CYAN}✅ Commited Files:${RESET}"
      echo -e "${BOLD}${CYAN}═════════════════════════════════════════════════════════════════════${RESET}"
      echo ""
      
      if [[ -z "$staged_files" ]]; then
          echo -e "${YELLOW}  No files commited.${RESET}"
      else
          i=1
          for file in $staged_files; do
              echo -e "${GREEN}  $i. $file${RESET}"
              echo ""
              staged_list+=("$file")
              ((i++))
          done
      fi
      echo ""
    fi
}


#*                                                                                   Main Activity # 3a
#* Execute the git commit and push operation at a time
#
# =====================================================================================================
#
function commit_and_push() {
  commit_changes
  git_push
}


#*                                                                                    Main Activity # 4
#* Execute pull and push operation at a time
#
# =====================================================================================================
#
function pull_and_push() {
  git_pull
  git_push
}


#*                                                                                    Main Activity # 4m
#* Execute merge
#
# =====================================================================================================
#
function merge_branch() {
  showActiveBranches
  branch=$(selectBranch)
  echo ""
  showBranchUpdatesByComparingMine $branch
}


#* git_diff_branches()
#*                                                                                    Main Activity # 5
#* Show the difference between two branches
# =====================================================================================================
#

function git_diff_branches() {
  echo "Enter the source branch (e.g., master):"
  read -r source_branch
  echo "Enter the target branch (e.g., feature-branch):"
  read -r target_branch

  echo "Showing diff between $source_branch and $target_branch..."
  git diff "$source_branch" "$target_branch"
}


#* git_log()
#*                                                                                    Main Activity # 6
#* Show the commit history
# =====================================================================================================
#

function git_log() {
  echo "Showing the commit history..."
  # git log --pretty=oneline
  git log --oneline --graph --decorate \
  --pretty=format:"%C(yellow)%ad%Creset %C(cyan)$(git branch --contains | grep -v 'HEAD' | sed 's/^[[:space:]]*//')%Creset %C(green)* %an%n%n%Creset%s%n%n" --date=format:'%Y-%m-%d %I:%M %p'
}


#* show_commit_changes()
#*                                                                                    Main Activity # 7
#* Show the files changed in the last 5 commits
# =====================================================================================================
#

function show_commit_changes() {

  branch_name=$(git rev-parse --abbrev-ref HEAD)

  #* Show the files changed in the last 5 commits
  echo -e "${BOLD}${CYAN}📂 Files Changed in the last 5 commit :${RESET}"
  echo ""
  echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════════════════════${RESET}"
  echo ""

  git log -n 5 --name-only --oneline | while read line; do
    if [[ $line =~ ^[a-f0-9]{7} ]]; then
      echo ""
      echo -e "\n${BOLD}${WHITE}$line${RESET}"
      echo -e "${WHITE}═══════════════════════════════════════════════════════════════════════════${RESET}"
    else
      echo ""
      echo -e "${GREEN}$line${RESET}"
    fi
  done
  echo ""
  echo ""
}


#* git_soft_reset()
#*                                                                                   Main Activity # 8s
#* Soft reset the repository
# =====================================================================================================
#

function git_soft_reset() {
  git reset HEAD~1 --soft
}



#* git_hard_reset()
#*                                                                                   Main Activity # 8h
#* Hard reset the repository
# =====================================================================================================
#

function git_hard_reset() {
  git reset --hard 
  git push --force origin 
}


#!
#! ╚═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════-Function of Main Activities-╝
#!



#* main()
#*                                                                                       # Main - Start
#* Main function that runs the script
# =====================================================================================================
#

function run_git_operation(){
    
  showAllFileChangesAsNumberedList

  local main_choice=-1

  while [[ "$main_choice" != "0" ]]; do
    
    show_options

    read -p "$(echo -e "\n${BOLD}${GREEN}🖌   Enter your choice (1-11)${RESET} || ${BOLD}${RED}0 to Exit: ${RESET}")" main_choice
    echo ""

    exetcute_choosen_git_operation $main_choice

  done

  exit 0

}


#* exit_script()
#*                                                                                       # Main - Exit
#* Exits the script
# =====================================================================================================
#
function exit_script() {
  echo -e "\n${RED}============================================${RESET}"
  echo -e "${RED}        -                                     ${RESET}"
  echo -e "${RED}       / \\                                   ${RESET}"
  echo -e "${RED}      /   \\                                  ${RESET}"
  echo -e "${RED}     /     \\        Exiting now...           ${RESET}"
  echo -e "${RED}    /_______\\                                ${RESET}"
  echo -e "${RED}    |       |                                 ${RESET}"
  echo -e "${RED}    |       |            o                    ${RESET}"
  echo -e "${RED}    |  Git  |          /|\\  -- -- -- -- - -  ${RESET}"
  echo -e "${RED}    |       |          / \\  -- -- -- - - -   ${RESET}"
  echo -e "${RED}    |_______|  -- -- -- -- -- -- -- - - -     ${RESET}"
  echo -e "${RED}==============================================${RESET}"
  echo ""
  exit 0
}

#* show_options()
#*                                                                                       # Main - View
#* Shows all available options to the user
# =====================================================================================================
#

function show_options() {
  echo -e "${BOLD}${BG_BLUE}                                                                                                           ${RESET}"
  echo -e "${BOLD}${BG_BLUE}                                     ╔══════════════════════════════╗                                      ${RESET}"
  echo -e "${BOLD}${BG_BLUE}                                     ║                              ║                                      ${RESET}"
  echo -e "${BOLD}${BG_BLUE}                                     ║   Select An Operation 👨‍💻   ║                                      ${RESET}"
  echo -e "${BOLD}${BG_BLUE}                                     ║                              ║                                      ${RESET}"
  echo -e "${BOLD}${BG_BLUE}                                     ╚══════════════════════════════╝                                      ${RESET}"
  echo -e "${BOLD}${BG_BLUE}                                                                                                           ${RESET}"
  echo ""
  echo ""
  echo ""
  echo "1 → Stage (1a → All)                        2 → UnStage (2a → All)"
  echo ""
  echo "3 → Commit (3p → & Push)                    4 → Pull & Push (4m → Merge)"
  echo ""
  echo "5 → Show difference                         6 → Commit History "
  echo ""
  echo "7 → Show Commit Changes                     8 → Reset((soft-s)/(hard-h))"
  echo ""
  echo -e "9 → Open ${BOLD}${MAGENTA} ➤  Utility Functionalities${RESET}"
  echo ""
  echo ""
}


#* exetcute_choosen_git_operation()
#*                                                                                     # Main Execution
#* Executes the chosen git operation
# =====================================================================================================
#


function exetcute_choosen_git_operation() {
  local choice="$1"

  if [[ "$choice" =~ ^[0-9a-zA-Z]+$ ]]; then

    case $choice in
      0)
         exit_script
        ;;
      1)
        stage_choosen_files
        ;;
      1a)
        stage_all_files
        ;;
      2)
        unstage_choosen_files
        ;;
      2a)
        unstage_All_changed_file
        ;;
      3)
        commit_changes
        ;;
      3p)
        commit_and_push
        ;;
      4)
        pull_and_push
        ;;
      4m)
        merge_branch
        ;;
      5)
        git_diff_branches
        ;;
      6)
        git_log
        ;;
      7)
        show_commit_changes
        ;;
      8s)
        git_soft_reset
        ;;
      8h)
        git_hard_reset
        ;;
      9)
        utilitiesTask
        ;;
      *)
        echo -e "${GOLDEN}Option not recognized${RESET}"
        echo ""
        ;;
    esac
  else
    echo ""
    echo -e "${RED}Invalid option. Please select a valid option.${RESET}"
    echo ""
  exit 0
  fi
}




#→                                                                                                                                                           
#→ ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════-Main Activities Execution End-╝  
#→                                                                                                                                                           