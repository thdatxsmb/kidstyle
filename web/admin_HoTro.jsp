<%-- 
    Document   : admin_HoTro
    Created on : Apr 17, 2026, 12:11:31 PM
    Author     : LEGION 5
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.HoTro"%>
<%@page import="java.util.*"%>
<%@page import="Model.User"%>
<%@page import="java.text.SimpleDateFormat"%>

<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"QuanTri".equals(admin.getVaiTro())) {
        response.sendRedirect("Login.jsp");
        return;
    }

    List<HoTro> list = (List<HoTro>) request.getAttribute("listHoTro");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Hỗ trợ khách hàng</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home_admin.css">
    </head>

    <body>

        <%@ include file="../layout/header_admin.jsp" %>
        <%@ include file="../layout/sidebar_admin.jsp" %>

        <div class="main-content" id="mainContent">
            <div class="container-fluid py-4">

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4 class="fw-bold">
                        <i class="bi bi-chat-dots text-primary me-2"></i>
                        Yêu cầu hỗ trợ
                    </h4>

                    <div class="d-flex align-items-center gap-2">
                        <div class="input-group" style="width: 320px;">
                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                            <input type="text" id="searchInput" class="form-control"
                                   placeholder="Tìm theo ID, họ tên, email, SĐT..."
                                   onkeyup="searchTable()">
                        </div>
                        <a href="Admin_HoTroController" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-clockwise"></i> Tải lại
                        </a>
                    </div>

                </div>

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

                <div class="card shadow-sm">
                    <div class="card-body p-0">
                        <div class="table-responsive">

                            <table class="table table-hover align-middle mb-0" id="hoTroTable">

                                <thead class="table-dark text-center">
                                    <tr>
                                        <th>ID</th>
                                        <th>Người gửi</th>
                                        <th>Liên hệ</th>
                                        <th>Nội dung</th>
                                        <th>Ngày gửi</th>
                                        <th>Trạng thái</th>
                                        <th>Xử lý</th>
                                        <th>Phản hồi</th>
                                    </tr>
                                </thead>

                                <tbody>

                                    <% if (list != null && !list.isEmpty()) {
                                            for (HoTro ht : list) {

                                                String badge = "";
                                                String text = "";

                                                if ("ChoXuLy".equals(ht.getTrangThai())) {
                                                    badge = "bg-warning text-dark";
                                                    text = "Chờ xử lý";
                                                } else {
                                                    badge = "bg-success";
                                                    text = "Đã xử lý";
                                                }
                                    %>

                                    <tr data-search="<%=("#" + ht.getMaHoTro() + " "
                                            + ht.getTenNguoiGui() + " "
                                            + ht.getEmail() + " "
                                            + ht.getSoDienThoai() + " "
                                            + ht.getNoiDung() + " "
                                            + (ht.getPhanHoi() != null ? ht.getPhanHoi() : "")).toLowerCase()%>">
                                        
                                        <td class="text-center fw-semibold">
                                            #<%= ht.getMaHoTro()%>
                                        </td>

                                        <td class="fw-semibold">
                                            <%= ht.getTenNguoiGui()%>
                                        </td>

                                        <td class="text-muted">
                                            <i class="bi bi-envelope"></i> <%= ht.getEmail()%><br>
                                            <i class="bi bi-phone"></i> <%= ht.getSoDienThoai()%>
                                        </td>

                                        <td style="max-width:250px;">
                                            <%= ht.getNoiDung()%>
                                        </td>

                                        <td class="text-muted text-center">
                                            <i class="bi bi-clock"></i>
                                            <%= sdf.format(ht.getNgayGui())%>
                                        </td>

                                        <td class="text-center">
                                            <span class="badge <%= badge%>">
                                                <%= text%>
                                            </span>
                                        </td>

                                        <td class="text-center">

                                            <% if ("ChoXuLy".equals(ht.getTrangThai())) {%>
                                            <button class="btn btn-sm btn-primary"
                                                    onclick="openModal('<%= ht.getMaHoTro()%>')">
                                                <i class="bi bi-reply"></i>
                                            </button>
                                            <% } else { %>
                                            <span class="text-success fw-bold">✔</span>
                                            <% }%>

                                        </td>

                                        <td>
                                            <%= ht.getPhanHoi() != null ? ht.getPhanHoi() : "<span class='text-muted'>---</span>"%>
                                        </td>

                                    </tr>

                                    <% }
                                    } else { %>

                                    <tr>
                                        <td colspan="7" class="text-center py-5 text-muted">
                                            <i class="bi bi-inbox fs-3"></i><br>
                                            Không có yêu cầu hỗ trợ
                                        </td>
                                    </tr>

                                    <% }%>

                                </tbody>

                            </table>

                        </div>
                    </div>
                </div>

            </div>
        </div>

        <div class="modal fade" id="replyModal">
            <div class="modal-dialog">
                <div class="modal-content">

                    <form action="Admin_HoTroController" method="post">
                        <input type="hidden" name="action" value="reply">
                        <input type="hidden" name="maHoTro" id="maHoTro">

                        <div class="modal-header">
                            <h5 class="modal-title">Phản hồi khách hàng</h5>
                        </div>

                        <div class="modal-body">
                            <label>Nội dung phản hồi:</label>
                            <textarea name="phanHoi" class="form-control" required></textarea>
                        </div>

                        <div class="modal-footer">
                            <button class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-success">
                                <i class="bi bi-send"></i> Gửi
                            </button>
                        </div>

                    </form>

                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            function openModal(maHoTro) {
                document.getElementById("maHoTro").value = maHoTro;
                new bootstrap.Modal(document.getElementById("replyModal")).show();
            }

            function searchTable() {
                const input = document.getElementById("searchInput").value.toLowerCase().trim();
                const rows = document.querySelectorAll("#hoTroTable tbody tr");

                rows.forEach(row => {
                    if (row.cells.length < 2)
                        return;

                    const searchText = row.getAttribute("data-search")
                            ? row.getAttribute("data-search").toLowerCase()
                            : "";

                    row.style.display = searchText.includes(input) ? "" : "none";
                });
            }
        </script>
    </body>
</html>