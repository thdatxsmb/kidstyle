<%-- 
    Document   : admin_ChatBox
    Created on : Apr 17, 2026, 5:41:40 PM
    Author     : LEGION 5
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Model.User"%>

<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"QuanTri".equals(admin.getVaiTro())) {
        response.sendRedirect("Login.jsp");
        return;
    }

    List<User> users = (List<User>) request.getAttribute("users");
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chat khách hàng</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home_admin.css">
    </head>

    <body>

        <%@ include file="../layout/header_admin.jsp" %>
        <%@ include file="../layout/sidebar_admin.jsp" %>

        <div class="main-content" id="mainContent">
            <div class="container-fluid py-3">

                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold">
                        <i class="bi bi-chat-dots text-primary me-2"></i>
                        Chat khách hàng
                    </h5>

                    <div class="d-flex align-items-center gap-2">
                        <div class="input-group" style="width: 320px;">
                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                            <input type="text" id="searchInput" class="form-control"
                                   placeholder="Tìm theo họ tên, email..."
                                   onkeyup="searchUser()">
                        </div>
                        <a href="Admin_HoTroController" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-clockwise"></i> Tải lại
                        </a>
                    </div>
                </div>

                <div class="card">
                    <div class="card-body p-0 d-flex" style="height:500px">

                        <div class="col-3 border-end overflow-auto">

                            <% if (users != null && !users.isEmpty()) {
                                    for (User u : users) {%>

                            <div onclick="loadUser(<%=u.getMaNguoiDung()%>, this)"
                                 class="p-3 border-bottom user-item"
                                 data-search="<%= (u.getHoTen() + " " + u.getEmail()).toLowerCase()%>"
                                 style="cursor:pointer">

                                <div class="fw-semibold">
                                    <i class="bi bi-person-circle text-primary me-1"></i>
                                    <%= u.getHoTen()%>
                                </div>

                                <div class="text-muted small">
                                    <%= u.getEmail()%>
                                </div>
                            </div>

                            <% }
                            } else { %>

                            <div class="text-center p-3 text-muted">
                                Không có user
                            </div>

                            <% }%>

                        </div>

                        <div class="col-9 d-flex flex-column">

                            <div id="chatBoxAdmin"
                                 class="flex-grow-1 overflow-auto p-3 bg-light">

                                <div class="text-center text-muted mt-5">
                                    Chọn user để chat
                                </div>

                            </div>

                            <div class="border-top p-2 d-flex">
                                <input id="adminMsg"
                                       class="form-control me-2"
                                       placeholder="Nhập tin nhắn...">

                                <button onclick="sendAdmin()" class="btn btn-primary">
                                    <i class="bi bi-send"></i>
                                </button>
                            </div>

                        </div>

                    </div>
                </div>

            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            document.getElementById("adminMsg").addEventListener("keypress", function (e) {
                if (e.key === "Enter") {
                    e.preventDefault();
                    sendAdmin();
                }
            });

            let currentUser = 0;

            function loadUser(id, el) {
                currentUser = id;

                document.querySelectorAll(".user-item").forEach(e => {
                    e.classList.remove("bg-light");
                });

                if (el)
                    el.classList.add("bg-light");

                fetch("Admin_ChatController?action=loadChat&maNguoiDung=" + id)
                        .then(r => r.text())
                        .then(data => {
                            document.getElementById("chatBoxAdmin").innerHTML = data;

                            let box = document.getElementById("chatBoxAdmin");
                            box.scrollTop = box.scrollHeight;
                        });
            }

            function sendAdmin() {
                let msg = document.getElementById("adminMsg").value;

                if (msg.trim() === "" || currentUser === 0)
                    return;

                fetch("Admin_ChatController", {
                    method: "POST",
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: "maNguoiDung=" + currentUser + "&message=" + msg
                }).then(() => {
                    document.getElementById("adminMsg").value = "";
                    loadUser(currentUser);
                });
            }

            function searchUser() {
                const keyword = document.getElementById("searchInput").value.toLowerCase();
                const items = document.querySelectorAll(".user-item");

                items.forEach(item => {
                    const text = item.getAttribute("data-search");
                    item.style.display = text.includes(keyword) ? "" : "none";
                });
            }

            setInterval(() => {
                if (currentUser !== 0) {
                    loadUser(currentUser);
                }
            }, 3000);
        </script>
    </body>
</html>