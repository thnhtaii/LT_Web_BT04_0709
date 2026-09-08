<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - DT SHOP</title>
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
            font-size: 32px;
            color: #2563eb;
            text-align: center;
            margin-bottom: 10px;
        }
        .form-floating:focus-within {
            z-index: 2;
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
        <h3 class="fw-bold text-center mb-1">Chào mừng trở lại</h3>
        <p class="text-center text-muted small mb-4">Đăng nhập vào tài khoản DT SHOP của bạn</p>

        <!-- Thông báo trạng thái -->
        <c:if test="${param.msg == 'activated'}">
            <div class="alert alert-success d-flex align-items-center small py-2" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> Kích hoạt tài khoản thành công! Bạn có thể đăng nhập ngay.
            </div>
        </c:if>
        <c:if test="${param.msg == 'reset_success'}">
            <div class="alert alert-success d-flex align-items-center small py-2" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> Đặt lại mật khẩu thành công! Vui lòng đăng nhập với mật khẩu mới.
            </div>
        </c:if>
        <c:if test="${param.msg == 'logged_out'}">
            <div class="alert alert-info d-flex align-items-center small py-2" role="alert">
                <i class="fa-solid fa-info-circle me-2"></i> Bạn đã đăng xuất an toàn khỏi hệ thống.
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-danger d-flex align-items-center small py-2" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i> ${error}
            </div>
        </c:if>

        <form action="<c:url value='/login'/>" method="POST">
            <div class="mb-3">
                <label class="form-label small fw-semibold text-secondary">Tên đăng nhập hoặc Email</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0"><i class="fa-regular fa-user text-muted"></i></span>
                    <input type="text" name="username" class="form-control border-start-0" placeholder="username hoặc email" value="${username}" required>
                </div>
            </div>

            <div class="mb-3">
                <div class="d-flex justify-content-between">
                    <label class="form-label small fw-semibold text-secondary">Mật khẩu</label>
                    <a href="<c:url value='/forgot-password'/>" class="small text-decoration-none text-primary">Quên mật khẩu?</a>
                </div>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0"><i class="fa-solid fa-lock text-muted"></i></span>
                    <input type="password" name="password" class="form-control border-start-0" placeholder="••••••••" required>
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-submit w-100 text-white mt-2">
                Đăng Nhập <i class="fa-solid fa-arrow-right ms-2"></i>
            </button>
        </form>

        <div class="text-center mt-4 pt-2 border-top">
            <span class="small text-muted">Chưa có tài khoản?</span>
            <a href="<c:url value='/register'/>" class="small text-decoration-none fw-bold text-primary ms-1">Đăng ký ngay</a>
        </div>

        <div class="text-center mt-3">
            <a href="<c:url value='/home'/>" class="small text-decoration-none text-secondary">
                <i class="fa-solid fa-house me-1"></i> Quay về trang chủ
            </a>
        </div>
    </div>


</body>
</html>
