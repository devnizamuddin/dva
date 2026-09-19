#!/bin/bash

# Define the directory where this script resides to locate utilities relative to it
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../utils/text_utils.sh"

# * ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
# * ║                                        New Bloc Generator                                        ║
# * ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝

function new_bloc() {

  # * ─── Input ────────────────────────────────────────────────────────────────
  read -p "Enter your feature name (e.g., auth): " FEATURE_NAME
  if [ -z "$FEATURE_NAME" ]; then
    echo "❌ Feature name is required!"
    return 1
  fi

  read -p "Enter your bloc name (e.g., login): " BLOC_NAME
  if [ -z "$BLOC_NAME" ]; then
    echo "❌ Bloc name is required!"
    return 1
  fi

  # * ─── Naming Conventions ────────────────────────────────────────────────────
  local FEATURE_LOWER=$(to_snake_case "$FEATURE_NAME")
  local BLOC_LOWER=$(to_snake_case "$BLOC_NAME")
  local BLOC_PASCAL=$(to_pascal_case "$BLOC_NAME")

  # * ─── Target Directory ──────────────────────────────────────────────────────
  local FEATURE_DIR="lib/features/$FEATURE_LOWER"
  local BLOC_DIR="$FEATURE_DIR/presentation/bloc/${BLOC_LOWER}"

  if [ ! -d "$FEATURE_DIR" ]; then
    echo "❌ Feature directory '$FEATURE_DIR' does not exist."
    echo "   👉 Please run 'Add Feature' first to create the feature structure."
    return 1
  fi

  if [ -d "$BLOC_DIR" ]; then
    echo "⚠️  Bloc '${BLOC_LOWER}' already exists at '$BLOC_DIR'."
    read -p "   Overwrite? (y/N): " CONFIRM
    if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
      echo "   Skipped."
      return 0
    fi
  fi

  mkdir -p "$BLOC_DIR"

  echo "⚙️  Generating bloc: ${BLOC_PASCAL}Bloc  →  $BLOC_DIR"

  # * ─── Bloc File ─────────────────────────────────────────────────────────────
  cat <<EOL > "$BLOC_DIR/${BLOC_LOWER}_bloc.dart"
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/value_equator.dart';

part '${BLOC_LOWER}_event.dart';
part '${BLOC_LOWER}_state.dart';

class ${BLOC_PASCAL}Bloc extends Bloc<${BLOC_PASCAL}Event, ${BLOC_PASCAL}State> {
  ${BLOC_PASCAL}Bloc() : super(${BLOC_PASCAL}Initial()) {
    on<${BLOC_PASCAL}Event>(_on${BLOC_PASCAL}Event);
  }

  void _on${BLOC_PASCAL}Event(${BLOC_PASCAL}Event event, Emitter<${BLOC_PASCAL}State> emit) {
    // TODO: Handle events
  }
}
EOL

  # * ─── Event File ─────────────────────────────────────────────────────────────
  cat <<EOL > "$BLOC_DIR/${BLOC_LOWER}_event.dart"
part of '${BLOC_LOWER}_bloc.dart';

sealed class ${BLOC_PASCAL}Event extends ValueEquator {
  const ${BLOC_PASCAL}Event();
  @override
  List<Object?> get values => [];
}
EOL

  # * ─── State File ─────────────────────────────────────────────────────────────
  cat <<EOL > "$BLOC_DIR/${BLOC_LOWER}_state.dart"
part of '${BLOC_LOWER}_bloc.dart';

sealed class ${BLOC_PASCAL}State extends ValueEquator {
  const ${BLOC_PASCAL}State();
  @override
  List<Object?> get values => [];
}

final class ${BLOC_PASCAL}Initial extends ${BLOC_PASCAL}State {}

final class ${BLOC_PASCAL}Loading extends ${BLOC_PASCAL}State {}

final class ${BLOC_PASCAL}Success extends ${BLOC_PASCAL}State {}

final class ${BLOC_PASCAL}Failure extends ${BLOC_PASCAL}State {
  final String message;
  const ${BLOC_PASCAL}Failure({required this.message});
}
EOL

  echo ""
  echo "✅ Bloc generated successfully!"
  echo ""
  echo "   📁 $BLOC_DIR/"
  echo "      ├── ${BLOC_LOWER}_bloc.dart"
  echo "      ├── ${BLOC_LOWER}_event.dart"
  echo "      └── ${BLOC_LOWER}_state.dart"
  echo ""
}
