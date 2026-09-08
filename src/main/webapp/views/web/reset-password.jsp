<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Lại Mật Khẩu - DT SHOP</title>
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
            padding: 20px;
        }
        .auth-card {
            background: white;
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08);
            width: 100%;
            max-width: 440px;
            padding: 40px;
            border: 1px solid #f1f5f9;
            margin: 40px auto;
        }
        .auth-logo {
            font-size: 36px;
            color: #2563eb;
            text-align: center;
            margin-bottom: 15px;
        }
        .otp-input {
            letter-spacing: 8px;
            font-size: 24px;
            font-weight: 700;
            text-align: center;
            color: #1e293b;
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
            <i class="fa-solid fa-lock-open"></i>
        </div>
        <h3 class="fw-bold text-center mb-1">Đặt Lại Mật Khẩu</h3>
        <p class="text-center text-muted small mb-4">Nhập mã OTP xác nhận gửi qua email và mật khẩu mới</p>

        <c:if test="${param.msg == 'otp_sent'}">
            <div class="alert alert-info small py-2 d-flex align-items-center" role="alert">
                <i class="fa-solid fa-paper-plane me-2"></i> Mã OTP đã được gửi tới email của bạn (hoặc xem tại console server).
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-danger small py-2 d-flex align-items-center" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i> ${error}
            </div>
        </c:if>

        <form action="<c:url value='/reset-password'/>" method="POST">
            <div class="mb-3">
                <label class="form-label small fw-semibold text-secondary">Email tài khoản</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0"><i class="fa-regular fa-envelope text-muted"></i></span>
                    <input type="email" name="email" class="form-control border-start-0" value="${email != null ? email : sessionScope.resetEmail}" placeholder="email@domain.com" required>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label small fw-semibold text-secondary">Mã OTP (6 số)</label>
                <input type="text" name="otp" class="form-control otp-input" maxlength="6" placeholder="------" pattern="[0-9]{6}" required autofocus>
            </div>

            <div class="mb-3">
                <label class="form-label small fw-semibold text-secondary">Mật khẩu mới</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0"><i class="fa-solid fa-lock text-muted"></i></span>
                    <input type="password" name="newPassword" class="form-control border-start-0" placeholder="Tối thiểu 6 ký tự" minlength="6" required>
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label small fw-semibold text-secondary">Xác nhận mật khẩu mới</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0"><i class="fa-solid fa-shield-halved text-muted"></i></span>
                    <input type="password" name="confirmPassword" class="form-control border-start-0" placeholder="Nhập lại mật khẩu mới" minlength="6" required>
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-submit w-100 text-white">
                <i class="fa-solid fa-check me-2"></i> Cập Nhật Mật Khẩu
            </button>
        </form>

        <div class="text-center mt-4 pt-2 border-top">
            <a href="<c:url value='/login'/>" class="small text-decoration-none fw-semibold text-secondary">
                <i class="fa-solid fa-arrow-left me-1"></i> Quay về Đăng nhập
            </a>
        </div>
    </div>


</body>
</html>
