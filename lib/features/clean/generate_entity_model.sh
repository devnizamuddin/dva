generate_dart_classes() {

  if ! command -v jq &> /dev/null; then
    echo "❌ jq is required"
    return 1
  fi

  echo "📥 Paste your JSON input (finish with CTRL+D):"
  local json_input
  json_input=$(cat)

  # Validate JSON upfront
  if ! echo "$json_input" | jq empty 2>/dev/null; then
    echo "❌ Invalid JSON input."
    return 1
  fi

  echo ""
  echo "📝 Enter root class name:"
  read -r root_name

  # Track generated classes globally to prevent duplicates
  declare -A GENERATED_CLASSES

  function capitalize() {
    echo "$(tr '[:lower:]' '[:upper:]' <<< ${1:0:1})${1:1}"
  }

  function generate_class() {
    # Crucial: Every variable used inside this recursive function MUST be local
    local json="$1"
    local name="$2"
    local class_name
    class_name="$(capitalize "$name")"

    # Avoid duplicate generation in recursive loops
    if [[ ${GENERATED_CLASSES[$class_name]} ]]; then
      return
    fi
    GENERATED_CLASSES[$class_name]=1

    # Extract keys and types securely into an array
    local fields
    fields=$(echo "$json" | jq -r 'to_entries[] | "\(.key)|\(.value | type)"')

    local -a FIELD_LINES=()
    while IFS= read -r line; do
      [[ -n "$line" ]] && FIELD_LINES+=("$line")
    done <<< "$fields"

    # ----------------------------------------------------
    # PHASE 1: GENERATE ENTITY
    # ----------------------------------------------------
    echo "===== ENTITY: ${class_name}Entity ====="
    echo "class ${class_name}Entity {"

    for field in "${FIELD_LINES[@]}"; do
      local key type dart_type nested_class
      IFS='|' read -r key type <<< "$field"
      dart_type="dynamic"

      if [[ "$type" == "string" ]]; then
        dart_type="String"
      elif [[ "$type" == "number" ]]; then
        dart_type="double"
      elif [[ "$type" == "boolean" ]]; then
        dart_type="bool"
      elif [[ "$type" == "object" ]]; then
        nested_class="$(capitalize "$key")"
        dart_type="${nested_class}Entity"
      elif [[ "$type" == "array" ]]; then
        # Check type of first element using jq
        local first_type
        first_type=$(echo "$json" | jq -r ".\""$key"\"[0] | type")
        
        if [[ "$first_type" == "object" ]]; then
          nested_class="$(capitalize "${key}Item")"
          dart_type="List<${nested_class}Entity>"
        elif [[ "$first_type" == "string" ]]; then
          dart_type="List<String>"
        elif [[ "$first_type" == "number" ]]; then
          dart_type="List<double>"
        elif [[ "$first_type" == "boolean" ]]; then
          dart_type="List<bool>"
        else
          dart_type="List<dynamic>"
        fi
      fi

      echo "  final $dart_type $key;"
    done

    echo ""
    echo "  ${class_name}Entity({"
    for field in "${FIELD_LINES[@]}"; do
      local key
      IFS='|' read -r key _ <<< "$field"
      echo "    required this.$key,"
    done
    echo "  });"
    echo "}"
    echo ""

    # ----------------------------------------------------
    # PHASE 2: GENERATE MODEL
    # ----------------------------------------------------
    echo "===== MODEL: ${class_name}Model ====="
    echo "class ${class_name}Model extends ${class_name}Entity {"

    echo "  ${class_name}Model({"
    for field in "${FIELD_LINES[@]}"; do
      local key
      IFS='|' read -r key _ <<< "$field"
      echo "    required super.$key,"
    done
    echo "  });"

    echo ""
    echo "  factory ${class_name}Model.fromJson(Map<String, dynamic> json) {"
    echo "    return ${class_name}Model("

    for field in "${FIELD_LINES[@]}"; do
      local key type nested_class
      IFS='|' read -r key type <<< "$field"

      if [[ "$type" == "object" ]]; then
        nested_class="$(capitalize "$key")"
        echo "      $key: ${nested_class}Model.fromJson(json['$key']),"

      elif [[ "$type" == "array" ]]; then
        local first_type
        first_type=$(echo "$json" | jq -r ".\""$key"\"[0] | type")

        if [[ "$first_type" == "object" ]]; then
          nested_class="$(capitalize "${key}Item")"
          echo "      $key: (json['$key'] as List)"
          echo "          .map((e) => ${nested_class}Model.fromJson(e))"
          echo "          .toList(),"
        else
          echo "      $key: List<dynamic>.from(json['$key']),"
        fi
      else
        echo "      $key: json['$key'],"
      fi
    done

    echo "    );"
    echo "  }"

    echo ""
    echo "  Map<String, dynamic> toJson() {"
    echo "    return {"

    for field in "${FIELD_LINES[@]}"; do
      local key type nested_class
      IFS='|' read -r key type <<< "$field"

      if [[ "$type" == "object" ]]; then
        # Cast to Model to access .toJson() safely
        nested_class="$(capitalize "$key")"
        echo "      '$key': ($key as ${nested_class}Model).toJson(),"

      elif [[ "$type" == "array" ]]; then
        local first_type
        first_type=$(echo "$json" | jq -r ".\""$key"\"[0] | type")

        if [[ "$first_type" == "object" ]]; then
          nested_class="$(capitalize "${key}Item")"
          echo "      '$key': $key.map((e) => (e as ${nested_class}Model).toJson()).toList(),"
        else
          echo "      '$key': $key,"
        fi
      else
        echo "      '$key': $key,"
      fi
    done

    echo "    };"
    echo "  }"
    echo "}"
    echo ""

    # ----------------------------------------------------
    # PHASE 3: RECURSION DOWN THE JSON TREE
    # ----------------------------------------------------
    # We do recursion AFTER creating the current parent classes to avoid code interweaving
    for field in "${FIELD_LINES[@]}"; do
      local key type nested_class sub_json
      IFS='|' read -r key type <<< "$field"

      if [[ "$type" == "object" ]]; then
        sub_json=$(echo "$json" | jq -c ".\""$key"\"")
        generate_class "$sub_json" "$key"

      elif [[ "$type" == "array" ]]; then
        local first_type
        first_type=$(echo "$json" | jq -r ".\""$key"\"[0] | type")

        if [[ "$first_type" == "object" ]]; then
          sub_json=$(echo "$json" | jq -c ".\""$key"\"[0]")
          generate_class "$sub_json" "${key}Item"
        fi
      fi
    done
  }

  # Kickoff execution
  generate_class "$json_input" "$root_name"
}