#!/bin/bash
# Installer for DVA CLI
# MIT License (c) 2025 Nizam Uddin Shamrat

echo "Installing DVA CLI..."
chmod +x bin/dva.sh
sudo cp bin/dva.sh /usr/local/bin/dva
echo "✅ DVA installed! Run 'dva' anywhere."
