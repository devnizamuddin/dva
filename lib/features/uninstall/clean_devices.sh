#!/bin/bash
echo "Clearing stuck iOS and Android connections..."

# 1. Terminate Apple/iOS background sync daemons
killall AMPDevicesAgent 2>/dev/null
killall AMPDeviceDiscoveryAgent 2>/dev/null

# 2. Terminate Android/MacDroid background processes
killall MacDroid 2>/dev/null

# 3. Restart Finder to wipe visual duplicates from the sidebar
killall Finder 2>/dev/null

echo "✅ Sidebar refreshed! You can now safely reconnect your devices."