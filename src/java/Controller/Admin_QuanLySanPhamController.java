/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.DanhMucDAO;
import Model.SanPham;
import Model.SanPhamDAO;
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

import jakarta.servlet.http.Part;
import java.nio.file.Paths;
import java.io.File;

/**
 *
 * @author LEGION 5
 */
import jakarta.servlet.annotation.MultipartConfig;

@MultipartConfig
@WebServlet(name = "Admin_QuanLySanPhamController", urlPatterns = {"/Admin_QuanLySanPhamController"})
public class Admin_QuanLySanPhamController extends HttpServlet {

    private SanPhamDAO sanPhamDAO;
    private DanhMucDAO danhMucDAO;

    @Override
    public void init() {
        try {
            sanPhamDAO = new SanPhamDAO();
            danhMucDAO = new DanhMucDAO();

        } catch (Exception e) {
            throw new RuntimeException("Không thể khởi tạo DAO", e);
        }
    }

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
            out.println("<title>Servlet Admin_QuanLySanPham</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Admin_QuanLySanPham at " + request.getContextPath() + "</h1>");
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

        request.setCharacterEncoding("UTF-8");

        try {
            HttpSession session = request.getSession(false);
            User admin = (User) (session != null ? session.getAttribute("user") : null);

            if (admin == null || !"QuanTri".equals(admin.getVaiTro())) {
                response.sendRedirect("Login.jsp");
                return;
            }

            // LOAD DANH MỤC
            request.setAttribute("danhSachDanhMuc", danhMucDAO.getAllDanhMuc());

            String action = request.getParameter("action");

            // ===== XÓA =====
            if ("delete".equals(action)) {
                int maSanPham = Integer.parseInt(request.getParameter("maSanPham"));

                if (sanPhamDAO.deleteSanPham(maSanPham)) {
                    session.setAttribute("success", "Xóa sản phẩm thành công!");
                } else {
                    session.setAttribute("error", "Xóa thất bại!");
                }

                response.sendRedirect("Admin_QuanLySanPhamController");
                return;
            }

            // ===== LOAD LIST =====
            String keyword = request.getParameter("keyword");
            List<SanPham> list;

            if (keyword != null && !keyword.trim().isEmpty()) {
                list = sanPhamDAO.timKiemSanPham(keyword);
            } else {
                list = sanPhamDAO.getAllSanPham();
            }

            request.setAttribute("danhSachSanPham", list);

            request.getRequestDispatcher("admin_QuanLySanPham.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống!");
            request.getRequestDispatcher("admin_QuanLySanPham.jsp")
                    .forward(request, response);
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

        String action = request.getParameter("action");

        try {

            if ("add".equals(action)) {
                themSanPham(request, response);

            } else if ("edit".equals(action)) {
                if ("POST".equalsIgnoreCase(request.getMethod())) {
                    capNhatSanPham(request, response);
                } else {
                    response.sendRedirect("Admin_QuanLySanPhamController");
                }
            } else {
                response.sendRedirect("Admin_QuanLySanPhamController");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi hệ thống!");
            response.sendRedirect("Admin_QuanLySanPhamController");
        }
    }

    // ====================== XỬ LÝ DANH MỤC ======================
    private int xuLyDanhMuc(HttpServletRequest req, HttpServletResponse resp) throws Exception {

        String maDanhMucStr = req.getParameter("maDanhMuc");
        String tenDanhMucMoi = req.getParameter("tenDanhMucMoi");

        int maDanhMuc;

        if ("new".equals(maDanhMucStr)) {

            if (tenDanhMucMoi == null || tenDanhMucMoi.trim().isEmpty()) {
                req.getSession().setAttribute("error", "Vui lòng nhập tên danh mục mới!");
                resp.sendRedirect("Admin_QuanLySanPhamController");
                return -1;
            }

            maDanhMuc = danhMucDAO.getOrCreateDanhMuc(tenDanhMucMoi);

        } else {
            maDanhMuc = Integer.parseInt(maDanhMucStr);
        }

        return maDanhMuc;
    }

    // ====================== THÊM ======================
    private void themSanPham(HttpServletRequest req, HttpServletResponse resp) throws Exception {

        int maDanhMuc = xuLyDanhMuc(req, resp);
        if (maDanhMuc == -1) {
            return;
        }

        String ten = req.getParameter("tenSanPham");
        String moTa = req.getParameter("moTa");

        double giaBan = parseDouble(req.getParameter("giaBan"));
        double giaKhuyenMai = parseDouble(req.getParameter("giaKhuyenMai"));
        int tonKho = parseInt(req.getParameter("tonKho"));
        String trangThai = req.getParameter("trangThai");

//anh
        Part filePart = req.getPart("fileAnh");

        String duongDanAnh = "";

        if (filePart != null && filePart.getSize() > 0) {

            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            String uploadPath = getServletContext().getRealPath("/uploads");

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            filePart.write(uploadPath + File.separator + fileName);

            duongDanAnh = "uploads/" + fileName;
        }

        if (ten == null || ten.trim().isEmpty()) {
            req.getSession().setAttribute("error", "Tên sản phẩm không được trống!");
            resp.sendRedirect("Admin_QuanLySanPhamController");
            return;
        }

        SanPham sp = new SanPham();

        sp.setTenSanPham(ten);
        sp.setMaDanhMuc(maDanhMuc);
        sp.setMoTa(moTa);
        sp.setGiaBan(giaBan);
        sp.setGiaKhuyenMai(giaKhuyenMai);
        sp.setTonKho(tonKho);
        sp.setDuongDanAnh(duongDanAnh);
        sp.setTrangThai(trangThai);

        if (sanPhamDAO.insertSanPham(sp)) {
            req.getSession().setAttribute("success", "Thêm sản phẩm thành công!");
        } else {
            req.getSession().setAttribute("error", "Thêm thất bại!");
        }

        resp.sendRedirect("Admin_QuanLySanPhamController");
    }

    // ====================== SỬA ======================
    private void capNhatSanPham(HttpServletRequest req, HttpServletResponse resp) throws Exception {

        int maSanPham = Integer.parseInt(req.getParameter("maSanPham"));

        int maDanhMuc = xuLyDanhMuc(req, resp);
        if (maDanhMuc == -1) {
            return;
        }

        String ten = req.getParameter("tenSanPham");
        String moTa = req.getParameter("moTa");

        double giaBan = parseDouble(req.getParameter("giaBan"));
        double giaKhuyenMai = parseDouble(req.getParameter("giaKhuyenMai"));
        int tonKho = parseInt(req.getParameter("tonKho"));

        Part filePart = req.getPart("fileAnh");

        String duongDanAnh;

        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("/uploads");

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            filePart.write(uploadPath + File.separator + fileName);

            duongDanAnh = "uploads/" + fileName;
        } else {
            duongDanAnh = req.getParameter("duongDanAnhCu");
        }
        String trangThai = req.getParameter("trangThai");

        SanPham sp = new SanPham();

        sp.setMaSanPham(maSanPham);
        sp.setTenSanPham(ten);
        sp.setMaDanhMuc(maDanhMuc);
        sp.setMoTa(moTa);
        sp.setGiaBan(giaBan);
        sp.setGiaKhuyenMai(giaKhuyenMai);
        sp.setTonKho(tonKho);
        sp.setDuongDanAnh(duongDanAnh);
        sp.setTrangThai(trangThai);

        if (sanPhamDAO.updateSanPham(sp)) {
            req.getSession().setAttribute("success", "Cập nhật thành công!");
        } else {
            req.getSession().setAttribute("error", "Cập nhật thất bại!");
        }

        resp.sendRedirect("Admin_QuanLySanPhamController");
    }

    // ====================== UTILS ======================
    private double parseDouble(String val) {
        try {
            if (val == null || val.trim().isEmpty()) {
                return 0;
            }

            // Xóa khoảng trắng
            val = val.trim();

            // Xóa dấu chấm phân cách hàng nghìn
            val = val.replace(".", "");

            // Nếu có dấu phẩy (trường hợp nhập 1,5)
            val = val.replace(",", ".");

            return Double.parseDouble(val);

        } catch (Exception e) {
            return 0;
        }
    }

    private int parseInt(String val) {
        try {
            return (val == null || val.isEmpty()) ? 0 : Integer.parseInt(val);
        } catch (Exception e) {
            return 0;
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
