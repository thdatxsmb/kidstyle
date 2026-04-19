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
import java.util.List;

/**
 *
 * @author LEGION 5
 */
@WebServlet(name = "Admin_QuanLyNguoiDungController", urlPatterns = {"/Admin_QuanLyNguoiDungController"})
public class Admin_QuanLyNguoiDungController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        try {
            userDAO = new UserDAO();
        } catch (Exception e) {
            throw new RuntimeException("Không thể khởi tạo UserDAO", e);
        }
    }

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
            out.println("<title>Servlet Admin_QuanLyNguoiDungController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Admin_QuanLyNguoiDungController at " + request.getContextPath() + "</h1>");
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
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        User admin = (User) (session != null ? session.getAttribute("user") : null);

        if (admin == null || !"QuanTri".equals(admin.getVaiTro())) {
            response.sendRedirect("Login.jsp");
            return;
        }

        try {
            String action = request.getParameter("action");

            if ("delete".equals(action)) {
                int maNguoiDung = Integer.parseInt(request.getParameter("maNguoiDung"));

                if (admin.getMaNguoiDung() == maNguoiDung) {
                    session.setAttribute("error", "Bạn không thể xóa chính tài khoản của mình!");
                } else {
                    try {
                        if (userDAO.deleteUser(maNguoiDung)) {
                            session.setAttribute("success", "Xóa người dùng thành công!");
                        } else {
                            session.setAttribute("error", "Không thể xóa người dùng này!");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        session.setAttribute("error", "Lỗi khi xóa: " + e.getMessage());
                    }
                }

                response.sendRedirect("Admin_QuanLyNguoiDungController");
                return; // QUAN TRỌNG
            }

            List<User> list = userDAO.getAllUsers();
            request.setAttribute("danhSachNguoiDung", list);
            request.getRequestDispatcher("admin_QuanLyNguoiDung.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("admin_QuanLyNguoiDung.jsp").forward(request, response);
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
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                xuLyThemMoi(request, response);
            } else if ("edit".equals(action)) {
                xuLyCapNhat(request, response);
            } else {
                response.sendRedirect("Admin_QuanLyNguoiDungController");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi hệ thống!");
            response.sendRedirect("Admin_QuanLyNguoiDungController");
        }
    }

// ====================== THÊM NGƯỜI DÙNG MỚI ======================
    private void xuLyThemMoi(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String hoTen = req.getParameter("hoTen");
        String email = req.getParameter("email");
        String soDienThoai = req.getParameter("soDienThoai");
        String diaChi = req.getParameter("diaChi");
        String matKhau = req.getParameter("matKhau");
        String vaiTro = req.getParameter("vaiTro");

        if (isEmpty(hoTen) || isEmpty(email) || isEmpty(matKhau)) {
            req.getSession().setAttribute("error", "Vui lòng điền đầy đủ Họ tên, Email và Mật khẩu!");
            resp.sendRedirect("Admin_QuanLyNguoiDungController");
            return;
        }

        if (!email.matches("^[\\w._%+-]+@[\\w.-]+\\.[a-zA-Z]{2,6}$")) {
            req.getSession().setAttribute("error", "Email không hợp lệ!");
            resp.sendRedirect("Admin_QuanLyNguoiDungController");
            return;
        }

        if (!isEmpty(soDienThoai)) {
            if (!soDienThoai.matches("\\d+")) {
                req.getSession().setAttribute("error", "SĐT chỉ được chứa số!");
                resp.sendRedirect("Admin_QuanLyNguoiDungController");
                return;
            }

            if (soDienThoai.length() < 10) {
                req.getSession().setAttribute("error", "SĐT phải đủ 10 số!");
                resp.sendRedirect("Admin_QuanLyNguoiDungController");
                return;
            }

            if (soDienThoai.length() > 10) {
                req.getSession().setAttribute("error", "SĐT chỉ được tối đa 10 số!");
                resp.sendRedirect("Admin_QuanLyNguoiDungController");
                return;
            }

            if (!soDienThoai.matches("^(03|05|07|08|09)\\d{8}$")) {
                req.getSession().setAttribute("error", "SĐT phải đúng đầu số Việt Nam (03,05,07,08,09)!");
                resp.sendRedirect("Admin_QuanLyNguoiDungController");
                return;
            }
        }
        // ==================== KIỂM TRA TRÙNG LẶP  ====================
        if (userDAO.isEmailExists(email)) {
            req.getSession().setAttribute("error", "Email đã tồn tại!");
        } else if (!isEmpty(soDienThoai) && userDAO.isPhoneExists(soDienThoai)) {
            req.getSession().setAttribute("error", "Số điện thoại đã tồn tại!");
        } else {
            User u = new User();
            u.setHoTen(hoTen.trim());
            u.setEmail(email.trim());
            u.setSoDienThoai(soDienThoai != null ? soDienThoai.trim() : null);
            u.setDiaChi(diaChi != null ? diaChi.trim() : null);
            u.setMatKhau(matKhau);           // Nên hash sau này
            u.setVaiTro(vaiTro != null && !vaiTro.isEmpty() ? vaiTro : "KhachHang");

            int id = userDAO.register(u);

            if (id > 0) {
                NhatKyDAO logDAO = new NhatKyDAO();
                req.getSession().setAttribute("success", "Thêm người dùng thành công!");
                logDAO.insertLog(id, "Đăng ký tài khoản", "Hệ thống");

            } else {
                req.getSession().setAttribute("error", "Thêm người dùng thất bại!");
            }

        }
        resp.sendRedirect("Admin_QuanLyNguoiDungController");
    }

    // ====================== CẬP NHẬT NGƯỜI DÙNG ======================
    private void xuLyCapNhat(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int maNguoiDung = Integer.parseInt(req.getParameter("maNguoiDung"));
        String hoTen = req.getParameter("hoTen");
        String email = req.getParameter("email");
        String soDienThoai = req.getParameter("soDienThoai");
        String diaChi = req.getParameter("diaChi");
        String matKhau = req.getParameter("matKhau");   // có thể để trống
        String vaiTro = req.getParameter("vaiTro");

        if (isEmpty(hoTen) || isEmpty(email)) {
            req.getSession().setAttribute("error", "Họ tên và Email không được để trống!");
            resp.sendRedirect("Admin_QuanLyNguoiDungController");
            return;
        }

        if (!email.matches("^[\\w._%+-]+@[\\w.-]+\\.[a-zA-Z]{2,6}$")) {
            req.getSession().setAttribute("error", "Email không hợp lệ!");
            resp.sendRedirect("Admin_QuanLyNguoiDungController");
            return;
        }

        if (!isEmpty(soDienThoai)) {
            if (!soDienThoai.matches("\\d+")) {
                req.getSession().setAttribute("error", "SĐT chỉ được chứa số!");
                resp.sendRedirect("Admin_QuanLyNguoiDungController");
                return;
            }

            if (soDienThoai.length() < 10) {
                req.getSession().setAttribute("error", "SĐT phải đủ 10 số!");
                resp.sendRedirect("Admin_QuanLyNguoiDungController");
                return;
            }

            if (soDienThoai.length() > 10) {
                req.getSession().setAttribute("error", "SĐT chỉ được tối đa 10 số!");
                resp.sendRedirect("Admin_QuanLyNguoiDungController");
                return;
            }

            if (!soDienThoai.matches("^(03|05|07|08|09)\\d{8}$")) {
                req.getSession().setAttribute("error", "SĐT phải đúng đầu số Việt Nam (03,05,07,08,09)!");
                resp.sendRedirect("Admin_QuanLyNguoiDungController");
                return;
            }
        }

        // Kiểm tra trùng khi sửa (bỏ qua chính nó)
        if (userDAO.checkEmailExists(email, maNguoiDung)) {
            req.getSession().setAttribute("error", "Email đã được sử dụng bởi tài khoản khác!");
        } else if (!isEmpty(soDienThoai) && userDAO.checkSDTExist(soDienThoai, maNguoiDung)) {
            req.getSession().setAttribute("error", "Số điện thoại đã được sử dụng bởi tài khoản khác!");
        } else {
            User u = new User();
            u.setMaNguoiDung(maNguoiDung);
            u.setHoTen(hoTen.trim());
            u.setEmail(email.trim());
            u.setSoDienThoai(soDienThoai);
            u.setDiaChi(diaChi);
            u.setMatKhau(matKhau);
            u.setVaiTro(vaiTro);

            boolean updatePassword = !isEmpty(matKhau);

            boolean result = userDAO.updateUser(u, updatePassword);

            if (result) {
                req.getSession().setAttribute("success", "Cập nhật thành công!");
            } else {
                req.getSession().setAttribute("error", "Không có thay đổi hoặc dữ liệu không hợp lệ!");
            }
        }
        resp.sendRedirect("Admin_QuanLyNguoiDungController");
    }

    private boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
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
