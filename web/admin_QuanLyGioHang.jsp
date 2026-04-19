<%-- 
    Document   : admin_QuanLyGioHang
    Created on : Mar 18, 2026, 9:29:23 AM
    Author     : LEGION 5
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, Model.GioHangAdmin"%>
<%@page import="Model.User"%>

<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"QuanTri".equals(admin.getVaiTro())) {
        response.sendRedirect("Login.jsp");
        return;
    }

    List<GioHangAdmin> list = (List<GioHangAdmin>) request.getAttribute("list");

    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("success");
    session.removeAttribute("error");
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý giỏ hàng</title>

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
                    <h4 class="fw-bold">
                        <i class="bi bi-cart-fill text-primary me-2"></i>
                        Quản lý giỏ hàng
                    </h4>

                    <div class="d-flex gap-2">
                        <div class="input-group" style="width: 320px;">
                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                            <input type="text" id="searchInput" class="form-control"
                                   placeholder="Tìm theo id hoặc tên user..."
                                   onkeyup="searchTable()">
                        </div>

                        <a href="Admin_QuanLyGioHangController" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-clockwise"></i> Tải lại
                        </a>
                    </div>
                </div>

                <% if (success != null) { %>
                <div class="alert alert-success alert-dismissible fade show">
                    <%= success %>
                    <button class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>

                <% if (error != null) { %>
                <div class="alert alert-danger alert-dismissible fade show">
                    <%= error %>
                    <button class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>

                <div class="card shadow-sm">
                    <div class="card-body p-0">
                        <div class="table-responsive">

                            <table class="table table-hover align-middle mb-0" id="cartTable">
                                <thead class="table-dark">
                                    <tr>
                                        <th>ID User</th>
                                        <th>Người dùng</th>
                                        <th>Số loại SP</th>
                                        <th>Tổng tiền</th>
                                        <th class="text-center">Thao tác</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <% if (list != null && !list.isEmpty()) {
                            for (GioHangAdmin g : list) { %>

                                    <tr data-search="<%= g.getMaNguoiDung() %> <%= g.getTenDangNhap().toLowerCase() %>">
                                        <td class="fw-semibold"><%= g.getMaNguoiDung() %></td>

                                        <td>
                                            <div class="d-flex align-items-center">
                                                <i class="bi bi-person-circle fs-4 me-2 text-secondary"></i>
                                                <span class="fw-semibold"><%= g.getTenDangNhap() %></span>
                                            </div>
                                        </td>

                                        <td>
                                            <span class="badge bg-primary">
                                                <%= g.getTongSanPham() %>
                                            </span>
                                        </td>

                                        <td class="text-danger fw-bold">
                                            <%= String.format("%,.0f", g.getTongTien()) %> đ
                                        </td>

                                        <td class="text-center">

                                            <a href="Admin_QuanLyGioHangController?action=view&maNguoiDung=<%= g.getMaNguoiDung() %>"
                                               class="btn btn-sm btn-info me-1">
                                                <i class="bi bi-eye"></i>
                                            </a>

                                            <button class="btn btn-sm btn-danger"
                                                    onclick="confirmDelete(<%= g.getMaNguoiDung() %>, '<%= g.getTenDangNhap() %>')">
                                                <i class="bi bi-trash"></i>
                                            </button>

                                        </td>

                                    </tr>

                                    <% }} else { %>

                                    <tr>
                                        <td colspan="5" class="text-center py-5 text-muted">
                                            <i class="bi bi-cart-x fs-4"></i><br>
                                            Không có giỏ hàng
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

        <div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-danger text-white border-0">
                        <h5 class="modal-title fw-semibold">
                            <i class="bi bi-trash-fill me-2"></i>
                            Xác nhận xóa giỏ hàng
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body py-4">
                        <p class="mb-1">Bạn có chắc chắn muốn xóa giỏ hàng của:</p>
                        <p class="fw-semibold text-danger mb-0" id="deleteName"></p>
                        <small class="text-muted">Hành động này không thể hoàn tác.</small>
                    </div>
                    <div class="modal-footer border-top">
                        <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">
                            Hủy
                        </button>
                        <a href="#" id="confirmDeleteBtn" class="btn btn-danger px-4">
                            <i class="bi bi-trash me-2"></i>Xóa giỏ hàng
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            function searchTable() {
                let input = document.getElementById("searchInput").value.toLowerCase().trim();

                document.querySelectorAll("#cartTable tbody tr").forEach(row => {
                    if (!row.hasAttribute("data-search")) {
                        row.style.display = "";
                        return;
                    }

                    let searchText = row.getAttribute("data-search").toLowerCase();

                    if (searchText.includes(input)) {
                        row.style.display = "";
                    } else {
                        row.style.display = "none";
                    }
                });
            }

            function confirmDelete(id, ten) {
                document.getElementById("deleteName").textContent = ten;

                document.getElementById("confirmDeleteBtn").href =
                        "Admin_QuanLyGioHangController?action=delete&maNguoiDung=" + id;

                new bootstrap.Modal(document.getElementById("deleteModal")).show();
            }
        </script>
    </body>
</html>