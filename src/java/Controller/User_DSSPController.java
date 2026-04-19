/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.DanhMuc;
import Model.DanhMucDAO;
import Model.SanPham;
import Model.SanPhamDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author LEGION 5
 */
@WebServlet(name = "User_DSSPController", urlPatterns = {"/User_DSSPController"})
public class User_DSSPController extends HttpServlet {

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
            out.println("<title>Servlet User_DSSPController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet User_DSSPController at " + request.getContextPath() + "</h1>");
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

 DanhMucDAO dmDao = new DanhMucDAO();
        SanPhamDAO spDao = new SanPhamDAO();

        // 1. Lấy tất cả danh mục
        List<DanhMuc> dsDanhMuc = dmDao.getAllDanhMuc();
        request.setAttribute("dsDanhMuc", dsDanhMuc);

        // 2. Xử lý phân trang
        int page = 1;
        int pageSize = 12; // Số lượng SP mỗi trang
        try {
            String p = request.getParameter("page");
            if (p != null) page = Integer.parseInt(p);
        } catch (Exception e) { page = 1; }

        // 3. Xử lý Tìm kiếm hoặc Lọc theo Danh mục
        String keyword = request.getParameter("keyword");
        String maDM_raw = request.getParameter("maDanhMuc");
        
        List<SanPham> dsSanPham = null;
        int totalProducts = 0;

        if (keyword != null && !keyword.trim().isEmpty()) {
            // Trường hợp TÌM KIẾM
            dsSanPham = spDao.timKiemSanPhamPaging(keyword.trim(), page, pageSize);
            totalProducts = spDao.countSanPhamSearch(keyword.trim());
            request.setAttribute("searchKeyword", keyword);
        } else if (maDM_raw != null && !maDM_raw.isEmpty()) {
            // Trường hợp LỌC THEO DANH MỤC
            int maDM = Integer.parseInt(maDM_raw);
            dsSanPham = spDao.getSanPhamByDanhMuc(maDM); // Lấy 12 cái cùng loại
            totalProducts = dsSanPham.size(); // Không phân trang sâu cho DM nếu không cần thiết
            request.setAttribute("selectedDM", maDM);
        } else {
            // Trường hợp TẤT CẢ
            dsSanPham = spDao.getSanPhamPaging(page, pageSize);
            totalProducts = spDao.countSanPham();
        }

        int totalPage = (int) Math.ceil((double) totalProducts / pageSize);

        request.setAttribute("dsSanPham", dsSanPham);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPage", totalPage);

        request.getRequestDispatcher("User_DanhSachSanPham.jsp").forward(request, response);
    
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
        doGet(request, response);
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
