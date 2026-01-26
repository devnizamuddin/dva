# ✨ Custom Commands Manager

## Overview
The Custom Commands Manager allows you to create, manage, and execute your own custom shell commands directly from the DVA CLI.

## Features

- **➕ Add New Command**: Create custom commands with name, description, and shell script content
- **📋 List All Commands**: View all saved custom commands
- **▶️ Execute Command**: Run any saved custom command
- **✏️ Edit Command**: Modify existing commands
- **🗑️ Delete Command**: Remove unwanted commands

## Storage

Custom commands are stored in JSON format at:
```
$DVA_HOME/.custom_commands.json
```

## Requirements

- `jq` - Command-line JSON processor (used for parsing and managing commands)
  - Install on macOS: `brew install jq`

## Usage

1. Navigate to DVA CLI main menu
2. Select "✨ CUSTOM COMMANDS"
3. Choose from available options:
   - Add new commands with multiline support
   - List all commands with descriptions
   - Execute commands by selection
   - Edit existing commands
   - Delete commands with confirmation

## Command Structure

Each command is stored with:
- **Name**: Unique identifier for the command
- **Description**: Brief explanation of what the command does
- **Content**: The actual shell command(s) to execute

## Examples

### Example 1: Simple Git Status
- **Name**: `git-status`
- **Description**: Show git status with branch info
- **Content**:
  ```bash
  git status
  git branch -v
  ```

### Example 2: Project Cleanup
- **Name**: `cleanup`
- **Description**: Clean temporary files from project
- **Content**:
  ```bash
  find . -name "*.tmp" -delete
  find . -name ".DS_Store" -delete
  echo "Cleanup complete!"
  ```

### Example 3: Flutter Build
- **Name**: `flutter-build-web`
- **Description**: Build Flutter web with production settings
- **Content**:
  ```bash
  flutter clean
  flutter pub get
  flutter build web --release
  ```

## Tips

- Use multiline commands for complex workflows
- Press Ctrl+D when finished entering command content
- Commands are executed with `eval`, so use carefully
- Test commands before saving them
- Use descriptive names for easy identification

## Security Note

⚠️ Be cautious when creating custom commands as they will be executed with your user permissions. Always verify command content before execution.
