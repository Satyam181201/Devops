# Node.js Express API Project

## Your Task:
Create a **Dockerfile** with:
- Use node:18-alpine
- Install dependencies (npm install)
- Run as non-root user
- Expose port 3000
- CMD: npm start

## Test Commands:
```bash
docker build -t express-api .
docker run -p 3000:3000 express-api
curl http://localhost:3000
curl http://localhost:3000/users
```
