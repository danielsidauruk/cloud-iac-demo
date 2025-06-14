FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
# npm ci (Clean Install)
RUN npm ci --omit=dev

FROM node:20-alpine

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY server.js ./server.js
COPY public ./public

EXPOSE 3000

CMD ["node", "server.js"]