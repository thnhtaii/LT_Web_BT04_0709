<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Cập nhật hồ sơ cá nhân</title>
    <style>
        .profile-card {
            background: #ffffff;
            border-radius: 16px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.04), 0 8px 10px -6px rgba(0, 0, 0, 0.04);
            padding: 2rem;
            transition: all 0.3s ease;
        }

        .avatar-preview-container {
            position: relative;
            width: 150px;
            height: 150px;
            margin: 0 auto 1.5rem auto;
        }

        .avatar-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
            border: 4px solid #ffffff;
            box-shadow: 0 8px 20px rgba(79, 70, 229, 0.18);
        }

        .btn-upload-badge {
            position: absolute;
            bottom: 6px;
            right: 6px;
            background: #4f46e5;
            color: #ffffff;
            border: 2px solid #ffffff;
            border-radius: 50%;
            width: 38px;
            height: 38px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
            transition: transform 0.2s, background 0.2s;
        }

        .btn-upload-badge:hover {
            transform: scale(1.1);
            background: #4338ca;
            color: #ffffff;
        }

        .form-label {
            font-weight: 600;
            font-size: 0.875rem;
            color: #475569;
            margin-bottom: 0.4rem;
        }

        .form-control {
            border-radius: 10px;
            border: 1px solid #cbd5e1;
            padding: 0.65rem 1rem;
            font-size: 0.95rem;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }

        .form-control:focus {
            border-color: #6366f1;
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.15);
        }

        .form-control[readonly] {
            background-color: #f1f5f9;
            color: #64748b;
        }

        .btn-save {
            background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
            color: #ffffff;
            border: none;
            border-radius: 10px;
            padding: 0.75rem 1.75rem;
            font-weight: 600;
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.25);
            transition: all 0.2s ease;
        }

        .btn-save:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(79, 70, 229, 0.35);
            color: #ffffff;
        }

        .badge-role {
            background-color: #e0e7ff;
            color: #4338ca;
            font-weight: 700;
            padding: 0.35rem 0.8rem;
            border-radius: 20px;
            font-size: 0.8rem;
        }
    </style>
</head>
<body>

    <!-- Header Section -->
    <div class="row justify-content-center mb-4">
        <div class="col-lg-10">
            <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
                <div>
                    <h3 class="fw-bold mb-1 text-dark">Hồ sơ cá nhân</h3>
                    <p class="text-muted mb-0">Quản lý và cập nhật thông tin họ tên, số điện thoại và ảnh đại diện</p>
                </div>
                <div>
                    <span class="badge-role">
                        <i class="fa-solid fa-shield-halved me-1"></i>
                        <c:choose>
                            <c:when test="${user.roleId == 1}">Quản trị viên (Admin)</c:when>
                            <c:otherwise>Thành viên (User)</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>
        </div>
    </div>

    <!-- Alert Notifications -->
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <c:if test="${param.msg == 'success'}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm d-flex align-items-center gap-2" role="alert">
                    <i class="fa-solid fa-circle-check fs-5 text-success"></i>
                    <div><strong>Thành công!</strong> Cập nhật thông tin hồ sơ của bạn thành công.</div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm d-flex align-items-center gap-2" role="alert">
                    <i class="fa-solid fa-circle-exclamation fs-5 text-danger"></i>
                    <div><strong>Thất bại!</strong> <c:out value="${error}"/></div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Main Content Form -->
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <form action="${pageContext.request.contextPath}/profile" method="post" enctype="multipart/form-data">
                <div class="row g-4">
                    <!-- Left Column: Avatar Preview -->
                    <div class="col-md-4">
                        <div class="profile-card text-center h-100 d-flex flex-column justify-content-center">
                            <div class="avatar-preview-container">
                                <c:choose>
                                    <c:when test="${not empty user.images}">
                                        <img id="avatarPreview" src="${pageContext.request.contextPath}/image?fname=${user.images}" 
                                             class="avatar-img" alt="Avatar">
                                    </c:when>
                                    <c:otherwise>
                                        <img id="avatarPreview" src="${pageContext.request.contextPath}/image" 
                                             class="avatar-img" alt="Default Avatar">
                                    </c:otherwise>
                                </c:choose>

                                <!-- Trigger Upload Button -->
                                <label for="imageFileInput" class="btn-upload-badge" title="Tải ảnh mới">
                                    <i class="fa-solid fa-camera"></i>
                                </label>
                            </div>

                            <h5 class="fw-bold mb-1 text-dark" id="displayFullname">
                                <c:out value="${user.fullname != null && !user.fullname.isEmpty() ? user.fullname : 'Chưa cập nhật tên'}" />
                            </h5>
                            <p class="text-muted small mb-3">@<c:out value="${user.username}" /></p>

                            <!-- Hidden file input triggered by camera badge -->
                            <div class="mt-2 text-center">
                                <label for="imageFileInput" class="btn btn-sm btn-outline-primary rounded-pill px-3">
                                    <i class="fa-solid fa-upload me-1"></i> Chọn ảnh đại diện
                                </label>
                                <input type="file" class="d-none" id="imageFileInput" name="imageFile" accept="image/*">
                                <div class="text-muted small mt-2" id="fileNameHint" style="font-size: 0.75rem;">Định dạng: JPG, PNG, WEBP (Tối đa 10MB)</div>
                            </div>
                        </div>
                    </div>

                    <!-- Right Column: Profile Form Details -->
                    <div class="col-md-8">
                        <div class="profile-card">
                            <h5 class="fw-bold text-dark border-bottom pb-3 mb-4">
                                <i class="fa-solid fa-user-pen me-2 text-primary"></i>Thông tin tài khoản
                            </h5>

                            <div class="row g-3">
                                <!-- Username (Readonly) -->
                                <div class="col-md-6">
                                    <label class="form-label">Tên đăng nhập (Username)</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-muted border-end-0">
                                            <i class="fa-regular fa-user"></i>
                                        </span>
                                        <input type="text" class="form-control border-start-0" value="${user.username}" readonly>
                                    </div>
                                    <small class="text-muted">Tên đăng nhập không thể thay đổi</small>
                                </div>

                                <!-- Email (Readonly) -->
                                <div class="col-md-6">
                                    <label class="form-label">Địa chỉ Email</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-muted border-end-0">
                                            <i class="fa-regular fa-envelope"></i>
                                        </span>
                                        <input type="email" class="form-control border-start-0" value="${user.email}" readonly>
                                    </div>
                                    <small class="text-muted">Email liên kết với tài khoản</small>
                                </div>

                                <!-- Fullname (Editable) -->
                                <div class="col-12">
                                    <label for="fullnameInput" class="form-label">
                                        Họ và tên <span class="text-danger">*</span>
                                    </label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-white text-muted border-end-0">
                                            <i class="fa-solid fa-signature"></i>
                                        </span>
                                        <input type="text" class="form-control border-start-0" id="fullnameInput" 
                                               name="fullname" value="${user.fullname}" placeholder="Nhập họ và tên đầy đủ" required>
                                    </div>
                                </div>

                                <!-- Phone (Editable) -->
                                <div class="col-12">
                                    <label for="phoneInput" class="form-label">
                                        Số điện thoại <span class="text-danger">*</span>
                                    </label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-white text-muted border-end-0">
                                            <i class="fa-solid fa-phone"></i>
                                        </span>
                                        <input type="tel" class="form-control border-start-0" id="phoneInput" 
                                               name="phone" value="${user.phone}" placeholder="Ví dụ: 0912345678" pattern="[0-9]{9,11}">
                                    </div>
                                    <small class="text-muted">Số điện thoại liên hệ (9 - 11 chữ số)</small>
                                </div>
                            </div>

                            <!-- Form Actions -->
                            <div class="mt-4 pt-3 border-top d-flex justify-content-end gap-2">
                                <a href="${pageContext.request.contextPath}/profile" class="btn btn-light rounded-pill px-4 fw-semibold text-secondary">
                                    <i class="fa-solid fa-rotate-left me-1"></i> Đặt lại
                                </a>
                                <button type="submit" class="btn btn-save">
                                    <i class="fa-solid fa-floppy-disk me-1"></i> Lưu thay đổi
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Live Preview Script -->
    <script>
        document.getElementById('imageFileInput').addEventListener('change', function (e) {
            const file = e.target.files[0];
            if (file) {
                // Kiểm tra dung lượng file (tối đa 10MB)
                if (file.size > 10 * 1024 * 1024) {
                    alert('Dung lượng ảnh vượt quá 10MB! Vui lòng chọn ảnh khác.');
                    this.value = '';
                    return;
                }

                // Hiển thị xem trước ảnh ngay lập tức
                const reader = new FileReader();
                reader.onload = function (event) {
                    document.getElementById('avatarPreview').src = event.target.result;
                };
                reader.readAsDataURL(file);

                // Cập nhật tên file hiển thị
                document.getElementById('fileNameHint').innerHTML = 
                    '<strong class="text-primary"><i class="fa-solid fa-file-image me-1"></i>' + file.name + '</strong>';
            }
        });

        // Cập nhật họ tên realtime ở preview card khi gõ
        document.getElementById('fullnameInput').addEventListener('input', function () {
            const val = this.value.trim();
            document.getElementById('displayFullname').innerText = val ? val : 'Chưa cập nhật tên';
        });
    </script>
</body>
</html>
