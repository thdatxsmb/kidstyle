/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.HoTro;
import Model.HoTroDAO;
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
@WebServlet(name = "User_HoTroController", urlPatterns = {"/User_HoTroController"})
public class User_HoTroController extends HttpServlet {

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
            out.println("<title>Servlet User_HoTroController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet User_HoTroController at " + request.getContextPath() + "</h1>");
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
            Model.User user = (Model.User) request.getSession().getAttribute("user");

            if (user != null) {
                HoTroDAO dao = new HoTroDAO();

                // 👉 bạn cần thêm hàm này (lọc theo email hoặc user)
                request.setAttribute("listHoTroUser",
                        dao.getByEmail(user.getEmail()));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        String referer = request.getHeader("referer");
        response.sendRedirect(referer);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String source = request.getParameter("source"); // 👈 THÊM

        try {
            String ten = request.getParameter("ten");
            String email = request.getParameter("email");
            String sdt = request.getParameter("sdt");
            String noiDung = request.getParameter("noiDung");

            HoTro ht = new HoTro();
            ht.setTenNguoiGui(ten);
            ht.setEmail(email);
            ht.setSoDienThoai(sdt);
            ht.setNoiDung(noiDung);
            ht.setTrangThai("ChoXuLy");

            HoTroDAO dao = new HoTroDAO();
            dao.insert(ht);

            request.getSession().setAttribute("msg", "Gửi yêu cầu thành công! ✅");

        } catch (Exception e) {
            request.getSession().setAttribute("msg", "Gửi thất bại ❌");
            e.printStackTrace();
        }

        // 👉 điều hướng theo source
        if ("modal".equals(source)) {
            response.sendRedirect("User_HomeController?openSupport=true");
        } else if ("forgot".equals(source)) {
            response.sendRedirect("User_QuenMatKhau.jsp");
        } else {
            response.sendRedirect("User_HomeController");
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
