package vn.iotstar.dao;

import java.util.List;
import vn.iotstar.entity.User;

public interface IUserDao {

    void insert(User user);

    void update(User user);

    void delete(int id) throws Exception;

    User findById(int id);

    User findByUsername(String username);

    User findByEmail(String email);

    boolean checkExistUsername(String username);

    boolean checkExistEmail(String email);

    List<User> findAll();
}
