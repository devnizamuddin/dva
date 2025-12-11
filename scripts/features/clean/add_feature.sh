#!/bin/bash

# Define the directory where this script resides to locate utilities relative to it
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Assuming the utils directory is two levels up -> ../../utils from scripts/features/clean
# Or more robustly, use DVA_HOME or reference from known location if DVA_HOME not guaranteed.
# Let's rely on standard path relative to this script for portability.
# features/clean -> features -> scripts -> utils is ../../utils
source "$SCRIPT_DIR/../../utils/text_utils.sh"

function add_feature_structure() {

  # * ╔==================================================================================================╗
  # * ║                                      Start From Here                                             ║
  # * ╚==================================================================================================╝

  # * 🧾 Taking feature name as user Input

  read -p "Enter your desired feature name: " FEATURE_NAME

  if [ -z "$FEATURE_NAME" ]; then
    echo "Feature name is required to generate feature structure!"
    return 1
  fi

  # * 🧾 Convert to snake_case and PascalCase
  local FEATURE_NAME_LOWER=$(to_snake_case "$FEATURE_NAME")
  local FEATURE_NAME_CAPITALIZED=$(to_pascal_case "$FEATURE_NAME")

  #*
  #* 🧾 Create folders
  #*

  local BASE_DIR="lib/features/$FEATURE_NAME_LOWER"

  echo "Creating folder structure for feature: $FEATURE_NAME_LOWER"

  mkdir -p "$BASE_DIR/data/datasources" \
           "$BASE_DIR/data/models" \
           "$BASE_DIR/data/repositories" \
           "$BASE_DIR/domain/entities" \
           "$BASE_DIR/domain/repositories" \
           "$BASE_DIR/domain/usecases" \
           "$BASE_DIR/presentation/blocs" \
           "$BASE_DIR/presentation/pages" \
           "$BASE_DIR/presentation/widgets"

  echo "Folders created successfully!"

  #* ╔==================================================================================================╗
  # * ║                                      Domain Layer                                                ║
  # * ╚==================================================================================================╝

  cat <<EOL > "$BASE_DIR/domain/entities/${FEATURE_NAME_LOWER}_entity.dart"
class ${FEATURE_NAME_CAPITALIZED}Entity {
  // Add properties and methods here
}
EOL

  cat <<EOL > "$BASE_DIR/domain/repositories/${FEATURE_NAME_LOWER}_repository.dart"
abstract class ${FEATURE_NAME_CAPITALIZED}Repository {
  // Define abstract methods here
}
EOL

  cat <<EOL > "$BASE_DIR/domain/usecases/${FEATURE_NAME_LOWER}_usecase.dart"
import '../repositories/${FEATURE_NAME_LOWER}_repository.dart';

class ${FEATURE_NAME_CAPITALIZED}UseCase {
  final ${FEATURE_NAME_CAPITALIZED}Repository repository;

  ${FEATURE_NAME_CAPITALIZED}UseCase({required this.repository});

  void call() {
    // Add logic here
  }
}
EOL

  #* ╔==================================================================================================╗
  # * ║                                      Data Layer                                                  ║
  # * ╚==================================================================================================╝

  cat <<EOL > "$BASE_DIR/data/models/${FEATURE_NAME_LOWER}_model.dart"
import '../../domain/entities/${FEATURE_NAME_LOWER}_entity.dart';

class ${FEATURE_NAME_CAPITALIZED}Model extends ${FEATURE_NAME_CAPITALIZED}Entity {
  // Add properties and methods here
}
EOL

  cat <<EOL > "$BASE_DIR/data/datasources/${FEATURE_NAME_LOWER}_remote_datasource.dart"
abstract class ${FEATURE_NAME_CAPITALIZED}RemoteDataSource {
  // Add properties and methods here
}

class ${FEATURE_NAME_CAPITALIZED}RemoteDataSourceImpl extends ${FEATURE_NAME_CAPITALIZED}RemoteDataSource {
  // Implement methods here
}
EOL

  cat <<EOL > "$BASE_DIR/data/repositories/${FEATURE_NAME_LOWER}_repository_impl.dart"
import '../../domain/repositories/${FEATURE_NAME_LOWER}_repository.dart';
import '../datasources/${FEATURE_NAME_LOWER}_remote_datasource.dart';

class ${FEATURE_NAME_CAPITALIZED}RepositoryImpl implements ${FEATURE_NAME_CAPITALIZED}Repository {
  final ${FEATURE_NAME_CAPITALIZED}RemoteDataSource remoteDataSource;

  ${FEATURE_NAME_CAPITALIZED}RepositoryImpl({
    required this.remoteDataSource,
  });
}
EOL

  #* ╔==================================================================================================╗
  # * ║                                      Presentation Layer                                          ║
  # * ╚==================================================================================================╝

  cat <<EOL > "$BASE_DIR/presentation/blocs/${FEATURE_NAME_LOWER}_bloc.dart"
import 'package:flutter_bloc/flutter_bloc.dart';

part '${FEATURE_NAME_LOWER}_event.dart';
part '${FEATURE_NAME_LOWER}_state.dart';

class ${FEATURE_NAME_CAPITALIZED}Bloc extends Bloc<${FEATURE_NAME_CAPITALIZED}Event, ${FEATURE_NAME_CAPITALIZED}State> {
  ${FEATURE_NAME_CAPITALIZED}Bloc() : super(${FEATURE_NAME_CAPITALIZED}Initial()) {
    on<${FEATURE_NAME_CAPITALIZED}Event>((event, emit) {});
  }
}
EOL

  cat <<EOL > "$BASE_DIR/presentation/blocs/${FEATURE_NAME_LOWER}_event.dart"
part of '${FEATURE_NAME_LOWER}_bloc.dart';

sealed class ${FEATURE_NAME_CAPITALIZED}Event {}
EOL

  cat <<EOL > "$BASE_DIR/presentation/blocs/${FEATURE_NAME_LOWER}_state.dart"
part of '${FEATURE_NAME_LOWER}_bloc.dart';

sealed class ${FEATURE_NAME_CAPITALIZED}State {}

final class ${FEATURE_NAME_CAPITALIZED}Initial extends ${FEATURE_NAME_CAPITALIZED}State {}
EOL

  cat <<EOL > "$BASE_DIR/presentation/pages/${FEATURE_NAME_LOWER}_page.dart"
import 'package:flutter/material.dart';

class ${FEATURE_NAME_CAPITALIZED}Page extends StatefulWidget {
  const ${FEATURE_NAME_CAPITALIZED}Page({super.key});

  @override
  State<${FEATURE_NAME_CAPITALIZED}Page> createState() => _${FEATURE_NAME_CAPITALIZED}PageState();
}

class _${FEATURE_NAME_CAPITALIZED}PageState extends State<${FEATURE_NAME_CAPITALIZED}Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('${FEATURE_NAME_CAPITALIZED} Page')),
      body: const Center(child: Text('Hello, ${FEATURE_NAME_CAPITALIZED}!')),
    );
  }
}
EOL

  echo "Feature $FEATURE_NAME_LOWER ($FEATURE_NAME_CAPITALIZED) structure created successfully!"

}
