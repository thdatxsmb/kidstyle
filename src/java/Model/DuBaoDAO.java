/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.sql.*;
import java.util.*;

/**
 *
 * @author LEGION 5
 */
public class DuBaoDAO {

    private static final String URL = "jdbc:mysql://localhost:3306/qlthoitrang?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASS = "";

    public DuBaoDAO() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
    }

    public Map<String, Double> getDoanhThuTheoThang() throws Exception {
        Map<String, Double> map = new LinkedHashMap<>();
        String sql = "SELECT DATE_FORMAT(NgayDatHang, '%Y-%m') AS thang, "
                + "SUM(TongTien) AS doanhThu "
                + "FROM donhang "
                + "WHERE TrangThai='DaGiao' "
                + "GROUP BY thang "
                + "ORDER BY thang ASC";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASS); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("thang"), rs.getDouble("doanhThu"));
            }
        }
        return map;
    }
}