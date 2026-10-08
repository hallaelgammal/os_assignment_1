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


if [ ! -f "directory-info.last" ]; then
    ls -l "$dir" > directory-info.last
fi

while true
do
    sleep "$interval"

    ls -l "$dir" > directory-info.new

    if diff directory-info.last directory-info.new > /dev/null; then
        echo "No changes detected."
    else
        for file in "$dir"/*
do
    filename=$(basename "$file")

    case "$filename" in
        *.exe)
            # malicious
		echo "$file is malicious and it is DELETED"
		cp "$file" "$malicious_dir/"
		rm "$file"
            ;;
        *.bat)
            # malicious
		echo "$file is malicious and it is DELETED"
		cp "$file" "$malicious_dir/"
		rm "$file"
            ;;
        *.vbs)
            # malicious
		echo "$file is malicious and it is DELETED"
		cp "$file" "$malicious_dir/"
		rm "$file"
            ;;
        *.scr)
            # malicious
		echo "$file is malicious and it is DELETED"
		cp "$file" "$malicious_dir/"
		rm "$file"
            ;;
        *.ps1)
            # malicious
		echo "$file is malicious and it is DELETED"
		cp "$file" "$malicious_dir/"
		rm "$file"
            ;;
    esac
if grep -qiE "virus|trojan|malware|worm|ransomware" "$file"; then
        echo "$file is malicious and it is DELETED"
        cp "$file" "$malicious_dir/"
        rm "$file"
fi

done
    fi

    cp directory-info.new directory-info.last
done



