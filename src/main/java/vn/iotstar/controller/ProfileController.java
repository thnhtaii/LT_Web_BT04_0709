package vn.iotstar.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import vn.iotstar.entity.User;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.UserServiceImpl;
import vn.iotstar.utils.Constant;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
@WebServlet(urlPatterns = { "/profile", "/profile/edit", "/user/profile" })
public class ProfileController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        User user = (User) req.getSession().getAttribute("account");

        // Nếu chưa đăng nhập hoặc session trống, lấy user đầu tiên trong DB hoặc khởi tạo mẫu để test
        if (user == null) {
            try {
                List<User> list = userService.findAll();
                if (list != null && !list.isEmpty()) {
                    user = list.get(0);
                } else {
                    user = new User("thanh_tai", "thanhtai@gmail.com", "123456", "Đỗ Thành Tài", "0912345678", null);
                    userService.insert(user);
                }
                req.getSession().setAttribute("account", user);
            } catch (Exception e) {
                e.printStackTrace();
                // Fallback nếu chưa kết nối được DB
                user = new User("thanh_tai", "thanhtai@gmail.com", "123456", "Đỗ Thành Tài", "0912345678", null);
            }
        } else {
            // Đồng bộ dữ liệu mới nhất từ database
            User refreshed = userService.findById(user.getId());
            if (refreshed != null) {
                user = refreshed;
                req.getSession().setAttribute("account", user);
            }
        }

        req.setAttribute("user", user);
        req.getRequestDispatcher("/views/user/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        User currentUser = (User) req.getSession().getAttribute("account");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/profile");
            return;
        }

        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");

        fullname = (fullname != null) ? fullname.trim() : "";
        phone = (phone != null) ? phone.trim() : "";

        if (fullname.isEmpty()) {
            req.setAttribute("error", "Họ và tên không được để trống!");
            req.setAttribute("user", currentUser);
            req.getRequestDispatcher("/views/user/profile.jsp").forward(req, resp);
            return;
        }

        if (fullname.length() < 2 || fullname.length() > 100) {
            req.setAttribute("error", "Họ và tên phải có độ dài từ 2 đến 100 ký tự!");
            req.setAttribute("user", currentUser);
            req.getRequestDispatcher("/views/user/profile.jsp").forward(req, resp);
            return;
        }

        // Validate số điện thoại định dạng chuẩn Việt Nam: 10 số, bắt đầu bằng 0
        if (!phone.isEmpty() && !phone.matches("^0[0-9]{9}$")) {
            req.setAttribute("error", "Số điện thoại không đúng định dạng! Vui lòng nhập 10 chữ số bắt đầu bằng số 0 (ví dụ: 0912345678).");
            req.setAttribute("user", currentUser);
            req.getRequestDispatcher("/views/user/profile.jsp").forward(req, resp);
            return;
        }

        // Xử lý upload file hình ảnh đại diện qua Multipart
        String fname = null;
        try {
            Part part = req.getPart("imageFile");
            if (part != null && part.getSize() > 0) {
                // Kiểm tra dung lượng file (tối đa 5MB)
                if (part.getSize() > 5 * 1024 * 1024) {
                    req.setAttribute("error", "Kích thước ảnh đại diện vượt quá giới hạn cho phép (tối đa 5MB)!");
                    req.setAttribute("user", currentUser);
                    req.getRequestDispatcher("/views/user/profile.jsp").forward(req, resp);
                    return;
                }

                String submittedName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                int dotIndex = submittedName.lastIndexOf(".");
                String ext = (dotIndex >= 0) ? submittedName.substring(dotIndex).toLowerCase() : "";

                // Kiểm tra định dạng đuôi file
                if (!ext.equals(".png") && !ext.equals(".jpg") && !ext.equals(".jpeg") && !ext.equals(".webp")) {
                    req.setAttribute("error", "Định dạng file không hợp lệ! Chỉ chấp nhận file ảnh (.jpg, .jpeg, .png, .webp).");
                    req.setAttribute("user", currentUser);
                    req.getRequestDispatcher("/views/user/profile.jsp").forward(req, resp);
                    return;
                }

                fname = System.currentTimeMillis() + ext;

                File uploadDir = new File(Constant.UPLOAD_DIR);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String savePath = Constant.UPLOAD_DIR + File.separator + fname;
                part.write(savePath);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi trong quá trình upload file: " + e.getMessage());
            req.setAttribute("user", currentUser);
            req.getRequestDispatcher("/views/user/profile.jsp").forward(req, resp);
            return;
        }

        try {
            currentUser.setFullname(fullname);
            currentUser.setPhone(phone);
            if (fname != null) {
                currentUser.setImages(fname);
                currentUser.setAvatar(fname);
            }

            userService.update(currentUser);
            req.getSession().setAttribute("account", currentUser);

            resp.sendRedirect(req.getContextPath() + "/profile?msg=success");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi cập nhật dữ liệu: " + e.getMessage());
            req.setAttribute("user", currentUser);
            req.getRequestDispatcher("/views/user/profile.jsp").forward(req, resp);
        }
    }
}
