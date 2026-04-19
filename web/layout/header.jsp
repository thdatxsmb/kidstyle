<%-- 
    Document   : header
    Created on : Feb 25, 2026, 2:41:07 PM
    Author     : LEGION 5
--%>

<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.User"%>
<%@page import="Model.GioHangDAO"%>
<%@page import="Model.HoTroDAO"%>

<%
    User loggedUser = (User) session.getAttribute("user");

    int soLuongGio = 0;

    if (loggedUser != null) {

        GioHangDAO dao = new GioHangDAO();
        soLuongGio = dao.demSoLuongGioHang(loggedUser.getMaNguoiDung());

    }
%>

<%
    List<Model.HoTro> dsHoTro = null;

    if (loggedUser != null) {
        try {
            HoTroDAO dao = new HoTroDAO();
            dsHoTro = dao.getByEmail(loggedUser.getEmail());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">

<nav class="navbar navbar-expand-lg navbar-light kid-navbar fixed-top">

    <div class="container-fluid px-4">

        <button class="navbar-toggler" type="button" id="sidebarToggler">
            <span class="navbar-toggler-icon"></span>
        </button>

        <a class="navbar-brand fw-bold" href="User_HomeController">
            🧸 KidStyle
        </a>

        <div class="collapse navbar-collapse">

            <ul class="navbar-nav me-auto">

                <li class="nav-item">
                    <a class="nav-link active" href="User_HomeController">
                        <i class="bi bi-house-door"></i> Trang chủ
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="User_DSSPController">
                        <i class="bi bi-bag-heart"></i> Sản phẩm
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="User_KhuyenMaiController">
                        <i class="bi bi-percent"></i> Khuyến mãi
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="javascript:void(0)" onclick="openSupport()">
                        <i class="bi bi-chat-dots"></i> Hỗ trợ
                    </a>
                </li>

            </ul>

            <form class="d-flex me-4"
                  style="max-width:320px;"
                  action="User_DSSPController"
                  method="get">

                <input class="form-control rounded-pill"
                       type="search"
                       name="keyword"
                       value="${param.keyword}"
                       placeholder="🔎 Tìm đồ cho bé...">

                <button class="btn btn-pink rounded-pill ms-2"
                        type="submit">

                    <i class="bi bi-search"></i>

                </button>

            </form>

            <ul class="navbar-nav align-items-center">

                <li class="nav-item">
                    <a class="nav-link position-relative" href="User_GioHangController">

                        <i class="bi bi-cart3 fs-4"></i>

                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger small">
                            <%=soLuongGio%>
                        </span>

                    </a>
                </li>


                <% if (loggedUser != null) {%>
                <li class="nav-item dropdown ms-3">
                    <a class="nav-link dropdown-toggle d-flex align-items-center"
                       href="javascript:void(0)"
                       data-bs-toggle="dropdown"
                       role="button"
                       aria-expanded="false">
                        <i class="bi bi-person-circle fs-4 me-2"></i>
                        <%= loggedUser.getHoTen()%>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li>
                            <a class="dropdown-item" href="User_HoSoController">
                                <i class="bi bi-person me-2 icon-dd"></i> Hồ sơ
                            </a>
                        </li>

                        <li>
                            <a class="dropdown-item" href="User_DonHangController">
                                <i class="bi bi-receipt me-2 icon-dd"></i> Đơn hàng
                            </a>
                        </li>

                        <li><hr class="dropdown-divider"></li>

                        <li>
                            <a class="dropdown-item text-danger" href="Logout">
                                <i class="bi bi-box-arrow-right me-2"></i> Đăng xuất
                            </a>
                        </li>
                    </ul>
                </li>
                <% } else { %>

                <li class="nav-item ms-3">
                    <a class="btn btn-outline-primary rounded-pill px-3 me-2"
                       href="Login.jsp">
                        <i class="bi bi-box-arrow-in-right"></i> Đăng nhập
                    </a>
                </li>

                <li class="nav-item">
                    <a class="btn btn-pink rounded-pill px-3"
                       href="DangKy.jsp">
                        <i class="bi bi-person-plus"></i> Đăng ký
                    </a>
                </li>

                <% }%>

            </ul>

        </div>
    </div>
</nav>

<div class="modal fade" id="supportModal">
    <div class="modal-dialog modal-xl modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header">
                <h5>
                    <i class="bi bi-headset me-2"></i> Hỗ trợ khách hàng
                </h5>
                <button class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body" style="max-height:70vh; overflow-y:auto;">

                <% if (loggedUser != null) {%>


                <div class="row">

                    <div class="col-md-5 border-end">
                        <h6 class="fw-bold mb-3">
                            <i class="bi bi-chat-dots me-2"></i>Gửi yêu cầu
                        </h6>
                        <form action="User_HoTroController" method="post">
                            <input type="hidden" name="source" value="modal">
                            <div class="mb-2 input-group">
                                <span class="input-group-text"><i class="bi bi-person"></i></span>
                                <input type="text" name="ten" class="form-control"
                                       value="<%= loggedUser.getHoTen()%>" readonly>
                            </div>

                            <div class="mb-2 input-group">
                                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                <input type="email" name="email" class="form-control"
                                       value="<%= loggedUser.getEmail()%>" readonly>
                            </div>

                            <div class="mb-2 input-group">
                                <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                                <input type="text" name="sdt" class="form-control"
                                       value="<%= loggedUser.getSoDienThoai()%>" readonly>
                            </div>

                            <div class="mb-3">
                                <textarea name="noiDung" class="form-control"
                                          placeholder="💬 Nhập nội dung hỗ trợ..." required></textarea>
                            </div>

                            <button class="btn btn-primary w-100">
                                <i class="bi bi-send"></i> Gửi yêu cầu
                            </button>
                        </form>
                    </div>

                    <div class="col-md-7">
                        <h6 class="fw-bold mb-3">
                            <i class="bi bi-clock-history me-1"></i> Lịch sử hỗ trợ
                        </h6>
                        <div style="max-height:350px; overflow-y:auto;">
                            <table class="table table-hover table-bordered">

                                <thead class="table-light text-center">
                                    <tr>
                                        <th>Nội dung</th>
                                        <th>Ngày</th>
                                        <th>Trạng thái</th>
                                        <th>Phản hồi</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <%
                                        List<Model.HoTro> ds = dsHoTro;

                                        if (ds != null && !ds.isEmpty()) {
                                            for (Model.HoTro ht : ds) {
                                    %>

                                    <tr>
                                        <td><%= ht.getNoiDung()%></td>
                                        <td><%= ht.getNgayGui()%></td>

                                        <td class="text-center">
                                            <% if ("ChoXuLy".equals(ht.getTrangThai())) { %>
                                            <span class="status waiting">Chờ</span>
                                            <% } else { %>
                                            <span class="status done">Đã xử lý</span>
                                            <% }%>
                                        </td>

                                        <td>
                                            <%= ht.getPhanHoi() != null ? ht.getPhanHoi() : "<i class='text-muted'>Chưa có</i>"%>
                                        </td>
                                    </tr>

                                    <% }
                                    } else { %>

                                    <tr>
                                        <td colspan="4" class="text-center text-muted py-3">
                                            Chưa có yêu cầu nào
                                        </td>
                                    </tr>

                                    <% } %>
                                </tbody>

                            </table>
                        </div>
                    </div>

                </div>

                <% }%>
            </div>
        </div>
    </div>
</div>

<script>
    function openSupport() {
        let isLogin = <%= (loggedUser != null)%>;

        if (isLogin) {

            document.querySelectorAll('.modal-backdrop').forEach(e => e.remove());
            document.body.classList.remove('modal-open');

            new bootstrap.Modal(document.getElementById("supportModal")).show();

        } else {
            window.location.href = "Login.jsp";
        }
    }
</script>

<%@ include file="../layout/chatbox.jsp" %>