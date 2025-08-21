#!/bin/bash
# Installer for DVA CLI
# MIT License (c) 2025 Nizam Uddin Shamrat

# Set installation folder
DVA_HOME="$HOME/.dva"

echo "Installing DVA CLI in $DVA_HOME..."

# Create necessary directories
mkdir -p "$DVA_HOME/bin"
mkdir -p "$DVA_HOME/scripts"
mkdir -p "$DVA_HOME/logs"

# Copy scripts
cp bin/dva.sh "$DVA_HOME/bin/"
cp scripts/*.sh "$DVA_HOME/scripts/"

# Make main CLI executable
chmod +x "$DVA_HOME/bin/dva.sh"

# Create symlink for global access
sudo ln -sf "$DVA_HOME/bin/dva.sh" /usr/local/bin/dva

echo "✅ DVA CLI installed successfully!"
echo "Run 'dva' from anywhere."
