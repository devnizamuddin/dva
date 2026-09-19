#!/bin/bash


#* ┏==================================================================================================┓
#* ┃                                       ☁️ Icloud: All Features                                    ┃
#* ┗==================================================================================================┛


sync_with_icloud() {
    read -p "Enter the folder path to sync with iCloud: " folder_path
    local folder_path="$folder_path"
    local folder_name
    local icloud_base="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
    local target_path

    # Check if folder exists
    if [[ ! -d "$folder_path" ]]; then
        echo "❌ Folder not found: $folder_path"
        return 1
    fi

    # Extract folder name
    folder_name=$(basename "$folder_path")
    target_path="$icloud_base/$folder_name"

    # Move folder to iCloud if not already there
    if [[ -d "$target_path" ]]; then
        echo "⚠️ Folder already exists in iCloud: $target_path"
    else
        echo "📦 Moving '$folder_name' to iCloud..."
        mv "$folder_path" "$icloud_base/"
    fi

    # Create symlink
    if [[ -L "$folder_path" ]]; then
        echo "🔗 Symlink already exists: $folder_path"
    else
        ln -s "$target_path" "$folder_path"
        echo "✅ Symlink created: $folder_path -> $target_path"
    fi
}
