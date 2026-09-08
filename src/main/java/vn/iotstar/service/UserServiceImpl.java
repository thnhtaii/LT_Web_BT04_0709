package vn.iotstar.service;

import java.sql.Timestamp;
import java.util.List;

import vn.iotstar.dao.IUserDao;
import vn.iotstar.dao.UserDaoImpl;
import vn.iotstar.entity.User;
import vn.iotstar.utils.Constant;
import vn.iotstar.utils.EmailUtil;
import vn.iotstar.utils.PasswordUtil;

public class UserServiceImpl implements IUserService {

    private final IUserDao userDao = new UserDaoImpl();

    @Override
    public User register(User user, String plainPassword) throws Exception {
        if (userDao.checkExistUsername(user.getUsername())) {
            throw new Exception("Tên đăng nhập '" + user.getUsername() + "' đã tồn tại!");
        }
        if (userDao.checkExistEmail(user.getEmail())) {
            throw new Exception("Địa chỉ email '" + user.getEmail() + "' đã được sử dụng!");
        }

        // Mã hóa mật khẩu
        user.setPassword(PasswordUtil.hashPassword(plainPassword));
        user.setStatus(0); // Chưa kích hoạt
        user.setRoleId(2); // Vai trò người dùng mặc định

        // Tạo mã OTP
        String otp = EmailUtil.generateOtp();
        user.setOtpCode(otp);
        long expiryTime = System.currentTimeMillis() + (Constant.OTP_EXPIRY_MINUTES * 60 * 1000);
        user.setOtpExpiry(new Timestamp(expiryTime));

        // Lưu vào CSDL
        userDao.insert(user);

        // Gửi email OTP
        EmailUtil.sendOtpEmail(user.getEmail(), otp, "Mã kích hoạt tài khoản - DT SHOP", "Kích hoạt tài khoản người dùng mới");

        return user;
    }

    @Override
    public boolean verifyOtp(String email, String otpCode) throws Exception {
        User user = userDao.findByEmail(email);
        if (user == null) {
            throw new Exception("Không tìm thấy người dùng với email: " + email);
        }

        if (user.getStatus() == 1) {
            return true; // Đã kích hoạt trước đó
        }

        if (user.getOtpCode() == null || !user.getOtpCode().equals(otpCode.trim())) {
            throw new Exception("Mã OTP không chính xác. Vui lòng kiểm tra lại!");
        }

        if (user.getOtpExpiry() != null && System.currentTimeMillis() > user.getOtpExpiry().getTime()) {
            throw new Exception("Mã OTP đã hết hạn (" + Constant.OTP_EXPIRY_MINUTES + " phút). Vui lòng bấm 'Gửi lại OTP'!");
        }

        // Kích hoạt tài khoản thành công
        user.setStatus(1);
        user.setOtpCode(null);
        user.setOtpExpiry(null);
        userDao.update(user);
        return true;
    }

    @Override
    public boolean resendOtp(String email) throws Exception {
        User user = userDao.findByEmail(email);
        if (user == null) {
            throw new Exception("Không tìm thấy người dùng với email: " + email);
        }

        String otp = EmailUtil.generateOtp();
        user.setOtpCode(otp);
        long expiryTime = System.currentTimeMillis() + (Constant.OTP_EXPIRY_MINUTES * 60 * 1000);
        user.setOtpExpiry(new Timestamp(expiryTime));
        userDao.update(user);

        EmailUtil.sendOtpEmail(user.getEmail(), otp, "Mã OTP mới - DT SHOP", "Gửi lại mã kích hoạt tài khoản");
        return true;
    }

    @Override
    public User login(String usernameOrEmail, String password) throws Exception {
        User user = userDao.findByUsername(usernameOrEmail);
        if (user == null) {
            user = userDao.findByEmail(usernameOrEmail);
        }

        if (user == null) {
            throw new Exception("Tên đăng nhập hoặc email không tồn tại!");
        }

        if (!PasswordUtil.checkPassword(password, user.getPassword())) {
            throw new Exception("Mật khẩu không chính xác!");
        }

        if (user.getStatus() == 0) {
            throw new Exception("Tài khoản chưa được kích hoạt! Vui lòng nhập mã OTP gửi qua email.");
        }

        if (user.getStatus() == 2) {
            throw new Exception("Tài khoản này đã bị khóa. Vui lòng liên hệ quản trị viên!");
        }

        return user;
    }

    @Override
    public boolean sendForgotPasswordOtp(String email) throws Exception {
        User user = userDao.findByEmail(email);
        if (user == null) {
            throw new Exception("Không tìm thấy tài khoản nào gắn với email: " + email);
        }

        String otp = EmailUtil.generateOtp();
        user.setOtpCode(otp);
        long expiryTime = System.currentTimeMillis() + (Constant.OTP_EXPIRY_MINUTES * 60 * 1000);
        user.setOtpExpiry(new Timestamp(expiryTime));
        userDao.update(user);

        EmailUtil.sendOtpEmail(user.getEmail(), otp, "Mã OTP đặt lại mật khẩu - DT SHOP", "Khôi phục mật khẩu tài khoản");
        return true;
    }

    @Override
    public boolean resetPassword(String email, String otpCode, String newPassword) throws Exception {
        User user = userDao.findByEmail(email);
        if (user == null) {
            throw new Exception("Không tìm thấy người dùng với email: " + email);
        }

        if (user.getOtpCode() == null || !user.getOtpCode().equals(otpCode.trim())) {
            throw new Exception("Mã OTP không chính xác. Vui lòng thử lại!");
        }

        if (user.getOtpExpiry() != null && System.currentTimeMillis() > user.getOtpExpiry().getTime()) {
            throw new Exception("Mã OTP đã hết hạn. Vui lòng yêu cầu mã OTP mới!");
        }

        // Cập nhật mật khẩu mới
        user.setPassword(PasswordUtil.hashPassword(newPassword));
        user.setOtpCode(null);
        user.setOtpExpiry(null);
        userDao.update(user);
        return true;
    }

    @Override
    public User findById(int id) {
        return userDao.findById(id);
    }

    @Override
    public User findByEmail(String email) {
        return userDao.findByEmail(email);
    }

    @Override
    public User findByUsername(String username) {
        return userDao.findByUsername(username);
    }

    @Override
    public void update(User user) {
        userDao.update(user);
    }

    @Override
    public void updateProfile(int id, String fullname, String phone, String images) {
        User user = userDao.findById(id);
        if (user != null) {
            user.setFullname(fullname);
            user.setPhone(phone);
            if (images != null && !images.trim().isEmpty()) {
                user.setImages(images);
                user.setAvatar(images);
            }
            userDao.update(user);
        }
    }

    @Override
    public void insert(User user) {
        userDao.insert(user);
    }

    @Override
    public List<User> findAll() {
        return userDao.findAll();
    }
}
