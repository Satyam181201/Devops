# Week 1: Linux Basics - Complete Guide 🐧

## Table of Contents
1. [File System Navigation](#file-system-navigation)
2. [File Operations](#file-operations)
3. [File Permissions](#file-permissions)
4. [Text Processing](#text-processing)
5. [Package Management](#package-management)
6. [Process Management](#process-management)
7. [User Management](#user-management)
8. [AWS EC2 Setup & SSH](#aws-ec2-setup--ssh)
9. [Installing Java 17 & Running JAR Files](#installing-java-17--running-jar-files)

---

## File System Navigation

### Understanding Linux File System
Think of Linux like a giant upside-down tree. The **root** is at the top (represented by `/`), and everything branches down from there.

```
/                          (root - the very top)
├── home/                  (user home folders)
│   ├── john/
│   └── sarah/
├── etc/                   (configuration files)
├── var/                   (variable data like logs)
└── usr/                   (user programs)
```

### Key Commands

#### `pwd` - Print Working Directory
**What it does:** Shows where you are right now in the file system.

```bash
pwd
# Output: /home/ubuntu
```

**Real-world analogy:** Like asking "Where am I?" on a map.

---

#### `ls` - List Files
**What it does:** Shows files and folders in your current location.

```bash
# Basic listing
ls

# Detailed listing (shows permissions, owner, size, date)
ls -l

# Show hidden files (files starting with .)
ls -a

# Human-readable file sizes
ls -lh

# Combine options
ls -lah
```

**Example Output:**
```
drwxr-xr-x 2 ubuntu ubuntu 4096 Jan 10 10:30 Documents
-rw-r--r-- 1 ubuntu ubuntu  156 Jan 10 09:15 notes.txt
```

**Reading the output:**
- `d` = directory, `-` = file
- `rw-r--r--` = permissions
- `ubuntu ubuntu` = owner and group
- `4096` = size in bytes
- `Jan 10 10:30` = last modified date

---

#### `cd` - Change Directory
**What it does:** Move to a different folder.

```bash
# Go to a specific folder
cd /home/ubuntu/Documents

# Go up one level
cd ..

# Go to your home directory
cd ~
# or just
cd

# Go to previous directory
cd -

# Go to root directory
cd /
```

**Think of it like:** Walking through rooms in a house.

---

#### `find` - Search for Files
**What it does:** Searches for files and folders based on criteria.

```bash
# Find all .txt files in current directory
find . -name "*.txt"

# Find all files modified in last 7 days
find . -mtime -7

# Find all directories
find . -type d

# Find files larger than 100MB
find . -size +100M

# Find and delete all .log files
find . -name "*.log" -delete
```

**Real example:**
```bash
# Find your application.properties file anywhere
find / -name "application.properties" 2>/dev/null
```
*Note: `2>/dev/null` hides permission errors*

---

#### `locate` - Fast File Search
**What it does:** Quickly finds files using a pre-built database.

```bash
# Update the database first (run with sudo)
sudo updatedb

# Find files
locate notes.txt

# Case-insensitive search
locate -i NOTES.TXT
```

**Difference from find:**
- `locate` is faster but uses a database (may be outdated)
- `find` is slower but searches in real-time

---

## File Operations

### `touch` - Create Empty File
**What it does:** Creates a new empty file or updates timestamp.

```bash
# Create a new file
touch myfile.txt

# Create multiple files
touch file1.txt file2.txt file3.txt
```

---

### `mkdir` - Make Directory
**What it does:** Creates a new folder.

```bash
# Create a single folder
mkdir projects

# Create nested folders
mkdir -p projects/java/spring-boot

# Create multiple folders
mkdir docs videos music
```

**The `-p` flag:** Creates parent directories if they don't exist. Without it, you'd need to create each folder one by one.

---

### `cp` - Copy Files/Folders
**What it does:** Makes a copy of files or folders.

```bash
# Copy a file
cp source.txt destination.txt

# Copy to another directory
cp myfile.txt /home/ubuntu/backup/

# Copy a folder (recursive)
cp -r myfolder /backup/

# Copy multiple files to a directory
cp file1.txt file2.txt file3.txt /destination/

# Copy with verbose output (shows what's being copied)
cp -v source.txt dest.txt
```

**Common options:**
- `-r` = recursive (for folders)
- `-v` = verbose (show progress)
- `-i` = interactive (ask before overwriting)

---

### `mv` - Move or Rename
**What it does:** Moves files/folders to a new location OR renames them.

```bash
# Rename a file
mv oldname.txt newname.txt

# Move file to another directory
mv myfile.txt /home/ubuntu/Documents/

# Move and rename at the same time
mv oldfile.txt /home/ubuntu/newfile.txt

# Move multiple files
mv file1.txt file2.txt file3.txt /destination/

# Move a directory
mv oldfolder newfolder
```

---

### `rm` - Remove Files/Folders
**What it does:** Deletes files and folders. **⚠️ BE CAREFUL - NO UNDO!**

```bash
# Remove a file
rm myfile.txt

# Remove multiple files
rm file1.txt file2.txt

# Remove a directory (empty)
rmdir emptyfolder

# Remove directory with contents
rm -r myfolder

# Force remove without confirmation
rm -f myfile.txt

# Interactive mode (asks before each delete)
rm -i myfile.txt

# Remove with verbose output
rm -v myfile.txt
```

**⚠️ NEVER DO THIS:**
```bash
rm -rf /    # This deletes EVERYTHING!
```

---

### `cat` - View File Contents
**What it does:** Displays entire file content on screen.

```bash
# View a file
cat myfile.txt

# View multiple files
cat file1.txt file2.txt

# Combine files into a new file
cat file1.txt file2.txt > combined.txt

# Append to a file
cat newcontent.txt >> existing.txt

# Number the lines
cat -n myfile.txt
```

---

### `head` - View File Beginning
**What it does:** Shows the first few lines of a file (default: 10 lines).

```bash
# View first 10 lines
head myfile.txt

# View first 20 lines
head -n 20 myfile.txt

# View first 5 lines
head -5 myfile.txt
```

**Use case:** Quickly checking log files or configuration files.

---

### `tail` - View File End
**What it does:** Shows the last few lines of a file (default: 10 lines).

```bash
# View last 10 lines
tail myfile.txt

# View last 20 lines
tail -n 20 myfile.txt

# Follow file in real-time (perfect for logs!)
tail -f /var/log/application.log

# Follow with line numbers
tail -f -n 100 /var/log/syslog
```

**Real-world use:** Monitoring live application logs!

---

## File Permissions

### Understanding Permissions
Every file and folder has permissions for three groups:
1. **Owner** (u) - The person who created it
2. **Group** (g) - Users in the same group
3. **Others** (o) - Everyone else

Each group can have three types of permissions:
- **r** (read) = 4 = Can view the file
- **w** (write) = 2 = Can modify the file
- **x** (execute) = 1 = Can run the file (if it's a program)

### Reading Permissions

```bash
ls -l myfile.txt
# Output: -rw-r--r-- 1 ubuntu ubuntu 1024 Jan 10 10:30 myfile.txt
```

**Breaking it down:**
```
-rw-r--r--
│││ │ │ │
│││ │ │ └── Others: r-- (read only)
│││ │ └──── Group: r-- (read only)
│││ └────── Owner: rw- (read + write)
││└──────── Special flags
│└───────── File type (- = file, d = directory)
```

---

### `chmod` - Change Permissions
**What it does:** Changes who can read, write, or execute a file.

#### **Method 1: Symbolic Mode (Easy to Remember)**

```bash
# Give owner execute permission
chmod u+x script.sh

# Remove write permission from group
chmod g-w myfile.txt

# Give everyone read permission
chmod a+r document.txt

# Multiple changes at once
chmod u+x,g-w,o-r myfile.txt
```

**Letters:**
- `u` = owner (user)
- `g` = group
- `o` = others
- `a` = all (everyone)

**Operations:**
- `+` = add permission
- `-` = remove permission
- `=` = set exact permission

#### **Method 2: Numeric Mode (Common in DevOps)**

```bash
# Make file readable and writable by owner only
chmod 600 myfile.txt

# Make script executable by everyone
chmod 755 script.sh

# Make file read-only for everyone
chmod 444 document.txt
```

**Common Permission Numbers:**
- `755` = Owner: rwx, Group: r-x, Others: r-x (common for scripts)
- `644` = Owner: rw-, Group: r--, Others: r-- (common for files)
- `600` = Owner: rw-, Group: ---, Others: --- (private files)
- `777` = Everyone: rwx (⚠️ dangerous! avoid this!)

**How to calculate:**
```
rwx = 4 + 2 + 1 = 7
rw- = 4 + 2 + 0 = 6
r-x = 4 + 0 + 1 = 5
r-- = 4 + 0 + 0 = 4
```

---

### `chown` - Change Owner
**What it does:** Changes who owns a file or folder.

```bash
# Change owner
sudo chown ubuntu myfile.txt

# Change owner and group
sudo chown ubuntu:developers myfile.txt

# Change owner of directory and all contents
sudo chown -R ubuntu:ubuntu /var/www/myapp

# Change only the group
sudo chown :developers myfile.txt
```

**Note:** Usually requires `sudo` (superuser privileges).

---

### `umask` - Default Permissions
**What it does:** Sets default permissions for newly created files.

```bash
# Check current umask
umask
# Output: 0022

# Set umask (files: 644, folders: 755)
umask 0022

# More restrictive (files: 600, folders: 700)
umask 0077
```

**How it works:**
- Default file: 666 (rw-rw-rw-)
- umask: 022
- Result: 644 (rw-r--r--)

---

## Text Processing

### `grep` - Search Text
**What it does:** Searches for text patterns in files. Think "Ctrl+F" for the command line.

```bash
# Search for word in a file
grep "error" application.log

# Case-insensitive search
grep -i "error" application.log

# Search in multiple files
grep "TODO" *.java

# Show line numbers
grep -n "error" app.log

# Show lines that DON'T contain pattern
grep -v "debug" app.log

# Search recursively in directories
grep -r "password" /etc/

# Count matching lines
grep -c "error" app.log

# Show 3 lines before and after match
grep -C 3 "Exception" app.log
```

**Real-world example:**
```bash
# Find all ERROR logs from today
grep "ERROR" /var/log/app.log | grep "2024-01-10"
```

---

### `sed` - Stream Editor
**What it does:** Edits text in files without opening them. Great for find-and-replace.

```bash
# Replace first occurrence in each line
sed 's/old/new/' file.txt

# Replace ALL occurrences
sed 's/old/new/g' file.txt

# Save changes to file
sed -i 's/old/new/g' file.txt

# Delete lines containing pattern
sed '/pattern/d' file.txt

# Print only lines 10-20
sed -n '10,20p' file.txt

# Replace only on line 5
sed '5s/old/new/' file.txt
```

**Real-world example:**
```bash
# Change port in config file
sed -i 's/port=8080/port=9090/g' application.properties

# Remove all empty lines
sed '/^$/d' file.txt
```

---

### `awk` - Text Processing Powerhouse
**What it does:** Processes text column by column. Great for structured data.

```bash
# Print first column
awk '{print $1}' file.txt

# Print multiple columns
awk '{print $1, $3}' file.txt

# Print lines longer than 80 characters
awk 'length($0) > 80' file.txt

# Sum numbers in column 3
awk '{sum+=$3} END {print sum}' file.txt

# Print with custom separator
awk -F',' '{print $1, $2}' data.csv

# Print lines where column 3 > 100
awk '$3 > 100' file.txt
```

**Real-world example:**
```bash
# Show only process names and CPU usage
ps aux | awk '{print $11, $3}'

# Find total disk usage
df -h | awk '{sum+=$3} END {print sum}'
```

---

### `cut` - Extract Columns
**What it does:** Cuts out specific columns from text.

```bash
# Get first column (space-delimited)
cut -d' ' -f1 file.txt

# Get columns 1 and 3 (comma-delimited)
cut -d',' -f1,3 data.csv

# Get characters 1-10 from each line
cut -c1-10 file.txt

# Extract usernames from /etc/passwd
cut -d':' -f1 /etc/passwd
```

---

### `sort` - Sort Lines
**What it does:** Sorts lines alphabetically or numerically.

```bash
# Sort alphabetically
sort file.txt

# Sort numerically
sort -n numbers.txt

# Reverse sort
sort -r file.txt

# Sort by column 2 (space-delimited)
sort -k2 file.txt

# Sort and remove duplicates
sort -u file.txt

# Sort by file size
ls -l | sort -k5 -n
```

---

### `uniq` - Remove Duplicates
**What it does:** Removes duplicate consecutive lines. **Must be sorted first!**

```bash
# Remove duplicates
sort file.txt | uniq

# Count occurrences
sort file.txt | uniq -c

# Show only duplicates
sort file.txt | uniq -d

# Show only unique lines (no duplicates)
sort file.txt | uniq -u
```

**Real-world example:**
```bash
# Find most common errors in log
grep "ERROR" app.log | sort | uniq -c | sort -rn | head -10
```

---

## Package Management

Linux uses **package managers** to install software. Think of it like an app store for your server.

### APT (Debian/Ubuntu)

```bash
# Update package list
sudo apt update

# Upgrade installed packages
sudo apt upgrade

# Install a package
sudo apt install nginx

# Install multiple packages
sudo apt install git curl vim

# Remove a package
sudo apt remove nginx

# Remove package and its config files
sudo apt purge nginx

# Remove unused dependencies
sudo apt autoremove

# Search for packages
apt search java

# Show package information
apt show openjdk-17-jdk

# List installed packages
apt list --installed
```

**Real workflow:**
```bash
# Always update first, then install
sudo apt update
sudo apt install postgresql
```

---

### YUM (RedHat/CentOS/Amazon Linux)

```bash
# Update package list
sudo yum update

# Install a package
sudo yum install nginx

# Remove a package
sudo yum remove nginx

# Search packages
yum search java

# Show package info
yum info java-17-openjdk

# List installed packages
yum list installed

# Clean cache
sudo yum clean all
```

---

## Process Management

### Understanding Processes
A **process** is a running program. Every program you run creates a process.

### `ps` - View Processes
**What it does:** Shows currently running processes.

```bash
# Show your processes
ps

# Show all processes (detailed)
ps aux

# Show processes in tree format
ps auxf

# Show processes for specific user
ps -u ubuntu

# Find specific process
ps aux | grep java
```

**Understanding ps aux output:**
```
USER  PID  %CPU %MEM    VSZ   RSS TTY  STAT START TIME COMMAND
ubuntu 1234  2.5  1.2 234567 45678  ?   Ssl  10:30 0:05 java -jar app.jar
```

- **PID** = Process ID (unique number)
- **%CPU** = CPU usage
- **%MEM** = Memory usage
- **STAT** = State (R=running, S=sleeping, Z=zombie)

---

### `top` - Live Process Monitor
**What it does:** Shows real-time process information (like Task Manager on Windows).

```bash
# Start top
top

# Exit: press 'q'
# Kill process: press 'k', enter PID
# Sort by memory: press 'M'
# Sort by CPU: press 'P'
```

**Better alternative:** Use `htop` (more user-friendly)
```bash
sudo apt install htop
htop
```

---

### `kill` - Stop Processes
**What it does:** Terminates (stops) a running process.

```bash
# Gracefully stop process (gives it time to cleanup)
kill 1234

# Force kill (immediate termination)
kill -9 1234

# Kill by process name
pkill firefox

# Kill all processes matching name
killall java

# Kill with specific signal
kill -SIGTERM 1234
```

**Common signals:**
- `15` (SIGTERM) = Graceful shutdown (default)
- `9` (SIGKILL) = Force kill (immediate)
- `1` (SIGHUP) = Reload configuration

**Real-world example:**
```bash
# Find and kill a Java application
ps aux | grep java
kill 12345
```

---

### `systemctl` - Manage Services
**What it does:** Controls system services (programs that run in the background).

```bash
# Start a service
sudo systemctl start nginx

# Stop a service
sudo systemctl stop nginx

# Restart a service
sudo systemctl restart nginx

# Reload configuration without restart
sudo systemctl reload nginx

# Enable service to start on boot
sudo systemctl enable nginx

# Disable service from starting on boot
sudo systemctl disable nginx

# Check service status
sudo systemctl status nginx

# View all running services
systemctl list-units --type=service

# View failed services
systemctl --failed
```

**Real-world example:**
```bash
# Install, start, and enable Nginx
sudo apt install nginx
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx
```

---

## User Management

### Understanding Users and Groups
- Every file and process belongs to a user
- Users can belong to multiple groups
- Groups make permission management easier

### `useradd` / `adduser` - Create Users

```bash
# Create a new user (basic)
sudo useradd john

# Create user with home directory
sudo useradd -m john

# Create user with specific shell
sudo useradd -m -s /bin/bash john

# Create user with expiry date
sudo useradd -e 2024-12-31 john

# Better alternative (more interactive)
sudo adduser john
```

**Difference:**
- `useradd` = Low-level, requires more options
- `adduser` = User-friendly, asks questions

---

### `passwd` - Set/Change Password

```bash
# Set password for new user
sudo passwd john

# Change your own password
passwd

# Force user to change password on next login
sudo passwd -e john

# Lock a user account
sudo passwd -l john

# Unlock a user account
sudo passwd -u john
```

---

### `usermod` - Modify User

```bash
# Add user to a group
sudo usermod -aG docker ubuntu

# Change user's home directory
sudo usermod -d /new/home john

# Change user's shell
sudo usermod -s /bin/zsh john

# Change username
sudo usermod -l newname oldname

# Lock user account
sudo usermod -L john
```

**Important:** `-aG` adds to group without removing from others. Without `-a`, it replaces all groups!

---

### `userdel` - Delete User

```bash
# Delete user (keep home directory)
sudo userdel john

# Delete user and home directory
sudo userdel -r john
```

---

### `groups` - View Groups

```bash
# Show your groups
groups

# Show groups for specific user
groups john

# Show all groups on system
cat /etc/group
```

---

### `groupadd` - Create Group

```bash
# Create a new group
sudo groupadd developers

# Create group with specific GID
sudo groupadd -g 1500 developers
```

---

### `groupdel` - Delete Group

```bash
sudo groupdel developers
```

---

### `su` and `sudo` - Switch User / Run as Root

```bash
# Switch to another user
su john

# Switch to root
su -

# Run single command as root
sudo apt update

# Run command as specific user
sudo -u john whoami

# Open root shell
sudo -i

# Run previous command with sudo
sudo !!
```

**Important difference:**
- `su` = Switch user (need their password)
- `sudo` = Run as superuser (need YOUR password)

---

## AWS EC2 Setup & SSH

### Step 1: Launch EC2 Instance

1. **Log into AWS Console**
   - Go to https://aws.amazon.com
   - Sign in to console

2. **Navigate to EC2**
   - Search for "EC2" in services
   - Click "Launch Instance"

3. **Configure Instance**
   - **Name:** `my-devops-server`
   - **OS:** Ubuntu Server 22.04 LTS (Free tier eligible)
   - **Instance Type:** t2.micro (Free tier)
   - **Key Pair:** Create new key pair
     - Name: `my-ec2-key`
     - Type: RSA
     - Format: `.pem` (for Git Bash) or `.ppk` (for PuTTY)
     - **Download and save this file!** You can't download it again!

4. **Network Settings**
   - Allow SSH (port 22) from your IP
   - Allow HTTP (port 80) if testing web servers

5. **Storage**
   - 8 GB (default, free tier)

6. **Launch Instance**
   - Wait 2-3 minutes for it to start

---

### Step 2: Connect with SSH (Git Bash on Windows)

#### **Prepare Your Key File**

```bash
# Open Git Bash
cd ~/Downloads

# Move key to .ssh folder
mkdir -p ~/.ssh
mv my-ec2-key.pem ~/.ssh/

# Set correct permissions (very important!)
chmod 400 ~/.ssh/my-ec2-key.pem
```

#### **Get Your Instance IP**
- Go to EC2 console
- Select your instance
- Copy "Public IPv4 address" (e.g., 3.25.123.45)

#### **Connect**

```bash
# SSH into your server
ssh -i ~/.ssh/my-ec2-key.pem ubuntu@3.25.123.45
```

**First time:** You'll see a message asking to verify fingerprint. Type `yes`.

**Success!** You should see:
```
Welcome to Ubuntu 22.04 LTS
ubuntu@ip-172-31-45-67:~$
```

---

### Step 3: Connect with PuTTY (Alternative for Windows)

1. **Convert .pem to .ppk**
   - Open PuTTYgen
   - Load your `.pem` file
   - Click "Save private key"
   - Save as `my-ec2-key.ppk`

2. **Configure PuTTY**
   - **Host Name:** `ubuntu@3.25.123.45`
   - **Connection > SSH > Auth:** Browse and select your `.ppk` file
   - **Session:** Save as "My EC2 Server"
   - Click "Open"

---

### Step 4: First Steps on Your Server

```bash
# Update system
sudo apt update
sudo apt upgrade -y

# Check system info
uname -a
cat /etc/os-release

# Check disk space
df -h

# Check memory
free -h

# Check CPU info
lscpu
```

---

### Troubleshooting SSH Issues

**Problem:** "Permission denied (publickey)"
```bash
# Fix key permissions
chmod 400 ~/.ssh/my-ec2-key.pem
```

**Problem:** "Connection timed out"
- Check Security Group allows SSH (port 22) from your IP
- Check your instance is running

**Problem:** "Host key verification failed"
```bash
# Remove old key
ssh-keygen -R 3.25.123.45
# Try connecting again
```

---

## Installing Java 17 & Running JAR Files

### Install Java 17 on Ubuntu

```bash
# Update package list
sudo apt update

# Install Java 17 (OpenJDK)
sudo apt install openjdk-17-jdk -y

# Verify installation
java -version
# Should show: openjdk version "17.0.x"

# Check javac (compiler)
javac -version

# Find Java installation path
which java
# Output: /usr/bin/java

# Get full path
readlink -f $(which java)
# Output: /usr/lib/jvm/java-17-openjdk-amd64/bin/java
```

---

### Set JAVA_HOME (Important for many applications)

```bash
# Edit .bashrc
nano ~/.bashrc

# Add these lines at the end:
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# Save: Ctrl+O, Enter, Ctrl+X

# Reload configuration
source ~/.bashrc

# Verify
echo $JAVA_HOME
# Should show: /usr/lib/jvm/java-17-openjdk-amd64
```

---

### Transfer JAR File to EC2

#### **Method 1: Using SCP (From your Windows machine)**

```bash
# Open Git Bash on Windows
cd /path/to/your/jarfile

# Copy to EC2
scp -i ~/.ssh/my-ec2-key.pem myapp.jar ubuntu@3.25.123.45:~/
```

#### **Method 2: Download from URL**

```bash
# SSH into EC2 first
ssh -i ~/.ssh/my-ec2-key.pem ubuntu@3.25.123.45

# Download JAR file
wget https://example.com/myapp.jar
# or
curl -O https://example.com/myapp.jar
```

---

### Run JAR File

```bash
# Simple run
java -jar myapp.jar

# Run with memory settings
java -Xms512m -Xmx1024m -jar myapp.jar

# Run in background
nohup java -jar myapp.jar > app.log 2>&1 &

# Check if running
ps aux | grep java

# View logs
tail -f app.log

# Stop application
ps aux | grep java
kill <PID>
```

---

### Create a Systemd Service (Professional Way)

This makes your Java app start automatically and run as a proper service.

```bash
# Create service file
sudo nano /etc/systemd/system/myapp.service
```

**Add this content:**
```ini
[Unit]
Description=My Java Application
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu
ExecStart=/usr/bin/java -jar /home/ubuntu/myapp.jar
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

**Save and enable:**
```bash
# Reload systemd
sudo systemctl daemon-reload

# Start service
sudo systemctl start myapp

# Enable on boot
sudo systemctl enable myapp

# Check status
sudo systemctl status myapp

# View logs
sudo journalctl -u myapp -f
```

---

## Week 1 Checklist ✅

By the end of Week 1, you should be able to:

- [ ] Navigate Linux file system with `cd`, `ls`, `pwd`
- [ ] Create, copy, move, and delete files
- [ ] Understand and change file permissions
- [ ] Search text with `grep` and process with `awk`, `sed`
- [ ] Install packages with `apt`
- [ ] View and manage processes
- [ ] Create and manage users
- [ ] Launch an AWS EC2 instance
- [ ] SSH into your EC2 from Windows
- [ ] Install Java 17 on Ubuntu
- [ ] Transfer and run a JAR file
- [ ] Keep the application running in background

---

## Quick Reference Cheat Sheet

### Navigation
```bash
pwd                    # Where am I?
ls -lah                # Show all files with details
cd /path/to/folder     # Go to folder
cd ..                  # Go up one level
cd ~                   # Go home
```

### File Operations
```bash
touch file.txt         # Create file
mkdir folder           # Create folder
cp source dest         # Copy
mv old new             # Move/rename
rm file                # Delete file
rm -r folder           # Delete folder
cat file.txt           # View file
head -20 file.txt      # First 20 lines
tail -f app.log        # Follow log file
```

### Permissions
```bash
chmod 755 script.sh    # rwxr-xr-x
chmod 644 file.txt     # rw-r--r--
chmod u+x script.sh    # Add execute for owner
chown user:group file  # Change owner
```

### Searching
```bash
find . -name "*.txt"          # Find files
grep "error" file.txt         # Search in file
grep -r "TODO" .              # Search in all files
```

### Processes
```bash
ps aux                 # Show all processes
ps aux | grep java     # Find Java processes
kill 1234              # Stop process 1234
kill -9 1234           # Force kill
top                    # Process monitor
systemctl status nginx # Check service
```

### Users
```bash
sudo useradd -m john   # Create user
sudo passwd john       # Set password
sudo usermod -aG group john  # Add to group
groups                 # Show my groups
```

### Package Management
```bash
sudo apt update        # Update list
sudo apt install nginx # Install package
sudo apt remove nginx  # Remove package
```

### SSH
```bash
ssh -i key.pem ubuntu@IP  # Connect to server
scp -i key.pem file ubuntu@IP:~/  # Copy file to server
```

---

## Tips for Success

1. **Practice Daily:** Spend 30 minutes each day on your EC2 instance
2. **Don't Memorize:** Understand concepts, commands will come naturally
3. **Use `man` Pages:** Type `man ls` to read the manual for any command
4. **Use Tab Completion:** Press Tab to auto-complete file/folder names
5. **Use Arrow Keys:** Press Up to recall previous commands
6. **Keep Notes:** Document commands that you use frequently
7. **Break Things:** You can't break the cloud instance permanently; practice freely!
8. **Use `--help`:** Most commands have a help flag: `ls --help`

---

## Next Steps (Week 2 Preview)

Once you're comfortable with Week 1:
- Git and version control
- Basic shell scripting
- Environment variables
- Cron jobs for scheduling
- Web servers (Nginx, Apache)
- Docker basics

---

## Additional Resources

- **Interactive Practice:** https://linuxjourney.com
- **Command Reference:** https://ss64.com/bash/
- **AWS Free Tier:** https://aws.amazon.com/free/
- **Ubuntu Documentation:** https://help.ubuntu.com/

---

**Remember:** Linux is about practice and repetition. Every DevOps engineer started exactly where you are now. Keep practicing, and it will become second nature! 🚀

**Questions?** Try the command first, then check `man <command>` or `<command> --help`!
