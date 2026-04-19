/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.util.*;

/**
 *
 * @author LEGION 5
 */
public class HoltWinters {

    public static class KetQuaDuBao {

        public List<Double> duBao;
        public List<Double> canTren;
        public List<Double> canDuoi;
        public double mape;

        public KetQuaDuBao(List<Double> duBao, List<Double> tren, List<Double> duoi, double mape) {
            this.duBao = duBao;
            this.canTren = tren;
            this.canDuoi = duoi;
            this.mape = mape;
        }
    }

    public static KetQuaDuBao duBao(List<Double> duLieu, int doDaiMuaVu, int soThangDuBao) {
        int n = duLieu.size();
        if (n < doDaiMuaVu) {
            doDaiMuaVu = Math.max(1, n / 2);
        }

        double alpha = 0.3, beta = 0.1, gamma = 0.3;
        double[] mucDo = new double[n];
        double[] xuHuong = new double[n];
        double[] muaVu = new double[doDaiMuaVu];

        // Khởi tạo
        mucDo[0] = duLieu.get(0);
        xuHuong[0] = (n > 1) ? (duLieu.get(1) - duLieu.get(0)) : 0;
        for (int i = 0; i < doDaiMuaVu; i++) {
            muaVu[i] = 1.0;
        }

        double tongSaiSo = 0;
        int count = 0;

        // Huấn luyện
        for (int t = 1; t < n; t++) {
            int m = t % doDaiMuaVu;
            double actual = duLieu.get(t);
            double predicted = (mucDo[t - 1] + xuHuong[t - 1]) * muaVu[m];

            if (actual > 0) {
                tongSaiSo += Math.abs((actual - predicted) / actual);
                count++;
            }

            mucDo[t] = alpha * (actual / muaVu[m]) + (1 - alpha) * (mucDo[t - 1] + xuHuong[t - 1]);
            xuHuong[t] = beta * (mucDo[t] - mucDo[t - 1]) + (1 - beta) * xuHuong[t - 1];
            muaVu[m] = gamma * (actual / mucDo[t]) + (1 - gamma) * muaVu[m];
        }

        double mape = (count > 0) ? (tongSaiSo / count) * 100 : 0;
        mape = Math.round(mape * 100.0) / 100.0;

        // Dự báo
        List<Double> forecast = new ArrayList<>();
        List<Double> upper = new ArrayList<>();
        List<Double> lower = new ArrayList<>();
        double sigma = tinhDoLechChuan(duLieu);

        for (int h = 1; h <= soThangDuBao; h++) {
            int m = (n - 1 + h) % doDaiMuaVu;
            double val = (mucDo[n - 1] + h * xuHuong[n - 1]) * muaVu[m];
            val = Math.max(0, val);
            forecast.add(val);
            upper.add(val + 1.96 * sigma);
            lower.add(Math.max(0, val - 1.96 * sigma));
        }

        return new KetQuaDuBao(forecast, upper, lower, mape);
    }

    private static double tinhDoLechChuan(List<Double> data) {
        double avg = data.stream().mapToDouble(d -> d).average().orElse(0);
        double var = 0;
        for (double d : data) {
            var += Math.pow(d - avg, 2);
        }
        return Math.sqrt(var / data.size());
    }
}
