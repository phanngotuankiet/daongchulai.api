# Daongchulai API

Backend API cho ứng dụng quản lý sản phẩm đá ong.

## Quick Start

### Development
```bash
./start-all.sh
```

### Production Deployment
```bash
./deploy.sh
```

## Services

- **PostgreSQL**: Database (port 5432)
- **Hasura**: GraphQL API (port 8080)
- **Backend API**: Custom API (port 4002)

## Database Schema

- `users` - Người dùng
- `categories` - Danh mục sản phẩm
- `products` - Sản phẩm
- `product_images` - Hình ảnh sản phẩm
- `posts` - Bài viết

## Environment Variables

Tạo file `.env` với:
```
DATABASE_URL=postgres://postgres:password@postgres:5432/daongchulai
HASURA_GRAPHQL_DATABASE_URL=postgres://postgres:password@postgres:5432/daongchulai
HASURA_GRAPHQL_ENABLE_CONSOLE=true
HASURA_GRAPHQL_ADMIN_SECRET=adminsecret
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_REGION=ap-southeast-1
AWS_S3_BUCKET_NAME=your_bucket_name
```

## API Endpoints

- GraphQL: `http://localhost:8080/v1/graphql`
- Upload API: `http://localhost:4002/api/upload/generate-upload-url`
- Hasura Console: `http://localhost:8080/console`