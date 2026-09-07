<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property='title'/> | DT SHOP - Web Profile</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <style>
        :root {
            --primary-color: #4f46e5;
            --primary-hover: #4338ca;
            --primary-light: #eef2ff;
            --dark-bg: #0f172a;
            --card-border: #e2e8f0;
        }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #f8fafc;
            color: #334155;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Navbar Styling */
        .navbar-custom {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(226, 232, 240, 0.8);
            box-shadow: 0 4px 20px -5px rgba(0, 0, 0, 0.05);
        }

        .navbar-brand {
            font-weight: 800;
            background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-size: 1.35rem;
            letter-spacing: -0.5px;
        }

        .nav-link {
            font-weight: 600;
            color: #475569 !important;
            padding: 0.5rem 1rem !important;
            border-radius: 8px;
            transition: all 0.2s ease;
        }

        .nav-link:hover, .nav-link.active {
            color: var(--primary-color) !important;
            background-color: var(--primary-light);
        }

        /* Avatar in navbar */
        .nav-avatar {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid var(--primary-color);
        }

        /* Main Content wrapper */
        .main-wrapper {
            flex: 1;
            padding-top: 2rem;
            padding-bottom: 3rem;
        }

        /* Footer */
        .footer-custom {
            background: #ffffff;
            border-top: 1px solid var(--card-border);
            padding: 1.5rem 0;
            font-size: 0.9rem;
            color: #64748b;
        }
    </style>

    <sitemesh:write property='head'/>
</head>
<body>

    <!-- Header / Navbar -->
    <nav class="navbar navbar-expand-lg navbar-custom sticky-top">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/profile">
                <i class="fa-solid fa-layer-group text-primary"></i>
                <span>DT WEB APP</span>
            </a>

            <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarMain">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/profile">
                            <i class="fa-regular fa-id-badge me-1"></i> Hồ sơ người dùng
                        </a>
                    </li>
                </ul>

                <div class="d-flex align-items-center gap-3">
                    <c:choose>
                        <c:when test="${not empty sessionScope.account.images}">
                            <img src="${pageContext.request.contextPath}/image?fname=${sessionScope.account.images}" 
                                 class="nav-avatar" alt="Avatar">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/image" 
                                 class="nav-avatar" alt="Default Avatar">
                        </c:otherwise>
                    </c:choose>
                    <div class="d-none d-md-block text-start">
                        <div class="fw-bold text-dark" style="font-size: 0.9rem;">
                            <c:out value="${sessionScope.account.fullname != null ? sessionScope.account.fullname : 'Tài khoản'}" />
                        </div>
                        <small class="text-muted" style="font-size: 0.75rem;">
                            @<c:out value="${sessionScope.account.username != null ? sessionScope.account.username : 'user'}" />
                        </small>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <!-- Content Injected by SiteMesh -->
    <main class="main-wrapper">
        <div class="container">
            <sitemesh:write property='body'/>
        </div>
    </main>

    <!-- Footer -->
    <footer class="footer-custom mt-auto">
        <div class="container text-center">
            <p class="mb-1 fw-semibold text-dark">Lập Trình Web - Bài Tập 04 (07/09) | Quản lý Profile với JPA &amp; SiteMesh</p>
            <p class="mb-0 text-muted">&copy; 2026 Đỗ Thành Tài - All rights reserved.</p>
        </div>
    </footer>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
