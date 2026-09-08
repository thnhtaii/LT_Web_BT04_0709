package vn.iotstar.dao;

import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;

import vn.iotstar.config.JPAConfig;
import vn.iotstar.entity.Product;

public class ProductDao implements IProductDao {

    @Override
    public void insert(Product product) {
        EntityManager enma = JPAConfig.getEntityManager();
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();
            enma.persist(product);
            trans.commit();
        } catch (Exception e) {
            trans.rollback();
            throw e;
        } finally {
            enma.close();
        }
    }

    @Override
    public void update(Product product) {
        EntityManager enma = JPAConfig.getEntityManager();
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();
            enma.merge(product);
            trans.commit();
        } catch (Exception e) {
            trans.rollback();
            throw e;
        } finally {
            enma.close();
        }
    }

    @Override
    public void delete(int productId) throws Exception {
        EntityManager enma = JPAConfig.getEntityManager();
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();
            Product product = enma.find(Product.class, productId);
            if (product != null) {
                enma.remove(product);
            } else {
                throw new Exception("Không tìm thấy sản phẩm");
            }
            trans.commit();
        } catch (Exception e) {
            trans.rollback();
            throw e;
        } finally {
            enma.close();
        }
    }

    @Override
    public Product findById(int productId) {
        EntityManager enma = JPAConfig.getEntityManager();
        try {
            return enma.find(Product.class, productId);
        } finally {
            enma.close();
        }
    }

    @Override
    public List<Product> findAll() {
        EntityManager enma = JPAConfig.getEntityManager();
        try {
            TypedQuery<Product> query = enma.createQuery("SELECT p FROM Product p ORDER BY p.productId DESC", Product.class);
            return query.getResultList();
        } finally {
            enma.close();
        }
    }

    @Override
    public List<Product> findAll(int page, int pageSize) {
        EntityManager enma = JPAConfig.getEntityManager();
        try {
            TypedQuery<Product> query = enma.createQuery("SELECT p FROM Product p ORDER BY p.productId DESC", Product.class);
            query.setFirstResult(page * pageSize);
            query.setMaxResults(pageSize);
            return query.getResultList();
        } finally {
            enma.close();
        }
    }

    @Override
    public List<Product> findTop10Recent() {
        EntityManager enma = JPAConfig.getEntityManager();
        try {
            TypedQuery<Product> query = enma.createQuery(
                "SELECT p FROM Product p ORDER BY p.createDate DESC, p.productId DESC", Product.class);
            query.setMaxResults(10);
            return query.getResultList();
        } finally {
            enma.close();
        }
    }

    @Override
    public List<Product> findByCategoryId(int categoryId) {
        EntityManager enma = JPAConfig.getEntityManager();
        try {
            TypedQuery<Product> query = enma.createQuery(
                "SELECT p FROM Product p WHERE p.category.categoryId = :catId ORDER BY p.productId DESC", Product.class);
            query.setParameter("catId", categoryId);
            return query.getResultList();
        } finally {
            enma.close();
        }
    }

    @Override
    public List<Product> findByCategoryId(int categoryId, int page, int pageSize) {
        EntityManager enma = JPAConfig.getEntityManager();
        try {
            TypedQuery<Product> query = enma.createQuery(
                "SELECT p FROM Product p WHERE p.category.categoryId = :catId ORDER BY p.productId DESC", Product.class);
            query.setParameter("catId", categoryId);
            query.setFirstResult(page * pageSize);
            query.setMaxResults(pageSize);
            return query.getResultList();
        } finally {
            enma.close();
        }
    }

    @Override
    public int count() {
        EntityManager enma = JPAConfig.getEntityManager();
        try {
            Query query = enma.createQuery("SELECT COUNT(p) FROM Product p");
            return ((Long) query.getSingleResult()).intValue();
        } finally {
            enma.close();
        }
    }

    @Override
    public int countByCategoryId(int categoryId) {
        EntityManager enma = JPAConfig.getEntityManager();
        try {
            Query query = enma.createQuery("SELECT COUNT(p) FROM Product p WHERE p.category.categoryId = :catId");
            query.setParameter("catId", categoryId);
            return ((Long) query.getSingleResult()).intValue();
        } finally {
            enma.close();
        }
    }

    @Override
    public List<Product> searchByName(String keyword, int page, int pageSize) {
        EntityManager enma = JPAConfig.getEntityManager();
        try {
            TypedQuery<Product> query = enma.createQuery(
                "SELECT p FROM Product p WHERE p.productName LIKE :kw ORDER BY p.productId DESC", Product.class);
            query.setParameter("kw", "%" + keyword + "%");
            query.setFirstResult(page * pageSize);
            query.setMaxResults(pageSize);
            return query.getResultList();
        } finally {
            enma.close();
        }
    }

    @Override
    public int countSearch(String keyword) {
        EntityManager enma = JPAConfig.getEntityManager();
        try {
            Query query = enma.createQuery("SELECT COUNT(p) FROM Product p WHERE p.productName LIKE :kw");
            query.setParameter("kw", "%" + keyword + "%");
            return ((Long) query.getSingleResult()).intValue();
        } finally {
            enma.close();
        }
    }
}
