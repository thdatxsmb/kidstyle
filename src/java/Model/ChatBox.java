/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.util.Date;

/**
 *
 * @author LEGION 5
 */
public class ChatBox {

    private int MaChat;
    private int MaNguoiDung;
    private String NoiDung;
    private String NguoiGui;
    private String TrangThai;
    private Date ThoiGian;

    public ChatBox() {
    }

    public ChatBox(int MaChat, int MaNguoiDung, String NoiDung, String NguoiGui, String TrangThai, Date ThoiGian) {
        this.MaChat = MaChat;
        this.MaNguoiDung = MaNguoiDung;
        this.NoiDung = NoiDung;
        this.NguoiGui = NguoiGui;
        this.TrangThai = TrangThai;
        this.ThoiGian = ThoiGian;
    }

    public int getMaChat() {
        return MaChat;
    }

    public void setMaChat(int MaChat) {
        this.MaChat = MaChat;
    }

    public int getMaNguoiDung() {
        return MaNguoiDung;
    }

    public void setMaNguoiDung(int MaNguoiDung) {
        this.MaNguoiDung = MaNguoiDung;
    }

    public String getNoiDung() {
        return NoiDung;
    }

    public void setNoiDung(String NoiDung) {
        this.NoiDung = NoiDung;
    }

    public String getNguoiGui() {
        return NguoiGui;
    }

    public void setNguoiGui(String NguoiGui) {
        this.NguoiGui = NguoiGui;
    }

    public String getTrangThai() {
        return TrangThai;
    }

    public void setTrangThai(String TrangThai) {
        this.TrangThai = TrangThai;
    }

    public Date getThoiGian() {
        return ThoiGian;
    }

    public void setThoiGian(Date ThoiGian) {
        this.ThoiGian = ThoiGian;
    }

}