package vn.iotstar.utils;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class PasswordUtil {

    /**
     * Mã hóa mật khẩu bằng SHA-256
     */
    public static String hashPassword(String password) {
        if (password == null || password.isEmpty()) {
            return "";
        }
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] encodedhash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder(2 * encodedhash.length);
            for (byte b : encodedhash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Lỗi mã hóa mật khẩu", e);
        }
    }

    /**
     * So khớp mật khẩu nhập vào với mật khẩu đã băm trong CSDL
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        // Hỗ trợ cả trường hợp mật khẩu cũ lưu dạng plain text (nếu có)
        return hashPassword(plainPassword).equalsIgnoreCase(hashedPassword) 
                || plainPassword.equals(hashedPassword);
    }
}
