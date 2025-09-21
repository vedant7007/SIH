# syntax=docker/dockerfile:1
FROM node:20-bookworm

# Install system dependencies (OpenSSL 3 for Prisma engines)
RUN apt-get update && apt-get install -y openssl && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# Ensure Prisma downloads correct engine binaries (OpenSSL 3)
ENV PRISMA_CLI_BINARY_TARGETS="debian-openssl-3.0.x"

# Copy only package files first for better caching
COPY package*.json ./

# Install dependencies
RUN npm ci || npm install

# Copy the rest of the backend source
COPY . .

# Expose API port
EXPOSE 4000

# Start in dev mode and run prisma generate/migrate inside container
CMD sh -c "npx prisma generate && npx prisma migrate deploy || true && npm run dev"