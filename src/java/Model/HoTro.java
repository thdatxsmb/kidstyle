/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.sql.Timestamp; 
/**
 *
 * @author LEGION 5
 */
public class HoTro {

    private int maHoTro;
    private String tenNguoiGui;
    private String email;
    private String soDienThoai;
    private String noiDung;
    private String trangThai;
    private String phanHoi;
    private Timestamp ngayGui;
    private Timestamp ngayXuLy;

    public HoTro() {
    }

    public HoTro(int maHoTro, String tenNguoiGui, String email, String soDienThoai, String noiDung, String trangThai, String phanHoi, Timestamp ngayGui, Timestamp ngayXuLy) {
        this.maHoTro = maHoTro;
        this.tenNguoiGui = tenNguoiGui;
        this.email = email;
        this.soDienThoai = soDienThoai;
        this.noiDung = noiDung;
        this.trangThai = trangThai;
        this.phanHoi = phanHoi;
        this.ngayGui = ngayGui;
        this.ngayXuLy = ngayXuLy;
    }

    public int getMaHoTro() {
        return maHoTro;
    }

    public void setMaHoTro(int maHoTro) {
        this.maHoTro = maHoTro;
    }

    public String getTenNguoiGui() {
        return tenNguoiGui;
    }

    public void setTenNguoiGui(String tenNguoiGui) {
        this.tenNguoiGui = tenNguoiGui;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getSoDienThoai() {
        return soDienThoai;
    }

    public void setSoDienThoai(String soDienThoai) {
        this.soDienThoai = soDienThoai;
    }

    public String getNoiDung() {
        return noiDung;
    }

    public void setNoiDung(String noiDung) {
        this.noiDung = noiDung;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public String getPhanHoi() {
        return phanHoi;
    }

    public void setPhanHoi(String phanHoi) {
        this.phanHoi = phanHoi;
    }

    public Timestamp getNgayGui() {
        return ngayGui;
    }

    public void setNgayGui(Timestamp ngayGui) {
        this.ngayGui = ngayGui;
    }

    public Timestamp getNgayXuLy() {
        return ngayXuLy;
    }

    public void setNgayXuLy(Timestamp ngayXuLy) {
        this.ngayXuLy = ngayXuLy;
    }
    
    
}
