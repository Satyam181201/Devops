# Git & GitHub Complete Beginner's Guide 🚀

## What You'll Learn
1. Initialize Git in your local folder
2. Create commits and track changes
3. Connect to GitHub
4. Push your code to GitHub
5. Daily workflow for managing code

---

## Part 1: Setup Git in Your Folder 📁

### Your Folder:
```
D:\Satyam\Devops\Git
```

### Step 1: Check if Git is Installed

```bash
# Open Git Bash or WSL Ubuntu
git --version

# Should show something like: git version 2.x.x
```

**If not installed:**

**Windows (Git Bash):**
- Download from: https://git-scm.com/download/win
- Install with default settings

**WSL Ubuntu:**
```bash
sudo apt-get update
sudo apt-get install git -y
```

---

## Part 2: Configure Git (One-Time Setup) ⚙️

```bash
# Set your name (will appear in commits)
git config --global user.name "Your Name"

# Set your email (use the same email as your GitHub account)
git config --global user.email "your.email@example.com"

# Check configuration
git config --list

# View specific settings
git config user.name
git config user.email
```

**Example:**
```bash
git config --global user.name "Satyam"
git config --global user.email "satyam@example.com"
```

---

## Part 3: Initialize Git in Your Folder 🎯

### Navigate to Your Git Folder

**Git Bash (Windows):**
```bash
cd "D:/Satyam/Devops/Git"
```

**WSL Ubuntu:**
```bash
cd /mnt/d/Satyam/Devops/Git
```

### Initialize Git Repository

```bash
# Initialize (creates .git folder)
git init

# You'll see: Initialized empty Git repository in D:/Satyam/Devops/Git/.git/

# Check status
git status
```

---

## Part 4: Create Your First Files 📝

```bash
# Create a README file
echo "# Git Learning Repository" > README.md
echo "This is where I practice Git commands" >> README.md

# Create a practice file
echo "Git is awesome!" > notes.txt

# Create a folder with file
mkdir examples
echo "Example content" > examples/example1.txt

# List what you created
ls -la
```

---

## Part 5: Basic Git Workflow 🔄

### The Git Three-Stage Process

```
Working Directory  →  Staging Area  →  Repository
    (edit)         →    (git add)    →  (git commit)
```

### Stage 1: Check Status

```bash
# See what changed
git status

# You'll see "Untracked files" in red
```

### Stage 2: Add Files to Staging

```bash
# Add specific file
git add README.md

# Add multiple files
git add README.md notes.txt

# Add all files
git add .

# Add all files of a type
git add *.txt

# Check status again
git status
# Files now show in green (staged)
```

### Stage 3: Commit (Save Snapshot)

```bash
# Commit with message
git commit -m "Initial commit: Add README and notes"

# View commit history
git log

# View compact history
git log --oneline
```

---

## Part 6: Create .gitignore File 🚫

Some files shouldn't be tracked (like passwords, logs, temp files).

```bash
# Create .gitignore file
cat > .gitignore << 'EOF'
# Ignore log files
*.log

# Ignore temporary files
*.tmp
*.temp

# Ignore system files
.DS_Store
Thumbs.db

# Ignore secrets
.env
secrets.txt
passwords.txt

# Ignore node_modules (if using Node.js)
node_modules/

# Ignore IDE settings
.vscode/
.idea/
EOF

# Add and commit .gitignore
git add .gitignore
git commit -m "Add gitignore file"
```

---

## Part 7: Connect to GitHub 🌐

### Step 1: Create GitHub Account
1. Go to https://github.com
2. Sign up (it's free!)
3. Verify your email

### Step 2: Create New Repository on GitHub

1. Click **+** icon (top right)
2. Click **New repository**
3. Repository name: `git-learning`
4. Description: `My Git practice repository`
5. Choose **Public** or **Private**
6. **DO NOT** check "Initialize with README" (you already have one!)
7. Click **Create repository**

### Step 3: Get Your Repository URL

After creating, GitHub shows you two URLs:

**HTTPS URL (easier, recommended for beginners):**
```
https://github.com/YOUR_USERNAME/git-learning.git
```

**SSH URL (more secure, needs setup):**
```
git@github.com:YOUR_USERNAME/git-learning.git
```

---

## Part 8: Link Local Folder to GitHub 🔗

### Add GitHub as Remote

```bash
# Add remote (replace YOUR_USERNAME with your actual GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/git-learning.git

# Verify remote was added
git remote -v

# You'll see:
# origin  https://github.com/YOUR_USERNAME/git-learning.git (fetch)
# origin  https://github.com/YOUR_USERNAME/git-learning.git (push)
```

### Rename Branch to 'main' (GitHub standard)

```bash
# Check current branch
git branch

# Rename to main (if it's master)
git branch -M main
```

---

## Part 9: Push to GitHub 🚀

### First Time Push

```bash
# Push to GitHub
git push -u origin main

# You'll be asked for credentials:
# Username: your_github_username
# Password: use Personal Access Token (NOT your GitHub password!)
```

### Generate GitHub Personal Access Token (PAT)

**GitHub stopped accepting passwords in 2021. You need a token:**

1. Go to GitHub → Click your profile picture → **Settings**
2. Scroll down → **Developer settings** (left sidebar)
3. **Personal access tokens** → **Tokens (classic)**
4. **Generate new token (classic)**
5. Note: `Git operations from local machine`
6. Expiration: Choose 90 days or No expiration
7. Select scopes: Check **repo** (all repo permissions)
8. Click **Generate token**
9. **COPY THE TOKEN NOW!** (You won't see it again)

### Use Token as Password

```bash
# When pushing:
Username: your_github_username
Password: ghp_xxxxxxxxxxxxxxxxxxxx  (paste your token here)
```

### Save Credentials (Optional - Don't enter every time)

```bash
# Save credentials in cache for 1 hour
git config --global credential.helper cache

# Save credentials permanently (less secure but convenient)
git config --global credential.helper store
```

---

## Part 10: Verify on GitHub ✅

1. Go to https://github.com/YOUR_USERNAME/git-learning
2. You should see:
   - ✅ README.md
   - ✅ notes.txt
   - ✅ examples/ folder
   - ✅ .gitignore
   - ✅ Your commit message

**Congratulations! Your code is now on GitHub!** 🎉

---

## Part 11: Daily Git Workflow 📅

### When You Make Changes:

```bash
# 1. Make changes to files
echo "New line added" >> notes.txt

# 2. Check what changed
git status

# 3. See exact changes
git diff

# 4. Add changes to staging
git add notes.txt
# or add everything:
git add .

# 5. Commit with descriptive message
git commit -m "Update notes with new information"

# 6. Push to GitHub
git push

# Done! Changes are now on GitHub
```

### Quick Commands

```bash
# See what changed
git status

# Add all changes
git add .

# Commit
git commit -m "Your message here"

# Push to GitHub
git push

# Pull latest from GitHub (if working from multiple computers)
git pull
```

---

## Part 12: Common Git Commands Reference 📚

### Status & Information

```bash
git status                    # Show current state
git log                       # Show commit history
git log --oneline            # Compact history
git log --graph --oneline    # Visual branch history
git diff                     # Show unstaged changes
git diff --staged            # Show staged changes
```

### Adding & Committing

```bash
git add file.txt             # Stage specific file
git add *.txt                # Stage all .txt files
git add .                    # Stage all changes
git commit -m "Message"      # Commit with message
git commit -am "Message"     # Add and commit (tracked files only)
```

### Branching

```bash
git branch                   # List branches
git branch new-feature       # Create new branch
git checkout new-feature     # Switch to branch
git checkout -b new-feature  # Create and switch in one command
git branch -d branch-name    # Delete branch
```

### Remote Operations

```bash
git remote -v                # Show remotes
git remote add origin URL    # Add remote
git push                     # Push to remote
git push -u origin main      # Push and set upstream
git pull                     # Fetch and merge from remote
git fetch                    # Download from remote (don't merge)
git clone URL                # Download repository
```

### Undoing Changes

```bash
# Unstage file (keep changes)
git reset file.txt

# Discard changes in working directory
git checkout -- file.txt

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1

# Revert a commit (safe, creates new commit)
git revert commit-hash
```

---

## Part 13: Practice Exercises 🎯

### Exercise 1: Create and Push New File

```bash
cd /mnt/d/Satyam/Devops/Git

# Create a new file
echo "Git commands I learned today" > git-commands.txt

# Stage and commit
git add git-commands.txt
git commit -m "Add git commands reference"

# Push to GitHub
git push

# Verify on GitHub!
```

### Exercise 2: Modify and Update

```bash
# Edit existing file
echo "Git is version control system" >> README.md

# Check changes
git diff

# Stage and commit
git add README.md
git commit -m "Update README with definition"

# Push
git push
```

### Exercise 3: Create Branch for Practice

```bash
# Create practice branch
git checkout -b practice

# Make changes
echo "Practice content" > practice-file.txt

# Commit
git add .
git commit -m "Add practice file"

# Push new branch
git push -u origin practice

# Switch back to main
git checkout main

# Merge practice into main
git merge practice

# Push updated main
git push
```

---

## Part 14: Folder Structure Best Practices 📁

### Organize Your Git Folder

```
D:\Satyam\Devops\Git\
├── README.md                   # Project description
├── .gitignore                  # Files to ignore
├── notes/                      # Your learning notes
│   ├── day1.md
│   ├── day2.md
│   └── commands.md
├── examples/                   # Code examples
│   ├── example1.sh
│   └── example2.sh
├── exercises/                  # Practice exercises
│   ├── exercise1.sh
│   └── exercise2.sh
└── projects/                   # Small projects
    └── project1/
```

### Create This Structure

```bash
cd /mnt/d/Satyam/Devops/Git

# Create folders
mkdir -p notes examples exercises projects

# Create sample files
echo "# Day 1 Notes" > notes/day1.md
echo "#!/bin/bash" > examples/example1.sh
chmod +x examples/example1.sh

# Add all
git add .
git commit -m "Organize repository structure"
git push
```

---

## Part 15: Troubleshooting Common Issues 🔧

### Issue 1: "Permission denied (publickey)"

**Solution:** Use HTTPS URL instead of SSH, or set up SSH keys.

```bash
# Check current remote
git remote -v

# If it shows git@github.com (SSH), change to HTTPS:
git remote set-url origin https://github.com/YOUR_USERNAME/git-learning.git

# Try pushing again
git push
```

### Issue 2: "Authentication failed"

**Solution:** Use Personal Access Token, not password.

```bash
# Generate token on GitHub (see Part 9)
# When prompted for password, paste the token

# Or save credentials:
git config --global credential.helper store
```

### Issue 3: "Repository not found"

**Solution:** Check remote URL is correct.

```bash
# View remote
git remote -v

# Update if wrong
git remote set-url origin CORRECT_URL
```

### Issue 4: "Merge conflict"

**Solution:** Manually resolve conflicts.

```bash
# Pull latest changes
git pull

# If conflict, edit files to fix
# Look for markers: <<<<<<< ======= >>>>>>>

# After fixing:
git add .
git commit -m "Resolve merge conflict"
git push
```

### Issue 5: "Updates were rejected"

**Solution:** Pull first, then push.

```bash
# Pull latest changes
git pull

# Then push
git push
```

---

## Part 16: GitHub Features to Explore 🌟

### 1. View Commit History
- Go to your repository → Click "Commits"
- See all changes over time

### 2. View Specific File History
- Click on any file → Click "History"
- See how file evolved

### 3. Compare Changes
- Click "Compare" → Select branches/commits
- See differences

### 4. Create Issues
- Click "Issues" tab → "New issue"
- Track bugs, features, tasks

### 5. Add README with Markdown
- Edit README.md on GitHub
- Use markdown formatting:

```markdown
# Heading 1
## Heading 2

**Bold text**
*Italic text*

- Bullet point
1. Numbered list

[Link](https://github.com)

`code`

```bash
code block
```
```

---

## Part 17: Quick Start Checklist ✅

- [ ] Install Git
- [ ] Configure user name and email
- [ ] Create GitHub account
- [ ] Navigate to D:\Satyam\Devops\Git
- [ ] Run `git init`
- [ ] Create README.md
- [ ] Run `git add .`
- [ ] Run `git commit -m "Initial commit"`
- [ ] Create repository on GitHub
- [ ] Copy repository URL
- [ ] Run `git remote add origin URL`
- [ ] Run `git push -u origin main`
- [ ] Verify files on GitHub
- [ ] Celebrate! 🎉

---

## Part 18: Essential Git Commands Cheat Sheet 📋

### Setup
```bash
git config --global user.name "Name"
git config --global user.email "email"
git init
```

### Basic Workflow
```bash
git status
git add .
git commit -m "message"
git push
git pull
```

### Branching
```bash
git branch
git branch name
git checkout name
git merge name
```

### Remote
```bash
git remote -v
git remote add origin URL
git push -u origin main
git clone URL
```

### History
```bash
git log
git log --oneline
git diff
```

---

## Next Steps 🚀

Once comfortable with basics:
1. Learn branching strategies (feature branches)
2. Explore GitHub Actions (CI/CD)
3. Contribute to open source projects
4. Learn Git best practices
5. Explore advanced commands (rebase, cherry-pick)

---

## Useful Resources 📚

- **Official Git Documentation:** https://git-scm.com/doc
- **GitHub Guides:** https://guides.github.com/
- **Interactive Git Tutorial:** https://learngitbranching.js.org/
- **Git Cheat Sheet:** https://education.github.com/git-cheat-sheet-education.pdf
- **Markdown Guide:** https://www.markdownguide.org/

---

## Pro Tips 💡

1. **Commit often** - Small, frequent commits are better than large ones
2. **Write good commit messages** - Explain "why", not just "what"
3. **Pull before push** - Avoid conflicts
4. **Use branches** for new features
5. **Review changes** before committing (`git diff`)
6. **Keep commits focused** - One logical change per commit
7. **Use .gitignore** - Don't commit sensitive or generated files
8. **Test before committing** - Make sure code works

---

**You're now ready to use Git and GitHub!** 🎉

**Practice daily and it will become second nature!** 💪
