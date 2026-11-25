# Docker Networks - Quick Interview Notes 🚀

---

## What is Docker Network?

**Docker Network** = Virtual network allowing containers to communicate

Default behavior:
- Containers are isolated
- Can't talk to each other
- Need a network to connect them

**Use case:** Backend API + Database need to talk → Docker Networks!

---

## Network Types (4 Types)

| Type | Description | Use Case |
|------|-------------|----------|
| **bridge** | Default, isolated network | Most common (multi-container apps) ✅ |
| **host** | Use host's network directly | High performance needed |
| **none** | No network access | Security, testing |
| **overlay** | Multi-host network | Docker Swarm, Kubernetes |

---

## 1. Bridge Network (Most Important!)

### Default Bridge vs Custom Bridge:

| Feature | Default Bridge | Custom Bridge |
|---------|----------------|---------------|
| **Name** | `bridge` | Your choice |
| **DNS** | No (use IP) ❌ | Yes (use container name) ✅ |
| **Isolation** | All containers | Only attached containers |
| **Recommended** | No | Yes ✅ |

### Commands:
```bash
# Create custom bridge network
docker network create mynetwork

# Run containers on network
docker run -d --name api --network mynetwork node:18
docker run -d --name db --network mynetwork postgres

# Containers can ping by name!
docker exec api ping db  # Works! ✅
```

### Command Explanations:

**1. Create Network:**
```bash
docker network create mynetwork
```
- Creates custom bridge network named "mynetwork"
- Enables DNS (containers use names as hostnames)

**2. Run API Container:**
```bash
docker run -d --name api --network mynetwork node:18
```
- `-d` = Run in background (detached)
- `--name api` = Name container "api"
- `--network mynetwork` = Connect to "mynetwork"
- `node:18` = Node.js v18 image
- **Result:** Container "api" running on "mynetwork"

**3. Run Database Container:**
```bash
docker run -d --name db --network mynetwork postgres
```
- `--name db` = Name container "db"
- `--network mynetwork` = Connect to same network
- `postgres` = PostgreSQL database image
- **Result:** Container "db" running on "mynetwork"

**4. Test Communication:**
```bash
docker exec api ping db
```
- `docker exec` = Execute command inside container
- `api` = Run command inside "api" container
- `ping db` = Ping hostname "db"
- **Result:** api can ping db by name (DNS works!)
- Output: `PING db (172.18.0.3): 56 data bytes...` ✅

**Why it works:** Both containers on same custom bridge network = DNS enabled!

**Always use custom bridge networks in production!**

---

## Custom Bridge Network - Key Points

### Why Custom Bridge is Better:

**Default Bridge (bad):**
```bash
docker run -d --name api node:18
docker run -d --name db postgres

# Must use IP addresses - no DNS! ❌
ping 172.17.0.3
```

**Custom Bridge (good):**
```bash
docker network create mynet
docker run -d --name api --network mynet node:18
docker run -d --name db --network mynet postgres

# Use container names - DNS works! ✅
ping db  # Works!
```

---

### How It Works:

**Docker provides built-in DNS:**
- Container name → IP address
- "db" automatically resolves to correct IP
- Like WiFi at home: "John's-Laptop" instead of "192.168.1.10"

---

### Practical Example: Web App + Database

```bash
# Create network
docker network create app-net

# Database
docker run -d \
  --name postgres \
  --network app-net \
  -e POSTGRES_PASSWORD=secret \
  postgres

# Backend API
docker run -d \
  --name api \
  --network app-net \
  -e DB_HOST=postgres \
  node:18

# Connection string: postgresql://postgres:5432/db
# No IP needed! ✅
```

---

### Multiple Networks (Security Pattern):

```bash
# Create networks
docker network create frontend-net
docker network create backend-net

# Frontend
docker run -d --name web --network frontend-net -p 80:80 nginx

# Backend (on BOTH networks)
docker run -d --name api --network frontend-net node:18
docker network connect backend-net api

# Database (private)
docker run -d --name db --network backend-net postgres

# Result:
# ✅ web → api (frontend-net)
# ✅ api → db (backend-net)
# ❌ web ✗ db (blocked!)
```

---

### Useful Commands:

```bash
# Create network
docker network create mynet

# Run on network
docker run --network mynet --name app nginx

# Connect running container
docker network connect mynet container-name

# Inspect (see containers on network)
docker network inspect mynet

# Disconnect
docker network disconnect mynet container-name
```

---

## 2. Host Network

**Container uses host's network directly (no isolation)**

```bash
docker run --network host nginx
# No need for -p flag
# Container uses host's ports directly
```

**Pros:** Best performance (no NAT overhead)  
**Cons:** No isolation, port conflicts, less secure  
**Use case:** Monitoring tools, high-performance apps

---

## 3. None Network

**No network access, completely isolated**

```bash
docker run --network none alpine
```

**Use case:** Security testing, batch processing

---

## 4. Overlay Network

**Multi-host network (containers on different servers)**

**Use case:** Docker Swarm, Kubernetes (not for single-host)

---

## Network Comparison Table

| Network Type | Container-to-Container | Use DNS | Isolation |
|--------------|------------------------|---------|-----------|
| **bridge (custom)** | ✅ Yes | ✅ Yes | ✅ High |
| **bridge (default)** | ✅ IP only | ❌ No | Medium |
| **host** | N/A | N/A | ❌ None |
| **none** | ❌ No | ❌ No | ✅ Complete |

---

## Real Example: Web App + Database

```bash
# 1. Create network
docker network create app-network

# 2. Run database
docker run -d \
  --name postgres \
  --network app-network \
  -e POSTGRES_PASSWORD=secret \
  postgres

# 3. Run web app
docker run -d \
  --name webapp \
  --network app-network \
  -p 8080:8080 \
  myapp

# webapp connects to postgres using hostname "postgres"
# Connection string: postgresql://postgres:5432/db
```

---

## Docker Compose with Networks

### Automatic Network (Simple):
```yaml
version: '3.8'
services:
  web:
    image: nginx
  api:
    image: node:18
  db:
    image: postgres

# Docker Compose auto-creates network!
# Services communicate using service names
```

### Custom Networks (Advanced):
```yaml
version: '3.8'
services:
  frontend:
    image: nginx
    networks:
      - frontend-net
  
  backend:
    image: node:18
    networks:
      - frontend-net
      - backend-net
  
  database:
    image: postgres
    networks:
      - backend-net

networks:
  frontend-net:
  backend-net:

# frontend ↔ backend (frontend-net)
# backend ↔ database (backend-net)
# frontend ✗ database (isolated!)
```

---

## Port Mapping vs Networks

### Port Mapping (`-p`): Host → Container (external access)
```bash
docker run -p 8080:80 nginx
# Access from browser: localhost:8080
```

### Networks (`--network`): Container → Container (internal)
```bash
docker network create mynet
docker run --network mynet --name web nginx
docker run --network mynet --name api node:18
# api accesses web internally (no -p needed)
```

### Both Together:
```bash
docker run -d \
  --name api \
  --network mynet \
  -p 8080:8080 \
  myapp

# External: http://localhost:8080
# Internal: http://api:8080 (from other containers)
```

---

## Commands Reference

```bash
# LIST NETWORKS
docker network ls

# CREATE NETWORK
docker network create mynetwork

# INSPECT NETWORK (see containers, IPs)
docker network inspect mynetwork

# CONNECT CONTAINER TO NETWORK
docker network connect mynetwork container_name

# DISCONNECT CONTAINER
docker network disconnect mynetwork container_name

# REMOVE NETWORK
docker network rm mynetwork

# REMOVE ALL UNUSED NETWORKS
docker network prune

# RUN CONTAINER ON NETWORK
docker run --network mynetwork nginx
```

---

## Interview Questions & Answers

### Q1: What are Docker network types?

**Answer:** Four types:
1. **Bridge** - isolated network for containers (most common)
2. **Host** - uses host's network directly (performance)
3. **None** - no network (security/testing)
4. **Overlay** - multi-host network (Docker Swarm)

---

### Q2: Difference between default bridge and custom bridge?

**Answer:**
- **Default bridge:** No DNS, use IP addresses only
- **Custom bridge:** DNS enabled, use container names as hostnames ✅

Custom bridge is recommended for production.

---

### Q3: How do containers communicate?

**Answer:** Containers on the same network communicate using:
1. Container names as hostnames (custom bridge) ✅
2. IP addresses (any network)

Example: Container "api" connects to "db" using hostname "db".

---

### Q4: Difference between -p and --network?

**Answer:**
- **`-p`** (port mapping): Exposes container to host/external (host:container)
- **`--network`**: Connects containers for internal communication

`-p` = external access, `--network` = internal communication

---

### Q5: When to use host network?

**Answer:** Use when:
- Maximum performance needed (no NAT overhead)
- Network monitoring tools (need all interfaces)

Trade-off: No isolation, less secure.

---

### Q6: Can a container be on multiple networks?

**Answer:** Yes!
```bash
docker network connect network1 container
docker network connect network2 container
```

Useful for isolation (e.g., backend on both frontend and database networks).

---

### Q7: How does Docker Compose handle networks?

**Answer:** Docker Compose automatically creates a default network for all services. Services communicate using service names. Can also define custom networks for isolation.

---

### Q8: What is network isolation?

**Answer:** Containers on different networks can't communicate by default. Provides security - e.g., frontend and database on separate networks with only backend bridging them.

---

## Best Practices

### ✅ DO:
- Use **custom bridge** networks (not default)
- Use **container names** as hostnames
- Create **separate networks** for different tiers
- Name networks clearly (`app-frontend`, `app-backend`)
- Remove unused networks (`docker network prune`)

### ❌ DON'T:
- Use default bridge in production
- Use host network (unless needed)
- Put all containers on one network (security risk)
- Expose database to frontend network

---

## Common Mistakes

### ❌ Wrong: Default bridge
```bash
docker run --name api node:18
docker run --name db postgres
# Must use IP addresses! ❌
```

### ✅ Right: Custom bridge
```bash
docker network create mynet
docker run --name api --network mynet node:18
docker run --name db --network mynet postgres
# Use names: api connects to "db" ✅
```

---

### ❌ Wrong: Single network for all
```bash
docker network create app
docker run --network app frontend
docker run --network app database
# Frontend can directly access database! (security risk)
```

### ✅ Right: Isolated networks
```bash
docker network create frontend-net
docker network create backend-net

docker run --network frontend-net frontend
docker run --network frontend-net --network backend-net backend
docker run --network backend-net database
# Frontend can't reach database! ✅
```

---

## Key Takeaways

1. **Custom bridge** > Default bridge (DNS enabled!)
2. **Container names** = Hostnames (in custom bridge)
3. **`-p`** = External, **`--network`** = Internal
4. **Multiple networks** = Better isolation/security
5. **Docker Compose** auto-creates networks
6. **Always use custom bridge in production!**

---

**Total: ~290 lines - Interview ready!** 🎯
