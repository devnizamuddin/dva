#!/bin/bash
#/*
# ===========================================================
# * DVA CLI Installer
# * MIT License (c) 2025 Nizam Uddin Shamrat
# ===========================================================
# * Comment 
# */

# ===========================================================
# * set -e ensures:
# ===========================================================
# - If any command fails (non-zero exit code), the script stops immediately.
# - Prevents running dependent commands after a failure.
# ===========================================================

set -e

#*
#* ┏==================================================================================================┓
#* ┃                                   📖 Target installation folder                                  ┃
#* ┗==================================================================================================┛
#*

DVA_HOME="$HOME/.dva"
DVA_LIB="$DVA_HOME/lib"
DVA_FEATURES="$DVA_LIB/features"
echo "🚀 Installing DVA CLI into $DVA_HOME..."

# Remove old scripts directory if present
if [ -d "$DVA_HOME/scripts" ]; then
    echo "🧹 Cleaning up old scripts directory..."
    rm -rf "$DVA_HOME/scripts"
fi

#*
#* ┏==================================================================================================┓
#* ┃                                   📖 Create required directories                                 ┃
#* ┗==================================================================================================┛
#*

# =======================================
# * Bin, Lib, UI, Features, Core
# =======================================
mkdir -p "$DVA_HOME/bin"
mkdir -p "$DVA_HOME/lib"
mkdir -p "$DVA_HOME/lib/ui"
mkdir -p "$DVA_HOME/lib/features"
mkdir -p "$DVA_HOME/lib/core"

# =======================================
# * Feature Folders
# =======================================
mkdir -p "$DVA_FEATURES/clean"
mkdir -p "$DVA_FEATURES/git"
mkdir -p "$DVA_FEATURES/flutter"
mkdir -p "$DVA_FEATURES/note"
mkdir -p "$DVA_FEATURES/text"
mkdir -p "$DVA_FEATURES/mac_os"
mkdir -p "$DVA_FEATURES/disk"
mkdir -p "$DVA_FEATURES/custom_commands"

# =======================================
# * Tasks, Utils, Logs
# =======================================
mkdir -p "$DVA_HOME/lib/tasks"
mkdir -p "$DVA_HOME/lib/utils"
mkdir -p "$DVA_HOME/data/logs"
mkdir -p "$DVA_HOME/data/notes"
mkdir -p "$DVA_HOME/tests"

#*
#* ┏==================================================================================================┓
#* ┃                                 📖 Copy scripts (if available)                                   ┃
#* ┗==================================================================================================┛
#*

# =======================================
# * ✌️ Main CLI entrypoint
# =======================================
cp bin/dva.sh "$DVA_HOME/bin/"

# =======================================
# * ✌️ General helper scripts
# =======================================
cp lib/*.sh "$DVA_HOME/lib/" 2>/dev/null || true

# =======================================
# * ✌️ UI scripts
# =======================================
cp lib/ui/*.sh "$DVA_HOME/lib/ui/" 2>/dev/null || true

# =======================================
# * ✌️ Core scripts
# =======================================
cp lib/core/*.sh "$DVA_HOME/lib/core/" 2>/dev/null || true

# =======================================
# * ✌️ Feature scripts
# =======================================
cp lib/features/*.sh "$DVA_HOME/lib/features/" 2>/dev/null || true

# =======================================
# * 💬 Generate Code scripts
# =======================================
cp lib/features/clean/*.sh "$DVA_HOME/lib/features/clean/" 2>/dev/null || true

# =======================================
# * 💙 Flutter scripts
# =======================================
cp lib/features/flutter/*.sh "$DVA_HOME/lib/features/flutter/" 2>/dev/null || true

# =======================================
# * 🗂️ GIT scripts
# =======================================
cp lib/features/git/*.sh "$DVA_HOME/lib/features/git/" 2>/dev/null || true

# ==============================================================================
# *                          📝 Note Feature scripts
# ==============================================================================
cp lib/features/note/*.sh "$DVA_HOME/lib/features/note/" 2>/dev/null || true

# ==============================================================================
# *                          🔠 Text Feature scripts
# ==============================================================================
cp lib/features/text/*.sh "$DVA_HOME/lib/features/text/" 2>/dev/null || true

# ==============================================================================
# *                          🍎 MacOS Feature scripts
# ==============================================================================
cp lib/features/mac_os/*.sh "$DVA_HOME/lib/features/mac_os/" 2>/dev/null || true

# ==============================================================================
# *                          💾 Disk Feature scripts
# ==============================================================================
cp lib/features/disk/*.sh "$DVA_HOME/lib/features/disk/" 2>/dev/null || true

# ==============================================================================
# *                          ✨ Custom Commands Feature scripts
# ==============================================================================

cp lib/features/custom_commands/*.sh "$DVA_HOME/lib/features/custom_commands/" 2>/dev/null || true

# ==============================================================================
# *                               ✌️ Task scripts
# ==============================================================================
cp lib/tasks/*.sh "$DVA_HOME/lib/tasks/" 2>/dev/null || true


# ==============================================================================
# *                              ✌️ Utility scripts
# ==============================================================================
cp lib/utils/*.sh "$DVA_HOME/lib/utils/" 2>/dev/null || true

# ==============================================================================
# *                              ✌️ Test scripts
# ==============================================================================
cp tests/*.sh "$DVA_HOME/tests/" 2>/dev/null || true


# ==============================================================================
# *                             📖 Make CLI executable
# ==============================================================================

chmod +x "$DVA_HOME/bin/dva.sh"


# ==============================================================================
# *                             Create symlink for global access
# ==============================================================================

if [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$DVA_HOME/bin/dva.sh" "$HOME/.local/bin/dva"
    echo "✅ Linked successfully in $HOME/.local/bin/dva"
elif [ -w /usr/local/bin ]; then
    ln -sf "$DVA_HOME/bin/dva.sh" /usr/local/bin/dva
    echo "✅ Linked successfully in /usr/local/bin/dva"
else
    echo "⚠️  Global installation requires sudo to write to /usr/local/bin..."
    sudo ln -sf "$DVA_HOME/bin/dva.sh" /usr/local/bin/dva
fi

# ===========================================================
# * 💰 Importing Files                                             
# ===========================================================
source "$DVA_HOME/lib/utils/style.sh"
source "$DVA_HOME/lib/utils/printer.sh"
source "$DVA_HOME/lib/ui/welcome_ui.sh"


# ==============================================================================
# *                            📖 Success message
# ==============================================================================

line_gap
multi_line_divider
welcome_user
multi_line_divider
line_gap
echo "👉 Run 'dva' from anywhere."
line_gap
echo "📂 Installed at: $DVA_HOME"
line_gap
multi_line_divider
line_gap