#!/bin/bash

function deployingWeb() {
  upgradeProjectVersion

  current_version=$(grep '^version:' pubspec.yaml | awk '{print $2}')

  version_name=$(echo "$current_version" | cut -d'+' -f1)
  version_code=$(echo "$current_version" | cut -d'+' -f2)
  echo ""
  echo "🆕 Commit files git"
  echo ""
  git add .
  git commit -m "📲 Deploy: v-$version_name+$version_code"
  echo ""
  echo "🏷️  Adding Tag-$version_name"
  echo ""
  git tag "release-$version_name"
  echo ""
  echo "🚀 Pushing commit and tag to origin"
  echo ""
  git push origin HEAD         # push the commit
  git push origin "release-$version_name"  # push the tag
  echo ""
  echo -e "✅ Pushed Flutter Web with tag: release-$version_name"
  echo ""
}

function deployingAndroid() {
  upgradeProjectVersion

  current_version=$(grep '^version:' pubspec.yaml | awk '{print $2}')
  version_name=$(echo "$current_version" | cut -d'+' -f1)
  version_code=$(echo "$current_version" | cut -d'+' -f2)

  echo ""
  echo "📱🛠️ Building release apk for Android"
  echo ""
  flutter build apk --release

  echo ""
  echo "🆕 Commit files git"
  echo ""
  git add .
  git commit -m "📲 Deploy: v-$version_name+$version_code"
  echo ""
  echo "🏷️  Adding Tag-$version_name"
  echo ""
  git tag "release-$version_name"
  echo ""
  echo "🚀 Pushing commit and tag to origin"
  echo ""
  git push origin HEAD         # push the commit
  git push origin "release-$version_name"  # push the tag
  echo ""
  echo -e "✅ Pushed Flutter Web with tag: release-$version_name"
  echo ""
}