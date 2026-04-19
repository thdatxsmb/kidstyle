<%-- 
    Document   : User_DatHangThanhCong
    Created on : Mar 25, 2026, 10:40:38 PM
    Author     : LEGION 5
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.User"%>
<%
    User user = (User) session.getAttribute("user");
    String maDonHang = request.getParameter("maDon");
    if (maDonHang == null || maDonHang.isEmpty()) {
        maDonHang = "Không xác định";
    }
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đặt hàng thành công - KidStyle</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user_dathangthanhcong.css">

    </head>
    <body class="bg-light">

        <%@ include file="../layout/header.jsp" %>
        <%@ include file="../layout/sidebar.jsp" %>
        <div class="sidebar-backdrop" id="sidebarBackdrop"></div>

        <div class="main-content">
            <div class="success-container">
                <div class="card p-5">
                    <i class="bi bi-check-circle-fill success-icon"></i>

                    <h1 class="fw-bold text-success mb-3">ĐẶT HÀNG THÀNH CÔNG!</h1>

                    <p class="lead text-muted mb-4">
                        Cảm ơn bạn đã mua sắm tại <strong>KidStyle</strong> 💕<br>
                        Đơn hàng của bạn đã được ghi nhận thành công.
                    </p>

                    <div class="alert alert-success fs-5 py-3">
                        <strong>Mã đơn hàng:</strong> 
                        <span class="fw-bold">#<%= maDonHang%></span>
                    </div>

                    <p class="text-muted mb-5">
                        Chúng tôi sẽ liên hệ với bạn sớm nhất để xác nhận đơn hàng và giao hàng.<br>
                        Thời gian giao dự kiến: <strong>2 - 4 ngày làm việc</strong>
                    </p>

                    <div class="d-grid gap-3 d-md-flex justify-content-md-center">
                        <a href="User_DonHangController" class="btn btn-primary btn-custom flex-fill">
                            <i class="bi bi-list-check me-2"></i>
                            Xem đơn hàng của tôi
                        </a>
                        <a href="User_DSSPController" class="btn btn-outline-primary btn-custom flex-fill">
                            <i class="bi bi-shop me-2"></i>
                            Tiếp tục mua sắm
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    </body>
</html>