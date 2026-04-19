<%-- 
    Document   : user_KhuyenMai
    Created on : Apr 19, 2026, 8:47:02 PM
    Author     : LEGION 5
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="Model.SanPham, Model.KhuyenMai"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>

<%
    List<KhuyenMai> dsKMActive = (List<KhuyenMai>) request.getAttribute("dsKMActive");
    List<SanPham> dsSanPhamSale = (List<SanPham>) request.getAttribute("dsSanPhamSale");
    Model.User user = (Model.User) session.getAttribute("user");

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Săn Deal Cho Bé - KidStyle</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user_dssp.css">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user_khuyenmai.css">
    </head>

    <body>
        <%@ include file="layout/header.jsp" %>
        <%@ include file="layout/sidebar.jsp" %>

        <div class="sidebar-backdrop" id="sidebarBackdrop"></div>

        <div class="main-content">
            <div class="container pb-5">

                <div class="text-center mb-5 mt-4">
                    <h2 class="fw-bold page-heading">
                        <i class="bi bi-gift text-danger"></i> ƯU ĐÃI CỰC HOT

                    </h2>
                    <p class="text-muted">Đừng bỏ lỡ các sản phẩm chất lượng với mức giá ưu đãi nhất tại KidStyle</p>
                </div>

                <% if (dsKMActive != null && !dsKMActive.isEmpty()) { %>
                <div class="promo-banner-container">
                    <h5 class="fw-bold mb-4">
                        <i class="bi bi-megaphone me-2" style="color:#ff6b9a"></i>
                        Chương trình đang diễn ra
                    </h5>
                    <div class="row g-3">
                        <% for (KhuyenMai km : dsKMActive) {%>
                        <div class="col-md-4">
                            <div class="promo-item">
                                <div class="promo-percent">-<%= (int) km.getPhanTramGiam()%>%</div>
                                <div class="promo-name"><%= km.getTenKhuyenMai()%></div>
                                <div class="promo-date">
                                    Hạn: <%= sdf.format(km.getNgayBatDau())%> - <%= sdf.format(km.getNgayKetThuc())%>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
                <% } %>

                <h3 class="category-title">Sản phẩm đang giảm giá</h3>

                <div class="product-grid">

                    <%
                        if (dsSanPhamSale != null && !dsSanPhamSale.isEmpty()) {
                            for (SanPham sp : dsSanPhamSale) {
                                int percent = (int) (100 - (sp.getGiaKhuyenMai() * 100 / sp.getGiaBan()));
                    %>

                    <div class="card-product">

                        <div class="product-badge">
                            <div class="sale-badge">
                                <span class="percent">-<%=percent%>%</span>
                                <span class="label">GIẢM</span>
                            </div>
                        </div>

                        <a href="User_ChiTietSPController?maSP=<%=sp.getMaSanPham()%>">
                            <img src="<%=sp.getDuongDanAnh()%>" alt="<%=sp.getTenSanPham()%>">
                        </a>

                        <div class="product-info">

                            <a class="product-name"
                               href="User_ChiTietSPController?maSP=<%=sp.getMaSanPham()%>">
                                <%=sp.getTenSanPham()%>
                            </a>

                            <div class="sold">
                                Đã bán <b><%=sp.getLuotBan()%></b>
                            </div>

                            <div class="price-box">
                                <span class="old-price">
                                    <%= String.format("%,.0f", sp.getGiaBan())%> ₫
                                </span>
                                <span class="price">
                                    <%= String.format("%,.0f", sp.getGiaKhuyenMai())%> ₫
                                </span>
                            </div>

                            <div class="product-actions">

                                <% if (user != null) {%>

                                <a href="javascript:void(0)"
                                   onclick="moModalThemGio(<%=sp.getMaSanPham()%>, '<%=sp.getTenSanPham()%>', '<%=sp.getDuongDanAnh()%>', <%=sp.getTonKho()%>)"
                                   class="btn btn-cart">
                                    <i class="bi bi-cart-plus"></i> Thêm vào giỏ
                                </a>

                                <a href="javascript:void(0)"
                                   onclick="moModalMuaNgay(<%=sp.getMaSanPham()%>, '<%=sp.getTenSanPham()%>', '<%=sp.getDuongDanAnh()%>', <%=sp.getTonKho()%>)"
                                   class="btn btn-buy">
                                    <i class="bi bi-lightning-charge"></i> Mua ngay
                                </a>

                                <% } else { %>

                                <a href="javascript:void(0)" onclick="yeuCauDangNhap()" class="btn btn-cart">
                                    <i class="bi bi-cart-plus"></i> Thêm vào giỏ
                                </a>

                                <a href="javascript:void(0)" onclick="yeuCauDangNhap()" class="btn btn-buy">
                                    <i class="bi bi-lightning-charge"></i> Mua ngay
                                </a>

                                <% } %>

                            </div>

                        </div>

                    </div>

                    <%
                        }
                    } else {
                    %>

                    <div class="empty bg-white rounded-4 shadow-sm w-100 py-5">
                        <i class="bi bi-emoji-smile fs-1 mb-3 text-muted"></i>
                        <p class="mb-0">Hiện chưa có sản phẩm nào đang trong chương trình ưu đãi.</p>
                        <a href="User_DSSPController" class="btn btn-outline-danger btn-sm mt-3 px-4 rounded-pill">
                            Xem tất cả sản phẩm
                        </a>
                    </div>

                    <%
                        }
                    %>

                </div>
            </div>

            <%@ include file="layout/footer.jsp" %>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                    function yeuCauDangNhap() {
                                        const modal = new bootstrap.Modal(document.getElementById('loginRequiredModal'));
                                        modal.show();
                                    }

                                    let maSanPham = 0;
                                    let max = 0;

                                    function moModalThemGio(maSP, tenSP, anhSP, tonKho) {
                                        maSanPham = maSP;
                                        max = tonKho;
                                        document.getElementById("tenSanPhamModal").innerText = tenSP;
                                        document.getElementById("anhSanPhamModal").src = anhSP;
                                        document.getElementById("soLuongSP").value = 1;
                                        new bootstrap.Modal(document.getElementById('modalThemGio')).show();
                                    }

                                    function tangSL() {
                                        let input = document.getElementById("soLuongSP");
                                        let val = parseInt(input.value) || 1;
                                        if (val >= max) {
                                            alert("Đã đạt tối đa tồn kho!");
                                            return;
                                        }
                                        input.value = val + 1;
                                    }

                                    function giamSL() {
                                        let input = document.getElementById("soLuongSP");
                                        if (input.value > 1)
                                            input.value--;
                                    }

                                    function xacNhanThemGio() {
                                        let sl = parseInt(document.getElementById("soLuongSP").value);
                                        if (isNaN(sl) || sl < 1) {
                                            alert("Số lượng không hợp lệ!");
                                            return;
                                        }
                                        if (sl > max) {
                                            alert("Vượt tồn kho!");
                                            return;
                                        }
                                        window.location = "User_GioHangController?action=add&maSP=" + maSanPham + "&sl=" + sl;
                                    }

                                    function moModalMuaNgay(maSP, tenSP, anhSP, tonKho) {
                                        maSanPham = maSP;
                                        max = tonKho;
                                        document.getElementById("tenSanPhamModalMua").innerText = tenSP;
                                        document.getElementById("anhSanPhamModalMua").src = anhSP;
                                        document.getElementById("soLuongSPMua").value = 1;
                                        new bootstrap.Modal(document.getElementById('modalMuaNgay')).show();
                                    }

                                    function tangSLMua() {
                                        let input = document.getElementById("soLuongSPMua");
                                        let val = parseInt(input.value) || 1;
                                        if (val >= max) {
                                            alert("Đã đạt tối đa tồn kho!");
                                            return;
                                        }
                                        input.value = val + 1;
                                    }

                                    function giamSLMua() {
                                        let input = document.getElementById("soLuongSPMua");
                                        if (input.value > 1)
                                            input.value--;
                                    }

                                    function xacNhanMua() {
                                        let sl = parseInt(document.getElementById("soLuongSPMua").value);
                                        if (isNaN(sl) || sl < 1) {
                                            alert("Số lượng không hợp lệ!");
                                            return;
                                        }
                                        if (sl > max) {
                                            alert("Vượt tồn kho!");
                                            return;
                                        }
                                        window.location = "User_ThanhToanController?type=buynow&maSP=" + maSanPham + "&sl=" + sl;
                                    }

                                    function checkSoLuong(input) {
                                        let val = parseInt(input.value) || 1;
                                        if (val > max) {
                                            alert("Vượt tồn kho!");
                                            input.value = max;
                                        }
                                        if (val < 1)
                                            input.value = 1;
                                    }
        </script>

        <div class="modal fade" id="loginRequiredModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content text-center p-4 rounded-4 shadow border-0">
                    <div class="mb-3">
                        <i class="bi bi-person-lock" style="font-size:60px;color:#ff6b9a;"></i>
                    </div>
                    <h4 class="fw-bold">Bạn chưa đăng nhập</h4>
                    <p class="text-muted">Vui lòng đăng nhập để thực hiện mua sắm.</p>
                    <div class="d-flex justify-content-center gap-3 mt-3">
                        <button class="btn btn-secondary px-4 rounded-pill" data-bs-dismiss="modal">Đóng</button>
                        <a href="Login.jsp" class="btn btn-danger px-4 rounded-pill">Đăng nhập</a>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal fade" id="modalThemGio" tabindex="-1">

            <div class="modal-dialog modal-dialog-centered">

                <div class="modal-content">

                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="bi bi-cart-plus"></i> Thêm vào giỏ
                        </h5>

                        <button type="button"
                                class="btn-close"
                                data-bs-dismiss="modal">
                        </button>
                    </div>

                    <div class="modal-body text-center">
                        <img id="anhSanPhamModal"
                             src=""
                             style="width:120px;height:120px;object-fit:cover;border-radius:10px;margin-bottom:10px;">

                        <h5 id="tenSanPhamModal"></h5>

                        <div class="d-flex justify-content-center align-items-center mt-3">

                            <button class="btn btn-secondary"
                                    onclick="giamSL()">-</button>

                            <input type="number"
                                   id="soLuongSP"
                                   value="1"
                                   min="1"
                                   class="form-control text-center mx-2"
                                   style="width:80px"
                                   oninput="checkSoLuong(this)">

                            <button class="btn btn-secondary"
                                    onclick="tangSL()">+</button>
                        </div>
                    </div>

                    <div class="modal-footer justify-content-center">
                        <button class="btn btn-secondary"
                                data-bs-dismiss="modal">
                            Hủy
                        </button>
                        <button class="btn btn-danger"
                                onclick="xacNhanThemGio()">

                            <i class="bi bi-cart-plus"></i>
                            Thêm vào giỏ
                        </button>
                    </div>

                </div>
            </div>
        </div>

        <div class="modal fade" id="modalMuaNgay" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">

                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="bi bi-lightning-charge"></i> Mua ngay
                        </h5>
                    </div>

                    <div class="modal-body text-center">
                        <img id="anhSanPhamModalMua"
                             style="width:120px;height:120px;object-fit:cover;border-radius:10px;margin-bottom:10px;">

                        <h5 id="tenSanPhamModalMua"></h5>

                        <div class="d-flex justify-content-center mt-3">
                            <button class="btn btn-secondary" onclick="giamSLMua()">-</button>

                            <input type="number"
                                   id="soLuongSPMua"
                                   value="1"
                                   min="1"
                                   class="form-control text-center mx-2"
                                   style="width:80px"
                                   oninput="checkSoLuong(this)">

                            <button class="btn btn-secondary" onclick="tangSLMua()">+</button>
                        </div>
                    </div>

                    <div class="modal-footer justify-content-center">
                        <button class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>

                        <button class="btn btn-danger" onclick="xacNhanMua()">
                            <i class="bi bi-lightning-charge"></i> Thanh toán
                        </button>

                    </div>
                </div>
            </div>
        </div>
    </body>
</html>