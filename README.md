# DVA CLI - Your Personal Developer Helper

DVA CLI (Developer Workflow Automation) is a powerful, premium command-line assistant designed to streamline developer workflows. Whether you're wrangling Git branches, managing Flutter deployments, or organizing your daily sticky notes, DVA provides a fast, aesthetic, and completely arrow-driven interface to accelerate your productivity.

## 🚀 Installation

To install DVA CLI as a global command on your system, run the installation script from the root of this repository:

```bash
./install.sh
```

This will:
1. Copy the CLI into `~/.dva`.
2. Securely create a system-wide symlink (`dva`) in `/usr/local/bin` (may require `sudo` if the directory is restricted).

## 📖 Usage

DVA replaces slow typed menus with an interactive, arrow-navigable interface. Open it from anywhere:

```bash
dva
```
Or, jump straight to a tool category:
```bash
dva <command>
```

---

## ✨ Features Dashboard

### 🐙 Git Operations
Stop typing long git commands and dealing with pull conflict anxiety.

- **Sync**: `dva sync` - Intelligently auto-stashes your dirty state, pulls from your selected branch, and pops your stash safely.
- **Commit**: `dva commit` - View staged files in a beautiful neumorphic card. Quick-select your commit prefixes (`🆕 Feature`, `🧩 Fix`, etc.) via an interactive `fzf` list.
- **Audit**: `dva audit` - Evaluate differences between branches. Includes an interactive **Stale Branch Cleanup Dashboard** to instantly remove branches you've already merged!

### 📱 Flutter Management
Simplify your multi-platform Flutter development matrix.

- **Builds**: Compile Web, APK, and iOS builds effortlessly.
- **Deploy**: Wrapper commands for git-tagging and pushing new releases with smooth loading animations.
- **Assets**: Safely generate asset constants.

### 📝 Sticky Notes
Keep your thoughts directly inside your terminal, formatted as authentic yellow sticky notes.

- Create dynamic notes with helpful syntax suggestions.
- **Search**: `dva note` -> Search Notes. Quickly find any text snippet across all your existing notes.

### 🔠 Text Utilities
Never leave the terminal to format strings.

- **Case Conversion**: Interactively convert any text into `snake_case`, `camelCase`, `PascalCase`, etc., instantly copying the result to your clipboard!
- **Comments Generator**: Instantly generate block comments with author and date signatures tailored to your git config.

---

## 📂 Architecture

```text
dva/
├── bin/            # Executable entry point
├── scripts/        # Core logic
│   ├── components/ # Reusable Interactive UI (Cards, Spinners)
│   ├── features/   # Command Implementations (Git, Flutter, Notes)
│   └── utils/      # Printing and Styling Primitives
└── install.sh      # Setup automation
```

## 📄 License

This project is licensed under the MIT License.
