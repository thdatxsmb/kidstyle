<%-- 
    Document   : admin_QuanLyDonHang
    Created on : Mar 17, 2026, 3:27:09 PM
    Author     : LEGION 5
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, Model.DonHang"%>
<%@page import="Model.User"%>

<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"QuanTri".equals(admin.getVaiTro())) {
        response.sendRedirect("Login.jsp");
        return;
    }

    List<DonHang> list = (List<DonHang>) request.getAttribute("listDonHang");

    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("success");
    session.removeAttribute("error");
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý đơn hàng</title>

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

                    <h4 class="fw-bold">
                        <i class="bi bi-receipt text-primary me-2"></i>
                        Quản lý đơn hàng
                    </h4>

                    <div class="d-flex gap-2">

                        <div class="input-group" style="width: 320px;">
                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                            <input type="text" id="searchInput" class="form-control"
                                   placeholder="Tìm theo ID, tên người nhận, SDT..."
                                   onkeyup="searchTable()">
                        </div>

                        <select id="filterStatus" class="form-select" style="width:200px" onchange="filterStatus()">
                            <option value="">Tất cả</option>

                            <optgroup label="Trạng thái đơn">
                                <option value="ChoXacNhan">Chờ xác nhận</option>
                                <option value="DaXacNhan">Đã xác nhận</option>
                                <option value="DangGiao">Đang giao</option>
                                <option value="DaGiao">Đã giao</option>
                                <option value="DaHuy">Đã hủy</option>
                            </optgroup>

                            <optgroup label="Hoàn đơn">
                                <option value="ChoDuyet">Yêu cầu hoàn</option>
                                <option value="DaDuyet">Đã hoàn</option>
                                <option value="TuChoi">Từ chối hoàn</option>
                            </optgroup>
                        </select>

                        <a href="Admin_QuanLyDonHangController" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-clockwise"></i> Tải lại
                        </a>

                    </div>
                </div>

                <% if (success != null) { %>
                <div class="alert alert-success"><%= success %></div>
                <% } %>

                <% if (error != null) { %>
                <div class="alert alert-danger"><%= error %></div>
                <% } %>

                <div class="card shadow-sm">
                    <div class="table-responsive">

                        <table class="table table-hover align-middle mb-0" id="orderTable">

                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Khách</th>
                                    <th>Ngày</th>
                                    <th>Tổng tiền</th>
                                    <th>Trạng thái</th>
                                    <th>Duyệt</th>
                                    <th>Hoàn đơn</th>
                                    <th class="text-center">Xem chi tiết</th>
                                </tr>
                            </thead>

                            <tbody>
                                <% if (list != null && !list.isEmpty()) {
                                    for (DonHang dh : list) {

                                        String tt = dh.getTrangThai();
                                        String hoan = dh.getTrangThaiHoan();

                                        String statusText = tt;
                                        String statusClass = "status-pending";

                                        if ("ChoXacNhan".equals(tt)) {
                                            statusText = "Chờ xác nhận";
                                            statusClass = "status-pending";

                                        } else if ("DaXacNhan".equals(tt)) {
                                            statusText = "Đã xác nhận";
                                            statusClass = "status-confirm";

                                        } else if ("DangGiao".equals(tt)) {
                                            statusText = "Đang giao";
                                            statusClass = "status-shipping";

                                        } else if ("DaGiao".equals(tt)) {
                                            statusText = "Đã giao";
                                            statusClass = "status-done";

                                        } else if ("DaHuy".equals(tt)) {
                                            statusText = "Đã hủy";
                                            statusClass = "status-cancel";
                                        }

                                        if ("ChoDuyet".equals(hoan)) {
                                            statusText = "Yêu cầu hoàn";
                                            statusClass = "status-return";

                                        } else if ("DaDuyet".equals(hoan)) {
                                            statusText = "Đã hoàn";
                                            statusClass = "status-return-ok";

                                        } else if ("TuChoi".equals(hoan)) {
                                            statusText = "Từ chối hoàn";
                                            statusClass = "status-return-cancel";
                                        }

                                %>

                                <tr 
                                    data-status="<%= tt %>"
                                    data-hoan="<%= hoan %>"
                                    data-search="<%= 
                                        ("#" + dh.getMaDonHang() + " " 
                                        + dh.getTenKhach() + " "
                                        + dh.getTenNguoiNhan() + " "
                                        + dh.getSoDienThoaiNhan()
                                        ).toLowerCase() 
                                    %>">

                                    <td class="fw-semibold">#<%= dh.getMaDonHang() %></td>

                                    <td>
                                        <b><%= dh.getTenKhach() %></b><br>
                                        <small class="text-muted">
                                            <%= dh.getTenNguoiNhan() %> - <%= dh.getSoDienThoaiNhan() %>
                                        </small>
                                    </td>

                                    <td><%= dh.getNgayDatHang() %></td>

                                    <td class="text-success fw-bold">
                                        <%= String.format("%,.0f", dh.getTongTien()) %> đ
                                    </td>

                                    <td>
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
                                    </td>

                                    <td>
                                        <form method="post" action="Admin_QuanLyDonHangController" class="d-flex gap-2">

                                            <input type="hidden" name="action" value="updateStatus">
                                            <input type="hidden" name="maDonHang" value="<%= dh.getMaDonHang() %>">

                                            <select name="trangThai" class="form-select form-select-sm">

                                                <% if ("ChoXacNhan".equals(tt)) { %>
                                                <option value="ChoXacNhan" selected>Chờ xác nhận</option>
                                                <option value="DaXacNhan">Duyệt đơn</option>
                                                <option value="DaHuy">Hủy đơn</option>

                                                <% } else if ("DaXacNhan".equals(tt)) { %>
                                                <option value="DaXacNhan" selected>Đã xác nhận</option>
                                                <option value="DangGiao">Bắt đầu giao</option>
                                                <option value="DaHuy">Hủy đơn</option>

                                                <% } else if ("DangGiao".equals(tt)) { %>
                                                <option value="DangGiao" selected>Đang giao</option>
                                                <option value="DaGiao">Hoàn thành</option>

                                                <% } else if ("DaGiao".equals(tt)) { %>
                                                <option value="DaGiao" selected>Đã giao</option>

                                                <% } else if ("DaHuy".equals(tt)) { %>
                                                <option value="DaHuy" selected>Đã hủy</option>
                                                <% } %>

                                            </select>

                                            <% if (!"DaGiao".equals(tt) && !"DaHuy".equals(tt)) { %>
                                            <button class="btn btn-sm btn-success">✔</button>
                                            <% } %>

                                        </form>
                                    </td>

                                    <td>
                                        <div class="d-flex flex-column align-items-center gap-1">

                                            <% if (hoan == null) { %>

                                            <span class="badge bg-secondary">Không hoàn</span>

                                            <% } else if ("ChoDuyet".equals(hoan)) { %>

                                            <span class="badge bg-warning text-dark">
                                                Yêu cầu hoàn
                                            </span>

                                            <small class="text-muted text-center">
                                                <%= dh.getLyDo() %>
                                            </small>

                                            <div class="d-flex gap-1">

                                                <form method="post" action="Admin_QuanLyDonHangController">
                                                    <input type="hidden" name="action" value="duyetHoan">
                                                    <input type="hidden" name="maDonHang" value="<%= dh.getMaDonHang() %>">
                                                    <button class="btn btn-sm btn-success px-2">✔</button>
                                                </form>

                                                <form method="post" action="Admin_QuanLyDonHangController">
                                                    <input type="hidden" name="action" value="tuChoiHoan">
                                                    <input type="hidden" name="maDonHang" value="<%= dh.getMaDonHang() %>">
                                                    <button class="btn btn-sm btn-danger px-2">✖</button>
                                                </form>

                                            </div>

                                            <% } else if ("DaDuyet".equals(hoan)) { %>

                                            <span class="badge bg-success">Đã hoàn</span>

                                            <% } else if ("TuChoi".equals(hoan)) { %>

                                            <span class="badge bg-danger">Từ chối</span>

                                            <% } %>

                                        </div>
                                    </td>

                                    <td class="text-center">
                                        <a href="Admin_QuanLyDonHangController?action=detail&id=<%= dh.getMaDonHang() %>"
                                           class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                    </td>

                                </tr>

                                <% }} else { %>

                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        Không có đơn hàng
                                    </td>
                                </tr>

                                <% } %>
                            </tbody>

                        </table>

                    </div>
                </div>

            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            function searchTable() {
                let val = document.getElementById("searchInput").value.toLowerCase();

                document.querySelectorAll("#orderTable tbody tr").forEach(row => {
                    let text = row.getAttribute("data-search");
                    row.style.display = text.includes(val) ? "" : "none";
                });
            }

            function filterStatus() {
                let val = document.getElementById("filterStatus").value;

                document.querySelectorAll("#orderTable tbody tr").forEach(row => {

                    let status = row.getAttribute("data-status"); // trạng thái đơn
                    let hoan = row.getAttribute("data-hoan");     // trạng thái hoàn

                    let show = false;

                    if (val === "") {
                        show = true;
                    }
                    else if (val === status) {
                        show = true;
                    }
                    else if (val === hoan) {
                        show = true;
                    }

                    row.style.display = show ? "" : "none";
                });
            }
        </script>

    </body>
</html>
