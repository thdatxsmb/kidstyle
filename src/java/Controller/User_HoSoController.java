/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.User;
import Model.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.PreparedStatement;

/**
 *
 * @author LEGION 5
 */
@WebServlet(name = "User_HoSoController", urlPatterns = {"/User_HoSoController"})
public class User_HoSoController extends HttpServlet {

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
            out.println("<title>Servlet User_HoSoController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet User_HoSoController at " + request.getContextPath() + "</h1>");
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

        HttpSession session = request.getSession(false);
        User user = (User) (session != null ? session.getAttribute("user") : null);

        if (user == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        request.getRequestDispatcher("User_HoSo.jsp").forward(request, response);
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
        request.setCharacterEncoding("UTF-8");

        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String hoTen = request.getParameter("hoTen");
        String email = request.getParameter("email");
        String soDienThoai = request.getParameter("soDienThoai");
        String diaChi = request.getParameter("diaChi");

        // ==================== KIỂM TRA DỮ LIỆU ====================
        if (hoTen == null || hoTen.trim().isEmpty()) {
            session.setAttribute("errorMsg", "Họ và tên không được để trống!");
            response.sendRedirect("User_HoSoController");
            return;
        }

        if (email == null || !email.matches("^[\\w._%+-]+@[\\w.-]+\\.[a-zA-Z]{2,6}$")) {
            session.setAttribute("errorMsg", "Email không đúng định dạng!");
            response.sendRedirect("User_HoSoController");
            return;
        }

        // KIỂM TRA SỐ ĐIỆN THOẠI - BẮT BUỘC CHÍNH XÁC 10 SỐ
        if (soDienThoai == null || soDienThoai.trim().isEmpty()) {
            session.setAttribute("errorMsg", "Số điện thoại không được để trống!");
            response.sendRedirect("User_HoSoController");
            return;
        }

        soDienThoai = soDienThoai.trim();

        if (soDienThoai.length() != 10) {
            session.setAttribute("errorMsg", "SĐT phải đúng 10 số!");
            response.sendRedirect("User_HoSoController");
            return;
        }

        if (!soDienThoai.matches("^(03|05|07|08|09)\\d{8}$")) {
            session.setAttribute("errorMsg", "SĐT phải đúng định dạng Việt Nam!");
            response.sendRedirect("User_HoSoController");
            return;
        }

        //check dia chi
        if (diaChi == null || diaChi.trim().isEmpty()) {
            session.setAttribute("errorMsg", "Địa chỉ không được để trống!");
            response.sendRedirect("User_HoSoController");
            return;
        }

        try {
            UserDAO dao = new UserDAO();

            if (dao.checkEmailExists(email, currentUser.getMaNguoiDung())) {
                session.setAttribute("errorMsg", "Email này đã được sử dụng bởi tài khoản khác!");
                response.sendRedirect("User_HoSoController");
                return;
            }

            if (dao.checkSDTExist(soDienThoai, currentUser.getMaNguoiDung())) {
                session.setAttribute("errorMsg", "Số điện thoại này đã được sử dụng bởi tài khoản khác!");
                response.sendRedirect("User_HoSoController");
                return;
            }

            User updatedUser = new User();
            updatedUser.setMaNguoiDung(currentUser.getMaNguoiDung());
            updatedUser.setHoTen(hoTen.trim());
            updatedUser.setEmail(email.trim());
            updatedUser.setSoDienThoai(soDienThoai.trim());
            updatedUser.setDiaChi(diaChi.trim());
            updatedUser.setVaiTro(currentUser.getVaiTro());

            boolean success = dao.updateUser(updatedUser, false);

            if (success) {
                currentUser.setHoTen(hoTen.trim());
                currentUser.setEmail(email.trim());
                currentUser.setSoDienThoai(soDienThoai.trim());
                currentUser.setDiaChi(diaChi.trim());
                session.setAttribute("user", currentUser);

                session.setAttribute("successMsg", "Cập nhật thông tin thành công!");
            } else {
                session.setAttribute("errorMsg", "Cập nhật thông tin thất bại!");
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
