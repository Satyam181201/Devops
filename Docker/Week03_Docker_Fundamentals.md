# Week 3 (Oct 26 - Nov 1) - Docker Fundamentals

This is where DevOps gets real. Everything after this week - CI/CD, Kubernetes, Argo CD - is built on containers. The goal this week: understand what a container actually is, write Dockerfiles, and get your Spring Boot app running in a container and pushed to a registry. You already *use* Docker at work (your services ship as images in ECR); this week turns "I've seen it" into "I can explain and defend it."

Same rule: **type every command and run it.** Install **Docker Desktop** first (Windows, WSL2 backend).

---

## Videos to watch this week
1. **TechWorld with Nana - "Docker Tutorial for Beginners"** (the ~1 hr crash course). Look for: image vs container, layers, Dockerfile, volumes.
2. **Abhishek Veeramalla - Docker (Day 1-2 of his DevOps playlist)** - Indian-context, real Dockerfile walkthroughs. Look for: multi-stage builds and why image size matters.
3. (Optional) **Bret Fisher - "Docker Mastery" free intro videos** - deeper on networking and volumes.

Rule: ~1 hour video, then build. The labs below are the real learning.

---

## Why Docker exists - the evolution (read once, this is a top interview topic)

**The old world: bare metal and "works on my machine."** Apps ran directly on physical servers. The app needed Java 8, a specific OpenSSL, certain env vars, a truststore in the right place. You set all that up by hand on each server. Move the app to another server and one tiny difference - a library version, a missing cert - broke it. The developer said "works on my machine," ops said "not in prod," and nobody could reproduce the exact environment.

**First fix: Virtual Machines (VMs).** VMware/VirtualBox/EC2 let you run a whole guest OS on top of a host. This gave isolation - each app got its own "machine." But a VM is **heavy**: it ships an entire operating system (GBs), takes minutes to boot, and you can only fit a few on a server. Packaging an app as a VM image worked but was slow and wasteful.

**The breakthrough: containers (Docker, 2013).** A container packages your app **plus its exact dependencies** into an image, but it does NOT ship a full OS - it shares the host machine's Linux kernel. So it's tiny (MBs not GBs), starts in milliseconds, and you can run dozens on one host. Crucially, the image is **identical** on your laptop, the CI runner, and production. That killed "works on my machine" - the image *is* the environment, frozen and shippable.

**One-line comparison to say in an interview:**
> "A VM virtualizes the hardware and ships a whole OS; a container virtualizes the OS and shares the host kernel. So containers are lighter, faster to start, and give you the same environment everywhere - which is why they became the unit of deployment for microservices."

**Is it still current?** Yes - containers are the foundation of modern DevOps. One nuance interviewers like: "Docker" now means two things - the *image format/runtime* (standardized as OCI) and the *Docker company's tooling*. Kubernetes dropped the Docker *runtime* (dockershim) in favor of containerd, but it still runs the same OCI *images* you build with Docker. So "Docker images" are more alive than ever; the low-level runtime just got swapped underneath.

*Plain English (the apartment analogy):* A physical server is a house. A **VM** is building a separate full house for each family - own kitchen, own plumbing, own everything (safe but expensive and slow to build). A **container** is an apartment in one building - each family has its own locked, private space, but they share the building's foundation and plumbing (the host kernel). Much cheaper, much faster to move into, and every apartment is built from the same blueprint (the image).

---

## Core concepts (know these cold)

### Image vs Container
- **Image** = the blueprint / frozen snapshot. Read-only. Built from a Dockerfile. Stored in a registry (Docker Hub, or your ECR). Example: `openjdk:17-alpine` + your jar.
- **Container** = a running instance of an image. You can start many containers from one image. It's the image brought to life, with a writable layer on top.

*Analogy:* Image is a class, container is an object. Or: image is the recipe, container is the cooked dish - one recipe, many dishes.

### Layers
A Docker image is built in **layers** - each instruction in a Dockerfile (`FROM`, `RUN`, `COPY`) adds a layer. Layers are cached and shared: if you rebuild and only your code changed, Docker reuses the cached base layers and only rebuilds from the changed step down. This is why **order matters** in a Dockerfile (put rarely-changing steps first).

### Registry
Where images live so others (and your cluster) can pull them. Public: Docker Hub. Private: AWS ECR (your work uses `286694495060.dkr.ecr.us-east-1.amazonaws.com`), GitHub Container Registry, etc.

### Docker architecture (one diagram in words)
- **Docker CLI** (`docker ...`) talks to the **Docker daemon** (`dockerd`).
- The daemon builds images, runs containers, and pulls/pushes to **registries**.
- Containers run as isolated processes on the host kernel using Linux namespaces (isolation) and cgroups (resource limits).

---

## Essential commands (run every one)

```bash
# images
docker pull nginx                      # download an image from a registry
docker images                          # list local images
docker rmi nginx                       # remove an image

# run containers
docker run nginx                       # run in foreground
docker run -d nginx                    # -d = detached (background)
docker run -d -p 8080:80 nginx         # map host port 8080 -> container port 80
docker run -d --name web nginx         # give it a name
docker run -it ubuntu bash             # -it = interactive terminal, run a shell inside

# inspect / manage running containers
docker ps                              # running containers
docker ps -a                           # all containers (incl. stopped)
docker logs web                        # view a container's logs
docker logs -f web                     # follow logs live
docker exec -it web bash               # get a shell INSIDE a running container
docker stop web                        # stop
docker start web                       # start
docker rm web                          # remove (must be stopped)

# build your own image
docker build -t myapp:1.0 .            # build from Dockerfile in current dir, tag it
docker run -d -p 8080:8080 myapp:1.0   # run your image

# registry
docker login                           # authenticate to a registry
docker tag myapp:1.0 user/myapp:1.0    # tag for pushing
docker push user/myapp:1.0             # push to the registry

# cleanup (you WILL fill your disk)
docker system prune -a                 # remove unused images/containers/networks
```

**The three commands you'll use most in real debugging:** `docker logs`, `docker exec -it ... sh`, and `docker ps`. Memorize those - they're the same muscle as `kubectl logs` / `kubectl exec` later.

---

## Writing a Dockerfile - line by line

A Dockerfile is the recipe. Here's a minimal one for a Spring Boot jar:
```dockerfile
FROM openjdk:17-alpine          # base image: a tiny Linux with Java 17
WORKDIR /app                    # set working dir; everything after is relative to here
COPY target/app.jar app.jar     # copy the built jar into the image
EXPOSE 8080                     # document that the app listens on 8080
ENTRYPOINT ["java","-jar","app.jar"]   # the command that runs when the container starts
```
**Instruction cheat sheet:**
- `FROM` - the base image you build on. Always first.
- `WORKDIR` - sets/creates the working directory.
- `COPY` - copy files from your machine into the image. (`ADD` is similar but also does URLs/untar - prefer `COPY`.)
- `RUN` - execute a command **at build time** (install packages, build). Each `RUN` = a new layer.
- `EXPOSE` - documentation of the port; does NOT actually publish it (you still need `-p` at run).
- `ENV` - set an environment variable inside the image.
- `CMD` vs `ENTRYPOINT` - both define what runs when the container starts. `ENTRYPOINT` is the fixed command; `CMD` is the default arguments (and is easy to override at `docker run`). Common pattern: `ENTRYPOINT ["java","-jar","app.jar"]`.

### Multi-stage builds (the thing that impresses interviewers)
Problem: if you build your jar *inside* the image, the final image also carries Maven, the JDK, and build junk - huge. Solution: **build in one stage, copy only the result into a clean small stage.**
```dockerfile
# stage 1: build
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /src
COPY . .
RUN mvn clean package -DskipTests

# stage 2: runtime (small, no Maven)
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /src/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
```
- `AS build` names the first stage.
- `COPY --from=build` pulls just the jar out of the build stage.
- Result: the final image has only a JRE + your jar, not the whole build toolchain. This is how you take an image from ~500MB to ~180MB.

---

## Map it to YOUR work (so you can answer "what do you do with Docker in your job?")

You containerize real microservices. I've read two of your actual Dockerfiles - use them as your honest story:

**Your Node service (`customer-360-service/Dockerfile`):**
- Base `node:16-alpine` pulled from your **private ECR** (not Docker Hub) - "we proxy base images through ECR."
- `WORKDIR /usr/src/app`, `COPY src/ .`, `npm install`, `CMD ["node","index.js"]`.
- Talking point: "It's a straightforward single-stage Node image; the base comes from our ECR, and the container just runs `node index.js`."

**Your Java service (`customer-manage-service-profile/Dockerfile`) - richer story:**
- Base `openjdk:17-alpine` from ECR; installs `curl`, `openssl`, `ca-certificates`, even `awscli` via `apk`.
- `COPY target/*.jar run.jar` - so the jar is built by the CI/Make step first, then copied in.
- Pulls **truststores from S3** at build (`aws s3 cp ... trustStore/`) and runs `c_rehash` - for MQ/Kafka TLS.
- Sets `LD_LIBRARY_PATH`, drops a native lib (`libvibesimplejava.so`) into `/usr/lib`.
- Comment in the file notes directories are pre-created so Spring Boot can run on a **read-only filesystem** - a real security hardening practice.

**How to say it in an interview:**
> "Our Java services are packaged as Alpine-based OpenJDK 17 images from our private ECR. The Dockerfile copies the built jar in, pulls TLS truststores from S3 for Kafka/MQ, sets up native libs, and pre-creates directories so the container can run with a read-only root filesystem. Images are tagged with the commit SHA and pushed to ECR, then deployed to EKS."

That's a genuinely strong, senior-sounding answer - and it's true.

**Honest gaps to note (so you can speak to improvement, which interviewers love):**
- Those Dockerfiles are **single-stage** and install build tools at runtime - "something I'd improve is moving to multi-stage builds to shrink the image and drop build-time tools from the runtime layer."
- Multiple `CMD` lines in the Java Dockerfile (only the last wins) - "I spotted the earlier `CMD` is dead; cleaning that up is the kind of hygiene fix I'd raise in review."
Saying what you'd improve shows 2-YOE judgment, not fresher memorization.

---

## Hands-on labs (do these)

- **Lab 1:** `docker run -d -p 8080:80 --name web nginx`, open `http://localhost:8080`, then `docker logs web` and `docker exec -it web sh`. Stop and remove it.
- **Lab 2:** Write a Dockerfile for a tiny app (use the Spring Boot `TaskManager` you already have, or a hello-world jar). Build with `docker build -t taskmanager:1.0 .` and run it.
- **Lab 3:** Convert Lab 2 to a **multi-stage build**. Compare image sizes with `docker images` before and after. Write the two numbers down - that's your interview soundbite.
- **Lab 4:** Push your image to **Docker Hub**: `docker login`, `docker tag taskmanager:1.0 <youruser>/taskmanager:1.0`, `docker push ...`. Confirm it appears on hub.docker.com.
- **Lab 5:** Break and fix: intentionally put `COPY` before `WORKDIR`, or expose the wrong port, see the failure, and fix it. Learning to read the build error is the skill.
- **Lab 6 (layers):** Add a `RUN echo hello` line, rebuild, and watch which layers are cached vs rebuilt. Move it above the `COPY` and rebuild again - notice the cache behavior change.

### This week's deliverable
Your Spring Boot app running in a container, image **pushed to Docker Hub** (or ECR if you can). Multi-stage Dockerfile in the repo. That's the Week 3 "done" marker - tick it on the roadmap.

---

## Common mistakes - and fixes
- **Image too big** - you built with a full JDK/Maven base. Fix: multi-stage build, Alpine/JRE runtime base.
- **`EXPOSE` but can't reach it** - `EXPOSE` only documents; you must `-p host:container` at run.
- **Changing code rebuilds everything** - your `COPY . .` is too early, busting the cache. Put dependency install before copying source so deps are cached.
- **Secrets baked into the image** - never `COPY` a `.env` or hardcode creds; they end up in image layers forever. Inject at runtime.
- **Running as root** - default is root inside the container; for production add a non-root `USER`. (Week 4 covers this.)
- **`latest` tag confusion** - `latest` isn't "newest," it's just a default tag. Use explicit tags (your work uses commit SHAs) so you know exactly what's running.
- **Disk fills up** - dangling images pile up. `docker system prune -a` periodically.

---

## Experienced-level Q&A (2 YOE, not fresher)

- **Q: Container vs VM - and why do we use containers for microservices?**
  "A VM virtualizes hardware and ships a full guest OS, so it's heavy and slow to boot; a container shares the host kernel and ships just the app plus its deps, so it's small and starts instantly. For microservices you're running many small services and scaling them up and down constantly - containers make that cheap and give you an identical image from laptop to prod. We ship each `customer-*` service as its own image to ECR."

- **Q: How do you make a Docker image smaller, and why care?**
  "Multi-stage builds - build the jar in a stage that has Maven/JDK, then copy only the jar into a clean JRE-alpine runtime stage, so build tools never reach production. Also order layers so dependencies cache. Smaller images pull faster on every deploy and shrink the attack surface. Honestly, our current service images are single-stage and I'd move them to multi-stage to cut size - that's a concrete improvement I can point to."

- **Q: CMD vs ENTRYPOINT?**
  "ENTRYPOINT is the fixed executable; CMD is the default arguments and is easy to override at `docker run`. Pattern we use is an ENTRYPOINT that launches the app. A gotcha I've actually seen in our Java Dockerfile is two `CMD` lines - only the last one takes effect, the first is dead code."

- **Q: An image builds fine locally but the container crashes on start in the cluster. How do you debug?**
  "Reproduce locally: `docker run` it and read `docker logs`. If it starts locally but not in the cluster, it's environment - a missing env var, a secret, or a file path that exists in my build but not at runtime. I `exec` into the container (or `kubectl exec` the pod) and check env vars and paths. For our services it's often a truststore or an env var like a GraphQL URL that's set per-environment in the Kustomize overlay."

- **Q: Why not just use the `latest` tag?**
  "Because `latest` is mutable - it doesn't tell you which build is running, and two pulls can give different images. We tag with the commit SHA, so a running container maps to an exact commit. That traceability is essential when you're rolling back a bad deploy."

- **Q: How do images get from build to your cluster?**
  "CI builds the image, tags it with the commit SHA, and pushes to our private ECR. The EKS deployment references that image + tag (via our Kustomize overlay), and the cluster pulls it using an IAM role. So the flow is: commit -> CI build -> ECR -> EKS pulls by SHA."

### "Said as a 2 YOE candidate" - phrasing bank
- "Each of our microservices ships as its own image in private ECR, SHA-tagged."
- "Our Java images are OpenJDK-17-alpine; they pull TLS truststores from S3 and are set up to run read-only."
- "I'd move our single-stage Dockerfiles to multi-stage to cut image size - that's a real improvement I see."
- "When a container won't start, I go straight to `docker logs` / `kubectl logs`, then `exec` in to check env and paths."

---

## Cheat sheet
```bash
docker build -t app:1.0 .            # build image from Dockerfile
docker run -d -p 8080:8080 app:1.0   # run, map port
docker ps / docker ps -a             # running / all containers
docker logs -f <name>                # follow logs
docker exec -it <name> sh            # shell inside a running container
docker stop/start/rm <name>          # lifecycle
docker images / docker rmi <img>     # list / remove images
docker tag app:1.0 user/app:1.0      # tag for a registry
docker push user/app:1.0             # push
docker system prune -a               # clean up disk

# Dockerfile essentials
FROM <base>            # base image (first line)
WORKDIR /app           # working dir
COPY src dest          # copy files in
RUN <cmd>              # run at BUILD time (new layer)
ENV KEY=value          # env var in image
EXPOSE 8080            # document port (doesn't publish)
ENTRYPOINT ["java","-jar","app.jar"]   # fixed start command
CMD ["--default-arg"]  # default args (overridable)

# multi-stage
FROM maven:3.9-eclipse-temurin-17 AS build
...
FROM eclipse-temurin:17-jre-alpine
COPY --from=build /src/target/*.jar app.jar
```

---

Next week: **Docker Compose + production basics** (`Week04_Docker_Compose.md`) - running your app together with a database, env vars, networking, and real hardening (non-root, small images, `.dockerignore`). Finish the Week 3 deliverable and tick the roadmap first.
