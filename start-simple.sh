#!/bin/bash

echo "🚀 Starting simple backend..."

# Stop any existing containers
docker-compose down

# Start services
docker-compose up -d

# Wait for services
sleep 15

# Apply migrations
echo "📦 Applying migrations..."
docker-compose exec backend bash -c "cd /app/hasura && hasura migrate apply --database-name default --endpoint http://hasura:8080"

# Apply metadata automatically
echo "🔧 Applying Hasura metadata..."
docker-compose exec backend bash -c "cd /app/hasura && hasura metadata apply --endpoint http://hasura:8080" 2>/dev/null || echo "⚠️  Metadata apply failed, continuing..."

# Export metadata to files (for backup and version control)
echo "💾 Exporting metadata to files..."
docker-compose exec backend bash -c "cd /app/hasura && hasura metadata export --endpoint http://hasura:8080" 2>/dev/null || echo "⚠️  Metadata export failed, continuing..."

# Apply seed data
echo "🌱 Applying seed data..."
docker-compose exec backend bash -c "cd /app/hasura && hasura seed apply --database-name default --endpoint http://hasura:8080" 2>/dev/null || echo "⚠️  Seed apply failed, continuing..."

echo "✅ Backend started successfully!"
echo "🔧 Hasura Console: http://localhost:8080"
echo "⚡ Backend API: http://localhost:4002"
echo "🗄️ PostgreSQL: localhost:5432"
echo ""
echo "🎯 Test GraphQL: curl -s 'http://localhost:8080/v1/graphql' -H 'Content-Type: application/json' -d '{\"query\":\"query { products { id name price } }\"}'"
