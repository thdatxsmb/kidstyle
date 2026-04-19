<%-- 
    Document   : User_ThanhToan
    Created on : Mar 14, 2026, 5:10:20 PM
    Author     : LEGION 5
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.List"%>
<%@page import="Model.GioHang"%>

<%
    NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));

    List<GioHang> list = (List<GioHang>) request.getAttribute("list");
    Double tongTienObj = (Double) request.getAttribute("tongTien");
    double tongTienInitial = (tongTienObj != null) ? tongTienObj : 0.0;

    String error = (String) request.getAttribute("error");
    String diaChi = (String) request.getAttribute("diaChi");
    String ghiChu = (String) request.getAttribute("ghiChu");

    if (error == null) {
        error = "";
    }
    if (diaChi == null) {
        diaChi = "";
    }
    if (ghiChu == null) {
        ghiChu = "";
    }

    String bankId = "970415";
    String accountNo = "107876448186";
    String accountName = "KidStyle Shop";
    String addInfo = "THANH TOAN DON HANG " + (System.currentTimeMillis() % 1000000);
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xác nhận thanh toán</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user_thanhtoan.css">
    </head>

    <body>

        <%@ include file="../layout/header.jsp" %>
        <%@ include file="../layout/sidebar.jsp" %>

        <div class="main-content">

            <div class="container">
                <h2 class="text-center mb-5 text-danger fw-bold">
                    <i class="bi bi-credit-card-fill me-2"></i> Xác nhận thanh toán
                </h2>
                <% if (!error.isEmpty()) {%>
                <div class="alert alert-danger"><%= error%></div>
                <% } %>

                <div class="d-flex justify-content-end">
                    <a href="javascript:history.back()" 
                       class="btn btn-outline-secondary mb-3">
                        <i class="bi bi-arrow-left"></i> Quay lại
                    </a>
                </div>

                <div class="card shadow mb-4">
                    <div class="card-header bg-dark text-white">
                        <h5 class="mb-0"><i class="bi bi-cart-fill me-2"></i>Sản phẩm trong đơn hàng</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover text-center align-middle">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Ảnh</th>
                                        <th>Tên sản phẩm</th>
                                        <th>Giá</th>
                                        <th>Số lượng</th>
                                        <th>Tạm tính</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (list != null && !list.isEmpty()) {
                                            for (GioHang gh : list) {
                                                double gia = (gh.getGiaKhuyenMai() > 0) ? gh.getGiaKhuyenMai() : gh.getGiaBan();
                                                double tamTinh = gia * gh.getSoLuong();
                                    %>
                                    <tr class="product-row" data-gia="<%= (long) gia%>" data-tonkho="<%= gh.getTonKho()%>">
                                        <td><img src="<%= gh.getDuongDanAnh()%>" alt="<%= gh.getTenSanPham()%>" width="80" class="img-thumbnail rounded"></td>
                                        <td><%= gh.getTenSanPham()%></td>
                                        <td><%= nf.format(gia)%></td>
                                        <td>
                                            <div class="d-flex justify-content-center align-items-center">
                                                <button type="button" class="btn btn-sm btn-secondary" onclick="giamSL(this)">-</button>

                                                <input type="number"
                                                       class="form-control text-center mx-2 soLuongInput"
                                                       value="<%= gh.getSoLuong()%>"
                                                       min="1"
                                                       style="width:70px"
                                                       oninput="kiemTraSoLuong(this)">

                                                <button type="button" class="btn btn-sm btn-secondary" onclick="tangSL(this)">+</button>
                                            </div>
                                        </td>                                    
                                        <td class="text-danger fw-bold tamTinh">
                                            <%= nf.format(tamTinh)%>
                                        </td>
                                    </tr>
                                    <% }
                                    } else { %>
                                    <tr><td colspan="5" class="text-center py-4">Không có sản phẩm</td></tr>
                                    <% }%>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="card shadow mb-4">
                    <div class="card-body text-end total">
                        <span class="fw-bold">Tổng tiền:</span> 
                        <span id="tongTien" class="text-danger fw-bold fs-4">
                            <%= nf.format(tongTienInitial)%>
                        </span>
                    </div>
                </div>

                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="bi bi-truck me-2"></i>Thông tin giao hàng & thanh toán</h5>
                    </div>
                    <div class="card-body">
                        <form action="User_ThanhToanController" method="post" id="paymentForm">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Địa chỉ nhận hàng <span class="text-danger">*</span></label>
                                <input type="text" name="diaChi" class="form-control shadow-sm" required value="<%= diaChi%>" placeholder="Số nhà, đường, phường/xã, quận/huyện...">
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Ghi chú cho người bán</label>
                                <textarea name="ghiChu" class="form-control shadow-sm" rows="3" placeholder="Ví dụ: Giao hàng sau 14h, gọi trước khi giao..."><%= ghiChu%></textarea>
                            </div>
                            <div class="mb-4">
                                <label class="form-label fw-bold">Phương thức thanh toán</label>
                                <div class="d-flex flex-column gap-2">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="phuongThuc" id="cod" value="COD" checked>
                                        <label class="form-check-label" for="cod"><i class="bi bi-cash me-2"></i>Thanh toán khi nhận hàng (COD)</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="phuongThuc" id="bank" value="Bank">
                                        <label class="form-check-label" for="bank"><i class="bi bi-bank me-2"></i>Chuyển khoản ngân hàng (QR Code)</label>
                                    </div>
                                </div>
                            </div>

                            <div id="qrSection" >
                                <h5 class="text-primary mb-3">Quét mã QR để chuyển khoản</h5>
                                <p class="text-muted">
                                    Số tiền : <strong id="soTienQR"><%= nf.format(tongTienInitial)%></strong>
                                </p>
                                <img id="qrImage" src="" alt="Mã QR VietinBank" class="img-fluid" >
                                <p class="mt-3 small text-danger fw-bold">
                                    Vui lòng kiểm tra kỹ đơn đặt hàng. <br>
                                    VietinBank: NGUYEN THANH DAT - 107876448186
                                </p>
                                <p class="small text-muted">
                                    Điền đầy đủ thông tin đơn hàng và kiểm tra thông tin khi thanh toán nhé ! <br>
                                    KidStyle Shop cảm ơn đã ủng hộ !
                                </p>
                            </div>


                            <div class="d-flex gap-3 mt-4">
                                <button type="button"
                                        class="btn btn-outline-secondary btn-lg flex-fill"
                                        onclick="if (confirm('Bạn có chắc muốn hủy và quay về trang chủ?')) {
                                                    window.location.href = '${pageContext.request.contextPath}/User_DSSPController';
                                                }">
                                    <i class="bi bi-x-circle me-2"></i> Hủy thanh toán
                                </button>

                                <button type="submit" class="btn btn-danger btn-lg flex-fill fw-bold">
                                    <i class="bi bi-check-circle-fill me-2"></i> ĐẶT HÀNG NGAY
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const bankRadio = document.getElementById('bank');
        const codRadio = document.getElementById('cod');
        const qrSection = document.getElementById('qrSection');

        function toggleQR() {
            if (bankRadio.checked) {
                qrSection.style.display = 'block';
                capNhatTien();
            } else {
                qrSection.style.display = 'none';
            }
        }

        bankRadio.addEventListener('change', toggleQR);
        codRadio.addEventListener('change', toggleQR);

        toggleQR();
        capNhatTien();
    });

    function tangSL(btn) {
        let row = btn.closest(".product-row");
        let input = row.querySelector(".soLuongInput");
        let tonKho = Number(row.dataset.tonkho);
        let current = Number(input.value);

        if (current >= tonKho) {
            alert("Số lượng trong kho chỉ còn " + tonKho + " sản phẩm!");
            return;
        }

        input.value = current + 1;
        capNhatTien();
    }

    function giamSL(btn) {
        let row = btn.closest(".product-row");
        let input = row.querySelector(".soLuongInput");
        let current = Number(input.value);

        if (current > 1) {
            input.value = current - 1;
            capNhatTien();
        }
    }

    function kiemTraSoLuong(input) {
        let row = input.closest(".product-row");
        let tonKho = Number(row.dataset.tonkho);
        let value = parseInt(input.value);

        if (isNaN(value) || value < 1) {
            return;
        }

        if (value > tonKho) {
            alert("Rất tiếc! Số lượng trong kho chỉ còn " + tonKho + " sản phẩm!");
            input.value = tonKho;
        }
        capNhatTien();
    }

    document.querySelectorAll('.soLuongInput').forEach(el => {
        el.addEventListener('blur', function () {
            if (this.value === "" || parseInt(this.value) < 1) {
                this.value = 1;
                capNhatTien();
            }
        });
    });

    function capNhatTien() {
        let rows = document.querySelectorAll(".product-row");
        let tong = 0;

        rows.forEach(row => {
            let gia = Number(row.dataset.gia);
            let input = row.querySelector(".soLuongInput");
            let sl = parseInt(input.value) || 0;

            let tamTinh = gia * sl;
            row.querySelector(".tamTinh").innerText = tamTinh.toLocaleString('vi-VN') + " ₫";
            tong += tamTinh;
        });

        document.getElementById("tongTien").innerText = tong.toLocaleString('vi-VN') + " ₫";

        if (document.getElementById('bank').checked) {
            document.getElementById("soTienQR").innerText = tong.toLocaleString('vi-VN') + " ₫";
            capNhatQR(tong);
        }
    }

    let qrTimeout;
    function capNhatQR(tong) {
        clearTimeout(qrTimeout);
        qrTimeout = setTimeout(() => {
            let qr = document.getElementById("qrImage");
            if (!qr)
                return;

            let amount = Math.round(tong);
            fetch("https://api.vietqr.io/v2/generate", {
                method: "POST",
                headers: {"Content-Type": "application/json"},
                body: JSON.stringify({
                    accountNo: "<%= accountNo%>",
                    accountName: "<%= accountName%>",
                    acqId: "<%= bankId%>",
                    amount: amount,
                    addInfo: "<%= addInfo%>",
                    format: "text",
                    template: "compact"
                })
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data && data.data) {
                            qr.src = data.data.qrDataURL;
                        }
                    })
                    .catch(err => console.error("Lỗi cập nhật QR:", err));
        }, 400);
    }
</script>