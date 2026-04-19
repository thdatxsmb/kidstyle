<%-- 
    Document   : admin_DuBao
    Created on : Apr 7, 2026, 10:39:42 PM
    Author     : LEGION 5
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.text.NumberFormat"%>
<%
    List<String> thangList = (List<String>) request.getAttribute("thangList");
    List<Double> doanhThuList = (List<Double>) request.getAttribute("doanhThuList");
    List<Double> forecastList = (List<Double>) request.getAttribute("forecastList");
    List<Double> upperList = (List<Double>) request.getAttribute("upperList");
    List<Double> lowerList = (List<Double>) request.getAttribute("lowerList");
    
    Double tongDoanhThu = (Double) request.getAttribute("tongDoanhThu");
    Double mapeValue = (Double) request.getAttribute("mapeValue");
    if (mapeValue == null) mapeValue = 0.0;
    if (tongDoanhThu == null) tongDoanhThu = 0.0;

    NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    double lastVal = (doanhThuList != null && !doanhThuList.isEmpty()) ? doanhThuList.get(doanhThuList.size() - 1) : 0;
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Dự báo & Chiến lược AI</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home_admin.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <style>
            #main {
                transition: all 0.3s;
                margin-left: 250px;
                padding: 20px;
            }
            .bg-gradient-blue {
                background: linear-gradient(45deg, #0d6efd, #0dcaf0);
            }
            .bg-gradient-green {
                background: linear-gradient(45deg, #198754, #20c997);
            }
            .bg-gradient-orange {
                background: linear-gradient(45deg, #fd7e14, #ffc107);
            }

            /* Chat Box */
            #ai-chat-btn {
                position: fixed;
                bottom: 25px;
                right: 25px;
                width: 60px;
                height: 60px;
                background: linear-gradient(135deg, #0d6efd, #0dcaf0); 
                color: white;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 28px;
                cursor: pointer;
                box-shadow: 0 4px 15px rgba(0,0,0,0.3);
                z-index: 9999;
            }

            #ai-chat-window {
                position: fixed;
                bottom: 95px;
                right: 25px;
                width: 400px;
                height: 540px;
                background: white;
                border-radius: 16px;
                box-shadow: 0 15px 50px rgba(0,0,0,0.25);
                display: none;
                flex-direction: column;
                z-index: 10000;
                border: 1px solid #ddd;
                overflow: hidden;
            }

            #ai-chat-window .chat-header {
                background: linear-gradient(135deg, #0d6efd, #0dcaf0); 
                color: white;
                padding: 18px 20px;
                font-size: 17px;
                font-weight: 700;
                display: flex;
                align-items: center;
                justify-content: space-between;
                border-bottom: 2px solid rgba(255,255,255,0.3);
            }

            #ai-chat-window .chat-header i {
                font-size: 22px;
                margin-right: 8px;
            }

            #ai-chat-window .chat-header button {
                background: rgba(255,255,255,0.25);
                border: none;
                color: white;
                width: 34px;
                height: 34px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 20px;
                transition: all 0.2s;
            }

            #ai-chat-window .chat-header button:hover {
                background: rgba(255,255,255,0.45);
                transform: rotate(90deg);
            }

            #ai-chat-window .chat-body {
                flex: 1;
                padding: 15px;
                overflow-y: auto;
                background: #f8f9fa;
                display: flex;
                flex-direction: column;
                gap: 10px;
            }
            #ai-chat-window .msg {
                padding: 10px 14px;
                border-radius: 15px;
                font-size: 14px;
                max-width: 85%;
                line-height: 1.5;
                white-space: pre-wrap;
            }
            #ai-chat-window .msg.ai {
                background: #fff;
                align-self: flex-start;
                border: 1px solid #eef;
            }
            #ai-chat-window .msg.user {
                background: #0d6efd;
                color: white;
                align-self: flex-end;
            }

            /* Hiệu ứng gõ chữ AI chuyên nghiệp */
            .typing {
                display: none;
                align-items: center;
                padding: 8px 12px;
                margin: 6px 0;
                background: #fff;
                border: 1px solid #eef;
                border-radius: 15px;
                max-width: 85%;
                align-self: flex-start;
            }
            .typing-dots {
                display: flex;
                gap: 4px;
            }
            .typing-dots span {
                height: 5px;
                width: 5px;
                background: #888;
                border-radius: 50%;
                animation: typingBounce 1.2s infinite;
            }
            .typing-dots span:nth-child(2) {
                animation-delay: 0.2s;
            }
            .typing-dots span:nth-child(3) {
                animation-delay: 0.4s;
            }
            @keyframes typingBounce {
                0%, 80%, 100% {
                    transform: translateY(0);
                }
                40% {
                    transform: translateY(-5px);
                }
            }
            .typing-text {
                margin-left: 8px;
                font-size: 13px;
                color: #666;
                font-style: italic;
            }

            /* AI Analysis Nguyên bản (To rõ) */
            .ai-analysis-box {
                white-space: pre-line;
                line-height: 1.6;
                font-size: 14.5px;
            }
            .ai-analysis-box b {
                color: #0d6efd;
            }
        </style>
    </head>
    <body class="bg-light">

        <%@ include file="../layout/header_admin.jsp" %>
        <%@ include file="../layout/sidebar_admin.jsp" %>

        <div class="main-content" id="mainContent">
            <div class="container-fluid py-4">

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4 class="fw-bold"><i class="bi bi-robot text-primary me-2"></i>Dự báo & Chiến lược AI</h4>
                    <div class="btn-group shadow-sm">
                        <a href="Admin_BaoCaoController?action=export" class="btn btn-success"><i class="bi bi-download me-1"></i> Xuất CSV</a>
                        <button class="btn btn-white border" onclick="location.reload()"><i class="bi bi-arrow-clockwise"></i> Tải lại</button>
                    </div>
                </div>

                <!-- THỐNG KÊ -->
                <div class="row g-3 mb-4 text-center">
                    <div class="col-md-4">
                        <div class="card border-0 bg-gradient-blue text-white shadow-sm p-3">
                            <small class="text-uppercase opacity-75 fw-bold">Doanh thu thực tế</small>
                            <h3 class="fw-bold mb-0 mt-1"><%= nf.format(tongDoanhThu) %></h3>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card border-0 bg-gradient-green text-white shadow-sm p-3">
                            <small class="text-uppercase opacity-75 fw-bold">Độ chính xác mô hình</small>
                            <h3 class="fw-bold mb-0 mt-1"><%= mapeValue %>%</h3>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card border-0 bg-gradient-orange text-white shadow-sm p-3">
                            <small class="text-uppercase opacity-75 fw-bold">Dự báo tháng tới (AI)</small>
                            <h3 class="fw-bold mb-0 mt-1"><% if (forecastList != null && !forecastList.isEmpty()) { %><%= nf.format(forecastList.get(0)) %><% } else { %> - <% } %></h3>
                        </div>
                    </div>
                </div>

                <!-- BIỂU ĐỒ VÀ GIAI ĐOẠN -->
                <div class="card p-4 border-0 shadow-sm mb-4">
                    <h6 class="fw-bold text-muted mb-4 uppercase"><i class="bi bi-graph-up me-2"></i>Biểu đồ so sánh Thực tế & Dự báo (Holt-Winters)</h6>
                    <div style="height: 400px;"><canvas id="forecastChart"></canvas></div>
                </div>


                <!-- Bảng dữ liệu -->
                <div class="card p-4 border-0 shadow-sm mb-4">
                    <h6 class="fw-bold text-muted mb-4 uppercase"><i class="bi bi-graph-up me-2"></i>Bảng dữ liệu</h6>

                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Giai đoạn</th>
                                    <th>Dữ liệu thực tế</th>
                                    <th>Dự báo AI</th>
                                    <th>Khoảng tin cậy</th>
                                    <th>Phân loại</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    if (thangList != null) {
                                        for (int i = 0; i < thangList.size(); i++) { 
                                %>
                                <tr>
                                    <td><%= thangList.get(i) %></td>
                                    <td class="text-primary fw-bold"><%= nf.format(doanhThuList.get(i)) %></td>
                                    <td class="text-muted small">-</td>
                                    <td class="text-muted small">-</td>
                                    <td><span class="badge bg-light text-primary border border-primary">Thực tế</span></td>
                                </tr>
                                <%      } 
                                    } 
                                %>

                                <% 
                                    if (forecastList != null) {
                                        for (int i = 0; i < forecastList.size(); i++) { 
                                %>
                                <tr class="bg-light">
                                    <td class="fw-bold text-danger">Tháng T+<%= (i+1) %></td>
                                    <td class="text-muted small">-</td>
                                    <td class="text-danger fw-bold"><%= nf.format(forecastList.get(i)) %></td>
                                    <td class="small text-muted">
                                        <%= nf.format(lowerList.get(i)) %> - <%= nf.format(upperList.get(i)) %>
                                    </td>
                                    <td><span class="badge bg-danger shadow-sm">Dự báo</span></td>
                                </tr>
                                <%      } 
                                    } 
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- PHÂN TÍCH CHIẾN LƯỢC AI -->
                <div class="card border-0 shadow-sm mb-4 bg-primary text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="fw-bold mb-0"><i class="bi bi-stars me-2"></i>Chiến lược kinh doanh từ Groq AI</h5>
                            <span class="badge bg-white text-primary rounded-pill px-3 py-2">LIVE ANALYSIS</span>
                        </div>

                        <div class="p-4 bg-white text-dark rounded-3 mt-3 shadow-inner" id="ai-strategy-content">
                            <div class="text-center py-5">
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                                <p class="mt-3 text-muted">Trợ lý AI đang đọc dữ liệu và xây dựng chiến lược...</p>
                            </div>
                        </div>

                        <div class="mt-3 d-flex gap-2">
                            <button class="btn btn-light btn-sm fw-bold" onclick="toggleAIChat()"><i class="bi bi-chat-text"></i> Chat chi tiết với AI</button>
                            <button class="btn btn-outline-light btn-sm" onclick="loadInitialAIAnalysis()"><i class="bi bi-arrow-repeat"></i> Phân tích lại</button>
                        </div>
                    </div>
                </div>

            </div>
        </div>


        <div id="ai-chat-btn" onclick="toggleAIChat()"><i class="bi bi-robot"></i></div>
        <div id="ai-chat-window">
            <div class="chat-header">
                <span class="fw-bold"><i class="bi bi-gpu-card me-2"></i>GROQ Phân tích & hỗ trợ AI</span>
                <button class="btn btn-sm text-white" onclick="toggleAIChat()"><i class="bi bi-dash-lg"></i></button>
            </div>
            <div class="chat-body" id="chatAiFlow">
                <div class="msg ai">Chào Admin! Tôi đã sẵn sàng tư vấn chiến lược dựa trên dữ liệu thật của KidStyle. Bạn muốn thảo luận về điểm nào?</div>
                <div id="typing-status" class="typing">
                    <div class="typing-dots"><span></span><span></span><span></span></div>
                    <span class="typing-text">AI đang phân tích dữ liệu...</span>
                </div>
            </div>
            <div class="p-3 bg-white border-top d-flex gap-2">
                <input type="text" id="aiInput" class="form-control" placeholder="Hỏi AI strategist..." onkeypress="if (event.key === 'Enter')
                            sendChatAI()">
                <button class="btn btn-primary px-3" onclick="sendChatAI()"><i class="bi bi-send-fill"></i></button>
            </div>
        </div>

        <script>
            // 1. BIỂU ĐỒ LOGIC 
            const ctx = document.getElementById('forecastChart');
            const labels = [];
            <% if (thangList != null) { for(String s : thangList) { %> labels.push('<%= s %>'); <% } } %>
            <% if (forecastList != null) { for(int i=1; i<=forecastList.size(); i++) { %> labels.push('Dự báo T+<%= i %>');
            <% } } %>

            const actuals = [
            <% if (doanhThuList != null) { for(int i=0; i<doanhThuList.size(); i++) { out.print( (i==0?"":",") + doanhThuList.get(i) ); } } %>
            <% if (forecastList != null) { for(int i=0; i<forecastList.size(); i++) { out.print(",null"); } } %>
            ];

            const forecasts = [
            <% if (doanhThuList != null && !doanhThuList.isEmpty()) { 
                    for(int i=0; i < doanhThuList.size()-1; i++) out.print("null, "); 
                    out.print(doanhThuList.get(doanhThuList.size()-1)); 
                } %>
            <% if (forecastList != null) { for(Double f : forecastList) { out.print(", " + f); } } %>
            ];

            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [
                        {label: 'Doanh thu Thực tế', data: actuals, borderColor: '#0d6efd', backgroundColor: 'rgba(13, 110, 253, 0.1)', fill: true, tension: 0.3, pointRadius: 5, pointHoverRadius: 8},
                        {label: 'Mô hình Dự báo', data: forecasts, borderColor: '#dc3545', borderDash: [5, 5], tension: 0.3, pointStyle: 'rectRot', pointRadius: 6, pointHoverRadius: 9}
                    ]
                },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    plugins: {legend: {position: 'top', labels: {font: {size: 12, weight: 'bold'}}}},
                    scales: {
                        y: {beginAtZero: true, ticks: {font: {weight: 'bold'}, callback: v => v.toLocaleString('vi-VN') + 'đ'}},
                        x: {ticks: {font: {weight: 'bold'}}}
                    }
                }
            });

            // 2. PHÂN TÍCH AI CHIẾN LƯỢC
            const contextStr = "Dữ liệu KidStyle: Thực tế <%= doanhThuList.toString() %>, Dự báo: <%= forecastList.toString() %>, Độ sai số: <%= mapeValue %>%";

            async function loadInitialAIAnalysis() {
                const container = document.getElementById('ai-strategy-content');
                container.innerHTML = `<div class="text-center py-5"><div class="spinner-border text-primary" role="status"></div><p class="mt-3 text-muted fw-bold">AI đang phân tích xu hướng thị trường...</p></div>`;
                try {
                    const res = await fetch('Admin_AIChatController', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        body: new URLSearchParams({
                            'message': 'Hãy viết báo cáo phân tích tài chính sâu sắc. Yêu cầu: Định dạng tiền VNĐ (VD: 1.000.000 đ), sử dụng gạch đầu dòng và ngắt dòng kép (\\n\\n) rõ ràng cho từng ý.',
                            'context': contextStr
                        })
                    });
                    const d = await res.json();
                    container.innerHTML = "";
                    const div = document.createElement('div');
                    div.className = "ai-analysis-box";
                    let content = d.choices[0].message.content;

                    content = content.replace(/\n{2,}/g, "<br>");
                    content = content.replace(/\n/g, "<br>");

                    div.innerHTML = content;
                    container.appendChild(div);
                } catch (e) {
                    container.innerHTML = `<p class="text-danger fw-bold">Không thể kết nối với AI. Hãy kiểm tra API Key.</p>`;
                }
            }

            window.onload = loadInitialAIAnalysis;

            // 3. CHAT LOGIC
            function toggleAIChat() {
                const w = document.getElementById('ai-chat-window');
                w.style.display = (w.style.display === 'flex') ? 'none' : 'flex';
            }

            async function sendChatAI() {
                const inp = document.getElementById('aiInput');
                const box = document.getElementById('chatAiFlow');
                const status = document.getElementById('typing-status');
                const txt = inp.value.trim();
                if (!txt)
                    return;

                const userDiv = document.createElement('div');
                userDiv.className = "msg user";
                userDiv.innerText = txt;
                box.appendChild(userDiv);

                // Đưa hiệu ứng typing xuống dưới cùng
                box.appendChild(status);
                status.style.display = 'flex';

                inp.value = '';
                box.scrollTop = box.scrollHeight;

                try {
                    const res = await fetch('Admin_AIChatController', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        body: new URLSearchParams({'message': txt, 'context': contextStr})
                    });
                    const d = await res.json();

                    status.style.display = 'none'; // Ẩn ngay khi có kết quả

                    const aiDiv = document.createElement('div');
                    aiDiv.className = "msg ai";
                    aiDiv.innerText = d.choices[0].message.content;
                    box.appendChild(aiDiv);
                    box.scrollTop = box.scrollHeight;
                } catch (e) {
                    status.style.display = 'none';
                }
            }
        </script>
    </body>
</html>