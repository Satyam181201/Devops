# Python Flask with Environment Variables

## Your Task:
Create a **Dockerfile** with:
- Use Python 3.11-slim
- Install dependencies
- Set default ENV variables:
  - ENV DB_HOST=localhost
  - ENV DB_PORT=5432
  - ENV ENV=development
- Run as non-root user
- Expose port 5000
- CMD: python app.py

## Test Commands:
```bash
# Build
docker build -t flask-env-app .

# Run with default env vars
docker run -p 5000:5000 flask-env-app

# Run with custom env vars
docker run -p 5000:5000 \
  -e DB_HOST=postgres.example.com \
  -e DB_PORT=3306 \
  -e ENV=production \
  flask-env-app

# Test
curl http://localhost:5000
curl http://localhost:5000/config
```

## Note:
This shows how to use environment variables in Docker!
