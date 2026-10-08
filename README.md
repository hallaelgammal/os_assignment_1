# Lab 2: Antivirus Daemon & Restore Tool

## Overview & Folder Hierarchy
This project implements a simple antivirus monitoring daemon and an interactive
 quarantine restore tool in Bash.

```text
.
├── antivirusd.sh        # Monitoring daemon script
├── restore.sh           # Interactive quarantine restore tool
├── Makefile             # Build and management Makefile
├── README.md            # Documentation file
├── test_dir/            # Monitored directory
└── malicious_dir/       # Quarantine directory
