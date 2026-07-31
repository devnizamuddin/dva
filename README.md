# DVA CLI

> Your Personal Developer Helper

DVA CLI (Developer Workflow Automation) is a powerful, premium command-line assistant designed to streamline developer workflows. Whether you're wrangling Git branches, managing Flutter deployments, or organizing your daily sticky notes, DVA provides a fast, aesthetic, and completely arrow-driven interface to accelerate your productivity.

___

## 🚀 Installation

To install DVA CLI as a global command on your system, run the installation script from the root of this repository:

```bash
git clone https://github.com/nizamuddinshamrat/dva.git
cd dva
./install.sh
```

___

## 📖 Usages

DVA CLI is packed with features accessible via the interactive main menu (`dva`) or through direct commands:

| Command / Access.     | Category       | Description                                                             |
|-----------------------|----------------|-------------------------------------------------------------------------|
| `dva`                 | ✨ Main Menu   | Open the interactive parent menu for all features.                      |
| `dva git`             | 🐙 Git         | Interactive Git flow and tools menu.                                    |
| `dva commit`          | 🐙 Git         | Stage files, pick commit prefix, commit, and push.                      |
| `dva sync`            | 🐙 Git         | Auto-stash, pull, and push current branch.                              |
| `dva merge`           | 🐙 Git         | Interactive branch merging.                                             |
| `dva audit`           | 🐙 Git         | Compare and clean stale local branches.                                 |
| `dva log`             | 🐙 Git         | Visual commit history.                                                  |
| `dva flutter`         | 📱 Flutter     | Manage Flutter tasks and configurations.                                |
| `dva release <target>`| 📱 Flutter     | Build release applications (`apk`, `ios`, `web`, `macos`).              |
| `dva cleanup <target>`| 📱 Flutter     | Clean project builds (`macos`, `android`, `ios`, `web`).                |
| `GENERATE CODE`       | 🗂️ Generation  | *Main Menu* ➔ Generate Clean Architecture boilerplate, BLoCs, Entities. |
| `dva note`            | 📝 Notes       | Manage quick developer notes and to-dos directly from the terminal.     |
| `dva text`            | 🔠 Utilities   | Convert text case (camelCase, snake_case, etc.) and generate comments.  |
| `DISK DASHBOARD`      | 💻 System      | *Main Menu* ➔ Analyze and visualize disk space.                         |
| `CUSTOM COMMANDS`     | 💻 System      | *Main Menu* ➔ Manage and execute custom saved commands.                 |
| `MacOS`               | 💻 System      | *Main Menu* ➔ MacOS-specific tools and utilities.                       |

## 📄 License

This project is licensed under the MIT License.
