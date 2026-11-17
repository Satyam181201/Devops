# Docker Volume Practice Project 🚀

**Simple project to practice Docker volumes**

---

## Project: Simple Note App with Volume

A Python app that saves notes to a file. Data persists using Docker volumes!

---

## Files Needed

### 1. app.py
```python
import os
from datetime import datetime

DATA_FILE = '/app/data/notes.txt'

def read_notes():
    if os.path.exists(DATA_FILE):
        with open(DATA_FILE, 'r') as f:
            return f.read()
    return "No notes yet!"

def add_note(note):
    with open(DATA_FILE, 'a') as f:
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        f.write(f"[{timestamp}] {note}\n")

# Main
print("=== Note App ===")
print("\nExisting notes:")
print(read_notes())

# Add new note
new_note = input("\nAdd a note (or press Enter to skip): ")
if new_note:
    add_note(new_note)
    print("Note saved!")

print("\nAll notes:")
print(read_notes())
```

### 2. Dockerfile
```dockerfile
FROM python:3.11-alpine

WORKDIR /app

COPY app.py .

# Create data directory
RUN mkdir -p /app/data

CMD ["python", "app.py"]
```

---

## Steps to Practice Volumes

### Step 1: Create Project Files

```bash
# Create folder
mkdir Volume-Practice
cd Volume-Practice

# Create app.py (copy code above)
# Create Dockerfile (copy code above)
```

### Step 2: Build Image

```bash
docker build -t note-app .
```

### Step 3: Run WITHOUT Volume (Data Lost!)

```bash
# Run container
docker run -it --name test1 note-app
# Add a note: "Hello Docker"
# Exit

# Run again
docker run -it --name test2 note-app
# Your note is GONE! ❌
```

Clean up:
```bash
docker rm test1 test2
```

---

### Step 4: Run WITH Named Volume (Data Persists!)

```bash
# Create volume
docker volume create mynotes

# Run with volume
docker run -it --name app1 -v mynotes:/app/data note-app
# Add note: "First note with volume"
# Exit

# Remove container
docker rm app1

# Run NEW container with SAME volume
docker run -it --name app2 -v mynotes:/app/data note-app
# Your note is THERE! ✅
```

---

### Step 5: Check Volume

```bash
# List volumes
docker volume ls

# Inspect volume
docker volume inspect mynotes
```

---

### Step 6: Multiple Containers, Same Volume

```bash
# Container 1
docker run -it --name writer -v mynotes:/app/data note-app
# Add note: "From container 1"

# Container 2 (same volume)
docker run -it --name reader -v mynotes:/app/data note-app
# See note from container 1! ✅
```

---

### Step 7: Bind Mount (Development)

```bash
# Create data folder on your PC
mkdir data

# Run with bind mount
docker run -it -v D:/Satyam/Devops/Docker/Volume-Practice/data:/app/data note-app
# Add note

# Check D:/Satyam/Devops/Docker/Volume-Practice/data/notes.txt
# You can see the file on your PC! ✅
```

---

## Commands Summary

```bash
# BUILD
docker build -t note-app .

# RUN WITH VOLUME
docker run -it -v mynotes:/app/data note-app

# RUN WITH BIND MOUNT (Windows)
docker run -it -v D:/path/to/data:/app/data note-app

# RUN WITH BIND MOUNT (Linux/Mac)
docker run -it -v /path/to/data:/app/data note-app

# LIST VOLUMES
docker volume ls

# INSPECT VOLUME
docker volume inspect mynotes

# REMOVE VOLUME
docker volume rm mynotes

# REMOVE ALL UNUSED VOLUMES
docker volume prune
```

---

## What You'll Learn

1. ✅ Data in containers is lost when container stops (without volumes)
2. ✅ Named volumes persist data
3. ✅ Multiple containers can share same volume
4. ✅ Bind mounts let you see files on host PC
5. ✅ Volumes survive container deletion

---

## Expected Output

### First Run (with volume):
```
=== Note App ===

Existing notes:
No notes yet!

Add a note (or press Enter to skip): Hello from Docker

Note saved!

All notes:
[2024-11-15 10:30:45] Hello from Docker
```

### Second Run (same volume):
```
=== Note App ===

Existing notes:
[2024-11-15 10:30:45] Hello from Docker

Add a note (or press Enter to skip): Second note

Note saved!

All notes:
[2024-11-15 10:30:45] Hello from Docker
[2024-11-15 10:32:10] Second note
```

---

## Cleanup

```bash
# Stop all containers
docker stop $(docker ps -aq)

# Remove containers
docker rm $(docker ps -aq)

# Remove volume
docker volume rm mynotes

# Remove image
docker rmi note-app
```

---

## Practice Tasks

1. ✅ Run without volume - see data lost
2. ✅ Run with volume - data persists
3. ✅ Share volume between 2 containers
4. ✅ Use bind mount to see file on PC
5. ✅ Delete container, data still there
6. ✅ Delete volume, data gone

---

**Practice all steps to understand volumes!** 🎯
