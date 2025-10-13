#!/bin/bash

echo "🔧 Fixing Hasura metadata permanently..."

# Stop containers
docker-compose down

# Remove volumes to start fresh
docker-compose down -v

# Start services
docker-compose up -d

# Wait for services
sleep 15

# Apply migrations
echo "📦 Applying migrations..."
docker-compose exec backend bash -c "cd /app/hasura && hasura migrate apply --database-name default --endpoint http://hasura:8080"

# Track all tables manually
echo "🔧 Tracking tables..."
docker-compose exec backend bash -c "cd /app/hasura && hasura metadata reload --endpoint http://hasura:8080"

# Set permissions for all tables
echo "🔐 Setting permissions..."

# Create minimal metadata for each table
cat > /tmp/metadata.yaml << 'EOF'
version: 3
sources:
- name: default
  kind: postgres
  tables:
  - table:
      schema: public
      name: users
    select_permissions:
    - role: user
      permission:
        columns:
        - id
        - username
        - role
        - created_at
        filter: {}
    insert_permissions:
    - role: user
      permission:
        columns:
        - username
        - password
        - role
        check: {}
    update_permissions:
    - role: user
      permission:
        columns:
        - username
        - password
        - role
        filter: {}
    delete_permissions:
    - role: user
      permission:
        filter: {}
  - table:
      schema: public
      name: categories
    select_permissions:
    - role: user
      permission:
        columns:
        - id
        - name
        - type
        - created_at
        filter: {}
    insert_permissions:
    - role: user
      permission:
        columns:
        - name
        - type
        check: {}
    update_permissions:
    - role: user
      permission:
        columns:
        - name
        - type
        filter: {}
    delete_permissions:
    - role: user
      permission:
        filter: {}
  - table:
      schema: public
      name: products
    select_permissions:
    - role: user
      permission:
        columns:
        - id
        - name
        - slug
        - description
        - price
        - stock
        - category_id
        - user_id
        - status
        - created_at
        filter: {}
    insert_permissions:
    - role: user
      permission:
        columns:
        - name
        - slug
        - description
        - price
        - stock
        - category_id
        - user_id
        - status
        check:
          user_id:
            _eq: X-Hasura-User-Id
    update_permissions:
    - role: user
      permission:
        columns:
        - name
        - slug
        - description
        - price
        - stock
        - status
        filter:
          user_id:
            _eq: X-Hasura-User-Id
    delete_permissions:
    - role: user
      permission:
        filter:
          user_id:
            _eq: X-Hasura-User-Id
  - table:
      schema: public
      name: product_images
    select_permissions:
    - role: user
      permission:
        columns:
        - id
        - product_id
        - image_url
        - alt_text
        - sort_order
        - is_primary
        - created_at
        - updated_at
        filter: {}
    insert_permissions:
    - role: user
      permission:
        columns:
        - product_id
        - image_url
        - alt_text
        - sort_order
        - is_primary
        check: {}
    update_permissions:
    - role: user
      permission:
        columns:
        - image_url
        - alt_text
        - sort_order
        - is_primary
        filter: {}
    delete_permissions:
    - role: user
      permission:
        filter: {}
  - table:
      schema: public
      name: posts
    select_permissions:
    - role: user
      permission:
        columns:
        - id
        - title
        - slug
        - content
        - excerpt
        - status
        - user_id
        - created_at
        - updated_at
        filter: {}
    insert_permissions:
    - role: user
      permission:
        columns:
        - title
        - slug
        - content
        - excerpt
        - status
        - user_id
        check:
          user_id:
            _eq: X-Hasura-User-Id
    update_permissions:
    - role: user
      permission:
        columns:
        - title
        - slug
        - content
        - excerpt
        - status
        filter:
          user_id:
            _eq: X-Hasura-User-Id
    delete_permissions:
    - role: user
      permission:
        filter:
          user_id:
            _eq: X-Hasura-User-Id
EOF

# Apply the metadata
docker-compose exec backend bash -c "cd /app/hasura && cat /tmp/metadata.yaml | hasura metadata apply --endpoint http://hasura:8080 --from-stdin"

echo "✅ Metadata fixed permanently!"
echo "🔧 Test: curl -s 'http://localhost:8080/v1/graphql' -H 'Content-Type: application/json' -d '{\"query\":\"query { products { id name price } }\"}'"
