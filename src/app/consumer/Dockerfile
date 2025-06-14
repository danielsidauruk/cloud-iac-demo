FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev

FROM node:20-alpine

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY server.js ./server.js

CMD ["node", "server.js"]

LABEL description="Consumer app"
