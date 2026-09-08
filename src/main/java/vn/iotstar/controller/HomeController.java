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

@WebServlet(urlPatterns = { "/home" })
public class HomeController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private IProductService productService = new ProductServiceImpl();
    private ICategoryService categoryService = new CategoryServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        // Lấy 10 sản phẩm mới nhất
        List<Product> top10Products = productService.findTop10Recent();
        List<Category> categories = categoryService.findAll();

        req.setAttribute("top10Products", top10Products);
        req.setAttribute("categories", categories);

        req.getRequestDispatcher("/views/web/home.jsp").forward(req, resp);
    }
}
