<%-- 
    Document   : Home
    Created on : Feb 24, 2026, 9:40:47 PM
    Author     : LEGION 5
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.User"%>
<%@page import="Model.SanPham"%>
<%@page import="java.util.List"%>

<%
    User user = (User) session.getAttribute("user");
    
    List<SanPham> top4 = (List<SanPham>) request.getAttribute("top4");

%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>KidStyle - Thời trang dễ thương cho bé</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    </head>
    <body>
        <%@ include file="../layout/header.jsp" %>
        <%@ include file="../layout/sidebar.jsp" %>

        <div class="sidebar-backdrop" id="sidebarBackdrop"></div>

        <div class="main-content">

            <section class="hero-review">
                <div id="heroSlider" class="carousel slide carousel-fade" 
                     data-bs-ride="carousel" data-bs-interval="3000">

                    <div class="carousel-indicators">
                        <button type="button" data-bs-target="#heroSlider" data-bs-slide-to="0" class="active"></button>
                        <button type="button" data-bs-target="#heroSlider" data-bs-slide-to="1"></button>
                        <button type="button" data-bs-target="#heroSlider" data-bs-slide-to="2"></button>
                    </div>

                    <div class="carousel-inner">

                         <div class="carousel-item active">
                            <div class="container d-flex align-items-center justify-content-between flex-wrap">
                                <div class="hero-img">
                                    <div class="blob"></div>
                                    <img src="${pageContext.request.contextPath}/img/home_banner1.png">
                                </div>
                                <div class="hero-content">
                                    <h3 class="hero-title">We love KidStyle</h3>
                                    <p class="hero-quote">“KidStyle là thương hiệu Việt đầu tiên đạt chuẩn quốc tế OEKO-TEX 100 cấp độ 1 – cấp độ an toàn nhất dành cho trẻ sơ sinh.
                                        Từng thiết kế của KidStyle chất chứa mong mỏi của một người mẹ với mong muốn con mình được được bảo vệ từ những điều nhỏ nhất trong những năm tháng đầu đời.”</p>
                                    <h5>- MC Minh Trang</h5>
                                </div>
                            </div>
                        </div>

                        <div class="carousel-item">
                            <div class="container d-flex align-items-center justify-content-between flex-wrap">
                                <div class="hero-img">
                                    <div class="blob"></div>
                                    <img src="${pageContext.request.contextPath}/img/home_banner2.png">
                                </div>
                                <div class="hero-content">
                                    <h3 class="hero-title">Chất lượng cho bé</h3>
                                    <p class="hero-quote">“Từng sản phẩm tại KidStyle không chỉ là quần áo, mà còn là sự chăm chút 
                                        trong từng đường kim mũi chỉ, đảm bảo sự thoải mái, an toàn và dễ chịu để bé có thể vui chơi, vận động suốt cả ngày dài mà không bị gò bó.”</p>
                                    <h5>- Khách hàng</h5>
                                </div>
                            </div>
                        </div>

                        <div class="carousel-item">
                            <div class="container d-flex align-items-center justify-content-between flex-wrap">
                                <div class="hero-img">
                                    <div class="blob"></div>
                                    <img src="${pageContext.request.contextPath}/img/banner1.jpg">
                                </div>
                                <div class="hero-content">
                                    <h3 class="hero-title">Sale cực sốc</h3>
                                    <p class="hero-quote">“Ưu đãi hấp dẫn lên đến 50% cho hàng loạt sản phẩm, cơ hội tuyệt vời 
                                        để ba mẹ sắm ngay những bộ đồ xinh xắn với mức giá siêu tiết kiệm.”</p>
                                    <h5>- KidStyle</h5>
                                </div>
                            </div>
                        </div>

                    </div>

                    <button class="carousel-control-prev" type="button" data-bs-target="#heroSlider" data-bs-slide="prev">
                        <span class="carousel-control-prev-icon"></span>
                    </button>

                    <button class="carousel-control-next" type="button" data-bs-target="#heroSlider" data-bs-slide="next">
                        <span class="carousel-control-next-icon"></span>
                    </button>

                </div>
            </section>


            <section class="banner-grid py-5">
                <div class="container">

                    <div class="row align-items-center mb-5">
                        <div class="col-md-6">
                            <img src="${pageContext.request.contextPath}/img/home1.jpg" class="img-fluid rounded-4 shadow">
                        </div>
                        <div class="col-md-6 text-center px-4">
                            <h2 class="fw-bold mb-3">Mẫu mã đẹp và phong phú</h2>
                            <p class="text-muted">
                                Tập hợp những mẫu quần áo thời trang bé gái mới nhất, đa phong cách: 
                                sành điệu, năng động, đáng yêu.
                            </p>
                            <a href="User_DSSPController" class="btn btn-outline-secondary mt-3 px-4">
                                Xem ngay
                            </a>
                        </div>
                    </div>

                    <div class="row align-items-center flex-md-row-reverse">
                        <div class="col-md-6">
                            <img src="${pageContext.request.contextPath}/img/home2.jpg" class="img-fluid rounded-4 shadow">
                        </div>
                        <div class="col-md-6 text-center px-4">
                            <h2 class="fw-bold mb-3">Quần áo cho bé Cool ngầu</h2>
                            <p class="text-muted">
                                Quần áo cho trẻ em năng động, sáng tạo. Thấm hút mồ hôi tốt giúp bé thoải mái vận động.
                            </p>
                            <a href="User_DSSPController" class="btn btn-outline-secondary mt-3 px-4">
                                Xem ngay
                            </a>
                        </div>
                    </div>

                </div>
            </section>

            <section class="py-5 bg-light">
                <div class="container">
                    <div class="text-center mb-5">
                        <h2 class="fw-bold display-6">
                            <i class="bi bi-star-fill text-warning me-3"></i>
                            SẢN PHẨM NỔI BẬT
                        </h2>
                        <p class="text-muted fs-5">Những món đồ được các bé và phụ huynh yêu thích nhất tuần này 💕</p>
                    </div>

                    <div class="row g-4">
                        <% if (top4 != null) {
                            for (SanPham sp : top4) { %>

                        <div class="col-lg-3 col-md-6">
                            <div class="card product-card h-100 shadow-sm border-0">

                                <div class="position-relative">
                                    <img src="<%= sp.getDuongDanAnh() %>" 
                                         class="card-img-top" 
                                         style="height:250px;object-fit:cover;">
                                    <span class="badge bg-danger position-absolute top-0 start-0 m-3">
                                        Hot 🔥
                                    </span>
                                </div>

                                <div class="card-body text-center d-flex flex-column">

                                    <h5 class="card-title fw-semibold">
                                        <%= sp.getTenSanPham() %>
                                    </h5>

                                    <p class="price text-danger fw-bold fs-5 mb-3">
                                        <%= String.format("%,.0f", sp.getGiaBan()) %> ₫
                                    </p>

                                    <% if (user != null) { %>

                                    <a href="javascript:void(0)" onclick="moModalThemGio(<%= sp.getMaSanPham() %>, '<%= sp.getTenSanPham() %>', '<%= sp.getDuongDanAnh() %>', <%= sp.getTonKho() %>)" 
                                       class="btn btn-outline-primary mb-2">
                                        <i class="bi bi-cart-plus"></i> Thêm vào giỏ
                                    </a>

                                    <a href="javascript:void(0)" onclick="moModalMuaNgay(<%= sp.getMaSanPham() %>, '<%= sp.getTenSanPham() %>', '<%= sp.getDuongDanAnh() %>', <%= sp.getTonKho() %>)" 
                                       class="btn btn-danger w-100">
                                        <i class="bi bi-lightning-charge"></i> Mua ngay
                                    </a>


                                    <% } else { %>

                                    <a href="javascript:void(0)" onclick="yeuCauDangNhap()" class="btn btn-outline-primary mb-2">
                                        <i class="bi bi-cart-plus"></i> Thêm vào giỏ
                                    </a>

                                    <a href="javascript:void(0)" onclick="yeuCauDangNhap()" class="btn btn-danger w-100">
                                        <i class="bi bi-lightning-charge"></i> Mua ngay
                                    </a>

                                    <% } %>

                                </div>
                            </div>
                        </div>

                        <%  }   
                    } else { %>
                        <p class="text-center">Không có dữ liệu</p>
                        <% } %>
                    </div>


                    <div class="text-center mt-5">
                        <a href="User_DSSPController" class="btn btn-outline-primary btn-lg px-5">
                            Xem tất cả sản phẩm <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>
                </div>
            </section>

            <div class="custom-banner text-center">
                <img src="${pageContext.request.contextPath}/img/banner.jpg" alt="KidStyle Banner">
            </div>

            <section class="py-5 bg-white">
                <div class="container">
                    <div class="row text-center g-5">
                        <div class="col-md-4">
                            <div class="service-box">
                                <i class="bi bi-truck service-icon"></i>
                                <h5 class="mt-4 fw-semibold">Giao hàng toàn quốc</h5>
                                <p class="text-muted">Nhanh chóng & an toàn<br>Free ship từ 300.000đ</p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="service-box">
                                <i class="bi bi-shield-check service-icon"></i>
                                <h5 class="mt-4 fw-semibold">Chất lượng đảm bảo</h5>
                                <p class="text-muted">Vải cotton organic<br>An toàn tuyệt đối cho bé</p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="service-box">
                                <i class="bi bi-arrow-repeat service-icon"></i>
                                <h5 class="mt-4 fw-semibold">Đổi trả dễ dàng</h5>
                                <p class="text-muted">Trong vòng 15 ngày<br>Không mất chi phí</p>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <%@ include file="../layout/footer.jsp" %>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>


                                        function yeuCauDangNhap() {
                                            const modal = new bootstrap.Modal(document.getElementById('loginRequiredModal'));
                                            modal.show();
                                        }

                                        let maSanPhamHienTai = 0;
                                        let max = 0; // tồn kho

                                        function moModalThemGio(maSP, tenSP, anhSP, tonKho) {
                                            maSanPhamHienTai = maSP;
                                            max = tonKho;

                                            document.getElementById("tenSanPhamModal").innerText = tenSP;
                                            document.getElementById("anhSanPhamModal").src = anhSP;
                                            document.getElementById("soLuongSP").value = 1;

                                            new bootstrap.Modal(document.getElementById('modalThemGio')).show();
                                        }

                                        function moModalMuaNgay(maSP, tenSP, anhSP, tonKho) {
                                            maSanPhamHienTai = maSP;
                                            max = tonKho;

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
                                            if (input.value > 1)
                                                input.value = parseInt(input.value) - 1;
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
                                                input.value = parseInt(input.value) - 1;
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

                                        function checkSoLuongThem(input) {
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

        <div class="modal fade" id="loginRequiredModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content text-center p-4 rounded-4">
                    <div class="mb-3">
                        <i class="bi bi-person-lock" style="font-size:60px;color:#ff6b9a;"></i>
                    </div>
                    <h4 class="fw-bold">Bạn chưa đăng nhập</h4>
                    <p class="text-muted">Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng hoặc mua ngay</p>
                    <div class="d-flex justify-content-center gap-3 mt-3">
                        <button class="btn btn-secondary px-4" data-bs-dismiss="modal">Đóng</button>
                        <a href="Login.jsp" class="btn btn-danger px-4">Đăng nhập</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="modalThemGio" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title"><i class="bi bi-cart-plus"></i> Thêm vào giỏ</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body text-center">
                        <img id="anhSanPhamModal" src="" style="width:120px;height:120px;object-fit:cover;border-radius:10px;margin-bottom:15px;">
                        <h5 id="tenSanPhamModal"></h5>
                        <div class="d-flex justify-content-center align-items-center mt-4">
                            <button class="btn btn-secondary" onclick="giamSL()">–</button>
                            <input type="number" id="soLuongSP" value="1" min="1" 
                                   class="form-control text-center mx-2" 
                                   style="width:80px;"
                                   oninput="checkSoLuongThem(this)">
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
                    </div>

                    <div class="modal-body text-center">
                        <img id="anhSanPhamModalMua" 
                             style="width:120px;height:120px;object-fit:cover;border-radius:10px;margin-bottom:15px;">

                        <h5 id="tenSanPhamModalMua"></h5>

                        <div class="d-flex justify-content-center align-items-center mt-4">
                            <button class="btn btn-secondary" onclick="giamSLMua()">–</button>

                            <input type="number" id="soLuongSPMua" value="1" min="1"
                                   class="form-control text-center mx-2"
                                   style="width:80px;"
                                   oninput="checkSoLuongThem(this)">

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