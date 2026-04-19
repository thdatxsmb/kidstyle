/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.util.*;
import Model.ThongKeDAO;

/**
 *
 * @author LEGION 5
 */
@WebServlet(name = "Admin_BaoCaoController", urlPatterns = {"/Admin_BaoCaoController"})
public class Admin_BaoCaoController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet Admin_BaoCaoController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Admin_BaoCaoController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        ThongKeDAO dao = new ThongKeDAO();
        Calendar cal = Calendar.getInstance();

        String viewType = request.getParameter("viewType");
        if (viewType == null) {
            viewType = "year";
        }

        String yearStr = request.getParameter("year");
        int year = (yearStr != null) ? Integer.parseInt(yearStr) : cal.get(Calendar.YEAR);

        String monthStr = request.getParameter("month");
        int month = (monthStr != null) ? Integer.parseInt(monthStr) : cal.get(Calendar.MONTH) + 1;

        String quarterStr = request.getParameter("quarter");
        int quarter = (quarterStr != null) ? Integer.parseInt(quarterStr) : 1;

        String action = request.getParameter("action");

// CHỨC NĂNG XUẤT CSV CHO POWER BI
        if ("export_csv".equals(action)) {
            exportToCSV(response, dao, viewType, year, month, quarter);
            return;
        }


        try {
            request.setAttribute("viewType", viewType);
            request.setAttribute("currYear", year);
            request.setAttribute("currMonth", month);
            request.setAttribute("currQuarter", quarter);

            request.setAttribute("m", dao.getMetricsByTimeFrame(viewType, year, month, quarter));
            request.setAttribute("timeSeries", dao.getTimeSeriesData(viewType, year, month, quarter));
            request.setAttribute("topSanPham", dao.getTopSanPhamBanChay(5));
            request.setAttribute("doanhThuDM", dao.getDoanhThuTheoDanhMuc());
            request.setAttribute("totalUsers", dao.countUsers());
            request.setAttribute("orderStatus", dao.getDonTheoTrangThai());
            request.setAttribute("growth", dao.getGrowthMetrics(year, month));

            request.getRequestDispatcher("admin_BaoCao.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void exportToCSV(HttpServletResponse response, ThongKeDAO dao, String viewType, int year, int month, int quarter) throws IOException {
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=KidStyle_PowerBI_" + viewType + ".csv");
        response.getWriter().write('\ufeff');

        PrintWriter writer = response.getWriter();
        // Header chuẩn: Timeline (Dạng Date), Doanh Thu (Số), Nhãn (Text)
        writer.println("Timeline,Label,Revenue,Type,Year");

        try {
            List<Map<String, Object>> data = dao.getTimeSeriesData(viewType, year, month, quarter);
            for (Map<String, Object> row : data) {
                String labelValue = row.get("label").toString();
                double revenue = (double) row.get("value");
                
                // Chuyển đổi nhãn thành ngày chuẩn để Power BI vẽ biểu đồ đường
                String powerBIDate = "";
                if ("year".equals(viewType)) {
                    // Nếu là năm, label là tháng (1-12) -> Chuyển thành YYYY-MM-01
                    powerBIDate = String.format("%d-%02d-01", year, Integer.parseInt(labelValue));
                } else if ("month".equals(viewType)) {
                    // Nếu là tháng, label là ngày -> Chuyển thành YYYY-MM-DD
                    powerBIDate = String.format("%d-%02d-%02d", year, month, Integer.parseInt(labelValue));
                } else {
                    powerBIDate = labelValue; 
                }

                // Xuất dòng dữ liệu: Chuẩn hóa không có dấu phẩy phân cách nghìn để Power BI không hiểu nhầm
                writer.printf("%s,%s,%.2f,%s,%d\n", powerBIDate, ("Tháng " + labelValue), revenue, viewType, year);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        writer.flush();
        writer.close();
    }


    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short descrip2tion of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
