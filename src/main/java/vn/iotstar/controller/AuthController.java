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

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String fullname = req.getParameter("fullname");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng điền đầy đủ các thông tin bắt buộc!");
            req.getRequestDispatcher("/views/web/register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu xác nhận không trùng khớp!");
            req.setAttribute("username", username);
            req.setAttribute("email", email);
            req.setAttribute("fullname", fullname);
            req.getRequestDispatcher("/views/web/register.jsp").forward(req, resp);
            return;
        }

        try {
            User user = new User(username.trim(), email.trim(), "", fullname != null ? fullname.trim() : "");
            userService.register(user, password);

            HttpSession session = req.getSession();
            session.setAttribute("otpEmail", email.trim());
            session.setAttribute("otpPurpose", "activate");

            resp.sendRedirect(req.getContextPath() + "/verify-otp?msg=otp_sent");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("username", username);
            req.setAttribute("email", email);
            req.setAttribute("fullname", fullname);
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

        String otp = req.getParameter("otp");
        if (email == null || email.trim().isEmpty() || otp == null || otp.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ email và mã OTP!");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/views/web/verify-otp.jsp").forward(req, resp);
            return;
        }

        try {
            boolean success = userService.verifyOtp(email.trim(), otp.trim());
            if (success) {
                session.removeAttribute("otpEmail");
                session.removeAttribute("otpPurpose");
                resp.sendRedirect(req.getContextPath() + "/login?msg=activated");
            } else {
                req.setAttribute("error", "Xác thực không thành công. Vui lòng thử lại!");
                req.setAttribute("email", email);
                req.getRequestDispatcher("/views/web/verify-otp.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("email", email);
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
        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập email tài khoản của bạn!");
            req.getRequestDispatcher("/views/web/forgot-password.jsp").forward(req, resp);
            return;
        }

        try {
            userService.sendForgotPasswordOtp(email.trim());
            HttpSession session = req.getSession();
            session.setAttribute("resetEmail", email.trim());
            resp.sendRedirect(req.getContextPath() + "/reset-password?msg=otp_sent");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("email", email);
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

        String otp = req.getParameter("otp");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        if (email == null || email.trim().isEmpty() ||
            otp == null || otp.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng điền đầy đủ các thông tin bắt buộc!");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/views/web/reset-password.jsp").forward(req, resp);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/views/web/reset-password.jsp").forward(req, resp);
            return;
        }

        try {
            userService.resetPassword(email.trim(), otp.trim(), newPassword);
            session.removeAttribute("resetEmail");
            resp.sendRedirect(req.getContextPath() + "/login?msg=reset_success");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("email", email);
            req.getRequestDispatcher("/views/web/reset-password.jsp").forward(req, resp);
        }
    }
}
