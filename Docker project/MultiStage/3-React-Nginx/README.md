# React App with Nginx (Multi-Stage)

## Your Task:
Create a **multi-stage Dockerfile** with:
- Stage 1: Build React app
  - Use node:18
  - Install dependencies
  - Run npm run build
- Stage 2: Serve with Nginx
  - Use nginx:alpine
  - Copy build folder to /usr/share/nginx/html
  - Expose port 80
  - CMD: nginx -g daemon off;

## Test Commands:
```bash
docker build -t react-app .
docker run -p 80:80 react-app
```

Then open browser: http://localhost

## Note:
This creates a TINY image (~25MB) - React app built in stage 1, served by Nginx in stage 2!
