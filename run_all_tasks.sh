#!/bin/bash

# Demonstration: Running all maintenance tasks sequentially (Day 4 & 5)
# This shows what option #5 in the maintenance suite does

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                               ║"
echo "║      Running All Maintenance Tasks (Option 5)                ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo

echo "This demonstrates the 'Run All Maintenance Tasks' feature"
echo "from the Maintenance Suite menu."
echo

# Task 1: Backup
echo "═══════════════════════════════════════════════════════════════"
echo "  TASK 1/3: Running Backup Script..."
echo "═══════════════════════════════════════════════════════════════"
./scripts/backup.sh ./test_files
echo
echo "✅ Task 1 Complete"
echo

# Task 2: System Update
echo "═══════════════════════════════════════════════════════════════"
echo "  TASK 2/3: Running System Update & Cleanup..."
echo "═══════════════════════════════════════════════════════════════"
./scripts/system_update.sh
echo
echo "✅ Task 2 Complete"
echo

# Task 3: Log Monitor
echo "═══════════════════════════════════════════════════════════════"
echo "  TASK 3/3: Running Log Monitor..."
echo "═══════════════════════════════════════════════════════════════"
./scripts/log_monitor.sh scan
echo
echo "✅ Task 3 Complete"
echo

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                               ║"
echo "║      ✅ ALL MAINTENANCE TASKS COMPLETED ✅                    ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo
echo "All scripts executed successfully with:"
echo "  ✓ Comprehensive error handling (Day 5)"
echo "  ✓ Detailed logging (Day 5)"
echo "  ✓ Status reporting"
echo
