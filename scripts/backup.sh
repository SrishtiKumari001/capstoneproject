#!/bin/bash

# Day 1: Automated System Backup Script
# This script creates timestamped backups of specified directories

# Configuration
BACKUP_DIR="${BACKUP_DIR:-./backups}"
LOG_FILE="${LOG_FILE:-./logs/backup.log}"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="backup_${TIMESTAMP}"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to log messages
log_message() {
    local level=$1
    shift
    local message="$@"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message" | tee -a "$LOG_FILE"
}

# Function to print colored messages
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Ensure log directory exists before any logging
mkdir -p "$(dirname "$LOG_FILE")"

# Error handling
set -euo pipefail
trap 'log_message "ERROR" "Backup failed at line $LINENO"' ERR

# Main backup function
perform_backup() {
    local source_dirs=("$@")
    
    if [ ${#source_dirs[@]} -eq 0 ]; then
        log_message "INFO" "No directories specified, using default: ./test_files"
        source_dirs=("./test_files")
    fi
    
    # Create backup directory if it doesn't exist
    mkdir -p "$BACKUP_DIR"
    
    # Create timestamped backup directory
    local backup_path="${BACKUP_DIR}/${BACKUP_NAME}"
    mkdir -p "$backup_path"
    
    log_message "INFO" "Starting backup process"
    print_message "$YELLOW" "=== Automated Backup Script ==="
    
    # Backup each directory
    for dir in "${source_dirs[@]}"; do
        if [ -d "$dir" ]; then
            local dir_name=$(basename "$dir")
            local archive_name="${backup_path}/${dir_name}.tar.gz"
            
            print_message "$YELLOW" "Backing up: $dir"
            tar -czf "$archive_name" -C "$(dirname "$dir")" "$(basename "$dir")" 2>/dev/null || {
                log_message "WARNING" "Failed to backup $dir"
                continue
            }
            
            local size=$(du -h "$archive_name" | cut -f1)
            print_message "$GREEN" "✓ Backed up $dir ($size)"
            log_message "INFO" "Successfully backed up $dir to $archive_name ($size)"
        else
            log_message "WARNING" "Directory not found: $dir"
            print_message "$RED" "✗ Directory not found: $dir"
        fi
    done
    
    # Create backup manifest
    local manifest="${backup_path}/MANIFEST.txt"
    {
        echo "Backup created: $(date)"
        echo "Backup location: $backup_path"
        echo "Contents:"
        ls -lh "$backup_path"
    } > "$manifest"
    
    # Summary
    local total_size=$(du -sh "$backup_path" | cut -f1)
    print_message "$GREEN" "\n=== Backup Complete ==="
    print_message "$GREEN" "Backup location: $backup_path"
    print_message "$GREEN" "Total size: $total_size"
    log_message "INFO" "Backup completed successfully. Total size: $total_size"
    
    return 0
}

# Parse command line arguments
if [ $# -eq 0 ]; then
    perform_backup
else
    perform_backup "$@"
fi
