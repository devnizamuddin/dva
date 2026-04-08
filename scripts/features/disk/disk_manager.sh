#!/bin/bash

#* ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
#* ║                                   💰 Imported Files                                              ║
#* ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝

source "$DVA_HOME/scripts/utils/printer.sh"
source "$DVA_HOME/scripts/components/menu_ui.sh"

#* ┏==================================================================================================┓
#* ┃                                  🔧 Disk Menu: Options & Actions                                 ┃
#* ┗==================================================================================================┛

DISK_TITLE="Disk Usage Dashboard"

DISK_OPTIONS=(
  "📊 Show Current Directory"
  "📂 Choose Specific Directory"
)

#* ┏==================================================================================================┓
#* ┃                              📖 Disk Action Functions                                            ┃
#* ┗==================================================================================================┛

function generate_bar() {
    local size=$1
    local max_size=$2
    local MAX_BAR_LENGTH=45
    if (( max_size == 0 )); then
        max_size=1
    fi
    local length=$(( size * MAX_BAR_LENGTH / max_size ))
    local bar=""
    for ((i=0; i<length; i++)); do
        bar+="█"
    done
    echo "$bar"
}

function display_disk_usage() {
    local DIR="${1:-.}"     
    local DEPTH="${2:-1}"   

    clear
    print_title "📊 Memory used by each folder in: $DIR"
    echo ""

    if [ ! -d "$DIR" ]; then
        print_status_error "Directory '$DIR' does not exist."
        return 1
    fi

    echo -e "${CYAN}Analyzing disk usage... Please wait.${NC}\n"

    # Get folder sizes sorted
    local entries=()
    while IFS=$'\t' read -r size folder; do
        entries+=("$size|$folder")
    done < <(du -h -d "$DEPTH" "$DIR" 2>/dev/null | sort -hr)

    if [ ${#entries[@]} -eq 0 ]; then
        print_status_warning "No folders found or permission denied."
        return 1
    fi

    # First pass to find MAX_SIZE
    local sizes_kb=()
    local MAX_SIZE=0
    for entry in "${entries[@]}"; do
        local folder="${entry#*|}"
        # Convert to KB for scaling
        local size_kb=$(du -k -d 0 "$folder" 2>/dev/null | cut -f1)
        sizes_kb+=("$size_kb")
        if (( size_kb > MAX_SIZE )); then
            MAX_SIZE=$size_kb
        fi
    done

    # Print dashboard
    clear
    print_title "📊 Memory used by each folder in: $DIR"
    echo ""
    
    echo -e "${BOLD}${BLUE}SIZE       | USAGE BAR${NC}"
    echo -e "${BLUE}------------------------------------------------------------${NC}"

    local i=0
    for entry in "${entries[@]}"; do
        local size_human="${entry%%|*}"
        local folder="${entry#*|}"
        local size_kb="${sizes_kb[$i]}"
        
        # Determine bar color based on size percentage
        local BAR=$(generate_bar "$size_kb" "$MAX_SIZE")
        local COLOR=$GREEN
        if (( size_kb > MAX_SIZE / 2 )); then 
            COLOR=$RED
        elif (( size_kb > MAX_SIZE / 5 )); then 
            COLOR=$YELLOW
        fi
        
        printf "${BOLD}%-10s${NC} | %b%s%b  (%s)\n" "$size_human" "$COLOR" "$BAR" "$NC" "$folder"
        ((i++))
    done
    echo ""
}

function disk_action_1() {
  display_disk_usage "."
}

function disk_action_2() {
  clear
  print_title "📊 Disk Usage Dashboard"
  echo ""
  read -p "$(echo -e "  ${GOLDEN}📁 Enter directory path (e.g., ~/Projects): ${RESET}")" target_dir
  echo ""
  
  if [[ -z "$target_dir" ]]; then
    print_status_error "No directory provided."
    return 1
  fi

  # Expand tilde if present
  target_dir="${target_dir/#\~/$HOME}"

  display_disk_usage "$target_dir"
}

#* ┏==================================================================================================┓
#* ┃                               📖 Disk Menu Loop                                                  ┃
#* ┗==================================================================================================┛

function run_disk_manager() {
  local ACTION_PREFIX="disk"
  menu_loop "$ACTION_PREFIX" "$DISK_TITLE" "${DISK_OPTIONS[@]}"
}
