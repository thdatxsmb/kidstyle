/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.LichSuTonKho;
import Model.LichSuTonKhoDAO;
import Model.SanPham;
import Model.SanPhamDAO;
import Model.ThongKeDAO;
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
@WebServlet(name = "Admin_TonKhoController", urlPatterns = {"/Admin_TonKhoController"})
public class Admin_TonKhoController extends HttpServlet {

    private final LichSuTonKhoDAO tonKhoDAO = new LichSuTonKhoDAO();

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
            out.println("<title>Servlet Admin_TonKhoController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Admin_TonKhoController at " + request.getContextPath() + "</h1>");
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
        // Lấy tham số tìm kiếm và lọc
        String keyword = request.getParameter("keyword");
        String maSanPhamFilterStr = request.getParameter("maSanPhamFilter");

        Integer maSanPhamFilter = null;
        if (maSanPhamFilterStr != null && !maSanPhamFilterStr.trim().isEmpty()) {
            try {
                maSanPhamFilter = Integer.parseInt(maSanPhamFilterStr);
            } catch (NumberFormatException e) {
                maSanPhamFilter = null;
            }
        }

        // Lấy danh sách sản phẩm
        List<SanPham> danhSachSanPham;
        if (keyword != null && !keyword.trim().isEmpty()) {
            danhSachSanPham = tonKhoDAO.timKiemSanPham(keyword.trim());
        } else {
            danhSachSanPham = tonKhoDAO.getAllSanPham();
        }

        // Lấy lịch sử tồn kho
        List<LichSuTonKho> danhSachLichSu;
        if (maSanPhamFilter != null) {
            danhSachLichSu = tonKhoDAO.getLichSuBySanPham(maSanPhamFilter);
        } else {
            danhSachLichSu = tonKhoDAO.getAllLichSu();
        }

        // Gửi dữ liệu sang JSP
        request.setAttribute("danhSachSanPham", danhSachSanPham);
        request.setAttribute("danhSachLichSu", danhSachLichSu);
        request.setAttribute("keyword", keyword);
        request.setAttribute("maSanPhamFilter", maSanPhamFilter);

        request.getRequestDispatcher("admin_TonKho.jsp").forward(request, response);
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
        if (action == null || action.isEmpty()) {
            response.sendRedirect("Admin_TonKhoController");
            return;
        }

        HttpSession session = request.getSession(false); // false = không tạo session mới
        if (session == null || session.getAttribute("maNguoiDung") == null) {
            response.sendRedirect("../Login");   // Chuyển về trang login nếu chưa đăng nhập
            return;
        }

        int maNguoiDung = (Integer) session.getAttribute("maNguoiDung");

        boolean success = false;

        try {
            if ("nhap".equals(action)) {
                int maSanPham = Integer.parseInt(request.getParameter("maSanPham"));
                int soLuong = Integer.parseInt(request.getParameter("soLuong"));
                double donGiaNhap = Double.parseDouble(request.getParameter("donGiaNhap"));
                String ghiChu = request.getParameter("ghiChu") != null ? request.getParameter("ghiChu") : "";

                success = tonKhoDAO.nhapHang(maSanPham, soLuong, donGiaNhap, ghiChu, maNguoiDung);

            } else if ("dieuchinh".equals(action)) {
                int maSanPham = Integer.parseInt(request.getParameter("maSanPham"));
                int soLuong = Integer.parseInt(request.getParameter("soLuong"));
                String ghiChu = request.getParameter("ghiChu") != null ? request.getParameter("ghiChu") : "";

                success = tonKhoDAO.dieuChinhTonKho(maSanPham, soLuong, ghiChu, maNguoiDung);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            success = false;
        } catch (Exception e) {
            e.printStackTrace();
            success = false;
        }

        if (success) {
            response.sendRedirect("Admin_TonKhoController?success=true");
        } else {
            response.sendRedirect("Admin_TonKhoController?error=true");
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
