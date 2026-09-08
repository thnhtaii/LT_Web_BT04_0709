<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cập Nhật Danh Mục - DT SHOP Admin</title>
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
            margin-bottom: 0;
        }
        .card-custom {
            background: white;
            border-radius: 20px;
            border: 1px solid #f1f5f9;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.04);
            max-width: 850px;
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
        .preview-img {
            width: 120px;
            height: 120px;
            border-radius: 14px;
            object-fit: cover;
            border: 1px solid #e2e8f0;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            margin-top: 8px;
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
            <h1 class="page-title">Cập Nhật Danh Mục</h1>
            <p class="page-subtitle">Chỉnh sửa thông tin chi tiết danh mục #${cate.categoryId}</p>
        </div>

        <div class="card-custom">
            <div class="card-custom-header">
                <i class="fa-solid fa-pen-to-square text-primary me-2"></i> Chỉnh Sửa Danh Mục: ${cate.categoryname}
            </div>
            <div class="card-custom-body">
                <form action="<c:url value='/admin/category/update'/>" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="categoryid" value="${cate.categoryId}">

                    <div class="mb-4">
                        <label class="form-label fw-semibold text-secondary small">Tên Danh Mục <span class="text-danger">*</span></label>
                        <input type="text" class="form-control form-control-lg" name="categoryname" value="${cate.categoryname}" required>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold text-secondary small">Trạng Thái Hoạt Động</label>
                        <select class="form-select" name="status">
                            <option value="1" ${cate.status == 1 ? 'selected' : ''}>Hoạt động (Hiển thị cho khách hàng)</option>
                            <option value="0" ${cate.status != 1 ? 'selected' : ''}>Khóa (Tạm ẩn danh mục)</option>
                        </select>
                    </div>

                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary small">Tải Ảnh Mới Thay Thế (Tùy chọn)</label>
                            <input type="file" class="form-control" name="images1" accept="image/*">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary small">Hoặc Cập Nhật Đường Dẫn URL Ảnh</label>
                            <input type="text" class="form-control" name="images" value="${cate.images}">
                        </div>
                    </div>

                    <c:if test="${not empty cate.images}">
                        <div class="mb-4">
                            <label class="form-label fw-semibold text-secondary small d-block">Ảnh hiện tại:</label>
                            <c:choose>
                                <c:when test="${cate.images.startsWith('http')}">
                                    <img src="${cate.images}" class="preview-img" alt="Preview" onerror="this.onerror=null; this.src='<c:url value='/image?fname=default'/>';">
                                </c:when>
                                <c:otherwise>
                                    <img src="<c:url value='/image?fname=${cate.images}'/>" class="preview-img" alt="Preview" onerror="this.onerror=null; this.src='<c:url value='/image?fname=default'/>';">
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <div class="d-flex justify-content-end gap-3 pt-3 border-top">
                        <a href="<c:url value='/admin/categories'/>" class="btn btn-outline-secondary rounded-pill px-4">
                            <i class="fa-solid fa-arrow-left me-2"></i> Quay lại
                        </a>
                        <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold shadow">
                            <i class="fa-solid fa-check me-2"></i> Cập Nhật Danh Mục
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
