package vn.iotstar.utils;

import java.io.File;

public class Constant {
    // Thư mục lưu trữ hình ảnh tải lên
    public static final String UPLOAD_DIR = "c:\\Users\\dotai\\Documents\\workspace-spring-tools-for-eclipse-5.3.0.RELEASE\\BT04_0709\\uploads";

    static {
        File dir = new File(UPLOAD_DIR);
        if (!dir.exists()) {
            dir.mkdirs();
        }
    }
}
