# 🚀 BÀI TẬP 04: SITEMESH DECORATOR 3 - USER PROFILE (JPA & MULTIPART) - FORM VALIDATION

> **Môn học:** Lập trình Web  
> **Nền tảng:** Java 21, Jakarta EE 10, Hibernate ORM 6 (JPA), SiteMesh 3, Bootstrap 5.3.3, Microsoft SQL Server

---

## 📌 MỤC TIÊU ĐỀ BÀI VÀ KẾT QUẢ ĐẠT ĐƯỢC


1. **Cấu hình SiteMesh Decorator 3 với 01 Template Bootstrap:**
   * Tích hợp thư viện `org.sitemesh:sitemesh:3.2.2` tương thích hoàn toàn với Jakarta EE 10 (`jakarta.servlet`).
   * Sử dụng class cấu hình `MySiteMeshFilter` kế thừa `ConfigurableSiteMeshFilter` kết hợp bộ lọc mapping `/*` trong `web.xml`.
   * Xây dựng **01 Template Bootstrap duy nhất** (`web.jsp` nằm trong `/WEB-INF/decorators/`) bọc toàn bộ ứng dụng: Header Navbar Glassmorphism, thanh tìm kiếm, menu danh mục tự động, trạng thái người dùng (Avatar + Họ tên + Badge vai trò), và Footer Responsive.
   * Cấu hình loại trừ tĩnh (`addExcludedPath`) cho `/image*`, `/assets/*`, `/static/*`, `/uploads/*` để đảm bảo stream file nhị phân không bị gián đoạn.

2. **Thực hiện Validation toàn diện cho tất cả chức năng có FORM:**
   * Áp dụng nguyên lý **Validation 2 lớp** (Client-side & Server-side).
   * **Client-side:** Tận dụng HTML5 Attributes (`required`, `minlength`, `maxlength`, `pattern`, `min`, `max`) kết hợp Bootstrap 5 Validation (`class="needs-validation"`, `novalidate`, `was-validated`, `.invalid-feedback`) và JavaScript kiểm tra file/password match.
   * **Server-side:** Kiểm tra chặt chẽ tại tầng Controller (Servlet) về kiểu dữ liệu, giới hạn chuỗi, regex số điện thoại/email, dung lượng file upload (`<= 5MB`), định dạng đuôi file mở rộng (`.jpg, .jpeg, .png, .webp`), tính duy nhất của dữ liệu trong CSDL và phản hồi thông báo lỗi trực quan.
   * **Các form áp dụng:**
     * Form Cập nhật Hồ sơ cá nhân (Profile)
     * Form Đăng ký tài khoản (Register)
     * Form Đăng nhập (Login)
     * Form Quên mật khẩu (Forgot Password)
     * Form Xác thực OTP kích hoạt & Khôi phục mật khẩu (Verify OTP)
     * Form Đặt lại mật khẩu (Reset Password)
     * Form Quản trị Danh mục (Category Add/Edit)
     * Form Quản trị Sản phẩm (Product Add/Edit)

3. **Chức năng Hồ sơ cá nhân (User Profile) - Update Fullname, Phone, Images:**
   * Thực thể `User` (`@Entity`) ánh xạ JPA đầy đủ các trường `fullname` (NVARCHAR), `phone` (VARCHAR), `images` & `avatar` (NVARCHAR).
   * Thao tác dữ liệu qua JPA `EntityManager` và `EntityTransaction` (begin, merge, commit, rollback on error, finally close).
   * `ProfileController` sử dụng annotation `@MultipartConfig` tiếp nhận file tải lên qua `Part part = req.getPart("imageFile")`.
   * Đặt tên file theo thời gian (`System.currentTimeMillis() + ext`) chống trùng lặp, lưu trữ vật lý tại thư mục `uploads/` trên server.
   * Có chức năng **Live Preview** hiển thị ngay ảnh đại diện và họ tên trên trình duyệt khi người dùng thao tác mà chưa cần ấn lưu (sử dụng HTML5 `FileReader`).
   * Tự động đồng bộ hóa `Session` để Navbar SiteMesh cập nhật Avatar và Họ tên mới ngay lập tức mà không cần đăng nhập lại.
   * Quản lý giao diện hoàn toàn bằng bố cục SiteMesh Decorator Bootstrap.

---

## 🛠️ CÔNG NGHỆ SỬ DỤNG (TECH STACK)

* **Ngôn ngữ & Nền tảng:** Java 21 (LTS)
* **Web Specification:** Jakarta EE 10 (Servlet 6.1.0, JSP 3.0.0, JSTL 3.0.1)
* **Giao diện & Trang trí:** 
  * SiteMesh 3.2.2 (`org.sitemesh:sitemesh`)
  * Bootstrap 5.3.3 (CSS & Bundle JS)
  * Font Awesome 6.5.2 & Google Font *Plus Jakarta Sans*
* **ORM & Database:**
  * JPA 3.1.0 với Hibernate ORM 6.6.1.Final
  * Hibernate Validator 8.0.1.Final (Bean Validation)
  * Microsoft SQL Server (`mssql-jdbc 12.8.1.jre11`)
* **Dịch vụ Email:** Jakarta Mail 2.1.3 & Angus Mail 2.0.3 (Gửi mã OTP qua SMTP Gmail)
* **Web Server:** Embedded Jetty 12.0.10 (Maven Plugin `jetty-ee10-maven-plugin`) & Hỗ trợ Apache Tomcat 10.1+

---

## 📂 CẤU TRÚC THƯ MỤC DỰ ÁN

```text
BT04_0709/
├── pom.xml                                    # Cấu hình dependencies, build WAR, Jetty plugin
├── uploads/                                   # Thư mục lưu trữ file ảnh tải lên từ Multipart
├── src/
│   ├── main/
│   │   ├── java/vn/iotstar/
│   │   │   ├── config/
│   │   │   │   └── JPAConfig.java             # Quản lý EntityManagerFactory và EntityManager
│   │   │   ├── controller/
│   │   │   │   ├── AuthController.java        # Đăng ký, Đăng nhập, OTP, Đổi mật khẩu
│   │   │   │   ├── CategoryController.java    # CRUD Danh mục Admin (Upload ảnh, Validation)
│   │   │   │   ├── DownloadImageController.java # Stream ảnh từ uploads/ ra trình duyệt
│   │   │   │   ├── HomeController.java        # Trang chủ, Top 10 sản phẩm mới nhất
│   │   │   │   ├── ProductAdminController.java# CRUD Sản phẩm Admin (Validation, Upload)
│   │   │   │   ├── ProductWebController.java  # Xem sản phẩm & chi tiết phía khách hàng
│   │   │   │   └── ProfileController.java     # Cập nhật Profile: Fullname, Phone, Image (Multipart)
│   │   │   ├── dao/                           # Data Access Object (Tương tác JPA)
│   │   │   │   ├── IUserDao.java & UserDaoImpl.java
│   │   │   │   ├── ICategoryDao.java & CategoryDao.java
│   │   │   │   └── IProductDao.java & ProductDao.java
│   │   │   ├── entity/                        # JPA Entities (Ánh xạ các bảng SQL Server)
│   │   │   │   ├── User.java                  # Entity User (fullname, phone, images, avatar...)
│   │   │   │   ├── Category.java              # Entity Category
│   │   │   │   ├── Product.java               # Entity Product
│   │   │   │   └── Video.java                 # Entity Video
│   │   │   ├── filter/
│   │   │   │   └── MySiteMeshFilter.java      # Cấu hình Decorator SiteMesh 3
│   │   │   ├── service/                       # Tầng xử lý nghiệp vụ (Business Logic)
│   │   │   │   ├── IUserService.java & UserServiceImpl.java
│   │   │   │   ├── ICategoryService.java & CategoryServiceImpl.java
│   │   │   │   └── IProductService.java & ProductServiceImpl.java
│   │   │   └── utils/
│   │   │       ├── Constant.java              # Hằng số hệ thống, thư mục UPLOAD_DIR
│   │   │       ├── EmailUtil.java             # Tiện ích gửi email OTP qua SMTP
│   │   │       └── PasswordUtil.java          # Tiện ích mã hóa mật khẩu SHA-256
│   │   ├── resources/
│   │   │   └── META-INF/
│   │   │       └── persistence.xml            # Cấu hình kết nối CSDL SQL Server JPA
│   │   └── webapp/
│   │       ├── index.jsp                      # Trang điều hướng ban đầu sang /home
│   │       ├── WEB-INF/
│   │       │   ├── web.xml                    # Đăng ký SiteMesh Filter
│   │       │   └── decorators/
│   │       │       └── web.jsp                # 01 Template Bootstrap Decorator duy nhất
│   │       └── views/
│   │           ├── user/
│   │           │   └── profile.jsp            # Giao diện Form cập nhật thông tin cá nhân
│   │           ├── web/                       # Giao diện Khách hàng (Home, Auth, Sản phẩm...)
│   │           └── admin/                     # Giao diện Quản trị viên (Danh mục, Sản phẩm...)
│   └── test/java/vn/iotstar/test/
│       └── DatabaseInitTest.java              # File kiểm thử kết nối DB và nạp dữ liệu mẫu
```

---

## ⚙️ CẤU HÌNH CƠ SỞ DỮ LIỆU (DATABASE CONFIGURATION)

Cấu hình JPA nằm tại file `src/main/resources/META-INF/persistence.xml`:

```xml
<property name="jakarta.persistence.jdbc.url" 
          value="jdbc:sqlserver://localhost:64590;databaseName=jakartaJPA;encrypt=true;trustServerCertificate=true" />
<property name="jakarta.persistence.jdbc.driver" value="com.microsoft.sqlserver.jdbc.SQLServerDriver" />
<property name="jakarta.persistence.jdbc.user" value="sa" />
<property name="jakarta.persistence.jdbc.password" value="22092006" />
<property name="hibernate.hbm2ddl.auto" value="update" />
```

> **Ghi chú:** Với cấu hình `hibernate.hbm2ddl.auto = update`, hệ thống sẽ tự động tạo/cập nhật cấu trúc bảng trong database `jakartaJPA` khi khởi chạy mà không cần chạy file SQL thủ công.

---

## 🚀 HƯỚNG DẪN KHỞI CHẠY VÀ SỬ DỤNG

### Cách 1: Khởi chạy bằng Terminal với Maven Jetty (Nhanh nhất)

1. Mở cửa sổ Terminal/PowerShell tại thư mục gốc của dự án:
   ```bash
   mvn jetty:run
   ```
2. Chờ màn hình xuất hiện thông báo:
   ```text
   [INFO] SiteMesh 3.2.2 initialized with filter name 'sitemesh'
   [INFO] Started ServerConnector@... {0.0.0.0:8085}
   [INFO] Started oejs.Server@...
   ```
3. **Giữ nguyên Terminal đang chạy** (không bấm `Ctrl+C`). Mở trình duyệt web truy cập các liên kết bên dưới.
4. Khi muốn tắt server: Nhấn `Ctrl + C` và nhập `y` trong Terminal.

### Cách 2: Khởi chạy trên Eclipse / Spring Tool Suite (STS)

1. Mở Eclipse/STS, đảm bảo đã cài đặt **Apache Tomcat 10.1+** (vì yêu cầu Jakarta EE 10).
2. Chuột phải vào project `BT04_0709` ➔ Chọn **Run As** ➔ **Run on Server**.
3. Chọn Server Tomcat 10.1 ➔ Bấm **Finish**.

---

## 🌐 DANH SÁCH CÁC ĐƯỜNG DẪN TRUY CẬP (URLS)

| Chức năng | Đường dẫn (URL) | Ghi chú |
|:---|:---|:---|
| **Trang chủ** | `http://localhost:8085/BT04_0709/` | Tự động chuyển tiếp vào `/home` |
| **Cập nhật Hồ sơ (Profile)** | `http://localhost:8085/BT04_0709/profile` | Hỗ trợ alias `/user/profile` |
| **Đăng nhập** | `http://localhost:8085/BT04_0709/login` | Form đăng nhập có validation |
| **Đăng ký** | `http://localhost:8085/BT04_0709/register` | Đăng ký & nhận mã OTP qua Email |
| **Xác thực OTP** | `http://localhost:8085/BT04_0709/verify-otp` | Kích hoạt tài khoản bằng OTP |
| **Quên mật khẩu** | `http://localhost:8085/BT04_0709/forgot-password` | Gửi mã OTP khôi phục |
| **Danh sách sản phẩm** | `http://localhost:8085/BT04_0709/product` | Xem danh mục, phân trang sản phẩm |
| **Quản trị Danh mục** | `http://localhost:8085/BT04_0709/admin/categories` | Thêm, sửa, xóa danh mục (Admin) |
| **Quản trị Sản phẩm** | `http://localhost:8085/BT04_0709/admin/products` | Thêm, sửa, xóa sản phẩm (Admin) |

---

## 🔑 TÀI KHOẢN ĐĂNG NHẬP MẶC ĐỊNH

| Loại tài khoản | Tên đăng nhập (Username) | Mật khẩu (Password) | Vai trò |
|:---|:---:|:---:|:---:|
| **Quản trị viên (Admin)** | `admin` | `admin123` | Quản trị hệ thống, danh mục, sản phẩm |
| **Người dùng mẫu (User)** | `thanh_tai` | `123456` | Khách hàng |

---

## 🧪 KỊCH BẢN KIỂM THỬ TỪNG YÊU CẦU ĐỀ BÀI

### 1. Kiểm thử chức năng Profile (Cập nhật Họ tên, SĐT, Ảnh đại diện Multipart)
1. Truy cập: `http://localhost:8085/BT04_0709/profile`
2. **Kiểm tra Live Preview ảnh:** Bấm vào icon máy ảnh trên avatar, chọn 1 ảnh `.png` hoặc `.jpg` từ máy. Avatar hiển thị thay đổi ngay lập tức trên giao diện.
3. **Kiểm tra Live Preview họ tên:** Gõ họ tên mới vào ô input Họ và tên, tên hiển thị dưới avatar thay đổi theo thời gian thực.
4. **Nhập SĐT:** Nhập số điện thoại chuẩn 10 số (ví dụ: `0912345678`).
5. **Bấm "Lưu thay đổi":**
   * File ảnh được upload lên server và ghi vào thư mục `uploads/`.
   * Tên file ảnh, fullname, phone được lưu xuống database bằng JPA `merge()`.
   * Thanh Navbar hiển thị thông báo thành công và Avatar/Họ tên trên góc phải Navbar tự động cập nhật mới ngay lập tức.

### 2. Kiểm thử tính năng Validation Form
* **Form Profile:**
  * Xóa trắng ô Họ tên ➔ Báo lỗi: *"Họ và tên không được để trống (từ 2 - 100 ký tự)"*.
  * Nhập SĐT chứa chữ hoặc ít hơn 10 chữ số (ví dụ: `09123`) ➔ Báo lỗi: *"Vui lòng nhập số điện thoại hợp lệ (10 chữ số bắt đầu bằng 0)"*.
  * Chọn file có đuôi `.txt`, `.exe` hoặc dung lượng `> 5MB` ➔ Bị chặn với cảnh báo rõ ràng.
* **Form Đăng ký / Đăng nhập:**
  * Mật khẩu ít hơn 6 ký tự hoặc Mật khẩu xác nhận không khớp ➔ Cảnh báo tức thì bằng JavaScript và chặn submit.
  * Tên đăng nhập hoặc Email đã tồn tại trong CSDL ➔ Server-side Servlet kiểm tra và trả thông báo lỗi.

### 3. Kiểm thử SiteMesh 3 Decorator
* Chuyển đổi giữa các trang: Profile, Trang chủ, Sản phẩm, Đăng nhập, Admin...
* Tất cả các view đều sử dụng chung **01 Template Bootstrap Decorator** (`web.jsp`): giữ nguyên bố cục Header Navbar, Footer, chỉ thay đổi phần nội dung body ở giữa (`<sitemesh:write property='body'/>`), tiêu đề trang thay đổi tương ứng theo từng view (`<sitemesh:write property='title'/>`).
