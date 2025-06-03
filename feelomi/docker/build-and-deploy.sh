#!/bin/bash
set -e

# Build optimized containers
echo "🏗️ Building Docker containers..."
docker compose build --no-cache

# Scan images for security vulnerabilities
echo "🔒 Scanning Docker images for vulnerabilities..."
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image feelomi-backend:latest
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image feelomi-flutter-builder:latest

# Run containers
echo "🚀 Starting services..."
docker compose up -d

echo "✅ Deployment complete!"