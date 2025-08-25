#!/bin/bash
# ==============================================
# DVA CLI Installer
# MIT License (c) 2025 Nizam Uddin Shamrat
# ==============================================

set -e

# Target installation folder
DVA_HOME="$HOME/.dva"

echo "🚀 Installing DVA CLI into $DVA_HOME..."

# Create required directories
mkdir -p "$DVA_HOME/bin"
mkdir -p "$DVA_HOME/scripts/tasks"
mkdir -p "$DVA_HOME/scripts/presentation/screens"
mkdir -p "$DVA_HOME/scripts/presentation/components"
mkdir -p "$DVA_HOME/logs"

# Copy main CLI
cp bin/dva.sh "$DVA_HOME/bin/"

# Copy helper scripts
cp scripts/*.sh "$DVA_HOME/scripts/" 2>/dev/null || true

# Copy task scripts if available
cp scripts/tasks/*.sh "$DVA_HOME/scripts/tasks/" 2>/dev/null || true

# Copy task scripts if available
cp scripts/presentation/components/*.sh "$DVA_HOME/scripts/presentation/components/" 2>/dev/null || true

# Copy screens scripts if available
cp scripts/presentation/screens/*.sh "$DVA_HOME/scripts/presentation/screens/" 2>/dev/null || true

# Make CLI executable
chmod +x "$DVA_HOME/bin/dva.sh"

# Create symlink for global access
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
