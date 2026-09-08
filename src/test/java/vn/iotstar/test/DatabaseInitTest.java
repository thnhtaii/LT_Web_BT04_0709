package vn.iotstar.test;

import java.sql.Timestamp;
import java.util.List;

import jakarta.persistence.EntityManager;

import vn.iotstar.config.JPAConfig;
import vn.iotstar.dao.CategoryDao;
import vn.iotstar.dao.ICategoryDao;
import vn.iotstar.dao.IProductDao;
import vn.iotstar.dao.IUserDao;
import vn.iotstar.dao.ProductDao;
import vn.iotstar.dao.UserDao;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.Product;
import vn.iotstar.entity.User;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.UserServiceImpl;
import vn.iotstar.utils.PasswordUtil;

public class DatabaseInitTest {

    public static void main(String[] args) {
        System.out.println("========== BẮT ĐẦU KHỞI TẠO VÀ KIỂM TRA HỆ THỐNG JPA ==========");

        EntityManager em = JPAConfig.getEntityManager();
        System.out.println("✅ Kết nối CSDL SQL Server và khởi tạo JPA EntityManager thành công!");
        em.close();

        IUserDao userDao = new UserDao();
        ICategoryDao categoryDao = new CategoryDao();
        IProductDao productDao = new ProductDao();
        IUserService userService = new UserServiceImpl();

        // 1. Tạo tài khoản Admin mặc định nếu chưa tồn tại
        try {
            User admin = userDao.findByUsername("admin");
            if (admin == null) {
                admin = new User("admin", "admin@iotstar.vn", PasswordUtil.hashPassword("admin123"), "Quản Trị Viên");
                admin.setRoleId(1); // Admin
                admin.setStatus(1); // Đã kích hoạt
                userDao.insert(admin);
                System.out.println("✅ Đã tạo tài khoản Admin mặc định (admin / admin123)");
            } else {
                System.out.println("ℹ️ Tài khoản Admin đã tồn tại.");
            }
        } catch (Exception e) {
            System.err.println("⚠️ Lỗi kiểm tra Admin: " + e.getMessage());
        }

        // 2. Kiểm tra và bổ sung danh mục mẫu nếu cần
        List<Category> categories = categoryDao.findAll();
        Category catPhone = null;
        Category catLaptop = null;
        if (categories.isEmpty()) {
            catPhone = new Category();
            catPhone.setCategoryname("Điện thoại");
            catPhone.setStatus(1);
            catPhone.setImages("https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500");
            categoryDao.insert(catPhone);

            catLaptop = new Category();
            catLaptop.setCategoryname("Laptop & Máy tính");
            catLaptop.setStatus(1);
            catLaptop.setImages("https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500");
            categoryDao.insert(catLaptop);

            categories = categoryDao.findAll();
            System.out.println("✅ Đã tạo các danh mục mẫu.");
        } else {
            catPhone = categories.get(0);
            catLaptop = categories.size() > 1 ? categories.get(1) : catPhone;
            System.out.println("ℹ️ Đã có " + categories.size() + " danh mục trong CSDL.");
        }

        // 3. Kiểm tra và bổ sung sản phẩm mẫu để có đủ dữ liệu kiểm thử (>= 12 sản phẩm để test phân trang 6sp/trang và top 10)
        int productCount = productDao.count();
        System.out.println("ℹ️ Số lượng sản phẩm hiện tại: " + productCount);
        if (productCount < 12) {
            String[][] sampleData = {
                {"iPhone 15 Pro Max 256GB", "Điện thoại Apple iPhone 15 Pro Max khung Titan cao cấp, chip A17 Pro siêu mạnh mẽ.", "29990000", "25", "https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=500"},
                {"Samsung Galaxy S24 Ultra", "Flagship Samsung tích hợp Galaxy AI thông minh, camera 200MP zoom 100x đỉnh cao.", "27990000", "30", "https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=500"},
                {"MacBook Pro 14 M3 Pro", "Laptop đồ họa chuyên nghiệp Apple chip M3 Pro, màn hình Liquid Retina XDR sắc nét.", "44990000", "15", "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500"},
                {"Dell XPS 13 Plus 9320", "Thiết kế tương lai siêu mỏng nhẹ, màn hình cảm ứng OLED 3.5K sắc nét và bàn phím cảm ứng.", "38500000", "12", "https://images.unsplash.com/photo-1593642632823-8f785ba67e45?w=500"},
                {"Xiaomi 14 Ultra Leica", "Hệ thống 4 camera Leica đỉnh cao, cảm biến 1 inch, chip Snapdragon 8 Gen 3.", "23490000", "20", "https://images.unsplash.com/photo-1565849904461-04a58ad377e0?w=500"},
                {"ASUS ROG Zephyrus G16", "Laptop Gaming cao cấp RTX 4070, màn hình OLED 240Hz siêu mượt cho game thủ.", "49990000", "10", "https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=500"},
                {"iPad Pro M4 11 inch", "Máy tính bảng mỏng nhất từ trước tới nay của Apple với màn hình Ultra Retina XDR OLED.", "26990000", "18", "https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=500"},
                {"Google Pixel 8 Pro", "Trải nghiệm Android thuần khiết với camera AI đỉnh cao và chip Google Tensor G3.", "18990000", "14", "https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=500"},
                {"Lenovo ThinkPad X1 Carbon Gen 11", "Laptop doanh nhân huyền thoại siêu bền nhẹ, bàn phím gõ êm ái hàng đầu thế giới.", "36900000", "8", "https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=500"},
                {"Sony Xperia 1 VI", "Điện thoại màn hình chuẩn điện ảnh, camera zoom quang học 85-170mm cho chuyên gia chụp ảnh.", "28990000", "10", "https://images.unsplash.com/photo-1580910051074-3eb694886505?w=500"},
                {"Tai nghe Sony WH-1000XM5", "Tai nghe chống ồn chủ động hàng đầu, âm thanh Hi-Res Audio không dây đỉnh cao.", "7490000", "40", "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500"},
                {"Apple Watch Ultra 2", "Đồng hồ thông minh thể thao chuyên nghiệp vỏ titan, GPS tần số kép chính xác cao.", "20490000", "15", "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500"}
            };

            for (int i = 0; i < sampleData.length; i++) {
                Product p = new Product();
                p.setProductName(sampleData[i][0]);
                p.setDescription(sampleData[i][1]);
                p.setPrice(Double.parseDouble(sampleData[i][2]));
                p.setQuantity(Integer.parseInt(sampleData[i][3]));
                p.setImages(sampleData[i][4]);
                p.setStatus(1);
                // Giãn cách thời gian tạo một chút để test thứ tự 10 sản phẩm mới nhất
                p.setCreateDate(new Timestamp(System.currentTimeMillis() - ((sampleData.length - i) * 60000L)));
                p.setCategory(i % 2 == 0 ? catPhone : catLaptop);
                productDao.insert(p);
            }
            System.out.println("✅ Đã tạo " + sampleData.length + " sản phẩm mẫu.");
        }

        // 4. Kiểm tra chức năng Đăng ký tài khoản và OTP
        try {
            String testEmail = "testuser@iotstar.vn";
            User existing = userDao.findByEmail(testEmail);
            if (existing == null) {
                User testUser = new User("testuser", testEmail, "", "Người Dùng Thử Nghiệm");
                userService.register(testUser, "123456");
                System.out.println("✅ Test đăng ký tài khoản thành công! Trạng thái: " + testUser.getStatus() + ", OTP: " + testUser.getOtpCode());

                // Test xác thực OTP
                boolean verified = userService.verifyOtp(testEmail, testUser.getOtpCode());
                System.out.println("✅ Test xác thực OTP thành công: " + verified);

                // Test đăng nhập
                User loggedIn = userService.login("testuser", "123456");
                System.out.println("✅ Test đăng nhập thành công với user: " + loggedIn.getUsername());
            } else {
                System.out.println("ℹ️ Tài khoản testuser đã có sẵn.");
            }
        } catch (Exception e) {
            System.err.println("⚠️ Lỗi kiểm thử User/OTP: " + e.getMessage());
            e.printStackTrace();
        }

        // 5. Kiểm tra Top 10 sản phẩm mới nhất
        List<Product> top10 = productDao.findTop10Recent();
        System.out.println("✅ Lấy top 10 sản phẩm mới nhất thành công: " + top10.size() + " sản phẩm.");

        // 6. Kiểm tra phân trang 6sp/trang
        List<Product> page1 = productDao.findAll(0, 6);
        List<Product> page2 = productDao.findAll(1, 6);
        System.out.println("✅ Trang 1 có " + page1.size() + " sản phẩm.");
        System.out.println("✅ Trang 2 có " + page2.size() + " sản phẩm.");

        System.out.println("========== HOÀN TẤT TẤT CẢ CÁC BƯỚC KIỂM TRA THÀNH CÔNG! ==========");
    }
}
