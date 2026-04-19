<%-- 
    Document   : chatbox
    Created on : Apr 17, 2026, 5:49:37 PM
    Author     : LEGION 5
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<style>
    #chatBtn{
        position:fixed;
        bottom:100px;
        right:20px;
        width:60px;
        height:60px;
        background: #ff6666;
        color:white;
        border-radius:50%;
        display:flex;
        align-items:center;
        justify-content:center;
        font-size:24px;
        cursor:pointer;
        z-index:999999;

        box-shadow: 0 0 15px rgba(13,110,253,0.8),
            0 0 30px rgba(111,66,193,0.8);

        animation: glow 1.2s infinite;
    }

    @keyframes glow {
        0% {
            transform: scale(1);
        }
        50% {
            transform: scale(1.1);
            box-shadow: 0 0 25px rgba(13,110,253,1),
                0 0 50px rgba(111,66,193,1);
        }
        100% {
            transform: scale(1);
        }
    }

    #chatBox{
        position:fixed;
        bottom:150px;
        right:20px;
        width:340px;
        height:460px;
        background:#fff;
        border-radius:18px;
        box-shadow:0 15px 40px rgba(0,0,0,0.25);
        display:none;
        flex-direction:column;
        overflow:hidden;
        z-index:999999;
        font-family:Arial;
    }

    .chat-header{
        background:linear-gradient(135deg,#0d6efd,#6f42c1);
        color:white;
        padding:12px;
        display:flex;
        justify-content:space-between;
        align-items:center;
        font-weight:bold;
    }

    .chat-content{
        flex:1;
        padding:10px;
        overflow-y:auto;
        background:#f6f7fb;
        font-size:14px;
    }

    .msg{
        padding:8px 10px;
        margin:6px 0;
        border-radius:12px;
        max-width:80%;
        clear:both;
    }

    .msg.user{
        background:#0d6efd;
        color:white;
        float:right;
    }

    .msg.bot{
        background:#e9ecef;
        float:left;
    }

    .chat-input{
        display:flex;
        border-top:1px solid #ddd;
        background:white;
    }

    .chat-input input{
        flex:1;
        border:none;
        padding:12px;
        outline:none;
    }

    .chat-input button{
        width:50px;
        border:none;
        background:#0d6efd;
        color:white;
        font-size:18px;
        cursor:pointer;
    }

    @keyframes shake {
        0% {
            transform: rotate(0);
        }
        25% {
            transform: rotate(5deg);
        }
        50% {
            transform: rotate(-5deg);
        }
        75% {
            transform: rotate(3deg);
        }
        100% {
            transform: rotate(0);
        }
    }

    #chatBtn:hover {
        animation: shake 0.4s;
    }

    #chatBadge{
        position:absolute;
        top:-5px;
        right:-5px;
        background:red;
        color:white;
        font-size:12px;
        padding:3px 6px;
        border-radius:50%;
        display:none;
        font-weight:bold;
    }

    .typing {
        display: flex;
        align-items: center;
        padding: 8px 12px;
        margin: 6px 0;
        background: #e9ecef;
        border-radius: 12px;
        max-width: 80%;
        float: left;
        clear: both;
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
    }
</style>

<div id="chatBtn" onclick="toggleChat()">
    <i class="fa-solid fa-comment"></i>
    <span id="chatBadge">0</span>
</div>

<div id="chatBox">

    <div class="chat-header">
        <span>🤖 KidStyle hỗ trợ AI</span>
        <button onclick="toggleChat()">✖</button>
    </div>

    <div id="chatContent" class="chat-content"></div>

    <div class="chat-input">
        <input id="chatInput" type="text" placeholder="Nhập tin nhắn..." />
        <button onclick="sendMessage()">➤</button>
    </div>

</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        loadChat();

    });

    function toggleChat() {
        let box = document.getElementById("chatBox");
        let badge = document.getElementById("chatBadge");

        let isOpen = box.style.display === "flex";

        box.style.display = isOpen ? "none" : "flex";

        if (!isOpen) {
            badge.style.display = "none";

            fetch("User_ChatBoxController", {
                method: "POST",
                headers: {"Content-Type": "application/x-www-form-urlencoded"},
                body: "action=markRead"
            });
        }
    }

    function loadChat() {
        fetch("User_ChatBoxController").then(res => res.json()).then(data => {
            let content = document.getElementById("chatContent");
            content.innerHTML = "";

            // 1. Hiển thị tin nhắn (hoặc lời chào nếu trống)
            if (data.length === 0) {
                let welcomeDiv = document.createElement("div");
                welcomeDiv.className = "msg bot";
                welcomeDiv.innerText = "Chào bạn! Tôi là trợ lý AI của cửa hàng KidStyle. Bạn cần tôi hỗ trợ gì về sản phẩm hay chính sách của shop không?";
                content.appendChild(welcomeDiv);
            } else {
                data.forEach(m => {
                    let div = document.createElement("div");
                    div.className = "msg " + m.type;
                    div.innerText = m.message;
                    content.appendChild(div);
                });
            }
            content.scrollTop = content.scrollHeight;

            // 2. Logic hiển thị Badge thông báo số tin nhắn chưa đọc
            let unread = data.filter(m =>
                m.status === "ChuaDoc" && m.type === "bot"
            ).length;

            let badge = document.getElementById("chatBadge");
            if (unread > 0) {
                badge.innerText = unread;
                badge.style.display = "block";
            } else {
                badge.style.display = "none";
            }
        });
    }

    function sendMessage() {
        let input = document.getElementById("chatInput");
        let msg = input.value.trim();
        if (!msg)
            return;

        let content = document.getElementById("chatContent");

        let userDiv = document.createElement("div");
        userDiv.className = "msg user";
        userDiv.innerText = msg;
        content.appendChild(userDiv);
        content.scrollTop = content.scrollHeight;

        input.value = "";

        let typingDiv = document.createElement("div");
        typingDiv.id = "typingIndicator";
        typingDiv.className = "typing";
        typingDiv.innerHTML = `
        <div class="typing-dots">
            <span></span>
            <span></span>
            <span></span>
        </div>
        <span class="typing-text">Đang trả lời...</span>
    `;
        content.appendChild(typingDiv);
        content.scrollTop = content.scrollHeight;

        fetch("User_ChatBoxController", {
            method: "POST",
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: "message=" + encodeURIComponent(msg)
        })
                .then(res => res.text())
                .then(data => {
                    let typing = document.getElementById("typingIndicator");
                    if (typing)
                        typing.remove();

                    let botDiv = document.createElement("div");
                    botDiv.className = "msg bot";
                    botDiv.innerText = data;
                    content.appendChild(botDiv);
                    content.scrollTop = content.scrollHeight;
                })
                .catch(err => {
                    console.error(err);
                    let typing = document.getElementById("typingIndicator");
                    if (typing)
                        typing.remove();

                    let errorDiv = document.createElement("div");
                    errorDiv.className = "msg bot";
                    errorDiv.innerText = "Có lỗi xảy ra, vui lòng thử lại.";
                    content.appendChild(errorDiv);
                    content.scrollTop = content.scrollHeight;
                });
    }

    document.getElementById("chatInput").addEventListener("keypress", function (e) {
        if (e.key === "Enter") {
            e.preventDefault();
            sendMessage();
        }
    });

</script>