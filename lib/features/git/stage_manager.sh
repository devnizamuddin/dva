#!/bin/bash



#* ┏==================================================================================================┓
#* ┃                                   📖 Stage Choosen Files                                         ┃
#* ┗==================================================================================================┛


function stage_choosen_files () {
  show_all_file_changes_as_numbered_list

  if [ ${#unstaged_list[@]} -eq 0 ]; then
    echo -e "\n${RED}❌  No file to stage...${RESET}\n"
  else
    input_file_numbers_to_stage_and_display
  fi
}

#* ┏==================================================================================================┓
#* ┃                                   📖 Stage All Files.                                            ┃
#* ┗==================================================================================================┛

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
    show_all_staged_file_as_numbered_list
  else
    echo -e "\n❌ No files to stage.\n"
  fi
}

#* ┏==================================================================================================┓
#* ┃                                   📖 UnStage Choosen Files                                       ┃
#* ┗==================================================================================================┛


function unstage_choosen_files(){
  staged_files=$(git diff --name-only --cached)

  echo ""

  if [[ -z "$staged_files" ]]; then
      echo -e "${YELLOW}  No staged files to unstage.${RESET}"
      return
      fi

  show_all_staged_file_as_numbered_list
  input_file_numbers_to_unstage_and_display
}


#* ┏==================================================================================================┓
#* ┃                                   📖 UnStage All File                                            ┃
#* ┗==================================================================================================┛


function unstage_all_files(){

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


#* ╔═══════════════════════════════════════════════════════════════╗
#* ║ 🧾 Show All File Changes As Numbered List                     ║
#* ╚═══════════════════════════════════════════════════════════════╝

function show_all_file_changes_as_numbered_list() {
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

#* ╔═══════════════════════════════════════════════════════════════╗
#* ║ 🧾 Show All Staged File As Numbered List                      ║
#* ╚═══════════════════════════════════════════════════════════════╝

function show_all_staged_file_as_numbered_list(){

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

#* ╔═══════════════════════════════════════════════════════════════╗
#* ║ 🧾 User input to Stage and display                            ║
#* ╚═══════════════════════════════════════════════════════════════╝

function input_file_numbers_to_stage_and_display(){
  
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
        show_all_staged_file_as_numbered_list
      fi

}

#* ╔═══════════════════════════════════════════════════════════════╗
#* ║ 🧾 User Input to Unstage and display                          ║
#* ╚═══════════════════════════════════════════════════════════════╝

function input_file_numbers_to_unstage_and_display(){
  
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

