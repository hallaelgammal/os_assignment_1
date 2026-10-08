#!/bin/bash
if [ "$#" -ne 3 ]; then 
     echo "usage: $0 dir malicious_dir interval-secs"
     exit 1
fi

dir="$1"
malicious_dir="$2"
interval="$3"

if [ ! -d "$dir" ]; then 
   echo "error: source directory does not exist."
   exit 1
fi

if [ ! -d "$malicious_dir" ]; then 
   echo "error: malicious_dir does not exist."
   exit 1
fi
scan_directory() {
	shopt -s nullglob
	for file in "$dir"/*; do
	   [ -f "$file" ] || continue
	   filename=$(basename "$file")
	   is_malicious=0

	   case "$filename" in
		*.exe|*.bat|*.vbs|*.scr|*.ps1)
			is_malicious=1
			;;
	   esac

	   # Check content keywords if not already flagged
        if [ "$is_malicious" -eq 0 ]; then
            if grep -qiE "virus|trojan|malware|worm|ransomware" "$file" 2>/dev/null; then
                is_malicious=1
            fi
        fi

        # Take action if flagged
        if [ "$is_malicious" -eq 1 ]; then
            echo "$filename is malicious and it is DELETED"
            cp "$file" "$malicious_dir/"
            rm -f "$file"
        fi
    done
    shopt -u nullglob
}

if [ ! -f "directory-info.last" ]; then
    scan_directory
    ls -l "$dir" > directory-info.last
fi

while true;
do
    sleep "$interval"

    ls -l "$dir" > directory-info.new

    if diff directory-info.last directory-info.new > /dev/null; then
        rm -f directory-info.new
    else
        scan_directory

	ls -l "$dir" > directory-info.last
	rm -f directory-info.new
    fi
done

