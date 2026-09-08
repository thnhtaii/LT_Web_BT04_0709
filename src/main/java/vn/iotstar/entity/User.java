package vn.iotstar.entity;

import java.io.Serializable;
import java.sql.Timestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;

@Entity
@Table(name = "users")
@NamedQuery(name = "User.findAll", query = "SELECT u FROM User u")
public class User implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "username", length = 50, unique = true, nullable = false)
    private String username;

    @Column(name = "email", length = 100, unique = true, nullable = false)
    private String email;

    @Column(name = "password", length = 255, nullable = false)
    private String password;

    @Column(name = "fullname", columnDefinition = "NVARCHAR(100) NULL")
    private String fullname;

    @Column(name = "phone", length = 20, nullable = true)
    private String phone;

    @Column(name = "images", columnDefinition = "NVARCHAR(255) NULL")
    private String images;

    @Column(name = "avatar", columnDefinition = "NVARCHAR(255) NULL")
    private String avatar;

    @Column(name = "roleId")
    private int roleId = 2; // 1: Admin, 2: User

    @Column(name = "status")
    private int status = 0; // 0: Inactive (pending OTP), 1: Active, 2: Locked

    @Column(name = "otpCode", length = 10, nullable = true)
    private String otpCode;

    @Column(name = "otpExpiry", nullable = true)
    private Timestamp otpExpiry;

    public User() {
    }

    public User(String username, String email, String password, String fullname) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.fullname = fullname;
        this.roleId = 2;
        this.status = 0;
    }

    public User(String username, String email, String password, String fullname, String phone, String images) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.fullname = fullname;
        this.phone = phone;
        this.images = images;
        this.avatar = images;
        this.roleId = 2;
        this.status = 1;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getImages() {
        return images != null && !images.isEmpty() ? images : avatar;
    }

    public void setImages(String images) {
        this.images = images;
        if (this.avatar == null || this.avatar.isEmpty()) {
            this.avatar = images;
        }
    }

    public String getAvatar() {
        return avatar != null && !avatar.isEmpty() ? avatar : images;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
        if (this.images == null || this.images.isEmpty()) {
            this.images = avatar;
        }
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getOtpCode() {
        return otpCode;
    }

    public void setOtpCode(String otpCode) {
        this.otpCode = otpCode;
    }

    public Timestamp getOtpExpiry() {
        return otpExpiry;
    }

    public void setOtpExpiry(Timestamp otpExpiry) {
        this.otpExpiry = otpExpiry;
    }

    public boolean isAdmin() {
        return this.roleId == 1;
    }
}
