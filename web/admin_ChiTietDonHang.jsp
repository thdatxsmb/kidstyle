<%-- 
    Document   : admin_ChiTietDonHang
    Created on : Mar 17, 2026, 3:33:43 PM
    Author     : LEGION 5
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, Model.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>

<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"QuanTri".equals(admin.getVaiTro())) {
        response.sendRedirect("Login.jsp");
        return;
    }

    DonHang donHang = (DonHang) request.getAttribute("donHang");
    List<ChiTietDonHang> list = (List<ChiTietDonHang>) request.getAttribute("chiTietList");

    if (donHang == null) {
        response.sendRedirect("Admin_QuanLyDonHangController");
        return;
    }

    if (list == null) list = new ArrayList<>();

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    nf.setMaximumFractionDigits(0);

    String tt = donHang.getTrangThai();
    String hoan = donHang.getTrangThaiHoan();

    String statusText = "";
    String statusClass = "";
    String statusIcon = "";

    if ("ChoDuyet".equals(hoan)) {
        statusText = "Yêu cầu hoàn";
        statusClass = "status-return";
        statusIcon = "bi-arrow-return-left";

    } else if ("DaDuyet".equals(hoan)) {
        statusText = "Đã hoàn";
        statusClass = "status-return-ok";
        statusIcon = "bi-arrow-return-right";

    } else if ("TuChoi".equals(hoan)) {
        statusText = "Từ chối hoàn";
        statusClass = "status-return-cancel";
        statusIcon = "bi-x-octagon";

    } else {

        switch (tt) {
            case "ChoXacNhan":
                statusText = "Chờ xác nhận";
                statusClass = "status-pending";
                statusIcon = "bi-hourglass-split";
                break;

            case "DaXacNhan":
                statusText = "Đã xác nhận";
                statusClass = "status-confirm";
                statusIcon = "bi-check-circle";
                break;

            case "DangGiao":
                statusText = "Đang giao";
                statusClass = "status-shipping";
                statusIcon = "bi-truck";
                break;

            case "DaGiao":
                statusText = "Đã giao";
                statusClass = "status-done";
                statusIcon = "bi-box-seam";
                break;

            case "DaHuy":
                statusText = "Đã hủy";
                statusClass = "status-cancel";
                statusIcon = "bi-x-circle";
                break;

            default:
                statusText = "Không rõ";
                statusClass = "status-cancel";
                statusIcon = "bi-question-circle";
        }
    }
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Admin - Chi tiết đơn</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home_admin.css">
    </head>

    <body>

        <%@ include file="../layout/header_admin.jsp" %>
        <%@ include file="../layout/sidebar_admin.jsp" %>

        <div class="main-content" id="mainContent">
            <div class="container-fluid">

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="fw-bold">
                        <i class="bi bi-receipt-cutoff"></i>
                        Đơn hàng #<span class="text-primary"><%=donHang.getMaDonHang()%></span>
                    </h3>

                    <button onclick="goBack()" class="btn btn-secondary">
                        ← Quay lại
                    </button>

                    <script>
                        function goBack() {
                            history.back();
                        }
                    </script>
                </div>

                <div class="card mb-4 shadow-sm">
                    <div class="card-header d-flex justify-content-between">
                        <h5><i class="bi bi-info-circle"></i> Thông tin đơn hàng</h5>

                        <span class="badge-status <%= statusClass %>">
                            <% if ("ChoXacNhan".equals(tt)) { %>
                            <i class="bi bi-hourglass-split"></i>
                            <% } else if ("DaXacNhan".equals(tt)) { %>
                            <i class="bi bi-check-circle"></i>
                            <% } else if ("DangGiao".equals(tt)) { %>
                            <i class="bi bi-truck"></i>
                            <% } else if ("DaGiao".equals(tt)) { %>
                            <i class="bi bi-box-seam"></i>
                            <% } else if ("DaHuy".equals(tt)) { %>
                            <i class="bi bi-x-circle"></i>
                            <% } %>

                            <% if ("ChoDuyet".equals(hoan)) { %>
                            <i class="bi bi-arrow-repeat"></i>
                            <% } else if ("DaDuyet".equals(hoan)) { %>
                            <i class="bi bi-check2-circle"></i>
                            <% } else if ("TuChoi".equals(hoan)) { %>
                            <i class="bi bi-x-octagon"></i>
                            <% } %>

                            <%= statusText %>
                        </span>
                    </div>

                    <div class="card-body row">
                        <div class="col-md-6">
                            <p><strong>Ngày đặt:</strong> <%= sdf.format(donHang.getNgayDatHang())%></p>
                            <p><strong>Thanh toán:</strong> <%= donHang.getPhuongThucThanhToan()%></p>
                            <p><strong>Tổng tiền:</strong> 
                                <span class="text-danger fw-bold"><%= nf.format(donHang.getTongTien())%></span>
                            </p>
                        </div>

                        <div class="col-md-6">
                            <p><strong>Người nhận:</strong> <%= donHang.getTenNguoiNhan()%></p>
                            <p><strong>SĐT:</strong> <%= donHang.getSoDienThoaiNhan()%></p>
                            <p><strong>Địa chỉ:</strong> <%= donHang.getDiaChiNhanHang()%></p>
                        </div>
                    </div>

                    <div class="px-3 pb-3">
                        <strong>Ghi chú:</strong> 
                        <%= (donHang.getGhiChu() != null && !donHang.getGhiChu().trim().isEmpty())
                                ? donHang.getGhiChu()
                                : "Không có"%>
                    </div>
                </div>

                <div class="mb-3">

                    <% if ("DaHuy".equals(tt)) { %>
                    <div class="alert alert-danger d-flex align-items-center gap-2">
                        <i class="bi bi-x-circle-fill"></i>
                        Đơn hàng đã bị hủy - 
                        <b><%= donHang.getLyDo() != null ? donHang.getLyDo() : "Không rõ lý do"%></b>
                    </div>
                    <% } %>

                    <% if ("ChoDuyet".equals(hoan)) { %>
                    <div class="alert alert-warning d-flex align-items-center gap-2">
                        <i class="bi bi-arrow-return-left"></i>
                        Khách đang yêu cầu hoàn hàng
                    </div>
                    <% } %>

                    <% if ("DaDuyet".equals(hoan)) { %>
                    <div class="alert alert-secondary d-flex align-items-center gap-2">
                        <i class="bi bi-arrow-return-right"></i>
                        Đơn hàng đã hoàn
                    </div>
                    <% } %>

                </div>

                <div class="card shadow-sm">
                    <div class="card-header">
                        <h5><i class="bi bi-box-seam"></i> Sản phẩm</h5>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover align-middle text-center">

                            <thead class="table-dark">
                                <tr>
                                    <th>Ảnh</th>
                                    <th>Tên</th>
                                    <th>Giá</th>
                                    <th>SL</th>
                                    <th>Thành tiền</th>
                                </tr>
                            </thead>

                            <tbody>
                                <% for (ChiTietDonHang ct : list) { %>
                                <tr>
                                    <td>
                                        <img src="<%= ct.getDuongDanAnh()%>" width="70" class="rounded">
                                    </td>

                                    <td class="fw-semibold">
                                        <%= ct.getTenSanPham()%>
                                    </td>

                                    <td><%= nf.format(ct.getDonGia())%></td>

                                    <td>
                                        <span class="badge bg-primary">
                                            <%= ct.getSoLuong()%>
                                        </span>
                                    </td>

                                    <td class="text-danger fw-bold">
                                        <%= nf.format(ct.getThanhTien())%>
                                    </td>
                                </tr>
                                <% } %>

                                <% if (list.isEmpty()) { %>
                                <tr>
                                    <td colspan="5" class="text-muted py-4">
                                        Không có sản phẩm
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>

                        </table>
                    </div>
                </div>

            </div>
        </div>

    </body>
</html>