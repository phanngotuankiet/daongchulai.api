#!/bin/bash

echo "🛑 Stopping all Docker services..."

# Export metadata before stopping (if containers are running)
if docker-compose ps | grep -q "Up"; then
    echo "💾 Exporting metadata before stopping..."
    docker-compose exec backend bash -c "cd /app/hasura && hasura metadata export --endpoint http://hasura:8080" 2>/dev/null || echo "⚠️  Could not export metadata (containers may not be ready)"
fi

# Stop all containers
docker-compose down

# Remove volumes if needed (uncomment if you want to reset database)
# docker-compose down -v

echo "✅ All services stopped!"
echo "💾 Metadata exported to hasura/metadata/"
