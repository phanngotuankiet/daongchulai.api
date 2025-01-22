SET check_function_bodies = false;
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
COMMENT ON TABLE public.laterite_sizes IS 'Bảng lưu trữ thông tin về kích thước, giá cả và tình trạng tồn kho của từng loại đá ong';
COMMENT ON COLUMN public.laterite_sizes.id IS 'ID tự động tăng, khóa chính của bảng';
COMMENT ON COLUMN public.laterite_sizes.size IS 'Kích thước của đá theo định dạng DxRxC (VD: 20x20x40 cm)';
COMMENT ON COLUMN public.laterite_sizes.price IS 'Giá bán của đá (đơn vị: VNĐ)';
COMMENT ON COLUMN public.laterite_sizes.color IS 'Màu sắc của đá';
COMMENT ON COLUMN public.laterite_sizes.weight IS 'Trọng lượng của đá (đơn vị: kg)';
COMMENT ON COLUMN public.laterite_sizes.stock_quantity IS 'Số lượng đá còn trong kho';
COMMENT ON COLUMN public.laterite_sizes.laterite_type_id IS 'ID tham chiếu đến bảng laterite_types, xác định loại đá';
COMMENT ON COLUMN public.laterite_sizes.status IS 'Trạng thái tồn kho: available (còn hàng), out_of_stock (hết hàng), discontinued (ngừng kinh doanh)';
COMMENT ON COLUMN public.laterite_sizes.created_at IS 'Thời điểm tạo bản ghi';
COMMENT ON COLUMN public.laterite_sizes.updated_at IS 'Thời điểm cập nhật bản ghi gần nhất';
CREATE SEQUENCE public.laterite_sizes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.laterite_sizes_id_seq OWNED BY public.laterite_sizes.id;
CREATE TABLE public.laterite_types (
    id integer NOT NULL,
    type character varying(100) NOT NULL,
    description text,
    origin character varying(100),
    hardness_level double precision,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE public.laterite_types IS 'Bảng lưu trữ thông tin các loại đá ong, bao gồm đặc tính và nguồn gốc của từng loại';
COMMENT ON COLUMN public.laterite_types.id IS 'ID tự động tăng, khóa chính của bảng';
COMMENT ON COLUMN public.laterite_types.type IS 'Tên loại đá ong (VD: đá ong xám, đá ong vàng, đá ong vàng viên)';
COMMENT ON COLUMN public.laterite_types.description IS 'Mô tả chi tiết về đặc điểm, công dụng và tính chất của loại đá';
COMMENT ON COLUMN public.laterite_types.origin IS 'Nguồn gốc xuất xứ của đá (VD: Chu Lai, ...)';
COMMENT ON COLUMN public.laterite_types.hardness_level IS 'Chỉ số độ cứng của đá theo thang đo tiêu chuẩn';
COMMENT ON COLUMN public.laterite_types.created_at IS 'Thời điểm tạo bản ghi';
COMMENT ON COLUMN public.laterite_types.updated_at IS 'Thời điểm cập nhật bản ghi gần nhất';
CREATE SEQUENCE public.laterite_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.laterite_types_id_seq OWNED BY public.laterite_types.id;
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
COMMENT ON TABLE public.users IS 'Bảng quản lý phân quyền người dùng với 2 role cơ bản: admin và anonymous';
COMMENT ON COLUMN public.users.id IS 'ID tự động tăng, khóa chính của bảng';
COMMENT ON COLUMN public.users.username IS 'Tên đăng nhập, chỉ dành cho admin';
COMMENT ON COLUMN public.users.password_hash IS 'Mật khẩu đã được mã hóa, chỉ dành cho admin';
COMMENT ON COLUMN public.users.email IS 'Email đăng nhập, chỉ dành cho admin';
COMMENT ON COLUMN public.users.last_login IS 'Thời điểm đăng nhập gần nhất';
COMMENT ON COLUMN public.users.is_active IS 'Trạng thái tài khoản: true - đang hoạt động, false - đã bị khóa';
CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
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
