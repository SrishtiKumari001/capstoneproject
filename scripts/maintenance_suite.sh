#!/bin/bash

# Day 4 & 5: Maintenance Suite with Menu and Error Handling
# This script combines all maintenance scripts into a unified interface

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${LOG_FILE:-./logs/maintenance.log}"
BACKUP_SCRIPT="${SCRIPT_DIR}/backup.sh"
UPDATE_SCRIPT="${SCRIPT_DIR}/system_update.sh"
MONITOR_SCRIPT="${SCRIPT_DIR}/log_monitor.sh"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Error handling
set -euo pipefail

# Function to log messages (Day 5 enhancement)
log_message() {
    local level=$1
    shift
    local message="$@"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

# Function to print colored messages
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to handle errors (Day 5 enhancement)
error_handler() {
    local line_no=$1
    log_message "ERROR" "Script failed at line $line_no"
    print_message "$RED" "❌ An error occurred. Check $LOG_FILE for details."
    exit 1
}

trap 'error_handler $LINENO' ERR

# Function to execute a script with error handling
execute_script() {
    local script=$1
    local script_name=$2
    shift 2
    local args="$@"
    
    if [ ! -f "$script" ]; then
        log_message "ERROR" "Script not found: $script"
        print_message "$RED" "❌ Error: $script_name script not found"
        return 1
    fi
    
    if [ ! -x "$script" ]; then
        chmod +x "$script"
    fi
    
    log_message "INFO" "Executing $script_name"
    print_message "$CYAN" "\n▶ Executing $script_name..."
    echo
    
    # Execute with error handling
    if bash "$script" $args; then
        log_message "INFO" "$script_name completed successfully"
        print_message "$GREEN" "\n✓ $script_name completed successfully"
        return 0
    else
        local exit_code=$?
        log_message "ERROR" "$script_name failed with exit code $exit_code"
        print_message "$RED" "\n❌ $script_name failed"
        return $exit_code
    fi
}

# Function to display the main menu
show_menu() {
    clear
    print_message "$CYAN" "╔═══════════════════════════════════════════════╗"
    print_message "$CYAN" "║                                               ║"
    print_message "$CYAN" "║      SYSTEM MAINTENANCE SUITE v1.0           ║"
    print_message "$CYAN" "║                                               ║"
    print_message "$CYAN" "╚═══════════════════════════════════════════════╝"
    echo
    print_message "$YELLOW" "  1) Automated Backup"
    print_message "$YELLOW" "  2) System Update & Cleanup"
    print_message "$YELLOW" "  3) Log Monitor (Scan)"
    print_message "$YELLOW" "  4) Log Monitor (Continuous)"
    print_message "$YELLOW" "  5) Run All Maintenance Tasks"
    print_message "$YELLOW" "  6) View Logs"
    print_message "$YELLOW" "  7) System Status"
    print_message "$YELLOW" "  0) Exit"
    echo
    print_message "$GREEN" "═══════════════════════════════════════════════"
}

# Function to run all maintenance tasks
run_all_tasks() {
    print_message "$MAGENTA" "\n╔═══════════════════════════════════════════════╗"
    print_message "$MAGENTA" "║      Running All Maintenance Tasks           ║"
    print_message "$MAGENTA" "╚═══════════════════════════════════════════════╝"
    
    local success_count=0
    local total_tasks=3
    
    # Task 1: Backup
    if execute_script "$BACKUP_SCRIPT" "Backup"; then
        success_count=$((success_count + 1))
    fi
    
    echo
    print_message "$BLUE" "───────────────────────────────────────────────"
    echo
    
    # Task 2: System Update
    if execute_script "$UPDATE_SCRIPT" "System Update & Cleanup"; then
        success_count=$((success_count + 1))
    fi
    
    echo
    print_message "$BLUE" "───────────────────────────────────────────────"
    echo
    
    # Task 3: Log Monitor
    if execute_script "$MONITOR_SCRIPT" "Log Monitor" "scan"; then
        success_count=$((success_count + 1))
    fi
    
    echo
    print_message "$MAGENTA" "╔═══════════════════════════════════════════════╗"
    print_message "$MAGENTA" "║           All Tasks Completed                ║"
    print_message "$MAGENTA" "╚═══════════════════════════════════════════════╝"
    print_message "$GREEN" "\nSuccessful: $success_count/$total_tasks tasks"
    
    log_message "INFO" "All maintenance tasks completed: $success_count/$total_tasks successful"
}

# Function to view logs
view_logs() {
    print_message "$YELLOW" "\n=== Recent Log Entries ==="
    
    if [ -f "$LOG_FILE" ]; then
        tail -20 "$LOG_FILE"
    else
        print_message "$RED" "No log file found"
    fi
    
    echo
    print_message "$BLUE" "Full log location: $LOG_FILE"
}

# Function to show system status
show_status() {
    print_message "$CYAN" "\n╔═══════════════════════════════════════════════╗"
    print_message "$CYAN" "║            System Status Report              ║"
    print_message "$CYAN" "╚═══════════════════════════════════════════════╝"
    echo
    
    # Disk usage
    print_message "$YELLOW" "📊 Disk Usage:"
    df -h . | tail -1
    echo
    
    # Backup count
    if [ -d "./backups" ]; then
        local backup_count=$(find ./backups -maxdepth 1 -type d | wc -l)
        backup_count=$((backup_count - 1))
        print_message "$YELLOW" "💾 Backups: $backup_count"
        
        if [ $backup_count -gt 0 ]; then
            local latest_backup=$(ls -td ./backups/*/ 2>/dev/null | head -1)
            if [ -n "$latest_backup" ]; then
                print_message "$GREEN" "   Latest: $(basename "$latest_backup")"
            fi
        fi
    fi
    echo
    
    # Log files
    print_message "$YELLOW" "📝 Log Files:"
    if [ -d "./logs" ]; then
        ls -lh ./logs/*.log 2>/dev/null | awk '{print "   " $9 " (" $5 ")"}'
    fi
    echo
    
    # Script status
    print_message "$YELLOW" "🔧 Available Scripts:"
    for script in "$BACKUP_SCRIPT" "$UPDATE_SCRIPT" "$MONITOR_SCRIPT"; do
        if [ -f "$script" ]; then
            print_message "$GREEN" "   ✓ $(basename "$script")"
        else
            print_message "$RED" "   ✗ $(basename "$script") (missing)"
        fi
    done
}

# Function to pause and wait for user input
pause() {
    echo
    print_message "$BLUE" "Press Enter to continue..."
    read -r
}

# Main menu loop
main() {
    # Create necessary directories
    mkdir -p "$(dirname "$LOG_FILE")"
    mkdir -p ./backups ./logs ./test_files
    
    # Create some test files if they don't exist
    if [ ! "$(ls -A ./test_files 2>/dev/null)" ]; then
        echo "Sample file 1" > ./test_files/sample1.txt
        echo "Sample file 2" > ./test_files/sample2.txt
        mkdir -p ./test_files/subdir
        echo "Sample file 3" > ./test_files/subdir/sample3.txt
    fi
    
    log_message "INFO" "Maintenance Suite started"
    
    while true; do
        show_menu
        read -p "Enter your choice [0-7]: " choice
        
        case $choice in
            1)
                execute_script "$BACKUP_SCRIPT" "Automated Backup"
                pause
                ;;
            2)
                execute_script "$UPDATE_SCRIPT" "System Update & Cleanup"
                pause
                ;;
            3)
                execute_script "$MONITOR_SCRIPT" "Log Monitor" "scan"
                pause
                ;;
            4)
                print_message "$YELLOW" "Enter monitoring duration in seconds (default: 60):"
                read -p "> " duration
                duration=${duration:-60}
                execute_script "$MONITOR_SCRIPT" "Log Monitor" "monitor" "$duration"
                pause
                ;;
            5)
                run_all_tasks
                pause
                ;;
            6)
                view_logs
                pause
                ;;
            7)
                show_status
                pause
                ;;
            0)
                print_message "$GREEN" "\nThank you for using the Maintenance Suite!"
                log_message "INFO" "Maintenance Suite exited normally"
                exit 0
                ;;
            *)
                print_message "$RED" "\n❌ Invalid choice. Please try again."
                sleep 2
                ;;
        esac
    done
}

# Run main function
main "$@"
