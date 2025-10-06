# Environment Setup Guide

## 🔧 Backend Environment (.env)

Tạo file `.env` trong thư mục `daongchulai.api/`:

```bash
# Database Configuration
DB_USER=postgres
DB_PASSWORD=password123
DB_NAME=daongchulai
DB_PORT=5432

# Hasura Configuration
HASURA_ADMIN_SECRET=adminsecret123
HASURA_GRAPHQL_UNAUTHORIZED_ROLE=anonymous
HASURA_GRAPHQL_JWT_SECRET={"type":"HS256","key":"your-super-secret-jwt-key-change-this-in-production"}
HASURA_URL=http://localhost:8080

# Application Configuration
NODE_ENV=development

# AWS S3 Configuration
AWS_REGION=ap-southeast-2
AWS_ACCESS_KEY_ID=your_access_key_here
AWS_SECRET_ACCESS_KEY=your_secret_key_here
AWS_S3_BUCKET_NAME=daong
```

## 🌐 Frontend Environment (.env)

Tạo file `.env` trong thư mục `daongchulai/`:

```bash
# AWS S3 Configuration for Frontend
VITE_AWS_REGION=ap-southeast-2
VITE_AWS_ACCESS_KEY_ID=your_access_key_here
VITE_AWS_SECRET_ACCESS_KEY=your_secret_key_here
VITE_AWS_S3_BUCKET_NAME=daong

# Hasura Configuration
VITE_HASURA_URL=http://localhost:8080
VITE_HASURA_ADMIN_SECRET=adminsecret123
```

## 🚀 Setup Steps

### 1. AWS S3 Setup
1. Tạo AWS Account
2. Tạo S3 bucket: `daong` (region: ap-southeast-2)
3. Tạo IAM user với S3 permissions
4. Lấy Access Key và Secret Key

### 2. Environment Files
1. Copy `env.example` thành `.env` trong cả 2 projects
2. Thay thế AWS credentials thật
3. Đảm bảo bucket name đúng

### 3. Start Services
```bash
# Backend
cd daongchulai.api
npm install
node server.js

# Frontend
cd daongchulai
npm install
npm run dev
```

## 🔒 Security Notes

- **Không commit** file `.env` vào Git
- **Sử dụng IAM user** với minimal permissions
- **Rotate AWS keys** định kỳ
- **Sử dụng environment variables** trong production
