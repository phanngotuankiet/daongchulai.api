-- Remove foreign key constraints
ALTER TABLE public.posts DROP CONSTRAINT IF EXISTS posts_user_id_fkey;
ALTER TABLE public.products DROP CONSTRAINT IF EXISTS products_user_id_fkey;
ALTER TABLE public.products DROP CONSTRAINT IF EXISTS products_category_id_fkey;
