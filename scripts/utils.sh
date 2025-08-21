#!/bin/bash
# Common helper functions
# MIT License (c) 2025 Nizam Uddin Shamrat

function confirm() {
    read -p "$1 (y/n): " choice
    case "$choice" in
        y|Y ) return 0 ;;
        * ) return 1 ;;
    esac
}
