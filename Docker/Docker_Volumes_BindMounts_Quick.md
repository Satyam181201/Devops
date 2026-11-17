# Docker Volumes & Bind Mounts - Quick Notes 🚀

**Short notes for interview prep!**

---

## The Problem

**Container data is lost when container stops!**

```bash
docker run mysql
# Add data to database
docker stop mysql
docker start mysql
# Data is GONE! ❌
```

**Solution:** Use volumes or bind mounts to persist data!

---

## 3 Types of Storage

| Type | What | When to Use |
|------|------|-------------|
| **Volume** | Managed by Docker | Production (databases, logs) |
| **Bind Mount** | Your folder mapped | Development (code changes) |
| **tmpfs** | RAM only (temporary) | Secrets, cache |

---

## 1. Volumes (Recommended for Production)

### What:
Docker manages storage location

### Create & Use:
```bash
# Create volume
docker volume create mydata

# Use volume
docker run -v mydata:/var/lib/mysql mysql

# List volumes
docker volume ls

# Inspect volume
docker volume inspect mydata

# Remove volume
docker volume rm mydata
```

### Where is it stored?
Linux: `/var/lib/docker/volumes/`  
Windows: Docker Desktop manages it

### Pros:
✅ Docker manages location  
✅ Easy backup  
✅ Works across platforms  
✅ Can be shared between containers  

### Cons:
❌ Can't see files easily on host

---

## 2. Bind Mounts (Good for Development)

### What:
Your computer folder → Container folder

### Use:
```bash
# Map host folder to container
docker run -v /host/path:/container/path myapp
docker run -v D:\code:/app myapp

# Example: Development
docker run -v D:\project:/app node:18 npm start
# Changes in D:\project instantly reflect in container!
```

### Pros:
✅ Easy to access files on host  
✅ Real-time code changes (development)  
✅ Full control over location  

### Cons:
❌ Path depends on host OS  
❌ Less portable  
❌ Security concerns

---

## Volume vs Bind Mount (Quick Comparison)

| Feature | Volume | Bind Mount |
|---------|--------|------------|
| **Managed by** | Docker | You |
| **Location** | Docker decides | You specify |
| **Syntax** | `-v myvolume:/data` | `-v /host/path:/data` |
| **Best for** | Production, databases | Development |
| **Portable** | Yes ✅ | No ❌ |
| **Easy backup** | Yes ✅ | Depends |

---

## Syntax Comparison

### Volume:
```bash
docker run -v volume_name:/container/path image
```

### Bind Mount:
```bash
docker run -v /host/path:/container/path image
```

### Anonymous Volume (Docker creates name):
```bash
docker run -v /container/path image
```

---

## Real Examples

### Example 1: MySQL with Volume (Production)
```bash
# Create volume
docker volume create mysql_data

# Run MySQL with volume
docker run -d \
  --name mysql \
  -v mysql_data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=password \
  mysql:8

# Data persists even if container is deleted!
```

### Example 2: Node.js Development with Bind Mount
```bash
# Map local code to container
docker run -d \
  --name node-app \
  -v D:\project:/app \
  -p 3000:3000 \
  node:18 \
  npm start

# Edit files in D:\project, changes reflect immediately!
```

### Example 3: Both Volume + Bind Mount
```bash
docker run -d \
  -v mydata:/app/data \              # Volume for database
  -v D:\code:/app/src \              # Bind mount for code
  -p 5000:5000 \
  myapp
```

---

## Docker Compose with Volumes

### Using Volumes:
```yaml
version: '3.8'
services:
  db:
    image: postgres
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:    # Named volume
```

### Using Bind Mounts:
```yaml
version: '3.8'
services:
  app:
    image: node:18
    volumes:
      - ./src:/app/src           # Bind mount
      - ./package.json:/app/package.json
```

### Both:
```yaml
version: '3.8'
services:
  app:
    image: myapp
    volumes:
      - app_data:/app/data       # Volume
      - ./code:/app/src          # Bind mount

volumes:
  app_data:
```

---

## Read-Only Volumes

```bash
# Read-only volume (container can't modify)
docker run -v myvolume:/data:ro myapp

# Read-only bind mount
docker run -v D:\config:/app/config:ro myapp
```

**Use case:** Config files, secrets (container shouldn't modify)

---

## Common Use Cases

### Use Volumes For:
✅ **Database data** (MySQL, PostgreSQL, MongoDB)  
✅ **Application logs**  
✅ **Uploads/user files**  
✅ **Production environments**  

### Use Bind Mounts For:
✅ **Development** (live code changes)  
✅ **Config files** (easy to edit on host)  
✅ **Source code** (when developing)  

---

## Interview Questions & Answers

### Q1: What's the difference between volumes and bind mounts?

**Answer:** Volumes are managed by Docker in its own storage location and are portable. Bind mounts map a specific host directory to container, giving full control but less portable. Volumes are recommended for production, bind mounts for development.

---

### Q2: Why use volumes instead of storing data in containers?

**Answer:** Container filesystem is ephemeral - data is lost when container is removed. Volumes persist data outside the container lifecycle, so data survives container restarts, updates, and deletions.

---

### Q3: How do you share data between containers?

**Answer:** Use a named volume and mount it to multiple containers:
```bash
docker volume create shared_data
docker run -v shared_data:/data container1
docker run -v shared_data:/data container2
```

---

### Q4: Where are Docker volumes stored?

**Answer:** On Linux: `/var/lib/docker/volumes/`. On Windows/Mac: inside Docker Desktop's VM. Docker manages the location, so you don't need to specify it.

---

### Q5: How do you backup a Docker volume?

**Answer:**
```bash
# Backup
docker run --rm -v myvolume:/data -v $(pwd):/backup ubuntu tar czf /backup/backup.tar.gz /data

# Restore
docker run --rm -v myvolume:/data -v $(pwd):/backup ubuntu tar xzf /backup/backup.tar.gz -C /
```

---

### Q6: What's an anonymous volume?

**Answer:** A volume without a name. Docker auto-generates a random name. Created with: `docker run -v /container/path image`. Hard to manage, not recommended.

---

### Q7: Can you mount the same volume to multiple containers?

**Answer:** Yes! Multiple containers can share one volume:
```bash
docker run -v shared:/data app1
docker run -v shared:/data app2
# Both access same data
```

---

### Q8: Bind mount vs volume - which is faster?

**Answer:** Volumes are slightly faster because they're optimized by Docker. Bind mounts go through OS filesystem, which can be slower especially on Windows/Mac (due to VM layer).

---

## Quick Commands Reference

```bash
# VOLUMES
docker volume create myvolume          # Create
docker volume ls                       # List
docker volume inspect myvolume         # Details
docker volume rm myvolume              # Delete
docker volume prune                    # Remove unused

# RUN WITH VOLUME
docker run -v myvolume:/data image     # Named volume
docker run -v /data image              # Anonymous volume

# RUN WITH BIND MOUNT
docker run -v /host:/container image   # Linux
docker run -v D:\code:/app image       # Windows

# READ-ONLY
docker run -v myvolume:/data:ro image  # Read-only
```

---

## Best Practices

### ✅ DO:
- Use **volumes** for production databases
- Use **bind mounts** for development
- Use **named volumes** (not anonymous)
- Backup volumes regularly
- Use read-only (`:ro`) for config files

### ❌ DON'T:
- Store data in containers without volumes
- Use bind mounts in production
- Share host system directories unnecessarily
- Forget to remove unused volumes (`docker volume prune`)

---

## Common Mistakes

### ❌ Wrong: Path with spaces
```bash
docker run -v D:\My Folder:/app image  # Fails!
```
### ✅ Right: Use quotes
```bash
docker run -v "D:\My Folder:/app" image
```

---

### ❌ Wrong: Windows backslash
```bash
docker run -v D:\code:/app image  # May fail
```
### ✅ Right: Use forward slash or quotes
```bash
docker run -v D:/code:/app image
docker run -v "D:\code:/app" image
```

---

## Key Takeaways

1. **Volumes** = Docker-managed, portable, production
2. **Bind Mounts** = Host folder, development
3. **Syntax:** `-v volume_name:/path` vs `-v /host/path:/path`
4. **Use volumes for databases**, bind mounts for code
5. **Data persists** even if container deleted
6. **Volumes can be shared** between containers
7. **Always use volumes in production!**

---

**That's it! Short, focused, interview-ready!** 🎯
