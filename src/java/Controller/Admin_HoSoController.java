/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.User;
import Model.UserDAO;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.regex.Pattern;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author LEGION 5
 */
@WebServlet(name = "Admin_HoSoController", urlPatterns = {"/Admin_HoSoController"})
public class Admin_HoSoController extends HttpServlet {

    private final Pattern PHONE_PATTERN = Pattern.compile("^(03|05|07|08|09)[0-9]{8}$");

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
            out.println("<title>Servlet Admin_HoSoController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Admin_HoSoController at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            UserDAO dao = new UserDAO();

            if ("updateProfile".equals(action)) {
                updateProfile(request, session, user, dao);
            } else if ("changePassword".equals(action)) {
                changePassword(request, session, user, dao);
            } else {
                session.setAttribute("error", "Action không hợp lệ");
            }

            dao.close();

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi hệ thống");
        }

        response.sendRedirect(request.getHeader("referer"));
    }

    // ================= UPDATE PROFILE =================
    private void updateProfile(HttpServletRequest request, HttpSession session,
            User user, UserDAO dao) throws Exception {

        String hoTen = request.getParameter("hoTen");
        String email = request.getParameter("email");
        String sdt = request.getParameter("soDienThoai");
        String diaChi = request.getParameter("diaChi");

        // ===== VALIDATE =====
        if (hoTen == null || hoTen.trim().isEmpty()) {
            session.setAttribute("profile_error", "Họ tên không được để trống");
            return;
        }

        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {

            session.setAttribute("profile_error", "Email không hợp lệ");
            return;
        }

        if (diaChi == null || diaChi.trim().isEmpty()) {
            session.setAttribute("profile_error", "Địa chỉ không được để trống");
            return;
        }

        if (sdt != null && !sdt.isEmpty() && !PHONE_PATTERN.matcher(sdt).matches()) {
            session.setAttribute("profile_error", "SĐT không hợp lệ");
            return;
        }

        // ===== CHECK TRÙNG =====
        if (dao.checkEmailExists(email, user.getMaNguoiDung())) {
            session.setAttribute("profile_error", "Email đã tồn tại");
            return;
        }

        if (sdt != null && !sdt.isEmpty()
                && dao.checkSDTExist(sdt, user.getMaNguoiDung())) {
            session.setAttribute("profile_error", "SĐT đã tồn tại");
            return;
        }

        // ===== UPDATE =====
        user.setHoTen(hoTen.trim());
        user.setEmail(email.trim());
        user.setSoDienThoai(sdt);
        user.setDiaChi(diaChi.trim());

        dao.updateUser(user, false);

        session.setAttribute("user", user);
        session.setAttribute("profile_success", "Cập nhật hồ sơ thành công");
    }

    // ================= CHANGE PASSWORD =================
    private void changePassword(HttpServletRequest request, HttpSession session,
            User user, UserDAO dao) throws Exception {

        String oldPass = request.getParameter("oldPassword");
        String newPass = request.getParameter("newPassword");
        String confirm = request.getParameter("confirmPassword");

        // ===== VALIDATE =====
        if (oldPass == null || oldPass.isEmpty()) {
            session.setAttribute("profile_error", "Vui lòng nhập mật khẩu cũ");
            return;
        }

        if (newPass == null || newPass.length() < 6) {
            session.setAttribute("profile_error", "Mật khẩu mới phải >= 6 ký tự");
            return;
        }

        if (!newPass.equals(confirm)) {
            session.setAttribute("profile_error", "Xác nhận mật khẩu không khớp");
            return;
        }

        // check mật khẩu cũ bằng DB (chuẩn hơn)
        User check = dao.login(user.getEmail(), oldPass);
        if (check == null) {
            session.setAttribute("profile_error", "Mật khẩu cũ không đúng");
            return;
        }

        // update
        user.setMatKhau(newPass);
        dao.updateUser(user, true);

        session.setAttribute("user", user);
        session.setAttribute("profile_success", "Đổi mật khẩu thành công");
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
