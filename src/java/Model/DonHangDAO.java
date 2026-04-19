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

public class DonHangDAO {

    //admin getAll
    public List<DonHang> getAllDonHang() throws ClassNotFoundException {
        List<DonHang> list = new ArrayList<>();

        String sql = """
        SELECT 
            d.*,
            COALESCE(u.HoTen, u.Email, CONCAT('User ', d.MaNguoiDung)) AS TenKhach
        FROM donhang d
        LEFT JOIN nguoidung u ON d.MaNguoiDung = u.MaNguoiDung
        ORDER BY d.NgayDatHang DESC
    """;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                DonHang dh = new DonHang();

                dh.setMaDonHang(rs.getInt("MaDonHang"));
                dh.setMaNguoiDung(rs.getInt("MaNguoiDung"));
                dh.setNgayDatHang(rs.getTimestamp("NgayDatHang"));
                dh.setTongTien(rs.getDouble("TongTien"));
                dh.setTrangThai(rs.getString("TrangThai"));
                dh.setDiaChiNhanHang(rs.getString("DiaChiNhanHang"));
                dh.setTenNguoiNhan(rs.getString("TenNguoiNhan"));
                dh.setSoDienThoaiNhan(rs.getString("SoDienThoaiNhan"));

                // ⭐ THÊM FIELD MỚI
                dh.setTenKhach(rs.getString("TenKhach"));
                dh.setTrangThaiHoan(rs.getString("trangThaiHoan"));
                dh.setNgayYeuCauHoan(rs.getTimestamp("ngayYeuCauHoan"));
                dh.setNgayDuyetHoan(rs.getTimestamp("ngayDuyetHoan"));
                dh.setLyDo(rs.getString("lyDo"));

                list.add(dh);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    //admin updateDonHang
    public boolean updateTrangThai(int maDonHang, String trangThai) throws ClassNotFoundException {
        String sql = "UPDATE donhang SET TrangThai = ? WHERE MaDonHang = ?";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, trangThai);
            ps.setInt(2, maDonHang);

            boolean result = ps.executeUpdate() > 0;

            if (result) {
                NhatKyDAO logDAO = new NhatKyDAO();
                logDAO.insertLog(1, "Cập nhật trạng thái", "Đơn #" + maDonHang + " -> " + trangThai);
            }

            return result;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    //tao don hang
    public int taoDonHang(Connection conn, DonHang donHang) throws SQLException {
        String sql = """
        INSERT INTO donhang 
        (MaNguoiDung, TongTien, TrangThai, GhiChu, 
         DiaChiNhanHang, PhuongThucThanhToan, TenNguoiNhan, SoDienThoaiNhan)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """;

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, donHang.getMaNguoiDung());
            ps.setDouble(2, donHang.getTongTien());

            // SỬA QUAN TRỌNG: Dùng giá trị không dấu, không khoảng trắng
            String trangThai = "ChoXacNhan";   // Phải khớp chính xác với ENUM
            if ("DaXacNhan".equals(donHang.getTrangThai())) {
                trangThai = "DaXacNhan";
            } else if ("DangGiao".equals(donHang.getTrangThai())) {
                trangThai = "DangGiao";
            } else if ("DaGiao".equals(donHang.getTrangThai())) {
                trangThai = "DaGiao";
            }

            ps.setString(3, trangThai);
            ps.setString(4, donHang.getGhiChu() != null ? donHang.getGhiChu() : "");
            ps.setString(5, donHang.getDiaChiNhanHang() != null ? donHang.getDiaChiNhanHang() : "");
            ps.setString(6, donHang.getPhuongThucThanhToan() != null ? donHang.getPhuongThucThanhToan() : "COD");
            ps.setString(7, donHang.getTenNguoiNhan() != null ? donHang.getTenNguoiNhan() : "");
            ps.setString(8, donHang.getSoDienThoaiNhan() != null ? donHang.getSoDienThoaiNhan() : "");

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);

                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi insert donhang: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    public boolean themChiTietDonHang(Connection conn, int maDonHang, int maSanPham, int soLuong, double donGia) throws SQLException {

        String sql = """
        INSERT INTO chitietdonhang (MaDonHang, MaSanPham, SoLuong, GiaBan)
        VALUES (?, ?, ?, ?)
    """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maDonHang);
            ps.setInt(2, maSanPham);
            ps.setInt(3, soLuong);
            ps.setDouble(4, donGia);

            return ps.executeUpdate() > 0;
        }
    }

    // Hàm tiện ích dùng transaction toàn bộ (nên dùng cái này trong controller)
    public int taoDonHangVaChiTiet(DonHang donHang, List<ChiTietDonHang> chiTietList) throws ClassNotFoundException {

        try (Connection conn = Connect.getConnection()) {

            conn.setAutoCommit(false);

            // 1. Tạo đơn hàng
            int maDonHang = taoDonHang(conn, donHang);
            if (maDonHang == -1) {
                conn.rollback();
                return -1;
            }

            // DAO sản phẩm
            SanPhamDAO spDAO = new SanPhamDAO();

            // 2. Loop từng sản phẩm
            for (ChiTietDonHang ct : chiTietList) {

                // 2.1 Thêm chi tiết đơn
                boolean ok = themChiTietDonHang(conn, maDonHang,
                        ct.getMaSanPham(),
                        ct.getSoLuong(),
                        ct.getDonGia());

                if (!ok) {
                    conn.rollback();
                    return -1;
                }

                // 2.2 TRỪ TỒN KHO (QUAN TRỌNG)
                boolean updateStock = spDAO.thayDoiTonKho(
                        conn,
                        ct.getMaSanPham(),
                        -ct.getSoLuong()
                );

                if (!updateStock) {
                    System.out.println("Không đủ hàng!");
                    conn.rollback();
                    return -1;
                }
            }

            // 3. TẠO THANH TOÁN (QUAN TRỌNG)
            taoThanhToan(conn, maDonHang,
                    donHang.getPhuongThucThanhToan(),
                    donHang.getTongTien());

            conn.commit();

            //log
            NhatKyDAO logDAO = new NhatKyDAO();
            logDAO.insertLog(
                    donHang.getMaNguoiDung(),
                    "Đặt đơn hàng",
                    "Đơn #" + maDonHang
            );
            return maDonHang;

        } catch (Exception e) {
            System.out.println("LỖI CHI TIẾT: " + e.getMessage());
            e.printStackTrace();
            return -1;
        }
    }

    //user mua lai
    public List<ChiTietDonHang> getChiTietDonHang(int maDonHang) throws ClassNotFoundException {
        List<ChiTietDonHang> list = new ArrayList<>();

        String sql = "SELECT * FROM chitietdonhang WHERE MaDonHang = ?";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maDonHang);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ChiTietDonHang ct = new ChiTietDonHang();
                ct.setMaSanPham(rs.getInt("MaSanPham"));
                ct.setSoLuong(rs.getInt("SoLuong"));
                ct.setDonGia(rs.getDouble("GiaBan"));

                list.add(ct);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<DonHang> layDanhSachDonHangCuaNguoiDung(int maNguoiDung) throws ClassNotFoundException {
        List<DonHang> list = new ArrayList<>();

        String sql = """
    SELECT d.*, sp.TenSanPham, sp.DuongDanAnh, ct.MaSanPham
    FROM donhang d
    JOIN chitietdonhang ct ON d.MaDonHang = ct.MaDonHang
    JOIN sanpham sp ON ct.MaSanPham = sp.MaSanPham
    WHERE d.MaNguoiDung = ?
    AND ct.MaSanPham = (
        SELECT ct2.MaSanPham
        FROM chitietdonhang ct2
        WHERE ct2.MaDonHang = d.MaDonHang
        LIMIT 1
    )
    ORDER BY d.NgayDatHang DESC
    """;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maNguoiDung);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                DonHang dh = new DonHang();

                dh.setMaDonHang(rs.getInt("MaDonHang"));
                dh.setMaNguoiDung(rs.getInt("MaNguoiDung"));
                dh.setMaSanPham(rs.getInt("MaSanPham"));
                dh.setNgayDatHang(rs.getTimestamp("NgayDatHang"));
                dh.setTongTien(rs.getDouble("TongTien"));
                dh.setTrangThai(rs.getString("TrangThai"));
                dh.setPhuongThucThanhToan(rs.getString("PhuongThucThanhToan"));

                dh.setTenSanPham(rs.getString("TenSanPham"));
                dh.setDuongDanAnh(rs.getString("DuongDanAnh"));

                dh.setTrangThaiHoan(rs.getString("trangThaiHoan"));

                list.add(dh);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    //chi tiet
    public DonHang getById(int id) throws ClassNotFoundException {

        String sql = "SELECT * FROM donhang WHERE MaDonHang = ?";

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                DonHang d = new DonHang();

                d.setMaDonHang(rs.getInt("MaDonHang"));
                d.setMaNguoiDung(rs.getInt("MaNguoiDung"));
                d.setNgayDatHang(rs.getTimestamp("NgayDatHang")); // ⭐ QUAN TRỌNG
                d.setTongTien(rs.getDouble("TongTien"));
                d.setTrangThai(rs.getString("TrangThai"));
                d.setPhuongThucThanhToan(rs.getString("PhuongThucThanhToan"));
                d.setTenNguoiNhan(rs.getString("TenNguoiNhan"));
                d.setSoDienThoaiNhan(rs.getString("SoDienThoaiNhan"));
                d.setDiaChiNhanHang(rs.getString("DiaChiNhanHang"));
                d.setGhiChu(rs.getString("GhiChu"));

                d.setLyDo(rs.getString("lyDo"));
                d.setTrangThaiHoan(rs.getString("trangThaiHoan"));
                d.setNgayYeuCauHoan(rs.getTimestamp("ngayYeuCauHoan"));
                d.setNgayDuyetHoan(rs.getTimestamp("ngayDuyetHoan"));

                return d;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    //thanh toan
    public void taoThanhToan(Connection conn, int maDonHang, String phuongThuc, double soTien) throws SQLException {
        String trangThai = "ChoThanhToan";

        String sql = """
        INSERT INTO ThanhToan (MaDonHang, PhuongThuc, TrangThai, SoTien, MaGiaoDich, NgayThanhToan)
        VALUES (?, ?, ?, ?, ?, ?)
    """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maDonHang);
            ps.setString(2, phuongThuc);
            ps.setString(3, trangThai);
            ps.setDouble(4, soTien);
            ps.setString(5, java.util.UUID.randomUUID().toString());
            ps.setTimestamp(6, new java.sql.Timestamp(System.currentTimeMillis()));

            ps.executeUpdate();
        }
    }

    public void yeuCauHoan(int id, String lyDo) {
        String sql = """
        UPDATE DonHang 
        SET lyDo=?, trangThaiHoan=?, ngayYeuCauHoan=NOW() 
        WHERE MaDonHang=?
    """;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, lyDo);
            ps.setString(2, "ChoDuyet"); // ✅ trạng thái hoàn riêng
            ps.setInt(3, id);

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void duyetHoan(int id) {
        String sql = """
    UPDATE DonHang 
    SET trangThaiHoan=?, ngayDuyetHoan=NOW(), TrangThai='DaHuy'
    WHERE MaDonHang=?
    """;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "DaDuyet");
            ps.setInt(2, id);

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void tuChoiHoan(int id) {
        String sql = """
        UPDATE DonHang 
        SET trangThaiHoan='TuChoi' 
        WHERE MaDonHang=?
    """;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean huyDon(int id, String lyDo) {
        String sql = "UPDATE DonHang SET TrangThai=?, lyDo=? WHERE MaDonHang=?";
        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            if (lyDo == null || lyDo.trim().isEmpty()) {
                lyDo = "Không có lý do";
            }

            ps.setString(1, "DaHuy");
            ps.setString(2, lyDo);
            ps.setInt(3, id);

            return ps.executeUpdate() > 0; // ✅ trả về true/false

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}
