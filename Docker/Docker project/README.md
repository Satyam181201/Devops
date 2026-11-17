# Docker Practice Projects 🐳

**Organized into Single-Stage and Multi-Stage builds!**

---

## Project Structure

```
Docker project/
│
├── SingleStage/                    (Simpler, Larger Images)
│   ├── 1-Python-Flask/            ✅ COMPLETED
│   ├── 2-NodeJS-Express/          📝 Practice
│   ├── 3-Python-EnvVars/          📝 Practice
│   └── 4-Java-HelloWorld/         📝 Practice
│
└── MultiStage/                     (Advanced, Smaller Images)
    ├── 1-Python-FastAPI/          📝 Practice
    ├── 2-Java-SpringBoot/         📝 Practice
    └── 3-React-Nginx/             📝 Practice
```

---

## What's the Difference?

### Single-Stage Build
- **One FROM** statement
- Build and run in **same image**
- **Simpler** to write
- **Larger** final image (includes build tools)
- Good for: Learning, simple apps, development

### Multi-Stage Build
- **Multiple FROM** statements
- Build in stage 1, **copy result** to stage 2
- **More complex** to write
- **5-10x smaller** final image (no build tools)
- Good for: Production, compiled apps, optimization

---

## Practice Order

### Start with Single-Stage (Learn Basics)

#### 1. ✅ SingleStage/1-Python-Flask (DONE)
- Simple Flask REST API
- **Type:** Single-stage
- **Size:** ~180 MB
- **Difficulty:** Easy

#### 2. 📝 SingleStage/2-NodeJS-Express
- Express.js REST API
- **Type:** Single-stage
- **Size:** ~200 MB
- **Difficulty:** Easy

#### 3. 📝 SingleStage/3-Python-EnvVars
- Flask with environment variables
- **Type:** Single-stage
- **Size:** ~180 MB
- **Difficulty:** Easy

#### 4. 📝 SingleStage/4-Java-HelloWorld
- Simple Java program
- **Type:** Single-stage (JDK included)
- **Size:** ~350 MB
- **Difficulty:** Easy

---

### Then Move to Multi-Stage (Advanced)

#### 5. 📝 MultiStage/1-Python-FastAPI
- FastAPI with dependencies
- **Type:** Multi-stage
- **Size:** ~180 MB (vs 1 GB single-stage)
- **Difficulty:** Medium

#### 6. 📝 MultiStage/2-Java-SpringBoot
- Spring Boot REST API
- **Type:** Multi-stage (Maven build + JRE runtime)
- **Size:** ~200 MB (vs 1.5 GB single-stage!)
- **Difficulty:** Medium
- **Compare** with SingleStage/4-Java to see difference!

#### 7. 📝 MultiStage/3-React-Nginx
- React frontend served by Nginx
- **Type:** Multi-stage (Build + Serve)
- **Size:** ~25 MB (vs 1.2 GB single-stage!)
- **Difficulty:** Medium

---

## How to Practice

For each project:

1. **Go to project folder**
   ```bash
   cd "d:\Satyam\Devops\Docker project\SingleStage\1-Python-Flask"
   ```

2. **Read README.md** in the folder

3. **Try writing Dockerfile yourself** (don't look at solution!)

4. **Build image:**
   ```bash
   docker build -t project-name .
   ```

5. **Run container:**
   ```bash
   docker run -p port:port project-name
   ```

6. **Test:**
   ```bash
   curl http://localhost:port
   ```

7. **Check solution** in `Dockerfile_Practice_Exercises.md` if stuck

---

## Single-Stage vs Multi-Stage Example

### Single-Stage Java (SingleStage/4-Java-HelloWorld):
```dockerfile
FROM openjdk:17-alpine          # 350 MB - includes JDK
WORKDIR /app
COPY HelloWorld.java .
RUN javac HelloWorld.java       # Compile with JDK
CMD ["java", "HelloWorld"]      # Run
```
**Final Image:** ~350 MB (includes JDK compiler)

### Multi-Stage Java (MultiStage/2-Java-SpringBoot):
```dockerfile
# Stage 1: Build (1.5 GB - DISCARDED!)
FROM maven:3.8-openjdk-17 AS builder
RUN mvn package                 # Build with Maven

# Stage 2: Runtime (200 MB - FINAL IMAGE!)
FROM openjdk:17-alpine          # Only JRE, no JDK
COPY --from=builder app.jar .
CMD ["java", "-jar", "app.jar"]
```
**Final Image:** ~200 MB (7x smaller! Only JRE, no Maven/JDK)

---

## Key Concepts to Practice

### Single-Stage Projects Focus On:
- ✅ FROM (base image)
- ✅ WORKDIR (set directory)
- ✅ COPY (copy files)
- ✅ RUN (install dependencies)
- ✅ EXPOSE (document port)
- ✅ ENV (environment variables)
- ✅ USER (non-root security)
- ✅ CMD (run command)

### Multi-Stage Projects Focus On:
- ✅ Multiple FROM statements
- ✅ AS stagename (naming stages)
- ✅ COPY --from=stagename (copying between stages)
- ✅ Image size optimization
- ✅ Build vs runtime separation

---

## Common Commands

```bash
# Build image
docker build -t app-name .

# Run container
docker run -p 5000:5000 app-name

# Run with env var
docker run -p 5000:5000 -e VAR=value app-name

# Run in background
docker run -d -p 5000:5000 app-name

# Check running containers
docker ps

# Check logs
docker logs <container-id>

# Stop container
docker stop <container-id>

# Check image size
docker images app-name

# Remove image
docker rmi app-name
```

---

## Dockerfile Checklist

Before considering your Dockerfile complete:

**Single-Stage:**
- [ ] Uses slim/alpine base image
- [ ] WORKDIR is set
- [ ] Dependencies copied and installed first (caching)
- [ ] Application code copied after dependencies
- [ ] EXPOSE documents the port
- [ ] Runs as non-root user
- [ ] CMD uses correct command
- [ ] Builds without errors
- [ ] Container runs successfully

**Multi-Stage:**
- [ ] All single-stage checks above, PLUS:
- [ ] Multiple FROM statements (at least 2)
- [ ] Build stage named with AS
- [ ] COPY --from used correctly
- [ ] Final stage uses smaller base image
- [ ] Final image significantly smaller than single-stage

---

## Compare Image Sizes

After building both single and multi-stage Java projects:

```bash
docker images

# You should see:
# java-hello          ~350 MB  (single-stage)
# spring-boot         ~200 MB  (multi-stage)
```

**Question for learning:** Why is multi-stage smaller?
**Answer:** Build tools (Maven, JDK compiler) stay in stage 1 and are discarded!

---

## Tips

1. **Start with SingleStage** - Master basics first
2. **Write Dockerfile yourself** - No copy-paste!
3. **Test everything** - Build, run, curl
4. **Compare sizes** - Check `docker images`
5. **Read error messages** - Docker errors are helpful
6. **Use .dockerignore** - Exclude unnecessary files
7. **Always run as non-root** - Security best practice

---

## Solutions

Solutions are in: `D:\Satyam\Devops\Docker\Dockerfile_Practice_Exercises.md`

**Try yourself first!** Only check solution if stuck.

---

## Next Steps After Completion

Once you complete all 7 projects:

1. **Docker Compose** - Run multiple containers together
2. **Docker Networks** - Container-to-container communication
3. **Docker Volumes** - Persistent data storage
4. **Docker Hub** - Push and share images
5. **Docker in CI/CD** - GitHub Actions, Jenkins
6. **Kubernetes** - Container orchestration at scale

---

## Interview Preparation

After completing these projects, you'll be able to answer:

- ✅ What is a Dockerfile?
- ✅ Difference between RUN, CMD, and ENTRYPOINT?
- ✅ What is multi-stage build and why use it?
- ✅ How to reduce Docker image size?
- ✅ Why run containers as non-root user?
- ✅ What is COPY vs ADD?
- ✅ How to use environment variables?
- ✅ What is layer caching?

---

**Good luck with your practice! Start with SingleStage/2-NodeJS-Express! 🚀**
