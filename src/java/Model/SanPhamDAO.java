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
public class SanPhamDAO {

    public List<SanPham> getAllSanPham() {

        List<SanPham> list = new ArrayList<>();
        String sql = ""
                + "SELECT sp.*, dm.TenDanhMuc "
                + "FROM sanpham sp "
                + "JOIN danhmuc dm ON sp.MaDanhMuc = dm.MaDanhMuc ORDER BY MaSanPham";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                SanPham sp = new SanPham();

                sp.setMaSanPham(rs.getInt("MaSanPham"));
                sp.setMaDanhMuc(rs.getInt("MaDanhMuc"));
                sp.setTenSanPham(rs.getString("TenSanPham"));
                sp.setMoTa(rs.getString("MoTa"));
                sp.setGiaBan(rs.getDouble("GiaBan"));
                sp.setGiaKhuyenMai(rs.getDouble("GiaKhuyenMai"));
                sp.setTonKho(rs.getInt("TonKho"));
                sp.setDuongDanAnh(rs.getString("DuongDanAnh"));
                sp.setTrangThai(rs.getString("TrangThai"));

                sp.setTenDanhMuc(rs.getString("TenDanhMuc"));

                list.add(sp);
            }

        } catch (Exception e) {
            e.printStackTrace(); // nếu lỗi sẽ hiện trong server log
        }

        return list;
    }

    public SanPham getSanPhamById(int maSanPham) throws ClassNotFoundException {

        String sql = "SELECT * FROM sanpham WHERE MaSanPham = ?";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maSanPham);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    SanPham sp = new SanPham();

                    sp.setMaSanPham(rs.getInt("MaSanPham"));
                    sp.setMaDanhMuc(rs.getInt("MaDanhMuc"));
                    sp.setTenSanPham(rs.getString("TenSanPham"));
                    sp.setMoTa(rs.getString("MoTa"));
                    sp.setGiaBan(rs.getDouble("GiaBan"));
                    sp.setGiaKhuyenMai(rs.getDouble("GiaKhuyenMai"));
                    sp.setTonKho(rs.getInt("TonKho"));
                    sp.setDuongDanAnh(rs.getString("DuongDanAnh"));
                    sp.setTrangThai(rs.getString("TrangThai"));

                    return sp;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<SanPham> timKiemSanPham(String keyword) {

        List<SanPham> list = new ArrayList<>();

        String sql = "SELECT * FROM SanPham WHERE TenSanPham LIKE ?";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                SanPham sp = new SanPham();

                sp.setMaSanPham(rs.getInt("MaSanPham"));
                sp.setMaDanhMuc(rs.getInt("MaDanhMuc"));
                sp.setTenSanPham(rs.getString("TenSanPham"));
                sp.setMoTa(rs.getString("MoTa"));
                sp.setGiaBan(rs.getDouble("GiaBan"));
                sp.setGiaKhuyenMai(rs.getDouble("GiaKhuyenMai"));
                sp.setTonKho(rs.getInt("TonKho"));
                sp.setDuongDanAnh(rs.getString("DuongDanAnh"));
                sp.setTrangThai(rs.getString("TrangThai"));

                list.add(sp);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean capNhatTonKho(int maSanPham, int tonKhoMoi) throws ClassNotFoundException {
        if (tonKhoMoi < 0) {
            System.err.println("Cảnh báo: Tồn kho mới âm cho sản phẩm " + maSanPham);
            return false; // Không cho phép tồn kho âm
        }

        String sql = "UPDATE sanpham SET TonKho = ? WHERE MaSanPham = ?";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tonKhoMoi);
            ps.setInt(2, maSanPham);

            int rowsAffected = ps.executeUpdate();
            System.out.println("Cập nhật tồn kho sản phẩm " + maSanPham + ": " + rowsAffected + " dòng thay đổi");
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi cập nhật tồn kho sản phẩm " + maSanPham + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean thayDoiTonKho(Connection conn, int maSanPham, int soLuongThayDoi) throws SQLException {

        String sql = "UPDATE sanpham SET TonKho = TonKho + ? WHERE MaSanPham = ? AND TonKho + ? >= 0";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, soLuongThayDoi);
            ps.setInt(2, maSanPham);
            ps.setInt(3, soLuongThayDoi);

            return ps.executeUpdate() > 0;
        }
    }

    //them sp
    public boolean insertSanPham(SanPham sp) {

        String sql = "INSERT INTO SanPham(MaDanhMuc,TenSanPham,MoTa,GiaBan,GiaKhuyenMai,TonKho,DuongDanAnh,TrangThai) VALUES(?,?,?,?,?,?,?,?)";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, sp.getMaDanhMuc());
            ps.setString(2, sp.getTenSanPham());
            ps.setString(3, sp.getMoTa());
            ps.setDouble(4, sp.getGiaBan());
            ps.setDouble(5, sp.getGiaKhuyenMai());
            ps.setInt(6, sp.getTonKho());
            ps.setString(7, sp.getDuongDanAnh());
            ps.setString(8, sp.getTrangThai());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    //update sp
    public boolean updateSanPham(SanPham sp) {

        String sql = "UPDATE SanPham SET MaDanhMuc=?,TenSanPham=?,MoTa=?,GiaBan=?,GiaKhuyenMai=?,TonKho=?,DuongDanAnh=?,TrangThai=? WHERE MaSanPham=?";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, sp.getMaDanhMuc());
            ps.setString(2, sp.getTenSanPham());
            ps.setString(3, sp.getMoTa());
            ps.setDouble(4, sp.getGiaBan());
            ps.setDouble(5, sp.getGiaKhuyenMai());
            ps.setInt(6, sp.getTonKho());
            ps.setString(7, sp.getDuongDanAnh());
            ps.setString(8, sp.getTrangThai());
            ps.setInt(9, sp.getMaSanPham());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    //xoa sp
    public boolean deleteSanPham(int maSanPham) {

        String sql = "DELETE FROM SanPham WHERE MaSanPham=?";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maSanPham);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    //top 4 ban chay
    public List<SanPham> getTop4BanChay() {

        List<SanPham> list = new ArrayList<>();

        String sql = "SELECT sp.*, SUM(ct.SoLuong) AS tongBan "
                + "FROM chitietdonhang ct "
                + "JOIN donhang dh ON ct.MaDonHang = dh.MaDonHang "
                + "JOIN sanpham sp ON ct.MaSanPham = sp.MaSanPham "
                + "GROUP BY sp.MaSanPham "
                + "ORDER BY tongBan DESC "
                + "LIMIT 4";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                SanPham sp = new SanPham();

                sp.setMaSanPham(rs.getInt("MaSanPham"));
                sp.setMaDanhMuc(rs.getInt("MaDanhMuc"));
                sp.setTenSanPham(rs.getString("TenSanPham"));
                sp.setMoTa(rs.getString("MoTa"));
                sp.setGiaBan(rs.getDouble("GiaBan"));
                sp.setGiaKhuyenMai(rs.getDouble("GiaKhuyenMai"));
                sp.setTonKho(rs.getInt("TonKho"));
                sp.setDuongDanAnh(rs.getString("DuongDanAnh"));
                sp.setTrangThai(rs.getString("TrangThai"));

                list.add(sp);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<SanPham> getSanPhamPaging(int page, int pageSize) {
        List<SanPham> list = new ArrayList<>();

        String sql = """
           SELECT sp.*, IFNULL(ct.tongBan,0) AS luotBan
            FROM sanpham sp
            LEFT JOIN (
                SELECT MaSanPham, SUM(SoLuong) AS tongBan
                FROM chitietdonhang
                GROUP BY MaSanPham
            ) ct ON sp.MaSanPham = ct.MaSanPham
            LIMIT ?, ?
        """;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            int offset = (page - 1) * pageSize;

            ps.setInt(1, offset);
            ps.setInt(2, pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                SanPham sp = new SanPham();

                sp.setMaSanPham(rs.getInt("MaSanPham"));
                sp.setTenSanPham(rs.getString("TenSanPham"));
                sp.setGiaBan(rs.getDouble("GiaBan"));
                sp.setGiaKhuyenMai(rs.getDouble("GiaKhuyenMai"));
                sp.setDuongDanAnh(rs.getString("DuongDanAnh"));

                sp.setLuotBan(rs.getInt("luotBan"));
                sp.setTonKho(rs.getInt("TonKho"));

                list.add(sp);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countSanPham() {
        String sql = "SELECT COUNT(*) FROM SanPham";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public List<SanPham> getSanPhamByDanhMuc(int maDanhMuc) {
        List<SanPham> list = new ArrayList<>();

        String sql = """
        SELECT sp.*, IFNULL(SUM(ct.SoLuong),0) AS luotBan
        FROM sanpham sp
        LEFT JOIN chitietdonhang ct 
            ON sp.MaSanPham = ct.MaSanPham
        WHERE sp.MaDanhMuc = ?
        GROUP BY sp.MaSanPham
        LIMIT 8
    """;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maDanhMuc);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                SanPham sp = new SanPham();

                sp.setMaSanPham(rs.getInt("MaSanPham"));
                sp.setTenSanPham(rs.getString("TenSanPham"));
                sp.setGiaBan(rs.getDouble("GiaBan"));
                sp.setGiaKhuyenMai(rs.getDouble("GiaKhuyenMai"));
                sp.setDuongDanAnh(rs.getString("DuongDanAnh"));
                sp.setLuotBan(rs.getInt("luotBan"));
                sp.setTonKho(rs.getInt("TonKho"));

                list.add(sp);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<SanPham> getSanPhamKhuyenMai() {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT sp.*, IFNULL(ct.tongBan, 0) AS luotBan "
                   + "FROM sanpham sp "
                   + "LEFT JOIN (SELECT MaSanPham, SUM(SoLuong) AS tongBan FROM chitietdonhang GROUP BY MaSanPham) ct ON sp.MaSanPham = ct.MaSanPham "
                   + "WHERE sp.GiaKhuyenMai > 0 AND sp.GiaKhuyenMai IS NOT NULL "
                   + "ORDER BY (sp.GiaBan - sp.GiaKhuyenMai) DESC";
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                SanPham sp = mapResultSetToSanPham(rs);
                sp.setLuotBan(rs.getInt("luotBan"));
                list.add(sp);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    private SanPham mapResultSetToSanPham(ResultSet rs) throws SQLException {
        SanPham sp = new SanPham();
        sp.setMaSanPham(rs.getInt("MaSanPham"));
        sp.setMaDanhMuc(rs.getInt("MaDanhMuc"));
        sp.setTenSanPham(rs.getString("TenSanPham"));
        sp.setMoTa(rs.getString("MoTa"));
        sp.setGiaBan(rs.getDouble("GiaBan"));
        sp.setGiaKhuyenMai(rs.getDouble("GiaKhuyenMai"));
        sp.setTonKho(rs.getInt("TonKho"));
        sp.setDuongDanAnh(rs.getString("DuongDanAnh"));
        sp.setTrangThai(rs.getString("TrangThai"));
        return sp;
    }

     public List<SanPham> timKiemSanPhamPaging(String keyword, int page, int pageSize) {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT sp.*, IFNULL(ct.tongBan, 0) AS luotBan FROM sanpham sp LEFT JOIN (SELECT MaSanPham, SUM(SoLuong) AS tongBan FROM chitietdonhang GROUP BY MaSanPham) ct ON sp.MaSanPham = ct.MaSanPham WHERE sp.TenSanPham LIKE ? LIMIT ?, ?";
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setInt(2, (page - 1) * pageSize);
            ps.setInt(3, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SanPham sp = mapResultSetToSanPham(rs);
                    sp.setLuotBan(rs.getInt("luotBan"));
                    list.add(sp);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public int countSanPhamSearch(String keyword) {
        String sql = "SELECT COUNT(*) FROM sanpham WHERE TenSanPham LIKE ?";
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
}