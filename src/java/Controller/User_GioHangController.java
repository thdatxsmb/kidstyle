/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.GioHang;
import Model.GioHangDAO;
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
@WebServlet(name = "User_GioHangController", urlPatterns = {"/User_GioHangController"})
public class User_GioHangController extends HttpServlet {

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
            out.println("<title>Servlet User_GioHangController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet User_GioHangController at " + request.getContextPath() + "</h1>");
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
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        GioHangDAO dao = new GioHangDAO();

        String action = request.getParameter("action");

        try {

            if ("add".equals(action)) {

                int maSP = Integer.parseInt(request.getParameter("maSP"));

                int sl = 1;

                if (request.getParameter("sl") != null) {
                    sl = Integer.parseInt(request.getParameter("sl"));
                }

                dao.themVaoGio(user.getMaNguoiDung(), maSP, sl);
            }

            if ("update".equals(action)) {

                int ma = Integer.parseInt(request.getParameter("ma"));
                int sl = Integer.parseInt(request.getParameter("sl"));

                dao.updateSoLuong(ma, sl);
            }

            if ("delete".equals(action)) {

                int ma = Integer.parseInt(request.getParameter("ma"));

                dao.xoaSanPham(ma);
            }
            if ("deleteSelected".equals(action)) {

                String ids = request.getParameter("ids");

                if (ids != null) {

                    String[] arr = ids.split(",");

                    for (String id : arr) {
                        dao.xoaSanPham(Integer.parseInt(id));
                    }
                }
            }

            if ("updateAjax".equals(action)) {

                int ma = Integer.parseInt(request.getParameter("ma"));
                int sl = Integer.parseInt(request.getParameter("sl"));

                dao.updateSoLuong(ma, sl);

                response.getWriter().print("ok");
                return; // QUAN TRỌNG
            }

            // Lấy danh sách giỏ hàng
            List<GioHang> list = dao.getGioHangByUser(user.getMaNguoiDung());

            request.setAttribute("gioHang", list);

            request.getRequestDispatcher("User_GioHang.jsp").forward(request, response);

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
