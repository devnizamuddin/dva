#!/bin/bash

function deployingWeb() {
  print_card "🚀 Deploying Flutter Web" "$CYAN"
  upgradeProjectVersion

  current_version=$(grep '^version:' pubspec.yaml | awk '{print $2}')

  version_name=$(echo "$current_version" | cut -d'+' -f1)
  version_code=$(echo "$current_version" | cut -d'+' -f2)
  
  echo ""
  print_status_info "Committing git files..."
  git add .
  git commit -m "📲 Deploy: v-$version_name+$version_code" >/dev/null 2>&1

  print_status_info "Adding Tag: release-$version_name"
  git tag "release-$version_name"

  echo ""
  show_progress_dots "Pushing commit and tag to origin" git push origin HEAD >/dev/null 2>&1 && git push origin "release-$version_name" >/dev/null 2>&1
  
  print_status_success "Pushed Flutter Web with tag: release-$version_name"
  echo ""
}

function deployingAndroid() {
  print_card "📱 Deploying Flutter Android" "$CYAN"
  upgradeProjectVersion

  current_version=$(grep '^version:' pubspec.yaml | awk '{print $2}')
  version_name=$(echo "$current_version" | cut -d'+' -f1)
  version_code=$(echo "$current_version" | cut -d'+' -f2)

  echo ""
  show_progress_dots "Building release APK for Android" flutter build apk --release

  echo ""
  print_status_info "Committing git files..."
  git add .
  git commit -m "📲 Deploy: v-$version_name+$version_code" >/dev/null 2>&1

  print_status_info "Adding Tag: release-$version_name"
  git tag "release-$version_name"

  echo ""
  show_progress_dots "Pushing commit and tag to origin" git push origin HEAD >/dev/null 2>&1 && git push origin "release-$version_name" >/dev/null 2>&1
  
  print_status_success "Pushed Flutter Android with tag: release-$version_name"
  echo ""
}