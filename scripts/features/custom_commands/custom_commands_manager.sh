#!/bin/bash

# * ┏==================================================================================================┓
# * ┃                           ✨ Custom Commands Manager: Options & Actions                         ┃
# * ┗==================================================================================================┛

# Commands storage file
CUSTOM_COMMANDS_FILE="$DVA_HOME/.custom_commands.json"

# Initialize commands file if it doesn't exist
function init_custom_commands_file() {
  if [[ ! -f "$CUSTOM_COMMANDS_FILE" ]]; then
    echo '{"commands":[]}' > "$CUSTOM_COMMANDS_FILE"
  fi
}

# Menu Title
CUSTOM_COMMANDS_TITLE="Custom Commands Manager"

# Menu Options
CUSTOM_COMMANDS_OPTIONS=(
  "➕ Add New Command"
  "📋 List All Commands"
  "▶️  Execute Command"
  "✏️  Edit Command"
  "🗑️  Delete Command"
)


# * ┏==================================================================================================┓
# * ┃                              📖 Custom Commands Action Functions                                ┃
# * ┗==================================================================================================┛

# Action 1: Add New Command
function custom_commands_action_1() {
  clear
  printf "\n${BOLD}✨ Add New Custom Command${NC}\n"
  printf "═══════════════════════════════════════════════════════════\n\n"
  
  read -p "📝 Enter command name: " cmd_name
  
  if [[ -z "$cmd_name" ]]; then
    printf "\n❌ Command name cannot be empty!\n"
    return 1
  fi
  
  # Check if command already exists
  if command_exists "$cmd_name"; then
    printf "\n⚠️  Command '%s' already exists!\n" "$cmd_name"
    return 1
  fi
  
  read -p "📄 Enter command description: " cmd_desc
  
  printf "\n💡 Enter the command to execute (use Ctrl+D when done):\n"
  printf "   You can enter multiple lines for complex commands.\n\n"
  
  # Read multiline command
  cmd_content=""
  while IFS= read -r line; do
    cmd_content+="$line"$'\n'
  done
  
  if [[ -z "$cmd_content" ]]; then
    printf "\n❌ Command content cannot be empty!\n"
    return 1
  fi
  
  # Add command to file
  add_command "$cmd_name" "$cmd_desc" "$cmd_content"
  
  printf "\n✅ Command '%s' added successfully!\n" "$cmd_name"
}

# Action 2: List All Commands
function custom_commands_action_2() {
  clear
  printf "\n${BOLD}📋 All Custom Commands${NC}\n"
  printf "═══════════════════════════════════════════════════════════\n\n"
  
  local count=$(get_command_count)
  
  if [[ $count -eq 0 ]]; then
    printf "📭 No custom commands found.\n"
    printf "   Add your first command using 'Add New Command' option.\n"
    return 0
  fi
  
  local commands=$(get_all_commands)
  local index=1
  
  while IFS='|' read -r name desc content; do
    printf "${BOLD}%d. %s${NC}\n" "$index" "$name"
    printf "   📝 Description: %s\n" "$desc"
    printf "   💻 Command:\n"
    printf "   %s\n\n" "$(echo "$content" | head -n 3 | sed 's/^/      /')"
    ((index++))
  done <<< "$commands"
  
  printf "═══════════════════════════════════════════════════════════\n"
  printf "Total: %d command(s)\n" "$count"
}

# Action 3: Execute Command
function custom_commands_action_3() {
  clear
  printf "\n${BOLD}▶️  Execute Custom Command${NC}\n"
  printf "═══════════════════════════════════════════════════════════\n\n"
  
  local count=$(get_command_count)
  
  if [[ $count -eq 0 ]]; then
    printf "📭 No custom commands available to execute.\n"
    return 0
  fi
  
  # List available commands
  local commands=$(get_all_commands)
  local index=1
  local cmd_names=()
  
  while IFS='|' read -r name desc content; do
    printf "%d. %s - %s\n" "$index" "$name" "$desc"
    cmd_names+=("$name")
    ((index++))
  done <<< "$commands"
  
  printf "\n"
  read -p "Enter command number to execute (or 0 to cancel): " choice
  
  if [[ "$choice" == "0" ]]; then
    return 0
  fi
  
  if [[ ! "$choice" =~ ^[0-9]+$ ]] || [[ $choice -lt 1 ]] || [[ $choice -gt $count ]]; then
    printf "\n❌ Invalid selection!\n"
    return 1
  fi
  
  local cmd_name="${cmd_names[$((choice-1))]}"
  local cmd_content=$(get_command_content "$cmd_name")
  
  printf "\n🚀 Executing: %s\n" "$cmd_name"
  printf "═══════════════════════════════════════════════════════════\n\n"
  
  # Execute the command
  eval "$cmd_content"
  
  printf "\n═══════════════════════════════════════════════════════════\n"
  printf "✅ Command executed.\n"
}

# Action 4: Edit Command
function custom_commands_action_4() {
  clear
  printf "\n${BOLD}✏️  Edit Custom Command${NC}\n"
  printf "═══════════════════════════════════════════════════════════\n\n"
  
  local count=$(get_command_count)
  
  if [[ $count -eq 0 ]]; then
    printf "📭 No custom commands available to edit.\n"
    return 0
  fi
  
  # List available commands
  local commands=$(get_all_commands)
  local index=1
  local cmd_names=()
  
  while IFS='|' read -r name desc content; do
    printf "%d. %s - %s\n" "$index" "$name" "$desc"
    cmd_names+=("$name")
    ((index++))
  done <<< "$commands"
  
  printf "\n"
  read -p "Enter command number to edit (or 0 to cancel): " choice
  
  if [[ "$choice" == "0" ]]; then
    return 0
  fi
  
  if [[ ! "$choice" =~ ^[0-9]+$ ]] || [[ $choice -lt 1 ]] || [[ $choice -gt $count ]]; then
    printf "\n❌ Invalid selection!\n"
    return 1
  fi
  
  local old_name="${cmd_names[$((choice-1))]}"
  local old_desc=$(get_command_description "$old_name")
  local old_content=$(get_command_content "$old_name")
  
  printf "\n📝 Current name: %s\n" "$old_name"
  read -p "Enter new name (press Enter to keep current): " new_name
  [[ -z "$new_name" ]] && new_name="$old_name"
  
  printf "\n📄 Current description: %s\n" "$old_desc"
  read -p "Enter new description (press Enter to keep current): " new_desc
  [[ -z "$new_desc" ]] && new_desc="$old_desc"
  
  printf "\n💡 Current command:\n%s\n\n" "$old_content"
  printf "Enter new command (use Ctrl+D when done, or Ctrl+C to keep current):\n"
  
  # Read new command content
  new_content=""
  while IFS= read -r line; do
    new_content+="$line"$'\n'
  done
  
  [[ -z "$new_content" ]] && new_content="$old_content"
  
  # Delete old command and add updated one
  delete_command "$old_name"
  add_command "$new_name" "$new_desc" "$new_content"
  
  printf "\n✅ Command updated successfully!\n"
}

# Action 5: Delete Command
function custom_commands_action_5() {
  clear
  printf "\n${BOLD}🗑️  Delete Custom Command${NC}\n"
  printf "═══════════════════════════════════════════════════════════\n\n"
  
  local count=$(get_command_count)
  
  if [[ $count -eq 0 ]]; then
    printf "📭 No custom commands available to delete.\n"
    return 0
  fi
  
  # List available commands
  local commands=$(get_all_commands)
  local index=1
  local cmd_names=()
  
  while IFS='|' read -r name desc content; do
    printf "%d. %s - %s\n" "$index" "$name" "$desc"
    cmd_names+=("$name")
    ((index++))
  done <<< "$commands"
  
  printf "\n"
  read -p "Enter command number to delete (or 0 to cancel): " choice
  
  if [[ "$choice" == "0" ]]; then
    return 0
  fi
  
  if [[ ! "$choice" =~ ^[0-9]+$ ]] || [[ $choice -lt 1 ]] || [[ $choice -gt $count ]]; then
    printf "\n❌ Invalid selection!\n"
    return 1
  fi
  
  local cmd_name="${cmd_names[$((choice-1))]}"
  
  read -p "⚠️  Are you sure you want to delete '$cmd_name'? (y/N): " confirm
  
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    delete_command "$cmd_name"
    printf "\n✅ Command '%s' deleted successfully!\n" "$cmd_name"
  else
    printf "\n❌ Deletion cancelled.\n"
  fi
}


# * ┏==================================================================================================┓
# * ┃                              🔧 Helper Functions for JSON Management                            ┃
# * ┗==================================================================================================┛

function command_exists() {
  local name="$1"
  local exists=$(jq -r ".commands[] | select(.name==\"$name\") | .name" "$CUSTOM_COMMANDS_FILE" 2>/dev/null)
  [[ -n "$exists" ]]
}

function add_command() {
  local name="$1"
  local desc="$2"
  local content="$3"
  
  # Escape special characters for JSON
  content=$(echo "$content" | jq -Rs .)
  desc=$(echo "$desc" | jq -Rs .)
  name=$(echo "$name" | jq -Rs .)
  
  jq ".commands += [{\"name\": $name, \"description\": $desc, \"content\": $content}]" \
    "$CUSTOM_COMMANDS_FILE" > "${CUSTOM_COMMANDS_FILE}.tmp" && \
    mv "${CUSTOM_COMMANDS_FILE}.tmp" "$CUSTOM_COMMANDS_FILE"
}

function delete_command() {
  local name="$1"
  
  jq ".commands = [.commands[] | select(.name != \"$name\")]" \
    "$CUSTOM_COMMANDS_FILE" > "${CUSTOM_COMMANDS_FILE}.tmp" && \
    mv "${CUSTOM_COMMANDS_FILE}.tmp" "$CUSTOM_COMMANDS_FILE"
}

function get_command_count() {
  jq -r '.commands | length' "$CUSTOM_COMMANDS_FILE" 2>/dev/null || echo "0"
}

function get_all_commands() {
  jq -r '.commands[] | "\(.name)|\(.description)|\(.content)"' "$CUSTOM_COMMANDS_FILE" 2>/dev/null
}

function get_command_content() {
  local name="$1"
  jq -r ".commands[] | select(.name==\"$name\") | .content" "$CUSTOM_COMMANDS_FILE" 2>/dev/null
}

function get_command_description() {
  local name="$1"
  jq -r ".commands[] | select(.name==\"$name\") | .description" "$CUSTOM_COMMANDS_FILE" 2>/dev/null
}


# * ┏==================================================================================================┓
# * ┃                               📖 Custom Commands Menu Loop                                      ┃
# * ┗==================================================================================================┛

function run_custom_commands() {
  # Check for jq dependency
  if ! command -v jq &> /dev/null; then
    printf "\n❌ Error: 'jq' is not installed but is required for Custom Commands.\n"
    printf "   Please install it using: brew install jq (on macOS) or sudo apt install jq (on Linux)\n"
    read -p "Press Enter to return..."
    return 1
  fi

  init_custom_commands_file
  
  local ACTION_PREFIX="custom_commands"
  
  menu_loop "$ACTION_PREFIX" "$CUSTOM_COMMANDS_TITLE" "${CUSTOM_COMMANDS_OPTIONS[@]}"
}
