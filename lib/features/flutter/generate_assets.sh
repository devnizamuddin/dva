#!/usr/bin/env bash

# ==============================================================
# Generates asset_path.dart dynamically from /assets directory
# ==============================================================

OUTPUT_FILE="lib/core/asset_path.dart"
ASSETS_DIR="assets"

# Create directory if missing
mkdir -p "$(dirname "$OUTPUT_FILE")"

# Header
echo "class AssetPath {" > $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

# Loop through asset folders
for folder in $(find $ASSETS_DIR -type d | sort); do
    # Skip main assets directory root
    if [[ "$folder" == "$ASSETS_DIR" ]]; then
        continue
    fi

    folder_name=$(basename "$folder")
    title=$(echo "$folder_name" | sed -E 's/_/ /g' | awk '{for(i=1;i<=NF;i++)$i=toupper(substr($i,1,1)) substr($i,2)}1')

    # Print formatted comment block
    cat >> $OUTPUT_FILE <<EOF
  /*
   * ┏==================================================================================================┓
   * ┃                                      $title Resources
   * ┗==================================================================================================┛
   */
EOF

    # Loop through files
    while IFS= read -r file; do
        file_name=$(basename "$file")
        var_name=$(echo "$file_name" \
            | sed -E 's/\.[^.]+$//' \
            | sed -E 's/[^a-zA-Z0-9]+/_/g' \
            | sed -E 's/^[0-9]+/_\0/' )

        echo "  static const String ${var_name} = '$file';" >> $OUTPUT_FILE
    done < <(find "$folder" -maxdepth 1 -type f | sort)

    echo "" >> $OUTPUT_FILE
done

echo "}" >> $OUTPUT_FILE

echo "✅ asset_path.dart generated successfully → $OUTPUT_FILE"
