-- Rollback admin schema migration
DROP TABLE IF EXISTS public.products CASCADE;
DROP TABLE IF EXISTS public.posts CASCADE;
DROP TABLE IF EXISTS public.categories CASCADE;
DROP TABLE IF EXISTS public.users CASCADE;

-- Restore original schema
CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

CREATE TABLE public.laterite_sizes (
    id integer NOT NULL,
    size character varying(50) NOT NULL,
    price numeric(10,2) NOT NULL,
    color character varying(50),
    weight double precision,
    stock_quantity integer DEFAULT 0,
    laterite_type_id integer,
    status character varying(20) DEFAULT 'available'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT laterite_sizes_status_check CHECK (((status)::text = ANY ((ARRAY['available'::character varying, 'out_of_stock'::character varying, 'discontinued'::character varying])::text[])))
);

CREATE TABLE public.laterite_types (
    id integer NOT NULL,
    type character varying(100) NOT NULL,
    description text,
    origin character varying(100),
    hardness_level double precision,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.users (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    username character varying(50),
    password_hash text,
    email character varying(255),
    last_login timestamp without time zone,
    is_active boolean DEFAULT true
);

CREATE SEQUENCE public.laterite_sizes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE public.laterite_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.laterite_sizes_id_seq OWNED BY public.laterite_sizes.id;
ALTER SEQUENCE public.laterite_types_id_seq OWNED BY public.laterite_types.id;
ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;

ALTER TABLE ONLY public.laterite_sizes ALTER COLUMN id SET DEFAULT nextval('public.laterite_sizes_id_seq'::regclass);
ALTER TABLE ONLY public.laterite_types ALTER COLUMN id SET DEFAULT nextval('public.laterite_types_id_seq'::regclass);
ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);

ALTER TABLE ONLY public.laterite_sizes
    ADD CONSTRAINT laterite_sizes_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.laterite_types
    ADD CONSTRAINT laterite_types_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);

CREATE TRIGGER update_laterite_sizes_updated_at BEFORE UPDATE ON public.laterite_sizes FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_laterite_types_updated_at BEFORE UPDATE ON public.laterite_types FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

ALTER TABLE ONLY public.laterite_sizes
    ADD CONSTRAINT laterite_sizes_laterite_type_id_fkey FOREIGN KEY (laterite_type_id) REFERENCES public.laterite_types(id);
