<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Tài Khoản - DT SHOP</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 30px 20px;
        }
        .auth-card {
            background: white;
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08);
            width: 100%;
            max-width: 480px;
            padding: 40px;
            border: 1px solid #f1f5f9;
            margin: 40px auto;
        }
        .auth-logo {
            font-size: 32px;
            color: #2563eb;
            text-align: center;
            margin-bottom: 10px;
        }
        .btn-submit {
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            border: none;
            padding: 12px;
            font-weight: 700;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
            transition: all 0.2s;
        }
        .btn-submit:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(37, 99, 235, 0.4);
        }
    </style>
</head>
<body>

    <div class="auth-card">
        <div class="auth-logo">
            <i class="fa-solid fa-cube"></i>
        </div>
        <h3 class="fw-bold text-center mb-1">Tạo tài khoản mới</h3>
        <p class="text-center text-muted small mb-4">Điền thông tin để đăng ký thành viên DT SHOP</p>

        <!-- Hộp thông báo OTP qua email -->
        <div class="alert alert-primary d-flex align-items-center small py-2 mb-3" role="alert">
            <i class="fa-solid fa-envelope-open-text me-2 fs-5"></i>
            <div>Hệ thống sẽ gửi <strong>mã xác thực OTP qua Email</strong> để kích hoạt tài khoản ngay sau khi đăng ký.</div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger d-flex align-items-center small py-2" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i> ${error}
            </div>
        </c:if>

        <form action="<c:url value='/register'/>" method="POST" class="needs-validation" novalidate id="registerForm">
            <div class="mb-3">
                <label class="form-label small fw-semibold text-secondary">Tên đăng nhập <span class="text-danger">*</span></label>
                <div class="input-group has-validation">
                    <span class="input-group-text bg-light border-end-0"><i class="fa-regular fa-user text-muted"></i></span>
                    <input type="text" name="username" class="form-control border-start-0" placeholder="ví dụ: nguyenvana" 
                           value="${username}" required minlength="3" maxlength="30" pattern="^[a-zA-Z0-9_]{3,30}$">
                    <div class="invalid-feedback">Tên đăng nhập từ 3 - 30 ký tự, chỉ chứa chữ cái, số và dấu gạch dưới (_).</div>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label small fw-semibold text-secondary">Họ và tên <span class="text-danger">*</span></label>
                <div class="input-group has-validation">
                    <span class="input-group-text bg-light border-end-0"><i class="fa-solid fa-id-card text-muted"></i></span>
                    <input type="text" name="fullname" class="form-control border-start-0" placeholder="Nguyễn Văn A" 
                           value="${fullname}" required minlength="2" maxlength="100">
                    <div class="invalid-feedback">Vui lòng nhập họ và tên của bạn (2 - 100 ký tự).</div>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label small fw-semibold text-secondary">Email nhận mã OTP <span class="text-danger">*</span></label>
                <div class="input-group has-validation">
                    <span class="input-group-text bg-light border-end-0"><i class="fa-regular fa-envelope text-muted"></i></span>
                    <input type="email" name="email" class="form-control border-start-0" placeholder="email@domain.com" 
                           value="${email}" required pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$">
                    <div class="invalid-feedback">Vui lòng nhập địa chỉ email hợp lệ (ví dụ: user@example.com).</div>
                </div>
                <div class="form-text small">Mã OTP kích hoạt sẽ gửi đến địa chỉ email này.</div>
            </div>

            <div class="mb-3">
                <label class="form-label small fw-semibold text-secondary">Mật khẩu <span class="text-danger">*</span></label>
                <div class="input-group has-validation">
                    <span class="input-group-text bg-light border-end-0"><i class="fa-solid fa-lock text-muted"></i></span>
                    <input type="password" name="password" id="password" class="form-control border-start-0" 
                           placeholder="Tối thiểu 6 ký tự" required minlength="6">
                    <div class="invalid-feedback">Mật khẩu phải có độ dài tối thiểu từ 6 ký tự trở lên.</div>
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label small fw-semibold text-secondary">Xác nhận mật khẩu <span class="text-danger">*</span></label>
                <div class="input-group has-validation">
                    <span class="input-group-text bg-light border-end-0"><i class="fa-solid fa-shield-halved text-muted"></i></span>
                    <input type="password" name="confirmPassword" id="confirmPassword" class="form-control border-start-0" 
                           placeholder="Nhập lại mật khẩu" required minlength="6">
                    <div class="invalid-feedback" id="confirmFeedback">Mật khẩu xác nhận không trùng khớp!</div>
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-submit w-100 text-white">
                Đăng Ký & Nhận Mã OTP <i class="fa-solid fa-arrow-right ms-2"></i>
            </button>
        </form>

        <div class="text-center mt-4 pt-2 border-top">
            <span class="small text-muted">Đã có tài khoản?</span>
            <a href="<c:url value='/login'/>" class="small text-decoration-none fw-bold text-primary ms-1">Đăng nhập</a>
        </div>

        <div class="text-center mt-3">
            <a href="<c:url value='/home'/>" class="small text-decoration-none text-secondary">
                <i class="fa-solid fa-house me-1"></i> Quay về trang chủ
            </a>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const form = document.getElementById('registerForm');
            const pwd = document.getElementById('password');
            const confirmPwd = document.getElementById('confirmPassword');

            function checkPasswordMatch() {
                if (confirmPwd.value && pwd.value !== confirmPwd.value) {
                    confirmPwd.setCustomValidity('Mật khẩu không khớp!');
                } else {
                    confirmPwd.setCustomValidity('');
                }
            }

            pwd.addEventListener('input', checkPasswordMatch);
            confirmPwd.addEventListener('input', checkPasswordMatch);

            form.addEventListener('submit', function (event) {
                checkPasswordMatch();
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    </script>


</body>
</html>
