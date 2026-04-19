/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.ChatBox;
import Model.ChatBoxDAO;
import Model.User;
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
@WebServlet(name = "Admin_ChatController", urlPatterns = {"/Admin_ChatController"})
public class Admin_ChatController extends HttpServlet {

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
            out.println("<title>Servlet Admin_ChatController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Admin_ChatController at " + request.getContextPath() + "</h1>");
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
            ChatBoxDAO dao = new ChatBoxDAO();

            if ("loadChat".equals(action)) {

                int maUser = Integer.parseInt(request.getParameter("maNguoiDung"));
                List<ChatBox> list = dao.getByUser(maUser);

                dao.markAsRead(maUser); 

                response.setContentType("text/html;charset=UTF-8");
                PrintWriter out = response.getWriter();

                for (ChatBox c : list) {
                    if ("USER".equals(c.getNguoiGui())) {

                        out.println(
                                "<div class='d-flex mb-2'>"
                                + "<div class='bg-white p-2 rounded shadow-sm'>"
                                + c.getNoiDung()
                                + "</div>"
                                + "</div>"
                        );

                    } else {

                        out.println(
                                "<div class='d-flex justify-content-end mb-2'>"
                                + "<div class='bg-primary text-white p-2 rounded'>"
                                + c.getNoiDung()
                                + "</div>"
                                + "</div>"
                        );
                    }
                }

                return;
            }

            List<User> users = dao.getUserChatList();
            request.setAttribute("users", users);

            request.getRequestDispatcher("admin_ChatBox.jsp").forward(request, response);

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
            throws IOException {

        int maUser = Integer.parseInt(request.getParameter("maNguoiDung"));
        String msg = request.getParameter("message");

        try {
            ChatBoxDAO dao = new ChatBoxDAO();

            ChatBox chat = new ChatBox();
            chat.setMaNguoiDung(maUser);
            chat.setNoiDung(msg);

            dao.insertAdmin(chat);

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
