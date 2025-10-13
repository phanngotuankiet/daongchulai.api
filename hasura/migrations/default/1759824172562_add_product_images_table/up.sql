-- Create product_images table (with IF NOT EXISTS equivalent)
DO $$ 
BEGIN
    -- Create table if not exists
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_name = 'product_images' 
        AND table_schema = 'public'
    ) THEN
        CREATE TABLE product_images (
            id SERIAL PRIMARY KEY,
            product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE,
            image_url TEXT NOT NULL,
            alt_text TEXT,
            sort_order INTEGER DEFAULT 0,
            is_primary BOOLEAN DEFAULT FALSE,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
        );
    END IF;

    -- Create indexes if not exist
    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes 
        WHERE indexname = 'idx_product_images_product_id'
    ) THEN
        CREATE INDEX idx_product_images_product_id ON product_images(product_id);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes 
        WHERE indexname = 'idx_product_images_sort_order'
    ) THEN
        CREATE INDEX idx_product_images_sort_order ON product_images(product_id, sort_order);
    END IF;

    -- Create function if not exists
    IF NOT EXISTS (
        SELECT 1 FROM pg_proc 
        WHERE proname = 'update_updated_at_column'
    ) THEN
        CREATE OR REPLACE FUNCTION update_updated_at_column()
        RETURNS TRIGGER AS $func$
        BEGIN
            NEW.updated_at = NOW();
            RETURN NEW;
        END;
        $func$ language 'plpgsql';
    END IF;

    -- Create trigger if not exists
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger 
        WHERE tgname = 'update_product_images_updated_at'
    ) THEN
        CREATE TRIGGER update_product_images_updated_at 
            BEFORE UPDATE ON product_images 
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
END $$;
