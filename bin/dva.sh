#!/bin/bash
# DVA CLI - Developer Workflow Automation
# MIT License (c) 2025 Nizam Uddin Shamrat


#*
#* ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
#* ║                                   💰 Imported Files                                              ║
#* ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝
#*


DVA_HOME="$HOME/.dva"

# Import helpers
source "$DVA_HOME/scripts/utils.sh"
source "$DVA_HOME/scripts/ui.sh"
source "$DVA_HOME/scripts/main_menu_ui.sh"
source "$DVA_HOME/scripts/tasks.sh"
source "$DVA_HOME/scripts/tasks/note_task.sh"
source "$DVA_HOME/scripts/presentation/screens/main_screen.sh"


clear


#*
#* ┏==================================================================================================┓
#* ┃                                   📖 Printing Comments                                           ┃
#* ┗==================================================================================================┛
#*

load_main_screen

# printWellcomeMessage


#*
#* ┏==================================================================================================┓
#* ┃                                   📖 Showing Menus                                               ┃
#* ┗==================================================================================================┛
#*


# print_card "1" "Start Dev Environment" "🚀" "$GREEN"
# print_card "2" "Clean Project" "🧹" "$YELLOW"
# print_flutter_card
# print_card "4" "GIT" "🔄" "$CYAN"
# print_card "0" "Quit" "❌" "$RED"

# printMenuUi



#*
#* ┏==================================================================================================┓
#* ┃                                 📖 Taking input to execute                                       ┃
#* ┗==================================================================================================┛
#*


# print_divider
# echo -e ""
# read -p "$(echo -e "${BOLD}👉 Select an option [0-3]: ${NC}") " choice


#*
#* ┏==================================================================================================┓
#* ┃                                   📖 Execute As choice                                           ┃
#* ┗==================================================================================================┛
#*

# case "$choice" in
#   1) print_flutter_task_list ;;
#   2) print_git_task_list ;;
#   3) flutter_menu ;;
#   0) print_info "Goodbye!"; log_task "CLI exited"; exit 0 ;;
#   *) print_error "Invalid option. Enter 0–4." ;;
# esac
