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
public class HoTroDAO {

    // ✅ 1. Thêm yêu cầu hỗ trợ
    public void insert(HoTro ht) throws Exception {
        String sql = "INSERT INTO hotro(TenNguoiGui, Email, SoDienThoai, NoiDung, TrangThai) VALUES(?,?,?,?,?)";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, ht.getTenNguoiGui());
            ps.setString(2, ht.getEmail());
            ps.setString(3, ht.getSoDienThoai());
            ps.setString(4, ht.getNoiDung());
            ps.setString(5, "ChoXuLy");

            ps.executeUpdate();
        }
    }

    // ✅ 2. Lấy tất cả yêu cầu
    public List<HoTro> getAll() throws Exception {
        List<HoTro> list = new ArrayList<>();
        String sql = "SELECT * FROM hotro ORDER BY NgayGui DESC";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                HoTro ht = new HoTro();
                ht.setMaHoTro(rs.getInt("MaHoTro"));
                ht.setTenNguoiGui(rs.getString("TenNguoiGui"));
                ht.setEmail(rs.getString("Email"));
                ht.setSoDienThoai(rs.getString("SoDienThoai"));
                ht.setNoiDung(rs.getString("NoiDung"));
                ht.setTrangThai(rs.getString("TrangThai"));
                ht.setPhanHoi(rs.getString("PhanHoi"));
                ht.setNgayGui(rs.getTimestamp("NgayGui"));
                ht.setNgayXuLy(rs.getTimestamp("NgayXuLy"));

                list.add(ht);
            }
        }

        return list;
    }

    // ✅ 3. Đếm yêu cầu chưa xử lý (badge 🔔)
    public int countChuaXuLy() throws Exception {
        String sql = "SELECT COUNT(*) FROM hotro WHERE TrangThai='ChoXuLy'";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        return 0;
    }

    // ✅ 4. Admin xử lý yêu cầu
    public void updateXuLy(int maHoTro, String phanHoi) throws Exception {
        String sql = "UPDATE hotro SET TrangThai='DaXuLy', PhanHoi=?, NgayXuLy=NOW() WHERE MaHoTro=?";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, phanHoi);
            ps.setInt(2, maHoTro);

            ps.executeUpdate();
        }
    }

    // ✅ 5. (Optional) Lấy 1 yêu cầu theo ID
    public HoTro getById(int maHoTro) throws Exception {
        String sql = "SELECT * FROM hotro WHERE MaHoTro=?";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maHoTro);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HoTro ht = new HoTro();
                ht.setMaHoTro(rs.getInt("MaHoTro"));
                ht.setTenNguoiGui(rs.getString("TenNguoiGui"));
                ht.setEmail(rs.getString("Email"));
                ht.setSoDienThoai(rs.getString("SoDienThoai"));
                ht.setNoiDung(rs.getString("NoiDung"));
                ht.setTrangThai(rs.getString("TrangThai"));
                ht.setPhanHoi(rs.getString("PhanHoi"));
                ht.setNgayGui(rs.getTimestamp("NgayGui"));
                ht.setNgayXuLy(rs.getTimestamp("NgayXuLy"));
                return ht;
            }
        }

        return null;
    }

    public List<HoTro> getByEmail(String email) throws Exception {
        List<HoTro> list = new ArrayList<>();
        String sql = "SELECT * FROM hotro WHERE Email=? ORDER BY NgayGui DESC";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                HoTro ht = new HoTro();
                ht.setMaHoTro(rs.getInt("MaHoTro"));
                ht.setNoiDung(rs.getString("NoiDung"));
                ht.setTrangThai(rs.getString("TrangThai"));
                ht.setNgayGui(rs.getTimestamp("NgayGui"));
                ht.setPhanHoi(rs.getString("PhanHoi"));
                list.add(ht);
            }
        }
        return list;
    }
}
