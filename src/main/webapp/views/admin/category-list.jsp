<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Danh Mục - DT SHOP Admin</title>
    <style>
        .page-header-box {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
            gap: 15px;
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
            overflow: hidden;
        }
        .card-custom-header {
            padding: 20px 24px;
            border-bottom: 1px solid #f1f5f9;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }
        .category-thumb {
            width: 80px;
            height: 80px;
            border-radius: 14px;
            object-fit: cover;
            border: 1px solid #e2e8f0;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.04);
            background-color: #f8fafc;
        }
        .table-custom th {
            background-color: #f8fafc;
            color: #475569;
            font-weight: 700;
            font-size: 0.82rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 16px 20px;
            border-bottom: 1px solid #e2e8f0;
        }
        .table-custom td {
            padding: 16px 20px;
            vertical-align: middle;
            border-bottom: 1px solid #f1f5f9;
        }
        .table-custom tbody tr:hover {
            background-color: #f8fafc;
        }
    </style>
</head>
<body>

    <div class="container my-4">
        <!-- Admin Subnav Tabs -->
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom flex-wrap gap-2">
            <ul class="nav nav-pills gap-2">
                <li class="nav-item">
                    <a class="nav-link active rounded-pill px-3" href="<c:url value='/admin/categories'/>">
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

        <!-- Header with Title & Add Button -->
        <div class="page-header-box">
            <div>
                <h1 class="page-title">Quản Lý Danh Mục</h1>
                <p class="page-subtitle">Xem, quản lý và chỉnh sửa toàn bộ các danh mục sản phẩm của DT SHOP</p>
            </div>
            <a href="<c:url value='/admin/category/add'/>" class="btn btn-primary btn-lg rounded-pill px-4 shadow-sm fw-bold">
                <i class="fa-solid fa-circle-plus me-2"></i> Thêm Danh Mục Mới
            </a>
        </div>

        <c:if test="${param.msg == 'deleted'}">
            <div class="alert alert-success alert-dismissible fade show rounded-4 shadow-sm mb-4" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> <strong>Thành công:</strong> Đã xóa danh mục khỏi hệ thống!
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show rounded-4 shadow-sm mb-4" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i> <strong>Lỗi:</strong> Không thể xóa danh mục này!
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Table Card -->
        <div class="card-custom">
            <div class="card-custom-header">
                <div class="fw-bold fs-6 text-dark d-flex align-items-center gap-2">
                    <i class="fa-solid fa-table-list text-primary"></i> Danh Sách Danh Mục
                    <span class="badge bg-primary rounded-pill ms-2">${listcate != null ? listcate.size() : 0} danh mục</span>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-custom align-middle mb-0">
                    <thead>
                        <tr>
                            <th style="width: 70px;" class="text-center">STT</th>
                            <th style="width: 110px;" class="text-center">Hình Ảnh</th>
                            <th>Tên Danh Mục</th>
                            <th style="width: 150px;" class="text-center">Trạng Thái</th>
                            <th style="width: 180px;" class="text-center">Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty listcate}">
                                <c:forEach items="${listcate}" var="cate" varStatus="STT">
                                    <tr>
                                        <td class="text-center fw-bold text-secondary">${STT.index + 1}</td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${cate.images != null && cate.images.startsWith('http')}">
                                                    <img class="category-thumb" src="${cate.images}" alt="${cate.categoryname}" onerror="this.onerror=null; this.src='<c:url value='/image?fname=default'/>';">
                                                </c:when>
                                                <c:otherwise>
                                                    <img class="category-thumb" src="<c:url value='/image?fname=${cate.images}'/>" alt="${cate.categoryname}" onerror="this.onerror=null; this.src='<c:url value='/image?fname=default'/>';">
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="fw-bold text-dark fs-6">${cate.categoryname}</div>
                                            <div class="small text-muted">ID Danh mục: #${cate.categoryId}</div>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${cate.status == 1}">
                                                    <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-2 rounded-pill fw-semibold">
                                                        <i class="fa-solid fa-circle-check me-1"></i> Hoạt động
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-3 py-2 rounded-pill fw-semibold">
                                                        <i class="fa-solid fa-lock me-1"></i> Khóa
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <div class="d-inline-flex gap-2">
                                                <a href="<c:url value='/admin/category/edit?id=${cate.categoryId}'/>" class="btn btn-sm btn-outline-primary rounded-pill px-3">
                                                    <i class="fa-solid fa-pen-to-square me-1"></i> Sửa
                                                </a>
                                                <button type="button" 
                                                        class="btn btn-sm btn-outline-danger rounded-pill px-3 btn-delete-category" 
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#deleteCategoryModal" 
                                                        data-name="${cate.categoryname}" 
                                                        data-url="<c:url value='/admin/category/delete?id=${cate.categoryId}'/>">
                                                    <i class="fa-solid fa-trash-can me-1"></i> Xóa
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" class="text-center py-5 text-muted">
                                        <i class="fa-solid fa-folder-open mb-3 text-secondary" style="font-size: 48px;"></i>
                                        <p class="mb-0">Chưa có danh mục nào. Hãy bấm <strong>Thêm Danh Mục Mới</strong> để tạo!</p>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Modal Xác Nhận Xóa Danh Mục Hiện Đại -->
    <div class="modal fade" id="deleteCategoryModal" tabindex="-1" aria-labelledby="deleteModalTitle" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width: 420px;">
            <div class="modal-content border-0 rounded-4 shadow-lg overflow-hidden">
                <div class="modal-body text-center p-4">
                    <div class="d-inline-flex align-items-center justify-content-center bg-danger-subtle text-danger rounded-circle mb-3" style="width: 70px; height: 70px;">
                        <i class="fa-solid fa-trash-can fs-2"></i>
                    </div>
                    <h4 class="fw-bold text-dark mb-2" id="deleteModalTitle">Xác Nhận Xóa</h4>
                    <p class="text-secondary mb-4" id="deleteModalMessage">
                        Bạn có chắc chắn muốn xóa danh mục này khỏi hệ thống không?
                    </p>
                    <div class="d-flex justify-content-center gap-3">
                        <button type="button" class="btn btn-light rounded-pill px-4 fw-semibold border" data-bs-dismiss="modal">
                            <i class="fa-solid fa-xmark me-1"></i> Hủy Bỏ
                        </button>
                        <a id="btnConfirmDeleteCate" href="#" class="btn btn-danger rounded-pill px-4 fw-bold shadow-sm">
                            <i class="fa-solid fa-trash-can me-1"></i> Xóa Danh Mục
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var deleteCateBtns = document.querySelectorAll('.btn-delete-category');
            var modalMsg = document.getElementById('deleteModalMessage');
            var confirmBtn = document.getElementById('btnConfirmDeleteCate');

            deleteCateBtns.forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var cateName = btn.getAttribute('data-name');
                    var deleteUrl = btn.getAttribute('data-url');
                    if (modalMsg) {
                        modalMsg.innerHTML = 'Bạn có chắc chắn muốn xóa danh mục <strong class="text-danger">[' + cateName + ']</strong> không?<br><span class="small text-muted">Hành động này sẽ xóa danh mục khỏi hệ thống.</span>';
                    }
                    if (confirmBtn) {
                        confirmBtn.setAttribute('href', deleteUrl);
                    }
                });
            });
        });
    </script>
</body>
</html>
