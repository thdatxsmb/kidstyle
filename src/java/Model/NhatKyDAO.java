/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import Controller.Connect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author LEGION 5
 */
public class NhatKyDAO {

    public void insertLog(int userId, String action, String target) {
        String sql = "INSERT INTO nhatky_hoatdong(maNguoiDung, hanhDong, doiTuong) VALUES (?, ?, ?)";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, action);
            ps.setString(3, target);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<NhatKy> getRecentLogs() {
        List<NhatKy> list = new ArrayList<>();

        String sql = """
        SELECT nk.*, nd.HoTen
        FROM nhatky_hoatdong nk
        JOIN nguoidung nd ON nk.maNguoiDung = nd.maNguoiDung
        ORDER BY nk.thoiGian DESC
        LIMIT 10
    """;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()){ 
            while (rs.next()) {
                NhatKy nk = new NhatKy();
                nk.setId(rs.getInt("id"));
                nk.setMaNguoiDung(rs.getInt("maNguoiDung"));
                nk.setTenNguoiDung(rs.getString("HoTen"));
                nk.setHanhDong(rs.getString("hanhDong"));
                nk.setDoiTuong(rs.getString("doiTuong"));
                nk.setThoiGian(rs.getTimestamp("thoiGian"));

                list.add(nk);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

}
