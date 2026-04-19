<%-- 
    Document   : admin_QuanLySanPham
    Created on : Mar 16, 2026, 5:52:31 PM
    Author     : LEGION 5
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.SanPham"%>
<%@page import="Model.DanhMuc"%>
<%@page import="java.util.List"%>

<%
    List<SanPham> list = (List<SanPham>) request.getAttribute("danhSachSanPham");
    List<DanhMuc> dsdm = (List<DanhMuc>) request.getAttribute("danhSachDanhMuc");

    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("success");
    session.removeAttribute("error");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý sản phẩm</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home_admin.css">

    </head>

    <body class="bg-light">

        <%@ include file="../layout/header_admin.jsp" %>
        <%@ include file="../layout/sidebar_admin.jsp" %>

        <div class="main-content" id="mainContent">
            <div class="container-fluid p-4">

                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h3 class="fw-bold text-primary">
                        <i class="bi bi-box-seam"></i> Quản lý sản phẩm
                    </h3>

                    <div class="d-flex gap-2">
                        <div class="input-group" style="width: 320px;">
                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                            <input id="searchInput" class="form-control"
                                   placeholder="Tìm sản phẩm theo ID, tên ..." onkeyup="searchTable()">
                        </div>
                        <a href="Admin_QuanLySanPhamController" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-clockwise"></i> Tải lại
                        </a>
                        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addModal">
                            <i class="bi bi-plus-lg"></i> Thêm mới
                        </button>
                    </div>
                </div>

                <% if (success != null) {%>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <%= success%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>
                <% if (error != null) {%>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <%= error%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>

                <div class="card shadow-sm">
                    <div class="card-body table-responsive">

                        <table class="table table-hover align-middle text-center" id="productTable">                         
                            <thead class="table-dark text-center">
                                <tr>
                                    <th>ID</th>
                                    <th>Ảnh</th>
                                    <th>Tên</th>
                                    <th>Danh mục</th>
                                    <th>Mô tả</th>
                                    <th>Giá</th>
                                    <th>KM</th>
                                    <th>Tồn</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>

                            <tbody>
                                <%
                                    if (list != null) {
                                        for (SanPham sp : list) {

                                            String ten = sp.getTenSanPham() != null ? sp.getTenSanPham().replace("'", "\\'") : "";
                                            String moTa = sp.getMoTa() != null ? sp.getMoTa().replace("'", "\\'") : "";
                                            String anh = sp.getDuongDanAnh() != null ? sp.getDuongDanAnh() : "";
                                %>

                                <tr>
                                    <td>#<%= sp.getMaSanPham()%></td>

                                    <td>
                                        <img src="<%= anh%>" style="width:60px;height:60px;object-fit:cover;border-radius:10px">
                                    </td>

                                    <td class="text-start fw-semibold"><%= sp.getTenSanPham()%></td>

                                    <td><%= sp.getTenDanhMuc() %></td>

                                    <td class="text-start" style="max-width:250px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
                                        <%= sp.getMoTa() != null ? sp.getMoTa() : "-" %>
                                    </td>

                                    <td class="text-success fw-semibold text-nowrap">
                                        <%= String.format("%,.0f đ", sp.getGiaBan())%>
                                    </td>

                                    <td class="text-nowrap">
                                        <%= sp.getGiaKhuyenMai() > 0 ? String.format("%,.0f đ", sp.getGiaKhuyenMai()) : "-"%>
                                    </td>

                                    <td class="fw-semibold"><%= sp.getTonKho()%></td>

                                    <td>
                                        <% if ("ConHang".equals(sp.getTrangThai())) { %>
                                        <span class="badge bg-success">Còn hàng</span>
                                        <% } else if ("HetHang".equals(sp.getTrangThai())) { %>
                                        <span class="badge bg-secondary">Hết hàng</span>
                                        <% } else { %>
                                        <span class="badge bg-danger">Ngừng bán</span>
                                        <% } %>
                                    </td>

                                    <td>
                                        <div class="d-flex justify-content-center gap-2">
                                            <button class="btn btn-warning btn-sm"
                                                    onclick="editProduct(
                                                    <%= sp.getMaSanPham()%>,
                                                                    '<%= ten%>',
                                                    <%= sp.getMaDanhMuc()%>,
                                                                    '<%= moTa%>',
                                                    <%= sp.getGiaBan()%>,
                                                    <%= sp.getGiaKhuyenMai()%>,
                                                    <%= sp.getTonKho()%>,
                                                                    '<%= anh%>',
                                                                    '<%= sp.getTrangThai()%>'
                                                                    )">
                                                <i class="bi bi-pencil"></i>
                                            </button>

                                            <button class="btn btn-danger btn-sm"
                                                    onclick="confirmDelete(<%= sp.getMaSanPham()%>, '<%= ten%>')">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </div>
                                    </td>

                                </tr>

                                <% }
                                    }%>
                            </tbody>
                        </table>

                    </div>
                </div>

            </div>
        </div>

        <div class="modal fade" id="addModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <form action="Admin_QuanLySanPhamController" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="add">

                        <div class="modal-header border-bottom">
                            <h5 class="modal-title fw-semibold">
                                <i class="bi bi-box-seam text-success me-2"></i>
                                Thêm sản phẩm mới
                            </h5>
                            <button class="btn-close" data-bs-dismiss="modal"></button>
                        </div>

                        <div class="modal-body">
                            <div class="row g-4">

                                <div class="col-md-8">
                                    <label class="form-label fw-medium">Tên sản phẩm *</label>
                                    <input type="text" name="tenSanPham" class="form-control" required>
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label fw-medium">Danh mục</label>

                                    <select name="maDanhMuc" id="addDanhMuc" class="form-select"
                                            onchange="toggleNewCategory('add')">
                                        <option value="">-- Chọn danh mục --</option>
                                        <% for (DanhMuc dm : dsdm) { %>
                                        <option value="<%= dm.getMaDanhMuc()%>">
                                            <%= dm.getTenDanhMuc()%>
                                        </option>
                                        <% } %>
                                        <option value="new">+ Thêm danh mục mới</option>
                                    </select>
                                </div>

                                <div class="col-md-8 d-none" id="newCategoryDivAdd">
                                    <label class="form-label fw-medium">Tên danh mục mới</label>
                                    <input type="text" name="tenDanhMucMoi" class="form-control">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-medium">Giá bán *</label>
                                    <input type="text" name="giaBan" class="form-control"
                                           oninput="formatCurrency(this)" required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-medium">Giá khuyến mãi</label>
                                    <input type="text" name="giaKhuyenMai" class="form-control"
                                           oninput="formatCurrency(this)">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-medium">Tồn kho *</label>
                                    <input type="number" name="tonKho" class="form-control" required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-medium">Link ảnh</label>
                                    <input type="file" name="fileAnh" class="form-control" onchange="previewImage(event, 'previewAdd')">

                                    <img id="previewAdd" 
                                         src="https://via.placeholder.com/100" 
                                         style="width:100px;height:100px;object-fit:cover;margin-top:10px;border-radius:10px;">
                                </div>

                                <div class="col-12">
                                    <label class="form-label fw-medium">Mô tả</label>
                                    <textarea name="moTa" class="form-control" rows="3"></textarea>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-medium">Trạng thái</label>
                                    <select name="trangThai" class="form-select">
                                        <option value="ConHang">Còn hàng</option>
                                        <option value="HetHang">Hết hàng</option>
                                        <option value="NgungBan">Ngừng bán</option>
                                    </select>
                                </div>

                            </div>
                        </div>

                        <div class="modal-footer border-top">
                            <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">
                                Hủy
                            </button>
                            <button class="btn btn-success px-4">
                                <i class="bi bi-plus-circle me-2"></i>Thêm sản phẩm
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="modal fade" id="editModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <form action="Admin_QuanLySanPhamController" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="maSanPham" id="edit_id">

                        <div class="modal-header border-bottom">
                            <h5 class="modal-title fw-semibold">
                                <i class="bi bi-pencil-square text-primary me-2"></i>
                                Chỉnh sửa sản phẩm
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>

                        <div class="modal-body">
                            <div class="row g-4">

                                <div class="col-md-8">
                                    <label class="form-label fw-medium">Tên sản phẩm *</label>
                                    <input type="text" id="edit_ten" name="tenSanPham" class="form-control" required>
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label fw-medium">Danh mục</label>

                                    <select name="maDanhMuc" id="edit_danhmuc" class="form-select"
                                            onchange="toggleNewCategory('edit')">
                                        <option value="">-- Chọn danh mục --</option>
                                        <% for (DanhMuc dm : dsdm) { %>
                                        <option value="<%= dm.getMaDanhMuc()%>">
                                            <%= dm.getTenDanhMuc()%>
                                        </option>
                                        <% } %>
                                        <option value="new">+ Thêm danh mục mới</option>
                                    </select>
                                </div>

                                <div class="col-md-8 d-none" id="newCategoryDivEdit">
                                    <label class="form-label fw-medium">Tên danh mục mới</label>
                                    <input type="text" name="tenDanhMucMoi" class="form-control">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-medium">Giá bán</label>
                                    <input type="text" id="edit_gia" name="giaBan"
                                           class="form-control" oninput="formatCurrency(this)">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-medium">Giá khuyến mãi</label>
                                    <input type="text" id="edit_km" name="giaKhuyenMai"
                                           class="form-control" oninput="formatCurrency(this)">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-medium">Tồn kho</label>
                                    <input type="number" id="edit_kho" name="tonKho" class="form-control">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-medium">Link ảnh</label>
                                    <input type="file" name="fileAnh" class="form-control" onchange="previewImage(event, 'previewEdit')">

                                    <img id="previewEdit" 
                                         src="" 
                                         style="width:100px;height:100px;object-fit:cover;margin-top:10px;border-radius:10px;">
                                    <input type="hidden" id="edit_anhCu" name="duongDanAnhCu">
                                </div>

                                <div class="col-12">
                                    <label class="form-label fw-medium">Mô tả</label>
                                    <textarea id="edit_moTa" name="moTa" class="form-control"></textarea>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-medium">Trạng thái</label>
                                    <select id="edit_trangthai" name="trangThai" class="form-select">
                                        <option value="ConHang">Còn hàng</option>
                                        <option value="HetHang">Hết hàng</option>
                                        <option value="NgungBan">Ngừng bán</option>
                                    </select>
                                </div>

                            </div>
                        </div>

                        <div class="modal-footer border-top">
                            <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">
                                Hủy
                            </button>
                            <button type="submit" class="btn btn-primary px-4">
                                <i class="bi bi-save me-2"></i>Lưu thay đổi
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">

                    <div class="modal-header bg-danger text-white border-0">
                        <h5 class="modal-title fw-semibold">
                            <i class="bi bi-trash-fill me-2"></i>
                            Xác nhận xóa sản phẩm
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body py-4">
                        <p class="mb-1">Bạn có chắc chắn muốn xóa sản phẩm:</p>
                        <p class="fw-semibold text-danger mb-0" id="deleteProductName"></p>
                        <small class="text-muted">Hành động này không thể hoàn tác.</small>
                    </div>

                    <div class="modal-footer border-top">
                        <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">Hủy</button>
                        <a href="#" id="confirmDeleteBtn" class="btn btn-danger px-4">
                            <i class="bi bi-trash me-2"></i>Xóa sản phẩm
                        </a>
                    </div>

                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            function searchTable() {
                let input = document.getElementById("searchInput").value.toLowerCase();
                document.querySelectorAll("#productTable tbody tr").forEach(r => {
                    r.style.display = r.innerText.toLowerCase().includes(input) ? "" : "none";
                });
            }

            function editProduct(id, ten, dm, mt, gia, km, kho, anh, tt) {
                document.getElementById("edit_id").value = id;
                document.getElementById("edit_ten").value = ten;
                document.getElementById("edit_danhmuc").value = dm;
                document.getElementById("edit_gia").value =
                        new Intl.NumberFormat('vi-VN').format(gia);

                document.getElementById("edit_km").value =
                        km > 0 ? new Intl.NumberFormat('vi-VN').format(km) : '';
                document.getElementById("edit_kho").value = kho;
                document.getElementById("previewEdit").src = anh;
                document.getElementById("edit_anhCu").value = anh;
                document.getElementById("edit_moTa").value = mt;
                document.getElementById("edit_trangthai").value = tt;

                new bootstrap.Modal(document.getElementById("editModal")).show();
            }

            function confirmDelete(id, ten) {
                document.getElementById("deleteProductName").textContent = ten;

                document.getElementById("confirmDeleteBtn").href =
                        "Admin_QuanLySanPhamController?action=delete&maSanPham=" + id;

                new bootstrap.Modal(document.getElementById("deleteModal")).show();
            }

            function toggleNewCategory(type) {
                let select = document.getElementById(type === 'add' ? "addDanhMuc" : "edit_danhmuc");
                let div = document.getElementById(type === 'add' ? "newCategoryDivAdd" : "newCategoryDivEdit");

                if (select.value === "new") {
                    div.classList.remove("d-none");
                } else {
                    div.classList.add("d-none");
                }
            }

            function previewImage(event, previewId) {
                const file = event.target.files[0];

                if (file) {
                    const reader = new FileReader();

                    reader.onload = function (e) {
                        document.getElementById(previewId).src = e.target.result;
                    }

                    reader.readAsDataURL(file);
                }
            }

            function formatCurrency(input) {
                let value = input.value.replace(/\D/g, '');
                if (value === '') {
                    input.value = '';
                    return;
                }
                input.value = new Intl.NumberFormat('vi-VN').format(value);
            }
        </script>
    </body>
</html>