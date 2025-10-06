#!/bin/bash

echo "🐳 Starting Backend Docker Compose..."

# Stop any existing containers
docker-compose down

# Build and start backend services
docker-compose up --build

echo "✅ Backend services are running!"
echo "🔧 Hasura Console: http://localhost:8080"
echo "⚡ Backend API: http://localhost:4002"
echo "🗄️ PostgreSQL: localhost:5432"
