package vn.iotstar.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import vn.iotstar.entity.Category;
import vn.iotstar.service.CategoryServiceImpl;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.utils.Constant;

@MultipartConfig()
@WebServlet(urlPatterns = { "/admin/categories", "/admin/category/add", "/admin/category/insert",
        "/admin/category/edit", "/admin/category/update", "/admin/category/delete" })
public class CategoryController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public ICategoryService cateService = new CategoryServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String url = req.getRequestURI();

        if (url.contains("/admin/categories")) {
            List<Category> list = cateService.findAll();
            req.setAttribute("listcate", list);
            req.getRequestDispatcher("/views/admin/category-list.jsp").forward(req, resp);

        } else if (url.contains("/admin/category/add")) {
            req.getRequestDispatcher("/views/admin/category-add.jsp").forward(req, resp);

        } else if (url.contains("/admin/category/edit")) {
            int id = Integer.parseInt(req.getParameter("id"));
            Category category = cateService.findById(id);
            req.setAttribute("cate", category);
            req.getRequestDispatcher("/views/admin/category-edit.jsp").forward(req, resp);

        } else if (url.contains("/admin/category/delete")) {
            int id = Integer.parseInt(req.getParameter("id"));
            try {
                cateService.delete(id);
                resp.sendRedirect(req.getContextPath() + "/admin/categories?msg=deleted");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/admin/categories?error=delete_failed");
                return;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String url = req.getRequestURI();

        if (url.contains("/admin/category/insert")) {
            String categoryname = req.getParameter("categoryname");
            categoryname = (categoryname != null) ? categoryname.trim() : "";
            String statusParam = req.getParameter("status");
            int status = 1;
            if (statusParam != null && !statusParam.isEmpty()) {
                try {
                    status = Integer.parseInt(statusParam);
                } catch (NumberFormatException e) {
                    status = 1;
                }
            }
            String images = req.getParameter("images");

            if (categoryname.isEmpty() || categoryname.length() < 2 || categoryname.length() > 200) {
                req.setAttribute("error", "Tên danh mục bắt buộc phải từ 2 đến 200 ký tự!");
                req.setAttribute("categoryname", categoryname);
                req.getRequestDispatcher("/views/admin/category-add.jsp").forward(req, resp);
                return;
            }

            Category category = new Category();
            category.setCategoryname(categoryname);
            category.setStatus(status);

            String fname = "";
            String uploadPath = Constant.DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists())
                uploadDir.mkdirs();

            try {
                Part part = req.getPart("images1");
                if (part != null && part.getSize() > 0) {
                    if (part.getSize() > 5 * 1024 * 1024) {
                        req.setAttribute("error", "Dung lượng ảnh danh mục vượt quá 5MB!");
                        req.setAttribute("categoryname", categoryname);
                        req.getRequestDispatcher("/views/admin/category-add.jsp").forward(req, resp);
                        return;
                    }

                    String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    int index = filename.lastIndexOf(".");
                    String ext = (index >= 0) ? filename.substring(index).toLowerCase() : "";
                    if (!ext.equals(".png") && !ext.equals(".jpg") && !ext.equals(".jpeg") && !ext.equals(".webp")) {
                        req.setAttribute("error", "Định dạng file không hợp lệ! Chỉ chấp nhận ảnh (.jpg, .jpeg, .png, .webp).");
                        req.setAttribute("categoryname", categoryname);
                        req.getRequestDispatcher("/views/admin/category-add.jsp").forward(req, resp);
                        return;
                    }

                    fname = System.currentTimeMillis() + ext;
                    part.write(uploadPath + File.separator + fname);
                    category.setImages(fname);
                } else if (images != null && !images.trim().isEmpty()) {
                    category.setImages(images.trim());
                } else {
                    category.setImages("https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500");
                }
            } catch (Exception fne) {
                fne.printStackTrace();
            }

            cateService.insert(category);
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
        }

        if (url.contains("/admin/category/update")) {
            int categoryid = 0;
            try {
                categoryid = Integer.parseInt(req.getParameter("categoryid"));
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/admin/categories");
                return;
            }

            String categoryname = req.getParameter("categoryname");
            categoryname = (categoryname != null) ? categoryname.trim() : "";
            String statusParam = req.getParameter("status");
            int status = 1;
            if (statusParam != null && !statusParam.isEmpty()) {
                try {
                    status = Integer.parseInt(statusParam);
                } catch (NumberFormatException e) {
                    status = 1;
                }
            }
            String images = req.getParameter("images");

            Category category = cateService.findById(categoryid);
            if (category == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/categories");
                return;
            }

            if (categoryname.isEmpty() || categoryname.length() < 2 || categoryname.length() > 200) {
                req.setAttribute("error", "Tên danh mục bắt buộc phải từ 2 đến 200 ký tự!");
                req.setAttribute("category", category);
                req.getRequestDispatcher("/views/admin/category-edit.jsp").forward(req, resp);
                return;
            }

            String fileold = category.getImages();
            category.setCategoryname(categoryname);
            category.setStatus(status);

            String fname = "";
            String uploadPath = Constant.DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists())
                uploadDir.mkdirs();

            try {
                Part part = req.getPart("images1");
                if (part != null && part.getSize() > 0) {
                    if (part.getSize() > 5 * 1024 * 1024) {
                        req.setAttribute("error", "Dung lượng ảnh danh mục vượt quá 5MB!");
                        req.setAttribute("category", category);
                        req.getRequestDispatcher("/views/admin/category-edit.jsp").forward(req, resp);
                        return;
                    }

                    String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    int index = filename.lastIndexOf(".");
                    String ext = (index >= 0) ? filename.substring(index).toLowerCase() : "";
                    if (!ext.equals(".png") && !ext.equals(".jpg") && !ext.equals(".jpeg") && !ext.equals(".webp")) {
                        req.setAttribute("error", "Định dạng file không hợp lệ! Chỉ chấp nhận ảnh (.jpg, .jpeg, .png, .webp).");
                        req.setAttribute("category", category);
                        req.getRequestDispatcher("/views/admin/category-edit.jsp").forward(req, resp);
                        return;
                    }

                    if (fileold != null && !fileold.isEmpty() && !fileold.startsWith("http")) {
                        deleteFile(uploadPath + File.separator + fileold);
                    }

                    fname = System.currentTimeMillis() + ext;
                    part.write(uploadPath + File.separator + fname);
                    category.setImages(fname);
                } else if (images != null && !images.trim().isEmpty()) {
                    category.setImages(images.trim());
                } else {
                    category.setImages(fileold);
                }
            } catch (Exception fne) {
                fne.printStackTrace();
            }

            cateService.update(category);
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
        }
    }

    public static void deleteFile(String filePath) {
        try {
            Path path = Paths.get(filePath);
            if (Files.exists(path)) {
                Files.delete(path);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
