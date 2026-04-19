<%-- 
    Document   : admin_BaoCao
    Created on : Apr 9, 2026, 10:58:25 AM
    Author     : LEGION 5
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.text.NumberFormat"%>
<%
    NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    nf.setMaximumFractionDigits(0);

    // Nhận dữ liệu bộ lọc
    String viewType = (String) request.getAttribute("viewType");
    Integer currYear = (Integer) request.getAttribute("currYear");
    Integer currMonth = (Integer) request.getAttribute("currMonth");
    Integer currQuarter = (Integer) request.getAttribute("currQuarter");

    // Nhận chỉ số nghiên cứu
    Map<String, Double> m = (Map<String, Double>) request.getAttribute("m");
    List<Map<String, Object>> timeSeries = (List<Map<String, Object>>) request.getAttribute("timeSeries");
    Double forecastMAPE = (Double) request.getAttribute("forecastMAPE");
    List<Map<String, Object>> topSanPham = (List<Map<String, Object>>) request.getAttribute("topSanPham");
    List<Map<String, Object>> doanhThuDM = (List<Map<String, Object>>) request.getAttribute("doanhThuDM");

    // Nhận chỉ số thực tế mới
    Integer totalUsers = (Integer) request.getAttribute("totalUsers");
    Map<String, Integer> orderStatus = (Map<String, Integer>) request.getAttribute("orderStatus");
    Map<String, Double> growth = (Map<String, Double>) request.getAttribute("growth");

    double revenueGrowth = growth != null && growth.containsKey("revenueGrowth") ? growth.get("revenueGrowth") : 0.0;
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Hệ thống phân tích báo cáo - KidStyle Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home_admin.css">

        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <style>
            :root {
                --sidebar-width: 250px;
                --header-height: 70px;
                --thesis-blue: #0d6efd;
                --thesis-bg: #f8fafc;
                --accent-green: #10b981;
                --accent-orange: #f59e0b;
            }
            body {
                background: var(--thesis-bg);
                font-family: 'Inter', system-ui, -apple-system, sans-serif;
                overflow-x: hidden;
            }

            #main {
                margin-left: var(--sidebar-width);
                padding-top: var(--header-height);
                transition: all 0.3s ease;
                min-height: 100vh;
            }

            .filter-panel {
                background: white;
                border-bottom: 1px solid #e2e8f0;
                padding: 12px 0;
                position: sticky;
                top: var(--header-height);
                z-index: 101;
                box-shadow: 0 2px 4px rgba(0,0,0,0.02);
            }

            .metric-card {
                background: white;
                border-radius: 12px;
                padding: 20px;
                border: 1px solid #e2e8f0;
                height: 100%;
                display: flex;
                flex-direction: column;
                position: relative;
                overflow: hidden;
            }
            .metric-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);
                border-color: var(--thesis-blue);
            }
            .metric-card .icon-box {
                width: 40px;
                height: 40px;
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 18px;
                margin-bottom: 12px;
            }

            .chart-box {
                background: white;
                border-radius: 16px;
                padding: 24px;
                border: 1px solid #e2e8f0;
                height: 100%;
                position: relative;
            }
            .thesis-header {
                border-left: 4px solid var(--thesis-blue);
                padding-left: 12px;
                margin-bottom: 15px;
            }
            .thesis-title {
                font-size: 14px;
                font-weight: 700;
                color: #1e293b;
                text-transform: uppercase;
                margin: 0;
            }
            .thesis-subtitle {
                font-size: 11px;
                color: #64748b;
                margin: 0;
            }

            .growth-indicator {
                font-size: 12px;
                font-weight: 600;
                padding: 2px 8px;
                border-radius: 99px;
            }
            .growth-positive {
                background: #ecfdf5;
                color: #059669;
            }
            .growth-negative {
                background: #fef2f2;
                color: #dc2626;
            }

            .status-badge {
                width: 8px;
                height: 8px;
                border-radius: 50%;
                display: inline-block;
                margin-right: 6px;
            }

            @media (max-width: 992px) {
                #main {
                    margin-left: 0;
                }
                .filter-panel {
                    top: 0;
                }
            }
            .chart-box canvas {
                width: 100% !important;
                height: 100% !important;
            }

            @media print {
                /* 1. Triệt tiêu trang trắng cuối: Quan trọng nhất */
                html, body {
                    height: auto !important;
                    margin: 0 !important;
                    padding: 0 !important;
                    background: #fff !important;
                }

                /* 2. Ẩn toàn bộ thành phần thừa */
                aside, nav, header, footer,
                .filter-panel, .dropdown, .btn, .sidebar,
                #adminSidebar, #sidebarBackdrop, #mainHeader {
                    display: none !important;
                    visibility: hidden !important;
                    height: 0 !important;
                    margin: 0 !important;
                    padding: 0 !important;
                }

                /* 3. Reset khung nội dung chính */
                #main, #mainContent, .main-content {
                    margin: 0 !important;
                    padding: 0 !important;
                    width: 100% !important;
                    min-height: auto !important; 
                    position: static !important;
                    display: block !important;
                }

                .container-fluid {
                    width: 100% !important;
                    padding: 0 !important;
                    margin: 0 !important;
                }

                /* 4. Tối ưu biểu đồ và bảng */
                .chart-box {
                    border: 1px solid #eee !important;
                    break-inside: avoid; 
                    margin-bottom: 15px !important;
                    padding: 15px !important;
                    page-break-inside: avoid;
                }

                canvas {
                    max-width: 100% !important;
                    height: auto !important;
                }

                /* 5. Ép text hiển thị rõ rệt */
                h4, h6, th, td, span, p {
                    color: #000 !important;
                }
            }
        </style>
    </head>
    <body>

        <%@ include file="layout/header_admin.jsp" %>
        <%@ include file="layout/sidebar_admin.jsp" %>

        <div class="main-content" id="mainContent">
            <!-- Bảng điều khiển bộ lọc -->
            <div class="filter-panel">
                <div class="container-fluid px-4">
                    <form action="Admin_BaoCaoController" method="get" class="row g-3 align-items-center">
                        <div class="col-auto"><span class="fw-bold text-secondary small"><i class="bi bi-funnel me-1"></i>BỘ LỌC PHÂN TÍCH:</span></div>
                        <div class="col-auto">
                            <select name="viewType" class="form-select form-select-sm border-0 bg-light" id="viewType" onchange="toggleFilters()">
                                <option value="year" <%= viewType.equals("year") ? "selected" : ""%>>Báo cáo Năm</option>
                                <option value="quarter" <%= viewType.equals("quarter") ? "selected" : ""%>>Báo cáo Quý</option>
                                <option value="month" <%= viewType.equals("month") ? "selected" : ""%>>Báo cáo Tháng</option>
                            </select>
                        </div>
                        <div class="col-auto">
                            <select name="year" class="form-select form-select-sm border-0 bg-light">
                                <% for (int y = 2024; y <= 2026; y++) {%>
                                <option value="<%=y%>" <%= currYear == y ? "selected" : ""%>>Năm <%=y%></option>
                                <% }%>
                            </select>
                        </div>
                        <div class="col-auto" id="quarterFilter" style="display: <%= viewType.equals("quarter") ? "block" : "none"%>">
                            <select name="quarter" class="form-select form-select-sm border-0 bg-light">
                                <% for (int q = 1; q <= 4; q++) {%>
                                <option value="<%=q%>" <%= currQuarter == q ? "selected" : ""%>>Quý <%=q%></option>
                                <% }%>
                            </select>
                        </div>
                        <div class="col-auto" id="monthFilter" style="display: <%= viewType.equals("month") ? "block" : "none"%>">
                            <select name="month" class="form-select form-select-sm border-0 bg-light">
                                <% for (int mo = 1; mo <= 12; mo++) {%>
                                <option value="<%=mo%>" <%= currMonth == mo ? "selected" : ""%>>Tháng <%=mo%></option>
                                <% }%>
                            </select>
                        </div>
                        <div class="col-auto">
                            <button type="submit" class="btn btn-primary btn-sm px-4 fw-bold">XEM BÁO CÁO</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="container-fluid px-4 py-4">

                <!-- TIÊU ĐỀ BÁO CÁO CHÍNH -->
                <div class="mb-4">
                    <h4 class="fw-bold text-dark">Tổng quan hiệu quả kinh doanh</h4>
                    <p class="text-muted small">Dữ liệu được cập nhật đến ngày <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date())%></p>
                </div>

                <!-- CHỈ SỐ QUAN TRỌNG (Metric Cards) -->
                <div class="row g-4 mb-4">
                    <div class="col-md-4 col-xl-2">
                        <div class="metric-card">
                            <div class="icon-box" style="background: #e0f2fe; color: #0369a1;"><i class="bi bi-person-heart"></i></div>
                            <span class="thesis-subtitle">Khách hàng</span>
                            <h4 class="fw-bold mb-1"><%= totalUsers%></h4>
                            <div class="mt-auto"><small class="text-muted">Tổng số tài khoản</small></div>
                        </div>
                    </div>
                    <div class="col-md-4 col-xl-2">
                        <div class="metric-card">
                            <div class="icon-box" style="background: #f0fdf4; color: #15803d;"><i class="bi bi-cash-stack"></i></div>
                            <span class="thesis-subtitle">Doanh thu kỳ này</span>
                            <h4 class="fw-bold mb-1"><%= nf.format(m.getOrDefault("revenue", 0.0))%></h4>
                            <div class="mt-auto">
                                <span class="growth-indicator <%= revenueGrowth >= 0 ? "growth-positive" : "growth-negative"%>">
                                    <i class="bi bi-arrow-<%= revenueGrowth >= 0 ? "up" : "down"%>"></i> <%= String.format("%.1f", Math.abs(revenueGrowth))%>%
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 col-xl-2">
                        <div class="metric-card">
                            <div class="icon-box" style="background: #fef2f2; color: #b91c1c;"><i class="bi bi-cart-check"></i></div>
                            <span class="thesis-subtitle">Đơn hoàn thành</span>
                            <h4 class="fw-bold mb-1"><%= m.getOrDefault("orders", 0.0).intValue()%></h4>
                            <div class="mt-auto"><small class="text-muted">Giao dịch thành công</small></div>
                        </div>
                    </div>
                    <div class="col-md-4 col-xl-2">
                        <div class="metric-card">
                            <div class="icon-box" style="background: #faf5ff; color: #7e22ce;"><i class="bi bi-bag-plus"></i></div>
                            <span class="thesis-subtitle">Sản lượng bán</span>
                            <h4 class="fw-bold mb-1"><%= m.getOrDefault("quantity", 0.0).intValue()%></h4>
                            <div class="mt-auto"><small class="text-muted">Số lượng item</small></div>
                        </div>
                    </div>
                    <div class="col-md-4 col-xl-2">
                        <div class="metric-card">
                            <div class="icon-box" style="background: #fff7ed; color: #c2410c;"><i class="bi bi-graph-up-arrow"></i></div>
                            <span class="thesis-subtitle">Giá trị đơn (AOV)</span>
                            <h4 class="fw-bold mb-1"><%= nf.format(m.getOrDefault("aov", 0.0))%></h4>
                            <div class="mt-auto"><small class="text-muted">Trung bình/Đơn hàng</small></div>
                        </div>
                    </div>
                    <div class="col-md-4 col-xl-2">
                        <div class="metric-card">
                            <div class="icon-box" style="background: #ecfdf5; color: #047857;"><i class="bi bi-activity"></i></div>
                            <span class="thesis-subtitle">Tình trạng PT</span>
                            <h4 class="fw-bold mb-1"><%= revenueGrowth > 0 ? "Tăng trưởng" : "Ổn định"%></h4>
                            <div class="mt-auto"><small class="text-muted">Dựa trên doanh thu</small></div>
                        </div>
                    </div>
                </div>

                <!-- BIỂU ĐỒ VÀ PHÂN TÍCH CHI TIẾT -->
                <div class="row g-4 mb-4">
                    <!-- Biểu đồ doanh thu -->
                    <div class="col-lg-8">
                        <div class="chart-box">
                            <div class="thesis-header d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="thesis-title">Xu hướng doanh thu theo thời gian</h6>
                                    <p class="thesis-subtitle">Phân tích chuỗi thời gian thực tế</p>
                                </div>
                                <div class="dropdown">
                                    <button class="btn btn-sm btn-light border dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                        <i class="bi bi-box-arrow-up-right me-1"></i>Hành động
                                    </button>
                                    <ul class="dropdown-menu shadow">
                                        <li>
                                            <a class="dropdown-item small" href="Admin_BaoCaoController?action=export_csv&viewType=<%=viewType%>&year=<%=currYear%>&month=<%=currMonth%>&quarter=<%=currQuarter%>">
                                                <i class="bi bi-file-earmark-spreadsheet me-2 text-success"></i>Xuất dữ liệu Power BI (CSV)
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item small" href="javascript:void(0)" onclick="printReport()">
                                                <i class="bi bi-printer me-2 text-primary"></i>In báo cáo (PDF)
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <div style="height: 380px;">
                                <canvas id="timeSeriesChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- Tình trạng đơn hàng & Cơ cấu -->
                    <div class="col-lg-4">
                        <div class="chart-box d-flex flex-column mb-4" style="height: auto;">
                            <div class="thesis-header">
                                <h6 class="thesis-title">Tỉ lệ trạng thái đơn hàng</h6>
                                <p class="thesis-subtitle">Cơ cấu vận hành hiện tại</p>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-sm table-borderless align-middle mb-0">
                                    <tbody>
                                        <%
                                            String[] statuses = {"ChoXacNhan", "DangGiao", "DaGiao", "DaHuy"};
                                            String[] statusLabels = {"Chờ xác nhận", "Đang giao hàng", "Đã hoàn thành", "Đã hủy đơn"};
                                            String[] statusColors = {"#f59e0b", "#3b82f6", "#10b981", "#ef4444"};
                                            for (int i = 0; i < statuses.length; i++) {
                                                int count = orderStatus != null && orderStatus.containsKey(statuses[i]) ? orderStatus.get(statuses[i]) : 0;
                                        %>
                                        <tr>
                                            <td><span class="status-badge" style="background: <%= statusColors[i]%>;"></span> <%= statusLabels[i]%></td>
                                            <td class="text-end fw-bold"><%= count%></td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="chart-box d-flex flex-column">
                            <div class="thesis-header">
                                <h6 class="thesis-title">Cơ cấu doanh mục sản phẩm</h6>
                                <p class="thesis-subtitle">Phân bổ nguồn thu theo nhóm hàng</p>
                            </div>
                            <div style="height: 260px;">
                                <canvas id="categoryChart"></canvas>
                            </div>

                        </div>
                    </div>
                </div>

                <!-- BẢNG TOP SẢN PHẨM -->
                <div class="row g-4">
                    <div class="col-12">
                        <div class="chart-box">
                            <div class="thesis-header">
                                <h6 class="thesis-title">Top 5 sản phẩm đạt hiệu quả kinh doanh cao nhất</h6>
                                <p class="thesis-subtitle">Xếp hạng dựa trên sản lượng phân phối thực tế</p>
                            </div>
                            <div class="table-responsive">
                                <table class="table align-middle">
                                    <thead class="table-light">
                                        <tr class="small text-uppercase text-muted">
                                            <th>Sản phẩm nghiên cứu</th>
                                            <th class="text-center">Sản lượng bán</th>
                                            <th class="text-end">Tiến độ mục tiêu</th>
                                            <th class="text-end">Đánh giá</th>
                                        </tr>
                                    </thead>
                                    
                                    <tbody>
                                        <% int rank = 1;
                                            for (Map<String, Object> sp : topSanPham) {
                                                double progress = 100 - (rank * 4.2);
                                        %>
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <span class="badge rounded-pill bg-light text-primary border me-3"><%= rank++%></span>
                                                    <div class="fw-bold text-dark"><%= sp.get("tenSP")%></div>
                                                </div>
                                            </td>
                                            <td class="text-center fw-bold"><%= sp.get("tong_ban")%></td>
                                            <td class="text-end" style="width: 200px;">
                                                <div class="d-flex align-items-center justify-content-end">
                                                    <div class="progress flex-grow-1 me-2" style="height: 6px; background: #f1f5f9;">
                                                        <div class="progress-bar bg-success" role="progressbar" style="width: <%= progress%>%"></div>
                                                    </div>
                                                    <small class="fw-bold"><%= String.format("%.0f", progress)%>%</small>
                                                </div>
                                            </td>
                                            <td class="text-end">
                                                <span class="badge bg-success-subtle text-success border border-success-subtle px-2">Hoàn thành tốt</span>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <script>
            function toggleFilters() {
                const type = document.getElementById('viewType').value;
                document.getElementById('quarterFilter').style.display = (type === 'quarter') ? 'block' : 'none';
                document.getElementById('monthFilter').style.display = (type === 'month') ? 'block' : 'none';
            }

            // Biểu đồ chuỗi thời gian
            const tsCtx = document.getElementById('timeSeriesChart').getContext('2d');
            const tsGradient = tsCtx.createLinearGradient(0, 0, 0, 400);
            tsGradient.addColorStop(0, 'rgba(13, 110, 253, 0.4)');
            tsGradient.addColorStop(1, 'rgba(13, 110, 253, 0)');

            <%
                List<String> labels = new ArrayList<>();
                List<Double> values = new ArrayList<>();
                String labelPrefix = viewType.equals("year") ? "Tháng " : (viewType.equals("month") ? "Ngày " : "Tháng ");
                for (Map<String, Object> point : timeSeries) {
                    labels.add("'" + labelPrefix + point.get("label") + "'");
                    values.add((Double) point.get("value"));
                }
            %>
            new Chart(tsCtx, {
                type: 'line',
                data: {
                    labels: <%= labels.toString()%>,
                    datasets: [{
                            label: 'Doanh thu (VND)',
                            data: <%= values.toString()%>,
                            borderColor: '#0d6efd',
                            backgroundColor: tsGradient,
                            fill: true,
                            tension: 0.3,
                            borderWidth: 3,
                            pointRadius: 4,
                            pointHoverRadius: 6
                        }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {display: false},
                        tooltip: {backgroundColor: '#1e293b', padding: 12, bodyFont: {size: 14}}
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {callback: v => v.toLocaleString('vi-VN') + 'đ'}
                        }
                    }
                }
            });

            // Biểu đồ danh mục
            <%
                List<String> labelsDM = new ArrayList<>();
                List<Double> valuesDM = new ArrayList<>();
                for (Map<String, Object> dm : doanhThuDM) {
                    labelsDM.add("'" + dm.get("tenDM") + "'");
                    valuesDM.add((Double) dm.get("doanhThu"));
                }
            %>
            new Chart(document.getElementById('categoryChart'), {
                type: 'doughnut',
                data: {
                    labels: <%= labelsDM.toString()%>,
                    datasets: [{
                            data: <%= valuesDM.toString()%>,
                            backgroundColor: ['#0d6efd', '#10b981', '#f59e0b', '#ef4444', '#06b6d4', '#8b5cf6'],
                            borderWidth: 2,
                            borderColor: '#fff'
                        }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    cutout: '75%',
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {padding: 15, usePointStyle: true, font: {size: 10}}
                        }
                    }
                }
            });
            
            //in pdf
            function printReport() {
                window.print();
            }
        </script>
    </body>
</html>