package vn.iotstar.service;

import java.util.List;

import vn.iotstar.dao.IProductDao;
import vn.iotstar.dao.ProductDao;
import vn.iotstar.entity.Product;

public class ProductServiceImpl implements IProductService {

    private IProductDao productDao = new ProductDao();

    @Override
    public void insert(Product product) {
        productDao.insert(product);
    }

    @Override
    public void update(Product product) {
        productDao.update(product);
    }

    @Override
    public void delete(int productId) throws Exception {
        productDao.delete(productId);
    }

    @Override
    public Product findById(int productId) {
        return productDao.findById(productId);
    }

    @Override
    public List<Product> findAll() {
        return productDao.findAll();
    }

    @Override
    public List<Product> findAll(int page, int pageSize) {
        return productDao.findAll(page, pageSize);
    }

    @Override
    public List<Product> findTop10Recent() {
        return productDao.findTop10Recent();
    }

    @Override
    public List<Product> findByCategoryId(int categoryId) {
        return productDao.findByCategoryId(categoryId);
    }

    @Override
    public List<Product> findByCategoryId(int categoryId, int page, int pageSize) {
        return productDao.findByCategoryId(categoryId, page, pageSize);
    }

    @Override
    public int count() {
        return productDao.count();
    }

    @Override
    public int countByCategoryId(int categoryId) {
        return productDao.countByCategoryId(categoryId);
    }

    @Override
    public List<Product> searchByName(String keyword, int page, int pageSize) {
        return productDao.searchByName(keyword, page, pageSize);
    }

    @Override
    public int countSearch(String keyword) {
        return productDao.countSearch(keyword);
    }
}
