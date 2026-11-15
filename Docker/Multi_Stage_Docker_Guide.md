# Multi-Stage Docker Build - Quick Guide 🚀

**Short guide with real-time examples and interview questions!**

---

## What is Multi-Stage Build?

Using **multiple FROM statements** in one Dockerfile to build in a big image, then copy only the result to a small image.

**Result:** Much smaller final images (5-10x reduction!)

---

## Basic Syntax

```dockerfile
# Stage 1: Build (named "builder")
FROM maven:3.8 AS builder
RUN # build commands here

# Stage 2: Runtime (final image)
FROM openjdk:17-alpine
COPY --from=builder /path/to/artifact .
CMD # run command
```

**Key:**
- `AS stagename` - Name a stage
- `COPY --from=stagename` - Copy from previous stage
- Only the **last stage** becomes the final image

---

## Real-Time Example 1: Java Spring Boot

```dockerfile
# Stage 1: Build with Maven
FROM maven:3.8-openjdk-17 AS builder
WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime with JRE only
FROM openjdk:17-alpine
WORKDIR /app
COPY --from=builder /build/target/*.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
```

**Size:** 1.5 GB → 200 MB

**Commands:**
```bash
docker build -t spring-app .
docker run -p 8080:8080 spring-app
```

---

## Real-Time Example 2: Node.js Application

```dockerfile
# Stage 1: Build
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Production
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./
RUN npm install --production
EXPOSE 3000
CMD ["node", "dist/server.js"]
```

**Size:** 1.2 GB → 150 MB

---

## Real-Time Example 3: React Frontend

```dockerfile
# Stage 1: Build React app
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

**Size:** 1.2 GB → 25 MB!

**Access:** http://localhost:80

---

## Real-Time Example 4: Python FastAPI

```dockerfile
# Stage 1: Build dependencies
FROM python:3.11 AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Stage 2: Runtime
FROM python:3.11-slim
WORKDIR /app
COPY --from=builder /root/.local /root/.local
COPY . .
ENV PATH=/root/.local/bin:$PATH
EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0"]
```

**Size:** 1 GB → 180 MB

---

## Real-Time Example 5: Go Application

```dockerfile
# Stage 1: Build
FROM golang:1.21 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Stage 2: Runtime (scratch = empty image!)
FROM scratch
COPY --from=builder /app/main /main
EXPOSE 8080
CMD ["/main"]
```

**Size:** 800 MB → 10 MB! (Go creates single binary)

---

## Why Use Multi-Stage?

| Benefit | Description |
|---------|-------------|
| **Smaller Size** | 5-10x reduction (no build tools) |
| **Faster Deploy** | Smaller = faster download/startup |
| **More Secure** | Less attack surface, no source code |
| **Cleaner** | No manual cleanup needed |

---

## Common Patterns

### Pattern 1: Build Dependencies Separately
```dockerfile
# Stage 1: Dependencies
FROM node:18 AS deps
COPY package*.json ./
RUN npm install

# Stage 2: Build
FROM node:18 AS builder
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# Stage 3: Runtime
FROM node:18-alpine
COPY --from=builder /app/dist ./dist
CMD ["node", "dist/server.js"]
```

### Pattern 2: Copy Multiple Artifacts
```dockerfile
FROM builder AS build1
RUN # build artifact 1

FROM builder AS build2
RUN # build artifact 2

FROM runtime
COPY --from=build1 /app/artifact1 .
COPY --from=build2 /app/artifact2 .
```

---

## Build Only Specific Stage

```bash
# Build only stage 1 (for testing)
docker build --target builder -t myapp-builder .

# Build final image (default)
docker build -t myapp .
```

---

## Interview Questions & Answers

### Q1: What is multi-stage build and why use it?

**Answer:** Multi-stage build uses multiple FROM statements in one Dockerfile. Build the app in a large image with all tools, then copy only the compiled artifact to a small runtime image. This reduces image size by 5-10x, improves security (no build tools in production), and speeds up deployment.

---

### Q2: How do you copy files between stages?

**Answer:** Use `COPY --from=stagename`. First, name the stage with `FROM image AS stagename`, then copy from it: `COPY --from=stagename /source /destination`.

Example:
```dockerfile
FROM maven:3.8 AS builder
RUN mvn package

FROM openjdk:17-alpine
COPY --from=builder /app/target/*.jar app.jar
```

---

### Q3: What happens to the first stage after build?

**Answer:** The first stage (build stage) is discarded. Only the last stage becomes the final image. The build stage and all its contents (source code, build tools, intermediate files) are thrown away, which is why the final image is much smaller.

---

### Q4: Can you have more than 2 stages?

**Answer:** Yes! You can have as many stages as needed. Each stage can copy from any previous stage using `--from=stagename`.

Example:
```dockerfile
FROM node:18 AS deps       # Stage 1
FROM node:18 AS builder    # Stage 2
FROM nginx:alpine          # Stage 3 (final)
COPY --from=builder /app/build .
```

---

### Q5: How do you build only a specific stage?

**Answer:** Use `docker build --target stagename -t image .`

Example:
```bash
docker build --target builder -t myapp-dev .
```

This is useful for debugging or creating development images.

---

### Q6: Difference between single-stage and multi-stage?

**Answer:**
- **Single-stage:** Everything in one image. Final image includes source code, build tools, and runtime. Large size (1-2 GB).
- **Multi-stage:** Build in stage 1, copy result to stage 2. Final image only has runtime and artifact. Small size (100-200 MB).

---

### Q7: Real-world scenario: Java app deployment

**Question:** You have a Spring Boot app. How would you create a multi-stage Dockerfile?

**Answer:**
```dockerfile
# Stage 1: Build with Maven (1.5 GB)
FROM maven:3.8-openjdk-17 AS builder
WORKDIR /build
COPY pom.xml .
COPY src ./src
RUN mvn package -DskipTests

# Stage 2: Runtime with JRE (200 MB)
FROM openjdk:17-alpine
COPY --from=builder /build/target/*.jar app.jar
CMD ["java", "-jar", "app.jar"]
```

Final image is 7x smaller and contains only JRE + JAR.

---

### Q8: When NOT to use multi-stage?

**Answer:** 
- Simple scripts that don't need compilation
- Images already small (like Python scripts with few dependencies)
- Development/debugging where you need build tools

But for production compiled apps (Java, Go, Node.js build), always use multi-stage!

---

### Q9: How to optimize multi-stage builds?

**Answer:**
1. Copy dependency files first (package.json, pom.xml) before source code for better caching
2. Use alpine/slim images for final stage
3. Run tests in build stage before copying to final stage
4. Use `--no-cache-dir` flags to avoid caching packages

---

### Q10: Can you copy from external images?

**Answer:** Yes! You can copy from any image, not just previous stages:

```dockerfile
FROM alpine
COPY --from=nginx:latest /etc/nginx/nginx.conf /nginx.conf
COPY --from=myapp:v1.0 /app/config.json /config.json
```

---

## Best Practices

1. **Name your stages clearly:**
   ```dockerfile
   FROM maven:3.8 AS build-stage
   FROM openjdk:17 AS production
   ```

2. **Order stages by frequency of change:**
   ```dockerfile
   FROM node:18 AS dependencies  # Changes rarely
   FROM node:18 AS builder       # Changes often
   FROM nginx:alpine             # Changes rarely
   ```

3. **Use smallest base for final stage:**
   ```dockerfile
   # Good
   FROM openjdk:17-alpine
   
   # Better for Go (empty image!)
   FROM scratch
   ```

4. **Run tests in build stage:**
   ```dockerfile
   FROM maven:3.8 AS builder
   RUN mvn test                  # Fails build if tests fail
   RUN mvn package
   ```

5. **Clean up in same layer:**
   ```dockerfile
   RUN mvn package && \
       rm -rf /root/.m2          # Remove Maven cache
   ```

---

## Quick Commands Reference

```bash
# Build multi-stage image
docker build -t myapp .

# Build specific stage only
docker build --target builder -t myapp-dev .

# Build with no cache
docker build --no-cache -t myapp .

# Check image size
docker images myapp

# Check image layers/history
docker history myapp

# Run container
docker run -p 8080:8080 myapp
```

---

## Practice Exercise

**Create a multi-stage Dockerfile for this Node.js Express app:**

**package.json:**
```json
{
  "name": "express-app",
  "scripts": {
    "build": "tsc",
    "start": "node dist/server.js"
  },
  "dependencies": {
    "express": "^4.18.0"
  },
  "devDependencies": {
    "typescript": "^5.0.0"
  }
}
```

**server.ts:**
```typescript
import express from 'express';
const app = express();
app.get('/', (req, res) => res.send('Hello!'));
app.listen(3000);
```

<details>
<summary>Click for Solution</summary>

```dockerfile
# Stage 1: Build TypeScript
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Production
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./
RUN npm install --production
EXPOSE 3000
CMD ["npm", "start"]
```

**Build & Run:**
```bash
docker build -t express-app .
docker run -p 3000:3000 express-app
# Visit: http://localhost:3000
```
</details>

---

## Key Takeaways 🎯

1. **Multi-stage = Multiple FROM** statements
2. **COPY --from=stagename** to copy between stages
3. **Only last stage** becomes final image
4. **5-10x smaller images** for production
5. **More secure** - no build tools/source code in production
6. Use for: Java, Go, Node.js, React, any compiled apps
7. **Always use for production builds!**

---

**That's it! Practice with the exercise and you're ready for interviews!** 🚀
