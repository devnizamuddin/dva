#!/bin/bash
# ==============================================
# DVA CLI Installer
# MIT License (c) 2025 Nizam Uddin Shamrat
# ==============================================

# set -e ensures:
# - If any command fails (non-zero exit code), the script stops immediately.
# - Prevents running dependent commands after a failure.
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

#*================================┃ Bin, Scripts, Components, Features ┃=======================================
mkdir -p "$DVA_HOME/bin"
mkdir -p "$DVA_HOME/scripts"
mkdir -p "$DVA_HOME/scripts/components"
mkdir -p "$DVA_HOME/scripts/features"
#===================================================┃==========================================================

#*==========================================┃ Feature Folders ┃================================================
mkdir -p "$DVA_FEATURES/git"
mkdir -p "$DVA_FEATURES/flutter"
mkdir -p "$DVA_FEATURES/note"
mkdir -p "$DVA_FEATURES/text"
mkdir -p "$DVA_FEATURES/mac_os"
#==================================================┃============================================================

#*=======================================┃Source, Tasks, Utils, Logs┃============================================
mkdir -p "$DVA_HOME/scripts/sources"
mkdir -p "$DVA_HOME/scripts/tasks"
mkdir -p "$DVA_HOME/scripts/utils"
mkdir -p "$DVA_HOME/logs"
#==================================================┃============================================================


#*
#* ┏==================================================================================================┓
#* ┃                                 📖 Copy scripts (if available)                                   ┃
#* ┗==================================================================================================┛
#*


#* ✌️ Main CLI entrypoint
#*
cp bin/dva.sh "$DVA_HOME/bin/"


#* ✌️ General helper scripts
#*    - These are common utility functions
#*
cp scripts/*.sh "$DVA_HOME/scripts/" 2>/dev/null || true


#* ✌️ Component scripts
#*    - Reusable UI parts for menus or common views
#*
cp scripts/components/*.sh "$DVA_HOME/scripts/components/" 2>/dev/null || true


#* ============================================== ✌️ Feature scripts ===============================================
#*
#* - Full-page CLI screens for structured navigation
# ==================================================================================================================

cp scripts/features/*.sh "$DVA_HOME/scripts/features/" 2>/dev/null || true

#* ============================================== 💙 Flutter scripts ===============================================
#*
#* - Full-page CLI screens for flutter functions
# ==================================================================================================================

cp scripts/features/flutter/*.sh "$DVA_HOME/scripts/features/flutter/" 2>/dev/null || true

#* ============================================== 🗂️ GIT scripts ===================================================
#*
#* - Full-page CLI screens for git functions
# ==================================================================================================================

cp scripts/features/git/*.sh "$DVA_HOME/scripts/features/git/" 2>/dev/null || true

#* ============================================= 📝 Note Feature scripts ==========================================
#*
#* - Full-page CLI screens for note functions
# ==================================================================================================================

cp scripts/features/note/*.sh "$DVA_HOME/scripts/features/note/" 2>/dev/null || true

#* ============================================== 🔠 Text Feature scripts ===============================================
#*
#* - Full-page CLI screens for text functions
# ==================================================================================================================

cp scripts/features/text/*.sh "$DVA_HOME/scripts/features/text/" 2>/dev/null || true

#* ============================================= 🍎 MacOS Feature scripts ==========================================
#*
#* - Full-page CLI screens for macOS functions
# ==================================================================================================================

cp scripts/features/mac_os/*.sh "$DVA_HOME/scripts/features/mac_os/" 2>/dev/null || true


#*
#* ✌️ Sources scripts
#*    - Full-page CLI screens for structured navigation
#*
cp scripts/sources/*.sh "$DVA_HOME/scripts/sources/" 2>/dev/null || true


#*
#* ✌️ Task scripts
#*    - Handles project-level tasks (build, clean, release, etc.)
#*
cp scripts/tasks/*.sh "$DVA_HOME/scripts/tasks/" 2>/dev/null || true


#*
#* ✌️ Utility scripts
#*    - Shared low-level helpers used across modules
#*
cp scripts/utils/*.sh "$DVA_HOME/scripts/utils/" 2>/dev/null || true


#*
#* ┏==================================================================================================┓
#* ┃                                   📖 Make CLI executable                                         ┃
#* ┗==================================================================================================┛
#*

chmod +x "$DVA_HOME/bin/dva.sh"


#*
#* ┏==================================================================================================┓
#* ┃                                 📖 Create symlink for global access                              ┃
#* ┗==================================================================================================┛
#*

if [ -w /usr/local/bin ]; then
    ln -sf "$DVA_HOME/bin/dva.sh" /usr/local/bin/dva
else
    echo "⚠️  /usr/local/bin requires sudo, creating symlink with sudo..."
    sudo ln -sf "$DVA_HOME/bin/dva.sh" /usr/local/bin/dva
fi

#*
#* ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
#* ║                                   💰 Imported Files                                              ║
#* ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝
#*

source "$DVA_HOME/scripts/components/welcome_ui.sh"

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