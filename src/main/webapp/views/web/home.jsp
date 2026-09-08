<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Chủ - DT SHOP</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #f8fafc;
            color: #1e293b;
        }
        .navbar-custom {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }
        .hero-section {
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 50%, #1e40af 100%);
            color: white;
            padding: 70px 0 60px 0;
            border-radius: 0 0 30px 30px;
            margin-bottom: 40px;
        }
        .hero-title {
            font-size: 2.8rem;
            font-weight: 800;
            letter-spacing: -0.5px;
        }
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 25px;
            border-bottom: 2px solid #e2e8f0;
            padding-bottom: 12px;
        }
        .section-title {
            font-size: 1.6rem;
            font-weight: 700;
            color: #0f172a;
            position: relative;
        }
        .section-title::after {
            content: '';
            position: absolute;
            bottom: -14px;
            left: 0;
            width: 60px;
            height: 3px;
            background-color: #2563eb;
            border-radius: 2px;
        }
        .product-card {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -2px rgba(0, 0, 0, 0.05);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid #f1f5f9;
            height: 100%;
            display: flex;
            flex-direction: column;
            text-decoration: none;
            color: inherit;
        }
        .product-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
            border-color: #cbd5e1;
            color: inherit;
        }
        .product-img-wrapper {
            position: relative;
            padding-top: 75%;
            background-color: #f8fafc;
            overflow: hidden;
        }
        .product-img {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.4s ease;
        }
        .product-card:hover .product-img {
            transform: scale(1.05);
        }
        .badge-new {
            position: absolute;
            top: 12px;
            left: 12px;
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
            color: white;
            font-size: 0.75rem;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 20px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .product-body {
            padding: 16px;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
        }
        .product-category {
            font-size: 0.8rem;
            color: #64748b;
            text-transform: uppercase;
            font-weight: 600;
            margin-bottom: 6px;
        }
        .product-name {
            font-size: 1.05rem;
            font-weight: 700;
            color: #1e293b;
            line-height: 1.4;
            margin-bottom: 8px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .product-price {
            font-size: 1.25rem;
            font-weight: 800;
            color: #2563eb;
            margin-top: auto;
        }
        .btn-view-detail {
            background-color: #f1f5f9;
            color: #334155;
            font-weight: 600;
            font-size: 0.85rem;
            border-radius: 8px;
            padding: 8px 12px;
            transition: all 0.2s ease;
            width: 100%;
            margin-top: 12px;
            text-align: center;
        }
        .product-card:hover .btn-view-detail {
            background-color: #2563eb;
            color: white;
        }
        .category-pill {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 30px;
            padding: 8px 18px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            color: #334155;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.2s;
        }
        .category-pill:hover {
            background-color: #2563eb;
            color: white;
            border-color: #2563eb;
        }
        footer {
            background-color: #0f172a;
            color: #94a3b8;
            padding: 40px 0 20px 0;
            margin-top: 60px;
        }
    </style>
</head>
<body>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-7">
                    <span class="badge bg-white text-primary px-3 py-2 rounded-pill fw-bold mb-3 shadow-sm">
                        <i class="fa-solid fa-bolt me-1"></i> BỘ SƯU TẬP MỚI 2026
                    </span>
                    <h1 class="hero-title mb-3">Khám Phá Công Nghệ & Thời Trang Hiện Đại</h1>
                    <p class="lead mb-4 text-white-50">Trải nghiệm mua sắm tiện lợi với các dòng sản phẩm chất lượng cao, cập nhật liên tục và giá cả tốt nhất thị trường.</p>
                    <div class="d-flex gap-3">
                        <a href="<c:url value='/product'/>" class="btn btn-light btn-lg rounded-pill px-4 fw-bold text-primary shadow">
                            <i class="fa-solid fa-cart-shopping me-2"></i>Mua sắm ngay
                        </a>
                        <a href="#latest-products" class="btn btn-outline-light btn-lg rounded-pill px-4">
                            Xem 10 sản phẩm mới
                        </a>
                    </div>
                </div>
                <div class="col-lg-5 d-none d-lg-block text-center">
                    <i class="fa-solid fa-bag-shopping" style="font-size: 180px; opacity: 0.85;"></i>
                </div>
            </div>
        </div>
    </section>

    <!-- Main Container -->
    <div class="container mb-5">

        <!-- Danh mục sản phẩm -->
        <c:if test="${not empty categories}">
            <div class="mb-5">
                <h5 class="fw-bold mb-3 text-secondary">DANH MỤC NỔI BẬT</h5>
                <div class="d-flex flex-wrap gap-2">
                    <a href="<c:url value='/product'/>" class="category-pill">
                        <i class="fa-solid fa-border-all text-primary"></i> Tất cả
                    </a>
                    <c:forEach items="${categories}" var="cat">
                        <a href="<c:url value='/product?categoryId=${cat.categoryId}'/>" class="category-pill">
                            <i class="fa-solid fa-tag text-primary"></i> ${cat.categoryname}
                        </a>
                    </c:forEach>
                </div>
            </div>
        </c:if>

        <!-- 10 Sản phẩm mới nhất -->
        <div id="latest-products">
            <div class="section-header">
                <div>
                    <span class="text-primary fw-bold text-uppercase small">Mới cập nhật</span>
                    <h2 class="section-title">10 Sản Phẩm Mới Nhất</h2>
                </div>
                <a href="<c:url value='/product'/>" class="text-decoration-none fw-semibold text-primary">
                    Xem tất cả sản phẩm <i class="fa-solid fa-arrow-right ms-1"></i>
                </a>
            </div>

            <c:choose>
                <c:when test="${not empty top10Products}">
                    <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-5 g-4">
                        <c:forEach items="${top10Products}" var="prod">
                            <div class="col">
                                <a href="<c:url value='/product/detail?id=${prod.productId}'/>" class="product-card">
                                    <div class="product-img-wrapper">
                                        <span class="badge-new">Mới</span>
                                        <c:choose>
                                            <c:when test="${prod.images != null && prod.images.startsWith('http')}">
                                                <img src="${prod.images}" alt="${prod.productName}" class="product-img">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="<c:url value='/image?fname=${prod.images}'/>" alt="${prod.productName}" class="product-img" onerror="this.src='https://via.placeholder.com/300x300?text=No+Image';">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="product-body">
                                        <div class="product-category">${prod.category != null ? prod.category.categoryname : 'Sản phẩm'}</div>
                                        <div class="product-name" title="${prod.productName}">${prod.productName}</div>
                                        <div class="product-price">
                                            ${prod.formattedPrice}
                                        </div>
                                        <div class="btn-view-detail">
                                            <i class="fa-solid fa-eye me-1"></i> Xem chi tiết
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5 bg-white rounded-4 shadow-sm">
                        <i class="fa-solid fa-box-open text-muted" style="font-size: 60px;"></i>
                        <p class="mt-3 text-muted">Hiện chưa có sản phẩm nào. Vui lòng thêm sản phẩm từ trang quản trị!</p>
                        <a href="<c:url value='/admin/product/add'/>" class="btn btn-primary rounded-pill px-4">
                            <i class="fa-solid fa-plus me-1"></i> Thêm sản phẩm đầu tiên
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
