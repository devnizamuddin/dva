
#* ┏==================================================================================================┓
#* ┃                           📖 Upgrade Flutter build and release vesrion                           ┃
#* ┗==================================================================================================┛


function upgradeProjectVersion(){

  # Extract the current version from pubspec.yaml
  current_version=$(grep '^version:' pubspec.yaml | awk '{print $2}')

  # Extract version name and version code separately
  version_name=$(echo "$current_version" | cut -d'+' -f1)
  version_code=$(echo "$current_version" | cut -d'+' -f2)

  # Increment version code
  new_version_code=$((version_code + 1))

  # Increment patch version (last digit of version name)
  IFS='.' read -r major minor patch <<< "$version_name"
  new_patch=$((patch + 1))

  # Generate the new version
  new_version_name="$major.$minor.$new_patch"

  # Update pubspec.yaml with the new version
  sed -i '' "s/^version: .*/version: $new_version_name+$new_version_code/" pubspec.yaml

  echo -e "\n✅ Version updated to: $new_version_name+$new_version_code"

}