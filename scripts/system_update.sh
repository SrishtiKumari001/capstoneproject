#!/bin/bash

# Day 2: System Update and Cleanup Script
# This script performs system updates and cleans up unnecessary files

# Configuration
LOG_FILE="${LOG_FILE:-./logs/system_update.log}"
CLEANUP_DIRS=("./logs" "./backups")
MAX_LOG_AGE=30

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

# Error handling (Day 5 requirement)
set -euo pipefail
trap 'log_message "ERROR" "Update script failed at line $LINENO"' ERR

# Function to simulate package updates (safe for demo)
update_system() {
    print_message "$YELLOW" "=== System Update ==="
    log_message "INFO" "Starting system update check"
    
    # Check if running with proper permissions
    if [ "$EUID" -eq 0 ]; then
        print_message "$BLUE" "Running as root, performing actual system updates..."
        
        # Detect package manager and update
        if command -v apt-get &> /dev/null; then
            print_message "$YELLOW" "Updating package lists..."
            apt-get update -qq && log_message "INFO" "Package lists updated"
            
            print_message "$YELLOW" "Upgrading packages..."
            apt-get upgrade -y -qq && log_message "INFO" "Packages upgraded"
        elif command -v yum &> /dev/null; then
            print_message "$YELLOW" "Updating system with yum..."
            yum update -y -q && log_message "INFO" "System updated with yum"
        elif command -v dnf &> /dev/null; then
            print_message "$YELLOW" "Updating system with dnf..."
            dnf update -y -q && log_message "INFO" "System updated with dnf"
        else
            print_message "$YELLOW" "No supported package manager found"
            log_message "WARNING" "No supported package manager detected"
        fi
    else
        print_message "$BLUE" "Simulating system update (run as root for actual updates)..."
        print_message "$GREEN" "✓ Package list update simulated"
        print_message "$GREEN" "✓ System upgrade simulated"
        log_message "INFO" "System update simulated (non-root execution)"
    fi
    
    print_message "$GREEN" "System update completed"
}

# Function to clean up old files
cleanup_system() {
    print_message "$YELLOW" "\n=== System Cleanup ==="
    log_message "INFO" "Starting cleanup process"
    
    local total_freed=0
    
    # Clean old log files
    for dir in "${CLEANUP_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            print_message "$YELLOW" "Cleaning old files in $dir..."
            
            # Find and remove files older than MAX_LOG_AGE days
            local old_files=$(find "$dir" -type f -mtime +${MAX_LOG_AGE} 2>/dev/null)
            
            if [ -n "$old_files" ]; then
                local size_before=$(du -sb "$dir" 2>/dev/null | cut -f1)
                find "$dir" -type f -mtime +${MAX_LOG_AGE} -delete 2>/dev/null
                local size_after=$(du -sb "$dir" 2>/dev/null | cut -f1)
                local freed=$((size_before - size_after))
                total_freed=$((total_freed + freed))
                
                print_message "$GREEN" "✓ Cleaned $dir (freed $(numfmt --to=iec $freed 2>/dev/null || echo $freed bytes))"
                log_message "INFO" "Cleaned $dir, freed $freed bytes"
            else
                print_message "$GREEN" "✓ No old files to clean in $dir"
            fi
        fi
    done
    
    # Clean temporary files
    print_message "$YELLOW" "Cleaning temporary files..."
    if [ -d "/tmp" ] && [ "$EUID" -eq 0 ]; then
        find /tmp -type f -mtime +7 -delete 2>/dev/null && \
            print_message "$GREEN" "✓ Temporary files cleaned"
    else
        print_message "$GREEN" "✓ Temporary cleanup skipped (requires root)"
    fi
    
    # Clean package cache (if root)
    if [ "$EUID" -eq 0 ]; then
        if command -v apt-get &> /dev/null; then
            print_message "$YELLOW" "Cleaning package cache..."
            apt-get clean -qq && apt-get autoclean -qq
            print_message "$GREEN" "✓ Package cache cleaned"
            log_message "INFO" "Package cache cleaned"
        fi
    fi
    
    print_message "$GREEN" "\n=== Cleanup Complete ==="
    print_message "$GREEN" "Total space freed: $(numfmt --to=iec $total_freed 2>/dev/null || echo $total_freed bytes)"
    log_message "INFO" "Cleanup completed, total freed: $total_freed bytes"
}

# Main execution
main() {
    mkdir -p "$(dirname "$LOG_FILE")"
    
    log_message "INFO" "System update and cleanup script started"
    print_message "$BLUE" "╔════════════════════════════════════════╗"
    print_message "$BLUE" "║  System Update & Cleanup Script       ║"
    print_message "$BLUE" "╚════════════════════════════════════════╝"
    
    update_system
    cleanup_system
    
    print_message "$GREEN" "\n✓ All operations completed successfully"
    log_message "INFO" "Script completed successfully"
}

main "$@"
