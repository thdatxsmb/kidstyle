<%-- 
    Document   : admin_ChiTietGioHang
    Created on : Mar 18, 2026, 9:30:20 AM
    Author     : LEGION 5
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, Model.GioHang"%>
<%@page import="Model.User"%>

<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"QuanTri".equals(admin.getVaiTro())) {
        response.sendRedirect("Login.jsp");
        return;
    }

    List<GioHang> list = (List<GioHang>) request.getAttribute("listChiTiet");

    Object tongObj = request.getAttribute("tongTien");
    double tongTien = (tongObj != null) ? (Double) tongObj : 0;
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết giỏ hàng</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home_admin.css">
    </head>

    <body>

        <%@ include file="../layout/header_admin.jsp" %>
        <%@ include file="../layout/sidebar_admin.jsp" %>

        <div class="main-content" id="mainContent">
            <div class="container-fluid">

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="fw-bold">
                        <i class="bi bi-cart4 me-2"></i> Chi tiết giỏ hàng - User ID: 
                        <span class="text-primary"><%=request.getAttribute("maNguoiDung")%></span>
                    </h3>

                    <a href="Admin_QuanLyGioHangController" class="btn btn-secondary">
                        ← Quay lại
                    </a>
                </div>

                <div class="card border-0 shadow-sm">
                    <div class="card-body">

                        <div class="table-responsive">
                            <table class="table table-hover align-middle text-center">

                                <thead class="table-dark">
                                    <tr>
                                        <th>Ảnh</th>
                                        <th>Tên SP</th>
                                        <th>Giá</th>
                                        <th>Số lượng</th>
                                        <th>Tổng</th>
                                        <th>Ngày thêm</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <%
                                        if (list != null && !list.isEmpty()) {
                                            for (GioHang g : list) {
                                                double gia = (g.getGiaKhuyenMai() > 0) ? g.getGiaKhuyenMai() : g.getGiaBan();
                                    %>
                                    <tr>
                                        <td>
                                            <img src="<%=g.getDuongDanAnh()%>" width="70" class="rounded">
                                        </td>

                                        <td><%=g.getTenSanPham()%></td>

                                        <td class="text-danger fw-bold">
                                            <%=String.format("%,.0f", gia)%> đ
                                        </td>

                                        <td>
                                            <span class="badge bg-primary">
                                                <%=g.getSoLuong()%>
                                            </span>
                                        </td>

                                        <td class="fw-bold">
                                            <%=String.format("%,.0f", gia * g.getSoLuong())%> đ
                                        </td>

                                        <td><%=g.getNgayThem()%></td>
                                    </tr>
                                    <%
                                        }
                                    } else {
                                    %>
                                    <tr>
                                        <td colspan="6" class="text-center text-muted py-4">
                                            <i class="bi bi-cart-x fs-4"></i><br>
                                            Giỏ hàng trống
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>

                            </table>
                        </div>

                    </div>
                </div>

                <div class="text-end mt-3">
                    <h5>
                        Tổng tiền: 
                        <span class="text-danger fw-bold">
                            <%=String.format("%,.0f", tongTien)%> đ
                        </span>
                    </h5>
                </div>

            </div>
        </div>
    </body>
</html>