# DVA CLI - Developer Workflow Automation

DVA CLI is a powerful command-line interface designed to streamline developer workflows, specifically tailored for Flutter development, Git management, and daily productivity tasks. Built with shell scripts, it provides a fast and efficient way to handle repetitive operations.

## 🚀 Installation

To install DVA CLI, simply run the installation script from the root of the repository:

```bash
./install.sh
```

This will:

1.  Install DVA CLI into `~/.dva`.
2.  Set up necessary directories and configurations.
3.  Create a system-wide symlink (`dva`) in `/usr/local/bin` (requires `sudo` access if not writable).

## 📖 Usage

Run the CLI using the `dva` command:

```bash
dva <command> [options]
```

If you run `dva` without arguments, it will open the interactive main menu.

## ✨ Features

### 💙 Flutter Management

Simplify your Flutter development process with dedicated commands for building, deploying, and asset management.

```bash
dva flutter [subcommand]
```

- **Builds**: Easily build for Web, APK, and iOS.
- **Assets**: Generate asset references automatically.
- **Deploy**: streamline deployment processes.

### 🗂️ Git Operation

Automate your Git workflow with simplified commands.

```bash
dva git [subcommand]
```

- **Commit**: `dva commit` - Stages all files, commits, and pushes in one go.
- **Merge**: `dva merge <branch>` - Helper for merging branches.
- **Branching & History**: Manage branches and view history easily.

### 📝 Notes

Keep track of your thoughts and tasks directly from the terminal.

```bash
dva note
```

- Create, search, and manage notes efficiently.

### 🔠 Text Utilities

Quickly manipulate text directly from the command line.

```bash
dva text
```

- **Case Conversion**: Convert text between snake_case, camelCase, PascalCase, etc.
- **Comments**: Generate formatted comments.

### 🍎 MacOS Utilities

Productivity scripts tailored for MacOS users.

```bash
dva mac_os
```

## 📂 Project Structure

```
dva/
├── bin/            # Executable entry points
├── scripts/        # Core logic and feature implementation
│   ├── components/ # UI components (menus, prompts)
│   ├── features/   # Feature-specific scripts (flutter, git, etc.)
│   ├── sources/    # Shared sources and configurations
│   ├── tasks/      # Task runners
│   └── utils/      # Helper utilities
└── install.sh      # Installation script
```

## 📄 License

This project is licensed under the MIT License.
