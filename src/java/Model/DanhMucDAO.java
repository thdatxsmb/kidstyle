/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import Controller.Connect;
import java.sql.*;
import java.util.*;

/**
 *
 * @author LEGION 5
 */
public class DanhMucDAO {

    public List<DanhMuc> getAllDanhMuc() {

        List<DanhMuc> list = new ArrayList<>();

        String sql = "SELECT * FROM DanhMuc ORDER BY MaDanhMuc";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                DanhMuc dm = new DanhMuc();

                dm.setMaDanhMuc(rs.getInt("MaDanhMuc"));
                dm.setTenDanhMuc(rs.getString("TenDanhMuc"));
                dm.setMoTa(rs.getString("MoTa"));
                dm.setNgayTao(rs.getTimestamp("NgayTao"));

                list.add(dm);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean insertDanhMuc(String ten, String moTa) {

        String sql = "INSERT INTO DanhMuc(TenDanhMuc,MoTa) VALUES(?,?)";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, ten);
            ps.setString(2, moTa);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteDanhMuc(int id) {

        String sql = "DELETE FROM DanhMuc WHERE MaDanhMuc=?";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Kiểm tra tên danh mục đã tồn tại (khi thêm mới)
    public boolean isTenDanhMucExists(String tenDanhMuc) {
        String sql = "SELECT COUNT(*) FROM DanhMuc WHERE TenDanhMuc = ?";
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, tenDanhMuc);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

// Kiểm tra tên danh mục đã tồn tại (khi sửa - bỏ qua chính nó)
    public boolean isTenDanhMucExists(String tenDanhMuc, int maDanhMuc) {
        String sql = "SELECT COUNT(*) FROM DanhMuc WHERE TenDanhMuc = ? AND MaDanhMuc != ?";
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, tenDanhMuc);
            ps.setInt(2, maDanhMuc);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

// Cập nhật danh mục
    public boolean updateDanhMuc(int maDanhMuc, String tenDanhMuc, String moTa) {
        String sql = "UPDATE DanhMuc SET TenDanhMuc = ?, MoTa = ? WHERE MaDanhMuc = ?";
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, tenDanhMuc);
            ps.setString(2, moTa);
            ps.setInt(3, maDanhMuc);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getOrCreateDanhMuc(String tenDanhMuc) {

        String select = "SELECT MaDanhMuc FROM DanhMuc WHERE TenDanhMuc = ?";
        String insert = "INSERT INTO DanhMuc(TenDanhMuc) VALUES(?)";

        try (Connection conn = Connect.getConnection()) {

            // 1. Kiểm tra tồn tại
            PreparedStatement ps = conn.prepareStatement(select);
            ps.setString(1, tenDanhMuc.trim());

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("MaDanhMuc"); // đã có
            }

            // 2. Nếu chưa có → insert
            PreparedStatement psInsert = conn.prepareStatement(insert, Statement.RETURN_GENERATED_KEYS);
            psInsert.setString(1, tenDanhMuc.trim());
            psInsert.executeUpdate();

            ResultSet rsKey = psInsert.getGeneratedKeys();
            if (rsKey.next()) {
                return rsKey.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

}
