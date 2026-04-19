/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.KhuyenMai;
import Model.KhuyenMaiDAO;
import Model.SanPham;
import Model.SanPhamDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author LEGION 5
 */
@WebServlet(name = "User_KhuyenMaiController", urlPatterns = {"/User_KhuyenMaiController"})
public class User_KhuyenMaiController extends HttpServlet {

        private SanPhamDAO spDao = new SanPhamDAO();
    private KhuyenMaiDAO kmDao = new KhuyenMaiDAO();

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
            out.println("<title>Servlet User_KhuyenMaiController</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet User_KhuyenMaiController at " + request.getContextPath() + "</h1>");
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
            // Lấy tất cả khuyến mãi đang hoạt động để làm Banner/Tiêu đề
            List<KhuyenMai> dsKM = kmDao.layTatCa();
            
            // Lọc ra các KM đang trong thời hạn (Client side check for display)
            long now = System.currentTimeMillis();
            List<KhuyenMai> dsKMActive = dsKM.stream()
                    .filter(km -> km.getNgayBatDau().getTime() <= now && km.getNgayKetThuc().getTime() >= now)
                    .collect(Collectors.toList());

            // Lấy danh sách sản phẩm đang có giá khuyến mãi
            List<SanPham> dsSanPhamSale = spDao.getSanPhamKhuyenMai();

            request.setAttribute("dsKMActive", dsKMActive);
            request.setAttribute("dsSanPhamSale", dsSanPhamSale);
            
            request.getRequestDispatcher("User_KhuyenMai.jsp").forward(request, response);
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
        processRequest(request, response);
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