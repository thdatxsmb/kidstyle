/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.util.Random;
import javax.imageio.ImageIO;

/**
 *
 * @author LEGION 5
 */
@WebServlet(name = "CaptchaServlet", urlPatterns = {"/CaptchaServlet"})
public class CaptchaServlet extends HttpServlet {

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
            out.println("<title>Servlet CaptchaServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CaptchaServlet at " + request.getContextPath() + "</h1>");
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
        int width = 130;
        int height = 45;

        BufferedImage image
                = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);

        Graphics2D g = image.createGraphics();

        // nền trắng
        g.setColor(Color.WHITE);
        g.fillRect(0, 0, width, height);

        // tạo mã random
        String chars = "abcdefghjklmnpqrstuvwxyz23456789";
        Random rd = new Random();
        StringBuilder captcha = new StringBuilder();

        for (int i = 0; i < 5; i++) {
            captcha.append(chars.charAt(rd.nextInt(chars.length())));
        }

        // lưu vào session
        request.getSession().setAttribute("captcha",
                captcha.toString());

        // vẽ chữ
        g.setFont(new Font("Arial", Font.BOLD, 28));
        g.setColor(Color.BLUE);
        g.drawString(captcha.toString(), 20, 32);

        // thêm nhiễu
        for (int i = 0; i < 15; i++) {
            g.setColor(new Color(rd.nextInt(255),
                    rd.nextInt(255),
                    rd.nextInt(255)));
            g.drawLine(rd.nextInt(width),
                    rd.nextInt(height),
                    rd.nextInt(width),
                    rd.nextInt(height));
        }

        g.dispose();

        response.setContentType("image/png");
        ImageIO.write(image, "png",
                response.getOutputStream());
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
