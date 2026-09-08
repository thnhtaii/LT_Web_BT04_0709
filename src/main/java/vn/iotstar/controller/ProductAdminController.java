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
            String description = req.getParameter("description");
            double price = Double.parseDouble(req.getParameter("price"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));
            int status = Integer.parseInt(req.getParameter("status"));
            int categoryId = Integer.parseInt(req.getParameter("categoryId"));
            String images = req.getParameter("images");

            Product product = new Product();
            product.setProductName(productName);
            product.setDescription(description);
            product.setPrice(price);
            product.setQuantity(quantity);
            product.setStatus(status);
            product.setCreateDate(new Timestamp(System.currentTimeMillis()));

            Category category = categoryService.findById(categoryId);
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
                    String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    int index = filename.lastIndexOf(".");
                    String ext = filename.substring(index + 1);
                    fname = System.currentTimeMillis() + "." + ext;
                    part.write(uploadPath + File.separator + fname);
                    product.setImages(fname);
                } else if (images != null && !images.isEmpty()) {
                    product.setImages(images);
                } else {
                    product.setImages("product-default.png");
                }
            } catch (FileNotFoundException fne) {
                fne.printStackTrace();
            }

            productService.insert(product);
            resp.sendRedirect(req.getContextPath() + "/admin/products");

        } else if (url.contains("/admin/product/update")) {
            int productId = Integer.parseInt(req.getParameter("productId"));
            String productName = req.getParameter("productName");
            String description = req.getParameter("description");
            double price = Double.parseDouble(req.getParameter("price"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));
            int status = Integer.parseInt(req.getParameter("status"));
            int categoryId = Integer.parseInt(req.getParameter("categoryId"));
            String images = req.getParameter("images");

            Product product = productService.findById(productId);
            String fileold = product.getImages();

            product.setProductName(productName);
            product.setDescription(description);
            product.setPrice(price);
            product.setQuantity(quantity);
            product.setStatus(status);

            Category category = categoryService.findById(categoryId);
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
                    if (fileold != null && !fileold.isEmpty() && fileold.length() >= 5
                            && !fileold.substring(0, 5).equals("https")) {
                        deleteFile(uploadPath + File.separator + fileold);
                    }

                    String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    int index = filename.lastIndexOf(".");
                    String ext = filename.substring(index + 1);
                    fname = System.currentTimeMillis() + "." + ext;
                    part.write(uploadPath + File.separator + fname);
                    product.setImages(fname);
                } else if (images != null && !images.isEmpty()) {
                    product.setImages(images);
                } else {
                    product.setImages(fileold);
                }
            } catch (FileNotFoundException fne) {
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
