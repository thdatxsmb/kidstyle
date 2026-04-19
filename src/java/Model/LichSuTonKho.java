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
public class LichSuTonKho {

    private int maLog;
    private int maSanPham;
    private String loaiThayDoi;
    private int soLuong;
    private double donGiaNhap;
    private double tongTien;
    private String ghiChu;
    private Timestamp ngayThayDoi;
    private int nguoiThucHien;
    private String tenSanPham;

    public LichSuTonKho() {
    }

    public LichSuTonKho(int maLog, int maSanPham, String loaiThayDoi, int soLuong,
            double donGiaNhap, double tongTien, String ghiChu,
            Timestamp ngayThayDoi, int nguoiThucHien) {
        this.maLog = maLog;
        this.maSanPham = maSanPham;
        this.loaiThayDoi = loaiThayDoi;
        this.soLuong = soLuong;
        this.donGiaNhap = donGiaNhap;
        this.tongTien = tongTien;
        this.ghiChu = ghiChu;
        this.ngayThayDoi = ngayThayDoi;
        this.nguoiThucHien = nguoiThucHien;
    }

    public int getMaLog() {
        return maLog;
    }

    public void setMaLog(int maLog) {
        this.maLog = maLog;
    }

    public int getMaSanPham() {
        return maSanPham;
    }

    public void setMaSanPham(int maSanPham) {
        this.maSanPham = maSanPham;
    }

    public String getTenSanPham() {
        return tenSanPham;
    }

    public void setTenSanPham(String tenSanPham) {
        this.tenSanPham = tenSanPham;
    }

    public String getLoaiThayDoi() {
        return loaiThayDoi;
    }

    public void setLoaiThayDoi(String loaiThayDoi) {
        this.loaiThayDoi = loaiThayDoi;
    }

    public int getSoLuong() {
        return soLuong;
    }

    public void setSoLuong(int soLuong) {
        this.soLuong = soLuong;
    }

    public double getDonGiaNhap() {
        return donGiaNhap;
    }

    public void setDonGiaNhap(double donGiaNhap) {
        this.donGiaNhap = donGiaNhap;
    }

    public double getTongTien() {
        return tongTien;
    }

    public void setTongTien(double tongTien) {
        this.tongTien = tongTien;
    }

    public String getGhiChu() {
        return ghiChu;
    }

    public void setGhiChu(String ghiChu) {
        this.ghiChu = ghiChu;
    }

    public Timestamp getNgayThayDoi() {
        return ngayThayDoi;
    }

    public void setNgayThayDoi(Timestamp ngayThayDoi) {
        this.ngayThayDoi = ngayThayDoi;
    }

    public int getNguoiThucHien() {
        return nguoiThucHien;
    }

    public void setNguoiThucHien(int nguoiThucHien) {
        this.nguoiThucHien = nguoiThucHien;
    }

}
