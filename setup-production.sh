#!/bin/bash

# Production Setup Script for Render
echo "🚀 Setting up production environment..."

# Install dependencies
npm install

# Apply Hasura metadata
cd hasura
hasura metadata apply --endpoint http://hasura:8080 --admin-secret adminsecret123

# Apply migrations
hasura migrate apply --endpoint http://hasura:8080 --admin-secret adminsecret123

# Apply seeds
hasura seed apply --endpoint http://hasura:8080 --admin-secret adminsecret123

echo "✅ Production setup completed!"
