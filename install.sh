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
echo "🚀 Installing DVA CLI into $DVA_HOME..."


#*
#* ┏==================================================================================================┓
#* ┃                                   📖 Create required directories                                 ┃
#* ┗==================================================================================================┛
#*

mkdir -p "$DVA_HOME/bin"
mkdir -p "$DVA_HOME/scripts"
mkdir -p "$DVA_HOME/scripts/components"
mkdir -p "$DVA_HOME/scripts/features"
mkdir -p "$DVA_HOME/scripts/tasks"
mkdir -p "$DVA_HOME/scripts/utils"
mkdir -p "$DVA_HOME/logs"


#*
#* ┏==================================================================================================┓
#* ┃                                 📖 Copy scripts (if available)                                   ┃
#* ┗==================================================================================================┛
#*


#*
#* ✌️ Main CLI entrypoint
#*
cp bin/dva.sh "$DVA_HOME/bin/"


#*
#* ✌️ General helper scripts
#*    - These are common utility functions
#*
cp scripts/*.sh "$DVA_HOME/scripts/" 2>/dev/null || true


#*
#* ✌️ Component scripts
#*    - Reusable UI parts for menus or common views
#*
cp scripts/components/*.sh "$DVA_HOME/scripts/components/" 2>/dev/null || true


#*
#* ✌️ Feature scripts
#*    - Full-page CLI screens for structured navigation
#*
cp scripts/features/*.sh "$DVA_HOME/scripts/features/" 2>/dev/null || true


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

echo ""
echo "✅ DVA CLI installed successfully!"
echo "👉 Run 'dva' from anywhere."
echo "📂 Installed at: $DVA_HOME"
