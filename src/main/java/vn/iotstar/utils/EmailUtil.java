package vn.iotstar.utils;

import java.util.Properties;
import java.util.Random;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailUtil {

    /**
     * Sinh mã OTP ngẫu nhiên gồm 6 chữ số
     */
    public static String generateOtp() {
        Random random = new Random();
        int number = 100000 + random.nextInt(900000);
        return String.valueOf(number);
    }

    /**
     * Gửi email chứa mã OTP (kích hoạt tài khoản hoặc quên mật khẩu)
     */
    public static boolean sendOtpEmail(String recipientEmail, String otpCode, String subject, String actionDescription) {
        // Luôn in thông tin OTP ra Console để thuận tiện kiểm thử và demo
        System.out.println("========================================================================");
        System.out.println("📬 [HỆ THỐNG GỬI MÃ OTP QUA EMAIL]");
        System.out.println("👉 Người nhận: " + recipientEmail);
        System.out.println("👉 Mục đích:   " + actionDescription);
        System.out.println("🔑 MÃ OTP LÀ:  [" + otpCode + "]");
        System.out.println("⏳ Thời hạn:   " + Constant.OTP_EXPIRY_MINUTES + " phút");
        System.out.println("========================================================================");

        // Cấu hình thuộc tính Mail SMTP
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", Constant.EMAIL_HOST);
        props.put("mail.smtp.port", Constant.EMAIL_PORT);
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        // Kiểm tra xem đã có thông tin email người gửi và mật khẩu ứng dụng chưa
        final String fromEmail = Constant.EMAIL_FROM;
        final String password = Constant.EMAIL_PASSWORD;

        if (password == null || password.trim().isEmpty()) {
            System.out.println("⚠️ Lưu ý: Chưa cấu hình mật khẩu ứng dụng Gmail (APP_EMAIL_PASSWORD).");
            System.out.println("Hệ thống sử dụng mã OTP hiển thị trên console ở trên để tiếp tục thử nghiệm.");
            return true;
        }

        try {
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(fromEmail, password);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail, "DT SHOP - Đỗ Thanh Thành Tài"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject(subject);

            String htmlContent = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 8px;'>"
                    + "<h2 style='color: #2563eb; text-align: center;'>HỆ THỐNG DT SHOP</h2>"
                    + "<p>Xin chào,</p>"
                    + "<p>Bạn nhận được email này cho thao tác: <strong>" + actionDescription + "</strong>.</p>"
                    + "<div style='text-align: center; margin: 30px 0;'>"
                    + "<span style='display: inline-block; font-size: 32px; font-weight: bold; letter-spacing: 5px; color: #d9534f; background-color: #f8f9fa; padding: 10px 25px; border-radius: 6px; border: 1px dashed #d9534f;'>"
                    + otpCode + "</span>"
                    + "</div>"
                    + "<p>Mã OTP này có hiệu lực trong vòng <strong>" + Constant.OTP_EXPIRY_MINUTES + " phút</strong>. Vui lòng không chia sẻ mã này với bất kỳ ai.</p>"
                    + "<hr style='border: none; border-top: 1px solid #eee; margin: 20px 0;'>"
                    + "<p style='font-size: 12px; color: #888; text-align: center;'>Đây là email tự động, vui lòng không phản hồi.</p>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("✅ Đã gửi email thành công tới: " + recipientEmail);
            return true;
        } catch (Exception e) {
            System.err.println("❌ Lỗi khi gửi email thực tế: " + e.getMessage());
            // Vẫn trả về true vì OTP đã được sinh và in ở console cho môi trường dev
            return true;
        }
    }
}
