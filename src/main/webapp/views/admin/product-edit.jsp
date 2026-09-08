<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cập Nhật Sản Phẩm - DT SHOP Admin</title>
    <style>
        .page-header-box {
            margin-bottom: 25px;
        }
        .page-title {
            color: #0f172a;
            font-size: 1.75rem;
            font-weight: 800;
            letter-spacing: -0.5px;
            margin: 0;
        }
        .page-subtitle {
            color: #64748b;
            font-size: 0.9rem;
            margin-top: 4px;
        }
        .card-custom {
            background: white;
            border-radius: 20px;
            border: 1px solid #f1f5f9;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.04);
            max-width: 900px;
            overflow: hidden;
        }
        .card-custom-header {
            padding: 20px 24px;
            border-bottom: 1px solid #f1f5f9;
            font-weight: 700;
            font-size: 1.05rem;
            color: #0f172a;
        }
        .card-custom-body {
            padding: 30px;
        }
        .img-preview {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 14px;
            border: 1px solid #e2e8f0;
            background-color: #f8fafc;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }
    </style>
</head>
<body>

    <div class="container my-4">
        <!-- Admin Subnav Tabs -->
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom flex-wrap gap-2">
            <ul class="nav nav-pills gap-2">
                <li class="nav-item">
                    <a class="nav-link rounded-pill px-3 text-secondary" href="<c:url value='/admin/categories'/>">
                        <i class="fa-solid fa-folder-tree me-1"></i> Danh mục
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link rounded-pill px-3 text-secondary" href="<c:url value='/admin/category/add'/>">
                        <i class="fa-solid fa-plus me-1"></i> Thêm danh mục
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link rounded-pill px-3 text-secondary" href="<c:url value='/admin/products'/>">
                        <i class="fa-solid fa-box-open me-1"></i> Sản phẩm
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link rounded-pill px-3 text-secondary" href="<c:url value='/admin/product/add'/>">
                        <i class="fa-solid fa-circle-plus me-1"></i> Thêm sản phẩm
                    </a>
                </li>
            </ul>
            <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle px-3 py-2 rounded-pill fw-semibold">
                <i class="fa-solid fa-shield-halved me-1"></i> Khu vực quản trị
            </span>
        </div>

        <div class="page-header-box">
            <h1 class="page-title">Cập Nhật Thông Tin Sản Phẩm</h1>
            <p class="page-subtitle">Chỉnh sửa thông số, danh mục và hình ảnh cho sản phẩm #${product.productId}</p>
        </div>

        <div class="card-custom">
            <div class="card-custom-header d-flex justify-content-between align-items-center">
                <span><i class="fa-solid fa-pen-to-square text-primary me-2"></i> ${product.productName}</span>
                <span class="badge bg-light text-dark border">ID: #${product.productId}</span>
            </div>
            <div class="card-custom-body">
                <form action="<c:url value='/admin/product/update'/>" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="productId" value="${product.productId}">

                    <div class="row g-3 mb-3">
                        <div class="col-md-8">
                            <label class="form-label fw-semibold text-secondary small">Tên Sản Phẩm <span class="text-danger">*</span></label>
                            <input type="text" class="form-control form-control-lg" name="productName" value="${product.productName}" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold text-secondary small">Danh Mục <span class="text-danger">*</span></label>
                            <select class="form-select form-select-lg" name="categoryId" required>
                                <c:forEach items="${categories}" var="c">
                                    <option value="${c.categoryId}" ${product.category != null && product.category.categoryId == c.categoryId ? 'selected' : ''}>
                                        ${c.categoryname}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-4">
                            <label class="form-label fw-semibold text-secondary small">Giá Bán (VNĐ) <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" name="price" value="${product.price}" min="0" step="1000" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold text-secondary small">Số Lượng Kho <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" name="quantity" value="${product.quantity}" min="0" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold text-secondary small">Trạng Thái</label>
                            <select class="form-select" name="status">
                                <option value="1" ${product.status == 1 ? 'selected' : ''}>Hoạt động (Đang bán)</option>
                                <option value="0" ${product.status == 0 ? 'selected' : ''}>Khóa (Tạm ngừng)</option>
                            </select>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold text-secondary small">Mô Tả Chi Tiết Sản Phẩm</label>
                        <textarea class="form-control" name="description" rows="4">${product.description}</textarea>
                    </div>

                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary small">Tải Ảnh Mới Thay Thế (nếu có)</label>
                            <input type="file" class="form-control" name="images1" accept="image/*">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary small">Hoặc Cập Nhật URL Ảnh Trực Tiếp</label>
                            <input type="text" class="form-control" name="images" value="${product.images}">
                        </div>
                    </div>

                    <c:if test="${not empty product.images}">
                        <div class="p-3 bg-light rounded-3 mb-4 border d-flex align-items-center gap-3">
                            <div>
                                <c:choose>
                                    <c:when test="${product.images.startsWith('http')}">
                                        <img src="${product.images}" class="img-preview" alt="Preview" onerror="this.onerror=null; this.src='<c:url value='/image?fname=default'/>';">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="<c:url value='/image?fname=${product.images}'/>" class="img-preview" alt="Preview" onerror="this.onerror=null; this.src='<c:url value='/image?fname=default'/>';">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div>
                                <div class="fw-bold small text-dark mb-1">Hình ảnh hiện tại của sản phẩm</div>
                                <div class="text-muted small text-break mb-1">${product.images}</div>
                                <div class="text-secondary small" style="font-size: 0.78rem;">
                                    <i class="fa-solid fa-circle-info text-primary me-1"></i> Tải lên ảnh mới ở trên nếu bạn muốn thay thế ảnh này.
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <div class="d-flex justify-content-end gap-3 pt-3 border-top">
                        <a href="<c:url value='/admin/products'/>" class="btn btn-outline-secondary rounded-pill px-4">
                            <i class="fa-solid fa-arrow-left me-2"></i> Quay lại
                        </a>
                        <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold shadow">
                            <i class="fa-solid fa-check me-2"></i> Cập Nhật Sản Phẩm
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
