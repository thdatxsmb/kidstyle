<%-- 
    Document   : sidebar
    Created on : Feb 25, 2026, 2:41:20 PM
    Author     : LEGION 5
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">

<%
    String maDM = request.getParameter("maDanhMuc");
    if (maDM == null) {
        maDM = "";
    }

    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "";
    }

    boolean isInAccount = (tab != null && !tab.isEmpty());
%>

<div class="sidebar" id="sidebarMenu">

    <div class="sidebar-header">📂 Danh mục</div>
    
    <a href="User_DSSPController"
       class="<%= (maDM.equals("") && !isInAccount) ? "active" : ""%>">
        🛍️ Tất cả
    </a>

    <a href="User_DSSPController?maDanhMuc=1"
       class="<%= "1".equals(maDM) ? "active" : ""%>">
        👕 Áo bé trai
    </a>

    <a href="User_DSSPController?maDanhMuc=2"
       class="<%= "2".equals(maDM) ? "active" : ""%>">
        👖 Quần bé trai
    </a>

    <a href="User_DSSPController?maDanhMuc=3"
       class="<%= "3".equals(maDM) ? "active" : ""%>">
        👚 Áo bé gái
    </a>

    <a href="User_DSSPController?maDanhMuc=4"
       class="<%= "4".equals(maDM) ? "active" : ""%>">
        👗 Váy bé gái
    </a>

    <a href="User_DSSPController?maDanhMuc=5"
       class="<%= "5".equals(maDM) ? "active" : ""%>">
        👶 Đồ sơ sinh
    </a>

    <a href="User_DSSPController?maDanhMuc=6"
       class="<%= "6".equals(maDM) ? "active" : ""%>">
        🧥 Áo khoác trẻ em
    </a>

    <a href="User_DSSPController?maDanhMuc=7"
       class="<%= "7".equals(maDM) ? "active" : ""%>">
        🌞 Bộ đồ mùa hè
    </a>

    <a href="User_DSSPController?maDanhMuc=8"
       class="<%= "8".equals(maDM) ? "active" : ""%>">
        ❄️ Bộ đồ mùa đông
    </a>

    <a href="User_DSSPController?maDanhMuc=9"
       class="<%= "9".equals(maDM) ? "active" : ""%>">
        👟 Giày dép trẻ em
    </a>

    <a href="User_DSSPController?maDanhMuc=10"
       class="<%= "10".equals(maDM) ? "active" : ""%>">
        🎀 Phụ kiện trẻ em
    </a>

    <hr class="text-light my-3 mx-3">

    <div class="sidebar-header">👤 Tài khoản</div>

    <% if (loggedUser != null) {%>

    <a href="User_HoSoController?tab=profile"
       class="<%= "profile".equals(tab) ? "active" : ""%>">
        <i class="bi bi-person me-2"></i> Hồ sơ
    </a>

    <a href="User_DonHangController?tab=orders"
       class="<%= "orders".equals(tab) ? "active" : ""%>">
        <i class="bi bi-receipt me-2"></i> Đơn hàng của tôi
    </a>

    <a href="Logout">
        <i class="bi bi-box-arrow-right me-2"></i> Đăng xuất
    </a>

    <% } else {%>

    <a href="Login.jsp?tab=login"
       class="<%= "login".equals(tab) ? "active" : ""%>">
        <i class="bi bi-box-arrow-in-right me-2"></i> Đăng nhập
    </a>

    <a href="DangKy.jsp?tab=register"
       class="<%= "register".equals(tab) ? "active" : ""%>">
        <i class="bi bi-person-plus me-2"></i> Đăng ký
    </a>

    <% }%>

</div>

<div class="sidebar-backdrop" id="sidebarBackdrop"></div>

<script>
    document.addEventListener("DOMContentLoaded", () => {

        const toggler = document.getElementById("sidebarToggler");
        const sidebar = document.getElementById("sidebarMenu");
        const backdrop = document.getElementById("sidebarBackdrop");
        const mainContent = document.querySelector(".main-content");

        if (toggler) {
            toggler.addEventListener("click", () => {
                sidebar.classList.toggle("show");
                backdrop.classList.toggle("show");
                mainContent?.classList.toggle("shift");
            });
        }

        backdrop.addEventListener("click", () => {
            sidebar.classList.remove("show");
            backdrop.classList.remove("show");
            mainContent?.classList.remove("shift");
        });

    });


    const sidebar = document.getElementById("sidebarMenu");

    let savedScroll = localStorage.getItem("sidebarScroll");
    if (savedScroll !== null) {
        sidebar.scrollTop = savedScroll;
    }

    sidebar.addEventListener("scroll", () => {
        localStorage.setItem("sidebarScroll", sidebar.scrollTop);
    });
</script>