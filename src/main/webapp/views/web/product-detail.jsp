<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.productName} - Chi Tiết Sản Phẩm</title>
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
        .detail-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.04);
            border: 1px solid #f1f5f9;
            overflow: hidden;
            padding: 35px;
        }
        .detail-img-wrapper {
            background-color: #f8fafc;
            border-radius: 16px;
            overflow: hidden;
            border: 1px solid #e2e8f0;
            text-align: center;
            padding: 20px;
        }
        .detail-img {
            max-width: 100%;
            max-height: 480px;
            object-fit: contain;
            border-radius: 12px;
            transition: transform 0.3s ease;
        }
        .detail-img:hover {
            transform: scale(1.02);
        }
        .product-price-tag {
            font-size: 2.2rem;
            font-weight: 800;
            color: #2563eb;
        }
        .related-card {
            background: white;
            border-radius: 14px;
            border: 1px solid #f1f5f9;
            text-decoration: none;
            color: inherit;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            transition: all 0.2s;
            height: 100%;
        }
        .related-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 20px rgba(0,0,0,0.06);
            color: inherit;
        }
        .related-img {
            width: 100%;
            height: 160px;
            object-fit: cover;
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

    <!-- Main Detail Container -->
    <div class="container my-4">

        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="<c:url value='/home'/>" class="text-decoration-none">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="<c:url value='/product'/>" class="text-decoration-none">Sản phẩm</a></li>
                <c:if test="${product.category != null}">
                    <li class="breadcrumb-item">
                        <a href="<c:url value='/product?categoryId=${product.category.categoryId}'/>" class="text-decoration-none">
                            ${product.category.categoryname}
                        </a>
                    </li>
                </c:if>
                <li class="breadcrumb-item active" aria-current="page">${product.productName}</li>
            </ol>
        </nav>

        <!-- Product Main Card -->
        <div class="detail-card mb-5">
            <div class="row g-5">
                <!-- Image Preview -->
                <div class="col-lg-6">
                    <div class="detail-img-wrapper">
                        <c:choose>
                            <c:when test="${product.images != null && product.images.startsWith('http')}">
                                <img src="${product.images}" alt="${product.productName}" class="detail-img">
                            </c:when>
                            <c:otherwise>
                                <img src="<c:url value='/image?fname=${product.images}'/>" alt="${product.productName}" class="detail-img" onerror="this.src='https://via.placeholder.com/500x500?text=No+Image';">
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Info Column -->
                <div class="col-lg-6 d-flex flex-column">
                    <div class="mb-2">
                        <c:if test="${product.category != null}">
                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-2 rounded-pill fw-semibold">
                                <i class="fa-solid fa-tag me-1"></i> ${product.category.categoryname}
                            </span>
                        </c:if>
                        <c:choose>
                            <c:when test="${product.quantity > 0 && product.status == 1}">
                                <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-2 rounded-pill fw-semibold ms-2">
                                    <i class="fa-solid fa-check me-1"></i> Còn hàng (${product.quantity} sản phẩm)
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-3 py-2 rounded-pill fw-semibold ms-2">
                                    <i class="fa-solid fa-xmark me-1"></i> Hết hàng
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <h1 class="fw-bold text-dark mt-2 mb-3">${product.productName}</h1>

                    <div class="product-price-tag mb-4">
                        ${product.formattedPrice}
                    </div>

                    <hr class="my-2">

                    <!-- Mô tả sản phẩm -->
                    <div class="my-3">
                        <h6 class="fw-bold text-secondary text-uppercase small">Mô Tả Sản Phẩm</h6>
                        <div class="text-secondary lh-lg">
                            <c:choose>
                                <c:when test="${not empty product.description}">
                                    <p>${product.description}</p>
                                </c:when>
                                <c:otherwise>
                                    <p class="fst-italic text-muted">Chưa có thông tin mô tả chi tiết cho sản phẩm này.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Ngày tạo / Cập nhật -->
                    <div class="small text-muted mb-4">
                        <i class="fa-regular fa-clock me-1"></i> Ngày đăng: 
                        <fmt:formatDate value="${product.createDate}" pattern="dd/MM/yyyy HH:mm" />
                    </div>

                    <!-- Nút thao tác -->
                    <div class="mt-auto d-flex flex-wrap gap-3">
                        <a href="<c:url value='/product'/>" class="btn btn-outline-secondary btn-lg rounded-pill px-4">
                            <i class="fa-solid fa-arrow-left me-2"></i>Quay lại danh sách
                        </a>
                        <button class="btn btn-primary btn-lg rounded-pill px-5 fw-bold shadow">
                            <i class="fa-solid fa-cart-plus me-2"></i>Thêm vào giỏ hàng
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Related Products Section (Sản phẩm cùng danh mục) -->
        <c:if test="${not empty relatedProducts}">
            <div class="mt-5">
                <h4 class="fw-bold mb-4"><i class="fa-solid fa-boxes-stacked text-primary me-2"></i>Sản Phẩm Cùng Danh Mục</h4>
                <div class="row row-cols-1 row-cols-sm-2 row-cols-md-4 g-4">
                    <c:forEach items="${relatedProducts}" var="rp">
                        <div class="col">
                            <a href="<c:url value='/product/detail?id=${rp.productId}'/>" class="related-card">
                                <c:choose>
                                    <c:when test="${rp.images != null && rp.images.startsWith('http')}">
                                        <img src="${rp.images}" alt="${rp.productName}" class="related-img">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="<c:url value='/image?fname=${rp.images}'/>" alt="${rp.productName}" class="related-img" onerror="this.src='https://via.placeholder.com/300x200?text=No+Image';">
                                    </c:otherwise>
                                </c:choose>
                                <div class="p-3 d-flex flex-column flex-grow-1">
                                    <div class="fw-bold small text-truncate" title="${rp.productName}">${rp.productName}</div>
                                    <div class="text-primary fw-bold mt-2">
                                        ${rp.formattedPrice}
                                    </div>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>
    </div>
</body>
</html>
