/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.DonHangDAO;
import Model.NhatKyDAO;
import Model.ThongKeDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author LEGION 5
 */
@WebServlet(name = "Admin_HomeController", urlPatterns = {"/Admin_HomeController"})
public class Admin_HomeController extends HttpServlet {

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
            out.println("<title>Servlet Admin_HomeController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Admin_HomeController at " + request.getContextPath() + "</h1>");
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
            ThongKeDAO thongKeDAO = new ThongKeDAO();
            DonHangDAO donHangDAO = new DonHangDAO();
            NhatKyDAO logDAO = new NhatKyDAO();

            request.setAttribute("soUser", thongKeDAO.countUsers());
            request.setAttribute("soSP", thongKeDAO.countSanPham());
            request.setAttribute("soDon", thongKeDAO.countDonHang());
            request.setAttribute("trangThaiDon", thongKeDAO.getDonTheoTrangThai());
            request.setAttribute("doanhThu", thongKeDAO.tongDoanhThu());
            request.setAttribute("listLog", logDAO.getRecentLogs());
            request.setAttribute("listDon", donHangDAO.getAllDonHang());

            request.getRequestDispatcher("HomeAdmin.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h2 style='color:red'>LỖI TRONG CONTROLLER:</h2>");
            response.getWriter().println("<pre>" + e.getMessage() + "</pre>");
            e.printStackTrace(response.getWriter());
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
