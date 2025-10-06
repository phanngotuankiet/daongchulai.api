# Đá Ong Chợ Lại - Backend API

Backend API cho hệ thống quản lý sản phẩm đá ong với Hasura GraphQL Engine và Express server.

## 🏗️ Kiến trúc

- **PostgreSQL**: Database chính
- **Hasura**: GraphQL Engine với auto-generated API
- **Express**: Backend server cho Hasura Actions
- **Docker**: Containerization

## 🚀 Quick Start với Docker

### Prerequisites
- Docker & Docker Compose
- Git

### 1. Clone repository
```bash
git clone https://github.com/phanngotuankiet/daongchulai.api.git
cd daongchulai.api
```

### 2. Chạy Backend Services
```bash
# Chạy tất cả backend services (PostgreSQL + Hasura + Backend)
./start-all.sh

# Hoặc chạy thủ công
docker-compose up --build
```

### 3. Truy cập Services
- **Hasura Console**: http://localhost:8080
- **Backend API**: http://localhost:4002
- **PostgreSQL**: localhost:5432

## 🛠️ Development

### Chạy riêng từng service

#### Chỉ Database + Hasura
```bash
docker-compose up postgres hasura
```

#### Chỉ Backend Server (không Docker)
```bash
# Install dependencies
npm install

# Start backend server
npm run start:server:dev
# hoặc
node server.js
```

### Environment Variables
```bash
NODE_ENV=development
PORT=4002
DB_HOST=postgres
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=password123
DB_NAME=daongchulai
HASURA_URL=http://hasura:8080
HASURA_ADMIN_SECRET=adminsecret123
```

## 📋 Available Scripts

```bash
# Development
npm run start:server:dev    # Start backend server với watch mode
npm run start:production    # Start production server

# Docker
./start-all.sh             # Start tất cả backend services
./stop-all.sh              # Stop tất cả services
./setup-production.sh      # Setup production environment

# Hasura
hasura metadata apply      # Apply metadata changes
hasura migrate apply       # Apply database migrations
hasura seed apply          # Apply seed data
```

## 🗄️ Database Schema

### Tables
- **users**: Quản lý người dùng (admin/user)
- **categories**: Danh mục sản phẩm/bài viết
- **products**: Sản phẩm đá ong
- **posts**: Bài viết/blog

### Hasura Actions
- **change_password**: Đổi mật khẩu với bcrypt hashing

## 🔧 Hasura Configuration

### Metadata
- `hasura/metadata/`: Hasura metadata files
- `hasura/migrations/`: Database migrations
- `hasura/seeds/`: Seed data

### Actions
- `src/actions/changePassword.ts`: Password change action handler

## 🐳 Docker Services

### Backend Services
- **postgres**: PostgreSQL database
- **hasura**: Hasura GraphQL Engine
- **backend**: Express server cho Actions

### Ports
- `5432`: PostgreSQL
- `8080`: Hasura Console
- `4002`: Backend API

## 🚀 Production Deployment

### Render Deployment
1. Connect GitHub repository
2. Set environment variables
3. Deploy với Docker

### Environment Variables cho Production
```bash
NODE_ENV=production
PORT=4002
HASURA_URL=https://your-hasura-url
HASURA_ADMIN_SECRET=your-admin-secret
```

## 📚 API Documentation

### GraphQL Endpoint
- **URL**: http://localhost:8080/v1/graphql
- **Console**: http://localhost:8080/console

### Hasura Actions
- **change_password**: POST /change-password

## 🔒 Security

- Password hashing với bcrypt
- JWT authentication
- Hasura permissions
- CORS configuration

## 📝 License

MIT License