<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm Sản Phẩm - DT SHOP Admin</title>
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
                    <a class="nav-link active rounded-pill px-3" href="<c:url value='/admin/product/add'/>">
                        <i class="fa-solid fa-circle-plus me-1"></i> Thêm sản phẩm
                    </a>
                </li>
            </ul>
            <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle px-3 py-2 rounded-pill fw-semibold">
                <i class="fa-solid fa-shield-halved me-1"></i> Khu vực quản trị
            </span>
        </div>

        <div class="page-header-box">
            <h1 class="page-title">Thêm Sản Phẩm Mới</h1>
            <p class="page-subtitle">Nhập thông tin sản phẩm và liên kết với danh mục trong hệ thống DT SHOP</p>
        </div>

        <div class="card-custom">
            <div class="card-custom-header">
                <i class="fa-solid fa-circle-plus text-primary me-2"></i> Form Thông Tin Sản Phẩm
            </div>
            <div class="card-custom-body">
                <form action="<c:url value='/admin/product/insert'/>" method="post" enctype="multipart/form-data">
                    <div class="row g-3 mb-3">
                        <div class="col-md-8">
                            <label class="form-label fw-semibold text-secondary small">Tên Sản Phẩm <span class="text-danger">*</span></label>
                            <input type="text" class="form-control form-control-lg" name="productName" placeholder="Nhập tên sản phẩm..." required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold text-secondary small">Danh Mục <span class="text-danger">*</span></label>
                            <select class="form-select form-select-lg" name="categoryId" required>
                                <c:forEach items="${categories}" var="c">
                                    <option value="${c.categoryId}">${c.categoryname}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-4">
                            <label class="form-label fw-semibold text-secondary small">Giá Bán (VNĐ) <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" name="price" placeholder="ví dụ: 1500000" min="0" step="1000" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold text-secondary small">Số Lượng Kho <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" name="quantity" placeholder="ví dụ: 25" min="0" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold text-secondary small">Trạng Thái</label>
                            <select class="form-select" name="status">
                                <option value="1" selected>Hoạt động (Đang bán)</option>
                                <option value="0">Khóa (Tạm ngừng)</option>
                            </select>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold text-secondary small">Mô Tả Chi Tiết Sản Phẩm</label>
                        <textarea class="form-control" name="description" rows="4" placeholder="Nhập thông tin mô tả chi tiết, thông số kỹ thuật..."></textarea>
                    </div>

                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary small">Tải Ảnh Lên Từ Máy Tính</label>
                            <input type="file" class="form-control" name="images1" accept="image/*">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary small">Hoặc Dán Đường Dẫn URL Ảnh Trực Tiếp</label>
                            <input type="text" class="form-control" name="images" placeholder="https://example.com/image.jpg">
                        </div>
                    </div>

                    <div class="d-flex justify-content-end gap-3 pt-3 border-top">
                        <a href="<c:url value='/admin/products'/>" class="btn btn-outline-secondary rounded-pill px-4">
                            <i class="fa-solid fa-arrow-left me-2"></i> Quay lại
                        </a>
                        <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold shadow">
                            <i class="fa-solid fa-check me-2"></i> Lưu Sản Phẩm
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
