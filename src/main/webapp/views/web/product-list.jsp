<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Sản Phẩm - DT SHOP</title>
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
        .page-header-bar {
            background: white;
            border-bottom: 1px solid #e2e8f0;
            padding: 24px 0;
            margin-bottom: 30px;
        }
        .product-card {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
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
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
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
        .category-filter-item {
            display: block;
            padding: 10px 16px;
            border-radius: 10px;
            color: #334155;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s;
            margin-bottom: 4px;
        }
        .category-filter-item:hover {
            background-color: #f1f5f9;
            color: #2563eb;
        }
        .category-filter-item.active {
            background-color: #2563eb;
            color: white;
            font-weight: 600;
        }
        .pagination .page-link {
            border-radius: 8px;
            margin: 0 3px;
            color: #1e293b;
            border-color: #e2e8f0;
            font-weight: 600;
        }
        .pagination .page-item.active .page-link {
            background-color: #2563eb;
            border-color: #2563eb;
            color: white;
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

    <!-- Page Header -->
    <div class="page-header-bar">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                <div>
                    <h2 class="fw-bold mb-1">Tất Cả Sản Phẩm</h2>
                    <p class="text-muted mb-0 small">
                        Hiển thị danh sách sản phẩm phân trang (<strong>6 sản phẩm / trang</strong>)
                    </p>
                </div>
                <div class="text-muted small">
                    Tổng cộng: <strong>${totalProducts}</strong> sản phẩm | Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content Container -->
    <div class="container mb-5">
        <div class="row g-4">
            <!-- Sidebar Filter -->
            <div class="col-lg-3">
                <div class="bg-white p-4 rounded-4 shadow-sm border border-light">
                    <h5 class="fw-bold mb-3"><i class="fa-solid fa-filter text-primary me-2"></i>Danh Mục</h5>
                    <div class="nav flex-column">
                        <a href="<c:url value='/product'/>" class="category-filter-item ${selectedCategoryId == null ? 'active' : ''}">
                            <i class="fa-solid fa-list-ul me-2"></i> Tất cả sản phẩm
                        </a>
                        <c:forEach items="${categories}" var="c">
                            <a href="<c:url value='/product?categoryId=${c.categoryId}'/>" class="category-filter-item ${selectedCategoryId == c.categoryId ? 'active' : ''}">
                                <i class="fa-solid fa-chevron-right me-2 small"></i> ${c.categoryname}
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <!-- Product Grid -->
            <div class="col-lg-9">
                <c:choose>
                    <c:when test="${not empty listProduct}">
                        <!-- 6 Products Grid (2 rows of 3 columns) -->
                        <div class="row row-cols-1 row-cols-md-2 row-cols-xl-3 g-4 mb-5">
                            <c:forEach items="${listProduct}" var="prod">
                                <div class="col">
                                    <a href="<c:url value='/product/detail?id=${prod.productId}'/>" class="product-card">
                                        <div class="product-img-wrapper">
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
                                            <div class="d-flex justify-content-between align-items-baseline mt-auto">
                                                <div class="product-price">
                                                    ${prod.formattedPrice}
                                                </div>
                                                <span class="small text-muted">SL: ${prod.quantity}</span>
                                            </div>
                                            <div class="btn-view-detail">
                                                <i class="fa-solid fa-circle-info me-1"></i> Bấm để xem chi tiết
                                            </div>
                                        </div>
                                    </a>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Pagination Controls (Phân trang) -->
                        <c:if test="${totalPages > 1}">
                            <nav aria-label="Product Pagination" class="d-flex justify-content-center">
                                <ul class="pagination pagination-lg">
                                    <!-- Previous Button -->
                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="<c:url value='/product?page=${currentPage - 1}${selectedCategoryId != null ? "&categoryId=".concat(selectedCategoryId) : ""}${keyword != null ? "&keyword=".concat(keyword) : ""}'/>" aria-label="Previous">
                                                <i class="fa-solid fa-angles-left"></i> Trước
                                            </a>
                                        </li>
                                    </c:if>

                                    <!-- Page Number Buttons -->
                                    <c:forEach begin="1" end="${totalPages}" var="p">
                                        <li class="page-item ${p == currentPage ? 'active' : ''}">
                                            <a class="page-link" href="<c:url value='/product?page=${p}${selectedCategoryId != null ? "&categoryId=".concat(selectedCategoryId) : ""}${keyword != null ? "&keyword=".concat(keyword) : ""}'/>">
                                                ${p}
                                            </a>
                                        </li>
                                    </c:forEach>

                                    <!-- Next Button -->
                                    <c:if test="${currentPage < totalPages}">
                                        <li class="page-item">
                                            <a class="page-link" href="<c:url value='/product?page=${currentPage + 1}${selectedCategoryId != null ? "&categoryId=".concat(selectedCategoryId) : ""}${keyword != null ? "&keyword=".concat(keyword) : ""}'/>" aria-label="Next">
                                                Sau <i class="fa-solid fa-angles-right"></i>
                                            </a>
                                        </li>
                                    </c:if>
                                </ul>
                            </nav>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5 bg-white rounded-4 shadow-sm">
                            <i class="fa-solid fa-box-open text-muted" style="font-size: 60px;"></i>
                            <h5 class="mt-3 text-muted">Không tìm thấy sản phẩm nào!</h5>
                            <p class="text-secondary small">Vui lòng thử lại với từ khóa hoặc danh mục khác.</p>
                            <a href="<c:url value='/product'/>" class="btn btn-outline-primary rounded-pill px-4">
                                Xem tất cả sản phẩm
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</body>
</html>
