# Java Simple HelloWorld (Single-Stage)

## Your Task:
Create a **single-stage Dockerfile** with:
- Use openjdk:17-alpine
- Set WORKDIR /app
- Copy HelloWorld.java
- Compile: javac HelloWorld.java
- Run as non-root user
- CMD: java HelloWorld

## Difference from Multi-Stage:
- **Single-stage:** Everything (JDK + compile + run) in one image
- **Multi-stage:** Build in stage 1, copy .class file to stage 2
- Single-stage is **larger** (~350MB) but **simpler**

## Test Commands:
```bash
docker build -t java-hello .
docker run java-hello
```

## Expected Output:
```
Hello from Java!
This is a single-stage Docker build
Java application is running...
Press Ctrl+C to stop
```

## Note:
This is single-stage - includes full JDK (for compilation).
Compare with project 5 (multi-stage) which is much smaller!
