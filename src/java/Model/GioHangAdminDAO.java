/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import Controller.Connect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author LEGION 5
 */
public class GioHangAdminDAO {

    public List<GioHangAdmin> getGioHangTheoUser() throws ClassNotFoundException, SQLException {
        List<GioHangAdmin> list = new ArrayList<>();

        String sql = """
       SELECT 
            g.MaNguoiDung,
            COALESCE(u.HoTen, u.Email, CONCAT('User ', g.MaNguoiDung)) as TenDangNhap,
            COUNT(*) AS TongSanPham,
        
            SUM(
                g.SoLuong * 
                (CASE 
                    WHEN s.GiaKhuyenMai IS NOT NULL AND s.GiaKhuyenMai > 0 
                        THEN s.GiaKhuyenMai 
                    ELSE s.GiaBan 
                END)
            ) AS TongTien
        
        FROM giohang g
        LEFT JOIN nguoidung u ON g.MaNguoiDung = u.MaNguoiDung
        LEFT JOIN sanpham s ON g.MaSanPham = s.MaSanPham
        
        GROUP BY g.MaNguoiDung, u.HoTen, u.Email
        HAVING COUNT(*) > 0
        ORDER BY TongTien DESC
    """;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            System.out.println("=== DEBUG SQL GIO HANG BẮT ĐẦU ===");
            System.out.println("SQL đang chạy:\n" + sql);

            int count = 0;
            while (rs.next()) {
                count++;
                GioHangAdmin gh = new GioHangAdmin();
                gh.setMaNguoiDung(rs.getInt("MaNguoiDung"));
                gh.setTenDangNhap(rs.getString("TenDangNhap"));
                gh.setTongSanPham(rs.getInt("TongSanPham"));
                gh.setTongTien(rs.getDouble("TongTien"));
                list.add(gh);

                System.out.println("→ User #" + count + ": " + gh.getMaNguoiDung()
                        + " | " + gh.getTenDangNhap()
                        + " | SP: " + gh.getTongSanPham()
                        + " | Tiền: " + gh.getTongTien());
            }

            System.out.println("=== DEBUG KẾT THÚC - Tổng user có giỏ hàng: " + list.size() + " ===");

        } catch (SQLException e) {
            System.out.println("❌ LỖI SQL: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("❌ LỖI KHÁC: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // 👉 LẤY CHI TIẾT GIỎ CỦA 1 USER
    public List<GioHang> getChiTietGioHang(int maNguoiDung) throws ClassNotFoundException {
        List<GioHang> list = new ArrayList<>();

        String sql = """
        SELECT g.MaGioHang, g.SoLuong, g.NgayThem,
               s.MaSanPham, s.TenSanPham,
               s.GiaBan, s.GiaKhuyenMai, s.DuongDanAnh
        FROM giohang g
        JOIN sanpham s ON g.MaSanPham = s.MaSanPham
        WHERE g.MaNguoiDung = ?
    """;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maNguoiDung);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    GioHang g = new GioHang();

                    g.setMaGioHang(rs.getInt("MaGioHang"));
                    g.setMaSanPham(rs.getInt("MaSanPham"));
                    g.setTenSanPham(rs.getString("TenSanPham"));
                    g.setSoLuong(rs.getInt("SoLuong"));
                    g.setGiaBan(rs.getDouble("GiaBan"));
                    g.setGiaKhuyenMai(rs.getDouble("GiaKhuyenMai"));
                    g.setDuongDanAnh(rs.getString("DuongDanAnh"));
                    g.setNgayThem(rs.getTimestamp("NgayThem"));

                    list.add(g);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean xoaGioHangCuaUser(int maNguoiDung) throws ClassNotFoundException {
        String sql = "DELETE FROM giohang WHERE MaNguoiDung = ?";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maNguoiDung);

            int rows = ps.executeUpdate();
            System.out.println("Đã xóa " + rows + " sản phẩm của user " + maNguoiDung);

            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}
