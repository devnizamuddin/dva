#!/bin/bash

function run_text_case_converter() {
    read -p "Enter your text: " input

    echo "=============================="
    echo " 🔠  TEXT CASE CONVERTER"
    echo "=============================="
    echo "1) UPPERCASE (ABC)"
    echo "2) lowercase (abc)"
    echo "3) Title Case (Abc Def)"
    echo "4) Snake Case (abc_def)"
    echo "5) Kebab Case (abc-def)"
    echo "6) Exit"
    echo "=============================="
    read -p "Choose an option [1-6]: " choice

    case $choice in
        1) printf '%s\n' "$input" | tr '[:lower:]' '[:upper:]';;
        2) printf '%s\n' "$input" | tr '[:upper:]' '[:lower:]';;
        3) printf '%s\n' "$input" | perl -pe "\$_=lc(\$_); s/(?<!')\b([[:alpha:]])/\\u\$1/g";;
        4) echo "$(echo "$input" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')" ;; # Snake case
        5) echo "$(echo "$input" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')" ;; # Kebab case
        6) echo "👋 Bye!"; return ;;
        *) echo "❌ Invalid choice" ;;
    esac
}


