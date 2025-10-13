#!/bin/bash

echo "🚀 Deploying to Production..."

# Install dependencies
npm install

# Start services
docker-compose up -d

# Wait for services to start
sleep 15

# Apply migrations
echo "📦 Applying database migrations..."
docker-compose exec backend bash -c "cd /app/hasura && hasura migrate apply --database-name default --endpoint http://hasura:8080"

# Apply metadata
echo "🔧 Applying Hasura metadata..."
docker-compose exec backend bash -c "cd /app/hasura && hasura metadata apply --endpoint http://hasura:8080 --skip-update-check"

echo "✅ Production deployment complete!"
echo "🔧 Hasura Console: http://localhost:8080"
echo "⚡ Backend API: http://localhost:4002"
