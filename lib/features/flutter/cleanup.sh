#!/bin/bash

[[ -n "${_DVA_FLUTTER_CLEANUP_LOADED+x}" ]] && return 0
_DVA_FLUTTER_CLEANUP_LOADED=1

function _cleanup_flutter() {
  local platform="$1"
  echo ""
  echo "=========================="
  echo "Build deleted successfully ..."
  echo "=========================="
  echo ""

  echo ""
  echo "=========================="
  echo "Cleaning Flutter project ..."
  echo "=========================="
  echo ""
  flutter clean

  echo ""
  echo "=========================="
  echo "Getting dependencies ..."
  echo "=========================="
  echo ""
  flutter pub get

  echo "=========================="
  echo "=========================="
  echo "Finished cleaning [$platform] successfully ..."
  echo "=========================="
  echo "=========================="
}
