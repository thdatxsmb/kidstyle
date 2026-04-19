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
import java.util.ArrayList;
import java.util.List;

public class KhuyenMaiDAO {

    public void dongBoGiaSanPham() {
        try (Connection conn = Connect.getConnection()) {
            conn.setAutoCommit(false);
            try (Statement st = conn.createStatement()) {

                // BƯỚC 0: TỰ ĐỘNG CẬP NHẬT TRẠNG THÁI (Mới thêm)
                // Chuyển các KM đã quá ngày sang 'HeThan'
                st.executeUpdate("UPDATE khuyenmai SET TrangThai = 'HeThan' WHERE NgayKetThuc < CURDATE() AND TrangThai != 'HeThan'");

                // BƯỚC 1: RESET - Đưa tất cả GiaKhuyenMai về NULL
                st.executeUpdate("UPDATE sanpham SET GiaKhuyenMai = NULL");

                // BƯỚC 2: Lấy danh sách khuyến mãi đang HIỆU LỰC (Phải là 'HoatDong' và trong ngày)
                String sqlGet = "SELECT MaSanPham, MaDanhMuc, PhanTramGiam FROM khuyenmai "
                        + "WHERE TrangThai = 'HoatDong' AND CURDATE() BETWEEN NgayBatDau AND NgayKetThuc";

                List<KhuyenMai> listKM = new ArrayList<>();
                try (ResultSet rs = st.executeQuery(sqlGet)) {
                    while (rs.next()) {
                        KhuyenMai km = new KhuyenMai();
                        int maSP = rs.getInt("MaSanPham");
                        if (rs.wasNull()) {
                            maSP = -1;
                        }
                        int maDM = rs.getInt("MaDanhMuc");
                        if (rs.wasNull()) {
                            maDM = -1;
                        }

                        km.setMaSanPham(maSP);
                        km.setMaDanhMuc(maDM);
                        km.setPhanTramGiam(rs.getDouble("PhanTramGiam"));
                        listKM.add(km);
                    }
                }

                // BƯỚC 3: ÁP DỤNG THEO THỨ TỰ ƯU TIÊN
                // 3.1: TOÀN SHOP (Cả MaSP và MaDM đều NULL)
                for (KhuyenMai km : listKM) {
                    if (km.getMaSanPham() == -1 && km.getMaDanhMuc() == -1) {
                        try (PreparedStatement ps = conn.prepareStatement("UPDATE sanpham SET GiaKhuyenMai = ROUND(GiaBan * (1 - ?/100), 0)")) {
                            ps.setDouble(1, km.getPhanTramGiam());
                            ps.executeUpdate();
                        }
                    }
                }

                // 3.2: THEO DANH MỤC (MaDM > 0 và MaSP là NULL)
                for (KhuyenMai km : listKM) {
                    if (km.getMaDanhMuc() > 0 && km.getMaSanPham() == -1) {
                        try (PreparedStatement ps = conn.prepareStatement("UPDATE sanpham SET GiaKhuyenMai = ROUND(GiaBan * (1 - ?/100), 0) WHERE MaDanhMuc = ?")) {
                            ps.setDouble(1, km.getPhanTramGiam());
                            ps.setInt(2, km.getMaDanhMuc());
                            ps.executeUpdate();
                        }
                    }
                }

                // 3.3: THEO SẢN PHẨM (Ưu tiên cao nhất)
                for (KhuyenMai km : listKM) {
                    if (km.getMaSanPham() > 0) {
                        try (PreparedStatement ps = conn.prepareStatement("UPDATE sanpham SET GiaKhuyenMai = ROUND(GiaBan * (1 - ?/100), 0) WHERE MaSanPham = ?")) {
                            ps.setDouble(1, km.getPhanTramGiam());
                            ps.setInt(2, km.getMaSanPham());
                            ps.executeUpdate();
                        }
                    }
                }

                conn.commit();
            } catch (Exception ex) {
                conn.rollback();
                ex.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<KhuyenMai> layTatCa() throws ClassNotFoundException {
        List<KhuyenMai> ds = new ArrayList<>();
        String sql = "SELECT km.*, sp.TenSanPham, dm.TenDanhMuc "
                + "FROM khuyenmai km "
                + "LEFT JOIN sanpham sp ON km.MaSanPham = sp.MaSanPham "
                + "LEFT JOIN danhmuc dm ON km.MaDanhMuc = dm.MaDanhMuc "
                + "ORDER BY km.MaKhuyenMai DESC";
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                KhuyenMai km = new KhuyenMai();
                km.setMaKhuyenMai(rs.getInt("MaKhuyenMai"));
                km.setTenKhuyenMai(rs.getString("TenKhuyenMai"));
                km.setMaSanPham(rs.getInt("MaSanPham"));
                km.setMaDanhMuc(rs.getInt("MaDanhMuc"));
                km.setPhanTramGiam(rs.getDouble("PhanTramGiam"));
                km.setGiaTriGiam(rs.getDouble("GiaTriGiam")); // QUAN TRỌNG: Cần có dòng này để lấy giá trị tối đa
                km.setNgayBatDau(rs.getTimestamp("NgayBatDau"));
                km.setNgayKetThuc(rs.getTimestamp("NgayKetThuc"));
                km.setTrangThai(rs.getString("TrangThai")); // Lấy trạng thái từ DB
                km.setTenSanPham(rs.getString("TenSanPham") != null ? rs.getString("TenSanPham") : "");
                km.setTenDanhMuc(rs.getString("TenDanhMuc") != null ? rs.getString("TenDanhMuc") : "");
                ds.add(km);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ds;
    }

    public boolean themMoi(KhuyenMai km) throws ClassNotFoundException {
        String sql = "INSERT INTO khuyenmai (TenKhuyenMai, MaSanPham, MaDanhMuc, PhanTramGiam, GiaTriGiam, NgayBatDau, NgayKetThuc, TrangThai) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, km.getTenKhuyenMai());
            if (km.getMaSanPham() <= 0) {
                ps.setNull(2, Types.INTEGER);
            } else {
                ps.setInt(2, km.getMaSanPham());
            }
            if (km.getMaDanhMuc() <= 0) {
                ps.setNull(3, Types.INTEGER);
            } else {
                ps.setInt(3, km.getMaDanhMuc());
            }
            ps.setDouble(4, km.getPhanTramGiam());
            ps.setDouble(5, km.getGiaTriGiam());
            ps.setDate(6, new java.sql.Date(km.getNgayBatDau().getTime()));
            ps.setDate(7, new java.sql.Date(km.getNgayKetThuc().getTime()));
            ps.setString(8, "HoatDong");
            boolean kq = ps.executeUpdate() > 0;
            if (kq) {
                dongBoGiaSanPham();
            }
            return kq;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean capNhat(KhuyenMai km) throws ClassNotFoundException {
        String sql = "UPDATE khuyenmai SET TenKhuyenMai=?, PhanTramGiam=?, GiaTriGiam=?, NgayBatDau=?, NgayKetThuc=?, MaSanPham=?, MaDanhMuc=? WHERE MaKhuyenMai=?";
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, km.getTenKhuyenMai());
            ps.setDouble(2, km.getPhanTramGiam());
            ps.setDouble(3, km.getGiaTriGiam());
            ps.setDate(4, new java.sql.Date(km.getNgayBatDau().getTime()));
            ps.setDate(5, new java.sql.Date(km.getNgayKetThuc().getTime()));
            if (km.getMaSanPham() <= 0) {
                ps.setNull(6, Types.INTEGER);
            } else {
                ps.setInt(6, km.getMaSanPham());
            }
            if (km.getMaDanhMuc() <= 0) {
                ps.setNull(7, Types.INTEGER);
            } else {
                ps.setInt(7, km.getMaDanhMuc());
            }
            ps.setInt(8, km.getMaKhuyenMai());
            boolean kq = ps.executeUpdate() > 0;
            if (kq) {
                dongBoGiaSanPham();
            }
            return kq;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean xoa(int id) throws ClassNotFoundException {
        String sql = "DELETE FROM khuyenmai WHERE MaKhuyenMai = ?";
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            boolean kq = ps.executeUpdate() > 0;
            if (kq) {
                dongBoGiaSanPham();
            }
            return kq;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}