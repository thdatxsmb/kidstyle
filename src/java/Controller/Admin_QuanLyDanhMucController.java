/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.DanhMuc;
import Model.DanhMucDAO;
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
@WebServlet(name = "Admin_QuanLyDanhMucController", urlPatterns = {"/Admin_QuanLyDanhMucController"})
public class Admin_QuanLyDanhMucController extends HttpServlet {

    DanhMucDAO dao = new DanhMucDAO();

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
            out.println("<title>Servlet Admin_QuanLyDanhMucController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Admin_QuanLyDanhMucController at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean deleted = dao.deleteDanhMuc(id);

                if (deleted) {
                    session.setAttribute("success", "Xóa danh mục thành công!");
                } else {
                    session.setAttribute("error", "Không thể xóa danh mục này! (Có thể đang có sản phẩm liên kết)");
                }
                response.sendRedirect("Admin_QuanLyDanhMucController");
                return;
            }

            // Load danh sách danh mục
            List<Model.DanhMuc> list = dao.getAllDanhMuc();
            request.setAttribute("danhSachDanhMuc", list);
            request.getRequestDispatcher("admin_QuanLyDanhMuc.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect("Admin_QuanLyDanhMucController");
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
        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                xuLyThemMoi(request, session);
            } else if ("edit".equals(action)) {
                xuLyCapNhat(request, session);
            } else {
                response.sendRedirect("Admin_QuanLyDanhMucController");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi hệ thống!");
        }

        response.sendRedirect("Admin_QuanLyDanhMucController");
    }

    // ====================== THÊM DANH MỤC MỚI ======================
    private void xuLyThemMoi(HttpServletRequest req, HttpSession session) {
        String tenDanhMuc = req.getParameter("tenDanhMuc");
        String moTa = req.getParameter("moTa");

        if (isEmpty(tenDanhMuc)) {
            session.setAttribute("error", "Tên danh mục không được để trống!");
            return;
        }

        // Kiểm tra trùng tên
        if (dao.isTenDanhMucExists(tenDanhMuc.trim())) {
            session.setAttribute("error", "Tên danh mục đã tồn tại!");
            return;
        }

        boolean success = dao.insertDanhMuc(tenDanhMuc.trim(), moTa != null ? moTa.trim() : null);

        if (success) {
            session.setAttribute("success", "Thêm danh mục thành công!");
        } else {
            session.setAttribute("error", "Thêm danh mục thất bại!");
        }
    }

    // ====================== CẬP NHẬT DANH MỤC ======================
    private void xuLyCapNhat(HttpServletRequest req, HttpSession session) {
        try {
            int maDanhMuc = Integer.parseInt(req.getParameter("maDanhMuc"));
            String tenDanhMuc = req.getParameter("tenDanhMuc");
            String moTa = req.getParameter("moTa");

            if (isEmpty(tenDanhMuc)) {
                session.setAttribute("error", "Tên danh mục không được để trống!");
                return;
            }

            // Kiểm tra trùng tên (bỏ qua danh mục hiện tại)
            if (dao.isTenDanhMucExists(tenDanhMuc.trim(), maDanhMuc)) {
                session.setAttribute("error", "Tên danh mục đã tồn tại!");
                return;
            }

            boolean success = dao.updateDanhMuc(maDanhMuc, tenDanhMuc.trim(),
                    moTa != null ? moTa.trim() : null);

            if (success) {
                session.setAttribute("success", "Cập nhật danh mục thành công!");
            } else {
                session.setAttribute("error", "Cập nhật danh mục thất bại!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi khi cập nhật danh mục!");
        }
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
