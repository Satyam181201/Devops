# Docker Networks - Quick Notes 🚀

**Short notes for interview prep!**

---

## The Problem

**Containers need to communicate with each other!**

```bash
# Container 1: Backend API
# Container 2: Database
# How do they talk? → Docker Networks!
```

---

## What is Docker Network?

**Docker Network** = Virtual network that allows containers to communicate

By default:
- Containers are isolated
- Can't talk to each other
- Need a network to connect them

---

## Network Types (4 Types)

| Type | Description | Use Case |
|------|-------------|----------|
| **bridge** | Default, isolated network | Most common (multi-container apps) |
| **host** | Use host's network directly | High performance needed |
| **none** | No network, isolated | Security, testing |
| **overlay** | Multi-host network | Docker Swarm, Kubernetes |

---

## 1. Bridge Network (Default & Most Used)

### What:
- Default network type
- Containers on same bridge can communicate
- Isolated from host and other networks

### Create & Use:
```bash
# Create network
docker network create mynetwork

# Run containers on network
docker run -d --name web --network mynetwork nginx
docker run -d --name api --network mynetwork node:18

# web can ping api by name!
docker exec web ping api
```

### Default Bridge vs Custom Bridge:

| Feature | Default Bridge | Custom Bridge |
|---------|----------------|---------------|
| **Name** | `bridge` | Your choice |
| **DNS** | No (use IP) | Yes (use container name) ✅ |
| **Isolation** | All containers | Only attached containers |
| **Recommended** | No ❌ | Yes ✅ |

**Always create custom bridge networks!**

---

## 2. Host Network

### What:
Container uses host's network directly (no isolation)

### Use:
```bash
docker run --network host nginx
# Container uses host's ports directly
# No need for -p flag
```

### Pros:
✅ Best performance (no NAT overhead)  
✅ Access all host ports  

### Cons:
❌ No isolation  
❌ Port conflicts  
❌ Less secure  

**Use case:** High-performance applications, monitoring tools

---

## 3. None Network

### What:
No network, completely isolated

### Use:
```bash
docker run --network none alpine
# Container has no network access
```

**Use case:** Security testing, batch processing

---

## 4. Overlay Network

### What:
Multi-host network (containers on different servers communicate)

**Use case:** Docker Swarm, Kubernetes (not for single-host Docker)

---

## Quick Comparison

| Network Type | Container-to-Container | Container-to-Internet | Use DNS |
|--------------|------------------------|----------------------|---------|
| **bridge (custom)** | ✅ Yes | ✅ Yes | ✅ Yes |
| **bridge (default)** | ✅ Yes (IP only) | ✅ Yes | ❌ No |
| **host** | N/A | ✅ Yes | N/A |
| **none** | ❌ No | ❌ No | ❌ No |

---

## Real Examples

### Example 1: Web App + Database (Bridge)

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

# webapp can connect to postgres using hostname "postgres"
# Connection string: postgresql://postgres:5432/db
```

---

### Example 2: Multiple Containers Communicating

```bash
# Create network
docker network create backend

# Frontend (Nginx)
docker run -d --name frontend --network backend -p 80:80 nginx

# Backend API (Node.js)
docker run -d --name api --network backend node:18

# Database (MySQL)
docker run -d --name db --network backend mysql:8

# Communication:
# frontend → api (by name "api")
# api → db (by name "db")
```

---

### Example 3: Connect Running Container to Network

```bash
# Container already running
docker run -d --name app1 nginx

# Create network
docker network create mynet

# Connect container to network
docker network connect mynet app1

# Now app1 is on mynet!
```

---

## Docker Compose with Networks

### Automatic Network:
```yaml
version: '3.8'
services:
  web:
    image: nginx
  api:
    image: node:18
  db:
    image: postgres

# Docker Compose creates network automatically!
# web, api, db can talk using service names
```

### Custom Networks:
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

## DNS Resolution (Container Name as Hostname)

**In custom bridge networks, use container names as hostnames:**

```bash
# Create network
docker network create mynet

# Run containers
docker run -d --name db --network mynet postgres
docker run -d --name api --network mynet node:18

# Inside api container:
ping db              # Works! ✅
curl http://db:5432  # Works! ✅

# In default bridge:
ping db              # Fails! ❌ (need IP address)
```

**This is why custom bridge > default bridge!**

---

## Port Mapping vs Networks

### Port Mapping (`-p`):
**Host → Container** (external access)
```bash
docker run -p 8080:80 nginx
# Access from browser: localhost:8080
```

### Networks:
**Container → Container** (internal communication)
```bash
docker network create mynet
docker run --network mynet --name web nginx
docker run --network mynet --name api node:18
# api can access web internally (no -p needed)
```

**Both together:**
```bash
docker run -d \
  --name api \
  --network mynet \
  -p 8080:8080 \     # External: localhost:8080
  myapp

# External: localhost:8080
# Internal (from other containers): http://api:8080
```

---

## Commands Reference

```bash
# LIST NETWORKS
docker network ls

# CREATE NETWORK
docker network create mynetwork
docker network create --driver bridge mynetwork

# INSPECT NETWORK
docker network inspect mynetwork

# CONNECT CONTAINER TO NETWORK
docker network connect mynetwork container_name

# DISCONNECT CONTAINER FROM NETWORK
docker network disconnect mynetwork container_name

# REMOVE NETWORK
docker network rm mynetwork

# REMOVE ALL UNUSED NETWORKS
docker network prune

# RUN CONTAINER ON NETWORK
docker run --network mynetwork image

# RUN WITH NETWORK ALIAS
docker run --network mynet --network-alias db postgres
```

---

## Interview Questions & Answers

### Q1: What are Docker network types?

**Answer:** Four types: 
1. **Bridge** (default) - isolated network for containers on same host
2. **Host** - container uses host's network directly  
3. **None** - no network, completely isolated
4. **Overlay** - multi-host network for Docker Swarm

Bridge is most commonly used for multi-container applications.

---

### Q2: Difference between default bridge and custom bridge?

**Answer:** 
- **Default bridge:** Containers communicate using IP addresses only, no automatic DNS
- **Custom bridge:** Containers can use container names as hostnames (DNS enabled), better isolation

Custom bridge is recommended for production.

---

### Q3: How do containers communicate with each other?

**Answer:** Containers on the same Docker network can communicate using:
1. Container names as hostnames (custom bridge)
2. IP addresses (any network)
3. Network aliases

Example: Container "api" can connect to "db" using hostname "db" if both are on same custom network.

---

### Q4: What is the difference between -p and --network?

**Answer:**
- **`-p` (port mapping):** Exposes container port to host/external world (host:container)
- **`--network`:** Connects container to a network for container-to-container communication

`-p` is for external access, `--network` is for internal communication between containers.

---

### Q5: When would you use host network?

**Answer:** Use host network when:
- Need maximum network performance (no NAT overhead)
- Running network monitoring tools (need access to all interfaces)
- Legacy apps that bind to specific host ports

Trade-off: Less isolation and security. Not recommended for most applications.

---

### Q6: How to connect two running containers?

**Answer:**
```bash
# Create network
docker network create mynet

# Connect both containers
docker network connect mynet container1
docker network connect mynet container2

# Now they can communicate!
```

---

### Q7: Can a container be on multiple networks?

**Answer:** Yes! A container can be connected to multiple networks simultaneously:
```bash
docker network connect network1 container
docker network connect network2 container
```

This allows different communication paths for different services.

---

### Q8: What happens to network when all containers stop?

**Answer:** The network persists even when all containers stop. Networks are independent resources and must be explicitly removed with `docker network rm` or `docker network prune`.

---

### Q9: How does Docker Compose handle networks?

**Answer:** Docker Compose automatically creates a default network for all services in the compose file. Services can communicate using service names as hostnames. You can also define custom networks for better isolation between service groups.

---

### Q10: What is network isolation?

**Answer:** Containers on different networks cannot communicate with each other by default. This provides security isolation - for example, frontend and database can be on separate networks with only backend connecting to both, preventing direct frontend-to-database access.

---

## Common Patterns

### Pattern 1: Frontend-Backend-Database
```bash
# Create networks
docker network create frontend
docker network create backend

# Frontend (public)
docker run -d --name web --network frontend -p 80:80 nginx

# API (both networks - bridge between frontend and backend)
docker run -d --name api --network frontend node:18
docker network connect backend api

# Database (private)
docker run -d --name db --network backend postgres

# Result: web → api → db (web can't reach db directly!)
```

### Pattern 2: Microservices
```bash
docker network create microservices

docker run -d --name auth --network microservices auth-service
docker run -d --name users --network microservices user-service
docker run -d --name orders --network microservices order-service

# All microservices can communicate using service names
```

---

## Inspect Network Details

```bash
# See which containers are on a network
docker network inspect mynetwork

# Output shows:
# - Network ID
# - Driver type
# - Connected containers
# - IP addresses
# - Gateway
```

---

## Best Practices

### ✅ DO:
- Use **custom bridge networks** (not default)
- Use **container names** as hostnames
- Create **separate networks** for different tiers (frontend, backend, database)
- Use **network aliases** for load balancing
- **Name your networks** clearly (e.g., "app-backend", "app-frontend")

### ❌ DON'T:
- Use default bridge network in production
- Use host network unless absolutely necessary
- Connect all containers to same network (security risk)
- Expose database directly to frontend network
- Forget to remove unused networks (`docker network prune`)

---

## Common Mistakes

### ❌ Wrong: Using default bridge
```bash
docker run -d --name api node:18
docker run -d --name db postgres
# Can't use names, need IP addresses!
```

### ✅ Right: Custom bridge
```bash
docker network create mynet
docker run -d --name api --network mynet node:18
docker run -d --name db --network mynet postgres
# Can use names: api connects to "db"
```

---

### ❌ Wrong: All containers on one network
```bash
docker network create app
docker run --network app frontend
docker run --network app backend
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
# Frontend can't reach database directly!
```

---

## Troubleshooting

### Container can't connect to another container:

**Check 1:** Are they on same network?
```bash
docker network inspect mynetwork
```

**Check 2:** Can you ping by name?
```bash
docker exec container1 ping container2
```

**Check 3:** Is it a custom bridge (not default)?
```bash
docker network ls
```

**Fix:** Connect to same custom network
```bash
docker network connect mynetwork container1
```

---

## Key Takeaways

1. **Bridge networks** = Most common (container communication)
2. **Custom bridge** > Default bridge (has DNS!)
3. **Container names** = Hostnames (in custom bridge)
4. **`-p`** = External access, **`--network`** = Internal communication
5. **Multiple networks** = Isolation (security)
6. **Docker Compose** = Auto-creates networks
7. **Always use custom bridge networks in production!**

---

**That's it! Short, focused, interview-ready!** 🎯
