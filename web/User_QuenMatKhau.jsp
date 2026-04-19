<%-- 
    Document   : User_QuenMatKhau
    Created on : Apr 17, 2026, 12:16:46 PM
    Author     : LEGION 5
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quên mật khẩu - KidStyle</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
              rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    </head>

    <body>

        <div class="wrapper">

            <div class="left-side">
                <div class="teddy">🧸✨</div>
                <h2>KidStyle</h2>
                <p>
                    Đừng lo lắng nếu bạn quên mật khẩu 💕<br>
                    Hãy gửi yêu cầu, đội ngũ KidStyle sẽ hỗ trợ bạn nhanh chóng!
                </p>
            </div>

            <div class="right-side">
                <div class="login-box">

                    <h4 class="login-title">
                        <span class="icon-badge">
                            <i class="bi bi-key-fill"></i>
                        </span>
                        Quên mật khẩu
                    </h4>
                    <%
                        String msg = (String) session.getAttribute("msg");
                        if (msg != null) {
                    %>
                    <div class="alert alert-success text-center">
                        <%= msg%>
                    </div>
                    <%
                            session.removeAttribute("msg");
                        }
                    %>

                    <form action="User_HoTroController" method="post">
                        <input type="hidden" name="source" value="forgot">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">
                                <i class="bi bi-person-badge-fill me-1"></i> Họ tên
                            </label>
                            <input type="text" name="ten" class="form-control"
                                   placeholder="Nhập họ tên..." required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">
                                <i class="bi bi-envelope-fill me-1"></i> Email
                            </label>
                            <input type="email" name="email" class="form-control"
                                   placeholder="Nhập email..." required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">
                                <i class="bi bi-telephone-fill me-1"></i> Số điện thoại
                            </label>
                            <input type="text" name="sdt" class="form-control"
                                   placeholder="Nhập số điện thoại..." required>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-semibold">
                                <i class="bi bi-chat-left-text-fill me-1"></i> Mô tả vấn đề
                            </label>
                            <textarea name="noiDung" class="form-control"
                                      rows="3"
                                      placeholder="Ví dụ: Tôi quên mật khẩu tài khoản..."
                                      required></textarea>
                        </div>

                        <button type="submit" class="btn btn-login mb-3">
                            <i class="bi bi-send-fill me-2"></i> GỬI YÊU CẦU
                        </button>

                        <div class="text-center small">
                            <a href="Login.jsp" class="d-block mb-2 text-muted">
                                <i class="bi bi-arrow-left-circle-fill me-2"></i> Quay lại Đăng nhập
                            </a>

                            <a href="DangKy.jsp" class="fw-bold text-primary">
                                Tạo tài khoản mới
                            </a>
                        </div>
                    </form>

                </div>
            </div>

        </div>

    </body>
</html>