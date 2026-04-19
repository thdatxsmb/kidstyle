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
import Model.User;
import Model.UserDAO;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author LEGION 5
 */
@WebServlet(name = "User_DoiMatKhau", urlPatterns = {"/User_DoiMatKhauController"})
public class User_DoiMatKhauController extends HttpServlet {

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
            out.println("<title>Servlet User_DoiMatKhau</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet User_DoiMatKhau at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String matKhauHienTai = request.getParameter("matKhauHienTai");
        String matKhauMoi = request.getParameter("matKhauMoi");
        String xacNhan = request.getParameter("xacNhan");

        // Kiểm tra dữ liệu đầu vào
        if (matKhauHienTai == null || matKhauHienTai.trim().isEmpty()) {
            session.setAttribute("errorMsg", "Vui lòng nhập mật khẩu hiện tại!");
            response.sendRedirect("User_HoSoController");
            return;
        }

        if (matKhauMoi == null || matKhauMoi.trim().length() < 6) {
            session.setAttribute("errorMsg", "Mật khẩu mới phải có ít nhất 6 ký tự!");
            response.sendRedirect("User_HoSoController");
            return;
        }

        if (!matKhauMoi.equals(xacNhan)) {
            session.setAttribute("errorMsg", "Mật khẩu xác nhận không khớp!");
            response.sendRedirect("User_HoSoController");
            return;
        }

        try {
            UserDAO dao = new UserDAO();

            // Kiểm tra mật khẩu hiện tại có đúng không
            User loginCheck = dao.login(currentUser.getEmail(), matKhauHienTai);
            if (loginCheck == null) {
                session.setAttribute("errorMsg", "Mật khẩu hiện tại không đúng!");
                response.sendRedirect("User_HoSoController");
                return;
            }

            // Cập nhật mật khẩu mới
            User updatedUser = new User();
            updatedUser.setMaNguoiDung(currentUser.getMaNguoiDung());
            updatedUser.setMatKhau(matKhauMoi);
            updatedUser.setHoTen(currentUser.getHoTen());
            updatedUser.setEmail(currentUser.getEmail());
            updatedUser.setSoDienThoai(currentUser.getSoDienThoai());
            updatedUser.setDiaChi(currentUser.getDiaChi());
            updatedUser.setVaiTro(currentUser.getVaiTro());

            boolean success = dao.updateUser(updatedUser, true); // true = cập nhật mật khẩu

            if (success) {
                session.setAttribute("successMsg", "Đổi mật khẩu thành công!");
            } else {
                session.setAttribute("errorMsg", "Đổi mật khẩu thất bại!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Có lỗi xảy ra: " + e.getMessage());
        }

        response.sendRedirect("User_HoSoController");
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
