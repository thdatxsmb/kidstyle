<%-- 
    Document   : User_DanhSachSanPham
    Created on : Feb 25, 2026, 11:08:48 AM
    Author     : LEGION 5
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="Model.SanPham"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="Model.DanhMuc"%>


<%
    List<SanPham> tatCaSanPham
            = (List<SanPham>) request.getAttribute("dsSanPham");

    NumberFormat nf
            = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>

<%
    Model.User user = (Model.User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh sách sản phẩm</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user_dssp.css">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
              rel="stylesheet">
    </head>

    <body>
        <%@ include file="layout/header.jsp" %>
        <%@ include file="layout/sidebar.jsp" %>

        <div class="sidebar-backdrop" id="sidebarBackdrop"></div>

        <div class="main-content">

            <div class="container">

                <h2 class="text-center fw-bold mb-4">
                    <i class="bi bi-stars"></i> Danh sách sản phẩm
                </h2>
                <%
                    List<DanhMuc> dsDanhMuc = (List<DanhMuc>) request.getAttribute("dsDanhMuc");
                    Integer selectedDM = (Integer) request.getAttribute("selectedDM");
                %>

                <div class="category-menu">
                    <a href="User_DSSPController"
                       class="<%= (selectedDM == null ? "active" : "") %>">
                        Tất cả
                    </a>

                    <% for (DanhMuc dm : dsDanhMuc) { %>
                    <a href="User_DSSPController?maDanhMuc=<%=dm.getMaDanhMuc()%>"
                       class="<%= (selectedDM != null && selectedDM == dm.getMaDanhMuc() ? "active" : "") %>">
                        <%=dm.getTenDanhMuc()%>
                    </a>
                    <% } %>
                </div>

                <%
                    List<SanPham> sanPhamTheoDM =
                    (List<SanPham>) request.getAttribute("sanPhamTheoDM");
                %>

                <% if (sanPhamTheoDM != null) { %>

                <h3 class="category-title">Sản phẩm theo danh mục</h3>

                <div class="product-grid">

                    <% for (SanPham sp : sanPhamTheoDM) { %>

                    <div class="card-product">

                        <div class="product-badge">
                            <% if (sp.getGiaKhuyenMai() > 0) { 
                                int percent = (int) (100 - (sp.getGiaKhuyenMai() * 100 / sp.getGiaBan()));
                            %>
                            <div class="sale-badge">
                                <span class="percent">-<%=percent%>%</span>
                                <span class="label">GIẢM</span>
                            </div>
                            <% } else { %>
                            <div class="new-badge">NEW</div>
                            <% } %>
                        </div>

                        <a href="User_ChiTietSPController?maSP=<%=sp.getMaSanPham()%>">
                            <img src="<%=sp.getDuongDanAnh()%>">
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
                                <% if (sp.getGiaKhuyenMai() > 0) { %>
                                <span class="old-price">
                                    <%= String.format("%,.0f", sp.getGiaBan()) %> ₫
                                </span>
                                <span class="price">
                                    <%= String.format("%,.0f", sp.getGiaKhuyenMai()) %> ₫
                                </span>
                                <% } else { %>
                                <span class="old-price invisible">0</span>
                                <span class="price">
                                    <%= String.format("%,.0f", sp.getGiaBan()) %> ₫
                                </span>
                                <% } %>
                            </div>

                            <div class="product-actions">

                                <% if (user != null) { %>

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

                    <% } %>

                </div>

                <% } %>
                <h3 class="category-title">Tất cả sản phẩm</h3>

                <div class="product-grid">

                    <%
                        if (tatCaSanPham != null && !tatCaSanPham.isEmpty()) {

                            for (SanPham sp : tatCaSanPham) {

                    %>

                    <div class="card-product">

                        <div class="product-badge">
                            <% if (sp.getGiaKhuyenMai() > 0) { 
                                int percent = (int) (100 - (sp.getGiaKhuyenMai() * 100 / sp.getGiaBan()));
                            %>

                            <div class="sale-badge">
                                <span class="percent">-<%=percent%>%</span>
                                <span class="label">GIẢM</span>
                            </div>

                            <% } else { %>
                            <div class="new-badge">NEW</div>
                            <% } %>
                        </div>

                        <a href="User_ChiTietSPController?maSP=<%=sp.getMaSanPham()%>">
                            <img src="<%=sp.getDuongDanAnh()%>" alt="product">
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
                                <% if (sp.getGiaKhuyenMai() > 0) { %>
                                <span class="old-price">
                                    <%= String.format("%,.0f", sp.getGiaBan()) %> ₫
                                </span>
                                <span class="price">
                                    <%= String.format("%,.0f", sp.getGiaKhuyenMai()) %> ₫
                                </span>
                                <% } else { %>
                                <span class="old-price invisible">0</span>  
                                <span class="price">
                                    <%= String.format("%,.0f", sp.getGiaBan()) %> ₫
                                </span>
                                <% } %>
                            </div>

                            <div class="product-actions">

                                <% if (user != null) { %>

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

                                <a href="javascript:void(0)"
                                   onclick="yeuCauDangNhap()"
                                   class="btn btn-cart">

                                    <i class="bi bi-cart-plus"></i> Thêm vào giỏ
                                </a>

                                <a href="javascript:void(0)"
                                   onclick="yeuCauDangNhap()"
                                   class="btn btn-buy">

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

                    <div class="empty">
                        Không có sản phẩm nào
                    </div>

                    <%
                        }
                    %>

                </div><br>

                <%
                    Integer currentPage = (Integer) request.getAttribute("currentPage");
                    Integer totalPage = (Integer) request.getAttribute("totalPage");
                    String searchKeyword = (String) request.getAttribute("searchKeyword");
                %>

                <% if (currentPage != null && totalPage != null) { %>

                <div class="pagination-container">

                    <%
                        int maxPageShow = 10;
                        int startPage = Math.max(1, currentPage - maxPageShow / 2);
                        int endPage = startPage + maxPageShow - 1;

                        if (endPage > totalPage) {
                            endPage = totalPage;
                            startPage = Math.max(1, endPage - maxPageShow + 1);
                        }
                        
                        // Xử lý tham số bổ sung để giữ key tìm kiếm và danh mục
                        String extraParams = "";
                        if (searchKeyword != null && !searchKeyword.isEmpty()) {
                            extraParams += "&keyword=" + java.net.URLEncoder.encode(searchKeyword, "UTF-8");
                        }
                        if (selectedDM != null) {
                            extraParams += "&maDanhMuc=" + selectedDM;
                        }
                    %>

                    <nav>
                        <ul class="pagination justify-content-center">

                            <li class="page-item <%= (currentPage == 1 ? "disabled" : "") %>">
                                <a class="page-link" href="User_DSSPController?page=1<%= extraParams %>">⏮  Trang đầu </a>
                            </li>

                            <li class="page-item <%= (currentPage == 1 ? "disabled" : "") %>">
                                <a class="page-link" href="User_DSSPController?page=<%=currentPage-1%><%= extraParams %>">◀</a>
                            </li>

                            <% if (startPage > 1) { %>
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                                <% } %>

                            <% for(int i = startPage; i <= endPage; i++) { %>
                            <li class="page-item <%= (i == currentPage ? "active" : "") %>">
                                <a class="page-link" href="User_DSSPController?page=<%=i%><%= extraParams %>">
                                    <%=i%>
                                </a>
                            </li>
                            <% } %>

                            <% if (endPage < totalPage) { %>
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                                <% } %>

                            <li class="page-item <%= (currentPage == totalPage ? "disabled" : "") %>">
                                <a class="page-link" href="User_DSSPController?page=<%=currentPage+1%><%= extraParams %>">▶</a>
                            </li>

                            <li class="page-item <%= (currentPage == totalPage ? "disabled" : "") %>">
                                <a class="page-link" href="User_DSSPController?page=<%=totalPage%><%= extraParams %>">Trang cuối  ⏭</a>
                            </li>

                        </ul>
                    </nav>

                </div>
                <% } %>
            </div>

            <%@ include file="layout/footer.jsp" %>

        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                       function yeuCauDangNhap() {
                                           const modalEl = document.getElementById('loginRequiredModal');
                                           let modal = bootstrap.Modal.getInstance(modalEl);
                                           if (!modal) modal = new bootstrap.Modal(modalEl);
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

                                           const modalEl = document.getElementById('modalThemGio');
                                           let modal = bootstrap.Modal.getInstance(modalEl);
                                           if (!modal) modal = new bootstrap.Modal(modalEl);
                                           modal.show();
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
                                           if (input.value > 1) {
                                               input.value--;
                                           }
                                       }

                                       function xacNhanThemGio() {
                                           let sl = parseInt(document.getElementById("soLuongSP").value);

                                           if (isNaN(sl)) {
                                               alert("Vui lòng nhập số lượng!");
                                               return;
                                           }

                                           if (sl > max) {
                                               alert("Vượt tồn kho!");
                                               return;
                                           }

                                           if (sl < 1) {
                                               alert("Số lượng không hợp lệ!");
                                               return;
                                           }

                                           window.location =
                                                   "User_GioHangController?action=add&maSP=" + maSanPham + "&sl=" + sl;
                                       }


                                       function moModalMuaNgay(maSP, tenSP, anhSP, tonKho) {
                                           maSanPham = maSP;
                                           max = tonKho;

                                           document.getElementById("tenSanPhamModalMua").innerText = tenSP;
                                           document.getElementById("anhSanPhamModalMua").src = anhSP;
                                           document.getElementById("soLuongSPMua").value = 1;

                                           const modalEl = document.getElementById('modalMuaNgay');
                                           let modal = bootstrap.Modal.getInstance(modalEl);
                                           if (!modal) modal = new bootstrap.Modal(modalEl);
                                           modal.show();
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

                                           if (isNaN(sl)) {
                                               alert("Vui lòng nhập số lượng!");
                                               return;
                                           }

                                           if (sl > max) {
                                               alert("Vượt tồn kho!");
                                               return;
                                           }

                                           if (sl < 1) {
                                               alert("Số lượng không hợp lệ!");
                                               return;
                                           }

                                           window.location =
                                                   "User_ThanhToanController?type=buynow&maSP=" + maSanPham + "&sl=" + sl;
                                       }

                                       function checkSoLuong(input) {
                                           let val = parseInt(input.value) || 1;

                                           if (val > max) {
                                               alert("Vượt tồn kho!");
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
                        <button type="button"
                                class="btn-close"
                                data-bs-dismiss="modal">
                        </button>
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