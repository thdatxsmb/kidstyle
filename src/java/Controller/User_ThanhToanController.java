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

import Model.*;
import jakarta.servlet.http.HttpSession;
import java.util.*;

/**
 *
 * @author LEGION 5
 */
@WebServlet(name = "User_ThanhToanController", urlPatterns = {"/User_ThanhToanController"})
public class User_ThanhToanController extends HttpServlet {

    private double tinhTongTien(List<GioHang> list) {
        double tong = 0;
        for (GioHang g : list) {
            double gia = g.getGiaKhuyenMai() > 0 ? g.getGiaKhuyenMai() : g.getGiaBan();
            tong += gia * g.getSoLuong();
        }
        return tong;
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

        List<GioHang> list = new ArrayList<>();

        GioHangDAO gioHangDAO = new GioHangDAO();
        SanPhamDAO spDAO = new SanPhamDAO();

        try {
            String idsParam = request.getParameter("ids");
            String maSPParam = request.getParameter("maSP");

// ✅ Ưu tiên MUA NGAY
            if (maSPParam != null) {
                list.clear();

                int maSP = Integer.parseInt(maSPParam);
                int sl = Integer.parseInt(request.getParameter("sl"));

                SanPham sp = spDAO.getSanPhamById(maSP);

                GioHang g = new GioHang();
                g.setMaSanPham(sp.getMaSanPham());
                g.setTenSanPham(sp.getTenSanPham());
                g.setGiaBan(sp.getGiaBan());
                g.setGiaKhuyenMai(sp.getGiaKhuyenMai());
                g.setDuongDanAnh(sp.getDuongDanAnh());
                g.setSoLuong(sl);
                g.setTonKho(sp.getTonKho()); 


                list.add(g);

            } // ✅ Thanh toán từ giỏ
            else if (idsParam != null && !idsParam.isEmpty()) {
                list.clear();

                String[] ids = idsParam.split(",");
                for (String id : ids) {
                    GioHang gh = gioHangDAO.getById(Integer.parseInt(id));
                    if (gh != null) {
                        list.add(gh);
                    }
                }
            } // ✅ fallback
            else {
                list = gioHangDAO.getGioHangByUser(user.getMaNguoiDung());
            }

            if (list.isEmpty()) {
                request.setAttribute("error", "Không có sản phẩm để thanh toán!");
            }

            session.setAttribute("checkout", list);

            double tongTien = tinhTongTien(list);

            request.setAttribute("tongTien", tongTien);
            request.setAttribute("list", list);

            request.getRequestDispatcher("User_ThanhToan.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("User_ThanhToan.jsp").forward(request, response);
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
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        List<GioHang> checkoutList = (List<GioHang>) session.getAttribute("checkout");

        if (checkoutList == null || checkoutList.isEmpty()) {
            request.setAttribute("error", "Không có sản phẩm để thanh toán.");
            request.getRequestDispatcher("User_ThanhToan.jsp").forward(request, response);
            return;
        }

        String diaChi = request.getParameter("diaChi");
        String ghiChu = request.getParameter("ghiChu");
        String phuongThuc = request.getParameter("phuongThuc");

        double tongTien = tinhTongTien(checkoutList);

        DonHangDAO donHangDAO = new DonHangDAO();
        SanPhamDAO sanPhamDAO = new SanPhamDAO();
        GioHangDAO gioHangDAO = new GioHangDAO();

        try {
            DonHang donHang = new DonHang();
            donHang.setMaNguoiDung(user.getMaNguoiDung());
            donHang.setTongTien(tongTien);
            if ("COD".equalsIgnoreCase(phuongThuc)) {
                donHang.setTrangThai("DaXacNhan"); // 🚀 duyệt luôn
            } else {
                donHang.setTrangThai("ChoXacNhan"); // ⏳ chờ admin
            }
            donHang.setGhiChu(ghiChu != null ? ghiChu.trim() : "");
            donHang.setDiaChiNhanHang(diaChi != null ? diaChi.trim() : "");
            donHang.setPhuongThucThanhToan(phuongThuc != null ? phuongThuc : "COD");
            donHang.setTenNguoiNhan(user.getHoTen() != null ? user.getHoTen() : "");
            donHang.setSoDienThoaiNhan(user.getSoDienThoai() != null ? user.getSoDienThoai() : "");

            List<ChiTietDonHang> chiTietList = new ArrayList<>();

            for (GioHang item : checkoutList) {
                SanPham sp = sanPhamDAO.getSanPhamById(item.getMaSanPham());

                if (sp == null) {
                    throw new Exception("Sản phẩm không tồn tại");
                }

                if (sp.getTonKho() < item.getSoLuong()) {
                    throw new Exception("Sản phẩm " + sp.getTenSanPham() + " không đủ hàng!");
                }

                double donGia = item.getGiaKhuyenMai() > 0 ? item.getGiaKhuyenMai() : item.getGiaBan();

                ChiTietDonHang ctdh = new ChiTietDonHang();
                ctdh.setMaSanPham(item.getMaSanPham());
                ctdh.setSoLuong(item.getSoLuong());
                ctdh.setDonGia(donGia);

                chiTietList.add(ctdh);

            }

            int maDonHang = donHangDAO.taoDonHangVaChiTiet(donHang, chiTietList);

            if (maDonHang <= 0) {
                throw new Exception("Tạo đơn hàng thất bại");
            }

            // 🔥 TẠO THANH TOÁN NGAY SAU KHI TẠO ĐƠN
            ThanhToanDAO ttDAO = new ThanhToanDAO();

            ThanhToan tt = new ThanhToan();
            tt.setMaDonHang(maDonHang);
            tt.setSoTien(tongTien);
            tt.setPhuongThuc(phuongThuc);

            if ("COD".equalsIgnoreCase(phuongThuc)) {
                tt.setTrangThai("DaThanhToan"); // COD -> coi như OK luôn
                tt.setMaGiaoDich("COD_" + System.currentTimeMillis());
            } else {
                tt.setTrangThai("ChoThanhToan"); // BANK -> chờ duyệt
                tt.setMaGiaoDich(UUID.randomUUID().toString());
            }

            ttDAO.themThanhToan(tt);

            for (GioHang item : checkoutList) {
                gioHangDAO.xoaTheoMaGioHang(item.getMaGioHang());
            }
            session.removeAttribute("checkout");

            response.sendRedirect("User_DatHangThanhCong.jsp?maDon=" + maDonHang);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            request.setAttribute("list", checkoutList);
            request.setAttribute("tongTien", tongTien);
            request.getRequestDispatcher("User_ThanhToan.jsp").forward(request, response);
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
