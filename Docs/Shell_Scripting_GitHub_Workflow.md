# Shell Scripting & GitHub Workflow Guide 🐚

## Overview
This guide will help you:
1. Create and organize shell scripts in Ubuntu (WSL)
2. Store them in the `ubuntu-data` folder
3. Push them to GitHub from Windows or WSL

---

## Part 1: Setting Up Your Shell Script Directory

### Step 1: Access Your ubuntu-data Folder from WSL

When you're in WSL (Ubuntu), your Windows drives are mounted under `/mnt/`

```bash
# Navigate to your ubuntu-data folder
cd /mnt/d/Satyam/Devops/ubuntu-data

# Verify you're in the right place
pwd
# Output: /mnt/d/Satyam/Devops/ubuntu-data

# List contents
ls -la
```

### Step 2: Create a Proper Structure

```bash
# Create a shell-scripts directory
mkdir -p shell-scripts

# Create subdirectories for organization
mkdir -p shell-scripts/basics
mkdir -p shell-scripts/automation
mkdir -p shell-scripts/backup
mkdir -p shell-scripts/monitoring

# Navigate to the folder
cd shell-scripts
```

---

## Part 2: Creating Shell Scripts

### Basic Template for Every Script

```bash
#!/bin/bash
#
# Script Name: script-name.sh
# Description: What this script does
# Author: Your Name
# Date: 2024-01-10
# Usage: ./script-name.sh [arguments]
#

# Your code here
echo "Hello, World!"
```

### Creating Your First Script

```bash
# Create a new script
nano hello-world.sh

# Or use vim
vim hello-world.sh
```

**Add this content:**
```bash
#!/bin/bash
#
# Script: hello-world.sh
# Description: My first shell script
# Author: Satyam
# Date: 2024-01-10
#

echo "======================================"
echo "  Welcome to Shell Scripting!"
echo "======================================"
echo ""
echo "Current Date: $(date)"
echo "Current User: $(whoami)"
echo "Current Directory: $(pwd)"
echo ""
echo "System Info:"
uname -a
echo ""
echo "======================================"
```

### Make It Executable

```bash
# Add execute permission
chmod +x hello-world.sh

# Run the script
./hello-world.sh
```

---

## Part 3: Initialize Git Repository

### Option A: Initialize from WSL (Ubuntu)

```bash
# Make sure you're in ubuntu-data folder
cd /mnt/d/Satyam/Devops/ubuntu-data

# Initialize git repository
git init

# Configure git (if not done already)
git config user.name "Your Name"
git config user.email "your.email@example.com"

# Create a README file
cat > README.md << 'EOF'
# Shell Scripting Practice 🐚

This repository contains my shell scripting practice files and automation scripts.

## Structure
- `shell-scripts/basics/` - Basic shell scripting examples
- `shell-scripts/automation/` - Automation scripts
- `shell-scripts/backup/` - Backup scripts
- `shell-scripts/monitoring/` - System monitoring scripts

## Usage
All scripts are executable. Run with:
```bash
./script-name.sh
```

## Author
Satyam - DevOps Learning Journey
EOF

# Create .gitignore file
cat > .gitignore << 'EOF'
# Temporary files
*.tmp
*.log
*.swp
*~

# OS specific
.DS_Store
Thumbs.db

# Backup files
*.bak
*.backup
EOF

# Add files to git
git add .

# Create first commit
git commit -m "Initial commit: Shell scripting repository setup"
```

### Option B: Initialize from Windows PowerShell

```powershell
# Open PowerShell and navigate to folder
cd D:\Satyam\Devops\ubuntu-data

# Initialize git
git init

# Configure git (if needed)
git config user.name "Your Name"
git config user.email "your.email@example.com"

# Add files and commit
git add .
git commit -m "Initial commit: Shell scripting repository setup"
```

---

## Part 4: Create GitHub Repository

### Step 1: Create Repository on GitHub

1. Go to https://github.com
2. Click the **+** icon → **New repository**
3. Repository name: `shell-scripting-practice`
4. Description: `My shell scripting learning journey`
5. Choose **Public** or **Private**
6. **DO NOT** initialize with README (we already have one)
7. Click **Create repository**

### Step 2: Link Local Repository to GitHub

GitHub will show you commands. Use these:

```bash
# Add remote repository (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/shell-scripting-practice.git

# Verify remote
git remote -v

# Push to GitHub (first time)
git branch -M main
git push -u origin main
```

**If you need authentication:**

```bash
# Use GitHub Personal Access Token (recommended)
# Go to: GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
# Generate new token with 'repo' scope
# Use token as password when pushing
```

---

## Part 5: Daily Workflow

### When You Create New Scripts

```bash
# 1. Navigate to your folder
cd /mnt/d/Satyam/Devops/ubuntu-data/shell-scripts

# 2. Create your script
nano my-new-script.sh

# 3. Make it executable
chmod +x my-new-script.sh

# 4. Test it
./my-new-script.sh

# 5. Add to git
git add my-new-script.sh

# 6. Commit with meaningful message
git commit -m "Add script to check disk usage"

# 7. Push to GitHub
git push
```

### Best Commit Message Practices

```bash
# Good commit messages
git commit -m "Add backup script for MySQL database"
git commit -m "Fix bug in user creation script"
git commit -m "Update monitoring script to check CPU usage"
git commit -m "Add comments to file permission script"

# Bad commit messages (avoid these)
git commit -m "update"
git commit -m "fix"
git commit -m "changes"
```

---

## Part 6: Common Shell Script Examples

### Example 1: System Information Script

```bash
#!/bin/bash
# system-info.sh - Display system information

echo "=== System Information ==="
echo "Hostname: $(hostname)"
echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime -p)"
echo ""
echo "=== CPU Information ==="
echo "CPU: $(lscpu | grep 'Model name' | cut -d':' -f2 | xargs)"
echo "Cores: $(nproc)"
echo ""
echo "=== Memory Information ==="
free -h
echo ""
echo "=== Disk Information ==="
df -h /
```

### Example 2: File Backup Script

```bash
#!/bin/bash
# backup.sh - Backup important files

# Configuration
SOURCE_DIR="$HOME/documents"
BACKUP_DIR="$HOME/backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="backup_$DATE.tar.gz"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Create backup
echo "Creating backup of $SOURCE_DIR..."
tar -czf "$BACKUP_DIR/$BACKUP_NAME" "$SOURCE_DIR"

if [ $? -eq 0 ]; then
    echo "Backup successful: $BACKUP_DIR/$BACKUP_NAME"
    echo "Backup size: $(du -h $BACKUP_DIR/$BACKUP_NAME | cut -f1)"
else
    echo "Backup failed!"
    exit 1
fi

# Keep only last 5 backups
cd "$BACKUP_DIR"
ls -t backup_*.tar.gz | tail -n +6 | xargs -r rm
echo "Cleaned up old backups. Keeping last 5."
```

### Example 3: User Input Script

```bash
#!/bin/bash
# user-input.sh - Interactive script example

echo "=== User Information Collector ==="
echo ""

# Get user input
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your favorite programming language: " language

echo ""
echo "=== Summary ==="
echo "Name: $name"
echo "Age: $age"
echo "Favorite Language: $language"
echo ""

# Conditional logic
if [ "$age" -ge 18 ]; then
    echo "You are an adult!"
else
    echo "You are a minor!"
fi
```

### Example 4: Service Check Script

```bash
#!/bin/bash
# check-service.sh - Check if a service is running

SERVICE_NAME=$1

if [ -z "$SERVICE_NAME" ]; then
    echo "Usage: $0 <service-name>"
    echo "Example: $0 nginx"
    exit 1
fi

# Check if service exists
if systemctl list-units --full --all | grep -Fq "$SERVICE_NAME"; then
    # Check if service is active
    if systemctl is-active --quiet "$SERVICE_NAME"; then
        echo "✓ $SERVICE_NAME is running"
        systemctl status "$SERVICE_NAME" --no-pager
    else
        echo "✗ $SERVICE_NAME is not running"
        read -p "Do you want to start it? (y/n): " answer
        if [ "$answer" = "y" ]; then
            sudo systemctl start "$SERVICE_NAME"
            echo "Started $SERVICE_NAME"
        fi
    fi
else
    echo "Service $SERVICE_NAME not found"
fi
```

### Example 5: Directory Cleanup Script

```bash
#!/bin/bash
# cleanup.sh - Clean up old files

TARGET_DIR="$HOME/downloads"
DAYS_OLD=30

echo "Finding files older than $DAYS_OLD days in $TARGET_DIR..."

# Find and list old files
FILES=$(find "$TARGET_DIR" -type f -mtime +$DAYS_OLD)

if [ -z "$FILES" ]; then
    echo "No old files found!"
    exit 0
fi

echo "Files to be deleted:"
echo "$FILES"
echo ""

# Count files
COUNT=$(echo "$FILES" | wc -l)
echo "Total: $COUNT files"

# Ask for confirmation
read -p "Delete these files? (y/n): " confirm

if [ "$confirm" = "y" ]; then
    find "$TARGET_DIR" -type f -mtime +$DAYS_OLD -delete
    echo "Files deleted successfully!"
else
    echo "Cleanup cancelled."
fi
```

---

## Part 7: Quick Command Reference

### Working in WSL

```bash
# Access Windows files from Ubuntu
cd /mnt/d/Satyam/Devops/ubuntu-data

# Copy script from Windows to WSL
cp /mnt/c/Users/Dell/Desktop/script.sh .

# Open Windows Explorer from WSL
explorer.exe .

# Run Windows commands from WSL
powershell.exe "Get-Date"
```

### Git Commands Quick Reference

```bash
# Check status
git status

# Add specific file
git add script.sh

# Add all changes
git add .

# Commit
git commit -m "Your message"

# Push to GitHub
git push

# Pull latest changes
git pull

# View commit history
git log --oneline

# Create a new branch
git checkout -b new-feature

# Switch branches
git checkout main

# View differences
git diff
```

### Script Debugging

```bash
# Run script with debug mode
bash -x script.sh

# Check syntax without running
bash -n script.sh

# Add debug statements in your script
set -x  # Enable debug
set +x  # Disable debug
```

---

## Part 8: Folder Structure Recommendation

```
ubuntu-data/
├── README.md
├── .gitignore
└── shell-scripts/
    ├── basics/
    │   ├── hello-world.sh
    │   ├── variables.sh
    │   ├── loops.sh
    │   └── conditionals.sh
    ├── automation/
    │   ├── backup.sh
    │   ├── cleanup.sh
    │   └── deploy.sh
    ├── monitoring/
    │   ├── system-info.sh
    │   ├── check-service.sh
    │   └── disk-alert.sh
    └── practice/
        ├── exercise1.sh
        ├── exercise2.sh
        └── exercise3.sh
```

---

## Part 9: GitHub Best Practices

### 1. Write Good README Files

Every script folder should have a README explaining:
- What the scripts do
- How to use them
- Any prerequisites
- Example usage

### 2. Add Comments in Scripts

```bash
# Good practice
#!/bin/bash
# Purpose: Backup MySQL database
# Author: Satyam
# Date: 2024-01-10
# Usage: ./backup-mysql.sh [database_name]

# Bad practice (no comments)
#!/bin/bash
mysql -u root -p$PASS $DB > backup.sql
```

### 3. Use Meaningful File Names

```bash
# Good names
backup-mysql-database.sh
check-nginx-status.sh
cleanup-old-logs.sh

# Bad names
script1.sh
test.sh
new.sh
```

### 4. Version Your Scripts

Consider adding version info:
```bash
#!/bin/bash
# Version: 1.0.0
# Last Modified: 2024-01-10
```

---

## Part 10: Troubleshooting

### Problem: Permission Denied

```bash
# Solution: Make script executable
chmod +x script.sh
```

### Problem: Bad Interpreter

```bash
# Make sure first line is correct
#!/bin/bash

# NOT this:
#!bin/bash
```

### Problem: Script Not Found

```bash
# Use ./ to run scripts in current directory
./script.sh

# NOT just
script.sh
```

### Problem: Git Push Authentication Failed

```bash
# Use Personal Access Token instead of password
# Generate at: GitHub → Settings → Developer settings → Personal access tokens

# Or use SSH keys (better for frequent use)
ssh-keygen -t ed25519 -C "your_email@example.com"
# Add the public key to GitHub: Settings → SSH and GPG keys
```

---

## Quick Start Checklist ✅

- [ ] Navigate to `/mnt/d/Satyam/Devops/ubuntu-data` in WSL
- [ ] Create `shell-scripts` directory
- [ ] Initialize git repository
- [ ] Create your first script
- [ ] Make it executable with `chmod +x`
- [ ] Test the script
- [ ] Create GitHub repository
- [ ] Add remote origin
- [ ] Commit and push to GitHub
- [ ] Celebrate! 🎉

---

## Pro Tips 💡

1. **Always test scripts** before committing
2. **Use meaningful commit messages** - your future self will thank you
3. **Commit often** - small, frequent commits are better than large ones
4. **Add error handling** - check if commands succeed
5. **Use variables** for repeated values
6. **Comment your code** - explain the "why", not just the "what"
7. **Keep scripts simple** - one script, one purpose
8. **Backup important scripts** - push to GitHub regularly

---

## Next Steps

Once comfortable with basics:
1. Learn about shell script functions
2. Explore advanced bash features
3. Practice error handling
4. Learn to schedule scripts with cron
5. Integrate scripts with CI/CD pipelines

---

## Useful Resources

- **Shell Scripting Tutorial:** https://www.shellscript.sh/
- **Bash Guide:** https://mywiki.wooledge.org/BashGuide
- **GitHub Docs:** https://docs.github.com/
- **Git Cheat Sheet:** https://education.github.com/git-cheat-sheet-education.pdf

---

**Happy Scripting! 🚀**
