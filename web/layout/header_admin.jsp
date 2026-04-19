<%-- 
    Document   : header_admin
    Created on : Mar 15, 2026, 5:30:06 PM
    Author     : LEGION 5
--%>
<%@page import="Model.ChatBoxDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.User"%>
<%@page import="Model.HoTroDAO"%>

<%
    int soYeuCau = 0;
    try {
        HoTroDAO dao = new HoTroDAO();
        soYeuCau = dao.countChuaXuLy();
    } catch (Exception e) {
        e.printStackTrace();
    }

    int soChat = 0;
    try {
        ChatBoxDAO dao = new ChatBoxDAO();
        soChat = dao.countUserChuaTraLoi();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<span class="badge bg-danger">
    <%= soYeuCau%>
</span>
<%
    User user = (User) session.getAttribute("user");
%>

<header class="navbar navbar-expand-lg">
    <div class="container-fluid d-flex align-items-center px-3">

        <div class="d-flex align-items-center gap-2">
            <button class="btn btn-link text-white p-0 me-2" id="sidebarToggler" type="button">
                <i class="bi bi-list fs-3"></i>
            </button>
            <a class="navbar-brand fw-bold d-flex align-items-center gap-2" href="Admin_HomeController">
                <i class="bi bi-shield-lock-fill fs-3"></i>
                ADMIN KIDSTYLE
            </a>
        </div>

        <div class="flex-grow-1 mx-4 position-relative" style="max-width: 580px;">
            <div class="input-group rounded-pill overflow-hidden shadow-sm">
                <input type="text" id="headerSearch"
                       class="form-control border-0 ps-4"
                       placeholder="Tìm kiếm nhanh chức năng ..."
                       onkeyup="searchHeaderFunction()">
                <button class="btn btn-light border-0 px-4" type="button" onclick="clearHeaderSearch()">
                    <i class="bi bi-search text-muted"></i>
                </button>
            </div>

            <div id="searchResults" class="list-group position-absolute w-100 mt-1 shadow" 
                 style="display: none; max-height: 280px; overflow-y: auto; z-index: 1050; border-radius: 12px;">
            </div>
        </div>

        <div class="d-flex align-items-center gap-4 ms-auto">
            <div class="position-relative">
                <div class="position-relative">
                    <a href="Admin_HoTroController?action=list">
                        <i class="bi bi-bell fs-4 text-white"></i>
                    </a>
                </div>
                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger px-2">
                    <%= soYeuCau%>
                </span>
            </div>

            <div class="position-relative">
                <a href="Admin_ChatController">
                    <i class="bi bi-chat-dots fs-4 text-white"></i>
                </a>

                <% if (soChat > 0) {%>
                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-warning text-dark px-2">
                    <%= soChat%>
                </span>
                <% }%>
            </div>

            <div class="dropdown">
                <a class="d-flex align-items-center text-white text-decoration-none dropdown-toggle" 
                   href="#" data-bs-toggle="dropdown">
                    <i class="bi bi-person-lock fs-4 me-2 text-white"></i>
                    <span class="fw-medium d-none d-lg-inline">
                        <%= (user != null) ? user.getHoTen() : "Admin"%>
                    </span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 mt-2">
                    <li>
                        <a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#profileModal">
                            <i class="bi bi-person me-2"></i>Hồ sơ
                        </a>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item text-danger" href="Logout">
                            <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất</a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</header>

<div class="modal fade" id="profileModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">

            <%
                String ps = (String) session.getAttribute("profile_success");
                String pe = (String) session.getAttribute("profile_error");

                session.removeAttribute("profile_success");
                session.removeAttribute("profile_error");

                boolean showModal = (ps != null || pe != null);
            %>

            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-person-circle me-1"></i> Thông tin tài khoản </h5>
            </div>

            <% if (ps != null) {%>
            <div class="alert alert-success alert-dismissible fade show mx-3 mb-0">
                <i class="bi bi-check-circle me-1"></i>
                <%= ps%>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>

            <% if (pe != null) {%>
            <div class="alert alert-danger alert-dismissible fade show mx-3 mb-0">
                <i class="bi bi-exclamation-triangle me-1"></i>
                <%= pe%>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% }%>

            <div class="modal-body">

                <ul class="nav nav-tabs" id="profileTab" role="tablist">
                    <li class="nav-item">
                        <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#infoTab">
                            <i class="bi bi-person me-1"></i> Hồ sơ
                        </button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#passwordTab">
                            <i class="bi bi-key me-1"></i> Mật khẩu
                        </button>
                    </li>
                </ul>

                <div class="tab-content mt-3">

                    <div class="tab-pane fade show active" id="infoTab">
                        <form action="Admin_HoSoController" method="post">
                            <input type="hidden" name="action" value="updateProfile">

                            <div class="mb-3">
                                <label class="form-label fw-medium">Họ tên</label>
                                <input type="text" name="hoTen" class="form-control"
                                       value="<%= user != null ? user.getHoTen() : ""%>" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-medium">Email</label>
                                <input type="email" name="email" class="form-control"
                                       value="<%= user != null ? user.getEmail() : ""%>"
                                       required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-medium">Số điện thoại</label>
                                <input type="text" name="soDienThoai" class="form-control"
                                       value="<%= user != null ? user.getSoDienThoai() : ""%>"
                                       maxlength="10"
                                       required
                                       pattern="^(03|05|07|08|09)[0-9]{8}$"
                                       oninvalid="this.setCustomValidity('SĐT phải 10 số và bắt đầu bằng 03,05,07,08,09')"
                                       oninput="this.setCustomValidity('')">
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-medium">Địa chỉ</label>
                                <input type="text" name="diaChi" class="form-control"
                                       value="<%= user != null ? user.getDiaChi() : ""%>"
                                       required
                                       oninvalid="this.setCustomValidity('Vui lòng nhập địa chỉ')"
                                       oninput="this.setCustomValidity('')">
                            </div>

                            <div class="mt-4 d-flex justify-content-end gap-2">
                                <button type="button" class="btn btn-light" data-bs-dismiss="modal">
                                    Hủy
                                </button>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-save me-2"></i>Lưu thay đổi
                                </button>
                            </div>
                        </form>
                    </div>

                    <div class="tab-pane fade" id="passwordTab">
                        <form id="profileForm" action="Admin_HoSoController" method="post">
                            <input type="hidden" name="action" value="changePassword">

                            <div class="mb-3">
                                <label class="form-label fw-medium">Mật khẩu cũ</label>
                                <div class="input-group">
                                    <input type="password" id="oldPassword" name="oldPassword" class="form-control" required>
                                    <span class="input-group-text toggle-pass" data-target="oldPassword">
                                        <i class="bi bi-eye-slash"></i>
                                    </span>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-medium">Mật khẩu mới</label>
                                <div class="input-group">
                                    <input type="password" id="newPassword" name="newPassword" class="form-control" required>
                                    <span class="input-group-text toggle-pass" data-target="newPassword">
                                        <i class="bi bi-eye-slash"></i>
                                    </span>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-medium">Xác nhận mật khẩu</label>
                                <div class="input-group">
                                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
                                    <span class="input-group-text toggle-pass" data-target="confirmPassword">
                                        <i class="bi bi-eye-slash"></i>
                                    </span>
                                </div>
                            </div>

                            <div class="d-flex justify-content-end gap-2">
                                <button type="button" class="btn btn-light" data-bs-dismiss="modal">
                                    Hủy
                                </button>
                                <button type="submit" class="btn btn-danger">
                                    <i class="bi bi-arrow-clockwise"></i> Đổi mật khẩu
                                </button>
                            </div>
                        </form>
                    </div>

                </div>
            </div>

        </div>
    </div>
</div>

<script>
    const contextPath = "${pageContext.request.contextPath}";

    window.onload = function () {
        const show = <%= showModal%>;

        if (show) {
            new bootstrap.Modal(document.getElementById("profileModal")).show();
        }
    };
</script>

<script>
    document.querySelectorAll(".toggle-pass").forEach(btn => {
        btn.addEventListener("click", function () {
            const targetId = this.getAttribute("data-target");
            const input = document.getElementById(targetId);
            const icon = this.querySelector("i");

            if (input.type === "password") {
                input.type = "text";
                icon.classList.remove("bi-eye-slash");
                icon.classList.add("bi-eye");
            } else {
                input.type = "password";
                icon.classList.remove("bi-eye");
                icon.classList.add("bi-eye-slash");
            }
        });
    });
</script>

<script>
    const menuItems = [
        {name: "Bảng tổng quan", url: contextPath + "/Admin_HomeController", icon: "bi-speedometer2"},
        {name: "Người dùng", url: contextPath + "/Admin_QuanLyNguoiDungController", icon: "bi-people"},
        {name: "Danh mục sản phẩm", url: contextPath + "/Admin_QuanLyDanhMucController", icon: "bi-tags"},
        {name: "Sản phẩm", url: contextPath + "/Admin_QuanLySanPhamController", icon: "bi-box-seam"},
        {name: "Giỏ hàng", url: contextPath + "/Admin_QuanLyGioHangController", icon: "bi-cart"},
        {name: "Đơn hàng", url: contextPath + "/Admin_QuanLyDonHangController", icon: "bi-receipt"},
        {name: "Khuyến mãi", url: contextPath + "/Admin_QuanLyKhuyenMaiController", icon: "bi-percent"},
        {name: "Tồn kho", url: contextPath + "/Admin_TonKhoController", icon: "bi-archive"},
        {name: "Thanh toán", url: contextPath + "/Admin_ThanhToanController", icon: "bi-credit-card"},
        {name: "Báo cáo doanh thu", url: contextPath + "/Admin_BaoCaoController", icon: "bi-bar-chart"},
        {name: "Dự báo bán hàng", url: contextPath + "/Admin_DuBaoController", icon: "bi-graph-up"}
    ];

    let currentIndex = -1;

    function searchHeaderFunction() {
        const keyword = document.getElementById("headerSearch").value.toLowerCase().trim();
        const resultsBox = document.getElementById("searchResults");

        if (keyword === "") {
            resultsBox.style.display = "none";
            return;
        }

        let html = "";
        let results = [];

        menuItems.forEach(item => {
            if (item.name.toLowerCase().includes(keyword)) {
                results.push(item);
            }
        });

        if (results.length > 0) {
            results.forEach((item, index) => {
                let highlighted = "<b>" + item.name + "</b>";
                if (item.name.toLowerCase().includes(keyword)) {
                    highlighted = item.name;
                }

                html +=
                        '<a href="' + item.url + '" ' +
                        'class="list-group-item list-group-item-action d-flex align-items-center gap-2" ' +
                        'data-index="' + index + '">' +
                        '<i class="bi ' + item.icon + ' text-primary"></i> ' +
                        highlighted +
                        '</a>';
            });
        } else {
            html = `<div class="list-group-item text-muted">Không tìm thấy chức năng</div>`;
        }

        resultsBox.innerHTML = html;
        resultsBox.style.display = "block";
        currentIndex = -1;

        document.querySelectorAll("#searchResults a").forEach(a => {
            a.onclick = function (e) {
                e.preventDefault();
                window.location.href = this.href;
            };
        });
    }

    function clearHeaderSearch() {
        document.getElementById("headerSearch").value = "";
        document.getElementById("searchResults").style.display = "none";
    }

    document.addEventListener("click", function (e) {
        const searchInput = document.getElementById("headerSearch");
        const resultsBox = document.getElementById("searchResults");
        if (!searchInput.contains(e.target) && !resultsBox.contains(e.target)) {
            resultsBox.style.display = "none";
        }
    });

    document.getElementById("headerSearch").addEventListener("keydown", function (e) {
        const items = document.querySelectorAll("#searchResults a");

        if (e.key === "ArrowDown") {
            currentIndex = (currentIndex + 1) % items.length;
        } else if (e.key === "ArrowUp") {
            currentIndex = (currentIndex - 1 + items.length) % items.length;
        } else if (e.key === "Enter") {
            if (items.length > 0) {
                let target = currentIndex >= 0 ? items[currentIndex] : items[0];
                window.location.href = target.href;
            }
        }

        items.forEach(item => item.classList.remove("active"));

        if (items[currentIndex]) {
            items[currentIndex].classList.add("active");
        }
    });
</script>