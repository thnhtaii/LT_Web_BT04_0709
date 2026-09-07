package vn.iotstar.service;

import java.util.List;
import vn.iotstar.entity.User;

public interface IUserService {

    User findById(int id);

    User findByUsername(String username);

    void update(User user);

    void updateProfile(int id, String fullname, String phone, String images);

    void insert(User user);

    List<User> findAll();
}
