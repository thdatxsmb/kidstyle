/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.GioHang;
import Model.GioHangAdmin;
import Model.GioHangAdminDAO;
import Model.GioHangDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author LEGION 5
 */
@WebServlet(name = "Admin_QuanLyGioHangController", urlPatterns = {"/Admin_QuanLyGioHangController"})
public class Admin_QuanLyGioHangController extends HttpServlet {

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
        String action = request.getParameter("action");

        GioHangAdminDAO adminDAO = new GioHangAdminDAO();
        GioHangDAO gioHangDAO = new GioHangDAO();

        try {

            // ❌ XÓA GIỎ USER
            if ("delete".equals(action)) {
                int maNguoiDung = Integer.parseInt(request.getParameter("maNguoiDung"));

                adminDAO.xoaGioHangCuaUser(maNguoiDung);

                response.sendRedirect("Admin_QuanLyGioHangController");
                return;
            }

            // 👁️ XEM CHI TIẾT GIỎ
            if ("view".equals(action)) {
                int maNguoiDung = Integer.parseInt(request.getParameter("maNguoiDung"));

                List<GioHang> list = adminDAO.getChiTietGioHang(maNguoiDung);

                double tongTien = 0;
                for (GioHang g : list) {
                    double gia = (g.getGiaKhuyenMai() > 0) ? g.getGiaKhuyenMai() : g.getGiaBan();
                    tongTien += gia * g.getSoLuong();
                }

                request.setAttribute("listChiTiet", list);
                request.setAttribute("tongTien", tongTien);
                request.setAttribute("maNguoiDung", maNguoiDung);

                request.getRequestDispatcher("admin_ChiTietGioHang.jsp").forward(request, response);
                return;
            }

            // 👉 DANH SÁCH USER
            // Thay thế phần lấy list bằng đoạn này để test
            List<GioHangAdmin> list = adminDAO.getGioHangTheoUser();
            System.out.println("Số user có giỏ hàng: " + list.size());
            if (list.isEmpty()) {
                System.out.println(">>> List rỗng - SQL không trả về dòng nào");
            } else {
                for (GioHangAdmin g : list) {
                    System.out.println(g.getMaNguoiDung() + " - " + g.getTenDangNhap()
                            + " - SP: " + g.getTongSanPham() + " - Tiền: " + g.getTongTien());
                }
            }
            request.setAttribute("list", list);
            request.getRequestDispatcher("admin_QuanLyGioHang.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
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
