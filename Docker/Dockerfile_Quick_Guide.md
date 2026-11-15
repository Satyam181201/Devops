# Dockerfile Quick Guide - Essential + Interview Questions 🚀

**Short, practical guide with only important things!**

---

## The Perfect Dockerfile Order (Follow This!)

```dockerfile
# 1. BASE IMAGE
FROM python:3.11-slim

# 2. SET WORKING DIRECTORY
WORKDIR /app

# 3. COPY DEPENDENCIES FILE FIRST (for caching)
COPY requirements.txt .

# 4. INSTALL DEPENDENCIES (as root - needs permission)
RUN pip install --no-cache-dir -r requirements.txt

# 5. COPY APPLICATION CODE (last, changes often)
COPY . .

# 6. EXPOSE PORT
EXPOSE 8080

# 7. CREATE NON-ROOT USER (security - after installs!)
RUN useradd -m appuser
RUN chown -R appuser:appuser /app

# 8. SWITCH TO NON-ROOT USER
USER appuser

# 9. START COMMAND (runs as appuser, not root)
CMD ["python", "app.py"]
```

**Key Order Rule:** Install packages as root → Create user → Switch to user → Run app

---

## 5 Essential Commands

### 1. FROM - Base Image (Always First!)
```dockerfile
FROM ubuntu:22.04
FROM node:18-alpine
FROM python:3.11-slim
```

### 2. RUN - Execute During Build
```dockerfile
# Install packages (one layer!)
RUN apt-get update && \
    apt-get install -y python3 curl && \
    rm -rf /var/lib/apt/lists/*
```

**Understanding the RUN Command Line by Line:**

```dockerfile
RUN apt-get update && \  
    apt-get install -y python3 curl && \  
    rm -rf /var/lib/apt/lists/*
```

- **`apt-get update`** - Updates package list from Ubuntu/Debian repositories (must run before installing)
- **`&&`** - Logical operator: "if previous succeeds, run next" (stops if update fails)
- **`\`** - Line continuation (makes long commands readable; all 3 lines = one RUN command)
- **`apt-get install -y python3 curl`** - Installs packages with `-y` flag (auto-answers "yes", required in Dockerfiles)
- **`rm -rf /var/lib/apt/lists/*`** - Deletes package cache to reduce image size by 20-40 MB

**Why combine in ONE RUN?**
```dockerfile
# ❌ BAD - 3 layers, larger image
RUN apt-get update
RUN apt-get install -y python3 curl
RUN rm -rf /var/lib/apt/lists/*

# ✅ GOOD - 1 layer, smaller image
RUN apt-get update && \
    apt-get install -y python3 curl && \
    rm -rf /var/lib/apt/lists/*
```

Each RUN creates a new layer. Combining them = fewer layers = smaller image!

### 3. COPY - Copy Files
```dockerfile
COPY app.py /app/
COPY . .
```

**Understanding COPY:**

**`COPY app.py /app/`** - Copies **one specific file**
- Source: `app.py` (on your computer)
- Destination: `/app/` (inside container)
- Result: Only `app.py` is copied to `/app/app.py`

**`COPY . .`** - Copies **everything**
- First `.` = current directory on your computer (all files!)
- Second `.` = current WORKDIR in container
- Result: All files and folders are copied

**Example:**
```dockerfile
WORKDIR /app
COPY requirements.txt .         # Copies to /app/requirements.txt
COPY . .                        # Copies everything to /app/
```

### 4. CMD - Default Command
```dockerfile
CMD ["python", "app.py"]
CMD ["node", "server.js"]
```

### 5. WORKDIR - Set Directory
```dockerfile
WORKDIR /app
```

**Understanding WORKDIR:**

WORKDIR sets the "current folder" inside the container - like using `cd` in terminal.

**Once set, ALL commands after it use that directory:**
```dockerfile
WORKDIR /app                    # Go to /app

COPY . .                        # Copies to /app/ (. means /app now)
RUN pip install                 # Runs inside /app
CMD ["python", "app.py"]        # Runs: python /app/app.py
```

**You can change WORKDIR anytime:**
```dockerfile
WORKDIR /app                    # Now in /app
COPY app.py .                   # → /app/app.py

WORKDIR /data                   # Now in /data
COPY data.json .                # → /data/data.json
```

**Key Points:**
- WORKDIR creates the folder if it doesn't exist
- `.` always means the current WORKDIR
- Stays active until you change it

---

### 6. EXPOSE - Document Port (Not Actually Open!)
```dockerfile
EXPOSE 5000
```

**Understanding EXPOSE:**

**EXPOSE is DOCUMENTATION ONLY** - it does NOT actually open/publish the port!

```dockerfile
EXPOSE 5000                     # Just tells: "app listens on 5000"
```

**To actually access the port, use `-p` flag:**
```bash
# ❌ Can't access (EXPOSE alone doesn't work)
docker run myapp

# ✅ Can access at localhost:5000
docker run -p 5000:5000 myapp

# ✅ Can access at localhost:8080 (maps to container's 5000)
docker run -p 8080:5000 myapp
```

**Port Mapping Format:**
```bash
docker run -p <your-port>:<container-port> image
           ↑              ↑
      Port on computer    Port in container
```

**Key Points:**
- EXPOSE = label/note (tells what port app uses)
- `-p` = actually opens the door to access the port
- Format: `-p host-port:container-port`

---

## RUN vs CMD vs ENTRYPOINT (Interview Favorite!)

| Command | When? | Can Override? |
|---------|-------|---------------|
| **RUN** | Build time | No |
| **CMD** | Runtime | Yes (easy) |
| **ENTRYPOINT** | Runtime | No (hard) |

**Example:**
```dockerfile
# RUN - Installs during build
RUN apt-get install python3

# CMD - Default, can override
CMD ["python", "app.py"]
docker run myimage python test.py  # Overrides CMD

# ENTRYPOINT - Fixed command
ENTRYPOINT ["python"]
CMD ["app.py"]
docker run myimage test.py  # Runs: python test.py
```

---

## COPY vs ADD

**Use COPY 99% of the time!**

```dockerfile
# ✅ COPY - Simple, clear
COPY app.py /app/

# ❌ ADD - Only for tar extraction
ADD app.tar.gz /app/  # Auto-extracts
```

---

## Why Order Matters? (Layer Caching)

```dockerfile
# ❌ WRONG - Rebuilds everything on code change
COPY . .
RUN pip install -r requirements.txt

# ✅ RIGHT - Only rebuilds code layer
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .  # Code changes often, put last!
```

---

## 3 Real Examples

### Example 1: Python App
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["python", "app.py"]
```

### Example 2: Node.js App
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
```

### Example 3: Multi-Stage (Java)
```dockerfile
# Build stage
FROM maven:3.8-openjdk-17 AS builder
WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn package -DskipTests

# Runtime stage
FROM openjdk:17-alpine
COPY --from=builder /build/target/*.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
```

---

## Interview Questions & Answers

### Q1: What is the difference between RUN, CMD, and ENTRYPOINT?

**Answer:**
- **RUN** executes commands during image build (like installing packages). Creates a layer.
- **CMD** sets the default command when container starts. Can be easily overridden.
- **ENTRYPOINT** sets a fixed command that always runs. CMD becomes arguments to ENTRYPOINT.

---

### Q2: Explain COPY vs ADD. When to use each?

**Answer:**
- **COPY** simply copies files from host to image. Use this for 99% of cases.
- **ADD** can copy files AND extract tar archives or download from URLs. Only use when you need tar extraction.
- COPY is preferred because it's explicit and more secure.

---

### Q3: Why should you copy dependency files before application code?

**Answer:**
Docker builds images in layers and caches them. If you copy package.json/requirements.txt first and install dependencies, that layer is cached. When you change application code, Docker only rebuilds from the COPY . . step, not the dependency installation. This makes builds much faster.

```dockerfile
# Good - dependencies cached
COPY package.json .
RUN npm install          # Cached if package.json unchanged
COPY . .                 # Only this rebuilds on code change
```

---

### Q4: How do you reduce Docker image size?

**Answer:**
1. Use **alpine** or **slim** base images (python:3.11-alpine vs python:3.11)
2. Use **multi-stage builds** (build in one stage, copy artifacts to smaller runtime stage)
3. Combine RUN commands into one layer with &&
4. Remove cache: `apt-get clean`, `npm cache clean`, `--no-cache-dir`
5. Use **.dockerignore** to exclude unnecessary files

Alpine = Smallest (~50 MB) but may have issues
Slim = Medium (~150 MB) ← Best choice for most cases!
Full = Largest (~1 GB) but no issues
Alpine uses apk, Slim/Full use apt-get
Always prefer smaller images for production

---

### Q5: What is multi-stage build? Why use it?

**Answer:**
Multi-stage build uses multiple FROM statements. First stage builds the application with all build tools. Second stage copies only the compiled artifact to a smaller base image.

**Benefits:**
- Much smaller final image (no build tools in production)
- Faster deployment
- More secure (less attack surface)

**Example:**
```dockerfile
# Stage 1: Build (heavy)
FROM maven:3.8 AS builder
RUN mvn package

# Stage 2: Runtime (light)
FROM openjdk:17-alpine
COPY --from=builder /app/target/*.jar app.jar
```

---

### Q6: How do you pass environment variables to a container?

**Answer:**
Three ways:
1. **In Dockerfile:** `ENV PORT=8080`
2. **At runtime with -e:** `docker run -e PORT=9090 myimage`
3. **With env file:** `docker run --env-file .env myimage`

---

### Q7: What is .dockerignore and why use it?

**Answer:**
.dockerignore lists files/folders to exclude from the build context (not copied to image).

**Why use it:**
- Faster builds (smaller context)
- Smaller images
- Security (don't copy secrets, .git, .env)

**Example .dockerignore:**
```
node_modules
.git
*.log
.env
```

---

### Q8: Why run containers as non-root user?

**Answer:**
Security! By default, containers run as **root** (admin/superuser) with full permissions. If a hacker exploits your app, they get full control. Running as non-root user limits damage.

**Understanding the commands:**
- `RUN useradd -m appuser` - Creates regular user (not admin)
- `USER appuser` - Switch to that user
- After this, app runs with **limited permissions**

**Where to add these commands:**
```dockerfile
FROM python:3.11-slim
WORKDIR /app

# 1. Install dependencies as root (needs permission)
COPY requirements.txt .
RUN pip install -r requirements.txt

# 2. Copy application files
COPY . .

# 3. Create non-root user (AFTER all installs!)
RUN useradd -m appuser
RUN chown -R appuser:appuser /app

# 4. Switch to non-root user
USER appuser

# 5. Run app as appuser (not root!)
CMD ["python", "app.py"]
```

**Rule:** Add `useradd` and `USER` **AFTER** all installations, **BEFORE** CMD

**Why this order:**
- Need root permission to install packages
- Switch to non-root only at the end
- App runs with limited permissions

---

### Q9: What does EXPOSE do in Dockerfile?

**Answer:**
EXPOSE documents which port the container listens on. It's **documentation only** - doesn't actually publish the port!

To actually publish: `docker run -p 8080:8080 myimage`

---

### Q10: You changed one line of code. Why does Docker rebuild everything?

**Answer:**
Probably because COPY . . is too early in the Dockerfile. Docker rebuilds all layers after a changed layer. Solution: copy dependency files first, then code last.

```dockerfile
# Fix:
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .  # Changes here only rebuild this layer
```

---

### Q11: How to debug a failing Dockerfile build?

**Answer:**
1. Check which layer failed: `docker build .`
2. Run a container from the last successful layer: `docker run -it <image-id> sh`
3. Manually run the failing command to see the error
4. Use `docker build --no-cache` to rebuild without cache

---

### Q12: What is the difference between CMD and ENTRYPOINT in combination?

**Answer:**
When both are used:
- ENTRYPOINT is the fixed command
- CMD provides default arguments to ENTRYPOINT
- You can override CMD at runtime, but ENTRYPOINT stays

```dockerfile
ENTRYPOINT ["python"]
CMD ["app.py"]

# docker run myimage          → python app.py
# docker run myimage test.py  → python test.py
```

---

## Quick Commands Reference

```bash
# Build image
docker build -t myapp .
docker build -t myapp:v1.0 .

# Run container
docker run -p 8080:8080 myapp
docker run -d -p 8080:8080 myapp  # Detached
docker run -e PORT=9090 myapp     # With env var

# Check images
docker images
docker image ls

# Remove image
docker rmi myapp

# See build history/layers
docker history myapp

# Build without cache
docker build --no-cache -t myapp .
```

---

## Common Mistakes

### ❌ Running as root
```dockerfile
CMD ["python", "app.py"]  # Runs as root!
```

### ✅ Run as non-root
```dockerfile
RUN useradd -m appuser
USER appuser
CMD ["python", "app.py"]
```

---

### ❌ Multiple RUN layers
```dockerfile
RUN apt-get update
RUN apt-get install python3
RUN apt-get install curl
```

### ✅ One RUN layer
```dockerfile
RUN apt-get update && \
    apt-get install -y python3 curl && \
    rm -rf /var/lib/apt/lists/*
```

---

### ❌ Code before dependencies
```dockerfile
COPY . .
RUN pip install -r requirements.txt
```

### ✅ Dependencies first
```dockerfile
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
```

---

## Practice Exercise

**Create Dockerfile for this Python app:**

**app.py:**
```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello, Docker!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

**requirements.txt:**
```
flask==2.3.0
```

<details>
<summary>Click for Solution</summary>

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
EXPOSE 5000
CMD ["python", "app.py"]
```

**Build & Run:**
```bash
docker build -t flask-app .
docker run -p 5000:5000 flask-app
# Visit: http://localhost:5000
```
</details>

---

## Key Takeaways 🎯

1. **Order matters** - Dependencies first, code last (caching!)
2. **Use COPY** not ADD (99% of time)
3. **RUN** = build time, **CMD** = runtime
4. **Multi-stage** = smaller images
5. **Non-root user** = security
6. **EXPOSE** = documentation only
7. **Combine RUN** commands = fewer layers

---

**That's it! Short, focused, interview-ready!** 🚀

**Practice:** Start with the exercise above, then try with Node.js or Java!
