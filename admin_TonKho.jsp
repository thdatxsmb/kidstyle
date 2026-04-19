<%-- 
    Document   : admin_TonKho
    Created on : Mar 29, 2026, 4:17:19 PM
    Author     : LEGION 5
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, Model.SanPham, Model.LichSuTonKho"%>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý tồn kho</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home_admin.css">

    </head>

    <body>

        <%@ include file="../layout/header_admin.jsp" %>
        <%@ include file="../layout/sidebar_admin.jsp" %>

        <div class="main-content" id="mainContent">
            <div class="container-fluid p-4">

                <%
                    List<SanPham> listSP = (List<SanPham>) request.getAttribute("danhSachSanPham");
                    List<LichSuTonKho> listLichSu = (List<LichSuTonKho>) request.getAttribute("danhSachLichSu");

                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

                    int tongSP = (listSP != null) ? listSP.size() : 0;
                    int sapHet = 0;
                    if (listSP != null) {
                        for (SanPham sp : listSP) if (sp.getTonKho() < 10) sapHet++;
                    }
                %>

                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4 class="fw-bold">📦 Quản lý tồn kho</h4>
                    <a href="Admin_TonKhoController" class="btn btn-outline-primary btn-sm">
                        <i class="bi bi-arrow-clockwise"></i> Reload
                    </a>
                </div>

                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="card text-center shadow-sm">
                            <div class="card-body">
                                <i class="bi bi-box fs-3 text-primary"></i>
                                <p class="mb-1">Tổng sản phẩm</p>
                                <h5 class="fw-bold text-primary"><%= tongSP %></h5>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card text-center shadow-sm">
                            <div class="card-body">
                                <i class="bi bi-exclamation-triangle fs-3 text-warning"></i>
                                <p class="mb-1">Sắp hết</p>
                                <h5 class="fw-bold text-warning"><%= sapHet %></h5>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card text-center shadow-sm">
                            <div class="card-body">
                                <i class="bi bi-clock-history fs-3 text-info"></i>
                                <p class="mb-1">Lịch sử</p>
                                <h5 class="fw-bold text-info"><%= (listLichSu != null) ? listLichSu.size() : 0 %></h5>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="input-group mb-4">
                    <span class="input-group-text"><i class="bi bi-search"></i></span>
                    <input type="text" id="searchInput" class="form-control" placeholder="Tìm sản phẩm...">
                </div>

                <div class="row">

                    <div class="col-lg-4">

                        <div class="card shadow-sm mb-3">
                            <div class="card-header bg-success text-white">Nhập hàng</div>
                            <div class="card-body">
                                <form action="Admin_TonKhoController" method="post">
                                    <input type="hidden" name="action" value="nhap">

                                    <select name="maSanPham" class="form-select mb-2">
                                        <% for (SanPham sp : listSP) { %>
                                        <option value="<%= sp.getMaSanPham() %>">
                                            <%= sp.getTenSanPham() %> (Tồn: <%= sp.getTonKho() %>)
                                        </option>
                                        <% } %>
                                    </select>

                                    <input type="number" name="soLuong" class="form-control mb-2" placeholder="Số lượng">
                                    <input type="number" name="donGiaNhap" class="form-control mb-2" placeholder="Đơn giá">

                                    <textarea name="ghiChu" class="form-control mb-2"></textarea>

                                    <button class="btn btn-success w-100">Nhập</button>
                                </form>
                            </div>
                        </div>

                        <div class="card shadow-sm">
                            <div class="card-header bg-warning">Điều chỉnh</div>
                            <div class="card-body">
                                <form action="Admin_TonKhoController" method="post">
                                    <input type="hidden" name="action" value="dieuchinh">

                                    <select name="maSanPham" class="form-select mb-2">
                                        <% for (SanPham sp : listSP) { %>
                                        <option value="<%= sp.getMaSanPham() %>">
                                            <%= sp.getTenSanPham() %>
                                        </option>
                                        <% } %>
                                    </select>

                                    <input type="number" name="soLuong" class="form-control mb-2" placeholder="+ / -">

                                    <textarea name="ghiChu" class="form-control mb-2"></textarea>

                                    <button class="btn btn-warning w-100">Cập nhật</button>
                                </form>
                            </div>
                        </div>

                    </div>

                    <div class="col-lg-8">
                        <div class="card shadow-sm">
                            <div class="card-header bg-dark text-white">Danh sách tồn kho</div>

                            <div style="max-height: 400px; overflow-y: auto;">
                                <table class="table table-hover text-center mb-0" id="productTable">
                                    <thead class="table-light sticky-top">
                                        <tr>
                                            <th>ID</th>
                                            <th>Tên sản phẩm</th>
                                            <th>Tồn kho</th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <% for (SanPham sp : listSP) { %>
                                        <tr class="<%= sp.getTonKho() < 10 ? "table-danger" : "" %>">
                                            <td>#<%= sp.getMaSanPham() %></td>
                                            <td class="tenSP"><%= sp.getTenSanPham() %></td>
                                            <td class="fw-bold"><%= sp.getTonKho() %></td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>

                        </div>
                    </div>

                </div>

                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card shadow-sm">
                            <div class="card-header bg-primary text-white">Lịch sử kho</div>

                            <div style="max-height: 300px; overflow-y: auto;">
                                <table class="table table-sm table-bordered text-center mb-0">
                                    <thead class="table-light sticky-top">
                                        <tr>
                                            <th>Ngày</th>
                                            <th>Sản phẩm</th>
                                            <th>Loại</th>
                                            <th>Số lượng</th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <% for (LichSuTonKho log : listLichSu) { %>
                                        <tr>
                                            <td><%= (log.getNgayThayDoi()!=null)? sdf.format(log.getNgayThayDoi()):"" %></td>
                                            <td><%= log.getTenSanPham() %></td>
                                            <td>
                                                <span class="badge <%= "NHAP_HANG".equals(log.getLoaiThayDoi()) ? "bg-success" : "bg-warning text-dark" %>">
                                                    <%= "NHAP_HANG".equals(log.getLoaiThayDoi()) ? "Nhập hàng" : "Điều chỉnh" %>
                                                </span>
                                            </td>
                                            <td class="<%= log.getSoLuong()>0?"text-success":"text-danger" %>">
                                                <%= log.getSoLuong() %>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>

                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    document.getElementById("searchInput").addEventListener("keyup", function () {
                        let keyword = this.value.toLowerCase();
                        let rows = document.querySelectorAll("#productTable tbody tr");

                        rows.forEach(row => {
                            let name = row.querySelector(".tenSP").innerText.toLowerCase();
                            row.style.display = name.includes(keyword) ? "" : "none";
                        });
                    });
                </script>
            </div>
        </div>
    </body>
</html>