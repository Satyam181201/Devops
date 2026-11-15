# Python FastAPI Project (Multi-Stage)

## Your Task:
Create a **Dockerfile** with:
- Multi-stage build (Stage 1: build deps, Stage 2: runtime)
- Use Python 3.11-slim for runtime
- Run as non-root user
- Expose port 8000
- CMD: uvicorn main:app --host 0.0.0.0 --port 8000

## Test Commands:
```bash
docker build -t fastapi-app .
docker run -p 8000:8000 fastapi-app
curl http://localhost:8000
curl http://localhost:8000/items/42
```
