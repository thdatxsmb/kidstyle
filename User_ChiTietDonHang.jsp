<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Model.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate, max-age=0");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("Login.jsp");
        return;
    }

    DonHang donHang = (DonHang) request.getAttribute("donHang");
    List<ChiTietDonHang> chiTietList = (List<ChiTietDonHang>) request.getAttribute("chiTietList");

    if (donHang == null) {
        response.sendRedirect("User_DonHangController");
        return;
    }

    if (chiTietList == null) {
        chiTietList = new java.util.ArrayList<>();
    }

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    nf.setMaximumFractionDigits(0);

    String statusClass = "status-default";
    String statusText = donHang.getTrangThai();

    String trangThaiHoan = donHang.getTrangThaiHoan();

    if ("ChoDuyet".equals(trangThaiHoan)) {
        statusText = "Đang chờ duyệt hoàn";
        statusClass = "status-return";
    } else if ("DaDuyet".equals(trangThaiHoan)) {
        statusText = "Đã hoàn";
        statusClass = "status-return-done";
    } else {
        switch (statusText) {
            case "ChoXacNhan":
                statusClass = "status-pending";
                statusText = "Chờ xác nhận";
                break;
            case "DaXacNhan":
                statusClass = "status-confirmed";
                statusText = "Đã xác nhận";
                break;
            case "DangGiao":
                statusClass = "status-shipping";
                statusText = "Đang giao";
                break;
            case "DaGiao":
                statusClass = "status-done";
                statusText = "Đã giao";
                break;
            case "DaHuy":
                statusClass = "status-cancel";
                statusText = "Đã hủy";
                break;
        }
    }
%>


<%
    String trangThai = donHang.getTrangThai();
    String lyDo = donHang.getLyDo();
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết đơn #<%= donHang.getMaDonHang()%></title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user_donhang.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user_chitietdonhang.css">
    </head>

    <body>

        <%@ include file="layout/header.jsp" %>
        <%@ include file="layout/sidebar.jsp" %>
        
        <div class="sidebar-backdrop" id="sidebarBackdrop"></div>

        <div class="main-content">
            <div class="container py-4">
                <div class="order-header">
                    <h2>
                        <i class="bi bi-receipt"></i>
                        Đơn hàng #<%= donHang.getMaDonHang()%>
                    </h2>
                    <div class="order-actions">
                        <%
                            String tt = donHang.getTrangThai();
                            String tth = donHang.getTrangThaiHoan();

                            boolean choPhepHuy = ("ChoXacNhan".equals(tt) || "DaXacNhan".equals(tt))
                                    && (tth == null || "TuChoi".equals(tth));

                            boolean choPhepHoan = "DaGiao".equals(tt)
                                    && (tth == null || "TuChoi".equals(tth));

                            boolean choPhepMuaLai = "DaGiao".equals(tt);
                        %>

                        <% if (choPhepHuy) {%>
                        <button type="button" class="btn btn-cancel"
                                onclick="openHuy(<%= donHang.getMaDonHang()%>)">
                            <i class="bi bi-x-circle"></i> Hủy
                        </button>
                        <% } %>

                        <% if (choPhepHoan) {%>
                        <button type="button" class="btn btn-return"
                                onclick="openHoan(<%= donHang.getMaDonHang()%>)">
                            <i class="bi bi-arrow-return-left"></i> Hoàn
                        </button>
                        <% } %>

                        <% if (choPhepMuaLai && !chiTietList.isEmpty()) {
                                ChiTietDonHang sp = chiTietList.get(0);%>
                        <button type="button" class="btn btn-rebuy"
                                onclick="openMuaLai(
                                <%= donHang.getMaDonHang()%>,
                                <%= sp.getMaSanPham()%>,
                                                '<%= sp.getTenSanPham()%>',
                                                '<%= sp.getDuongDanAnh()%>')">
                            <i class="bi bi-cart-plus"></i> Mua lại
                        </button>
                        <% }%>

                        <a href="User_DonHangController" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left"></i> Quay lại
                        </a>
                    </div>
                </div>

                <div class="card order-info mb-4">
                    <div class="card-header d-flex justify-content-between">
                        <h5><i class="bi bi-info-circle"></i> Thông tin đơn hàng</h5>
                        <span class="order-status <%= statusClass%>">
                            <% if ("ChoXacNhan".equals(tt)) { %>
                            <i class="bi bi-hourglass-split"></i>
                            <% } else if ("DaXacNhan".equals(tt)) { %>
                            <i class="bi bi-check-circle"></i>
                            <% } else if ("DangGiao".equals(tt)) { %>
                            <i class="bi bi-truck"></i>
                            <% } else if ("DaGiao".equals(tt)) { %>
                            <i class="bi bi-bag-check"></i>
                            <% } else if ("DaHuy".equals(tt)) { %>
                            <i class="bi bi-x-circle-fill me-1"></i>
                            <% } %>

                            <% if ("ChoDuyet".equals(trangThaiHoan)) { %>
                            <i class="bi bi-arrow-repeat"></i>
                            <% } else if ("DaDuyet".equals(trangThaiHoan)) { %>
                            <i class="bi bi-check2-all"></i>
                            <% } else if ("TuChoi".equals(trangThaiHoan)) { %>
                            <i class="bi bi-x-octagon"></i>
                            <% }%>
                            <%= statusText%>
                        </span>
                    </div>

                    <div class="card mt-4">
                        <div class="card-body">
                            <% if ("ChoXacNhan".equals(tt)) { %>
                            <div class="alert alert-warning">
                                <h5>⏳ Đơn hàng đang chờ xác nhận</h5>
                                <p>Shop sẽ xác nhận đơn hàng của bạn sớm.</p>
                            </div>
                            <% } %>
                            <% if ("DaXacNhan".equals(tt)) { %>
                            <div class="alert alert-info">
                                <h5>✔ Đơn hàng đã được xác nhận</h5>
                                <p>Đơn hàng đang được chuẩn bị.</p>
                            </div>
                            <% } %>
                            <% if ("DangGiao".equals(tt)) { %>
                            <div class="alert alert-primary">
                                <h5>🚚 Đơn hàng đang giao</h5>
                                <p>Đơn hàng đang trên đường tới bạn.</p>
                            </div>
                            <% } %>
                            <% if ("DaGiao".equals(tt)) { %>
                            <div class="alert alert-success">
                                <h5>🎉 Đã giao hàng thành công</h5>
                                <p>Cảm ơn bạn đã mua hàng!</p>
                            </div>
                            <% } %>
                            <% if ("DaHuy".equals(tt)) {%>
                            <div class="alert alert-danger">
                                <h5>❌ Đơn hàng đã bị hủy</h5>
                                <p><strong>Lý do:</strong> <%= (donHang.getLyDo() != null && !donHang.getLyDo().trim().isEmpty()) ? donHang.getLyDo() : "Không có"%></p>
                            </div>
                            <% } %>

                            <% if ("ChoDuyet".equals(trangThaiHoan)) { %>
                            <div class="alert alert-warning">⏳ Yêu cầu hoàn hàng đang chờ duyệt</div>
                            <% } %>
                            <% if ("DaDuyet".equals(trangThaiHoan)) { %>
                            <div class="alert alert-success">✔ Đã hoàn hàng thành công</div>
                            <% } %>
                            <% if ("TuChoi".equals(trangThaiHoan)) { %>
                            <div class="alert alert-danger">❌ Yêu cầu hoàn bị từ chối</div>
                            <% }%>
                        </div>
                    </div>

                    <div class="card-body row">
                        <div class="col-md-6">
                            <p>
                                <i class="bi bi-calendar-event me-2 text-muted"></i>
                                <strong>Ngày đặt:</strong> <%= sdf.format(donHang.getNgayDatHang())%>
                            </p>

                            <p>
                                <i class="bi bi-credit-card me-2 text-muted"></i>
                                <strong>Thanh toán:</strong> <%= donHang.getPhuongThucThanhToan()%>
                            </p>

                            <p>
                                <i class="bi bi-cash-stack me-2 text-danger"></i>
                                <strong>Tổng tiền:</strong> 
                                <span class="text-danger fw-bold"><%= nf.format(donHang.getTongTien())%></span>
                            </p>
                        </div>

                        <div class="col-md-6">
                            <p>
                                <i class="bi bi-person me-2 text-muted"></i>
                                <strong>Người nhận:</strong> <%= donHang.getTenNguoiNhan()%>
                            </p>

                            <p>
                                <i class="bi bi-telephone me-2 text-muted"></i>
                                <strong>SĐT:</strong> <%= donHang.getSoDienThoaiNhan()%>
                            </p>

                            <p>
                                <i class="bi bi-geo-alt me-2 text-muted"></i>
                                <strong>Địa chỉ:</strong> <%= donHang.getDiaChiNhanHang()%>
                            </p>
                        </div>

                    </div>
                </div>

                <div class="card">
                    <div class="card-header d-flex justify-content-between">
                        <h5><i class="bi bi-box-seam"></i> Sản phẩm</h5>
                        <div class="order-meta">
                            <i class="bi bi-chat-left-text-fill text-primary"></i>
                            <span>Ghi chú: <%= (donHang.getGhiChu() != null && !donHang.getGhiChu().trim().isEmpty()) ? donHang.getGhiChu() : "Không có"%></span>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead>
                                <tr>
                                    <th>Ảnh</th>
                                    <th>Tên</th>
                                    <th>Giá</th>
                                    <th>SL</th>
                                    <th>Thành tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (ChiTietDonHang ct : chiTietList) {%>
                                <tr>
                                    <td><img src="<%= ct.getDuongDanAnh()%>" class="product-img"></td>
                                    <td class="fw-semibold"><%= ct.getTenSanPham()%></td>
                                    <td><%= nf.format(ct.getDonGia())%></td>
                                    <td><%= ct.getSoLuong()%></td>
                                    <td class="text-danger fw-bold"><%= nf.format(ct.getThanhTien())%></td>
                                </tr>
                                <% } %>
                                <% if (chiTietList.isEmpty()) { %>
                                <tr>
                                    <td colspan="5" class="text-center text-muted py-4">Không có sản phẩm</td>
                                </tr>
                                <% }%>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            function openHuy(id) {
                document.getElementById("huyId").value = id;
                document.getElementById("huyMa").innerText = "#" + id;
                new bootstrap.Modal(document.getElementById("modalHuy")).show();
            }

            function openHoan(id) {
                document.getElementById("hoanId").value = id;
                new bootstrap.Modal(document.getElementById("modalHoan")).show();
            }

            function openMuaLai(id, maSP, ten, anh) {
                document.getElementById("mualaiId").value = id;
                document.getElementById("maSanPhamMuaLai").value = maSP;

                document.getElementById("tenMuaLai").innerText = ten;
                document.getElementById("anhMuaLai").src = anh;

                new bootstrap.Modal(document.getElementById("modalMuaLai")).show();
            }

            function checkLyDo() {
                let val = document.getElementById("lyDoSelect").value;
                let input = document.getElementById("lyDoInput");

                if (val === "Khác") {
                    input.style.display = "block";
                    input.required = true;
                } else {
                    input.style.display = "none";
                    input.required = false;
                }
            }

            function checkLyDoHoan() {
                let val = document.getElementById("lyDoHoanSelect").value;
                let input = document.getElementById("lyDoHoanInput");

                if (val === "Khác") {
                    input.style.display = "block";
                    input.required = true;
                } else {
                    input.style.display = "none";
                    input.required = false;
                }
            }

            function tangSL() {
                let sl = document.getElementById("slMuaLai");
                sl.value = parseInt(sl.value) + 1;
            }

            function giamSL() {
                let sl = document.getElementById("slMuaLai");
                if (sl.value > 1)
                    sl.value--;
            }
        </script>

        <div class="modal fade" id="modalHuy" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <form action="User_DonHangController" method="post" class="modal-content p-3">

                    <input type="hidden" name="action" value="huy">
                    <input type="hidden" name="id" id="huyId">

                    <div class="modal-header">
                        <h5 class="modal-title text-danger">
                            <i class="bi bi-x-circle"></i> Hủy đơn hàng
                        </h5>
                    </div>

                    <div class="modal-body">

                        <p class="text-muted text-center">
                            Bạn có chắc muốn hủy đơn <b id="huyMa"></b>?
                        </p>

                        <select class="form-select mb-3" name="lyDo" id="lyDoSelect" onchange="checkLyDo()">
                            <option value="">-- Chọn lý do --</option>
                            <option value="Đổi ý không mua nữa">Đổi ý không mua nữa</option>
                            <option value="Đặt nhầm sản phẩm">Đặt nhầm sản phẩm</option>
                            <option value="Thời gian giao lâu">Thời gian giao lâu</option>
                            <option value="Khác">Khác</option>
                        </select>

                        <textarea name="lyDoKhac" id="lyDoInput"
                                  class="form-control"
                                  placeholder="Nhập lý do khác..."
                                  style="display:none;"></textarea>

                    </div>

                    <div class="modal-footer justify-content-center">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-danger">Xác nhận</button>
                    </div>

                </form>
            </div>
        </div>

        <div class="modal fade" id="modalHoan" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <form action="User_DonHangController" method="post" class="modal-content p-3">

                    <input type="hidden" name="action" value="hoan">
                    <input type="hidden" name="id" id="hoanId">

                    <div class="modal-header">
                        <h5 class="modal-title text-warning">
                            <i class="bi bi-arrow-repeat"></i> Yêu cầu hoàn hàng
                        </h5>
                    </div>

                    <div class="modal-body">

                        <p class="text-muted text-center">Chọn lý do hoàn hàng</p>

                        <select class="form-select mb-3" name="lyDo" id="lyDoHoanSelect" onchange="checkLyDoHoan()">
                            <option value="">-- Chọn lý do --</option>
                            <option value="Sản phẩm lỗi">Sản phẩm lỗi</option>
                            <option value="Không đúng mô tả">Không đúng mô tả</option>
                            <option value="Sai size">Sai size</option>
                            <option value="Khác">Khác</option>
                        </select>

                        <textarea name="lyDoKhac" id="lyDoHoanInput"
                                  class="form-control"
                                  placeholder="Nhập lý do khác..."
                                  style="display:none;"></textarea>

                    </div>

                    <div class="modal-footer justify-content-center">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-warning">Gửi yêu cầu</button>
                    </div>

                </form>
            </div>
        </div>


        <div class="modal fade" id="modalMuaLai" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <form action="User_DonHangController" method="post" class="modal-content p-3">

                    <input type="hidden" name="action" value="mualai">
                    <input type="hidden" name="id" id="mualaiId">
                    <input type="hidden" name="maSanPham" id="maSanPhamMuaLai">

                    <div class="modal-header">
                        <h5 class="modal-title text-primary">
                            <i class="bi bi-cart-plus"></i> Mua lại sản phẩm
                        </h5>
                    </div>

                    <div class="modal-body text-center">

                        <img id="anhMuaLai"
                             style="width:120px;height:120px;object-fit:cover;border-radius:10px;">

                        <h5 id="tenMuaLai" class="mt-2"></h5>

                        <div class="d-flex justify-content-center align-items-center mt-4 qty-box">
                            <button type="button" class="btn btn-secondary" onclick="giamSL()">–</button>

                            <input type="number" name="soLuong" id="slMuaLai"
                                   value="1" min="1"
                                   class="form-control text-center mx-2"
                                   style="width:80px;">

                            <button type="button" class="btn btn-secondary" onclick="tangSL()">+</button>
                        </div>

                    </div>

                    <div class="modal-footer justify-content-center">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-lightning-charge"></i> Thanh toán
                        </button>
                    </div>

                </form>
            </div>
        </div>

    </body>
</html>