package vn.iotstar.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import vn.iotstar.utils.Constant;

@WebServlet(urlPatterns = { "/image" })
public class DownloadImageController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String DEFAULT_SVG = "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"200\" height=\"200\" viewBox=\"0 0 200 200\">"
            + "<rect width=\"200\" height=\"200\" fill=\"#e2e8f0\" rx=\"100\"/>"
            + "<circle cx=\"100\" cy=\"80\" r=\"35\" fill=\"#94a3b8\"/>"
            + "<path d=\"M45 165c0-30 25-55 55-55s55 25 55 55\" fill=\"#94a3b8\"/>"
            + "</svg>";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fname = req.getParameter("fname");
        if (fname == null || fname.trim().isEmpty()) {
            sendDefaultSvg(resp);
            return;
        }

        // Nếu fname là URL bên ngoài (http / https), chuyển hướng trực tiếp
        if (fname.startsWith("http://") || fname.startsWith("https://")) {
            resp.sendRedirect(fname);
            return;
        }

        String filePath = Constant.UPLOAD_DIR + File.separator + fname;
        File file = new File(filePath);

        if (!file.exists()) {
            sendDefaultSvg(resp);
            return;
        }

        String mimeType = getServletContext().getMimeType(file.getName());
        if (mimeType == null) {
            mimeType = "application/octet-stream";
        }
        resp.setContentType(mimeType);
        resp.setContentLengthLong(file.length());

        try (FileInputStream fis = new FileInputStream(file);
             OutputStream os = resp.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }
        }
    }

    private void sendDefaultSvg(HttpServletResponse resp) throws IOException {
        resp.setContentType("image/svg+xml");
        byte[] bytes = DEFAULT_SVG.getBytes(StandardCharsets.UTF_8);
        resp.setContentLength(bytes.length);
        try (OutputStream os = resp.getOutputStream()) {
            os.write(bytes);
        }
    }
}
