package vn.iotstar.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import vn.iotstar.entity.Category;
import vn.iotstar.entity.Product;
import vn.iotstar.service.CategoryServiceImpl;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.IProductService;
import vn.iotstar.service.ProductServiceImpl;
import vn.iotstar.utils.Constant;

@MultipartConfig()
@WebServlet(urlPatterns = { "/admin/products", "/admin/product/add", "/admin/product/insert",
        "/admin/product/edit", "/admin/product/update", "/admin/product/delete" })
public class ProductAdminController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private IProductService productService = new ProductServiceImpl();
    private ICategoryService categoryService = new CategoryServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String url = req.getRequestURI();

        if (url.contains("/admin/products")) {
            List<Product> list = productService.findAll();
            req.setAttribute("listproduct", list);
            req.getRequestDispatcher("/views/admin/product-list.jsp").forward(req, resp);

        } else if (url.contains("/admin/product/add")) {
            List<Category> categories = categoryService.findAll();
            req.setAttribute("categories", categories);
            req.getRequestDispatcher("/views/admin/product-add.jsp").forward(req, resp);

        } else if (url.contains("/admin/product/edit")) {
            int id = Integer.parseInt(req.getParameter("id"));
            Product product = productService.findById(id);
            List<Category> categories = categoryService.findAll();
            req.setAttribute("product", product);
            req.setAttribute("categories", categories);
            req.getRequestDispatcher("/views/admin/product-edit.jsp").forward(req, resp);

        } else if (url.contains("/admin/product/delete")) {
            int id = Integer.parseInt(req.getParameter("id"));
            try {
                productService.delete(id);
                resp.sendRedirect(req.getContextPath() + "/admin/products?msg=deleted");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/admin/products?error=delete_failed");
                return;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String url = req.getRequestURI();

        if (url.contains("/admin/product/insert")) {
            String productName = req.getParameter("productName");
            productName = (productName != null) ? productName.trim() : "";
            String description = req.getParameter("description");
            String priceStr = req.getParameter("price");
            String quantityStr = req.getParameter("quantity");
            String statusParam = req.getParameter("status");
            String categoryIdStr = req.getParameter("categoryId");
            String images = req.getParameter("images");

            req.setAttribute("productName", productName);
            req.setAttribute("description", description);
            req.setAttribute("price", priceStr);
            req.setAttribute("quantity", quantityStr);
            req.setAttribute("categoryId", categoryIdStr);

            List<Category> categories = categoryService.findAll();
            req.setAttribute("categories", categories);

            if (productName.isEmpty() || productName.length() < 2 || productName.length() > 255) {
                req.setAttribute("error", "Tên sản phẩm bắt buộc phải từ 2 đến 255 ký tự!");
                req.getRequestDispatcher("/views/admin/product-add.jsp").forward(req, resp);
                return;
            }

            int categoryId = 0;
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (Exception e) {
                req.setAttribute("error", "Vui lòng chọn danh mục hợp lệ cho sản phẩm!");
                req.getRequestDispatcher("/views/admin/product-add.jsp").forward(req, resp);
                return;
            }

            Category category = categoryService.findById(categoryId);
            if (category == null) {
                req.setAttribute("error", "Danh mục đã chọn không tồn tại trên hệ thống!");
                req.getRequestDispatcher("/views/admin/product-add.jsp").forward(req, resp);
                return;
            }

            double price = 0;
            try {
                price = Double.parseDouble(priceStr);
                if (price <= 0) {
                    req.setAttribute("error", "Giá bán sản phẩm phải lớn hơn 0 VNĐ!");
                    req.getRequestDispatcher("/views/admin/product-add.jsp").forward(req, resp);
                    return;
                }
            } catch (Exception e) {
                req.setAttribute("error", "Giá bán không hợp lệ! Vui lòng nhập một số dương.");
                req.getRequestDispatcher("/views/admin/product-add.jsp").forward(req, resp);
                return;
            }

            int quantity = 0;
            try {
                quantity = Integer.parseInt(quantityStr);
                if (quantity < 0) {
                    req.setAttribute("error", "Số lượng tồn kho không được âm!");
                    req.getRequestDispatcher("/views/admin/product-add.jsp").forward(req, resp);
                    return;
                }
            } catch (Exception e) {
                req.setAttribute("error", "Số lượng tồn kho không hợp lệ! Vui lòng nhập một số nguyên không âm.");
                req.getRequestDispatcher("/views/admin/product-add.jsp").forward(req, resp);
                return;
            }

            int status = 1;
            try {
                status = Integer.parseInt(statusParam);
            } catch (Exception e) {
                status = 1;
            }

            Product product = new Product();
            product.setProductName(productName);
            product.setDescription(description);
            product.setPrice(price);
            product.setQuantity(quantity);
            product.setStatus(status);
            product.setCreateDate(new Timestamp(System.currentTimeMillis()));
            product.setCategory(category);

            String fname = "";
            String uploadPath = Constant.DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            try {
                Part part = req.getPart("images1");
                if (part != null && part.getSize() > 0) {
                    if (part.getSize() > 5 * 1024 * 1024) {
                        req.setAttribute("error", "Dung lượng ảnh sản phẩm vượt quá 5MB!");
                        req.getRequestDispatcher("/views/admin/product-add.jsp").forward(req, resp);
                        return;
                    }

                    String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    int index = filename.lastIndexOf(".");
                    String ext = (index >= 0) ? filename.substring(index).toLowerCase() : "";
                    if (!ext.equals(".png") && !ext.equals(".jpg") && !ext.equals(".jpeg") && !ext.equals(".webp")) {
                        req.setAttribute("error", "Định dạng file không hợp lệ! Chỉ chấp nhận ảnh (.jpg, .jpeg, .png, .webp).");
                        req.getRequestDispatcher("/views/admin/product-add.jsp").forward(req, resp);
                        return;
                    }

                    fname = System.currentTimeMillis() + ext;
                    part.write(uploadPath + File.separator + fname);
                    product.setImages(fname);
                } else if (images != null && !images.trim().isEmpty()) {
                    product.setImages(images.trim());
                } else {
                    product.setImages("https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500");
                }
            } catch (Exception fne) {
                fne.printStackTrace();
            }

            productService.insert(product);
            resp.sendRedirect(req.getContextPath() + "/admin/products");

        } else if (url.contains("/admin/product/update")) {
            int productId = 0;
            try {
                productId = Integer.parseInt(req.getParameter("productId"));
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/admin/products");
                return;
            }

            Product product = productService.findById(productId);
            if (product == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/products");
                return;
            }

            List<Category> categories = categoryService.findAll();
            req.setAttribute("categories", categories);

            String productName = req.getParameter("productName");
            productName = (productName != null) ? productName.trim() : "";
            String description = req.getParameter("description");
            String priceStr = req.getParameter("price");
            String quantityStr = req.getParameter("quantity");
            String statusParam = req.getParameter("status");
            String categoryIdStr = req.getParameter("categoryId");
            String images = req.getParameter("images");

            if (productName.isEmpty() || productName.length() < 2 || productName.length() > 255) {
                req.setAttribute("error", "Tên sản phẩm bắt buộc phải từ 2 đến 255 ký tự!");
                req.setAttribute("product", product);
                req.getRequestDispatcher("/views/admin/product-edit.jsp").forward(req, resp);
                return;
            }

            int categoryId = 0;
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (Exception e) {
                req.setAttribute("error", "Vui lòng chọn danh mục hợp lệ!");
                req.setAttribute("product", product);
                req.getRequestDispatcher("/views/admin/product-edit.jsp").forward(req, resp);
                return;
            }

            Category category = categoryService.findById(categoryId);
            if (category == null) {
                req.setAttribute("error", "Danh mục đã chọn không tồn tại!");
                req.setAttribute("product", product);
                req.getRequestDispatcher("/views/admin/product-edit.jsp").forward(req, resp);
                return;
            }

            double price = 0;
            try {
                price = Double.parseDouble(priceStr);
                if (price <= 0) {
                    req.setAttribute("error", "Giá bán sản phẩm phải lớn hơn 0 VNĐ!");
                    req.setAttribute("product", product);
                    req.getRequestDispatcher("/views/admin/product-edit.jsp").forward(req, resp);
                    return;
                }
            } catch (Exception e) {
                req.setAttribute("error", "Giá bán không hợp lệ!");
                req.setAttribute("product", product);
                req.getRequestDispatcher("/views/admin/product-edit.jsp").forward(req, resp);
                return;
            }

            int quantity = 0;
            try {
                quantity = Integer.parseInt(quantityStr);
                if (quantity < 0) {
                    req.setAttribute("error", "Số lượng tồn kho không được âm!");
                    req.setAttribute("product", product);
                    req.getRequestDispatcher("/views/admin/product-edit.jsp").forward(req, resp);
                    return;
                }
            } catch (Exception e) {
                req.setAttribute("error", "Số lượng không hợp lệ!");
                req.setAttribute("product", product);
                req.getRequestDispatcher("/views/admin/product-edit.jsp").forward(req, resp);
                return;
            }

            int status = 1;
            try {
                status = Integer.parseInt(statusParam);
            } catch (Exception e) {
                status = 1;
            }

            String fileold = product.getImages();
            product.setProductName(productName);
            product.setDescription(description);
            product.setPrice(price);
            product.setQuantity(quantity);
            product.setStatus(status);
            product.setCategory(category);

            String fname = "";
            String uploadPath = Constant.DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            try {
                Part part = req.getPart("images1");
                if (part != null && part.getSize() > 0) {
                    if (part.getSize() > 5 * 1024 * 1024) {
                        req.setAttribute("error", "Dung lượng ảnh vượt quá 5MB!");
                        req.setAttribute("product", product);
                        req.getRequestDispatcher("/views/admin/product-edit.jsp").forward(req, resp);
                        return;
                    }

                    String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    int index = filename.lastIndexOf(".");
                    String ext = (index >= 0) ? filename.substring(index).toLowerCase() : "";
                    if (!ext.equals(".png") && !ext.equals(".jpg") && !ext.equals(".jpeg") && !ext.equals(".webp")) {
                        req.setAttribute("error", "Định dạng file không hợp lệ! Chỉ chấp nhận ảnh (.jpg, .jpeg, .png, .webp).");
                        req.setAttribute("product", product);
                        req.getRequestDispatcher("/views/admin/product-edit.jsp").forward(req, resp);
                        return;
                    }

                    if (fileold != null && !fileold.isEmpty() && !fileold.startsWith("http")) {
                        deleteFile(uploadPath + File.separator + fileold);
                    }

                    fname = System.currentTimeMillis() + ext;
                    part.write(uploadPath + File.separator + fname);
                    product.setImages(fname);
                } else if (images != null && !images.trim().isEmpty()) {
                    product.setImages(images.trim());
                } else {
                    product.setImages(fileold);
                }
            } catch (Exception fne) {
                fne.printStackTrace();
            }

            productService.update(product);
            resp.sendRedirect(req.getContextPath() + "/admin/products");
        }
    }

    private void deleteFile(String filePath) {
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
