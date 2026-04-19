<%-- 
    Document   : admin_QuanLyKhuyenMai
    Created on : Mar 17, 2026, 3:37:57 PM
    Author     : LEGION 5
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.KhuyenMai, Model.SanPham, Model.DanhMuc, java.util.*, java.text.SimpleDateFormat"%>
<%
    List<KhuyenMai> list = (List<KhuyenMai>) request.getAttribute("listKM");
    List<SanPham> listSP = (List<SanPham>) request.getAttribute("listSP");
    List<DanhMuc> listDM = (List<DanhMuc>) request.getAttribute("listDM");

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfInput = new SimpleDateFormat("yyyy-MM-dd");
    Date now = new Date();

    // Xử lý thông báo (nếu có bổ sung trong Controller sau này)
    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("success");
    session.removeAttribute("error");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý khuyến mãi - KidStyle Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home_admin.css">
    </head>
    <body class="bg-light">
        <%@ include file="layout/header_admin.jsp" %>
        <%@ include file="layout/sidebar_admin.jsp" %>

        <div class="main-content" id="mainContent">
            <div class="container-fluid py-4">

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="fw-bold m-0"><i class="bi bi-gift-fill me-2 text-primary"></i>Quản lý khuyến mãi</h4>
                        <p class="text-muted small m-0 mt-1">Thiết lập và theo dõi các chương trình ưu đãi của cửa hàng</p>
                    </div>

                    <div class="d-flex align-items-center gap-2">
                        <div class="input-group" style="width: 320px;">
                            <span class="input-group-text bg-white border-end-0"><i class="bi bi-search"></i></span>
                            <input type="text" id="searchInput" class="form-control border-start-0 ps-0"
                                   placeholder="Tìm kiếm chương trình..." onkeyup="searchTable()">
                        </div>
                        <a href="Admin_QuanLyKhuyenMaiController?action=sync" class="btn btn-outline-primary fw-semibold">
                            <i class="bi bi-arrow-clockwise"></i> Đồng bộ giá
                        </a>
                        <button class="btn btn-success fw-semibold" onclick="openAddModal()">
                            <i class="bi bi-plus-lg"></i> Thêm mới
                        </button>
                    </div>
                </div>

                <% if (success != null) {%>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i><%= success%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>
                <% if (error != null) {%>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i><%= error%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>

                <div class="card shadow-sm border-0">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0 text-center" id="promotionTable">
                                <thead class="table-dark">
                                    <tr>
                                        <th width="60">ID</th>
                                        <th class="text-start">Chương trình</th>
                                        <th>Áp dụng</th>
                                        <th>Mức giảm</th>
                                        <th>Giảm tối đa</th>
                                        <th>Thời gian</th>
                                        <th>Trạng thái</th>
                                        <th width="120">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (list != null && !list.isEmpty()) {
                                            for (KhuyenMai km : list) {
                                                String sttLabel = "Đang chạy";
                                                String sttClass = "bg-success-subtle text-success border border-success-subtle";
                                                if ("HeThan".equals(km.getTrangThai())) {
                                                    sttLabel = "Hết hạn";
                                                    sttClass = "bg-danger-subtle text-danger border border-danger-subtle";
                                                } else if (now.before(km.getNgayBatDau())) {
                                                    sttLabel = "Sắp tới";
                                                    sttClass = "bg-warning-subtle text-warning border border-warning-subtle";
                                                }
                                    %>
                                    <tr data-search="<%= km.getTenKhuyenMai()%>">
                                        <td class="text-muted"><%= km.getMaKhuyenMai()%></td>
                                        <td class="text-start">
                                            <div class="fw-bold"><%= km.getTenKhuyenMai()%></div>
                                        </td>
                                        <td>
                                            <% if (km.getMaSanPham() > 0) {%>
                                            <span class="text-primary small"><i class="bi bi-box me-1"></i><%= km.getTenSanPham()%></span>
                                                <% } else if (km.getMaDanhMuc() > 0) {%>
                                            <span class="text-warning small"><i class="bi bi-folder-fill me-1"></i><%= km.getTenDanhMuc()%></span>
                                                <% } else { %>
                                            <span class="text-secondary small"><i class="bi bi-shop me-1"></i>Toàn shop</span>
                                            <% }%>
                                        </td>
                                        <td class="fw-bold text-danger">-<%= km.getPhanTramGiam()%>%</td>
                                        <td class="text-muted"><%= String.format("%,.0f", km.getGiaTriGiam())%> ₫</td>
                                        <td class="small">
                                            <div><%= sdf.format(km.getNgayBatDau())%></div>
                                            <div class="text-muted opacity-75"><%= sdf.format(km.getNgayKetThuc())%></div>
                                        </td>
                                        <td>
                                            <span class="badge px-3 py-2 <%= sttClass%>" style="font-size: 11px;"><%= sttLabel%></span>
                                        </td>
                                        <td>
                                            <button class="btn btn-sm btn-warning me-1" 
                                                    onclick="openEditModal('<%= km.getMaKhuyenMai()%>', '<%= km.getTenKhuyenMai()%>', '<%= km.getPhanTramGiam()%>', '<%= km.getGiaTriGiam()%>', '<%= sdfInput.format(km.getNgayBatDau())%>', '<%= sdfInput.format(km.getNgayKetThuc())%>', '<%= km.getMaSanPham()%>', '<%= km.getMaDanhMuc()%>')">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger" onclick="confirmDelete(<%= km.getMaKhuyenMai()%>, '<%= km.getTenKhuyenMai()%>')">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <% }
                                    } else { %>
                                    <tr>
                                        <td colspan="8" class="text-center py-5 text-muted">Chưa có dữ liệu khuyến mãi</td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="kmModal" tabindex="-1">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content shadow">
                    <form id="kmForm" action="Admin_QuanLyKhuyenMaiController" method="post">
                        <input type="hidden" name="action" id="formAction" value="add">
                        <input type="hidden" name="id" id="kmId">

                        <div class="modal-header border-bottom">
                            <h5 class="modal-title fw-bold" id="modalTitle"><i class="bi bi-plus-circle me-2"></i>Thêm khuyến mãi mới</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body p-4">
                            <div class="row g-3">
                                <div class="col-12">
                                    <label class="form-label fw-semibold">Tên chương trình <span class="text-danger">*</span></label>
                                    <input type="text" name="ten" id="kmTen" class="form-control" placeholder="Nhập tên khuyến mãi..." required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold"><i class="bi bi-box me-1"></i>Áp dụng cho SP</label>
                                    <select name="maSP" id="kmMaSP" class="form-select bg-light" onchange="khiChon('sp')">
                                        <option value="0">--- Chọn sản phẩm ---</option>
                                        <% if (listSP != null) {
                                                for (SanPham sp : listSP) {%>
                                        <option value="<%= sp.getMaSanPham()%>"><%= sp.getTenSanPham()%></option>
                                        <% }
                                            } %>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold"><i class="bi bi-folder me-1"></i>Áp dụng cho Danh mục</label>
                                    <select name="maDM" id="kmMaDM" class="form-select bg-light" onchange="khiChon('dm')">
                                        <option value="0">--- Chọn danh mục ---</option>
                                        <% if (listDM != null) {
                                                for (DanhMuc dm : listDM) {%>
                                        <option value="<%= dm.getMaDanhMuc()%>"><%= dm.getTenDanhMuc()%></option>
                                        <% }
                                            }%>
                                    </select>
                                </div>
                                <div class="col-12 small text-muted"><i class="bi bi-info-circle me-1"></i>Ưu tiên chọn 1 trong 2. Bỏ trống cả 2 để áp dụng Toàn Shop.</div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Phần trăm giảm (%) <span class="text-danger">*</span></label>
                                    <input type="number" name="phanTram" id="kmPhanTram" class="form-control" min="1" max="100" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Giảm tối đa (đ) <span class="text-danger">*</span></label>
                                    <input type="number" name="giaTri" id="kmGiaTri" class="form-control" min="0" value="0" required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Từ ngày <span class="text-danger">*</span></label>
                                    <input type="date" name="batDau" id="kmBatDau" class="form-control" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Đến ngày <span class="text-danger">*</span></label>
                                    <input type="date" name="ketThuc" id="kmKetThuc" class="form-control" required>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer border-top">
                            <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary px-4 fw-bold">Xác nhận</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="modal fade" id="deleteModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content shadow">
                    <div class="modal-header bg-danger text-white border-0">
                        <h5 class="modal-title fw-bold"><i class="bi bi-trash-fill me-2"></i>Xác nhận xóa</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body py-4">
                        <p class="mb-2">Bạn có chắc chắn muốn xóa khuyến mãi:</p>
                        <p class="fw-bold text-danger mb-0" id="deleteName"></p>
                        <small class="text-muted">Hệ thống sẽ đồng bộ lại toàn bộ giá sản phẩm sau khi xóa.</small>
                    </div>
                    <div class="modal-footer border-0">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <a href="#" id="confirmDeleteBtn" class="btn btn-danger px-4 fw-bold">Xóa ngay</a>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                        const modalKm = new bootstrap.Modal(document.getElementById('kmModal'));
                                        const modalDelete = new bootstrap.Modal(document.getElementById('deleteModal'));

                                        function searchTable() {
                                            let input = document.getElementById("searchInput").value.toLowerCase();
                                            let rows = document.querySelectorAll("#promotionTable tbody tr");
                                            rows.forEach(row => {
                                                let text = row.getAttribute("data-search") ? row.getAttribute("data-search").toLowerCase() : "";
                                                row.style.display = text.includes(input) ? "" : "none";
                                            });
                                        }

                                        function khiChon(loai) {
                                            if (loai === 'sp')
                                                document.getElementById('kmMaDM').value = "0";
                                            else
                                                document.getElementById('kmMaSP').value = "0";
                                        }

                                        function openAddModal() {
                                            document.getElementById('modalTitle').innerHTML = '<i class="bi bi-plus-circle me-2"></i>Thêm khuyến mãi mới';
                                            document.getElementById('formAction').value = "add";
                                            document.getElementById('kmForm').reset();
                                            modalKm.show();
                                        }

                                        function openEditModal(id, ten, pt, gt, bd, kt, sp, dm) {
                                            document.getElementById('modalTitle').innerHTML = '<i class="bi bi-pencil-square me-2"></i>Chỉnh sửa khuyến mãi';
                                            document.getElementById('formAction').value = "edit";
                                            document.getElementById('kmId').value = id;
                                            document.getElementById('kmTen').value = ten;
                                            document.getElementById('kmPhanTram').value = pt;
                                            document.getElementById('kmGiaTri').value = gt;
                                            document.getElementById('kmBatDau').value = bd;
                                            document.getElementById('kmKetThuc').value = kt;
                                            document.getElementById('kmMaSP').value = (sp && sp !== "-1") ? sp : "0";
                                            document.getElementById('kmMaDM').value = (dm && dm !== "-1") ? dm : "0";
                                            modalKm.show();
                                        }

                                        function confirmDelete(id, ten) {
                                            document.getElementById('deleteName').innerText = ten;
                                            document.getElementById('confirmDeleteBtn').href = "Admin_QuanLyKhuyenMaiController?action=delete&id=" + id;
                                            modalDelete.show();
                                        }
        </script>
    </body>
</html>