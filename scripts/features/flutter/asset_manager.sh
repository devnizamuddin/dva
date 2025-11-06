#!/bin/bash

function create_asset_constants() {
    OUTPUT_FILE="lib/core/constants/asset_path.dart"
    ASSETS_DIR="assets"

    # Create directory if missing
    mkdir -p "$(dirname "$OUTPUT_FILE")"

    echo "class AssetPath {" > $OUTPUT_FILE
    echo "" >> $OUTPUT_FILE

    for folder in $(find $ASSETS_DIR -type d | sort); do
        if [[ "$folder" == "$ASSETS_DIR" ]]; then
            continue
        fi

        folder_name=$(basename "$folder")
        title=$(echo "$folder_name" | sed -E 's/_/ /g' | awk '{for(i=1;i<=NF;i++)$i=toupper(substr($i,1,1)) substr($i,2)}1')

        cat >> $OUTPUT_FILE <<EOF
  /*
   * ┏==================================================================================================┓
   * ┃                                      $title Resources                                            ┃
   * ┗==================================================================================================┛
   */
EOF

        while IFS= read -r file; do
            file_name=$(basename "$file")

            # Remove extension → make camelCase
            base_name=$(echo "$file_name" | sed -E 's/\.[^.]+$//')

            # Convert invalid chars to space → camelCase
            camel=$(echo "$base_name" | \
                sed -E 's/[^a-zA-Z0-9]+/ /g' | \
                awk '{ 
                    for(i=1;i<=NF;i++){
                        if(i==1) {
                            $i=tolower($i)
                        } else {
                            $i=toupper(substr($i,1,1)) substr($i,2)
                        }
                    }
                    printf "%s", $1
                    for(i=2;i<=NF;i++) printf "%s", $i
                }')

            echo "  static const String $camel = '$file';" >> $OUTPUT_FILE

        done < <(find "$folder" -maxdepth 1 -type f | sort)

        echo "" >> $OUTPUT_FILE
    done

    echo "}" >> $OUTPUT_FILE

    echo "✅ asset_path.dart generated → $OUTPUT_FILE"
}
