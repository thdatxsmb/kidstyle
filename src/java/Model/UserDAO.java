package Model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    private static final String URL = "jdbc:mysql://localhost:3306/qlthoitrang?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASS = "";
    private Connection conn;

    public UserDAO() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(URL, USER, PASS);
    }

    // ==================== LẤY DANH SÁCH NGƯỜI DÙNG ====================
    public List<User> getAllUsers() throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM nguoidung ORDER BY MaNguoiDung";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapUser(rs));
            }
        }
        return list;
    }

    // ==================== ĐĂNG NHẬP ====================
    public User login(String input, String password) throws SQLException {
        String sql = "SELECT * FROM nguoidung WHERE (Email = ? OR SoDienThoai = ?) AND MatKhau = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, input);
            ps.setString(2, input);
            ps.setString(3, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        }
        return null;
    }

    // ==================== ĐĂNG KÝ ====================
    public int register(User u) throws SQLException {
        if (u.getEmail() != null && isEmailExists(u.getEmail())) {
            throw new SQLException("Email đã tồn tại.");
        }
        if (u.getSoDienThoai() != null && isPhoneExists(u.getSoDienThoai())) {
            throw new SQLException("Số điện thoại đã tồn tại.");
        }

        String sql = "INSERT INTO nguoidung (HoTen, Email, SoDienThoai, DiaChi, MatKhau, VaiTro, NgayTao) "
                + "VALUES (?, ?, ?, ?, ?, ?, NOW())";

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, u.getHoTen());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getSoDienThoai());
            ps.setString(4, u.getDiaChi());
            ps.setString(5, u.getMatKhau());
            ps.setString(6, u.getVaiTro() != null ? u.getVaiTro() : "KhachHang");

            int rows = ps.executeUpdate();

            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        return -1; // thất bại
    }

    // ==================== CẬP NHẬT NGƯỜI DÙNG ====================
    public boolean updateUser(User u, boolean updatePassword) throws SQLException {
        String sql = updatePassword
                ? "UPDATE nguoidung SET HoTen=?, Email=?, SoDienThoai=?, DiaChi=?, MatKhau=?, VaiTro=? WHERE MaNguoiDung=?"
                : "UPDATE nguoidung SET HoTen=?, Email=?, SoDienThoai=?, DiaChi=?, VaiTro=? WHERE MaNguoiDung=?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setString(idx++, u.getHoTen());
            ps.setString(idx++, u.getEmail());
            ps.setString(idx++, u.getSoDienThoai());
            ps.setString(idx++, u.getDiaChi());
            if (updatePassword) {
                ps.setString(idx++, u.getMatKhau());
            }
            ps.setString(idx++, u.getVaiTro());
            ps.setInt(idx, u.getMaNguoiDung());
            return ps.executeUpdate() > 0;
        }
    }

    // ==================== XÓA NGƯỜI DÙNG ====================
    public boolean deleteUser(int id) throws SQLException {
        try {
            // XÓA BẢNG CON TRƯỚC
            String sql1 = "DELETE FROM nhatky_hoatdong WHERE maNguoiDung = ?";
            try (PreparedStatement ps1 = conn.prepareStatement(sql1)) {
                ps1.setInt(1, id);
                ps1.executeUpdate();
            }

            // SAU ĐÓ XÓA USER
            String sql2 = "DELETE FROM nguoidung WHERE MaNguoiDung = ?";
            try (PreparedStatement ps2 = conn.prepareStatement(sql2)) {
                ps2.setInt(1, id);
                return ps2.executeUpdate() > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }

    // ==================== KIỂM TRA TỒN TẠI ====================
    public boolean isEmailExists(String email) throws SQLException {
        return checkExists("Email", email, -1);
    }

    public boolean isPhoneExists(String sdt) throws SQLException {
        return checkExists("SoDienThoai", sdt, -1);
    }

    // Kiểm tra tồn tại khi UPDATE (bỏ qua chính bản thân user)
    public boolean checkEmailExists(String email, int excludeId) throws SQLException {
        return checkExists("Email", email, excludeId);
    }

    public boolean checkSDTExist(String sdt, int excludeId) throws SQLException {
        return checkExists("SoDienThoai", sdt, excludeId);
    }

    private boolean checkExists(String column, String value, int excludeId) throws SQLException {
        if (value == null || value.trim().isEmpty()) {
            return false;
        }

        String sql = "SELECT COUNT(*) FROM nguoidung WHERE " + column + " = ?";
        if (excludeId > 0) {
            sql += " AND MaNguoiDung != ?";
        }

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, value.trim());
            if (excludeId > 0) {
                ps.setInt(2, excludeId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    // Map ResultSet -> User
    private User mapUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setMaNguoiDung(rs.getInt("MaNguoiDung"));
        u.setHoTen(rs.getString("HoTen"));
        u.setEmail(rs.getString("Email"));
        u.setSoDienThoai(rs.getString("SoDienThoai"));
        u.setDiaChi(rs.getString("DiaChi"));
        u.setMatKhau(rs.getString("MatKhau"));
        u.setVaiTro(rs.getString("VaiTro"));
        u.setNgayTao(rs.getTimestamp("NgayTao"));
        return u;
    }

    public void close() throws SQLException {
        if (conn != null && !conn.isClosed()) {
            conn.close();
        }
    }
}
