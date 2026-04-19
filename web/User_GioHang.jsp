<%-- 
    Document   : User_GioHang
    Created on : Mar 12, 2026, 5:00:08 PM
    Author     : LEGION 5
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="Model.GioHang"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>

<%
    List<GioHang> gioHang = (List<GioHang>) request.getAttribute("gioHang");

    NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>

<!DOCTYPE html>
<html>
    <head>

        <meta charset="UTF-8">
        <title>Giỏ hàng</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
              rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user_giohang.css">

    </head>

    <body>

        <%@ include file="layout/header.jsp" %>
        <%@ include file="layout/sidebar.jsp" %>

        <div class="sidebar-backdrop" id="sidebarBackdrop"></div>


        <div class="main-content">

            <div class="container">

                <div class="cart-page">

                    <h2 class="text-center mb-4">🛒 Giỏ hàng của bạn</h2>

                    <div class="cart-table-wrapper">

                        <table class="table table-bordered cart-table">

                            <thead>
                                <tr>
                                    <th >Chọn sản phẩm</th>
                                    <th>Ảnh</th>
                                    <th>Sản phẩm</th>
                                    <th>Giá</th>
                                    <th>Số lượng</th>
                                    <th>Tổng</th>
                                    <th>Xóa</th>
                                </tr>
                            </thead>

                            <tbody>

                                <%
                                    double tong = 0;

                                    if (gioHang != null) {

                                        for (GioHang g : gioHang) {

                                            double gia = g.getGiaKhuyenMai() > 0 ? g.getGiaKhuyenMai() : g.getGiaBan();
                                            double thanhTien = gia * g.getSoLuong();

                                            tong += thanhTien;

                                %>

                                <tr>
                                    <td>
                                        <input type="checkbox" 
                                               class="product-check"
                                               data-id="<%=g.getMaGioHang()%>"
                                               value="<%=g.getMaGioHang()%>">
                                    </td>

                                    <td width="120">
                                        <img src="<%=g.getDuongDanAnh()%>" width="100">
                                    </td>

                                    <td>
                                        <%=g.getTenSanPham()%>
                                    </td>

                                    <td>
                                        <%=nf.format(gia)%>
                                    </td>

                                    <td>

                                        <button class="btn btn-sm btn-secondary"
                                                onclick="changeQty(<%=g.getMaGioHang()%>, -1, <%=gia%>)">-</button>

                                        <span class="mx-2 qty-<%=g.getMaGioHang()%>"><%=g.getSoLuong()%></span>

                                        <button class="btn btn-sm btn-secondary"
                                                onclick="changeQty(<%=g.getMaGioHang()%>, 1, <%=gia%>)">+</button>

                                    </td>

                                    <td class="row-total row-<%=g.getMaGioHang()%>">
                                        <%=nf.format(thanhTien)%>
                                    </td>

                                    <td>

                                        <a href="User_GioHangController?action=delete&ma=<%=g.getMaGioHang()%>"
                                           class="btn btn-danger btn-sm">

                                            <i class="bi bi-trash"></i>

                                        </a>

                                    </td>

                                </tr>

                                <%
                                        }
                                    }
                                %>

                            </tbody>

                        </table>

                    </div>

                    <div class="cart-footer">

                        <div class="left-actions">

                            <button type="button"
                                    class="btn btn-outline-secondary btn-sm"
                                    onclick="selectAll()">

                                <i class="bi bi-check-square"></i>
                                Chọn tất cả

                            </button>

                            <button type="button"
                                    class="btn btn-outline-secondary btn-sm"
                                    onclick="unselectAll()">

                                <i class="bi bi-square"></i>
                                Bỏ chọn

                            </button>

                            <button type="button"
                                    class="btn btn-outline-danger btn-sm"
                                    onclick="deleteSelected()">

                                <i class="bi bi-trash"></i>
                                Xóa sản phẩm đã chọn

                            </button>

                        </div>

                        <div class="right-actions">

                            <div class="total-box total-cart">

                                Tổng giỏ hàng
                                <span><%=nf.format(tong)%></span>

                            </div>

                            <div class="total-box total-selected">

                                Đã chọn
                                <span id="selectedTotal">0 ₫</span>

                            </div>

                            <button class="btn btn-danger"
                                    onclick="checkoutSelected()">

                                <i class="bi bi-credit-card"></i>
                                Thanh toán

                            </button>
                        </div>
                    </div>

                </div>
            </div> 
        </div> 

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            const checks = document.querySelectorAll(".product-check");

            function changeQty(ma, delta, gia) {
                let qtyEl = document.querySelector(".qty-" + ma);

                let current = parseInt(qtyEl.innerText);

                let newQty = current + delta;

                if (newQty < 1)
                    return;

                fetch("User_GioHangController?action=updateAjax&ma=" + ma + "&sl=" + newQty)
                        .then(res => res.text())
                        .then(data => {

                            if (data === "ok") {

                                qtyEl.innerText = newQty;

                                let total = gia * newQty;

                                document.querySelector(".row-" + ma).innerText =
                                        new Intl.NumberFormat('vi-VN', {
                                            style: 'currency',
                                            currency: 'VND'
                                        }).format(total);
                                updateCartTotal();
                                updateSelectedTotal();
                            }
                        });
            }

            function updateCartTotal() {
                let sum = 0;
                document.querySelectorAll(".row-total").forEach(r => {
                    let text = r.innerText.replace(/[^\d]/g, '');
                    sum += parseInt(text);

                });
                document.querySelector(".total-cart span").innerText =
                        new Intl.NumberFormat('vi-VN', {
                            style: 'currency',
                            currency: 'VND'
                        }).format(sum);
            }


            function updateSelectedTotal() {
                let total = 0;
                document.querySelectorAll(".product-check").forEach(c => {
                    if (c.checked) {
                        let id = c.dataset.id;

                        let row = document.querySelector(".row-" + id);

                        let text = row.innerText.replace(/[^\d]/g, '');

                        total += parseInt(text);
                    }
                });
                document.getElementById("selectedTotal").innerText =
                        new Intl.NumberFormat('vi-VN', {
                            style: 'currency',
                            currency: 'VND'
                        }).format(total);
            }


            document.querySelectorAll(".product-check").forEach(c => {
                c.addEventListener("change", updateSelectedTotal);
            });

            function selectAll() {
                checks.forEach(c => c.checked = true);
                updateSelectedTotal();
            }

            function unselectAll() {
                checks.forEach(c => c.checked = false);
                updateSelectedTotal();
            }

            function deleteSelected() {
                let ids = [];
                document.querySelectorAll(".product-check:checked").forEach(c => {
                    ids.push(c.value);
                });
                if (ids.length === 0) {
                    alert("Vui lòng chọn sản phẩm");
                    return;
                }
                window.location =
                        "User_GioHangController?action=deleteSelected&ids=" + ids.join(",");
            }

            function checkoutSelected() {
                let ids = [];

                document.querySelectorAll(".product-check:checked").forEach(c => {
                    ids.push(c.value);
                });
                if (ids.length === 0) {
                    alert("Vui lòng chọn sản phẩm");
                    return;
                }
                window.location =
                        "User_ThanhToanController?ids=" + ids.join(",");
            }
        </script>
    </body>
</html>