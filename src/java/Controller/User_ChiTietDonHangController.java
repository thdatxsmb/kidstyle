/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.ChiTietDonHang;
import Model.ChiTietDonHangDAO;
import Model.DonHang;
import Model.DonHangDAO;
import Model.User;
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
@WebServlet(name = "User_ChiTietDonHangController", urlPatterns = {"/User_ChiTietDonHangController"})
public class User_ChiTietDonHangController extends HttpServlet {

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
            out.println("<title>Servlet User_ChiTietDonHangController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet User_ChiTietDonHangController at " + request.getContextPath() + "</h1>");
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
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if (user == null) {
                response.sendRedirect("Login.jsp");
                return;
            }

            int maDon = Integer.parseInt(request.getParameter("id"));

            DonHangDAO donDAO = new DonHangDAO();
            ChiTietDonHangDAO ctDAO = new ChiTietDonHangDAO();

            DonHang don = donDAO.getById(maDon);
            List<ChiTietDonHang> list = ctDAO.getByDonHang(maDon);

            // ❗ CHECK quyền: user chỉ xem đơn của mình
            if (don == null || don.getMaNguoiDung() != user.getMaNguoiDung()) {
                response.sendRedirect("User_DonHangController");
                return;
            }

            request.setAttribute("donHang", don);
            request.setAttribute("chiTietList", list);

            request.getRequestDispatcher("User_ChiTietDonHang.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("User_DonHangController");
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
        DonHangDAO donDAO = new DonHangDAO();

        String action = request.getParameter("action");
        int id = Integer.parseInt(request.getParameter("id"));

        if ("hoan".equals(action)) {
            String lyDo = request.getParameter("lyDo");
            String lyDoKhac = request.getParameter("lyDoKhac");

            if ("Khác".equals(lyDo)) {
                lyDo = lyDoKhac;
            }

            donDAO.yeuCauHoan(id, lyDo);
        }

        if ("huy".equals(action)) {
            String lyDo = request.getParameter("lyDo");
            String lyDoKhac = request.getParameter("lyDoKhac");

            if ("Khác".equals(lyDo)) {
                lyDo = lyDoKhac;
            }

            donDAO.huyDon(id, lyDo);
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
