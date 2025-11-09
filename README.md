# Bash Scripting Suite for System Maintenance

A comprehensive collection of Bash scripts designed to automate system maintenance tasks including backups, updates, log monitoring, and system cleanup.

## 📁 Project Structure

```
.
├── scripts/
│   ├── backup.sh              # Day 1: Automated backup script
│   ├── system_update.sh       # Day 2: System update and cleanup
│   ├── log_monitor.sh         # Day 3: Log monitoring with alerts
│   └── maintenance_suite.sh   # Day 4-5: Unified maintenance suite
├── logs/                      # Log files directory
├── backups/                   # Backup storage directory
├── test_files/               # Sample files for testing
└── README.md                 # This file
```

## 🚀 Features

### Day 1: Automated Backup Script (`backup.sh`)
- Creates timestamped backups of specified directories
- Compresses files using tar.gz format
- Generates backup manifests
- Provides detailed logging
- Color-coded console output

**Usage:**
```bash
./scripts/backup.sh [directory1] [directory2] ...
```

**Example:**
```bash
./scripts/backup.sh ./test_files ./logs
```

### Day 2: System Update & Cleanup (`system_update.sh`)
- Simulates or performs system package updates
- Cleans up old log files (30+ days)
- Removes temporary files
- Cleans package cache (requires root)
- Reports space freed

**Usage:**
```bash
./scripts/system_update.sh
```

**Note:** Run as root for actual system updates. Otherwise, it runs in simulation mode.

### Day 3: Log Monitoring (`log_monitor.sh`)
- Scans log files for errors, warnings, and critical issues
- Monitors system resources (disk, memory, load)
- Supports continuous monitoring mode
- Generates alerts for detected issues
- Color-coded severity levels

**Usage:**
```bash
# Single scan
./scripts/log_monitor.sh scan

# Continuous monitoring (60 seconds)
./scripts/log_monitor.sh monitor 60
```

### Day 4-5: Maintenance Suite (`maintenance_suite.sh`)
- **Interactive menu-driven interface**
- Executes all maintenance scripts from one place
- **Comprehensive error handling**
- **Detailed logging functionality**
- System status dashboard
- Run all tasks sequentially
- View consolidated logs

**Usage:**
```bash
./scripts/maintenance_suite.sh
```

**Menu Options:**
1. Automated Backup
2. System Update & Cleanup
3. Log Monitor (Scan)
4. Log Monitor (Continuous)
5. Run All Maintenance Tasks
6. View Logs
7. System Status
0. Exit

## 📋 Day 5 Enhancements

All scripts include:
- ✅ **Error Handling**: Comprehensive error trapping and recovery
- ✅ **Logging**: Detailed timestamped logs for all operations
- ✅ **Status Reporting**: Clear success/failure messages
- ✅ **Exit Codes**: Proper return codes for automation
- ✅ **Input Validation**: Checks for required files and permissions
- ✅ **Color-Coded Output**: Visual feedback for different message types

## 🎯 Assignment Completion

### ✅ Day 1: Automated Backups
- Timestamped backup directories
- Compressed archives (tar.gz)
- Backup manifests
- Multiple directory support

### ✅ Day 2: System Updates & Cleanup
- Package update capability
- Old file cleanup
- Temporary file removal
- Space usage reporting

### ✅ Day 3: Log Monitoring
- Pattern-based alert detection
- System resource monitoring
- Configurable alert conditions
- Continuous monitoring mode

### ✅ Day 4: Maintenance Suite
- Interactive menu system
- Unified script execution
- Task orchestration
- Log viewing capability

### ✅ Day 5: Error Handling & Logging
- Trap-based error handling
- Detailed log files
- Operation status tracking
- Comprehensive reporting

## 🛠️ Installation

1. Clone or download the project
2. Ensure scripts are executable:
```bash
chmod +x scripts/*.sh
```

3. Create necessary directories (auto-created on first run):
```bash
mkdir -p logs backups test_files
```

## 📊 Logging

All scripts log to the `./logs/` directory:
- `backup.log` - Backup operation logs
- `system_update.log` - Update and cleanup logs
- `maintenance.log` - Maintenance suite logs
- `alerts.log` - Log monitoring alerts

## 🔒 Permissions

- **Regular user**: All scripts work in simulation/safe mode
- **Root user**: Full system update and cleanup capabilities

## 📝 Configuration

Scripts use environment variables for configuration:

```bash
# Backup configuration
export BACKUP_DIR="./backups"
export LOG_FILE="./logs/backup.log"

# Run backup
./scripts/backup.sh
```

## 🧪 Testing

The maintenance suite includes test files in `./test_files/`:
- Sample text files for backup testing
- Subdirectory structure
- Auto-generated on first run

## 🎨 Color Coding

- 🔴 **Red**: Errors and critical issues
- 🟡 **Yellow**: Warnings and processing messages
- 🟢 **Green**: Success messages
- 🔵 **Blue**: Informational messages
- 🟣 **Magenta**: Section headers

## 📖 Examples

### Run a complete maintenance cycle:
```bash
./scripts/maintenance_suite.sh
# Select option 5: "Run All Maintenance Tasks"
```

### Backup specific directories:
```bash
./scripts/backup.sh /home/user/documents /etc
```

### Monitor logs for 5 minutes:
```bash
./scripts/log_monitor.sh monitor 300
```

## 🆘 Troubleshooting

**Scripts won't execute:**
```bash
chmod +x scripts/*.sh
```

**Permission denied during updates:**
```bash
sudo ./scripts/system_update.sh
```

**Logs not appearing:**
- Check that `./logs/` directory exists
- Verify write permissions

## 📄 License

This is an educational project created for learning Bash scripting and Linux system administration.

## 👨‍💻 Author

Created as part of Assignment 5 (LinuxOS and LSP) - Bash Scripting Suite for System Maintenance

---

**Note**: Always test scripts in a safe environment before using in production. Run with appropriate permissions and review logs regularly.
