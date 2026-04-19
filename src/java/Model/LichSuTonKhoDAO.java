/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import Controller.Connect;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author LEGION 5
 */
public class LichSuTonKhoDAO {

// Lấy tất cả lịch sử tồn kho
    public List<LichSuTonKho> getAllLichSu() {
        List<LichSuTonKho> list = new ArrayList<>();
        String sql = """
                SELECT l.*, s.TenSanPham 
                FROM LichSuTonKho l
                JOIN SanPham s ON l.MaSanPham = s.MaSanPham
                ORDER BY l.NgayThayDoi DESC
        """;
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                LichSuTonKho log = new LichSuTonKho();
                log.setMaLog(rs.getInt("MaLog"));
                log.setMaSanPham(rs.getInt("MaSanPham"));
                log.setLoaiThayDoi(rs.getString("LoaiThayDoi"));
                log.setSoLuong(rs.getInt("SoLuong"));
                log.setDonGiaNhap(rs.getDouble("DonGiaNhap"));
                log.setTongTien(rs.getDouble("TongTien"));
                log.setGhiChu(rs.getString("GhiChu"));
                log.setNgayThayDoi(rs.getTimestamp("NgayThayDoi"));
                log.setNguoiThucHien(rs.getInt("NguoiThucHien"));
                log.setTenSanPham(rs.getString("TenSanPham"));
                list.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy lịch sử theo một sản phẩm cụ thể (dùng cho lọc)
    public List<LichSuTonKho> getLichSuBySanPham(int maSanPham) {
        List<LichSuTonKho> list = new ArrayList<>();
        String sql = """
            SELECT l.*, s.TenSanPham 
            FROM LichSuTonKho l
            JOIN SanPham s ON l.MaSanPham = s.MaSanPham
            WHERE l.MaSanPham = ?
            ORDER BY l.NgayThayDoi DESC
        """;
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maSanPham);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LichSuTonKho log = new LichSuTonKho();
                    log.setMaLog(rs.getInt("MaLog"));
                    log.setMaSanPham(rs.getInt("MaSanPham"));
                    log.setLoaiThayDoi(rs.getString("LoaiThayDoi"));
                    log.setSoLuong(rs.getInt("SoLuong"));
                    log.setDonGiaNhap(rs.getDouble("DonGiaNhap"));
                    log.setTongTien(rs.getDouble("TongTien"));
                    log.setGhiChu(rs.getString("GhiChu"));
                    log.setNgayThayDoi(rs.getTimestamp("NgayThayDoi"));
                    log.setNguoiThucHien(rs.getInt("NguoiThucHien"));
                    log.setTenSanPham(rs.getString("TenSanPham")); 
                    list.add(log);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Nhập hàng
    public boolean nhapHang(int maSanPham, int soLuong, double donGiaNhap, String ghiChu, int nguoiThucHien) {
        String sqlUpdate = "UPDATE sanpham SET TonKho = TonKho + ? WHERE MaSanPham = ?";
        String sqlInsert = "INSERT INTO LichSuTonKho (MaSanPham, LoaiThayDoi, SoLuong, DonGiaNhap, TongTien, GhiChu, NguoiThucHien) "
                + "VALUES (?, 'NHAP_HANG', ?, ?, ?, ?, ?)";

        try (Connection conn = Connect.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement ps1 = conn.prepareStatement(sqlUpdate)) {
                ps1.setInt(1, soLuong);
                ps1.setInt(2, maSanPham);
                ps1.executeUpdate();
            }

            try (PreparedStatement ps2 = conn.prepareStatement(sqlInsert)) {
                ps2.setInt(1, maSanPham);
                ps2.setInt(2, soLuong);
                ps2.setDouble(3, donGiaNhap);
                ps2.setDouble(4, donGiaNhap * soLuong);
                ps2.setString(5, ghiChu);
                ps2.setInt(6, nguoiThucHien);
                ps2.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Điều chỉnh tồn kho
    public boolean dieuChinhTonKho(int maSanPham, int soLuongDieuChinh, String ghiChu, int nguoiThucHien) {
        String sqlUpdate = "UPDATE sanpham SET TonKho = TonKho + ? WHERE MaSanPham = ?";
        String sqlInsert = "INSERT INTO LichSuTonKho (MaSanPham, LoaiThayDoi, SoLuong, GhiChu, NguoiThucHien) "
                + "VALUES (?, 'DIEU_CHINH', ?, ?, ?)";

        try (Connection conn = Connect.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement ps1 = conn.prepareStatement(sqlUpdate)) {
                ps1.setInt(1, soLuongDieuChinh);
                ps1.setInt(2, maSanPham);
                ps1.executeUpdate();
            }

            try (PreparedStatement ps2 = conn.prepareStatement(sqlInsert)) {
                ps2.setInt(1, maSanPham);
                ps2.setInt(2, soLuongDieuChinh);
                ps2.setString(3, ghiChu);
                ps2.setInt(4, nguoiThucHien);
                ps2.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy tất cả sản phẩm (cho dropdown và bảng)
    public List<SanPham> getAllSanPham() {
        SanPhamDAO sanPhamDAO = new SanPhamDAO();
        return sanPhamDAO.getAllSanPham();
    }

    // Tìm kiếm sản phẩm theo tên (dùng cho chức năng tìm kiếm)
    public List<SanPham> timKiemSanPham(String keyword) {
        SanPhamDAO sanPhamDAO = new SanPhamDAO();
        return sanPhamDAO.timKiemSanPham(keyword);
    }
}
