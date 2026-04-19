/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author LEGION 5
 */
import Controller.Connect;
import java.sql.*;
import java.util.*;

public class GioHangDAO {

    // Lấy toàn bộ giỏ hàng của user
    public List<GioHang> getGioHangByUser(int maNguoiDung) throws ClassNotFoundException {
        List<GioHang> list = new ArrayList<>();
        String sql = """
            SELECT g.MaGioHang, g.SoLuong, s.MaSanPham, s.TenSanPham,
                   s.GiaBan, s.GiaKhuyenMai, s.DuongDanAnh,
                   s.TonKho   -- 👈 THÊM DÒNG NÀY
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
                    g.setTonKho(rs.getInt("TonKho")); // 👈 THÊM
                    list.add(g);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Nên thay bằng logger sau này
        }
        return list;
    }

    // Thêm hoặc tăng số lượng sản phẩm trong giỏ
    public boolean themVaoGio(int maNguoiDung, int maSanPham, int soLuongThem) throws ClassNotFoundException {
        String checkSQL = "SELECT SoLuong FROM giohang WHERE MaNguoiDung = ? AND MaSanPham = ?";
        String insertSQL = "INSERT INTO giohang (MaNguoiDung, MaSanPham, SoLuong, NgayThem) VALUES (?, ?, ?, NOW())";
        String updateSQL = "UPDATE giohang SET SoLuong = SoLuong + ? WHERE MaNguoiDung = ? AND MaSanPham = ?";

        Connection conn = null;

        try {
            conn = Connect.getConnection();
            conn.setAutoCommit(false);

            PreparedStatement psCheck = conn.prepareStatement(checkSQL);
            psCheck.setInt(1, maNguoiDung);
            psCheck.setInt(2, maSanPham);

            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                PreparedStatement psUpdate = conn.prepareStatement(updateSQL);
                psUpdate.setInt(1, soLuongThem);
                psUpdate.setInt(2, maNguoiDung);
                psUpdate.setInt(3, maSanPham);
                psUpdate.executeUpdate();
            } else {
                PreparedStatement psInsert = conn.prepareStatement(insertSQL);
                psInsert.setInt(1, maNguoiDung);
                psInsert.setInt(2, maSanPham);
                psInsert.setInt(3, soLuongThem);
                psInsert.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return false;
        } finally {
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Xóa một sản phẩm khỏi giỏ
    public boolean xoaSanPham(int maGioHang) throws ClassNotFoundException {
        String sql = "DELETE FROM giohang WHERE MaGioHang = ?";
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maGioHang);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa  giỏ hàng của user (rất cần sau khi thanh toán)
    public boolean xoaTheoMaGioHang(int maGioHang) throws ClassNotFoundException {
        String sql = "DELETE FROM giohang WHERE MaGioHang = ?";
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maGioHang);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Đếm số sản phẩm (không phải số lượng, mà số dòng)
    public int demSoLuongSanPhamTrongGio(int maNguoiDung) throws ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM giohang WHERE MaNguoiDung = ?";
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maNguoiDung);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Cập nhật số lượng cụ thể (thường dùng khi chỉnh sửa trong trang giỏ)
    public boolean updateSoLuong(int maGioHang, int soLuongMoi) throws ClassNotFoundException {
        if (soLuongMoi <= 0) {
            return xoaSanPham(maGioHang); // Nếu <=0 thì xóa luôn
        }
        String sql = "UPDATE giohang SET SoLuong = ? WHERE MaGioHang = ?";
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, soLuongMoi);
            ps.setInt(2, maGioHang);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Thêm lại hàm cũ để tránh lỗi NoSuchMethodError
    public int demSoLuongGioHang(int maNguoiDung) throws ClassNotFoundException {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM giohang WHERE MaNguoiDung = ?";
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maNguoiDung);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public GioHang getById(int maGioHang) throws ClassNotFoundException {
        String sql = """
            SELECT g.MaGioHang, g.SoLuong, s.MaSanPham, s.TenSanPham,
                   s.GiaBan, s.GiaKhuyenMai, s.DuongDanAnh,
                   s.TonKho   -- 👈 THÊM
            FROM giohang g
            JOIN sanpham s ON g.MaSanPham = s.MaSanPham
            WHERE g.MaGioHang = ?
        """;
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maGioHang);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                GioHang g = new GioHang();
                g.setMaGioHang(rs.getInt("MaGioHang"));
                g.setMaSanPham(rs.getInt("MaSanPham"));
                g.setTenSanPham(rs.getString("TenSanPham"));
                g.setSoLuong(rs.getInt("SoLuong"));
                g.setGiaBan(rs.getDouble("GiaBan"));
                g.setGiaKhuyenMai(rs.getDouble("GiaKhuyenMai"));
                g.setDuongDanAnh(rs.getString("DuongDanAnh"));
                g.setTonKho(rs.getInt("TonKho")); // 👈 THÊM
                return g;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
