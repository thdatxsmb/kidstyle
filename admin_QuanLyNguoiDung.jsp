<%-- 
    Document   : admin_QuanLyNguoiDung
    Created on : Mar 16, 2026, 3:26:07 PM
    Author     : LEGION 5
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.User"%>
<%@page import="java.util.List"%>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"QuanTri".equals(admin.getVaiTro())) {
        response.sendRedirect("Login.jsp");
        return;
    }
    List<User> list = (List<User>) request.getAttribute("danhSachNguoiDung");
    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("success");
    session.removeAttribute("error");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý người dùng</title>
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
                        <i class="bi bi-people-fill text-primary me-2"></i>
                        Quản lý người dùng
                    </h4>

                    <div class="d-flex align-items-center gap-2">
                        <div class="input-group" style="width: 320px;">
                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                            <input type="text" id="searchInput" class="form-control"
                                   placeholder="Tìm theo ID, họ tên, email, SĐT..."
                                   onkeyup="searchTable()">
                        </div>
                        <a href="Admin_QuanLyNguoiDungController" class="btn btn-outline-secondary">
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
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0" id="userTable">
                                <thead class="table-dark">
                                    <tr>
                                        <th>ID</th>
                                        <th>Người dùng</th>
                                        <th>Email</th>
                                        <th>SĐT</th>
                                        <th>Địa chỉ</th>
                                        <th>Vai trò</th>
                                        <th>Ngày tạo</th>
                                        <th class="text-center">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (list != null && !list.isEmpty()) {
                                            for (User u : list) {%>
                                    <tr data-search="#<%= u.getMaNguoiDung() + " " + u.getHoTen() + " " + u.getEmail() + " " + (u.getSoDienThoai() != null ? u.getSoDienThoai() : "")%>">
                                        <td class="fw-semibold">#<%= u.getMaNguoiDung()%></td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <i class="bi bi-person-circle fs-3 me-3 text-secondary"></i>
                                                <span class="fw-semibold"><%= u.getHoTen()%></span>
                                            </div>
                                        </td>
                                        <td><%= u.getEmail()%></td>
                                        <td><%= u.getSoDienThoai() != null ? u.getSoDienThoai() : "-"%></td>
                                        <td><%= u.getDiaChi() != null ? u.getDiaChi() : "-"%></td>

                                        <td>
                                            <% if ("QuanTri".equals(u.getVaiTro())) { %>
                                            <span class="badge bg-danger">Quản trị</span>
                                            <% } else { %>
                                            <span class="badge bg-primary">Khách hàng</span>
                                            <% }%>
                                        </td>
                                        <td>
                                            <%= u.getNgayTao() != null
                                                    ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(u.getNgayTao())
                                                    : "N/A"%>
                                        </td>
                                        <td class="text-center" style="width: 140px; white-space: nowrap;">
                                            <button class="btn btn-sm btn-warning me-1"
                                                    onclick="editUser(<%= u.getMaNguoiDung()%>, '<%= u.getHoTen()%>', '<%= u.getEmail()%>', '<%= u.getSoDienThoai() != null ? u.getSoDienThoai() : ""%>', '<%= u.getDiaChi() != null ? u.getDiaChi().replace("'", "\\'") : ""%>', '<%= u.getVaiTro()%>')">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <% if (admin.getMaNguoiDung() != u.getMaNguoiDung()) {%>
                                            <button class="btn btn-sm btn-danger"
                                                    onclick="confirmDelete(<%= u.getMaNguoiDung()%>, '<%= u.getHoTen()%>')">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% }
                                    } else { %>
                                    <tr>
                                        <td colspan="8" class="text-center py-5 text-muted">
                                            Không có dữ liệu người dùng
                                        </td>
                                    </tr>
                                    <% }%>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="addModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <form action="Admin_QuanLyNguoiDungController" method="post">
                        <input type="hidden" name="action" value="add">

                        <div class="modal-header border-bottom">
                            <h5 class="modal-title fw-semibold">
                                <i class="bi bi-person-plus-fill text-success me-2"></i>
                                Thêm người dùng mới
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>

                        <div class="modal-body">
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <label class="form-label fw-medium">Họ và tên <span class="text-danger">*</span></label>
                                    <input type="text" name="hoTen" class="form-control" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-medium">Email <span class="text-danger">*</span></label>
                                    <input type="email" name="email" class="form-control" required
                                           oninput="this.setCustomValidity('')">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-medium">Số điện thoại</label>
                                    <input type="text" name="soDienThoai" class="form-control"
                                           maxlength="10"
                                           pattern="^(03|05|07|08|09)[0-9]{8}$"
                                           required
                                           oninvalid="this.setCustomValidity('SĐT phải 10 số và bắt đầu bằng 03,05,07,08,09')"
                                           oninput="this.setCustomValidity('')">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-medium">Vai trò</label>
                                    <select name="vaiTro" class="form-select">
                                        <option value="KhachHang">Khách hàng</option>
                                        <option value="QuanTri">Quản trị viên</option>
                                    </select>
                                </div>

                                <div class="col-12">
                                    <label class="form-label fw-medium">Địa chỉ</label>
                                    <input type="text" name="diaChi" class="form-control" required
                                           oninvalid="this.setCustomValidity('Vui lòng nhập địa chỉ')"
                                           oninput="this.setCustomValidity('')">                                </div>

                                <div class="col-12">
                                    <label class="form-label fw-medium">Mật khẩu <span class="text-danger">*</span></label>
                                    <input type="password" name="matKhau" class="form-control" required>
                                </div>
                            </div>
                        </div>

                        <div class="modal-footer border-top">
                            <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-success px-4">
                                <i class="bi bi-check-circle me-2"></i>Thêm người dùng
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <form action="Admin_QuanLyNguoiDungController" method="post">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="maNguoiDung" id="edit_maNguoiDung">

                        <div class="modal-header border-bottom">
                            <h5 class="modal-title fw-semibold">
                                <i class="bi bi-pencil-square text-primary me-2"></i>
                                Chỉnh sửa thông tin người dùng
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>

                        <div class="modal-body">
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <label class="form-label fw-medium">Họ và tên <span class="text-danger">*</span></label>
                                    <input type="text" name="hoTen" id="edit_hoTen" class="form-control" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-medium">Email <span class="text-danger">*</span></label>
                                    <input type="email" name="email" id="edit_email" class="form-control" required
                                           oninput="this.setCustomValidity('')">                             
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-medium">Số điện thoại</label>
                                    <input type="text" name="soDienThoai" id="edit_soDienThoai" class="form-control"
                                           maxlength="10"
                                           required
                                           pattern="^(03|05|07|08|09)[0-9]{8}$"
                                           oninvalid="this.setCustomValidity('SĐT phải 10 số và bắt đầu bằng 03,05,07,08,09')"
                                           oninput="this.setCustomValidity('')">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-medium">Vai trò</label>
                                    <select name="vaiTro" id="edit_vaiTro" class="form-select">
                                        <option value="KhachHang">Khách hàng</option>
                                        <option value="QuanTri">Quản trị viên</option>
                                    </select>
                                </div>

                                <div class="col-12">
                                    <label class="form-label fw-medium">Địa chỉ</label>
                                    <input type="text" name="diaChi" id="edit_diaChi" class="form-control">
                                </div>

                                <div class="col-12">
                                    <label class="form-label fw-medium">Mật khẩu mới <small class="text-muted">(để trống nếu không đổi)</small></label>
                                    <input type="password" name="matKhau" id="edit_matKhauMoi" 
                                           class="form-control" placeholder="Nhập mật khẩu mới nếu muốn thay đổi">
                                </div>
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
                            Xác nhận xóa người dùng
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <div class="modal-body py-4">
                        <p class="mb-1">Bạn có chắc chắn muốn xóa người dùng:</p>
                        <p class="fw-semibold text-danger mb-0" id="deleteName"></p>
                        <small class="text-muted">Hành động này không thể hoàn tác.</small>
                    </div>

                    <div class="modal-footer border-top">
                        <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">Hủy</button>
                        <a href="#" id="confirmDeleteBtn" class="btn btn-danger px-4">
                            <i class="bi bi-trash me-2"></i>Xóa người dùng
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            function searchTable() {
                const input = document.getElementById("searchInput").value.toLowerCase().trim();
                const rows = document.querySelectorAll("#userTable tbody tr");
                rows.forEach(row => {
                    if (row.cells.length < 2)
                        return;

                    const searchText = row.getAttribute("data-search")
                            ? row.getAttribute("data-search").toLowerCase()
                            : "";

                    row.style.display = searchText.includes(input) ? "" : "none";
                });
            }

            function editUser(ma, hoTen, email, sdt, diaChi, vaiTro) {
                document.getElementById("edit_maNguoiDung").value = ma;
                document.getElementById("edit_hoTen").value = hoTen;
                document.getElementById("edit_email").value = email;
                document.getElementById("edit_soDienThoai").value = sdt || "";
                document.getElementById("edit_diaChi").value = diaChi || "";
                document.getElementById("edit_vaiTro").value = vaiTro || "KhachHang";

                document.getElementById("edit_matKhauMoi").value = "";

                new bootstrap.Modal(document.getElementById("editModal")).show();
            }

            function confirmDelete(ma, ten) {
                document.getElementById("deleteName").textContent = ten;
                document.getElementById("confirmDeleteBtn").href =
                        "Admin_QuanLyNguoiDungController?action=delete&maNguoiDung=" + ma;
                new bootstrap.Modal(document.getElementById("deleteModal")).show();
            }
        </script>
    </body>
</html>