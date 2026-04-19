<%-- 
    Document   : admin_ThanhToan
    Created on : Mar 30, 2026, 5:45:07 PM
    Author     : LEGION 5
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, Model.ThanhToan"%>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý thanh toán</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home_admin.css">
    </head>

    <body>

        <%@ include file="../layout/header_admin.jsp" %>
        <%@ include file="../layout/sidebar_admin.jsp" %>

        <div class="main-content" id="mainContent">
            <div class="container-fluid p-4">

                <%
                    List<ThanhToan> listTT = (List<ThanhToan>) request.getAttribute("danhSachThanhToan");
                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

                    int tong = (listTT != null) ? listTT.size() : 0;
                    int daThanhToan = 0;
                    int choThanhToan = 0;

                    if (listTT != null) {
                        for (ThanhToan tt : listTT) {
                            if ("DaXacNhan".equals(tt.getTrangThaiDon())) {
                                daThanhToan++;
                            } else {
                                choThanhToan++;
                            }
                        }
                    }
                %>

                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4 class="fw-bold">💳 Quản lý thanh toán</h4>
                    <a href="Admin_ThanhToanController" class="btn btn-outline-primary btn-sm">
                        <i class="bi bi-arrow-clockwise"></i> Reload
                    </a>
                </div>

                <div class="row mb-4">

                    <div class="col-md-4">
                        <div class="card text-center shadow-sm">
                            <div class="card-body">
                                <i class="bi bi-receipt fs-3 text-primary"></i>
                                <p class="mb-1">Tổng giao dịch</p>
                                <h5 class="fw-bold text-primary"><%= tong%></h5>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card text-center shadow-sm">
                            <div class="card-body">
                                <i class="bi bi-check-circle fs-3 text-success"></i>
                                <p class="mb-1">Đã thanh toán</p>
                                <h5 class="fw-bold text-success"><%= daThanhToan%></h5>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card text-center shadow-sm">
                            <div class="card-body">
                                <i class="bi bi-clock fs-3 text-warning"></i>
                                <p class="mb-1">Chờ thanh toán</p>
                                <h5 class="fw-bold text-warning"><%= choThanhToan%></h5>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="input-group mb-3">
                    <span class="input-group-text"><i class="bi bi-search"></i></span>
                    <input type="text" id="searchInput" class="form-control" placeholder="Tìm mã đơn hàng...">
                </div>

                <div class="card shadow-sm">
                    <%
                        String msg = (String) session.getAttribute("message");
                        if (msg != null) {
                    %>
                    <div class="alert alert-info"><%= msg%></div>
                    <%
                            session.removeAttribute("message");
                        }
                    %>

                    <div class="card-header bg-dark text-white">Danh sách thanh toán</div>

                    <div style="max-height: 500px; overflow-y: auto;">
                        <table class="table table-hover text-center mb-0" id="paymentTable">

                            <thead class="table-light sticky-top">
                                <tr>
                                    <th>ID</th>
                                    <th>Mã đơn</th>
                                    <th>Số tiền</th>
                                    <th>Phương thức</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>

                            <tbody>
                                <% if (listTT != null) {
                                        for (ThanhToan tt : listTT) {%>

                                <tr>
                                    <td>#<%= tt.getMaThanhToan()%></td>

                                    <td class="maDon"><%= tt.getMaDonHang()%></td>

                                    <td class="fw-bold text-primary">
                                        <%= String.format("%,.0f", tt.getSoTien())%> đ
                                    </td>

                                    <td>
                                        <span class="badge <%= "COD".equals(tt.getPhuongThuc()) ? "bg-secondary" : "bg-info text-dark"%>">
                                            <%= tt.getPhuongThuc()%>
                                        </span>
                                    </td>

                                    <td>
                                        <span class="badge
                                              <%= "DaXacNhan".equals(tt.getTrangThaiDon()) ? "bg-success" : "bg-warning text-dark" %>">

                                            <%= "DaXacNhan".equals(tt.getTrangThaiDon()) 
                                                ? "Đã xác nhận" 
                                                : "Chờ xác nhận" %>
                                        </span>
                                    </td>

                                    <td>
                                        <%= (tt.getNgayThanhToan() != null) ? sdf.format(tt.getNgayThanhToan()) : ""%>
                                    </td>
                                    <td>
                                        <% if ("ChoThanhToan".equals(tt.getTrangThai()) 
                                            && !"COD".equals(tt.getPhuongThuc())) { %>

                                        <form action="Admin_ThanhToanController" method="post">
                                            <input type="hidden" name="action" value="duyet">
                                            <input type="hidden" name="maThanhToan" value="<%= tt.getMaThanhToan()%>">
                                            <button class="btn btn-success btn-sm">✔ Duyệt</button>
                                        </form>

                                        <% } else if ("COD".equals(tt.getPhuongThuc())) { %>
                                        <span class="text-secondary">COD - Không cần duyệt</span>
                                        <% } else { %>
                                        <span class="text-success">✔ Đã duyệt</span>
                                        <% } %>
                                    </td>
                                </tr>

                                <% }
                                    }%>
                            </tbody>

                        </table>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

                <script>
                    document.getElementById("searchInput").addEventListener("keyup", function () {
                        let keyword = this.value.toLowerCase();
                        let rows = document.querySelectorAll("#paymentTable tbody tr");

                        rows.forEach(row => {
                            let maDon = row.querySelector(".maDon").innerText.toLowerCase();
                            row.style.display = maDon.includes(keyword) ? "" : "none";
                        });
                    });
                </script>
            </div>
        </div>
    </body>
</html>