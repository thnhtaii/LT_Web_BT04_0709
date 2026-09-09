<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác Thực OTP - DT SHOP</title>
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
            letter-spacing: 12px;
            font-size: 28px;
            font-weight: 800;
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
            <i class="fa-solid fa-shield-halved"></i>
        </div>
        <h3 class="fw-bold text-center mb-1">Kích Hoạt Tài Khoản</h3>
        <p class="text-center text-muted small mb-4">Nhập mã OTP gồm 6 chữ số được gửi tới email của bạn</p>

        <c:if test="${param.msg == 'otp_sent'}">
            <div class="alert alert-info small py-2 d-flex align-items-center" role="alert">
                <i class="fa-solid fa-paper-plane me-2"></i> Mã OTP đã được gửi đến email. Vui lòng kiểm tra hộp thư (hoặc console server).
            </div>
        </c:if>
        <c:if test="${param.msg == 'resent'}">
            <div class="alert alert-success small py-2 d-flex align-items-center" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> Đã gửi lại mã OTP mới!
            </div>
        </c:if>
        <c:if test="${param.msg == 'not_activated'}">
            <div class="alert alert-warning small py-2 d-flex align-items-center" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i> Tài khoản của bạn chưa kích hoạt. Vui lòng nhập OTP để kích hoạt.
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger small py-2 d-flex align-items-center" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i> ${param.error}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger small py-2 d-flex align-items-center" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i> ${error}
            </div>
        </c:if>

        <form action="<c:url value='/verify-otp'/>" method="POST" class="needs-validation" novalidate id="otpForm">
            <div class="mb-3">
                <label class="form-label small fw-semibold text-secondary">Địa chỉ Email <span class="text-danger">*</span></label>
                <div class="input-group has-validation">
                    <span class="input-group-text bg-light border-end-0"><i class="fa-regular fa-envelope text-muted"></i></span>
                    <input type="email" name="email" class="form-control border-start-0" 
                           value="${email != null ? email : sessionScope.otpEmail}" placeholder="email@domain.com" required>
                    <div class="invalid-feedback">Vui lòng nhập địa chỉ email hợp lệ.</div>
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label small fw-semibold text-secondary">Mã OTP (6 chữ số) <span class="text-danger">*</span></label>
                <input type="text" name="otp" id="otpInput" class="form-control otp-input" maxlength="6" 
                       placeholder="------" pattern="^\d{6}$" inputmode="numeric" required autofocus autocomplete="one-time-code">
                <div class="invalid-feedback text-center">Vui lòng nhập đúng 6 chữ số OTP.</div>
                <div class="form-text text-center small mt-2">
                    <i class="fa-regular fa-clock me-1"></i> Mã có hiệu lực trong vòng 5 phút
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-submit w-100 text-white">
                <i class="fa-solid fa-check me-2"></i> Kích Hoạt Tài Khoản
            </button>
        </form>

        <div class="text-center mt-4 pt-2 border-top">
            <span class="small text-muted">Chưa nhận được mã?</span>
            <a href="<c:url value='/resend-otp?email=${email != null ? email : sessionScope.otpEmail}'/>" class="small text-decoration-none fw-bold text-primary ms-1">
                Gửi lại mã OTP
            </a>
        </div>

        <div class="text-center mt-3">
            <a href="<c:url value='/login'/>" class="small text-decoration-none text-secondary">
                <i class="fa-solid fa-arrow-left me-1"></i> Quay về đăng nhập
            </a>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const form = document.getElementById('otpForm');
            const otpInput = document.getElementById('otpInput');

            // Chỉ cho phép nhập số
            otpInput.addEventListener('input', function() {
                this.value = this.value.replace(/[^0-9]/g, '');
            });

            form.addEventListener('submit', function (event) {
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
