/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.ChatBox;
import Model.ChatBoxDAO;
import Model.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author LEGION 5
 */
@WebServlet(name = "User_ChatBoxController", urlPatterns = {"/User_ChatBoxController"})
public class User_ChatBoxController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ChatBoxController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ChatBoxController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {

            User user = (User) request.getSession().getAttribute("user");

            int userId = (user == null) ? 1 : user.getMaNguoiDung();

            ChatBoxDAO dao = new ChatBoxDAO();
            List<ChatBox> list = dao.getByUser(userId);
            try {

                response.setContentType("application/json;charset=UTF-8");

                StringBuilder json = new StringBuilder();
                json.append("[");

                for (int i = 0; i < list.size(); i++) {
                    ChatBox c = list.get(i);

                    json.append("{")
                            .append("\"type\":\"")
                            .append(
                                    "USER".equals(c.getNguoiGui()) ? "user"
                                    : "ADMIN".equals(c.getNguoiGui()) ? "bot" : "bot"
                            )
                            .append("\",")
                            .append("\"message\":\"")
                            .append(c.getNoiDung().replace("\"", "\\\""))
                            .append("\",")
                            .append("\"status\":\"")
                            .append(c.getTrangThai())
                            .append("\"")
                            .append("}");

                    if (i < list.size() - 1) {
                        json.append(",");
                    }
                }

                json.append("]");

                response.getWriter().write(json.toString());

            } catch (Exception e) {
                e.printStackTrace();
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(User_ChatBoxController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("text/plain;charset=UTF-8");

        User user = (User) request.getSession().getAttribute("user");
        String action = request.getParameter("action");

        //1. XỬ LÝ ACTION TRƯỚC
        if ("markRead".equals(action)) {
            try {
                if (user != null) {
                    ChatBoxDAO dao = new ChatBoxDAO();
                    dao.markReadUser(user.getMaNguoiDung());
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            return;
        }

        //2. SAU ĐÓ MỚI XỬ LÝ MESSAGE
        String message = request.getParameter("message");

        if (message == null || message.trim().isEmpty()) {
            response.getWriter().write("EMPTY_MESSAGE");
            return;
        }

        try {
            ChatBoxDAO dao = new ChatBoxDAO();

            // lưu USER
            if (user != null) {
                ChatBox userChat = new ChatBox();
                userChat.setMaNguoiDung(user.getMaNguoiDung());
                userChat.setNoiDung(message);
                userChat.setNguoiGui("USER");
                dao.insert(userChat);
            }

            // gọi AI
            String aiReply = callAI(message);

            // lưu AI
            if (user != null) {
                ChatBox ai = new ChatBox();
                ai.setMaNguoiDung(user.getMaNguoiDung());
                ai.setNoiDung(aiReply);
                ai.setNguoiGui("AI");
                dao.insert(ai);
            }

            response.getWriter().write(aiReply);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("SERVER_ERROR");
        }
    }

    private String callAI(String msg) {
        try {
            String apiKey = "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";

            URL url = new URL("https://api.groq.com/openai/v1/chat/completions");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Bearer " + apiKey);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            String systemPrompt =
                "Bạn là trợ lý AI của cửa hàng thời trang trẻ em KidStyle (Việt Nam). "
              + "Bạn luôn phải bám sát shop này khi trả lời. "
              + "Shop bán: quần áo trẻ em, giày dép, phụ kiện trẻ em. "
              + "QUY TẮC: "
              + "1. Luôn tư vấn theo sản phẩm trẻ em (size, độ tuổi). "
              + "2. Nếu khách hỏi chung → gợi ý sản phẩm phù hợp. "
              + "3. Không nói về AI, không lan man ngoài shop. "
              + "4. Trả lời ngắn gọn, thân thiện, dễ hiểu.";

            String body = """
            {
              "model": "llama-3.3-70b-versatile",
              "messages": [
                {
                  "role": "system",
                  "content": "%s"
                },
                {
                  "role": "user",
                  "content": "%s"
                }
              ]
            }
            """.formatted(
                systemPrompt.replace("\"", "\\\""),
                msg.replace("\"", "\\\"")
            );
            
            
            conn.getOutputStream().write(body.getBytes("UTF-8"));

            BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "UTF-8")
            );

            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }

            return extractGroqText(sb.toString());

        } catch (Exception e) {
            e.printStackTrace();
            return "AI lỗi: " + e.getMessage();
        }
    }

    private String extractGroqText(String json) {
        try {
            String key = "\"content\":\"";

            int start = json.indexOf(key) + key.length();
            int end = json.indexOf("\"", start);

            return json.substring(start, end)
                    .replace("\\n", "\n")
                    .replace("\\\"", "\"");

        } catch (Exception e) {
            return "Parse lỗi";
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
