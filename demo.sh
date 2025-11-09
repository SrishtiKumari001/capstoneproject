#!/bin/bash

# Demo script to showcase all five days of functionality

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                               ║"
echo "║   Bash Scripting Suite - Assignment 5 Demo                   ║"
echo "║   All Five Days Completed                                    ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo
echo "This demo will showcase all 5 days of the assignment:"
echo "  Day 1: Automated Backup"
echo "  Day 2: System Update & Cleanup"
echo "  Day 3: Log Monitoring"
echo "  Day 4: Maintenance Suite Menu"
echo "  Day 5: Error Handling & Logging (integrated in all scripts)"
echo
echo "Press Enter to continue with the demo..."
read

echo
echo "═══════════════════════════════════════════════════════════════"
echo "  DAY 1: AUTOMATED BACKUP SCRIPT"
echo "═══════════════════════════════════════════════════════════════"
echo
sleep 2
./scripts/backup.sh ./test_files

echo
echo
echo "Press Enter to continue..."
read

echo
echo "═══════════════════════════════════════════════════════════════"
echo "  DAY 2: SYSTEM UPDATE & CLEANUP SCRIPT"
echo "═══════════════════════════════════════════════════════════════"
echo
sleep 2
./scripts/system_update.sh

echo
echo
echo "Press Enter to continue..."
read

echo
echo "═══════════════════════════════════════════════════════════════"
echo "  DAY 3: LOG MONITORING SCRIPT"
echo "═══════════════════════════════════════════════════════════════"
echo
sleep 2
./scripts/log_monitor.sh scan

echo
echo
echo "Press Enter to continue..."
read

echo
echo "═══════════════════════════════════════════════════════════════"
echo "  DAY 4 & 5: MAINTENANCE SUITE (with Error Handling & Logging)"
echo "═══════════════════════════════════════════════════════════════"
echo
echo "The maintenance suite combines all scripts with:"
echo "  ✓ Interactive menu system"
echo "  ✓ Comprehensive error handling (Day 5)"
echo "  ✓ Detailed logging functionality (Day 5)"
echo "  ✓ System status monitoring"
echo
echo "To run the full maintenance suite interactively, use:"
echo "    ./scripts/maintenance_suite.sh"
echo
echo
echo "═══════════════════════════════════════════════════════════════"
echo "  ASSIGNMENT COMPLETION SUMMARY"
echo "═══════════════════════════════════════════════════════════════"
echo
echo "✅ Day 1: Automated backup with timestamps - COMPLETE"
echo "✅ Day 2: System update and cleanup - COMPLETE"
echo "✅ Day 3: Log monitoring with alerts - COMPLETE"
echo "✅ Day 4: Maintenance suite with menu - COMPLETE"
echo "✅ Day 5: Error handling & logging - COMPLETE"
echo
echo "All scripts are located in the ./scripts/ directory"
echo "All logs are stored in the ./logs/ directory"
echo "All backups are stored in the ./backups/ directory"
echo
echo "For full interactive experience, run: ./scripts/maintenance_suite.sh"
echo
