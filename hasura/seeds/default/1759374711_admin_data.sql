-- Seed data for admin system

-- Insert users
INSERT INTO public.users (username, password, role) VALUES
('admin', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin'), -- password: admin123
('user', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'); -- password: user123

-- Insert categories
INSERT INTO public.categories (name, type) VALUES
('Tin tức', 'post'),
('Hướng dẫn', 'post'),
('Đá ong cắt lát', 'product'),
('Đá ong cắt viên', 'product'),
('Công trình', 'product');

-- Insert posts
INSERT INTO public.posts (title, body, user_id, status) VALUES
('Chào mừng đến với Đá Ong Chủ Lai', 'Chúng tôi chuyên cung cấp các loại đá ong chất lượng cao từ Chu Lai, Quảng Nam. Sản phẩm đa dạng từ đá ong cắt lát đến đá ong viên phục vụ mọi nhu cầu xây dựng.', 1, 'published'),
('Hướng dẫn chọn đá ong phù hợp', 'Đá ong cắt lát thích hợp cho ốp tường, lát sàn. Đá ong viên dùng để xây tường, làm hàng rào. Tùy vào công trình mà chọn loại đá phù hợp.', 1, 'published'),
('Bảng giá đá ong mới nhất', 'Cập nhật bảng giá đá ong các loại kích thước khác nhau. Giá có thể thay đổi theo thời gian và số lượng đặt hàng.', 2, 'draft');

-- Insert products
INSERT INTO public.products (name, slug, description, price, stock, image_url, category_id, user_id, status) VALUES
('Đá ong 20x40x2 cm', 'da-ong-20x40x2', 'Đá ong cắt lát kích thước 20x40x2 cm, phù hợp ốp tường, lát sàn. Trọng lượng khoảng 10kg/viên.', 40000, 100, 'https://raw.githubusercontent.com/phanngotuankiet/daongchulai/main/src/assets/20x40.jpg', 3, 1, 'active'),
('Đá ong 10x20x2 cm', 'da-ong-10x20x2', 'Đá ong cắt lát kích thước 10x20x2 cm, dùng cho các công trình nhỏ. Trọng lượng khoảng 10kg/viên.', 15000, 150, 'https://raw.githubusercontent.com/phanngotuankiet/daongchulai/main/src/assets/10x20x2.jpg', 3, 1, 'active'),
('Đá ong 15x30x2 cm', 'da-ong-15x30x2', 'Đá ong cắt lát kích thước 15x30x2 cm, kích thước trung bình phù hợp nhiều công trình. Trọng lượng khoảng 10kg/viên.', 30000, 80, 'https://raw.githubusercontent.com/phanngotuankiet/daongchulai/main/src/assets/15x30x2.jpg', 3, 2, 'active'),
('Đá ong viên', 'da-ong-vien', 'Đá ong cắt viên dùng xây tường, làm hàng rào. Kích thước tiêu chuẩn, chất lượng cao.', 40000, 200, 'https://raw.githubusercontent.com/phanngotuankiet/daongchulai/main/src/assets/daongvien.jpg', 4, 1, 'active'),
('Tường rào đá ong', 'tuong-rao-da-ong', 'Dịch vụ thi công tường rào bằng đá ong, bao gồm vật liệu và nhân công.', 40000, 5, 'https://raw.githubusercontent.com/phanngotuankiet/daongchulai/main/src/assets/congtrinh1.jpg', 5, 1, 'active'),
('Nhà ở đá ong', 'nha-o-da-ong', 'Dịch vụ xây dựng nhà ở bằng đá ong, thiết kế hiện đại, bền đẹp.', 40000, 2, 'https://raw.githubusercontent.com/phanngotuankiet/daongchulai/main/src/assets/congtrinh2.jpg', 5, 1, 'active');
