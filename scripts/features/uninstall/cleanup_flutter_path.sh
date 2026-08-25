#!/bin/bash

set -Eeuo pipefail

# ============================================================
# Flutter / Dart / FVM PATH Cleanup for macOS
# ============================================================

CURRENT_USER="${SUDO_USER:-$(stat -f '%Su' /dev/console)}"

USER_HOME="$(
    dscl . -read "/Users/$CURRENT_USER" NFSHomeDirectory |
    awk '{print $2}'
)"

echo
echo "================================================"
echo " Flutter / Dart / FVM PATH Cleanup"
echo "================================================"
echo
echo "User: $CURRENT_USER"
echo

CONFIG_FILES=(
    "$USER_HOME/.zshrc"
    "$USER_HOME/.zprofile"
    "$USER_HOME/.zlogin"
    "$USER_HOME/.bashrc"
    "$USER_HOME/.bash_profile"
    "$USER_HOME/.profile"
)

FOUND=0

for FILE in "${CONFIG_FILES[@]}"; do

    [[ -f "$FILE" ]] || continue

    if grep -qiE 'flutter|dart|fvm' "$FILE"; then

        FOUND=1

        echo "================================================"
        echo "Found Flutter/Dart/FVM references in:"
        echo "  $FILE"
        echo "================================================"
        echo

        echo "Matching lines:"
        grep -niE 'flutter|dart|fvm' "$FILE" || true

        echo
        read -r -p "Remove these lines from this file? [y/N]: " CONFIRM

        if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then

            BACKUP="${FILE}.backup.$(date +%Y%m%d_%H%M%S)"

            cp "$FILE" "$BACKUP"

            echo
            echo "Backup created:"
            echo "  $BACKUP"

            TEMP_FILE="$(mktemp)"

            # Remove lines containing Flutter, Dart, or FVM.
            grep -viE 'flutter|dart|fvm' "$FILE" > "$TEMP_FILE" || true

            mv "$TEMP_FILE" "$FILE"

            echo
            echo "✓ Cleaned:"
            echo "  $FILE"

        else

            echo
            echo "Skipped:"
            echo "  $FILE"

        fi

        echo

    fi

done

echo "================================================"

if [[ "$FOUND" -eq 0 ]]; then

    echo "No Flutter, Dart, or FVM references were found."

else

    echo "PATH cleanup completed."

fi

echo "================================================"
echo
echo "Restart Terminal or run:"
echo
echo "  exec \$SHELL"
echo
echo "Then verify:"
echo
echo "  which flutter"
echo "  which dart"
echo "  which fvm"
echo