#!/bin/bash

echo "🐳 Starting Database and Hasura only..."

# Stop any existing containers
docker-compose down

# Start only postgres and hasura
docker-compose up postgres hasura

echo "✅ Database and Hasura are running!"
echo "🔧 Hasura Console: http://localhost:8080"
echo "🗄️ PostgreSQL: localhost:5432"
