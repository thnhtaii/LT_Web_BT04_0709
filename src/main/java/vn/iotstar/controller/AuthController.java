package vn.iotstar.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import vn.iotstar.entity.User;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.UserServiceImpl;

@WebServlet(urlPatterns = { "/login", "/register", "/verify-otp", "/resend-otp", "/forgot-password", "/reset-password", "/logout" })
public class AuthController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String uri = req.getRequestURI();

        if (uri.contains("/login")) {
            req.getRequestDispatcher("/views/web/login.jsp").forward(req, resp);
        } else if (uri.contains("/register")) {
            req.getRequestDispatcher("/views/web/register.jsp").forward(req, resp);
        } else if (uri.contains("/verify-otp")) {
            req.getRequestDispatcher("/views/web/verify-otp.jsp").forward(req, resp);
        } else if (uri.contains("/resend-otp")) {
            handleResendOtp(req, resp);
        } else if (uri.contains("/forgot-password")) {
            req.getRequestDispatcher("/views/web/forgot-password.jsp").forward(req, resp);
        } else if (uri.contains("/reset-password")) {
            req.getRequestDispatcher("/views/web/reset-password.jsp").forward(req, resp);
        } else if (uri.contains("/logout")) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/login?msg=logged_out");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String uri = req.getRequestURI();

        if (uri.contains("/register")) {
            handleRegister(req, resp);
        } else if (uri.contains("/verify-otp")) {
            handleVerifyOtp(req, resp);
        } else if (uri.contains("/login")) {
            handleLogin(req, resp);
        } else if (uri.contains("/forgot-password")) {
            handleForgotPassword(req, resp);
        } else if (uri.contains("/reset-password")) {
            handleResetPassword(req, resp);
        }
    }

    private static final String EMAIL_REGEX = "^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\\.[A-Za-z]{2,})$";
    private static final String USERNAME_REGEX = "^[a-zA-Z0-9_]{3,30}$";
    private static final String OTP_REGEX = "^\\d{6}$";

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String fullname = req.getParameter("fullname");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        username = (username != null) ? username.trim() : "";
        email = (email != null) ? email.trim() : "";
        fullname = (fullname != null) ? fullname.trim() : "";

        req.setAttribute("username", username);
        req.setAttribute("email", email);
        req.setAttribute("fullname", fullname);

        if (username.isEmpty() || email.isEmpty() || password == null || password.trim().isEmpty() || fullname.isEmpty()) {
            req.setAttribute("error", "Vui lòng điền đầy đủ tất cả các trường bắt buộc!");
            req.getRequestDispatcher("/views/web/register.jsp").forward(req, resp);
            return;
        }

        if (!username.matches(USERNAME_REGEX)) {
            req.setAttribute("error", "Tên đăng nhập từ 3 - 30 ký tự, chỉ chứa chữ cái, chữ số và dấu gạch dưới (_)! Không chứa dấu cách hay ký tự đặc biệt.");
            req.getRequestDispatcher("/views/web/register.jsp").forward(req, resp);
            return;
        }

        if (!email.matches(EMAIL_REGEX)) {
            req.setAttribute("error", "Địa chỉ email không đúng định dạng hợp lệ (ví dụ: user@example.com)!");
            req.getRequestDispatcher("/views/web/register.jsp").forward(req, resp);
            return;
        }

        if (fullname.length() < 2 || fullname.length() > 100) {
            req.setAttribute("error", "Họ và tên phải có độ dài từ 2 đến 100 ký tự!");
            req.getRequestDispatcher("/views/web/register.jsp").forward(req, resp);
            return;
        }

        if (password.length() < 6) {
            req.setAttribute("error", "Mật khẩu phải có độ dài tối thiểu từ 6 ký tự trở lên!");
            req.getRequestDispatcher("/views/web/register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu xác nhận không trùng khớp với mật khẩu đã nhập!");
            req.getRequestDispatcher("/views/web/register.jsp").forward(req, resp);
            return;
        }

        try {
            if (userService.findByUsername(username) != null) {
                req.setAttribute("error", "Tên đăng nhập '" + username + "' đã tồn tại trên hệ thống. Vui lòng chọn tên khác!");
                req.getRequestDispatcher("/views/web/register.jsp").forward(req, resp);
                return;
            }

            if (userService.findByEmail(email) != null) {
                req.setAttribute("error", "Địa chỉ email '" + email + "' đã được đăng ký cho tài khoản khác!");
                req.getRequestDispatcher("/views/web/register.jsp").forward(req, resp);
                return;
            }

            User user = new User(username, email, "", fullname);
            userService.register(user, password);

            HttpSession session = req.getSession();
            session.setAttribute("otpEmail", email);
            session.setAttribute("otpPurpose", "activate");

            resp.sendRedirect(req.getContextPath() + "/verify-otp?msg=otp_sent");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/views/web/register.jsp").forward(req, resp);
        }
    }

    private void handleVerifyOtp(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        String sessionEmail = (String) session.getAttribute("otpEmail");
        String email = req.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            email = sessionEmail;
        }

        email = (email != null) ? email.trim() : "";
        String otp = req.getParameter("otp");
        otp = (otp != null) ? otp.trim() : "";

        req.setAttribute("email", email);
        req.setAttribute("otp", otp);

        if (email.isEmpty() || otp.isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ địa chỉ email và mã OTP 6 chữ số!");
            req.getRequestDispatcher("/views/web/verify-otp.jsp").forward(req, resp);
            return;
        }

        if (!otp.matches(OTP_REGEX)) {
            req.setAttribute("error", "Mã xác thực OTP phải gồm đúng 6 chữ số (0-9)!");
            req.getRequestDispatcher("/views/web/verify-otp.jsp").forward(req, resp);
            return;
        }

        try {
            boolean success = userService.verifyOtp(email, otp);
            if (success) {
                session.removeAttribute("otpEmail");
                session.removeAttribute("otpPurpose");
                resp.sendRedirect(req.getContextPath() + "/login?msg=activated");
            } else {
                req.setAttribute("error", "Mã OTP không chính xác hoặc đã hết hạn (5 phút). Vui lòng thử lại!");
                req.getRequestDispatcher("/views/web/verify-otp.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/views/web/verify-otp.jsp").forward(req, resp);
        }
    }

    private void handleResendOtp(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        String email = req.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            email = (String) session.getAttribute("otpEmail");
        }

        if (email != null && !email.trim().isEmpty()) {
            try {
                userService.resendOtp(email.trim());
                session.setAttribute("otpEmail", email.trim());
                resp.sendRedirect(req.getContextPath() + "/verify-otp?msg=resent");
                return;
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/verify-otp?error=" + e.getMessage());
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/verify-otp");
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String usernameOrEmail = req.getParameter("username");
        String password = req.getParameter("password");

        if (usernameOrEmail == null || usernameOrEmail.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập tên đăng nhập/email và mật khẩu!");
            req.getRequestDispatcher("/views/web/login.jsp").forward(req, resp);
            return;
        }

        try {
            User user = userService.login(usernameOrEmail.trim(), password);
            HttpSession session = req.getSession();
            session.setAttribute("account", user);

            if (user.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin/categories");
            } else {
                resp.sendRedirect(req.getContextPath() + "/home");
            }
        } catch (Exception e) {
            String errorMsg = e.getMessage();
            req.setAttribute("error", errorMsg);
            req.setAttribute("username", usernameOrEmail);

            // Nếu tài khoản chưa kích hoạt, chuyển hướng sang nhập OTP
            if (errorMsg != null && errorMsg.contains("chưa được kích hoạt")) {
                User unverifiedUser = userService.findByUsername(usernameOrEmail.trim());
                if (unverifiedUser == null) {
                    unverifiedUser = userService.findByEmail(usernameOrEmail.trim());
                }
                if (unverifiedUser != null) {
                    HttpSession session = req.getSession();
                    session.setAttribute("otpEmail", unverifiedUser.getEmail());
                    resp.sendRedirect(req.getContextPath() + "/verify-otp?msg=not_activated");
                    return;
                }
            }
            req.getRequestDispatcher("/views/web/login.jsp").forward(req, resp);
        }
    }

    private void handleForgotPassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        email = (email != null) ? email.trim() : "";
        req.setAttribute("email", email);

        if (email.isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập địa chỉ email tài khoản của bạn!");
            req.getRequestDispatcher("/views/web/forgot-password.jsp").forward(req, resp);
            return;
        }

        if (!email.matches(EMAIL_REGEX)) {
            req.setAttribute("error", "Địa chỉ email không đúng định dạng hợp lệ!");
            req.getRequestDispatcher("/views/web/forgot-password.jsp").forward(req, resp);
            return;
        }

        if (userService.findByEmail(email) == null) {
            req.setAttribute("error", "Địa chỉ email '" + email + "' không tồn tại trong hệ thống. Vui lòng kiểm tra lại!");
            req.getRequestDispatcher("/views/web/forgot-password.jsp").forward(req, resp);
            return;
        }

        try {
            userService.sendForgotPasswordOtp(email);
            HttpSession session = req.getSession();
            session.setAttribute("resetEmail", email);
            resp.sendRedirect(req.getContextPath() + "/reset-password?msg=otp_sent");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/views/web/forgot-password.jsp").forward(req, resp);
        }
    }

    private void handleResetPassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        String sessionEmail = (String) session.getAttribute("resetEmail");
        String email = req.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            email = sessionEmail;
        }

        email = (email != null) ? email.trim() : "";
        String otp = req.getParameter("otp");
        otp = (otp != null) ? otp.trim() : "";
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        req.setAttribute("email", email);
        req.setAttribute("otp", otp);

        if (email.isEmpty() || otp.isEmpty() || newPassword == null || newPassword.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng điền đầy đủ tất cả các thông tin bắt buộc!");
            req.getRequestDispatcher("/views/web/reset-password.jsp").forward(req, resp);
            return;
        }

        if (!otp.matches(OTP_REGEX)) {
            req.setAttribute("error", "Mã OTP phải gồm đúng 6 chữ số (0-9)!");
            req.getRequestDispatcher("/views/web/reset-password.jsp").forward(req, resp);
            return;
        }

        if (newPassword.length() < 6) {
            req.setAttribute("error", "Mật khẩu mới phải có tối thiểu từ 6 ký tự trở lên!");
            req.getRequestDispatcher("/views/web/reset-password.jsp").forward(req, resp);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp với mật khẩu mới!");
            req.getRequestDispatcher("/views/web/reset-password.jsp").forward(req, resp);
            return;
        }

        try {
            userService.resetPassword(email, otp, newPassword);
            session.removeAttribute("resetEmail");
            resp.sendRedirect(req.getContextPath() + "/login?msg=reset_success");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/views/web/reset-password.jsp").forward(req, resp);
        }
    }
}
