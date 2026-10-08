#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "usage: $0 dir malicious_dir"
    exit 1
fi

dir="$1"
malicious_dir="$2"

if [ ! -d "$dir" ]; then
    echo "error: source directory does not exist"
    exit 1
fi

if [ ! -d "$malicious_dir" ]; then 
   echo "error: malicious_dir does not exist."
   exit 1
fi



while true; do
    
 if [ -z "$(find "$malicious_dir" -type f -print -quit)" ]; then
        echo "No malicious files to review."
        exit 0
    fi

    
    files=()
    shopt -s nullglob
    for file in "$malicious_dir"/*; do
        if [ -f "$file" ]; then
            files+=("$file")
        fi
    done
    shopt -u nullglob

    
    echo "Quarantined Files:"
    
    i=1
    for file in "${files[@]}"; do
        echo "$i. $(basename "$file")"
        i=$((i + 1))
    done
    

    read -p "Choose a file (by number): " choice

    
    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#files[@]}" ]; then
        echo "Invalid selection. Please try again."
        echo ""
        continue
    fi

    selected="${files[$((choice - 1))]}"
    selected_name=$(basename "$selected")

    
    echo "Selected File: $selected_name"
    echo "1. Restore this file back into $dir"
    echo "2. Permanently delete this file from $malicious_dir"
    echo "3. Leave as-is"
    read -p "Choose an action (1-3): " action

    case "$action" in
        1)
            # Restore file back to original directory
            mv "$selected" "$dir/$selected_name"
            echo "Restored $selected_name to $dir."
            ;;
        2)
            # Permanently delete file from quarantine
            rm -f "$selected"
            echo "$selected_name permanently deleted."
            ;;
        3)
            # Leave file in quarantine and return to the list
            echo "Left $selected_name as-is."
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
    echo ""
done
