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
public class ChatBoxDAO {

    public boolean insert(ChatBox chat) throws ClassNotFoundException {

        String sql = """
            INSERT INTO ChatBox (MaNguoiDung, NoiDung, NguoiGui, TrangThai)
            VALUES (?, ?, ?, ?)
        """;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, chat.getMaNguoiDung());
            ps.setString(2, chat.getNoiDung());
            ps.setString(3, chat.getNguoiGui());
            ps.setString(4, "ChuaDoc");

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<ChatBox> getByUser(int maNguoiDung) throws ClassNotFoundException {

        List<ChatBox> list = new ArrayList<>();

        String sql = """
            SELECT * FROM ChatBox
            WHERE MaNguoiDung = ?
            ORDER BY ThoiGian ASC
        """;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maNguoiDung);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ChatBox c = new ChatBox();

                c.setMaChat(rs.getInt("MaChat"));
                c.setMaNguoiDung(rs.getInt("MaNguoiDung"));
                c.setNoiDung(rs.getString("NoiDung"));
                c.setNguoiGui(rs.getString("NguoiGui"));
                c.setTrangThai(rs.getString("TrangThai"));
                c.setThoiGian(rs.getTimestamp("ThoiGian"));

                list.add(c);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean markAsRead(int maNguoiDung) throws ClassNotFoundException {

        String sql = """
        UPDATE ChatBox 
        SET TrangThai = 'DaDoc' 
        WHERE MaNguoiDung = ?
        AND NguoiGui = 'USER'
    """;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maNguoiDung);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean markReadUser(int maNguoiDung) throws ClassNotFoundException {

        String sql = """
    UPDATE ChatBox 
    SET TrangThai = 'DaDoc' 
    WHERE MaNguoiDung = ?
    AND NguoiGui IN ('ADMIN','AI')
    """;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maNguoiDung);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<User> getUserChatList() throws ClassNotFoundException {

        List<User> list = new ArrayList<>();

        String sql
                = """
                SELECT DISTINCT u.MaNguoiDung, u.HoTen, u.Email
                FROM ChatBox c
                JOIN nguoidung u ON c.MaNguoiDung = u.MaNguoiDung
                ORDER BY c.MaNguoiDung DESC
            """;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setMaNguoiDung(rs.getInt("MaNguoiDung"));
                u.setHoTen(rs.getString("HoTen"));
                u.setEmail(rs.getString("Email"));
                list.add(u);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean insertAdmin(ChatBox chat) throws ClassNotFoundException {

        String sql = """
        INSERT INTO ChatBox (MaNguoiDung, NoiDung, NguoiGui, TrangThai)
        VALUES (?, ?, 'ADMIN', 'DaDoc')
    """;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, chat.getMaNguoiDung());
            ps.setString(2, chat.getNoiDung());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int countUserChuaTraLoi() throws ClassNotFoundException {

        String sql = """
        SELECT COUNT(DISTINCT MaNguoiDung)
        FROM ChatBox
        WHERE TrangThai = 'ChuaDoc'
        AND NguoiGui = 'USER'
    """;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public int countUnreadByUser(int maNguoiDung) throws ClassNotFoundException {

        String sql = """
        SELECT COUNT(*)
        FROM ChatBox
        WHERE MaNguoiDung = ?
        AND TrangThai = 'ChuaDoc'
        AND NguoiGui = 'USER'
    """;

        try (Connection conn = Connect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maNguoiDung);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

}
