#!/bin/bash

dir="${1:-/path/to/test_dir}"
malicious_dir="${2:-/path/to/malicious_dir}"

if [ ! -d "$dir" ] || [ ! -d "$malicious_dir" ]; then
    exit 1
fi

scan_directory() {
    shopt -s nullglob
    for file in "$dir"/*; do
        [ -f "$file" ] || continue
        
        filename=$(basename "$file")
        is_malicious=0

        # to check final extensions
        case "$filename" in
            *.exe|*.bat|*.vbs|*.scr|*.ps1)
                is_malicious=1
                ;;
        esac

        # to check keywords
        if [ "$is_malicious" -eq 0 ]; then
            if grep -qiE "virus|trojan|malware|worm|ransomware" "$file" 2>/dev/null; then
                is_malicious=1
            fi
        fi

        # Quarantine action
        if [ "$is_malicious" -eq 1 ]; then
            echo "$filename is malicious and it is DELETED"
            cp "$file" "$malicious_dir/"
            rm -f "$file"
        fi
    done
    shopt -u nullglob
}

scan_directory

# Regenerate snapshot for state consistency
ls -l "$dir" > "$dir/../directory-info.last" 2>/dev/null || ls -l "$dir" > directory-info.last
