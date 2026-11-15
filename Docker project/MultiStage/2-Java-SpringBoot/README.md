# Java Spring Boot Project (Multi-Stage)

## Your Task:
Create a **multi-stage Dockerfile** with:
- Stage 1: Build with maven:3.8-openjdk-17
  - Copy pom.xml, run dependency:go-offline
  - Copy src, run mvn package -DskipTests
- Stage 2: Runtime with openjdk:17-alpine
  - Copy jar from builder stage
  - Run as non-root user
  - Expose port 8080
  - CMD: java -jar app.jar

## Test Commands:
```bash
docker build -t spring-api .
docker run -p 8080:8080 spring-api
curl http://localhost:8080
curl http://localhost:8080/api/status
```

## Note:
This is a multi-stage build to reduce image size from 1.5GB to ~200MB!
