<%--
    Document   : Login
    Created on : Feb 24, 2026
    Author     : LEGION 5 - chỉnh sửa đồng bộ KidStyle
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng Nhập - KidStyle</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">

    </head>
    <body>
        <div class="wrapper">
            <div class="left-side">
                <div class="teddy">🧸✨</div>
                <h2>KidStyle</h2>
                <p>Chào mừng bạn trở lại với KidStyle 💕<br>
                    Đăng nhập để tiếp tục cập nhật bộ sưu tập đồ dễ thương cho các bé! 🌸</p>
            </div>

            <div class="right-side">
                <div class="login-box">
                    <h4 class="login-title">
                        <span class="icon-badge">
                            <i class="bi bi-person-lock"></i>
                        </span>
                        Đăng nhập
                    </h4>
                    <%
                        String error = (String) session.getAttribute("error");
                        if (error != null) {
                    %>
                    <div class="alert alert-danger text-center">
                        <%= error%>
                    </div>
                    <%
                            session.removeAttribute("error");
                        }
                    %>

                    <form action="Login" method="post">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">
                                <i class="bi bi-person-fill me-1"></i> Tài khoản
                            </label>
                            <input type="text" name="username" class="form-control" 
                                   placeholder="Nhập email hoặc sdt ..." required>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-semibold">
                                <i class="bi bi-lock-fill me-1"></i> Mật khẩu
                            </label>
                            <div class="input-group">
                                <input type="password" name="password" class="form-control" id="password"
                                       placeholder="Nhập mật khẩu..." required>
                                <span class="input-group-text" id="togglePass">
                                    <i class="bi bi-eye-slash" id="iconEye"></i>
                                </span>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">
                                <i class="bi bi-shield-lock-fill me-1"></i> Mã xác thực
                            </label>
                            <div class="d-flex align-items-center">
                                <input type="text" name="captcha" class="form-control me-3"
                                       placeholder="Nhập mã..." required>
                                <img src="CaptchaServlet" id="captchaImage"
                                     style="height: 45px; border-radius: 10px; border: 1px solid #ddd;">
                                <button type="button" class="btn btn-light ms-2" onclick="reloadCaptcha()">
                                    <i class="bi bi-arrow-clockwise"></i>
                                </button>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-login mb-3">
                            <i class="bi bi-box-arrow-in-right me-2"></i> ĐĂNG NHẬP
                        </button>

                        <div class="text-center small">
                            <a href="User_QuenMatKhau.jsp" class="d-block mb-2 text-muted">
                                Quên mật khẩu?
                            </a>
                            <span>Chưa có tài khoản? </span>
                            <a href="DangKy.jsp" class="fw-bold text-primary">
                                Đăng ký ngay
                            </a>
                            <a href="Home.jsp" class="back-home d-block mt-3">
                                <i class="bi bi-arrow-left-circle-fill me-2"></i> Quay lại Trang chủ
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
            const toggle = document.getElementById("togglePass");
            const password = document.getElementById("password");
            const icon = document.getElementById("iconEye");

            toggle.onclick = function () {
                if (password.type === "password") {
                    password.type = "text";
                    icon.classList.replace("bi-eye-slash", "bi-eye");
                } else {
                    password.type = "password";
                    icon.classList.replace("bi-eye", "bi-eye-slash");
                }
            };

            function reloadCaptcha() {
                document.getElementById("captchaImage").src =
                        "CaptchaServlet?" + new Date().getTime();
            }
        </script>
    </body>
</html>