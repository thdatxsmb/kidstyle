/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.ThanhToan;
import Model.ThanhToanDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

/**
 *
 * @author LEGION 5
 */
@WebServlet(name = "Admin_ThanhToanController", urlPatterns = {"/Admin_ThanhToanController"})
public class Admin_ThanhToanController extends HttpServlet {

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
            out.println("<title>Servlet Admin_ThanhToanController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Admin_ThanhToanController at " + request.getContextPath() + "</h1>");
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
            ThanhToanDAO dao = new ThanhToanDAO();
            List<ThanhToan> list = dao.getAllThanhToan(); // cần viết thêm

            request.setAttribute("danhSachThanhToan", list);
            request.getRequestDispatcher("admin_ThanhToan.jsp")
                    .forward(request, response);

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

            ThanhToanDAO dao = new ThanhToanDAO();

            // ================== DUYỆT THANH TOÁN ==================
            if ("duyet".equals(action)) {

                int maThanhToan = Integer.parseInt(request.getParameter("maThanhToan"));

                boolean success = dao.duyetThanhToan(maThanhToan);

                if (success) {
                    request.getSession().setAttribute("message", "✔ Duyệt thành công!");
                } else {
                    request.getSession().setAttribute("message", "❌ Duyệt thất bại!");
                }

                response.sendRedirect("Admin_ThanhToanController");
                return;
            }

            // ================== TẠO THANH TOÁN ==================
            int maDonHang = Integer.parseInt(request.getParameter("maDonHang"));
            double soTien = Double.parseDouble(request.getParameter("soTien"));
            String phuongThuc = request.getParameter("phuongThuc");

            ThanhToan tt = new ThanhToan();
            tt.setMaDonHang(maDonHang);
            tt.setSoTien(soTien);
            tt.setPhuongThuc(phuongThuc);

            if ("COD".equals(phuongThuc)) {
                tt.setTrangThai("ChoThanhToan");
                tt.setMaGiaoDich("COD_" + System.currentTimeMillis());
            } else {
                tt.setTrangThai("DaThanhToan");
                tt.setMaGiaoDich(UUID.randomUUID().toString());
            }

            boolean success = dao.themThanhToan(tt);

            if (success) {
                request.getSession().setAttribute("message", "✔ Thanh toán thành công!");
            } else {
                request.getSession().setAttribute("message", "❌ Thanh toán thất bại!");
            }

            response.sendRedirect("Admin_ThanhToanController");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
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
