-- Drop existing tables and constraints
DROP TABLE IF EXISTS public.laterite_sizes CASCADE;
DROP TABLE IF EXISTS public.laterite_types CASCADE;
DROP TABLE IF EXISTS public.users CASCADE;
DROP FUNCTION IF EXISTS public.update_updated_at_column() CASCADE;

-- Create new admin system schema

-- Users table for admin system
CREATE TABLE public.users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'user' CHECK (role IN ('admin', 'user')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE public.users IS 'Users table for admin system';
COMMENT ON COLUMN public.users.id IS 'Primary key';
COMMENT ON COLUMN public.users.username IS 'Unique username for login';
COMMENT ON COLUMN public.users.password IS 'Hashed password';
COMMENT ON COLUMN public.users.role IS 'User role: admin or user';
COMMENT ON COLUMN public.users.created_at IS 'Account creation timestamp';

-- Categories table
CREATE TABLE public.categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL CHECK (type IN ('post', 'product')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE public.categories IS 'Categories for posts and products';
COMMENT ON COLUMN public.categories.id IS 'Primary key';
COMMENT ON COLUMN public.categories.name IS 'Category name';
COMMENT ON COLUMN public.categories.type IS 'Category type: post or product';
COMMENT ON COLUMN public.categories.created_at IS 'Creation timestamp';

-- Posts table
CREATE TABLE public.posts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    user_id INTEGER NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    status VARCHAR(50) DEFAULT 'draft' CHECK (status IN ('draft', 'published')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE public.posts IS 'Posts table for content management';
COMMENT ON COLUMN public.posts.id IS 'Primary key';
COMMENT ON COLUMN public.posts.title IS 'Post title';
COMMENT ON COLUMN public.posts.body IS 'Post content';
COMMENT ON COLUMN public.posts.user_id IS 'Reference to users table';
COMMENT ON COLUMN public.posts.status IS 'Post status: draft or published';
COMMENT ON COLUMN public.posts.created_at IS 'Creation timestamp';

-- Products table
CREATE TABLE public.products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INTEGER DEFAULT 0,
    image_url TEXT,
    category_id INTEGER REFERENCES public.categories(id) ON DELETE SET NULL,
    user_id INTEGER NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE public.products IS 'Products table for e-commerce';
COMMENT ON COLUMN public.products.id IS 'Primary key';
COMMENT ON COLUMN public.products.name IS 'Product name';
COMMENT ON COLUMN public.products.slug IS 'Unique URL slug';
COMMENT ON COLUMN public.products.description IS 'Product description';
COMMENT ON COLUMN public.products.price IS 'Product price';
COMMENT ON COLUMN public.products.stock IS 'Stock quantity';
COMMENT ON COLUMN public.products.image_url IS 'Product image URL';
COMMENT ON COLUMN public.products.category_id IS 'Reference to categories table';
COMMENT ON COLUMN public.products.user_id IS 'Reference to users table';
COMMENT ON COLUMN public.products.status IS 'Product status: active or inactive';
COMMENT ON COLUMN public.products.created_at IS 'Creation timestamp';

-- Create indexes for better performance
CREATE INDEX idx_posts_user_id ON public.posts(user_id);
CREATE INDEX idx_posts_status ON public.posts(status);
CREATE INDEX idx_posts_created_at ON public.posts(created_at);

CREATE INDEX idx_products_user_id ON public.products(user_id);
CREATE INDEX idx_products_category_id ON public.products(category_id);
CREATE INDEX idx_products_status ON public.products(status);
CREATE INDEX idx_products_slug ON public.products(slug);
CREATE INDEX idx_products_created_at ON public.products(created_at);

CREATE INDEX idx_categories_type ON public.categories(type);
