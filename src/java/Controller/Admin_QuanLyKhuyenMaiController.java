/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.DanhMucDAO;
import Model.KhuyenMai;
import Model.KhuyenMaiDAO;
import Model.SanPhamDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 *
 * @author LEGION 5
 */
@WebServlet(name = "Admin_QuanLyKhuyenMaiController", urlPatterns = {"/Admin_QuanLyKhuyenMaiController"})
public class Admin_QuanLyKhuyenMaiController extends HttpServlet {

    private KhuyenMaiDAO dao = new KhuyenMaiDAO();
    private SanPhamDAO spDao = new SanPhamDAO();
    private DanhMucDAO dmDao = new DanhMucDAO();

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
            out.println("<title>Servlet Admin_QuanLyKhuyenMaiController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Admin_QuanLyKhuyenMaiController at " + request.getContextPath() + "</h1>");
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
        try {
            String action = request.getParameter("action");

            // Nút "Đồng bộ giá" thủ công
            if ("sync".equals(action)) {
                dao.dongBoGiaSanPham();
                response.sendRedirect("Admin_QuanLyKhuyenMaiController");
                return;
            }

            // Xoá khuyến mãi
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.xoa(id);
                response.sendRedirect("Admin_QuanLyKhuyenMaiController");
                return;
            }

            // Mặc định: Hiển thị danh sách và tự động đồng bộ để đảm bảo dữ liệu mới nhất
            dao.dongBoGiaSanPham();

            request.setAttribute("listKM", dao.layTatCa());
            request.setAttribute("listSP", spDao.getAllSanPham());
            request.setAttribute("listDM", dmDao.getAllDanhMuc());
            request.getRequestDispatcher("admin_QuanLyKhuyenMai.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
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
        try {
            String action = request.getParameter("action");
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

            KhuyenMai km = new KhuyenMai();
            if ("edit".equals(action)) {
                km.setMaKhuyenMai(Integer.parseInt(request.getParameter("id")));
            }

            km.setTenKhuyenMai(request.getParameter("ten"));
            km.setPhanTramGiam(Double.parseDouble(request.getParameter("phanTram")));
            km.setGiaTriGiam(Double.parseDouble(request.getParameter("giaTri")));
            km.setNgayBatDau(sdf.parse(request.getParameter("batDau")));
            km.setNgayKetThuc(sdf.parse(request.getParameter("ketThuc")));

            // Lấy ID từ giao diện (0 = Toàn shop)
            int maSP = Integer.parseInt(request.getParameter("maSP"));
            int maDM = Integer.parseInt(request.getParameter("maDM"));

            // Logic duy nhất: Chỉ chọn SP HOẶC Danh mục (Ưu tiên sản phẩm lẻ nếu có cả 2 - đề phòng)
            if (maSP > 0) {
                maDM = 0;
            }

            km.setMaSanPham(maSP);
            km.setMaDanhMuc(maDM);

            if ("add".equals(action)) {
                dao.themMoi(km);
            } else {
                dao.capNhat(km);
            }

            response.sendRedirect("Admin_QuanLyKhuyenMaiController");
        } catch (Exception e) {
            e.printStackTrace();
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
