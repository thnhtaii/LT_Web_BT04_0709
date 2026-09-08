package vn.iotstar.utils;

import java.io.File;

public class Constant {
    // Thư mục lưu trữ hình ảnh tải lên của BT04_0709
    public static final String UPLOAD_DIR = "c:\\Users\\dotai\\Documents\\workspace-spring-tools-for-eclipse-5.3.0.RELEASE\\BT04_0709\\uploads";

    // Alias DIR tương thích với các controller của BT02
    public static final String DIR = UPLOAD_DIR;

    // Cấu hình phân trang
    public static final int PAGE_SIZE = 6;
    public static final int TOP_RECENT_SIZE = 10;
    public static final int OTP_EXPIRY_MINUTES = 5;

    // Cấu hình gửi mail SMTP
    public static final String EMAIL_HOST = "smtp.gmail.com";
    public static final String EMAIL_PORT = "587";
    public static final String EMAIL_FROM = System.getProperty("APP_EMAIL_FROM", "dothanhthanhtai24133050@gmail.com");
    public static final String EMAIL_PASSWORD = System.getProperty("APP_EMAIL_PASSWORD", "");

    static {
        File dir = new File(UPLOAD_DIR);
        if (!dir.exists()) {
            dir.mkdirs();
        }
    }
}
