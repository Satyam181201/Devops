FROM node:18-alpine

WORKDIR /app

COPY package*.josn ./

RUN npm install --production

COPY server.js .

RUN adduser -D appuser && chown -R appuser:appuser /app
USER appuser

CMD["npm", "start"]