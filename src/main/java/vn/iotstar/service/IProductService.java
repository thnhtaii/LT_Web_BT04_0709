package vn.iotstar.service;

import java.util.List;
import vn.iotstar.entity.Product;

public interface IProductService {

    void insert(Product product);

    void update(Product product);

    void delete(int productId) throws Exception;

    Product findById(int productId);

    List<Product> findAll();

    List<Product> findAll(int page, int pageSize);

    List<Product> findTop10Recent();

    List<Product> findByCategoryId(int categoryId);

    List<Product> findByCategoryId(int categoryId, int page, int pageSize);

    int count();

    int countByCategoryId(int categoryId);

    List<Product> searchByName(String keyword, int page, int pageSize);

    int countSearch(String keyword);
}
