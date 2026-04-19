/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.ChiTietDonHang;
import Model.ChiTietDonHangDAO;
import Model.DonHang;
import Model.DonHangDAO;
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
@WebServlet(name = "Admin_QuanLyDonHangController", urlPatterns = {"/Admin_QuanLyDonHangController"})
public class Admin_QuanLyDonHangController extends HttpServlet {

    private DonHangDAO donHangDAO = new DonHangDAO();
    private ChiTietDonHangDAO chiTietDAO = new ChiTietDonHangDAO();

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
            out.println("<title>Servlet Admin_QuanLyDonHangController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Admin_QuanLyDonHangController at " + request.getContextPath() + "</h1>");
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
        String action = request.getParameter("action");

        try {
            if (action == null || action.equals("list")) {

                List<DonHang> list = donHangDAO.getAllDonHang();
                request.setAttribute("listDonHang", list);

                request.getRequestDispatcher("admin_QuanLyDonHang.jsp").forward(request, response);

            } else if (action.equals("detail")) {

                int maDonHang = Integer.parseInt(request.getParameter("id"));

                DonHang donHang = donHangDAO.getById(maDonHang); 

                List<ChiTietDonHang> list = chiTietDAO.getChiTietByDonHang(maDonHang);

                request.setAttribute("donHang", donHang);
                request.setAttribute("chiTietList", list);

                request.getRequestDispatcher("admin_ChiTietDonHang.jsp")
                        .forward(request, response);
            }

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

        String action = request.getParameter("action");

        try {
            if ("updateStatus".equals(action)) {

                int maDonHang = Integer.parseInt(request.getParameter("maDonHang"));
                String trangThai = request.getParameter("trangThai");

                boolean ok = donHangDAO.updateTrangThai(maDonHang, trangThai);

                if (ok) {
                    request.getSession().setAttribute("success", "Cập nhật thành công!");
                } else {
                    request.getSession().setAttribute("error", "Cập nhật thất bại!");
                }

                response.sendRedirect("Admin_QuanLyDonHangController");

            } else if ("duyetHoan".equals(action)) {

                int id = Integer.parseInt(request.getParameter("maDonHang"));
                donHangDAO.duyetHoan(id);

                request.getSession().setAttribute("success", "Đã duyệt hoàn!");
                response.sendRedirect("Admin_QuanLyDonHangController");

            } else if ("tuChoiHoan".equals(action)) {

                int id = Integer.parseInt(request.getParameter("maDonHang"));

                donHangDAO.tuChoiHoan(id);

                request.getSession().setAttribute("success", "Đã từ chối hoàn!");
                response.sendRedirect("Admin_QuanLyDonHangController");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi hệ thống!");
            response.sendRedirect("Admin_QuanLyDonHangController");
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
