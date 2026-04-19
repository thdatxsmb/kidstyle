<%-- 
    Document   : HomeAdmin
    Created on : Feb 25, 2026, 10:38:42 AM
    Author     : LEGION 5
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.User"%>
<%@page import="java.util.List"%>
<%@page import="Model.DonHang"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="Model.NhatKy"%>

<%
    NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    nf.setMaximumFractionDigits(0);
    Double doanhThu = (Double) request.getAttribute("doanhThu");
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard - ${user.hoTen}</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home_admin.css">

        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
    </head>
    <body>
        <%@ include file="../layout/header_admin.jsp" %>
        <%@ include file="../layout/sidebar_admin.jsp" %>

        <div class="main-content" id="mainContent">
            <div class="container-fluid p-4">

                <div class="d-flex justify-content-between align-items-center mb-5">
                    <h2 class="fw-bold">📊 Bảng tổng quan</h2>
                    <span class="badge bg-light text-dark p-2 shadow-sm">
                        <i class="bi bi-calendar"></i>
                        <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date())%>
                    </span>
                </div>

                <div class="row g-4 mb-5">
                    <div class="col-xl-3 col-lg-6">
                        <div class="stat-card text-center shadow-sm">
                            <i class="bi bi-people-fill stat-icon text-primary"></i>
                            <h6 class="text-muted">Người dùng</h6>
                            <div class="stat-number text-primary">${soUser}</div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-lg-6">
                        <div class="stat-card text-center shadow-sm">
                            <i class="bi bi-box-seam stat-icon text-success"></i>
                            <h6 class="text-muted">Sản phẩm</h6>
                            <div class="stat-number text-success">${soSP}</div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-lg-6">
                        <div class="stat-card text-center shadow-sm">
                            <i class="bi bi-receipt stat-icon text-warning"></i>
                            <h6 class="text-muted">Đơn hàng</h6>
                            <div class="stat-number text-warning">${soDon}</div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-lg-6">
                        <div class="stat-card text-center shadow-sm">
                            <i class="bi bi-cash-stack stat-icon text-danger"></i>
                            <h6 class="text-muted">Doanh thu</h6>
                            <div class="stat-number text-danger">
                                <%= nf.format(doanhThu != null ? doanhThu : 0) %>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mt-4">
                    <div class="col-lg-8">
                        <div class="card p-4 shadow-sm rounded-4">
                            <h5 class="fw-bold mb-3">
                                <i class="bi bi-bar-chart"></i> Tổng quan đơn hàng
                            </h5>
                            <div style="position: relative; height: 420px; width: 100%;">
                                <canvas id="orderStatusChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-4">
                        <div class="card p-4 shadow-sm rounded-4" style="height: 510px;">
                            <h5 class="fw-bold mb-3">
                                <i class="bi bi-clock-history"></i> Hoạt động gần đây
                            </h5>

                            <div style="height: calc(510px - 65px); overflow-y: auto;">
                                <ul class="list-group list-group-flush">
                                    <%
                                        List<NhatKy> listLog = (List<NhatKy>) request.getAttribute("listLog");
                                        if (listLog != null && !listLog.isEmpty()) {
                                            for (NhatKy log : listLog) {
                                    %>
                                    <li class="list-group-item">
                                        <div><strong><%= log.getTenNguoiDung() %></strong></div>
                                        <div class="small text-muted">
                                            <%= log.getHanhDong() %> (<%= log.getDoiTuong() %>)
                                        </div>
                                        <small class="text-muted"><%= log.getThoiGian() %></small>
                                    </li>
                                    <%
                                            }
                                        } else {
                                    %>
                                    <li class="list-group-item text-center text-muted py-4">
                                        Chưa có hoạt động gần đây
                                    </li>
                                    <% } %>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card p-4 shadow-sm rounded-4">
                            <h5 class="fw-bold mb-3">
                                <i class="bi bi-clock-history"></i> Đơn hàng gần đây
                            </h5>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
                                    <thead>
                                        <tr>
                                            <th>Mã</th>
                                            <th>Khách</th>
                                            <th>Tiền</th>
                                            <th>Trạng thái</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            List<DonHang> listDon = (List<DonHang>) request.getAttribute("listDon");
                                            if (listDon != null && !listDon.isEmpty()) {
                                                for (DonHang d : listDon) {
                                                    String trangThai = d.getTrangThai();
                                                    String trangThaiHoan = d.getTrangThaiHoan();
                                                    String statusClass = "bg-secondary";
                                                    String statusText = trangThai;

                                                    if ("ChoDuyet".equals(trangThaiHoan)) {
                                                        statusClass = "bg-warning";
                                                        statusText = "Chờ duyệt hoàn";
                                                    } else if ("DaDuyet".equals(trangThaiHoan)) {
                                                        statusClass = "bg-success";
                                                        statusText = "Đã hoàn";
                                                    } else if ("TuChoi".equals(trangThaiHoan)) {
                                                        statusClass = "bg-danger";
                                                        statusText = "Từ chối hoàn";
                                                    } else {
                                                        switch (trangThai) {
                                                            case "ChoXacNhan":
                                                                statusClass = "bg-warning text-dark";
                                                                statusText = "Chờ xác nhận";
                                                                break;
                                                            case "DaXacNhan":
                                                                statusClass = "bg-primary";
                                                                statusText = "Đã xác nhận";
                                                                break;
                                                            case "DangGiao":
                                                                statusClass = "bg-info";
                                                                statusText = "Đang giao";
                                                                break;
                                                            case "DaGiao":
                                                                statusClass = "bg-success";
                                                                statusText = "Đã giao";
                                                                break;
                                                            case "DaHuy":
                                                                statusClass = "bg-danger";
                                                                statusText = "Đã hủy";
                                                                break;
                                                            default:
                                                                statusClass = "bg-secondary";
                                                                statusText = trangThai;
                                                        }
                                                    }
                                        %>
                                        <tr>
                                            <td><strong>#<%= d.getMaDonHang() %></strong></td>
                                            <td><%= d.getTenNguoiNhan() != null ? d.getTenNguoiNhan() : "Không có" %></td>
                                            <td class="text-danger fw-semibold"><%= nf.format(d.getTongTien()) %></td>
                                            <td>
                                                <span class="badge <%= statusClass %>">
                                                    <%= statusText %>
                                                </span>
                                            </td>
                                        </tr>
                                        <%
                                                }
                                            } else {
                                        %>
                                        <tr>
                                            <td colspan="4" class="text-center py-4 text-muted">Chưa có đơn hàng nào</td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            const dataMap = {
                ChoXacNhan: <%= request.getAttribute("trangThaiDon") != null ? 
                                ((java.util.Map)request.getAttribute("trangThaiDon")).getOrDefault("ChoXacNhan", 0) : 0 %>,
                DaXacNhan: <%= request.getAttribute("trangThaiDon") != null ? 
                                ((java.util.Map)request.getAttribute("trangThaiDon")).getOrDefault("DaXacNhan", 0) : 0 %>,
                DangGiao: <%= request.getAttribute("trangThaiDon") != null ? 
                                ((java.util.Map)request.getAttribute("trangThaiDon")).getOrDefault("DangGiao", 0) : 0 %>,
                DaGiao: <%= request.getAttribute("trangThaiDon") != null ? 
                                ((java.util.Map)request.getAttribute("trangThaiDon")).getOrDefault("DaGiao", 0) : 0 %>,
                DaHuy: <%= request.getAttribute("trangThaiDon") != null ? 
                                ((java.util.Map)request.getAttribute("trangThaiDon")).getOrDefault("DaHuy", 0) : 0 %>,
                ChoDuyet: <%= request.getAttribute("trangThaiDon") != null ? 
                                ((java.util.Map)request.getAttribute("trangThaiDon")).getOrDefault("ChoDuyet", 0) : 0 %>,
                DaDuyet: <%= request.getAttribute("trangThaiDon") != null ? 
                                ((java.util.Map)request.getAttribute("trangThaiDon")).getOrDefault("DaDuyet", 0) : 0 %>,
                TuChoi: <%= request.getAttribute("trangThaiDon") != null ? 
                                ((java.util.Map)request.getAttribute("trangThaiDon")).getOrDefault("TuChoi", 0) : 0 %>
            };

            console.log("Dữ liệu biểu đồ:", dataMap);

            new Chart(document.getElementById('orderStatusChart'), {
                type: 'doughnut',
                data: {
                    labels: [
                        'Chờ xác nhận', 'Đã xác nhận', 'Đang giao', 'Đã giao',
                        'Đã hủy', 'Yêu cầu hoàn', 'Đã hoàn', 'Từ chối hoàn'
                    ],
                    datasets: [{
                            data: [
                                dataMap.ChoXacNhan, dataMap.DaXacNhan, dataMap.DangGiao, dataMap.DaGiao,
                                dataMap.DaHuy, dataMap.ChoDuyet, dataMap.DaDuyet, dataMap.TuChoi
                            ],
                            backgroundColor: [
                                '#ffc107', '#0d6efd', '#0dcaf0', '#198754',
                                '#dc3545', '#fd7e14', '#20c997', '#6c757d'
                            ],
                            borderColor: '#fff',
                            borderWidth: 3
                        }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'right',
                            labels: {
                                boxWidth: 14,
                                padding: 15,
                                font: {size: 13}
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    const value = context.raw || 0;
                                    const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                    const percent = total > 0 ? Math.round((value / total) * 100) : 0;

                                    return context.label + ": " + value + " đơn (" + percent + "%)";
                                }
                            }
                        }
                    }
                }
            });
        </script>
    </body>
</html>