/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.NhatKyDAO;
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

/**
 *
 * @author LEGION 5
 */
@WebServlet(name = "DangKy", urlPatterns = {"/DangKy"})
public class DangKy extends HttpServlet {

    private static final String EMAIL_REGEX
            = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";

    private static final String PHONE_REGEX = "^0[0-9]{9}$";

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
            out.println("<title>Servlet DangKy</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DangKy at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("DangKy.jsp").forward(request, response);
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

        // Lấy dữ liệu từ form
        String hoTen = request.getParameter("HoTen");
        String email = request.getParameter("Email");
        String soDienThoai = request.getParameter("SoDienThoai");
        String matKhau = request.getParameter("MatKhau");
        String xacNhanMatKhau = request.getParameter("XacNhanMatKhau");
        String diaChi = request.getParameter("DiaChi");

        // ====================== KIỂM TRA KHÔNG ĐƯỢC ĐỂ TRỐNG ======================
        if (hoTen == null || hoTen.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || soDienThoai == null || soDienThoai.trim().isEmpty()
                || matKhau == null || matKhau.trim().isEmpty()
                || xacNhanMatKhau == null || xacNhanMatKhau.trim().isEmpty()
                || diaChi == null || diaChi.trim().isEmpty()) {

            request.setAttribute("error", "Vui lòng điền đầy đủ tất cả thông tin!");
            request.getRequestDispatcher("DangKy.jsp").forward(request, response);
            return;
        }

        // ====================== KIỂM TRA MẬT KHẨU ======================
        if (matKhau.trim().length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự!");
            request.getRequestDispatcher("DangKy.jsp").forward(request, response);
            return;
        }

        if (!matKhau.equals(xacNhanMatKhau)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("DangKy.jsp").forward(request, response);
            return;
        }

        // ====================== KIỂM TRA EMAIL ======================
        String emailTrim = email.trim();
        if (!emailTrim.matches(EMAIL_REGEX)) {
            request.setAttribute("error", "Email không hợp lệ! Vui lòng nhập đúng định dạng (ví dụ: tenban@gmail.com)");
            request.getRequestDispatcher("DangKy.jsp").forward(request, response);
            return;
        }

        // ====================== KIỂM TRA SỐ ĐIỆN THOẠI ======================
        String phoneTrim = soDienThoai.trim();
        if (!phoneTrim.matches(PHONE_REGEX)) {
            request.setAttribute("error", "Số điện thoại không hợp lệ! Phải bắt đầu bằng 0 và đúng 10 chữ số (ví dụ: 0912345678)");
            request.getRequestDispatcher("DangKy.jsp").forward(request, response);
            return;
        }

        // ====================== THỰC HIỆN ĐĂNG KÝ ======================
        try {
            UserDAO dao = new UserDAO();
            NhatKyDAO logDAO = new NhatKyDAO();

            // Kiểm tra email đã tồn tại
            if (dao.isEmailExists(emailTrim)) {
                request.setAttribute("error", "Email này đã được đăng ký. Vui lòng dùng email khác.");
                request.getRequestDispatcher("DangKy.jsp").forward(request, response);
                return;
            }

            // Kiểm tra số điện thoại đã tồn tại
            if (dao.isPhoneExists(phoneTrim)) {
                request.setAttribute("error", "Số điện thoại này đã được đăng ký.");
                request.getRequestDispatcher("DangKy.jsp").forward(request, response);
                return;
            }

            // Tạo đối tượng User
            User newUser = new User();
            newUser.setHoTen(hoTen.trim());
            newUser.setEmail(emailTrim);
            newUser.setSoDienThoai(phoneTrim);
            newUser.setMatKhau(matKhau);           // Nên hash mật khẩu sau này
            newUser.setDiaChi(diaChi.trim());
            newUser.setVaiTro("KhachHang");
            int userId = dao.register(newUser);

            if (userId > 0) {

                logDAO.insertLog(userId, "Đăng ký tài khoản", "Hệ thống");

                request.setAttribute("success", "Đăng ký thành công!");
                request.getRequestDispatcher("Login.jsp").forward(request, response);

            } else {
                request.setAttribute("error", "Đăng ký thất bại");
                request.getRequestDispatcher("DangKy.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("DangKy.jsp").forward(request, response);
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
