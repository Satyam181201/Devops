# Docker Compose - Quick Interview Notes 🚀

---

## What is Docker Compose?

**Docker Compose** = Run multi-container apps with one command

**Problem:**
```bash
docker run -d --name db postgres
docker run -d --name api -e DB_HOST=db node:18
docker run -d -p 80:80 nginx
# Too many commands! ❌
```

**Solution:**
```yaml
# docker-compose.yml
services:
  db:
    image: postgres
  api:
    image: node:18
  web:
    image: nginx
```
```bash
docker compose up    # Start all! ✅
docker compose down  # Stop all!
```

---

## Compose vs Kubernetes

| Feature | Compose | Kubernetes |
|---------|---------|------------|
| **Scope** | Single host | Multiple hosts |
| **Use** | Local dev, CI | Production clusters |
| **Complexity** | Simple | Complex |
| **Scaling** | No | Yes |

**Rule:** Compose for dev, Kubernetes for production

---

## docker-compose.yml Structure

```yaml
version: "3.9"

services:                    # Containers
  app:
    build: .                 # Build from Dockerfile
    ports:
      - "8080:8080"          # host:container
    environment:             # Env vars
      - DB_HOST=db
      - DB_PASSWORD=${DB_PASSWORD}  # From .env
    depends_on:              # Start order
      - db
  
  db:
    image: postgres:13
    volumes:
      - db-data:/var/lib/postgresql/data

volumes:
  db-data:                   # Persist data
```

---

## Service Communication (DNS)

**Containers talk using service names:**

```yaml
services:
  api:
    image: node:18
  db:
    image: postgres
```

**Inside api container:**
```bash
ping db                      # Works! ✅
psql -h db -U postgres       # Connect using "db" as hostname
```

**Connection string:**
```
postgresql://db:5432/mydb
# NOT localhost!
```

---

## Real Example

```yaml
version: "3.9"

services:
  web:
    image: nginx:alpine
    ports:
      - "80:80"
    depends_on:
      - api
  
  api:
    build: ./backend
    environment:
      - DB_HOST=db
      - DB_PASSWORD=${DB_PASSWORD}
    depends_on:
      - db
  
  db:
    image: postgres:13
    environment:
      - POSTGRES_PASSWORD=${DB_PASSWORD}
    volumes:
      - postgres-data:/var/lib/postgresql/data

volumes:
  postgres-data:
```

**.env file:**
```
DB_PASSWORD=secret123
```

---

## Commands

```bash
# START
docker compose up              # Foreground
docker compose up -d           # Background
docker compose up --build      # Rebuild + start

# STATUS
docker compose ps              # Running services
docker compose logs -f api     # Follow logs

# EXECUTE
docker compose exec api sh     # Shell into service

# STOP
docker compose down            # Stop + remove containers
docker compose down -v         # + remove volumes (wipes data!)

# RESTART
docker compose restart api     # Restart one service
```

---

## Volumes

### Named Volume (Persist Data):
```yaml
volumes:
  - db-data:/var/lib/mysql
```
- For databases, uploads
- Survives `docker compose down`
- Docker manages location

### Bind Mount (Live Development):
```yaml
volumes:
  - ./src:/app/src
```
- For live code editing
- Maps host folder to container
- Changes reflect immediately

---

## Best Practices

1. **Use .env for secrets:** `DB_PASSWORD=${DB_PASSWORD}` not hardcoded
2. **Don't expose unnecessary ports:** Database internal only
3. **Specific versions:** `postgres:13.8` not `latest`
4. **Health checks:** Verify service is ready
5. **`.dockerignore`:** Keep build context small

---

## Interview Questions

### Q1: What is Docker Compose?

**Answer:** Tool for running multi-container apps. Define services in `docker-compose.yml`, start with `docker compose up`. Used for local dev, CI, simple deployments.

---

### Q2: Compose vs Kubernetes?

**Answer:**
- **Compose:** Single host, local dev, simple
- **Kubernetes:** Multiple hosts, production, auto-scaling, self-healing

Same concepts (services, DNS, declarative), different scale.

---

### Q3: How do containers communicate in Compose?

**Answer:** Compose creates a network and provides DNS. Containers reach each other using **service names as hostnames**. Example: `api` connects to `db` using hostname "db".

---

### Q4: What is `depends_on`?

**Answer:** Controls **start order only**, not "wait until ready". Example: `depends_on: [db]` starts database first, but app may need retry logic because DB takes time to be ready.

---

### Q5: Named volumes vs bind mounts?

**Answer:**
- **Named volume:** Docker-managed, persists data, for databases. Example: `db-data:/var/lib/mysql`
- **Bind mount:** Maps host folder, for live code editing. Example: `./src:/app/src`

---

### Q6: How to handle secrets?

**Answer:** Use `.env` file and reference with `${VAR}`, never hardcode. Add `.env` to `.gitignore`.

---

### Q7: What happens with `docker compose down -v`?

**Answer:**
- `docker compose down` removes containers, keeps volumes
- `docker compose down -v` removes containers AND volumes (data wiped!)

---

### Q8: `docker-compose` vs `docker compose`?

**Answer:**
- `docker-compose` (hyphen): Old v1, deprecated
- `docker compose` (space): New v2, current standard

---

## Common Mistakes

1. **Using `localhost`:** Use service name (`db`) not `localhost`
2. **Hardcoding secrets:** Use `.env` file, add to `.gitignore`
3. **Assuming `depends_on` waits:** Add retry logic or healthcheck
4. **Losing data:** Use named volumes, avoid `down -v`

---

## Key Takeaways

1. **Compose** = Multi-container apps in one file
2. **Service names** = Hostnames (DNS)
3. **`depends_on`** = Start order only
4. **Named volumes** = Persist data
5. **`.env`** = Store secrets
6. **Don't expose** unnecessary ports
7. **v2 (`docker compose`)** is current

---

**~280 lines - Interview ready!** 🎯
