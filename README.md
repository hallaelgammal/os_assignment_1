# Lab 2: Antivirus Daemon & Restore Tool

## Overview & Folder Hierarchy
This project implements a lightweight Linux/Bash antivirus solution consisting of
 a background monitoring daemon (`antivirusd.sh`),
 an interactive quarantine restoration tool (`restore.sh`),
 and an automated periodic scanner (`antivirus-cron.sh`).

```text
.
├── antivirusd.sh        # Core monitoring daemon script (Part 1)
├── restore.sh           # Interactive quarantine restore tool (Part 2)
├── antivirus-cron.sh    # Periodic cron scan script (Bonus 1)
├── whitelist.txt        # Excluded filenames database (Bonus 2)
├── Makefile             # Build and management Makefile (Part 3)
├── README.md            # Project documentation (Part 4)
├── test_dir/            # Monitored source directory
└── malicious_dir/       # Quarantine directory

## Prerequisites and installation 
This project runs on Linux/Ubuntu environments and requires standard Unix tools
 including 'bash', 'GNU make', 'grep', 'coreutils', and 'cron'.

To install all required dependencies on Ubuntu, open your terminal and run:
    sudo apt update
    sudo apt install build-essential bash cron
to ensure the cron daemon is active on your system 
    sudo systemctl enable --now cron

## Step by step instructions 
1) set file permissions
  Before executing the scripts, ensure all files have execution permissions:
      chmod +x antivirusd.sh restore.sh antivirus-cron.sh

2) running via Makefile (recommended)
  setup directories
      make setup 
  
  run the antivirus daemon 
      make antivirus
  run the restore tool
      make restore

3) running manually
  antivirus daemon
      ./antivirusd.sh test_dir malicious_dir 5
    Argument 1: Directory to monitor (test_dir)

    Argument 2: Quarantine directory (malicious_dir)

    Argument 3: Scan interval in seconds (5)


  restore tool 
      ./restore.sh test_dir malicious_dir
    Displays a numbered list of files in quarantine.

Enter a file number to review it, then choose an action:

   1. Restore this file back into dir: Moves the file back to test_dir (with a prompt asking whether to add it to whitelist.txt).

   2. Permanently delete this file from malicious_dir: Removes the file permanently.

   3. Go back: Returns to the main selection list.


## Hardcoded rule locations
The threat detection logic is located inside the scan_directory function
 in antivirusd.sh (as well as antivirus-cron.sh):

1) flagged extensions list: 
   defined within the " case "$filename"" in pattern matching block
   inside "scan_directory":
        
        case "$filename" in
    *.exe|*.bat|*.vbs|*.scr|*.ps1)
        is_malicious=1
        ;;
esac


2) flagged keywords list:
   defined within the case insenstive extended regex "grep" command inside 
   "scan_directory": 

       grep -qiE "virus|trojan|malware|worm|ransomware" "$file"


## Bonus features 

   ## bonus 1: cron job setup
    1) Executing Every Minute at Second 23

Edit your user crontab using crontab -e and add:
    * * * * * sleep 23 && /home/hallaelgammal/Desktop/os_assignment_1/antivirus-cron.sh /home/hallaelgammal/Desktop/os_assignment_1/test_dir /home/hallaelgammal/Desktop/os_assignment_1/malicious_dir

    2) Cron expression for every 3rd Friday of the month at 12:31 am 
      31 0 15-21 * * [ "$(date +\%u)" -eq 5 ] && /home/hallaelgammal/Desktop/os_assignment_1/antivirus-cron.sh /home/hallaelgammal/Desktop/os_assignment_1/test_dir /home/hallaelgammal/Desktop/os_assignment_1/malicious_dir
  
     31 0: Runs at 12:31 AM (Minute 31, Hour 0).
     15-21: Restricts execution to days 15 through 21 (the day-of-month window containing the 3rd Friday).
     [ "$(date +\%u)" -eq 5 ]: Verifies that the day of the week is Friday (5).



    ## bonus 2: whitelist mechanism 
     * Database : whitelisted filenames are saved in whitelist.txt
     * Restoration Prompt: When restoring a file via restore.sh,
       option 1 prompts whether to whitelist the file. If confirmed,
       the file name is appended to whitelist.txt.
     * Daemon Exclusion: Before analyzing extensions or keywords,
       antivirusd.sh checks if the filename exists in whitelist.txt.
       Whitelisted files are skipped and remain in test_dir.
