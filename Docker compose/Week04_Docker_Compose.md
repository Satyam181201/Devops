# Week 4 (Nov 2 - 8) - Docker Compose + production basics

Week 3 ran one container. Real apps are never one container - they're your app **plus** a database, maybe a cache, maybe a message queue. This week you learn to run a **multi-container app with one command** using Docker Compose, and you learn the **production hygiene** that separates a toy image from a shippable one: non-root users, small images, env config, logging, `.dockerignore`. This is also the mental bridge to Kubernetes - Compose teaches the same ideas (services, networking, config) in a simpler form.

Same rule: **type and run everything.** You need Docker Desktop (Compose is included).

---

## Videos to watch this week
1. **TechWorld with Nana - "Docker Compose Tutorial"** (part of her Docker course). Look for: services, `depends_on`, networks, volumes.
2. **Abhishek Veeramalla - Docker (multi-container / compose day)** - real example wiring an app to a DB.
3. (Optional) **Bret Fisher - Compose and image-size/security videos** - non-root, slim images.

Rule: ~1 hour video, then build the app+DB stack in the labs.

---

## Why Docker Compose exists - the evolution (read once)

**The problem after Week 3:** once you have more than one container, running them by hand is painful. You'd `docker run` the database, then `docker run` the app with the right `-p`, `-e` env vars, `--network`, in the right order, every single time. Miss a flag and it breaks. Tear it down and you repeat the whole dance. It's not repeatable and it's not shareable - the exact same "pet vs cattle" problem containers were supposed to fix, just one level up.

**The fix: Docker Compose.** You describe the **whole stack** - app, database, cache, their ports, env vars, volumes, and how they network together - in one `docker-compose.yml` file. Then `docker compose up` starts all of it, wired correctly, in one command, and `docker compose down` tears it all down. The file lives in Git, so the stack is reproducible and reviewable. Compose is "infrastructure as a file" for your local/single-host multi-container app.

**Where it sits vs Kubernetes (important for interviews):** Compose is for **a single host** - great for local dev, small deployments, and CI. Kubernetes is for **a cluster** - many machines, self-healing, autoscaling, rolling updates. They share the same concepts (a "service", config, networking between services), which is exactly why Compose is the perfect stepping stone before Week 8's Kubernetes. The idea you learn here - "declare the desired state of my app in YAML, let the tool make it so" - is the whole philosophy of Kubernetes.

**Is it still current?** Yes for local dev, CI, and simple multi-container setups - extremely common. For production microservices at scale, the industry moved to Kubernetes (which is exactly where your work runs - EKS). So the honest framing is: "Compose for local/dev and simple hosts; Kubernetes for production clusters." Also note: the old `docker-compose` (hyphen, Python v1) is superseded by `docker compose` (space, the v2 plugin) - mention v2 if asked.

*Plain English:* Running containers by hand is like starting every appliance in your kitchen separately and plugging them into the right sockets each morning. Compose is a single "kitchen on" switch described in a checklist - flip it and the fridge, oven, and lights all come up correctly wired, every time.

---

## Docker Compose - the file explained

`docker-compose.yml` for a Spring Boot app + MySQL:
```yaml
version: "3.9"                     # compose file format version
services:                          # each service = one container (or more)
  app:
    build: .                       # build from the Dockerfile in this folder
    ports:
      - "8080:8080"                # host:container
    environment:                   # env vars passed into the container
      - SPRING_DATASOURCE_URL=jdbc:mysql://db:3306/tasks
      - SPRING_DATASOURCE_USERNAME=root
      - SPRING_DATASOURCE_PASSWORD=${DB_PASSWORD}   # from .env, not hardcoded
    depends_on:
      - db                         # start db before app (ordering, not readiness)
  db:
    image: mysql:8                 # use a prebuilt image
    environment:
      - MYSQL_ROOT_PASSWORD=${DB_PASSWORD}
      - MYSQL_DATABASE=tasks
    volumes:
      - db-data:/var/lib/mysql     # persist data outside the container
    ports:
      - "3306:3306"

volumes:
  db-data:                         # named volume, survives container restarts
```
**Explanation:**
- `services:` - each key (`app`, `db`) is one container. Compose creates a shared network so they can reach each other **by service name** - the app connects to the DB at host `db`, not an IP. (That service-name DNS is exactly how Kubernetes works too.)
- `build: .` vs `image:` - build your own from a Dockerfile, or pull a ready-made image.
- `environment:` - config via env vars (12-factor style). Secrets come from a `.env` file via `${VAR}`, never hardcoded.
- `depends_on:` - controls **start order**, not "wait until ready." The app may still need retry logic because the DB takes time to accept connections (common gotcha).
- `volumes:` - a **named volume** persists the DB's data on the host, so `docker compose down` + `up` doesn't wipe your database.

**Commands:**
```bash
docker compose up            # start the whole stack (foreground)
docker compose up -d         # detached (background)
docker compose ps            # what's running
docker compose logs -f app   # follow one service's logs
docker compose exec app sh   # shell into the app container
docker compose down          # stop and remove containers + network
docker compose down -v       # also remove the named volumes (wipes data)
docker compose up --build    # rebuild images then start
```

### Volumes vs bind mounts
- **Named volume** (`db-data:`) - Docker manages it; best for databases/persistent data.
- **Bind mount** (`./code:/app`) - maps a host folder into the container; best for live-editing code in dev.
- **Why it matters:** containers are ephemeral - their writable layer is lost on removal. Anything you must keep (DB files, uploads) goes in a volume.

### Networking in Compose
Compose puts all services on one network; they reach each other by **service name** as the hostname (`db`, `app`). You only publish (`ports:`) the ones the outside world needs (usually just the app). Internal services (the DB) often don't need a published port at all - a security improvement.

---

## Production basics - what makes an image shippable

This is the "production basics" half of the week and a rich interview area.

### 1. Run as non-root
By default the process in a container runs as **root** - if someone breaks out, they're root on a shared kernel. Add a user:
```dockerfile
RUN addgroup -S app && adduser -S app -G app
USER app
```
Now the app runs unprivileged. Interviewers ask this a lot: "why non-root?" - least privilege, smaller blast radius.

### 2. Small, minimal base images
Smaller image = faster pulls on every deploy + fewer packages = smaller attack surface. Prefer `-alpine` or `-slim` or distroless, and use multi-stage (Week 3) to drop build tools.

### 3. `.dockerignore`
Like `.gitignore`, but for the Docker build context. Stops you from copying junk (and secrets) into the image:
```
target/           # if you copy the prebuilt jar, you may still want to exclude build caches
.git
.env
*.md
node_modules
```
Benefits: faster builds (smaller context sent to the daemon) and no accidental secret leaks.

### 4. Config via environment variables (12-factor)
Don't bake config into the image. Pass DB URLs, credentials, feature flags as **env vars** at runtime. Same image runs in dev/preprod/prod with different env - exactly how your work does it (env vars set per environment in the Kustomize overlay).

### 5. Logging to stdout/stderr
A container should log to stdout/stderr, not to a file inside the container. The platform (Docker, Kubernetes) collects stdout. Writing to a file inside an ephemeral container loses logs when it dies.

### 6. Health checks
Tell the platform how to know the app is actually ready, not just "process started":
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s CMD curl -f http://localhost:8080/health || exit 1
```
In Kubernetes this becomes liveness/readiness probes (Week 9) - and your prod overlays already set `readinessProbe`/`livenessProbe` initial delays.

---

## Map it to YOUR work (so you can answer "how do you handle multi-service / config / prod hardening?")

Your platform doesn't use Compose in production (it's Kubernetes on EKS), so be precise and honest - Compose maps to the *concepts*, EKS is the *reality*:

- **Multi-service wiring:** "In production our services find each other by **Kubernetes service DNS** - e.g. `customer-service-customers-fetch-graphql.customer-main.svc.cluster.local:8080`. Compose's 'reach a service by its name' is the same idea at single-host scale; EKS does it cluster-wide."
- **Config via env vars:** "We're 12-factor - config is injected as env vars per environment through our **Kustomize overlays** (DB/API URLs, OAuth client IDs, token URLs). Same image, different env per environment." (True - I've seen the `kustomization.yml` env patches.)
- **Secrets:** "Secrets like client secrets and JWT keys are injected as env vars at deploy time, not baked into the image - and never committed. AWS access is via **IRSA** (an IAM role annotated on the Kubernetes service account), so we don't ship AWS keys at all."
- **Persistence:** "Stateful data lives outside the container - managed data stores, not the container filesystem - the same reason Compose uses named volumes."
- **Hardening:** "Our Java Dockerfile pre-creates directories specifically so the container can run with a **read-only root filesystem** - that's the non-root / least-privilege mindset in practice."
- **Health:** "Our deployments set readiness and liveness probes (with tuned initial delays) so Kubernetes only sends traffic when the service is actually up - the production version of a Docker HEALTHCHECK."

**How to say it in an interview:**
> "We don't use Compose in prod - we're on EKS - but the concepts carry over: services discover each other by DNS name, config and secrets are injected as env vars per environment via Kustomize (never baked into images), AWS auth is via IRSA so there are no static keys in the image, and readiness/liveness probes gate traffic. I use Compose locally to stand up an app plus its dependencies quickly."

**Honest improvement point:** "A local `docker-compose.yml` to run a service with its dependencies would speed up onboarding/dev - something I'd add."

---

## Hands-on labs (do these)

- **Lab 1:** Write a `docker-compose.yml` that runs your Spring Boot `TaskManager` + a MySQL (or Postgres) container. `docker compose up` and hit the app. Confirm the app connects to the DB **by service name**, not an IP.
- **Lab 2:** Add a **named volume** to the DB. `docker compose down`, `up` again, and prove the data survived.
- **Lab 3:** Move the DB password into a `.env` file and reference it with `${DB_PASSWORD}`. Confirm no secret is in `docker-compose.yml` or the image.
- **Lab 4:** Add a `.dockerignore`. Rebuild and note the build context got smaller (and `.git`/`.env` aren't in the image).
- **Lab 5:** Add a non-root `USER` to your Dockerfile. Rebuild, `docker compose exec app whoami` - confirm it's not root.
- **Lab 6:** Add a `HEALTHCHECK` to the app image (or a `healthcheck:` block in compose). Watch `docker compose ps` show `healthy`.
- **Lab 7:** Shrink the image - multi-stage + alpine/slim base - and record the before/after size. Target under ~200MB.

### This week's deliverable
App + database running via **Docker Compose**, image **under ~200MB**, a `README.md` with a short **architecture description** (what the services are and how they connect). That's the Week 4 "done" marker - tick the roadmap.

---

## Common mistakes - and fixes
- **App can't reach DB** - you used `localhost` instead of the **service name** (`db`). Inside Compose, `localhost` is the container itself.
- **`depends_on` isn't "wait until ready"** - it only orders startup. Add connection retry in the app, or a healthcheck + `condition: service_healthy`.
- **Data disappears on `down`** - no volume, or you ran `down -v`. Use a named volume and avoid `-v` unless you mean to wipe.
- **Secrets in the compose file or image** - use a `.env` + `${VAR}`, and `.dockerignore` the `.env`.
- **Publishing ports you don't need** - don't expose the DB's `3306` to the host in prod-like setups; keep internal services internal.
- **Running as root** - add a `USER`; interviewers notice.
- **Huge images** - forgot multi-stage; build tools shipped to runtime.

---

## Experienced-level Q&A (2 YOE, not fresher)

- **Q: When do you use Docker Compose vs Kubernetes?**
  "Compose for a single host - local dev, CI, simple multi-container setups - because it's one file and one command. Kubernetes for production at scale, where you need self-healing, autoscaling, rolling updates across many nodes. They share concepts - services discovered by name, config as env, declared desired state - which is why Compose is a good mental warm-up. Our production is EKS; I'd reach for Compose locally."

- **Q: How do containers in a stack talk to each other, and how is that different in prod?**
  "In Compose they share a network and resolve each other by service name as the hostname - the app connects to `db`, not an IP. In our EKS setup it's the same idea via Kubernetes service DNS, e.g. a service reaching a GraphQL backend at its `*.customer-main.svc.cluster.local:8080` name. Name-based discovery means I never hardcode IPs."

- **Q: How do you handle configuration and secrets across environments?**
  "Twelve-factor: the image is identical across environments, and config comes in as env vars at runtime. On our platform that's done per environment through Kustomize overlays - DB URLs, API URLs, OAuth client IDs. Secrets are injected as env vars at deploy, never baked into the image or committed, and AWS access uses IRSA - an IAM role on the service account - so there are no static cloud keys in the image."

- **Q: Why run a container as non-root, and have you done it?**
  "Least privilege - if the process is compromised, you don't want it running as root on a shared kernel. In practice our Java Dockerfile pre-creates the directories the app needs so it can run on a read-only root filesystem, which is the same hardening mindset. Adding an explicit non-root `USER` is a standard step I'd make sure is in place."

- **Q: A DB-backed app works locally but the container can't connect to the DB. Debug it.**
  "Check the hostname first - inside a container `localhost` is the container, so it must use the DB's service name. Then check the DB is actually accepting connections, not just started - `depends_on` orders startup but doesn't wait for readiness, so I'd confirm with a healthcheck or retry. Then env vars - right URL, user, password from `.env`. I'd `compose logs db` and `compose exec app` to test connectivity from inside."

- **Q: How do you keep images production-ready?**
  "Small base (alpine/slim/distroless) + multi-stage so build tools don't ship, non-root user, `.dockerignore` to keep junk and secrets out, config via env not baked in, log to stdout, and a health check. Smaller, least-privilege images pull faster and have a smaller attack surface."

### "Said as a 2 YOE candidate" - phrasing bank
- "Services talk by name - `db` in Compose, service DNS in our EKS cluster - never hardcoded IPs."
- "Same image everywhere; config and secrets come in as env vars per environment via Kustomize."
- "AWS access is IRSA - a role on the service account - so no static keys live in the image."
- "Our Java containers are set up to run read-only - that's the non-root hardening mindset in practice."
- "Readiness/liveness probes gate traffic in prod - the real version of a Docker HEALTHCHECK."

---

## Cheat sheet
```yaml
# docker-compose.yml essentials
services:
  app:
    build: .
    ports: ["8080:8080"]
    environment: ["KEY=${KEY}"]      # from .env, not hardcoded
    depends_on: [db]                 # start order only
  db:
    image: mysql:8
    volumes: ["db-data:/var/lib/mysql"]
volumes:
  db-data:
```
```bash
docker compose up -d        # start stack (detached)
docker compose ps           # status
docker compose logs -f app  # follow a service's logs
docker compose exec app sh  # shell into a service
docker compose down         # stop + remove (keep volumes)
docker compose down -v      # also wipe volumes
docker compose up --build   # rebuild then start
```
```dockerfile
# production hardening in the Dockerfile
RUN addgroup -S app && adduser -S app -G app
USER app                                   # non-root
HEALTHCHECK --interval=30s CMD curl -f http://localhost:8080/health || exit 1
# + .dockerignore (.git .env target node_modules)
# + multi-stage + alpine/slim base for small images
# + config via ENV at runtime, log to stdout
```

---

Next week: **CI/CD with GitHub Actions** (`Week05_CICD_GitHub_Actions.md`) - automate build/test/push on every commit. That's where exit codes (Week 2) and images (Week 3-4) come together into a pipeline. Finish the Week 4 deliverable and tick the roadmap first.
