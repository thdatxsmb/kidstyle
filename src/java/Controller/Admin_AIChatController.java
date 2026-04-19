/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

/**
 *
 * @author LEGION 5
 */
@WebServlet(name = "Admin_AIChatController", urlPatterns = {"/Admin_AIChatController"})
public class Admin_AIChatController extends HttpServlet {

    private static final String GROQ_API_KEY = "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";
    private static final String GROQ_URL = "https://api.groq.com/openai/v1/chat/completions";

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
            out.println("<title>Servlet Admin_AIChatController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Admin_AIChatController at " + request.getContextPath() + "</h1>");
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
            throws ServletException, IOException {
        processRequest(request, response);
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
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String userMessage = request.getParameter("message");
        String contextData = request.getParameter("context");

        try {
            URL url = new URL(GROQ_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Bearer " + GROQ_API_KEY);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            String systemInstruction = "Bạn là chuyên gia phân tích tài chính của KidStyle. "
                    + "Dữ liệu hiện tại: " + contextData
                    + ". QUY TẮC BẮT BUỘC: "
                    + "1. Luôn định dạng tiền tệ theo chuẩn VNĐ (Ví dụ: 1.234.567 đ). "
                    + "2. Trả lời bằng tiếng Việt, súc tích, chuyên nghiệp. "
                    + "3. Sử dụng các đoạn văn ngắn, danh sách (bullets) và xuống dòng để dễ đọc. "
                    + "4. Tuyệt đối không viết dính chùm một khối văn bản.";

            String jsonInput = "{"
                    + "\"model\": \"llama-3.3-70b-versatile\","
                    + "\"messages\": ["
                    + "  {\"role\": \"system\", \"content\": \"" + systemInstruction.replace("\"", "\\\"") + "\"},"
                    + "  {\"role\": \"user\", \"content\": \"" + userMessage.replace("\"", "\\\"") + "\"}"
                    + "]"
                    + "}";

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonInput.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            StringBuilder resBody = new StringBuilder();
            try (BufferedReader br = new BufferedReader(new java.io.InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) {
                    resBody.append(line.trim());
                }
            }

            response.getWriter().write(resBody.toString());

        } catch (Exception e) {
            response.setStatus(500);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
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
