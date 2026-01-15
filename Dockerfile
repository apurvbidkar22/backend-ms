# -------- Build stage --------
FROM node:20-alpine AS build

WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev
COPY src ./src

# -------- Runtime stage --------
FROM node:20-alpine

WORKDIR /app

# Copy app
COPY --from=build /app /app

# Fix permissions for OpenShift random UID
RUN chgrp -R 0 /app && \
    chmod -R g=u /app

# OpenShift will inject random UID
EXPOSE 8080

CMD ["node", "src/server.js"]
