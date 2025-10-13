-- Add foreign key constraints (with IF NOT EXISTS equivalent)
DO $$ 
BEGIN
    -- Add posts_user_id_fkey if not exists
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'posts_user_id_fkey' 
        AND table_name = 'posts' 
        AND table_schema = 'public'
    ) THEN
        ALTER TABLE public.posts ADD CONSTRAINT posts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
    END IF;

    -- Add products_user_id_fkey if not exists
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'products_user_id_fkey' 
        AND table_name = 'products' 
        AND table_schema = 'public'
    ) THEN
        ALTER TABLE public.products ADD CONSTRAINT products_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
    END IF;

    -- Add products_category_id_fkey if not exists
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'products_category_id_fkey' 
        AND table_name = 'products' 
        AND table_schema = 'public'
    ) THEN
        ALTER TABLE public.products ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE SET NULL;
    END IF;
END $$;
