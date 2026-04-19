<%--
    Document   : User_HoSo
    Created on : Mar 14, 2026
    Author     : LEGION 5
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.User"%>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("Login.jsp");
        return;
    }

    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg = (String) session.getAttribute("errorMsg");

    session.removeAttribute("successMsg");
    session.removeAttribute("errorMsg");
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hồ sơ cá nhân - KidStyle</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user_hoso.css">

    </head>
    <body>

        <%@ include file="layout/header.jsp" %>
        <%@ include file="layout/sidebar.jsp" %>

        <div class="sidebar-backdrop" id="sidebarBackdrop"></div>

        <div class="main-content container py-5">
            <div class="row g-4">
                <div class="col-lg-4">
                    <div class="profile-card card mb-4">
                        <div class="card-body text-center py-5">
                            <i class="bi bi-person-circle display-1 text-primary mb-3"></i>
                            <h4 class="mb-1"><%= user.getHoTen()%></h4>
                            <p class="text-muted mb-0"><%= user.getEmail()%></p>
                        </div>
                    </div>

                    <div class="profile-card card">
                        <div class="list-group list-group-flush">
                            <a href="User_HoSoController" class="list-group-item list-group-item-action active px-4 py-3">
                                <i class="bi bi-person me-3"></i> Hồ sơ cá nhân
                            </a>
                            <a href="User_DonHangController" class="list-group-item list-group-item-action px-4 py-3">
                                <i class="bi bi-receipt me-3"></i> Đơn hàng của tôi
                            </a>
                            <a href="Logout" class="list-group-item list-group-item-action text-danger px-4 py-3">
                                <i class="bi bi-box-arrow-right me-3"></i> Đăng xuất
                            </a>
                        </div>
                    </div>
                </div>

                <div class="col-lg-8">
                    <div class="profile-card card">
                        <div class="card-header text-white py-3">
                            <h5 class="mb-0">
                                <i class="bi bi-person-lines-fill me-2"></i>
                                Cập nhật thông tin cá nhân
                            </h5>
                        </div>
                        <div class="card-body p-4">

                            <% if (successMsg != null && !successMsg.trim().isEmpty()) {%>
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <%= successMsg%>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <% } %>

                            <% if (errorMsg != null && !errorMsg.trim().isEmpty()) {%>
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <%= errorMsg%>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <% }%>

                            <form action="User_HoSoController" method="post" class="row g-3">
                                <input type="hidden" name="maNguoiDung" value="<%= user.getMaNguoiDung()%>">

                                <div class="col-md-6">
                                    <label class="form-label fw-medium">
                                        <i class="bi bi-person-fill me-1"></i> Họ và tên
                                    </label>
                                    <input type="text" name="hoTen" class="form-control" 
                                           value="<%= user.getHoTen()%>" required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-medium">
                                        <i class="bi bi-envelope-fill me-1"></i> Email
                                    </label>
                                    <input type="email" name="email" class="form-control" 
                                           value="<%= user.getEmail()%>" required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-medium">
                                        <i class="bi bi-telephone-fill me-1"></i> Số điện thoại
                                    </label>
                                    <input type="text" name="soDienThoai" class="form-control"
                                           value="<%= user.getSoDienThoai() != null ? user.getSoDienThoai() : ""%>"
                                           pattern="^(03|05|07|08|09)[0-9]{8}$"
                                           required
                                           oninvalid="this.setCustomValidity('SĐT phải 10 số và bắt đầu bằng 03,05,07,08,09')"
                                           oninput="this.setCustomValidity('')">
                                </div>

                                <div class="col-12">
                                    <label class="form-label fw-medium">
                                        <i class="bi bi-geo-alt-fill me-1"></i> Địa chỉ nhận hàng
                                    </label>
                                    <input type="text" name="diaChi" class="form-control" 
                                           value="<%= user.getDiaChi() != null ? user.getDiaChi() : ""%>"
                                           placeholder="Ví dụ: 123 Đường Láng, Đống Đa, Hà Nội">
                                </div>

                                <div class="col-12 mt-4">
                                    <button type="submit" class="btn btn-main px-5 py-2">
                                        <i class="bi bi-check-circle-fill me-2"></i> Lưu thông tin
                                    </button>
                                </div>
                            </form>

                            <hr class="my-5">
                            <div class="card-header text-white py-3">
                                <h5 class="mb-0">
                                    <i class="bi bi-shield-lock me-2"></i>
                                    Đổi mật khẩu
                                </h5>
                            </div><br>
                            <form action="User_DoiMatKhauController" method="post" class="row g-3">

                                <div class="col-12">
                                    <label class="form-label fw-medium">
                                        <i class="bi bi-lock-fill me-1"></i> Mật khẩu hiện tại
                                    </label>
                                    <div class="input-group">
                                        <input type="password" name="matKhauHienTai" id="currentPass" class="form-control" 
                                               required placeholder="Nhập mật khẩu hiện tại">
                                        <span class="input-group-text" id="toggleCurrent" style="cursor: pointer;">
                                            <i class="bi bi-eye-slash" id="iconCurrent"></i>
                                        </span>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-medium">
                                        <i class="bi bi-key-fill me-1"></i> Mật khẩu mới
                                    </label>
                                    <div class="input-group">
                                        <input type="password" name="matKhauMoi" id="newPass" class="form-control" 
                                               required minlength="6" placeholder="Tối thiểu 6 ký tự">
                                        <span class="input-group-text" id="toggleNew" style="cursor: pointer;">
                                            <i class="bi bi-eye-slash" id="iconNew"></i>
                                        </span>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-medium">
                                        <i class="bi bi-patch-check-fill me-1"></i> Xác nhận mật khẩu mới
                                    </label>
                                    <div class="input-group">
                                        <input type="password" name="xacNhan" id="confirmPass" class="form-control" 
                                               required minlength="6" placeholder="Nhập lại mật khẩu mới">
                                        <span class="input-group-text" id="toggleConfirm" style="cursor: pointer;">
                                            <i class="bi bi-eye-slash" id="iconConfirm"></i>
                                        </span>
                                    </div>
                                </div>

                                <div class="col-12 mt-3">
                                    <button type="submit" class="btn btn-main px-5 py-2">
                                        <i class="bi bi-lock me-2"></i> Cập nhật mật khẩu
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            function togglePassword(inputId, iconId) {
                const input = document.getElementById(inputId);
                const icon = document.getElementById(iconId);

                if (input.type === "password") {
                    input.type = "text";
                    icon.classList.replace("bi-eye-slash", "bi-eye");
                } else {
                    input.type = "password";
                    icon.classList.replace("bi-eye", "bi-eye-slash");
                }
            }

            document.getElementById("toggleCurrent").addEventListener("click", function () {
                togglePassword("currentPass", "iconCurrent");
            });

            document.getElementById("toggleNew").addEventListener("click", function () {
                togglePassword("newPass", "iconNew");
            });

            document.getElementById("toggleConfirm").addEventListener("click", function () {
                togglePassword("confirmPass", "iconConfirm");
            });
        </script>
    </body>
</html>