<%--
    Document   : DangKy
    Created on : Feb 24, 2026, 5:10:20 PM
    Author     : LEGION 5 
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng Ký - KidStyle</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dangky.css">
    </head>
    <body>
        <div class="wrapper">
            <div class="left-side">
                <div class="teddy">🧸✨</div>
                <h2>KidStyle</h2>
                <p>Chào mừng bạn trở lại với KidStyle 💕<br>
                    Đăng ký để khám phá thế giới thời trang dễ thương cho bé! 🌸</p>
            </div>

            <div class="right-side">
                <div class="register-box">
                    <h4 class="login-title">
                        <span class="icon-badge">
                            <i class="bi bi-person-lines-fill"></i>
                        </span>
                        Đăng ký tài khoản
                    </h4>
                    <%
                        String error = (String) request.getAttribute("error");
                        if (error == null) {
                            error = (String) session.getAttribute("error");
                            if (error != null) {
                                session.removeAttribute("error");
                            }
                        }
                        if (error != null) {
                    %>
                    <div class="alert alert-danger text-center"><%= error%></div>
                    <% } %>

                    <%
                        String success = (String) request.getAttribute("success");
                        if (success == null) {
                            success = (String) session.getAttribute("success");
                            if (success != null) {
                                session.removeAttribute("success");
                            }
                        }
                        if (success != null) {
                    %>
                    <div class="alert alert-success text-center"><%= success%></div>
                    <% }%>

                    <form action="DangKy" method="post">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">
                                <i class="bi bi-person-badge-fill me-1"></i> Họ và tên
                            </label>
                            <input type="text" name="HoTen" class="form-control" placeholder="Nhập họ và tên..." required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">
                                <i class="bi bi-envelope-fill me-1"></i> Email
                            </label>
                            <input type="email" name="Email" class="form-control" placeholder="Nhập email..." required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">
                                <i class="bi bi-telephone-fill me-1"></i> Số điện thoại
                            </label>
                            <input type="text" name="SoDienThoai" class="form-control" 
                                   placeholder="Nhập số điện thoại..." required pattern="[0-9]{9,11}">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">
                                <i class="bi bi-lock-fill me-1"></i> Mật khẩu
                            </label>
                            <div class="input-group">
                                <input type="password" name="MatKhau" id="password" class="form-control" 
                                       placeholder="Nhập mật khẩu..." required minlength="6">
                                <span class="input-group-text" id="togglePass">
                                    <i class="bi bi-eye-slash" id="iconEye"></i>
                                </span>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-semibold">
                                <i class="bi bi-shield-check me-1"></i> Xác nhận mật khẩu
                            </label>
                            <div class="input-group">
                                <input type="password" name="XacNhanMatKhau" id="confirmPassword" class="form-control" 
                                       placeholder="Nhập lại mật khẩu..." required minlength="6">
                                <span class="input-group-text" id="toggleConfirmPass">
                                    <i class="bi bi-eye-slash" id="iconEyeConfirm"></i>
                                </span>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-semibold">
                                <i class="bi bi-geo-alt-fill me-1"></i> Địa chỉ
                            </label>
                            <input type="text" name="DiaChi" class="form-control" placeholder="Nhập địa chỉ ..." required>
                        </div>

                        <input type="hidden" name="VaiTro" value="KhachHang">

                        <button type="submit" class="btn btn-register mb-3 w-100">
                            <i class="bi bi-person-plus-fill me-2"></i> ĐĂNG KÝ
                        </button>

                        <div class="text-center small">
                            <span>Đã có tài khoản? </span>
                            <a href="Login.jsp" class="login-link">Đăng nhập ngay</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
            const togglePass = document.getElementById("togglePass");
            const password = document.getElementById("password");
            const iconEye = document.getElementById("iconEye");

            togglePass.onclick = function () {
                if (password.type === "password") {
                    password.type = "text";
                    iconEye.classList.replace("bi-eye-slash", "bi-eye");
                } else {
                    password.type = "password";
                    iconEye.classList.replace("bi-eye", "bi-eye-slash");
                }
            };

            const toggleConfirm = document.getElementById("toggleConfirmPass");
            const confirmPass = document.getElementById("confirmPassword");
            const iconEyeConfirm = document.getElementById("iconEyeConfirm");

            toggleConfirm.onclick = function () {
                if (confirmPass.type === "password") {
                    confirmPass.type = "text";
                    iconEyeConfirm.classList.replace("bi-eye-slash", "bi-eye");
                } else {
                    confirmPass.type = "password";
                    iconEyeConfirm.classList.replace("bi-eye", "bi-eye-slash");
                }
            };
        </script>
    </body>
</html>