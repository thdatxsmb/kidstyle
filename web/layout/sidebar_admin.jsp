<%-- 
    Document   : sidebar_admin
    Created on : Mar 15, 2026, 5:31:05 PM
    Author     : LEGION 5
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<aside class="sidebar" id="adminSidebar">

    <div class="sidebar-section-title">TỔNG QUAN</div>
    <a href="${pageContext.request.contextPath}/Admin_HomeController" class="nav-link" id="dashboard-link">
        <i class="bi bi-speedometer2 me-3"></i> Bảng tổng quan
    </a>

    <div class="sidebar-section-title">QUẢN LÝ</div>
    <a href="${pageContext.request.contextPath}/Admin_QuanLyNguoiDungController" class="nav-link">
        <i class="bi bi-people me-3"></i> Người dùng
    </a>
    <a href="${pageContext.request.contextPath}/Admin_QuanLyDanhMucController" class="nav-link">
        <i class="bi bi-tags me-3"></i> Danh mục sản phẩm
    </a>
    <a href="${pageContext.request.contextPath}/Admin_QuanLySanPhamController" class="nav-link">
        <i class="bi bi-box-seam me-3"></i> Sản phẩm
    </a>
    <a href="${pageContext.request.contextPath}/Admin_QuanLyGioHangController" class="nav-link">
        <i class="bi bi-cart me-3"></i> Giỏ hàng
    </a>
    <a href="${pageContext.request.contextPath}/Admin_QuanLyDonHangController" class="nav-link">
        <i class="bi bi-receipt me-3"></i> Đơn hàng
    </a>
    <a href="${pageContext.request.contextPath}/Admin_QuanLyKhuyenMaiController" class="nav-link">
        <i class="bi bi-gift me-3"></i> Khuyến mãi
    </a>

    <div class="sidebar-section-title">KHO & THANH TOÁN</div>
    <a href="${pageContext.request.contextPath}/Admin_TonKhoController" class="nav-link">
        <i class="bi bi-boxes me-3"></i> Tồn kho
    </a>
    <a href="${pageContext.request.contextPath}/Admin_ThanhToanController" class="nav-link">
        <i class="bi bi-credit-card me-3"></i> Thanh toán
    </a>

    <div class="sidebar-section-title">BÁO CÁO & DỰ BÁO</div>
    <a href="${pageContext.request.contextPath}/Admin_BaoCaoController" class="nav-link">
        <i class="bi bi-cash-stack me-3"></i> Báo cáo doanh thu
    </a>
    <a href="${pageContext.request.contextPath}/Admin_DuBaoController" class="nav-link">
        <i class="bi bi-graph-up-arrow me-3"></i> Dự báo bán hàng
    </a>

    <div class="sidebar-section-title mt-4">HỆ THỐNG</div>
    <a href="${pageContext.request.contextPath}/Admin_HomeController" class="nav-link" >
        <i class="bi bi-house-door me-3"></i> Về trang chủ website
    </a>
    <a href="Logout" class="nav-link text-danger">
        <i class="bi bi-box-arrow-right me-3"></i> Đăng xuất
    </a>
</aside>

<div class="sidebar-backdrop" id="sidebarBackdrop"></div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const currentPath = window.location.pathname.toLowerCase();

        document.querySelectorAll(".sidebar .nav-link").forEach(function (link) {
            const href = link.getAttribute("href");
            if (!href) return;

            if (link.id === "dashboard-link") {
                if (currentPath.includes("admin_homecontroller") || 
                    currentPath.endsWith("/admin") || 
                    currentPath.endsWith("/admin/")) {
                    link.classList.add("active");
                }
                return;  
            }

            const linkText = link.textContent.trim();
            if (linkText.includes("Về trang chủ website")) {
                return; 
            }

            if (currentPath.endsWith(href.toLowerCase()) || 
                (href.includes("Admin_HomeController") && currentPath.includes("admin_homecontroller"))) {
                link.classList.add("active");
            }
        });
    });

    document.addEventListener("DOMContentLoaded", function () {
        const sidebar = document.getElementById("adminSidebar");
        
        let savedScroll = localStorage.getItem("sidebarScroll");
        if (savedScroll !== null) {
            sidebar.scrollTop = parseInt(savedScroll);
        }

        sidebar.addEventListener("scroll", function () {
            localStorage.setItem("sidebarScroll", sidebar.scrollTop);
        });
    });

    document.addEventListener('DOMContentLoaded', function () {
        const toggler = document.getElementById('sidebarToggler');
        const sidebar = document.getElementById('adminSidebar');
        const mainContent = document.getElementById('mainContent');
        
        if (toggler) {
            toggler.addEventListener('click', function (e) {
                e.preventDefault();
                sidebar.classList.toggle('collapsed');
                if (mainContent) mainContent.classList.toggle('expand');
            });
        }
    });
</script>