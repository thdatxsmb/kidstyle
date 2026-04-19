/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.ChiTietDonHang;
import Model.DonHang;
import Model.DonHangDAO;
import Model.GioHang;
import Model.SanPham;
import Model.SanPhamDAO;
import Model.User;
import com.sun.jdi.connect.spi.Connection;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author LEGION 5
 */
@WebServlet(name = "User_DonHangController", urlPatterns = {"/User_DonHangController"})
public class User_DonHangController extends HttpServlet {

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
            out.println("<title>Servlet User_DonHangController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet User_DonHangController at " + request.getContextPath() + "</h1>");
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

        try {
            DonHangDAO dao = new DonHangDAO();
            List<DonHang> danhSach = dao.layDanhSachDonHangCuaNguoiDung(user.getMaNguoiDung());

            request.setAttribute("danhSachDonHang", danhSach);
            request.getRequestDispatcher("User_DonHang.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", e.getMessage());
            request.getRequestDispatcher("User_DonHang.jsp").forward(request, response);
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

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String action = request.getParameter("action");
        int id = Integer.parseInt(request.getParameter("id"));

        try {
            DonHangDAO dao = new DonHangDAO();
            switch (action) {

                case "huy": {
                    String lyDo = request.getParameter("lyDo");
                    String lyDoKhac = request.getParameter("lyDoKhac");

                    if ("Khác".equals(lyDo)) {
                        lyDo = lyDoKhac;
                    }

                    boolean ok = dao.huyDon(id, lyDo);

                    if (ok) {
                        session.setAttribute("successMsg", "Đã hủy đơn!");
                    } else {
                        session.setAttribute("errorMsg", "Hủy thất bại!");
                    }

                    // 🔥 QUAN TRỌNG: luôn về danh sách
                    response.sendRedirect("User_DonHangController");
                    return;
                }

                // 🟡 HOÀN
                case "hoan": {
                    String lyDo = request.getParameter("lyDo");
                    dao.yeuCauHoan(id, lyDo); // ✅ đúng

                    session.setAttribute("successMsg", "Đã gửi yêu cầu hoàn!");
                    break;
                }

                // 🔵 MUA LẠI
                case "mualai": {

                    int soLuong = Integer.parseInt(request.getParameter("soLuong"));
                    int maSP = Integer.parseInt(request.getParameter("maSanPham"));

                    SanPhamDAO spDAO = new SanPhamDAO();
                    List<GioHang> checkoutList = (List<GioHang>) session.getAttribute("checkout");

                    // Lấy sản phẩm theo ID (QUAN TRỌNG)
                    SanPham sp = spDAO.getSanPhamById(maSP);

                    if (sp == null) {
                        session.setAttribute("errorMsg", "Sản phẩm không tồn tại!");
                        response.sendRedirect("User_DonHangController");
                        return;
                    }

                    // Kiểm tra tồn kho (bonus xịn)
                    if (sp.getTonKho() < soLuong) {
                        session.setAttribute("errorMsg", "Sản phẩm không đủ hàng!");
                        response.sendRedirect("User_DonHangController");
                        return;
                    }

                    // Tạo item checkout
                    GioHang g = new GioHang();
                    g.setMaSanPham(sp.getMaSanPham());
                    g.setTenSanPham(sp.getTenSanPham());
                    g.setGiaBan(sp.getGiaBan());
                    g.setGiaKhuyenMai(sp.getGiaKhuyenMai());
                    g.setDuongDanAnh(sp.getDuongDanAnh());
                    g.setSoLuong(soLuong);

                    if (checkoutList == null) {
                        checkoutList = new ArrayList<>();
                    } else {
                        checkoutList.clear(); // ⚠️ đảm bảo chỉ mua 1 sản phẩm
                    }

                    checkoutList.add(g);
                    session.setAttribute("checkout", checkoutList);
                    session.setAttribute("isBuyNow", true); // ✅ thêm dòng này
                    // chuyển qua thanh toán
                    response.sendRedirect("User_ThanhToanController");
                    return;
                }
            }

                        response.sendRedirect("User_DonHangController");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Lỗi: " + e.getMessage());
            response.sendRedirect("User_DonHangController");
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
