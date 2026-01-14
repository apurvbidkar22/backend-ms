# -------- Build stage --------
FROM node:20-alpine AS build

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY src ./src

# -------- Runtime stage --------
FROM node:20-alpine

# Non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app
COPY --from=build /app /app

USER appuser

EXPOSE 8080
CMD ["node", "src/server.js"]
