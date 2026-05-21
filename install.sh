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
DVA_SCRIPTS="$DVA_HOME/scripts"
DVA_FEATURES="$DVA_SCRIPTS/features"
echo "🚀 Installing DVA CLI into $DVA_HOME..."


#*
#* ┏==================================================================================================┓
#* ┃                                   📖 Create required directories                                 ┃
#* ┗==================================================================================================┛
#*

# =======================================
# * Bin, Scripts, Components, Features
# =======================================
mkdir -p "$DVA_HOME/bin"
mkdir -p "$DVA_HOME/scripts"
mkdir -p "$DVA_HOME/scripts/components"
mkdir -p "$DVA_HOME/scripts/features"

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
# * Sources, Tasks, Utils, Logs
# =======================================
mkdir -p "$DVA_HOME/scripts/sources"
mkdir -p "$DVA_HOME/scripts/tasks"
mkdir -p "$DVA_HOME/scripts/utils"
mkdir -p "$DVA_HOME/data/logs"
mkdir -p "$DVA_HOME/data/notes"

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
cp scripts/*.sh "$DVA_HOME/scripts/" 2>/dev/null || true

# =======================================
# * ✌️ Component scripts
# =======================================
cp scripts/components/*.sh "$DVA_HOME/scripts/components/" 2>/dev/null || true


# =======================================
# * ✌️ Feature scripts
# =======================================
cp scripts/features/*.sh "$DVA_HOME/scripts/features/" 2>/dev/null || true

# =======================================
# * 💙 CLEAN scripts
# =======================================
cp scripts/features/clean/*.sh "$DVA_HOME/scripts/features/clean/" 2>/dev/null || true

# =======================================
# * 💙 Flutter scripts
# =======================================
cp scripts/features/flutter/*.sh "$DVA_HOME/scripts/features/flutter/" 2>/dev/null || true

# =======================================
# * 🗂️ GIT scripts
# =======================================
cp scripts/features/git/*.sh "$DVA_HOME/scripts/features/git/" 2>/dev/null || true

# ==============================================================================
# *                          📝 Note Feature scripts
# ==============================================================================
cp scripts/features/note/*.sh "$DVA_HOME/scripts/features/note/" 2>/dev/null || true

# ==============================================================================
# *                          🔠 Text Feature scripts
# ==============================================================================
cp scripts/features/text/*.sh "$DVA_HOME/scripts/features/text/" 2>/dev/null || true

# ==============================================================================
# *                          🍎 MacOS Feature scripts
# ==============================================================================
cp scripts/features/mac_os/*.sh "$DVA_HOME/scripts/features/mac_os/" 2>/dev/null || true

# ==============================================================================
# *                          💾 Disk Feature scripts
# ==============================================================================
cp scripts/features/disk/*.sh "$DVA_HOME/scripts/features/disk/" 2>/dev/null || true

# ==============================================================================
# *                          ✨ Custom Commands Feature scripts
# ==============================================================================

cp scripts/features/custom_commands/*.sh "$DVA_HOME/scripts/features/custom_commands/" 2>/dev/null || true

# ==============================================================================
# *                              ✌️ Sources scripts
# ==============================================================================
cp scripts/sources/*.sh "$DVA_HOME/scripts/sources/" 2>/dev/null || true

# ==============================================================================
# *                               ✌️ Task scripts
# ==============================================================================
cp scripts/tasks/*.sh "$DVA_HOME/scripts/tasks/" 2>/dev/null || true


# ==============================================================================
# *                              ✌️ Utility scripts
# ==============================================================================
cp scripts/utils/*.sh "$DVA_HOME/scripts/utils/" 2>/dev/null || true


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
source "$DVA_HOME/scripts/components/welcome_ui.sh"


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