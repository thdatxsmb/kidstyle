<%-- 
    Document   : User_DonHang
    Created on : Mar 15, 2026
    Author     : LEGION 5
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Model.DonHang"%>
<%@page import="Model.User"%>
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

    List<DonHang> danhSachDonHang = (List<DonHang>) request.getAttribute("danhSachDonHang");
    String errorMsg = (String) session.getAttribute("errorMsg");
    session.removeAttribute("errorMsg");

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    nf.setMaximumFractionDigits(0);
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đơn hàng của tôi - KidStyle</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user_donhang.css">
    </head>
    <body>
        <%@ include file="layout/header.jsp" %>
        <%@ include file="layout/sidebar.jsp" %>
        <div class="sidebar-backdrop" id="sidebarBackdrop"></div>

        <div class="main-content">
            <div class="container">
                <div class="order-detail">

                    <h2 class="order-title fw-bold">
                        <i class="bi bi-bag-check me-2"></i>
                        Đơn hàng của tôi
                    </h2>

                    <% if (errorMsg != null && !errorMsg.trim().isEmpty()) {%>
                    <div class="alert alert-danger text-center mb-4">
                        <%= errorMsg%>
                    </div>
                    <% } %>

                    <% if (danhSachDonHang == null || danhSachDonHang.isEmpty()) { %>

                    <div class="empty-state text-center py-5">
                        <i class="bi bi-receipt-cutoff empty-icon"></i>
                        <h4 class="empty-title">Bạn chưa có đơn hàng nào</h4>
                        <p class="empty-text">
                            Khi bạn đặt hàng, danh sách đơn hàng sẽ hiển thị tại đây.
                        </p>
                        <a href="User_DSSPController" class="btn btn-primary px-4 py-2">
                            <i class="bi bi-cart-plus me-2"></i>
                            Mua sắm ngay
                        </a>
                    </div>

                    <% } else {%>

                    <div class="card-order">

                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5>
                                <i class="bi bi-list-check me-2 text-primary"></i>
                                Danh sách đơn hàng
                            </h5>

                            <span class="badge bg-primary">
                                <%= danhSachDonHang.size()%> đơn
                            </span>
                        </div>

                        <div class="table-responsive">

                            <table class="table table-hover align-middle mb-0">

                                <thead>

                                    <tr>
                                        <th style="width:100px">Mã ĐH</th>
                                        <th>Ngày đặt</th>
                                        <th>Sản phẩm</th>
                                        <th>Tổng tiền</th>
                                        <th>Trạng thái</th>
                                        <th>Thanh toán</th>
                                        <th>Chi tiết</th>
                                    </tr>

                                </thead>

                                <tbody>
                                    <%
                                        for (DonHang dh : danhSachDonHang) {

                                            String statusClass = "status-default";
                                            String statusText = dh.getTrangThai();

                                            String hoan = dh.getTrangThaiHoan();

                                            if ("ChoDuyet".equals(hoan)) {
                                                statusText = "Đang chờ duyệt hoàn";
                                                statusClass = "status-return";
                                            } else if ("DaDuyet".equals(hoan)) {
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

                                    <tr>

                                        <td class="fw-semibold text-dark">
                                            #<%= dh.getMaDonHang()%>
                                        </td>

                                        <td class="order-date text-muted">
                                            <i class="bi bi-calendar3 me-1"></i>
                                            <%= sdf.format(dh.getNgayDatHang())%>
                                        </td>

                                        <td>
                                            <div class="d-flex align-items-center gap-2">

                                                <img src="<%= dh.getDuongDanAnh()%>" 
                                                     style="width:50px;height:50px;object-fit:cover;border-radius:8px;">

                                                <div style="max-width:280px">
                                                    <div class="fw-semibold">
                                                        <%= dh.getTenSanPham()%>
                                                    </div>
                                                </div>

                                            </div>
                                        </td>
                                        <td class="order-money text-danger fw-semibold">
                                            <%= nf.format(dh.getTongTien())%>
                                        </td>

                                        <td>
                                            <span class="order-status <%= statusClass%>">

                                                <% String tt = dh.getTrangThai(); %>
                                                <% String hoanTT = dh.getTrangThaiHoan(); %>

                                                <%-- ICON THEO TRẠNG THÁI ĐƠN --%>
                                                <% if ("ChoXacNhan".equals(tt)) { %>
                                                <i class="bi bi-hourglass-split"></i>
                                                <% } else if ("DaXacNhan".equals(tt)) { %>
                                                <i class="bi bi-check-circle"></i>
                                                <% } else if ("DangGiao".equals(tt)) { %>
                                                <i class="bi bi-truck"></i>
                                                <% } else if ("DaGiao".equals(tt)) { %>
                                                <i class="bi bi-bag-check"></i>
                                                <% } else if ("DaHuy".equals(tt)) { %>
                                                <i class="bi bi-x-circle-fill"></i>
                                                <% } %>

                                                <%-- ICON TRẠNG THÁI HOÀN ƯU TIÊN HIỂN THỊ --%>
                                                <% if ("ChoDuyet".equals(hoanTT)) { %>
                                                <i class="bi bi-arrow-repeat"></i>
                                                <% } else if ("DaDuyet".equals(hoanTT)) { %>
                                                <i class="bi bi-check2-all"></i>
                                                <% } else if ("TuChoi".equals(hoanTT)) { %>
                                                <i class="bi bi-x-octagon"></i>
                                                <% }%>

                                                <%= statusText%>
                                            </span>

                                        </td>

                                        <td>
                                            <%
                                                String pt = dh.getPhuongThucThanhToan();
                                            %>

                                            <% if ("COD".equals(pt)) { %>
                                            <span class="payment-badge cod">
                                                <i class="bi bi-cash-coin"></i> COD
                                            </span>
                                            <% } else if ("Bank".equals(pt)) { %>
                                            <span class="payment-badge bank">
                                                <i class="bi bi-credit-card me-1"></i> Chuyển khoản
                                            </span>
                                            <% } else { %>
                                            <span class="payment-badge other">
                                                <i class="bi bi-credit-card"></i> —
                                            </span>
                                            <% }%>
                                        </td>
                                        <td>
                                            <%
                                                String trangThaiDon = dh.getTrangThai();
                                                String trangThaiHoan = dh.getTrangThaiHoan();

                                                boolean choPhepHuy = ("ChoXacNhan".equals(trangThaiDon) || "DaXacNhan".equals(trangThaiDon))
                                                        && (trangThaiHoan == null || "TuChoi".equals(trangThaiHoan));

                                                boolean choPhepHoan = "DaGiao".equals(trangThaiDon)
                                                        && (trangThaiHoan == null || "TuChoi".equals(trangThaiHoan));

                                                boolean choPhepMuaLai = "DaGiao".equals(trangThaiDon);
                                            %>

                                            <div class="action-group">
                                                <a href="User_ChiTietDonHangController?id=<%= dh.getMaDonHang()%>" 
                                                   class="btn btn-view" title="Xem chi tiết">
                                                    <i class="bi bi-eye"></i>
                                                </a>

                                                <button type="button" 
                                                        class="btn btn-cancel"
                                                        onclick="openHuy(<%= dh.getMaDonHang()%>)"
                                                        <%= choPhepHuy ? "" : "disabled"%> 
                                                        title="Hủy đơn hàng">
                                                    <i class="bi bi-x-circle"></i>
                                                </button>

                                                <button type="button" 
                                                        class="btn btn-return"
                                                        onclick="openHoan(<%= dh.getMaDonHang()%>)"
                                                        <%= choPhepHoan ? "" : "disabled"%> 
                                                        title="Yêu cầu hoàn hàng">
                                                    <i class="bi bi-arrow-return-left"></i>
                                                </button>

                                                <button type="button" 
                                                        class="btn btn-rebuy"
                                                        onclick="openMuaLai(<%= dh.getMaDonHang()%>, <%= dh.getMaSanPham()%>, '<%= dh.getTenSanPham()%>', '<%= dh.getDuongDanAnh()%>')"
                                                        <%= choPhepMuaLai ? "" : "disabled"%> 
                                                        title="Mua lại sản phẩm">
                                                    <i class="bi bi-cart-plus"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>

                                    <% } %>

                                </tbody>

                            </table>

                        </div>

                    </div>

                    <% }%>

                </div>
            </div>

            <%@ include file="layout/footer.jsp" %>
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