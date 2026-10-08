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
