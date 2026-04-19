<%-- 
    Document   : admin_QuanLyDanhMuc
    Created on : Mar 16, 2026, 6:11:17 PM
    Author     : LEGION 5
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.DanhMuc"%>
<%@page import="java.util.List"%>
<%
    List<DanhMuc> list = (List<DanhMuc>) request.getAttribute("danhSachDanhMuc");
    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("success");
    session.removeAttribute("error");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý danh mục</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home_admin.css">
    </head>
    <body>
        <%@ include file="../layout/header_admin.jsp" %>
        <%@ include file="../layout/sidebar_admin.jsp" %>

        <div class="main-content" id="mainContent">
            <div class="container-fluid py-4">

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4 class="fw-bold mb-0">
                        <i class="bi bi-tags-fill text-primary me-2"></i>
                        Quản lý danh mục
                    </h4>

                    <div class="d-flex align-items-center gap-2">
                        <div class="input-group" style="width: 320px;">
                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                            <input type="text" id="searchInput" class="form-control"
                                   placeholder="Tìm theo ID hoặc tên danh mục..." 
                                   onkeyup="searchTable()">
                        </div>
                        <a href="Admin_QuanLyDanhMucController" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-clockwise"></i> Tải lại
                        </a>
                        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addModal">
                            <i class="bi bi-plus-lg"></i> Thêm mới
                        </button>
                    </div>
                </div>

                <% if (success != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <%= success %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>
                <% if (error != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <%= error %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>

                <div class="card shadow-sm">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0" id="categoryTable">
                                <thead class="table-dark">
                                    <tr>
                                        <th width="80">ID</th>
                                        <th>Danh mục</th>
                                        <th>Mô tả</th>
                                        <th>Ngày tạo</th>
                                        <th width="120" class="text-center">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (list != null && !list.isEmpty()) {
                        for (DanhMuc dm : list) { %>
                                    <tr data-search="<%= dm.getMaDanhMuc() %> <%= dm.getTenDanhMuc() + " " + (dm.getMoTa() != null ? dm.getMoTa() : "") %>">
                                        <td class="fw-semibold text-center"><%= dm.getMaDanhMuc() %></td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <i class="bi bi-folder-fill fs-4 me-3 text-warning"></i>
                                                <span class="fw-semibold"><%= dm.getTenDanhMuc() %></span>
                                            </div>
                                        </td>
                                        <td><%= dm.getMoTa() != null ? dm.getMoTa() : "-" %></td>
                                        <td>
                                            <%= dm.getNgayTao() != null
                                                ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(dm.getNgayTao())
                                                : "N/A" %>
                                        </td>
                                        <td class="text-center">
                                            <button class="btn btn-sm btn-warning me-1"
                                                    onclick="editCategory(<%= dm.getMaDanhMuc() %>, '<%= dm.getTenDanhMuc() %>', '<%= dm.getMoTa() != null ? dm.getMoTa().replace("'", "\\'") : "" %>')">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger"
                                                    onclick="confirmDelete(<%= dm.getMaDanhMuc() %>, '<%= dm.getTenDanhMuc() %>')">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <% }
                    } else { %>
                                    <tr>
                                        <td colspan="5" class="text-center py-5 text-muted">
                                            Không có dữ liệu danh mục
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <div class="modal fade" id="addModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form action="Admin_QuanLyDanhMucController" method="post">
                        <input type="hidden" name="action" value="add">

                        <div class="modal-header border-bottom">
                            <h5 class="modal-title fw-semibold">
                                <i class="bi bi-folder-plus text-success me-2"></i>
                                Thêm danh mục mới
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>

                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label fw-medium">Tên danh mục <span class="text-danger">*</span></label>
                                <input type="text" name="tenDanhMuc" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-medium">Mô tả</label>
                                <textarea name="moTa" class="form-control" rows="4" placeholder="Nhập mô tả danh mục..."></textarea>
                            </div>
                        </div>

                        <div class="modal-footer border-top">
                            <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-success px-4">
                                <i class="bi bi-plus-circle me-2"></i>Thêm danh mục
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form action="Admin_QuanLyDanhMucController" method="post">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="maDanhMuc" id="edit_maDanhMuc">

                        <div class="modal-header border-bottom">
                            <h5 class="modal-title fw-semibold">
                                <i class="bi bi-pencil-square text-primary me-2"></i>
                                Chỉnh sửa danh mục
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>

                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label fw-medium">Tên danh mục <span class="text-danger">*</span></label>
                                <input type="text" name="tenDanhMuc" id="edit_tenDanhMuc" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-medium">Mô tả</label>
                                <textarea name="moTa" id="edit_moTa" class="form-control" rows="4"></textarea>
                            </div>
                        </div>

                        <div class="modal-footer border-top">
                            <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">Hủy</button>
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
                            Xác nhận xóa danh mục
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <div class="modal-body py-4">
                        <p class="mb-2">Bạn có chắc chắn muốn xóa danh mục:</p>
                        <p class="fw-semibold text-danger mb-0" id="deleteName"></p>
                        <small class="text-muted">Hành động này không thể hoàn tác.</small>
                    </div>

                    <div class="modal-footer border-top">
                        <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">Hủy</button>
                        <a href="#" id="confirmDeleteBtn" class="btn btn-danger px-4">
                            <i class="bi bi-trash me-2"></i>Xóa danh mục
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            function searchTable() {
                const input = document.getElementById("searchInput").value.toLowerCase().trim();
                const rows = document.querySelectorAll("#categoryTable tbody tr");

                rows.forEach(row => {
                    if (row.cells.length < 2)
                        return;

                    const searchText = row.getAttribute("data-search")
                            ? row.getAttribute("data-search").toLowerCase()
                            : "";

                    row.style.display = searchText.includes(input) ? "" : "none";
                });
            }

            function editCategory(ma, ten, moTa) {
                document.getElementById("edit_maDanhMuc").value = ma;
                document.getElementById("edit_tenDanhMuc").value = ten;
                document.getElementById("edit_moTa").value = moTa || "";
                new bootstrap.Modal(document.getElementById("editModal")).show();
            }

            function confirmDelete(ma, ten) {
                document.getElementById("deleteName").textContent = ten;
                document.getElementById("confirmDeleteBtn").href =
                        "Admin_QuanLyDanhMucController?action=delete&id=" + ma;
                new bootstrap.Modal(document.getElementById("deleteModal")).show();
            }
        </script>
    </body>
</html>