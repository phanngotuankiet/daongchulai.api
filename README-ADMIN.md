# 🎛️ Đá Ong Chủ Lai - Admin API

Backend API cho hệ thống admin được xây dựng với NestJS và Hasura GraphQL.

## 🚀 Tính năng

- **Hasura GraphQL API** với PostgreSQL
- **Authentication** với JWT (admin/user roles)
- **Database** PostgreSQL với Hasura
- **CRUD Operations** cho Posts, Products, Categories, Users
- **Role-based Permissions**
- **Docker** support
- **TypeScript** hoàn toàn

## 📋 Schema Database

### Users
```sql
- id: SERIAL PRIMARY KEY
- username: VARCHAR(255) UNIQUE NOT NULL
- password: VARCHAR(255) NOT NULL (hashed)
- role: VARCHAR(50) DEFAULT 'user' ('admin' | 'user')
- created_at: TIMESTAMP DEFAULT CURRENT_TIMESTAMP
```

### Categories
```sql
- id: SERIAL PRIMARY KEY
- name: VARCHAR(255) NOT NULL
- type: VARCHAR(50) NOT NULL ('post' | 'product')
- created_at: TIMESTAMP DEFAULT CURRENT_TIMESTAMP
```

### Posts
```sql
- id: SERIAL PRIMARY KEY
- title: VARCHAR(255) NOT NULL
- body: TEXT NOT NULL
- user_id: INTEGER NOT NULL REFERENCES users(id)
- status: VARCHAR(50) DEFAULT 'draft' ('draft' | 'published')
- created_at: TIMESTAMP DEFAULT CURRENT_TIMESTAMP
```

### Products
```sql
- id: SERIAL PRIMARY KEY
- name: VARCHAR(255) NOT NULL
- slug: VARCHAR(255) UNIQUE NOT NULL
- description: TEXT
- price: DECIMAL(10,2) NOT NULL
- stock: INTEGER DEFAULT 0
- image_url: TEXT
- category_id: INTEGER REFERENCES categories(id)
- user_id: INTEGER NOT NULL REFERENCES users(id)
- status: VARCHAR(50) DEFAULT 'active' ('active' | 'inactive')
- created_at: TIMESTAMP DEFAULT CURRENT_TIMESTAMP
```

## 🛠️ Cài đặt

### 1. Cài đặt dependencies
```bash
npm install
```

### 2. Cấu hình environment
```bash
cp .env.example .env
```

Chỉnh sửa `.env`:
```env
HASURA_GRAPHQL_ENDPOINT=http://localhost:8080/v1/graphql
HASURA_GRAPHQL_ADMIN_SECRET=your-admin-secret
DATABASE_URL=postgresql://username:password@localhost:5432/daongchulai
```

### 3. Chạy với Docker
```bash
docker-compose up --build
```

### 4. Apply migrations và seeds
```bash
# Apply migrations
hasura migrate apply --endpoint http://localhost:8080

# Apply seeds
hasura seed apply --endpoint http://localhost:8080
```

## 📚 API Documentation

### Hasura GraphQL Endpoint
- **URL**: `http://localhost:8080/v1/graphql`
- **Console**: `http://localhost:8080/console`

### Authentication

#### Login (Custom Action)
```graphql
mutation {
  login(input: {
    username: "admin"
    password: "admin123"
  }) {
    token
    user {
      id
      username
      role
    }
  }
}
```

### Posts Management

#### Get All Posts
```graphql
query {
  posts {
    id
    title
    body
    status
    created_at
    user {
      username
      role
    }
  }
}
```

#### Create Post
```graphql
mutation {
  insert_posts_one(object: {
    title: "New Post"
    body: "Post content here"
    user_id: 1
    status: "published"
  }) {
    id
    title
    status
  }
}
```

#### Update Post
```graphql
mutation {
  update_posts_by_pk(
    pk_columns: { id: 1 }
    _set: {
      title: "Updated Title"
      status: "published"
    }
  ) {
    id
    title
    status
  }
}
```

### Products Management

#### Get All Products
```graphql
query {
  products {
    id
    name
    slug
    price
    stock
    status
    category {
      name
      type
    }
    user {
      username
    }
  }
}
```

#### Create Product
```graphql
mutation {
  insert_products_one(object: {
    name: "New Product"
    slug: "new-product"
    description: "Product description"
    price: 99.99
    stock: 10
    category_id: 1
    user_id: 1
    status: "active"
  }) {
    id
    name
    slug
    price
  }
}
```

#### Update Stock
```graphql
mutation {
  update_products_by_pk(
    pk_columns: { id: 1 }
    _set: { stock: 50 }
  ) {
    id
    name
    stock
  }
}
```

### Categories Management

#### Get All Categories
```graphql
query {
  categories {
    id
    name
    type
    created_at
    products {
      id
      name
      price
    }
  }
}
```

#### Create Category
```graphql
mutation {
  insert_categories_one(object: {
    name: "Electronics"
    type: "product"
  }) {
    id
    name
    type
  }
}
```

### Users Management

#### Get All Users
```graphql
query {
  users {
    id
    username
    role
    created_at
    posts {
      id
      title
    }
    products {
      id
      name
    }
  }
}
```

## 🔐 Authentication & Authorization

### JWT Token
- Token được trả về sau login action
- Thêm vào header: `Authorization: Bearer <token>`
- Token chứa: `sub` (user id), `username`, `role`

### Roles & Permissions

#### Admin Role
- Full access to all resources
- Can create, read, update, delete all posts, products, categories
- Can manage users

#### User Role
- Limited access to own resources
- Can create, read, update, delete own posts and products
- Cannot access other users' data

### Hasura Permissions
- **Select**: Admin có thể xem tất cả, User chỉ xem data của mình
- **Insert**: Admin có thể tạo mọi thứ, User chỉ tạo với user_id của mình
- **Update**: Admin có thể update tất cả, User chỉ update data của mình
- **Delete**: Admin có thể xóa tất cả, User chỉ xóa data của mình

## 🚀 Deployment

### Docker Compose
```bash
docker-compose up --build -d
```

### Manual Deployment
1. Setup PostgreSQL database
2. Configure Hasura
3. Apply migrations
4. Apply seeds
5. Configure environment variables

## 🧪 Testing

### Hasura Console
1. Mở `http://localhost:8080/console`
2. Test các queries/mutations
3. Kiểm tra permissions

### Sample Data
Sau khi apply seeds:

**Admin User:**
- Username: `admin`
- Password: `admin123`
- Role: `admin`

**Regular User:**
- Username: `user`
- Password: `user123`
- Role: `user`

**Sample Data:**
- 5 categories (Technology, Business, Electronics, Clothing, Books)
- 3 posts (2 published, 1 draft)
- 5 products (4 active, 1 inactive)

## 📊 Queries nâng cao

### Filter Posts by Status
```graphql
query {
  posts(where: { status: { _eq: "published" } }) {
    id
    title
    created_at
  }
}
```

### Filter Products by Category
```graphql
query {
  products(where: { category_id: { _eq: 1 } }) {
    id
    name
    price
    stock
  }
}
```

### Filter Products by Status
```graphql
query {
  products(where: { status: { _eq: "active" } }) {
    id
    name
    price
    stock
  }
}
```

### Get Products by Slug
```graphql
query {
  products(where: { slug: { _eq: "macbook-pro-16" } }) {
    id
    name
    description
    price
    stock
    category {
      name
    }
  }
}
```

### Search Products
```graphql
query {
  products(where: { name: { _ilike: "%macbook%" } }) {
    id
    name
    price
    stock
  }
}
```

## 🔧 Troubleshooting

### Common Issues

1. **Database connection failed**
   - Kiểm tra PostgreSQL đang chạy
   - Verify DATABASE_URL trong .env

2. **Hasura console not accessible**
   - Kiểm tra Hasura container đang chạy
   - Verify port 8080 không bị conflict

3. **Migration failed**
   - Kiểm tra database permissions
   - Verify migration files syntax

4. **Authentication failed**
   - Kiểm tra JWT secret
   - Verify user credentials trong seeds

## 📈 Performance Tips

1. **Database Indexing**
   - Username (unique)
   - Slug (unique)
   - Status fields
   - Foreign keys

2. **Query Optimization**
   - Sử dụng Hasura's query optimization
   - Limit results với pagination
   - Use proper filters

3. **Caching**
   - Enable Hasura caching
   - Use Redis for session storage
   - Cache frequent queries

## 🎯 Roadmap

### Phase 1 (Current)
- ✅ Basic CRUD operations
- ✅ Authentication với Hasura Actions
- ✅ GraphQL API
- ✅ Database schema

### Phase 2 (Next)
- 📧 Email notifications
- 📊 Analytics dashboard
- 🔍 Search functionality
- 🖼️ File upload
- 📱 Mobile API

### Phase 3 (Future)
- 🔄 Real-time subscriptions
- 📈 Advanced analytics
- 🤖 AI-powered features
- 🌐 Multi-tenant support
- 🔒 Advanced security

---

**🎉 Admin System với Hasura đã sẵn sàng!**

Bạn có thể bắt đầu với:
1. `docker-compose up --build` - Chạy Hasura và PostgreSQL
2. Mở `http://localhost:8080/console` - Hasura Console
3. Apply migrations và seeds
4. Test GraphQL API
5. Login với admin/admin123 để test
