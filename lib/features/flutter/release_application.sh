#!/bin/bash
source "$(dirname "$0")/release_helpers.sh"


# * ===========================================================================================================================
# *                                                     Helper Functions
# * ===========================================================================================================================

# * ===========================================================
# * Clean old artifacts
# * ===========================================================

function _clean_old_artifacts() {
  echo "🧹 Cleaning old files..."
  rm -rf "${DMG_WORK_DIR}"
  rm -f "${DMG_NAME}"
}

# * ===========================================================
# * Build Flutter macOS app
# * ===========================================================

function _build_flutter_macos() {
  echo "🚀 Building Flutter macOS app..."
  ${FLUTTER_BUILD}
  APP_PATH="${BUILD_APP_PATH}/${APP_NAME}.app"
  if [ ! -d "$APP_PATH" ]; then
    echo "❌ App not found at $APP_PATH"
    exit 1
  fi
}

# * ===========================================================
# * Optional ad‑hoc signing (disable with SIGN_ADHOC=0)
# * ===========================================================

function _optional_sign() {
  if [ "${SIGN_ADHOC:-1}" -eq 1 ]; then
    echo "🔏 Ad‑hoc signing app..."
    if ! codesign --deep --force --sign - "$APP_PATH"; then
      echo "⚠️ Warning: codesign failed – the DMG will still be created but may show Gatekeeper warnings."
    fi
  else
    echo "⚡ Skipping ad‑hoc signing (SIGN_ADHOC=0)."
  fi
}

# * ===========================================================
# * Prepare DMG contents
# * ===========================================================

function _prepare_dmg_contents() {
  echo "📦 Preparing DMG contents..."
  mkdir "${DMG_WORK_DIR}"
  cp -R "$APP_PATH" "${DMG_WORK_DIR}/"
  ln -s /Applications "${DMG_WORK_DIR}/Applications"
}

# * ===========================================================
# * Create the DMG image
# * ===========================================================

function _create_dmg() {
  echo "💿 Creating DMG..."
  hdiutil create \
    -volname "${VOLUME_NAME}" \
    -srcfolder "${DMG_WORK_DIR}" \
    -ov \
    -format UDZO \
    "${DMG_NAME}"
}

# * ===========================================================
# * Extract version name and code from pubspec.yaml
# * ===========================================================
function _extract_version_vars() {
  local current_version=$(grep '^version:' pubspec.yaml | awk '{print $2}')
  version_name=$(echo "$current_version" | cut -d'+' -f1)
  version_code=$(echo "$current_version" | cut -d'+' -f2)
}

# * ===========================================================
# * Commit changes and create a Git tag
# * ===========================================================

function _git_commit_and_tag() {
  echo ""  # blank line for readability
  print_status_info "Committing git files..."
  git add .
  git commit -m "📲 Deploy: v-${version_name}+${version_code}" >/dev/null 2>&1 || true

  print_status_info "Adding Tag: release-${version_name}"
  git tag "release-${version_name}"
}

# * ===========================================================
# * Push commit and tag to origin
# * ===========================================================

function _git_push() {
  echo ""  # blank line for readability
  show_progress_dots "Pushing commit and tag to origin" \
    git push origin HEAD >/dev/null 2>&1 && git push origin "release-${version_name}" >/dev/null 2>&1
}


# * ===========================================================================================================================
# *                                                     Main Function
# * ===========================================================================================================================

# * ===========================================================
# * Building macOS App                                             
# * ===========================================================

function buildingMacOsApp(){

# ============================
# * CONFIG
# ============================
APP_NAME="NUS Assistant"            # Must match .app name
FLUTTER_BUILD="flutter build macos --release"
BUILD_APP_PATH="build/macos/Build/Products/Release"
DMG_WORK_DIR="dmg"
DMG_NAME="${APP_NAME}.dmg"
VOLUME_NAME="${APP_NAME}"

# ============================
# * Print starting message
# ============================

print_card "🚀 Building macOS App" "$CYAN"

# ============================
# * Upgrade project version
# ============================
upgradeProjectVersion

# ============================
# * CLEAN UP
# ============================
_clean_old_artifacts

# ============================
# * BUILD FLUTTER APP
# ============================
_build_flutter_macos

# ============================
# * OPTIONAL: AD-HOC SIGNING
# ============================
_optional_sign

# ============================
# * PREPARE DMG CONTENT
# ============================
_prepare_dmg_contents

# ============================
# * CREATE DMG
# ============================
_create_dmg

# ============================
# * DONE
# ============================
echo "✅ DMG created successfully: ${DMG_NAME}"
echo "⚠️  First launch requires Right-click → Open"

}

# * ===========================================================
# * Deploying Flutter Web                                             
# * ===========================================================

function deployingWeb() {

# ============================
# * Print starting message
# ============================

  print_card "🚀 Deploying Flutter Web" "$CYAN"

# ============================
# * Upgrade project version
# ============================

  upgradeProjectVersion

# ============================
# * Extract version vars
# ============================

  _extract_version_vars

# ============================
# * Commit git files
# ============================

  _git_commit_and_tag

# ============================
# * Push commit and tag
# ============================

  _git_push
  print_status_success "Pushed Flutter Web with tag: release-${version_name}"
  echo ""
}

# * ===========================================================
# * Deploying Flutter Android                                             
# * ===========================================================

function deployingAndroid() {
  # ============================
  # * Print starting message
  # ============================

  print_card "📱 Deploying Flutter Android" "$CYAN"

  # ============================
  # * Upgrade project version
  # ============================

  upgradeProjectVersion

  # ============================
  # * Extract version vars
  # ============================

  _extract_version_vars

  # ============================
  # * Build APK
  # ============================
  show_progress_dots "Building release APK for Android" flutter build apk --release
  _git_commit_and_tag
  _git_push
  print_status_success "Pushed Flutter Android with tag: release-${version_name}"
  echo ""
}