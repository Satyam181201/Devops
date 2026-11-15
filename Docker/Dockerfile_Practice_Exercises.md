# Dockerfile Practice Exercises 🎯

**5 Real-World Examples: Java, Node.js, Python**

Practice building Docker images for these applications!

---

## Exercise 1: Python Flask API

### Application Files:

**app.py:**
```python
from flask import Flask, jsonify
app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({"message": "Hello from Flask!"})

@app.route('/health')
def health():
    return jsonify({"status": "healthy"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

**requirements.txt:**
```
flask==3.0.0
```

### Your Task:
Create a Dockerfile that:
- Uses Python 3.11-slim
- Installs dependencies
- Runs as non-root user
- Exposes port 5000

<details>
<summary>Click for Solution</summary>

**Dockerfile:**
```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5000

RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

CMD ["python", "app.py"]
```

**Commands:**
```bash
# Build
docker build -t flask-api .

# Run
docker run -p 5000:5000 flask-api

# Test
curl http://localhost:5000
curl http://localhost:5000/health
```
</details>

---

## Exercise 2: Node.js Express API

### Application Files:

**server.js:**
```javascript
const express = require('express');
const app = express();

app.get('/', (req, res) => {
    res.json({ message: 'Hello from Express!' });
});

app.get('/users', (req, res) => {
    res.json({ users: ['Alice', 'Bob', 'Charlie'] });
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
```

**package.json:**
```json
{
  "name": "express-api",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
```

### Your Task:
Create a Dockerfile that:
- Uses Node.js 18-alpine
- Installs dependencies
- Runs as non-root user
- Exposes port 3000

<details>
<summary>Click for Solution</summary>

**Dockerfile:**
```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install --production

COPY server.js .

EXPOSE 3000

RUN adduser -D appuser && chown -R appuser:appuser /app
USER appuser

CMD ["npm", "start"]
```

**Commands:**
```bash
# Build
docker build -t express-api .

# Run
docker run -p 3000:3000 express-api

# Test
curl http://localhost:3000
curl http://localhost:3000/users
```
</details>

---

-----------------Multi Stage dockerfile------------------

## Exercise 3: Java Spring Boot (Multi-Stage)

### Application Files:

**pom.xml:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0">
    <modelVersion>4.0.0</modelVersion>
    
    <groupId>com.example</groupId>
    <artifactId>demo</artifactId>
    <version>1.0.0</version>
    
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.1.0</version>
    </parent>
    
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
    </dependencies>
    
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```

**src/main/java/com/example/demo/DemoApplication.java:**
```java
package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class DemoApplication {
    
    @GetMapping("/")
    public String home() {
        return "Hello from Spring Boot!";
    }
    
    @GetMapping("/api/status")
    public String status() {
        return "Service is running";
    }
    
    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }
}
```

### Your Task:
Create a **multi-stage** Dockerfile that:
- Stage 1: Build with Maven
- Stage 2: Run with JRE (alpine)
- Runs as non-root user
- Exposes port 8080

<details>
<summary>Click for Solution</summary>

**Dockerfile:**
```dockerfile
# Stage 1: Build
FROM maven:3.8-openjdk-17 AS builder
WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM openjdk:17-alpine
WORKDIR /app

COPY --from=builder /build/target/*.jar app.jar

EXPOSE 8080

RUN adduser -D appuser && chown appuser:appuser app.jar
USER appuser

CMD ["java", "-jar", "app.jar"]
```

**Commands:**
```bash
# Build
docker build -t spring-api .

# Run
docker run -p 8080:8080 spring-api

# Test
curl http://localhost:8080
curl http://localhost:8080/api/status
```
</details>

---

## Exercise 4: Python FastAPI (Multi-Stage)

### Application Files:

**main.py:**
```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello from FastAPI!"}

@app.get("/items/{item_id}")
def read_item(item_id: int):
    return {"item_id": item_id, "name": f"Item {item_id}"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}
```

**requirements.txt:**
```
fastapi==0.104.1
uvicorn==0.24.0
```

### Your Task:
Create a **multi-stage** Dockerfile that:
- Stage 1: Build dependencies
- Stage 2: Runtime with slim image
- Runs as non-root user
- Exposes port 8000

<details>
<summary>Click for Solution</summary>

**Dockerfile:**
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
COPY main.py .

ENV PATH=/root/.local/bin:$PATH

EXPOSE 8000

RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

**Commands:**
```bash
# Build
docker build -t fastapi-app .

# Run
docker run -p 8000:8000 fastapi-app

# Test
curl http://localhost:8000
curl http://localhost:8000/items/42
curl http://localhost:8000/health

# Or open browser: http://localhost:8000/docs
```
</details>

---

## Exercise 5: Node.js React App (Multi-Stage with Nginx)

### Application Files:

**package.json:**
```json
{
  "name": "react-app",
  "version": "1.0.0",
  "scripts": {
    "build": "react-scripts build",
    "start": "react-scripts start"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-scripts": "5.0.1"
  }
}
```

**public/index.html:**
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>React App</title>
</head>
<body>
    <div id="root"></div>
</body>
</html>
```

**src/App.js:**
```javascript
import React from 'react';

function App() {
  return (
    <div style={{ textAlign: 'center', marginTop: '50px' }}>
      <h1>Hello from React!</h1>
      <p>Dockerized React Application</p>
    </div>
  );
}

export default App;
```

**src/index.js:**
```javascript
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(<App />);
```

### Your Task:
Create a **multi-stage** Dockerfile that:
- Stage 1: Build React app with Node.js
- Stage 2: Serve with Nginx
- Exposes port 80

<details>
<summary>Click for Solution</summary>

**Dockerfile:**
```dockerfile
# Stage 1: Build
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY public ./public
COPY src ./src
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine

COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

**Commands:**
```bash
# Build
docker build -t react-app .

# Run
docker run -p 80:80 react-app

# Test
# Open browser: http://localhost
```
</details>

---

## Bonus Exercise: Python with Database

### Application Files:

**app.py:**
```python
from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/')
def home():
    db_host = os.getenv('DB_HOST', 'localhost')
    return jsonify({
        "message": "Hello from Flask!",
        "database": db_host
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

**requirements.txt:**
```
flask==3.0.0
```

### Your Task:
Create a Dockerfile that:
- Uses environment variables
- Runs as non-root user
- Passes DB_HOST at runtime

<details>
<summary>Click for Solution</summary>

**Dockerfile:**
```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

ENV DB_HOST=localhost

EXPOSE 5000

RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

CMD ["python", "app.py"]
```

**Commands:**
```bash
# Build
docker build -t flask-db-app .

# Run with default DB_HOST
docker run -p 5000:5000 flask-db-app

# Run with custom DB_HOST
docker run -p 5000:5000 -e DB_HOST=postgres.example.com flask-db-app

# Test
curl http://localhost:5000
```
</details>

---

## Practice Steps for Each Exercise:

1. **Create folder** for the exercise
2. **Create application files** (copy code above)
3. **Write Dockerfile** (try yourself first!)
4. **Build image:** `docker build -t app-name .`
5. **Run container:** `docker run -p port:port app-name`
6. **Test:** Use curl or browser
7. **Check solution** if stuck

---

## Commands Cheat Sheet:

```bash
# Build image
docker build -t myapp .

# Run container
docker run -p 5000:5000 myapp

# Run in background
docker run -d -p 5000:5000 myapp

# Run with environment variable
docker run -p 5000:5000 -e PORT=8080 myapp

# Check running containers
docker ps

# Stop container
docker stop <container-id>

# Check logs
docker logs <container-id>

# Remove container
docker rm <container-id>

# Remove image
docker rmi myapp

# Check image size
docker images myapp
```

---

## Tips:

1. **Start with Exercise 1** (easiest - Python Flask)
2. **Try writing Dockerfile yourself** before checking solution
3. **Build and test** each one
4. **Compare your Dockerfile** with the solution
5. **Practice multi-stage builds** (Exercises 3, 4, 5)

---

## What to Focus On:

- ✅ Correct order of commands
- ✅ Using slim/alpine images
- ✅ Installing dependencies first (caching)
- ✅ Running as non-root user
- ✅ Multi-stage builds for compiled apps
- ✅ Exposing correct ports

---

## Interview Preparation:

After completing these exercises, you should be able to:
- Write Dockerfiles for Java/Node.js/Python apps
- Explain multi-stage builds
- Optimize image size
- Implement security best practices (non-root user)
- Debug Docker build issues

---

**Practice all 5 exercises and you'll be ready for any Dockerfile question!** 🚀
