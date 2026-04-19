/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import Controller.Connect;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author LEGION 5
 */
public class ThongKeDAO {

    public int countUsers() throws ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM nguoidung";
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countSanPham() throws ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM sanpham";
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countDonHang() throws ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM donhang";
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double tongDoanhThu() throws ClassNotFoundException {
        String sql = "SELECT COALESCE(SUM(TongTien), 0) FROM donhang WHERE TrangThai = 'DaGiao'";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Double> getDoanhThu7Ngay() throws ClassNotFoundException {
        List<Double> list = new ArrayList<>();
        String sql = """
        SELECT COALESCE(SUM(TongTien), 0) as tong_doanh_thu
                    FROM donhang 
                    WHERE TrangThai = 'DaGiao'
                    AND NgayDatHang >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
                    AND NgayDatHang < DATE_SUB(CURDATE(), INTERVAL ? DAY) + INTERVAL 1 DAY
        """;

        try (Connection conn = Connect.getConnection()) {
            for (int i = 6; i >= 0; i--) {
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, i);
                    ps.setInt(2, i);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            list.add(rs.getDouble("tong_doanh_thu"));
                        } else {
                            list.add(0.0);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int tongTonKho() throws ClassNotFoundException {
        String sql = "SELECT SUM(tonKho) FROM sanpham";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public List<Integer> getNhapTheoThang(int year) throws ClassNotFoundException {
        List<Integer> list = new ArrayList<>();

        String sql = """
        SELECT MONTH(ngay) thang, SUM(soLuong) tong
        FROM phieukho
        WHERE loai='NHAP' AND YEAR(ngay)=?
        GROUP BY MONTH(ngay)
    """;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, year);
            ResultSet rs = ps.executeQuery();

            int[] data = new int[12];

            while (rs.next()) {
                int thang = rs.getInt("thang");
                data[thang - 1] = rs.getInt("tong");
            }

            for (int i : data) {
                list.add(i);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Integer> getXuatTheoThang(int year) throws ClassNotFoundException {
        List<Integer> list = new ArrayList<>();

        String sql = """
        SELECT MONTH(ngay) thang, SUM(soLuong) tong
        FROM phieukho
        WHERE loai='XUAT' AND YEAR(ngay)=?
        GROUP BY MONTH(ngay)
    """;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, year);
            ResultSet rs = ps.executeQuery();

            int[] data = new int[12];

            while (rs.next()) {
                int thang = rs.getInt("thang");
                data[thang - 1] = rs.getInt("tong");
            }

            for (int i : data) {
                list.add(i);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Double> getDoanhThuTheoThang(int year) throws ClassNotFoundException {
        List<Double> list = new ArrayList<>();

        String sql = """
        SELECT MONTH(NgayDatHang) thang, SUM(TongTien) tong
        FROM donhang
        WHERE TrangThai='DaGiao' AND YEAR(NgayDatHang)=?
        GROUP BY MONTH(NgayDatHang)
    """;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, year);
            ResultSet rs = ps.executeQuery();

            double[] data = new double[12];

            while (rs.next()) {
                int thang = rs.getInt("thang");
                data[thang - 1] = rs.getDouble("tong");
            }

            for (double i : data) {
                list.add(i);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Map<String, Integer> getDonTheoTrangThai() throws ClassNotFoundException {
        Map<String, Integer> map = new HashMap<>();

        // Trạng thái đơn hàng chính
        String sql1 = """
        SELECT TrangThai, COUNT(*) as soLuong 
        FROM donhang 
        GROUP BY TrangThai
    """;

        // Trạng thái hoàn hàng (chỉ tính những đơn đã DaGiao và có yêu cầu hoàn)
        String sql2 = """
        SELECT TrangThaiHoan, COUNT(*) as soLuong 
        FROM donhang 
        WHERE TrangThaiHoan IS NOT NULL 
        GROUP BY TrangThaiHoan
    """;

        try (Connection conn = Connect.getConnection()) {

            // Query trạng thái đơn chính
            try (PreparedStatement ps = conn.prepareStatement(sql1); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getString("TrangThai"), rs.getInt("soLuong"));
                }
            }

            // Query trạng thái hoàn
            try (PreparedStatement ps = conn.prepareStatement(sql2); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getString("TrangThaiHoan"), rs.getInt("soLuong"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    // PHÂN TÍCH TỔNG HỢP THEO GIÀI ĐOẠN (Yêu cầu đề tài trang 4)
    public Map<String, Double> getMetricsByTimeFrame(String type, int year, int month, int quarter) throws ClassNotFoundException {
        Map<String, Double> results = new HashMap<>();
        String condition = " WHERE dh.TrangThai = 'DaGiao' AND YEAR(dh.NgayDatHang) = ? ";
        if (type.equals("month")) {
            condition += " AND MONTH(dh.NgayDatHang) = " + month;
        }
        if (type.equals("quarter")) {
            condition += " AND QUARTER(dh.NgayDatHang) = " + quarter;
        }

        String sql = "SELECT "
                + "COALESCE(SUM(dh.TongTien), 0) as r, "
                + "COUNT(DISTINCT dh.MaDonHang) as o, "
                + "COALESCE(SUM(ct.soLuong), 0) as q "
                + "FROM donhang dh "
                + "LEFT JOIN chitietdonhang ct ON dh.MaDonHang = ct.MaDonHang " + condition;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                double revenue = rs.getDouble("r");
                double orders = rs.getDouble("o");

                results.put("revenue", rs.getDouble("r"));
                results.put("orders", rs.getDouble("o"));
                results.put("quantity", rs.getDouble("q"));

                double aov = (orders > 0) ? (revenue / orders) : 0.0;
                results.put("aov", aov);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return results;
    }

    // DỮ LIỆU CHUỖI THỜI GIAN CHO BIỂU ĐỒ (Phục vụ Holt-Winters)
    public List<Map<String, Object>> getTimeSeriesData(String viewType, int year, int month, int quarter) throws ClassNotFoundException {
        List<Map<String, Object>> list = new ArrayList<>();
        String select = "";
        String groupBy = "";
        String condition = " WHERE dh.TrangThai = 'DaGiao' AND YEAR(dh.NgayDatHang) = ? ";

        if (viewType.equals("year")) {
            select = "MONTH(dh.NgayDatHang) as label, SUM(dh.TongTien) as val";
            groupBy = "MONTH(dh.NgayDatHang)";
        } else if (viewType.equals("month")) {
            select = "DAY(dh.NgayDatHang) as label, SUM(dh.TongTien) as val";
            groupBy = "DAY(dh.NgayDatHang)";
            condition += " AND MONTH(dh.NgayDatHang) = " + month;
        } else if (viewType.equals("quarter")) {
            select = "MONTH(dh.NgayDatHang) as label, SUM(dh.TongTien) as val";
            groupBy = "MONTH(dh.NgayDatHang)";
            condition += " AND QUARTER(dh.NgayDatHang) = " + quarter;
        }

        String sql = "SELECT " + select + " FROM donhang dh " + condition + " GROUP BY " + groupBy + " ORDER BY label ASC";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("label", rs.getString("label"));
                map.put("value", rs.getDouble("val"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Integer> getSoDonTheoThang(int year) throws ClassNotFoundException {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT MONTH(NgayDatHang) thang, COUNT(*) as tong FROM donhang WHERE TrangThai='DaGiao' AND YEAR(NgayDatHang)=? GROUP BY MONTH(NgayDatHang)";
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            ResultSet rs = ps.executeQuery();
            int[] data = new int[12];
            while (rs.next()) {
                data[rs.getInt("thang") - 1] = rs.getInt("tong");
            }
            for (int i : data) {
                list.add(i);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Integer> getSanLuongTheoThang(int year) throws ClassNotFoundException {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT MONTH(dh.NgayDatHang) thang, SUM(ct.soLuong) as tong FROM donhang dh JOIN chitietdonhang ct ON dh.MaDonHang = ct.MaDonHang WHERE dh.TrangThai='DaGiao' AND YEAR(dh.NgayDatHang)=? GROUP BY MONTH(dh.NgayDatHang)";
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            ResultSet rs = ps.executeQuery();
            int[] data = new int[12];
            while (rs.next()) {
                data[rs.getInt("thang") - 1] = rs.getInt("tong");
            }
            for (int i : data) {
                list.add(i);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getTopSanPhamBanChay(int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT sp.TenSanPham, SUM(ct.soLuong) as tong_ban FROM sanpham sp JOIN chitietdonhang ct ON sp.MaSanPham = ct.MaSanPham JOIN donhang dh ON ct.MaDonHang = dh.MaDonHang WHERE dh.TrangThai = 'DaGiao' GROUP BY sp.MaSanPham, sp.TenSanPham ORDER BY tong_ban DESC LIMIT ?";
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("tenSP", rs.getString("TenSanPham"));
                map.put("tong_ban", rs.getInt("tong_ban"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getDoanhThuTheoDanhMuc() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT dm.TenDanhMuc, SUM(ct.soLuong * ct.giaBan) as doanh_thu FROM danhmuc dm JOIN sanpham sp ON dm.MaDanhMuc = sp.MaDanhMuc JOIN chitietdonhang ct ON sp.MaSanPham = ct.MaSanPham JOIN donhang dh ON ct.MaDonHang = dh.MaDonHang WHERE dh.TrangThai = 'DaGiao' GROUP BY dm.MaDanhMuc, dm.TenDanhMuc";
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("tenDM", rs.getString("TenDanhMuc"));
                map.put("doanhThu", rs.getDouble("doanh_thu"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, Double> getGrowthMetrics(int year, int month) {
        Map<String, Double> growth = new HashMap<>();
        double curr = 0, prev = 0;
        int pM = (month == 1) ? 12 : month - 1;
        int pY = (month == 1) ? year - 1 : year;
        String sql = "SELECT SUM(TongTien) FROM donhang WHERE TrangThai='DaGiao' AND YEAR(NgayDatHang)=? AND MONTH(NgayDatHang)=?";
        try (Connection conn = Connect.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, year);
                ps.setInt(2, month);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    curr = rs.getDouble(1);
                }
            }
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, pY);
                ps.setInt(2, pM);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    prev = rs.getDouble(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        growth.put("revenueGrowth", (prev > 0) ? ((curr - prev) / prev) * 100 : 0);
        return growth;
    }
}