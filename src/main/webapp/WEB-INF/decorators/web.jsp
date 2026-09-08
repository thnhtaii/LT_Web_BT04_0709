<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property='title'/> - DT SHOP</title>

    <!-- Google Fonts: Plus Jakarta Sans -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Bootstrap 5.3.3 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome 6.5.2 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
            --primary-color: #2563eb;
            --primary-hover: #1d4ed8;
            --primary-light: #eff6ff;
            --dark-color: #0f172a;
            --slate-border: #e2e8f0;
            --bg-canvas: #f8fafc;
        }

        body {
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: var(--bg-canvas);
            color: #334155;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            margin: 0;
        }

        /* Navbar Header Glassmorphism */
        .navbar-custom {
            background: rgba(255, 255, 255, 0.96);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border-bottom: 1px solid rgba(226, 232, 240, 0.85);
            box-shadow: 0 4px 20px -5px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }

        .navbar-brand {
            font-weight: 800;
            font-size: 1.4rem;
            letter-spacing: -0.5px;
            text-decoration: none;
        }

        .navbar-brand .brand-text {
            color: #0f172a;
            font-weight: 800;
        }

        .navbar-brand .brand-badge {
            background: var(--primary-gradient);
            color: #ffffff;
            width: 36px;
            height: 36px;
            border-radius: 10px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            box-shadow: 0 4px 10px rgba(37, 99, 235, 0.25);
        }

        .nav-link {
            font-weight: 600;
            color: #475569 !important;
            padding: 0.5rem 0.9rem !important;
            border-radius: 8px;
            transition: all 0.2s ease;
            font-size: 0.95rem;
        }

        .nav-link:hover, .nav-link.active {
            color: var(--primary-color) !important;
            background-color: var(--primary-light);
        }

        .nav-search-input {
            border-radius: 20px 0 0 20px;
            border-color: #cbd5e1;
            font-size: 0.9rem;
            padding-left: 1rem;
        }

        .nav-search-input:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
        }

        .nav-search-btn {
            border-radius: 0 20px 20px 0;
            border-color: #cbd5e1;
            background-color: #f1f5f9;
            color: #475569;
            transition: all 0.2s;
        }

        .nav-search-btn:hover {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: #ffffff;
        }

        .user-nav-avatar {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid var(--primary-color);
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
        }

        .dropdown-menu-custom {
            border-radius: 14px;
            border: 1px solid var(--slate-border);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            padding: 0.5rem;
        }

        .dropdown-item-custom {
            font-weight: 500;
            font-size: 0.9rem;
            padding: 0.55rem 1rem;
            border-radius: 8px;
            transition: all 0.15s ease;
        }

        .dropdown-item-custom:hover {
            background-color: var(--primary-light);
            color: var(--primary-color);
        }

        /* Main Content Wrapper */
        .main-wrapper {
            flex: 1 0 auto;
            width: 100%;
        }

        /* Footer */
        .footer-custom {
            background-color: #0f172a;
            color: #94a3b8;
            border-top: 1px solid #1e293b;
            padding: 50px 0 25px 0;
            margin-top: auto;
        }

        .footer-title {
            color: #f8fafc;
            font-weight: 700;
            font-size: 1.05rem;
            margin-bottom: 1.25rem;
        }

        .footer-link {
            color: #94a3b8;
            text-decoration: none;
            display: inline-block;
            margin-bottom: 0.6rem;
            font-size: 0.9rem;
            transition: color 0.2s ease, transform 0.2s ease;
        }

        .footer-link:hover {
            color: #60a5fa;
            transform: translateX(4px);
        }

        .footer-bottom {
            border-top: 1px solid rgba(255, 255, 255, 0.08);
            margin-top: 35px;
            padding-top: 20px;
            font-size: 0.85rem;
        }

        /* Global Toast / Notification badges */
        .badge-admin-tag {
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
            color: white;
            font-weight: 700;
            font-size: 0.75rem;
            padding: 3px 8px;
            border-radius: 6px;
        }
    </style>

    <sitemesh:write property='head'/>
</head>
<body>

    <!-- ============================================== -->
    <!-- 01 BOOTSTRAP TEMPLATE: HEADER NAVBAR           -->
    <!-- ============================================== -->
    <nav class="navbar navbar-expand-lg navbar-custom sticky-top py-2">
        <div class="container">
            <!-- Brand Logo -->
            <a class="navbar-brand d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/home">
                <span class="brand-badge">
                    <i class="fa-solid fa-cube"></i>
                </span>
                <span class="brand-text">DT <span class="text-primary">SHOP</span></span>
            </a>

            <!-- Mobile Toggler -->
            <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain">
                <span class="navbar-toggler-icon"></span>
            </button>

            <!-- Navbar Links & Actions -->
            <div class="collapse navbar-collapse" id="navbarMain">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-3 gap-lg-1">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/home" id="navHome">
                            <i class="fa-solid fa-house me-1 text-primary"></i> Trang chủ
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/product" id="navProduct">
                            <i class="fa-solid fa-boxes-stacked me-1 text-primary"></i> Sản phẩm
                        </a>
                    </li>

                    <!-- Menu Quản Trị dành cho Admin (roleId == 1) -->
                    <c:if test="${sessionScope.account != null && sessionScope.account.roleId == 1}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle text-warning fw-semibold" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fa-solid fa-shield-halved me-1 text-warning"></i> Quản trị
                            </a>
                            <ul class="dropdown-menu dropdown-menu-custom shadow">
                                <li>
                                    <a class="dropdown-item dropdown-item-custom" href="${pageContext.request.contextPath}/admin/categories">
                                        <i class="fa-solid fa-folder-open me-2 text-primary"></i> Quản lý Danh mục
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item dropdown-item-custom" href="${pageContext.request.contextPath}/admin/category/add">
                                        <i class="fa-solid fa-plus me-2 text-success"></i> Thêm Danh mục mới
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item dropdown-item-custom" href="${pageContext.request.contextPath}/admin/products">
                                        <i class="fa-solid fa-box me-2 text-info"></i> Quản lý Sản phẩm
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item dropdown-item-custom" href="${pageContext.request.contextPath}/admin/product/add">
                                        <i class="fa-solid fa-circle-plus me-2 text-success"></i> Thêm Sản phẩm mới
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:if>
                </ul>

                <!-- Search Input Form -->
                <form class="d-flex me-lg-3 my-2 my-lg-0" action="${pageContext.request.contextPath}/product" method="GET">
                    <div class="input-group" style="max-width: 280px;">
                        <input class="form-control nav-search-input" type="search" name="keyword" 
                               value="${param.keyword}" placeholder="Tìm kiếm sản phẩm...">
                        <button class="btn nav-search-btn" type="submit" title="Tìm kiếm">
                            <i class="fa-solid fa-magnifying-glass"></i>
                        </button>
                    </div>
                </form>

                <!-- User Account Section -->
                <div class="d-flex align-items-center gap-2 mt-2 mt-lg-0">
                    <c:choose>
                        <c:when test="${not empty sessionScope.account}">
                            <div class="dropdown">
                                <a href="#" class="d-flex align-items-center gap-2 text-decoration-none dropdown-toggle text-dark" 
                                   data-bs-toggle="dropdown" aria-expanded="false">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.account.avatar}">
                                            <img src="${pageContext.request.contextPath}/image?fname=${sessionScope.account.avatar}" 
                                                 class="user-nav-avatar" alt="Avatar">
                                        </c:when>
                                        <c:when test="${not empty sessionScope.account.images}">
                                            <img src="${pageContext.request.contextPath}/image?fname=${sessionScope.account.images}" 
                                                 class="user-nav-avatar" alt="Avatar">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/image" 
                                                 class="user-nav-avatar" alt="Avatar">
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="d-none d-xl-block text-start lh-sm">
                                        <div class="fw-bold" style="font-size: 0.88rem;">
                                            <c:out value="${sessionScope.account.fullname != null ? sessionScope.account.fullname : sessionScope.account.username}" />
                                        </div>
                                        <small class="text-muted" style="font-size: 0.75rem;">
                                            <c:choose>
                                                <c:when test="${sessionScope.account.roleId == 1}">
                                                    <span class="badge-admin-tag">Admin</span>
                                                </c:when>
                                                <c:otherwise>Thành viên</c:otherwise>
                                            </c:choose>
                                        </small>
                                    </div>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end dropdown-menu-custom shadow-lg">
                                    <li class="px-3 py-2 border-bottom mb-1">
                                        <div class="fw-bold text-dark"><c:out value="${sessionScope.account.fullname}" /></div>
                                        <div class="small text-muted">@<c:out value="${sessionScope.account.username}" /></div>
                                    </li>
                                    <li>
                                        <a class="dropdown-item dropdown-item-custom" href="${pageContext.request.contextPath}/profile">
                                            <i class="fa-regular fa-id-badge me-2 text-primary"></i> Hồ sơ người dùng
                                        </a>
                                    </li>
                                    <c:if test="${sessionScope.account.roleId == 1}">
                                        <li>
                                            <a class="dropdown-item dropdown-item-custom" href="${pageContext.request.contextPath}/admin/categories">
                                                <i class="fa-solid fa-gear me-2 text-warning"></i> Trang quản trị
                                            </a>
                                        </li>
                                    </c:if>
                                    <li><hr class="dropdown-divider"></li>
                                    <li>
                                        <a class="dropdown-item dropdown-item-custom text-danger" href="${pageContext.request.contextPath}/logout">
                                            <i class="fa-solid fa-right-from-bracket me-2"></i> Đăng xuất
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary btn-sm rounded-pill px-3 fw-semibold">
                                <i class="fa-solid fa-right-to-bracket me-1"></i> Đăng nhập
                            </a>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-sm rounded-pill px-3 fw-semibold text-white">
                                <i class="fa-solid fa-user-plus me-1"></i> Đăng ký
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>

    <!-- ============================================== -->
    <!-- 01 BOOTSTRAP TEMPLATE: BODY CONTENT INJECTION  -->
    <!-- ============================================== -->
    <main class="main-wrapper">
        <sitemesh:write property='body'/>
    </main>

    <!-- ============================================== -->
    <!-- 01 BOOTSTRAP TEMPLATE: FOOTER                  -->
    <!-- ============================================== -->
    <footer class="footer-custom">
        <div class="container">
            <div class="row g-4">
                <div class="col-lg-4 col-md-6">
                    <div class="d-flex align-items-center gap-2 mb-3">
                        <span class="brand-badge" style="width: 32px; height: 32px; font-size: 0.95rem;">
                            <i class="fa-solid fa-cube"></i>
                        </span>
                        <span class="fw-bold fs-5 text-white">DT SHOP</span>
                    </div>
                    <p class="small text-secondary mb-3">
                        Hệ thống mua sắm thiết bị công nghệ và điện tử thông minh, cam kết sản phẩm chính hãng, bảo hành uy tín và dịch vụ tận tâm.
                    </p>
                    <div class="d-flex gap-2">
                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle">Chính hãng 100%</span>
                        <span class="badge bg-success-subtle text-success border border-success-subtle">Giao hàng nhanh</span>
                        <span class="badge bg-info-subtle text-info border border-info-subtle">Hỗ trợ 24/7</span>
                    </div>
                </div>

                <div class="col-lg-2 col-md-6 col-6">
                    <h6 class="footer-title">Khám Phá</h6>
                    <ul class="list-unstyled mb-0">
                        <li><a href="${pageContext.request.contextPath}/home" class="footer-link">Trang chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/product" class="footer-link">Tất cả sản phẩm</a></li>
                        <li><a href="${pageContext.request.contextPath}/profile" class="footer-link">Hồ sơ cá nhân</a></li>
                    </ul>
                </div>

                <div class="col-lg-2 col-md-6 col-6">
                    <h6 class="footer-title">Tài Khoản</h6>
                    <ul class="list-unstyled mb-0">
                        <li><a href="${pageContext.request.contextPath}/login" class="footer-link">Đăng nhập</a></li>
                        <li><a href="${pageContext.request.contextPath}/register" class="footer-link">Đăng ký mới</a></li>
                        <li><a href="${pageContext.request.contextPath}/forgot-password" class="footer-link">Quên mật khẩu</a></li>
                    </ul>
                </div>

                <div class="col-lg-4 col-md-6">
                    <h6 class="footer-title">Liên Hệ & Hỗ Trợ</h6>
                    <p class="small text-secondary mb-2">
                        <i class="fa-solid fa-phone me-2 text-primary"></i>Hotline: <strong>1900 8888</strong>
                    </p>
                    <p class="small text-secondary mb-2">
                        <i class="fa-solid fa-envelope me-2 text-primary"></i>Email: <strong>support@dtshop.vn</strong>
                    </p>
                    <p class="small text-secondary mb-2">
                        <i class="fa-solid fa-location-dot me-2 text-primary"></i>Địa chỉ: <strong>TP. Hồ Chí Minh, Việt Nam</strong>
                    </p>
                </div>
            </div>

            <div class="footer-bottom d-flex flex-wrap justify-content-between align-items-center gap-2">
                <div>
                    &copy; 2026 <strong>DT SHOP</strong>. All rights reserved.
                </div>
                <div class="text-secondary small">
                    Chính sách bảo mật &bull; Điều khoản dịch vụ
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap 5.3.3 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Auto highlight active navigation link -->
    <script>
        (function() {
            const currentPath = window.location.pathname;
            if (currentPath.endsWith('/home') || currentPath.endsWith('/')) {
                const homeLink = document.getElementById('navHome');
                if (homeLink) homeLink.classList.add('active');
            } else if (currentPath.includes('/product')) {
                const productLink = document.getElementById('navProduct');
                if (productLink) productLink.classList.add('active');
            }
        })();
    </script>
</body>
</html>
