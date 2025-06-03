# Stage 1: Build
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Install dependencies for build
RUN apk add --no-cache python3 make g++

# Copy package files and install dependencies
COPY package*.json ./
RUN npm ci --only=production

# Copy source code (except items in .dockerignore)
COPY . .

# Build TypeScript
RUN npm run build

# Stage 2: Security scan
FROM aquasec/trivy:latest AS security-scan

# Copy application for scanning
COPY --from=builder /app /app
WORKDIR /app

# Run security scan on dependencies
RUN trivy filesystem --no-progress --ignore-unfixed --security-checks vuln --format table --exit-code 1 .

# Stage 3: Production with minimal footprint
FROM node:20-alpine AS production

# Set environment variables
ENV NODE_ENV=production
ENV PORT=8080

# Create app directory
WORKDIR /app

# Create a non-root user
RUN addgroup -g 1001 appuser && \
    adduser -u 1001 -G appuser -s /bin/sh -D appuser && \
    chown -R appuser:appuser /app

# Copy built application
COPY --from=builder --chown=appuser:appuser /app/dist /app/dist
COPY --from=builder --chown=appuser:appuser /app/node_modules /app/node_modules
COPY --from=builder --chown=appuser:appuser /app/package*.json /app/

# Use non-root user
USER appuser

# Expose port
EXPOSE 8080

# Run the application
CMD ["node", "dist/main.js"]