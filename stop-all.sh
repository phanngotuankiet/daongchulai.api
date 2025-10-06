#!/bin/bash

echo "🛑 Stopping all Docker services..."

# Stop all containers
docker-compose down

# Remove volumes if needed (uncomment if you want to reset database)
# docker-compose down -v

echo "✅ All services stopped!"
