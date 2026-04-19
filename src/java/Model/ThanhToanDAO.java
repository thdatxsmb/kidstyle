package Model;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author LEGION 5
 */
import Controller.Connect;
import Model.ThanhToan;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ThanhToanDAO {

    public List<ThanhToan> getAllThanhToan() throws ClassNotFoundException {
        List<ThanhToan> list = new ArrayList<>();

        String sql = "SELECT t.*, d.TrangThai AS TrangThaiDon\n"
                + "FROM thanhtoan t\n"
                + "JOIN DonHang d ON t.MaDonHang = d.MaDonHang\n"
                + "ORDER BY t.NgayThanhToan DESC";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ThanhToan tt = new ThanhToan();

                tt.setMaThanhToan(rs.getInt("MaThanhToan"));
                tt.setMaDonHang(rs.getInt("MaDonHang"));
                tt.setPhuongThuc(rs.getString("PhuongThuc"));
                tt.setTrangThai(rs.getString("TrangThai"));
                tt.setSoTien(rs.getDouble("SoTien"));
                tt.setMaGiaoDich(rs.getString("MaGiaoDich"));
                tt.setNgayThanhToan(rs.getTimestamp("NgayThanhToan"));
                tt.setTrangThaiDon(rs.getString("TrangThaiDon"));

                list.add(tt);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Thêm thanh toán
    public boolean themThanhToan(ThanhToan tt) throws ClassNotFoundException {
        String sql = """
            INSERT INTO thanhtoan 
            (MaDonHang, PhuongThuc, TrangThai, SoTien, MaGiaoDich)
            VALUES (?, ?, ?, ?, ?)
        """;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tt.getMaDonHang());
            ps.setString(2, tt.getPhuongThuc());
            ps.setString(3, tt.getTrangThai());
            ps.setDouble(4, tt.getSoTien());
            ps.setString(5, tt.getMaGiaoDich());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy thanh toán theo đơn hàng
    public ThanhToan getByMaDonHang(int maDonHang) throws ClassNotFoundException {
        String sql = "SELECT * FROM thanhtoan WHERE MaDonHang = ?";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maDonHang);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                ThanhToan tt = new ThanhToan();
                tt.setMaThanhToan(rs.getInt("MaThanhToan"));
                tt.setMaDonHang(rs.getInt("MaDonHang"));
                tt.setPhuongThuc(rs.getString("PhuongThuc"));
                tt.setTrangThai(rs.getString("TrangThai"));
                tt.setSoTien(rs.getDouble("SoTien"));
                tt.setMaGiaoDich(rs.getString("MaGiaoDich"));
                tt.setNgayThanhToan(rs.getTimestamp("NgayThanhToan"));
                return tt;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean duyetThanhToan(int maTT) {
        String sqlGet = "SELECT MaDonHang, PhuongThuc FROM ThanhToan WHERE MaThanhToan = ?";
        String sqlUpdateTT = "UPDATE ThanhToan SET TrangThai = 'DaThanhToan' WHERE MaThanhToan = ?";
        String sqlUpdateDon = "UPDATE DonHang SET TrangThai = 'DaXacNhan' WHERE MaDonHang = ?";

        try (Connection conn = Connect.getConnection()) {
            conn.setAutoCommit(false);

            int maDon = 0;
            String pt = "";

            // Lấy info
            try (PreparedStatement ps = conn.prepareStatement(sqlGet)) {
                ps.setInt(1, maTT);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    maDon = rs.getInt("MaDonHang");
                    pt = rs.getString("PhuongThuc");
                }
            }

            // ❌ COD thì không duyệt
            if ("COD".equalsIgnoreCase(pt)) {
                return false;
            }

            // Update thanh toán
            try (PreparedStatement ps = conn.prepareStatement(sqlUpdateTT)) {
                ps.setInt(1, maTT);
                ps.executeUpdate();
            }

            // Update đơn hàng
            try (PreparedStatement ps = conn.prepareStatement(sqlUpdateDon)) {
                ps.setInt(1, maDon);
                ps.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
