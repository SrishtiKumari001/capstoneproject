#!/bin/bash

# Day 3: Log Monitoring Script
# This script monitors log files and alerts on certain conditions

# Configuration
MONITOR_LOGS=("./logs/backup.log" "./logs/system_update.log" "./logs/maintenance.log")
ALERT_LOG="${ALERT_LOG:-./logs/alerts.log}"
CHECK_INTERVAL=5
ALERT_PATTERNS=("ERROR" "CRITICAL" "FAILED" "WARNING")

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Function to log alerts
log_alert() {
    local level=$1
    local message=$2
    local log_file=$3
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message (Source: $log_file)" | tee -a "$ALERT_LOG"
}

# Function to print colored messages
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Ensure log directory exists before any logging
mkdir -p "$(dirname "$ALERT_LOG")"

# Error handling (Day 5 requirement)
set -euo pipefail
trap 'echo "[$(date +"%Y-%m-%d %H:%M:%S")] [ERROR] Log monitor failed at line $LINENO" | tee -a "$ALERT_LOG" >&2; exit 1' ERR

# Function to check for patterns in a log file
check_log_file() {
    local log_file=$1
    
    if [ ! -f "$log_file" ]; then
        echo 0
        return
    fi
    
    local alerts_found=0
    
    for pattern in "${ALERT_PATTERNS[@]}"; do
        local matches=$(grep -c "$pattern" "$log_file" 2>/dev/null || true)
        matches=${matches:-0}
        
        if [ "$matches" -gt 0 ]; then
            alerts_found=$((alerts_found + matches))
            
            case $pattern in
                "CRITICAL"|"FAILED")
                    print_message "$RED" "🚨 CRITICAL: Found $matches '$pattern' entries in $(basename $log_file)" >&2
                    log_alert "CRITICAL" "Found $matches '$pattern' entries" "$log_file" >&2
                    ;;
                "ERROR")
                    print_message "$RED" "❌ ERROR: Found $matches error entries in $(basename $log_file)" >&2
                    log_alert "ERROR" "Found $matches error entries" "$log_file" >&2
                    ;;
                "WARNING")
                    print_message "$YELLOW" "⚠️  WARNING: Found $matches warning entries in $(basename $log_file)" >&2
                    log_alert "WARNING" "Found $matches warning entries" "$log_file" >&2
                    ;;
            esac
            
            # Show recent matches
            print_message "$BLUE" "   Recent entries:" >&2
            grep "$pattern" "$log_file" | tail -3 | while read line; do
                echo "   → $line" >&2
            done
            echo >&2
        fi
    done
    
    echo $alerts_found
}

# Function to monitor logs continuously
monitor_continuous() {
    local duration=$1
    local end_time=$((SECONDS + duration))
    
    print_message "$YELLOW" "Monitoring logs for $duration seconds..."
    print_message "$BLUE" "Press Ctrl+C to stop monitoring"
    echo
    
    while [ $SECONDS -lt $end_time ]; do
        for log_file in "${MONITOR_LOGS[@]}"; do
            check_log_file "$log_file" > /dev/null
        done
        sleep $CHECK_INTERVAL
    done
}

# Function to perform single scan
scan_logs() {
    print_message "$BLUE" "╔════════════════════════════════════════╗"
    print_message "$BLUE" "║      Log Monitoring & Alert System    ║"
    print_message "$BLUE" "╚════════════════════════════════════════╝"
    echo
    
    print_message "$YELLOW" "Scanning log files for issues..."
    echo
    
    local total_alerts=0
    local files_checked=0
    
    for log_file in "${MONITOR_LOGS[@]}"; do
        if [ -f "$log_file" ]; then
            files_checked=$((files_checked + 1))
            print_message "$GREEN" "📄 Checking: $log_file"
            local count=$(check_log_file "$log_file")
            total_alerts=$((total_alerts + count))
        fi
    done
    
    echo
    print_message "$GREEN" "=== Scan Summary ==="
    print_message "$GREEN" "Files checked: $files_checked"
    print_message "$GREEN" "Total alerts: $total_alerts"
    
    if [ $total_alerts -eq 0 ]; then
        print_message "$GREEN" "✓ No issues detected"
    else
        print_message "$YELLOW" "⚠️  $total_alerts issue(s) require attention"
    fi
    
    # System resource check
    echo
    print_message "$BLUE" "=== System Resources ==="
    
    # Disk usage
    local disk_usage=$(df -h . | tail -1 | awk '{print $5}' | sed 's/%//')
    if [ "$disk_usage" -gt 80 ]; then
        print_message "$RED" "⚠️  Disk usage: ${disk_usage}% (High)"
        log_alert "WARNING" "High disk usage: ${disk_usage}%" "system"
    else
        print_message "$GREEN" "✓ Disk usage: ${disk_usage}%"
    fi
    
    # Memory usage
    if command -v free &> /dev/null; then
        local mem_usage=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100.0}')
        if [ "$mem_usage" -gt 80 ]; then
            print_message "$RED" "⚠️  Memory usage: ${mem_usage}% (High)"
            log_alert "WARNING" "High memory usage: ${mem_usage}%" "system"
        else
            print_message "$GREEN" "✓ Memory usage: ${mem_usage}%"
        fi
    fi
    
    # Load average
    if command -v uptime &> /dev/null; then
        local load_avg=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')
        print_message "$GREEN" "✓ Load average: $load_avg"
    fi
}

# Main execution
main() {
    mkdir -p "$(dirname "$ALERT_LOG")"
    
    case "${1:-scan}" in
        scan)
            scan_logs
            ;;
        monitor)
            duration=${2:-60}
            monitor_continuous $duration
            ;;
        *)
            echo "Usage: $0 [scan|monitor [duration]]"
            echo "  scan    - Perform a single scan of log files"
            echo "  monitor - Continuously monitor logs (default: 60 seconds)"
            exit 1
            ;;
    esac
}

main "$@"
