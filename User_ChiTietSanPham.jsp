<%-- 
    Document   : User_ChiTietSanPham
    Created on : Mar 12, 2026, 4:10:52 PM
    Author     : LEGION 5
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.SanPham"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>

<%
    SanPham sp = (SanPham) request.getAttribute("sanPham");
    NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    Model.User user = (Model.User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết sản phẩm</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user_chitietsp.css">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
              rel="stylesheet">
    </head>

    <body>

        <%@ include file="../layout/header.jsp" %>
        <%@ include file="../layout/sidebar.jsp" %>

        <div class="sidebar-backdrop" id="sidebarBackdrop"></div>

        <div class="main-content">
            <div class="container">

                <div class="product-detail">

                    <div class="row g-4 align-items-center">

                        <div class="col-md-6">
                            <a href="javascript:history.back()" class="btn btn-light mb-3 back-btn">
                                <i class="bi bi-arrow-left"></i> Quay lại
                            </a>

                            <div class="image-box">
                                <img src="<%=sp.getDuongDanAnh()%>" class="img-fluid">
                            </div>
                        </div>

                        <div class="col-md-6">

                            <h2 class="product-title">
                                <i class="bi bi-tag-fill title-icon me-2"></i>
                                <%=sp.getTenSanPham()%>
                            </h2>
                            
                            <% if (sp.getGiaKhuyenMai() > 0) {%>
                            <div class="price-box">
                                <span class="old-price"><%=nf.format(sp.getGiaBan())%></span>
                                <span class="price"><%=nf.format(sp.getGiaKhuyenMai())%></span>
                                <span class="discount-badge">SALE</span>
                            </div>
                            <% } else {%>
                            <div class="price"><%=nf.format(sp.getGiaBan())%></div>
                            <% }%>

                            <div class="section">
                                <div class="section-title">
                                    <i class="bi bi-card-text"></i> Mô tả sản phẩm :
                                    <p class="product-desc"><%=sp.getMoTa()%></p>
                                </div>
                            </div>
                            <p class="stock">
                                <i class="bi bi-box-seam"></i>
                                Còn lại: <b><%=sp.getTonKho()%></b> sản phẩm
                            </p>

                            <div class="product-actions">

                                <% if (user != null) { %>

                                <button class="btn btn-cart"
                                        onclick="moModalThemGio(<%=sp.getMaSanPham()%>, '<%=sp.getTenSanPham()%>', '<%=sp.getDuongDanAnh()%>')">
                                    <i class="bi bi-cart-plus"></i> Thêm vào giỏ
                                </button>

                                <button class="btn btn-buy"
                                        onclick="moModalMuaNgay(<%=sp.getMaSanPham()%>, '<%=sp.getTenSanPham()%>', '<%=sp.getDuongDanAnh()%>')">
                                    <i class="bi bi-lightning-charge"></i> Mua ngay
                                </button>

                                <% } else { %>

                                <button class="btn btn-cart" onclick="yeuCauDangNhap()">
                                    <i class="bi bi-cart-plus"></i> Thêm vào giỏ
                                </button>

                                <button class="btn btn-buy" onclick="yeuCauDangNhap()">
                                    <i class="bi bi-lightning-charge"></i> Mua ngay
                                </button>

                                <% } %>

                            </div>

                        </div>

                    </div>

                </div>

                <%@ include file="../layout/footer.jsp" %>

            </div>
        </div>

        <div class="modal fade" id="modalThemGio" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">

                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="bi bi-cart-plus"></i> Thêm vào giỏ
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body text-center">
                        <img id="anhSanPhamModal"
                             style="width:120px;height:120px;object-fit:cover;border-radius:10px;margin-bottom:15px;">

                        <h5 id="tenSanPhamModal"></h5>

                        <div class="d-flex justify-content-center align-items-center mt-4">
                            <button class="btn btn-secondary" onclick="giamSL()">–</button>

                            <input type="number" id="soLuongSP" value="1" min="1" max="<%=sp.getTonKho()%>"                                   class="form-control text-center mx-2"
                                   style="width:80px;"
                                   oninput="checkSoLuong(this)">

                            <button class="btn btn-secondary" onclick="tangSL()">+</button>
                        </div>
                    </div>

                    <div class="modal-footer justify-content-center">
                        <button class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>

                        <button class="btn btn-danger" onclick="xacNhanThemGio()">
                            <i class="bi bi-cart-plus"></i> Thêm vào giỏ
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
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body text-center">
                        <img id="anhSanPhamModalMua"
                             style="width:120px;height:120px;object-fit:cover;border-radius:10px;margin-bottom:15px;">

                        <h5 id="tenSanPhamModalMua"></h5>

                        <div class="d-flex justify-content-center align-items-center mt-4">
                            <button class="btn btn-secondary" onclick="giamSLMua()">–</button>

                            <input type="number" id="soLuongSPMua" value="1" min="1" max="<%=sp.getTonKho()%>"
                                   class="form-control text-center mx-2"
                                   style="width:80px;"
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

        <div class="modal fade" id="loginRequiredModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content text-center p-4 rounded-4">

                    <div class="mb-3">
                        <i class="bi bi-person-lock" style="font-size:60px;color:#ff6b9a;"></i>
                    </div>

                    <h4 class="fw-bold">Bạn chưa đăng nhập</h4>

                    <p class="text-muted">
                        Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng hoặc mua ngay
                    </p>

                    <div class="d-flex justify-content-center gap-3 mt-3">

                        <button class="btn btn-secondary px-4"
                                data-bs-dismiss="modal">
                            Đóng
                        </button>

                        <a href="Login.jsp"
                           class="btn btn-danger px-4">
                            Đăng nhập
                        </a>

                    </div>
                </div>
            </div>
        </div>
    </body>
</html>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
                            function yeuCauDangNhap() {
                                const modal = new bootstrap.Modal(
                                        document.getElementById('loginRequiredModal')
                                        );
                                modal.show();
                            }


                            let maSanPhamHienTai = 0;
                            let max = <%=sp.getTonKho()%>;

                            function moModalThemGio(maSP, tenSP, anhSP) {
                                maSanPhamHienTai = maSP;

                                document.getElementById("tenSanPhamModal").innerText = tenSP;
                                document.getElementById("anhSanPhamModal").src = anhSP;
                                document.getElementById("soLuongSP").value = 1;

                                new bootstrap.Modal(document.getElementById('modalThemGio')).show();
                            }

                            function moModalMuaNgay(maSP, tenSP, anhSP) {
                                maSanPhamHienTai = maSP;

                                document.getElementById("tenSanPhamModalMua").innerText = tenSP;
                                document.getElementById("anhSanPhamModalMua").src = anhSP;
                                document.getElementById("soLuongSPMua").value = 1;

                                new bootstrap.Modal(document.getElementById('modalMuaNgay')).show();
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
                                let val = parseInt(input.value) || 1;

                                if (val > 1)
                                    input.value = val - 1;
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
                                let val = parseInt(input.value) || 1;

                                if (val > 1)
                                    input.value = val - 1;
                            }

                            function xacNhanThemGio() {
                                let sl = parseInt(document.getElementById("soLuongSP").value);

                                if (isNaN(sl)) {
                                    alert("Vui lòng nhập số lượng!");
                                    return;
                                }

                                if (sl > max) {
                                    alert("Số lượng vượt tồn kho!");
                                    return;
                                }

                                if (sl < 1) {
                                    alert("Số lượng không hợp lệ!");
                                    return;
                                }

                                window.location = "User_GioHangController?action=add&maSP="
                                        + maSanPhamHienTai + "&sl=" + sl;
                            }

                            function xacNhanMua() {
                                let sl = parseInt(document.getElementById("soLuongSPMua").value);

                                if (isNaN(sl)) {
                                    alert("Vui lòng nhập số lượng!");
                                    return;
                                }

                                if (sl > max) {
                                    alert("Số lượng vượt tồn kho!");
                                    return;
                                }

                                if (sl < 1) {
                                    alert("Số lượng không hợp lệ!");
                                    return;
                                }

                                window.location = "User_ThanhToanController?type=buynow&maSP="
                                        + maSanPhamHienTai + "&sl=" + sl;
                            }

                            function checkSoLuong(input) {
                                let val = parseInt(input.value) || 1;

                                if (val > max) {
                                    alert("Vượt quá tồn kho!");
                                    input.value = max;
                                }

                                if (val < 1) {
                                    input.value = 1;
                                }
                            }

</script>