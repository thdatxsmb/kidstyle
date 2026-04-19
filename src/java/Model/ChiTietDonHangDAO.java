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
public class ChiTietDonHangDAO {

    public List<ChiTietDonHang> getByDonHang(int maDonHang) throws ClassNotFoundException {

        List<ChiTietDonHang> list = new ArrayList<>();

        String sql = """
            SELECT c.*, s.TenSanPham, s.DuongDanAnh
            FROM ChiTietDonHang c
            JOIN SanPham s ON c.MaSanPham = s.MaSanPham
            WHERE c.MaDonHang = ?
        """;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maDonHang);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                ChiTietDonHang ct = new ChiTietDonHang();

                ct.setMaChiTiet(rs.getInt("MaChiTiet"));
                ct.setMaDonHang(rs.getInt("MaDonHang"));
                ct.setMaSanPham(rs.getInt("MaSanPham"));
                ct.setSoLuong(rs.getInt("SoLuong"));
                ct.setDonGia(rs.getDouble("GiaBan"));

                ct.setTenSanPham(rs.getString("TenSanPham"));
                ct.setDuongDanAnh(rs.getString("DuongDanAnh"));

                list.add(ct);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean themChiTietDonHang(ChiTietDonHang ctdh) throws ClassNotFoundException {
        String sql = """
            INSERT INTO chitietdonhang 
            (MaDonHang, MaSanPham, SoLuong, GiaBan)   -- hoặc DonGia nếu bạn đổi tên cột
            VALUES (?, ?, ?, ?)
        """;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, ctdh.getMaDonHang());
            ps.setInt(2, ctdh.getMaSanPham());
            ps.setInt(3, ctdh.getSoLuong());
            ps.setDouble(4, ctdh.getDonGia());

            int rowsAffected = ps.executeUpdate();
            System.out.println("Inserted " + rowsAffected + " chi tiết cho đơn " + ctdh.getMaDonHang());
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi insert chi tiết đơn hàng: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<ChiTietDonHang> getChiTietByDonHang(int maDonHang) throws ClassNotFoundException {
        List<ChiTietDonHang> list = new ArrayList<>();

        String sql = """
        SELECT c.*, s.TenSanPham, s.DuongDanAnh
        FROM ChiTietDonHang c
        JOIN SanPham s ON c.MaSanPham = s.MaSanPham
        WHERE c.MaDonHang = ?
    """;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maDonHang);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ChiTietDonHang ct = new ChiTietDonHang();

                ct.setMaChiTiet(rs.getInt("MaChiTiet"));
                ct.setMaDonHang(rs.getInt("MaDonHang"));
                ct.setMaSanPham(rs.getInt("MaSanPham"));
                ct.setSoLuong(rs.getInt("SoLuong"));
                ct.setDonGia(rs.getDouble("GiaBan"));

                ct.setTenSanPham(rs.getString("TenSanPham"));
                ct.setDuongDanAnh(rs.getString("DuongDanAnh"));

                list.add(ct);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Nếu cần: Xóa chi tiết (thường không dùng, chỉ khi hủy đơn)
    public boolean xoaChiTiet(int maChiTiet) throws ClassNotFoundException {
        String sql = "DELETE FROM chitietdonhang WHERE MaChiTiet = ?";
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maChiTiet);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
