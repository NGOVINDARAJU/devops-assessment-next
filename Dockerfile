# Dockerfile
# Stage 1 — build
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2 — production
FROM node:18-alpine AS runner
ENV NODE_ENV=production
WORKDIR /app

# create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# copy production deps
COPY --from=builder /app/package*.json ./
RUN npm ci --omit=dev

# copy build and public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/node_modules ./node_modules

USER appuser
EXPOSE 3000
CMD ["node", "node_modules/.bin/next", "start", "-p", "3000"]
