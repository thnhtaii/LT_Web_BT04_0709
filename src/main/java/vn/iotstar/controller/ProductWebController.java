package vn.iotstar.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import vn.iotstar.entity.Category;
import vn.iotstar.entity.Product;
import vn.iotstar.service.CategoryServiceImpl;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.IProductService;
import vn.iotstar.service.ProductServiceImpl;
import vn.iotstar.utils.Constant;

@WebServlet(urlPatterns = { "/product", "/product/detail" })
public class ProductWebController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private IProductService productService = new ProductServiceImpl();
    private ICategoryService categoryService = new CategoryServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String uri = req.getRequestURI();

        if (uri.contains("/product/detail")) {
            handleDetail(req, resp);
        } else {
            handleList(req, resp);
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int page = 1;
        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int pageSize = Constant.PAGE_SIZE; // 6 sản phẩm / trang

        String categoryIdParam = req.getParameter("categoryId");
        String keyword = req.getParameter("keyword");

        List<Product> listProduct;
        int totalProducts;

        if (categoryIdParam != null && !categoryIdParam.trim().isEmpty()) {
            int categoryId = Integer.parseInt(categoryIdParam);
            listProduct = productService.findByCategoryId(categoryId, page - 1, pageSize);
            totalProducts = productService.countByCategoryId(categoryId);
            req.setAttribute("selectedCategoryId", categoryId);
        } else if (keyword != null && !keyword.trim().isEmpty()) {
            listProduct = productService.searchByName(keyword.trim(), page - 1, pageSize);
            totalProducts = productService.countSearch(keyword.trim());
            req.setAttribute("keyword", keyword.trim());
        } else {
            listProduct = productService.findAll(page - 1, pageSize);
            totalProducts = productService.count();
        }

        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
        if (totalPages < 1) totalPages = 1;

        List<Category> categories = categoryService.findAll();

        req.setAttribute("listProduct", listProduct);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalProducts", totalProducts);
        req.setAttribute("categories", categories);

        req.getRequestDispatcher("/views/web/product-list.jsp").forward(req, resp);
    }

    private void handleDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/product");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            Product product = productService.findById(id);
            if (product == null) {
                resp.sendRedirect(req.getContextPath() + "/product");
                return;
            }

            List<Product> relatedProducts = null;
            if (product.getCategory() != null) {
                relatedProducts = productService.findByCategoryId(product.getCategory().getCategoryId(), 0, 4);
                // Loại trừ chính sản phẩm đang xem
                relatedProducts.removeIf(p -> p.getProductId() == product.getProductId());
            }

            req.setAttribute("product", product);
            req.setAttribute("relatedProducts", relatedProducts);
            req.getRequestDispatcher("/views/web/product-detail.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/product");
        }
    }
}
