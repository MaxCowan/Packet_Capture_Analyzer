package DBModule;

import java.sql.*;
import java.util.*;
import com.google.gson.*;
import com.mysql.jdbc.Driver;

public class QueryHelper {

    public QueryHelper() {
    }

    private Connection getConnection() throws SQLException {
        String hostdb = "";  // MySQl host
        String userdb = "";  // MySQL username
        String passdb = "";  // MySQL password
        String namedb = "";  // MySQL database name

        //Establish a connection to the database
        DriverManager.registerDriver(new com.mysql.jdbc.Driver());
        return DriverManager.getConnection("jdbc:mysql://" + hostdb + "/" + namedb, userdb, passdb);
    }


    // mode can be "frameLen", "popSender", "popDestPort", or "netActivity"
    // timeSpan can be either "all" or "recent" for each of the four modes
    public String generateChartJSON(String mode, String timeSpan) throws SQLException {
        // Initialize connection
        Connection con = getConnection();

        String sql = getSQLQuery(mode, timeSpan);
        Gson gson = new Gson();

        // Execute the query.
        PreparedStatement pt = con.prepareStatement(sql);
        ResultSet rs = pt.executeQuery();

        // Push the data into the array using map object.
        ArrayList<Map<String, String>> arrData = new ArrayList<>();
        String[] queryColumns = getColNames(mode, timeSpan);
        while (rs.next()) {
            Map<String, String> lv = new HashMap<String, String>();
            lv.put("label", rs.getString(queryColumns[0]));
            lv.put("value", rs.getString(queryColumns[1]));
            arrData.add(lv);
        }

        // Close the connection.
        rs.close();

        // The 'chartobj' map object holds the chart attributes and data.
        Map<String, String> chartobj = getChartAttributes(mode, timeSpan);

        // Create 'dataMap' map object to make a complete FC datasource.
        Map<String, String> dataMap = new LinkedHashMap<String, String>();
        dataMap.put("chart", gson.toJson(chartobj));
        dataMap.put("data", gson.toJson(arrData));

        return gson.toJson(dataMap);
    }


    // Helper function to generateChartJSON for assigning the appropriate query
    private String getSQLQuery(String mode, String timeSpan) {
        // Assign sql the appropriate query
        switch (mode) {
            case "frameLen":
                switch (timeSpan) {
                    case "all":
                        return "SELECT DATE_FORMAT(`date`, '%m-%d %H:%i') AS timeChunk, AVG(size) AS avgLen " +
                                "FROM packet_data " +
                                "WHERE (destination LIKE 'vps105582.vps.ovh' OR destination LIKE 'vps105582.vps.ovh.ca') " +
                                "GROUP BY UNIX_TIMESTAMP(date) DIV (TIMESTAMPDIFF(SECOND,(SELECT MIN(date) FROM packet_data),(SELECT MAX(date) FROM packet_data))/50);";
                    case "recent":
                        return "SELECT DATE_FORMAT(`date`, '%m-%d %H:%i') AS timeChunk, AVG(size) AS avgLen " +
                                "FROM packet_data " +
                                "WHERE date >= (SELECT MAX(date) - INTERVAL 30 MINUTE FROM packet_data) " +
                                "AND (destination LIKE 'vps105582.vps.ovh' OR destination LIKE 'vps105582.vps.ovh.ca') " +
                                "GROUP BY UNIX_TIMESTAMP(date) DIV 120;";
                }
                break;
            case "popSender":
                switch (timeSpan) {
                    case "all":
                        return "SELECT source, count(source) AS freq " +
                                "FROM packet_data " +
                                "WHERE source != '' AND (destination LIKE 'vps105582.vps.ovh' OR destination LIKE 'vps105582.vps.ovh.ca') " +
                                "GROUP BY source " +
                                "ORDER BY count(source) " +
                                "DESC LIMIT 10;";
                    case "recent":
                        return "SELECT source, count(source) AS freq " +
                                "FROM packet_data " +
                                "WHERE date >= (SELECT MAX(date) - INTERVAL 30 MINUTE FROM packet_data) " +
                                "AND source != '' " +
                                "AND (destination LIKE 'vps105582.vps.ovh' OR destination LIKE 'vps105582.vps.ovh.ca') " +
                                "GROUP BY source " +
                                "ORDER BY count(source) " +
                                "DESC LIMIT 10;";
                }
                break;
            case "popDestPort":
                switch (timeSpan) {
                    case "all":
                        return "SELECT destination_port, count(destination_port) AS freq " +
                                "FROM packet_data " +
                                "WHERE destination LIKE 'vps105582.vps.ovh' OR destination LIKE 'vps105582.vps.ovh.ca' " +
                                "GROUP BY destination_port " +
                                "ORDER BY count(destination_port) " +
                                "DESC LIMIT 10;";
                    case "recent":
                        return "SELECT destination_port, count(destination_port) AS freq " +
                                "FROM packet_data " +
                                "WHERE date >= (SELECT MAX(date) - INTERVAL 30 MINUTE FROM packet_data) " +
                                "AND (destination LIKE 'vps105582.vps.ovh' OR destination LIKE 'vps105582.vps.ovh.ca') " +
                                "GROUP BY destination_port " +
                                "ORDER BY count(destination_port) " +
                                "DESC LIMIT 10;";
                }
                break;
            case "netActivity":
                switch (timeSpan) {
                    case "all":
                        return "SELECT DATE_FORMAT(`date`, '%m-%d %H:%i') AS timeChunk, COUNT(date) AS freq " +
                                "FROM packet_data " +
                                "WHERE (destination LIKE 'vps105582.vps.ovh' OR destination LIKE 'vps105582.vps.ovh.ca') " +
                                "GROUP BY UNIX_TIMESTAMP(date) DIV (TIMESTAMPDIFF(SECOND,(SELECT MIN(date) FROM packet_data),(SELECT MAX(date) FROM packet_data))/50);";
                    case "recent":
                        return "SELECT DATE_FORMAT(`date`, '%m-%d %H:%i') AS timeChunk, COUNT(date) AS freq " +
                                "FROM packet_data " +
                                "WHERE date >= (SELECT MAX(date) - INTERVAL 30 MINUTE FROM packet_data) " +
                                "AND (destination LIKE 'vps105582.vps.ovh' OR destination LIKE 'vps105582.vps.ovh.ca') " +
                                "GROUP BY UNIX_TIMESTAMP(date) DIV 120;";
                }
                break;
        }
        return "Invalid mode/timespan";
    }


    // Helper function to generateChartJSON for setting the visual parameters of the Chart
    private Map<String,String> getChartAttributes(String mode, String timeSpan) {
        // The 'chartobj' map object holds the chart attributes and data.
        Map<String, String> chartobj = new HashMap<String, String>();
        String caption = "";
        String subcaption = "";
        String xAxis = "";
        String yAxis = "";
        String dataColor = "";
        switch (mode) {
            case "frameLen":
                caption = "Average Packet Length Over Time";
                xAxis = "Time";
                yAxis = "Packet Length (in bits)";
                dataColor = "#ff8c00";
                break;
            case "popSender":
                caption = "Most Frequent Senders";
                xAxis = "Sender Address";
                yAxis = "Number of Packets Received";
                dataColor = "#6702cc";
                break;
            case "popDestPort":
                caption = "Most Popular Destination Ports";
                xAxis = "Port Number";
                yAxis = "Number of Packets Received";
                dataColor = "#00cbff";
                break;
            case "netActivity":
                caption = "Network Activity Over Time";
                xAxis = "Time";
                yAxis = "Packets Captured";
                dataColor = "#cc0131";
                break;
        }
        if (timeSpan.equals("all")) subcaption = "All Time";
        else subcaption = "Most Recent 30 Minutes";

        // Set the chart parameters
        chartobj.put("caption", caption);
        chartobj.put("subcaption", subcaption);
        chartobj.put("xaxisname", xAxis);
        chartobj.put("yaxisname", yAxis);
        chartobj.put("paletteColors", dataColor);
        chartobj.put("bgColor", "#ffffff");
        chartobj.put("borderAlpha", "20");
        chartobj.put("canvasBorderAlpha", "0");
        chartobj.put("usePlotGradientColor", "0");
        chartobj.put("plotBorderAlpha", "10");
        chartobj.put("showXAxisLine", "1");
        chartobj.put("xAxisLineColor", "#999999");
        chartobj.put("showValues", "1");
        chartobj.put("divlineColor", "#999999");
        chartobj.put("divLineIsDashed", "1");
        chartobj.put("showAlternateHGridColor", "0");

        return chartobj;
    }


    // Helper function to generateChartJSON for getting the appropriate column names for a query
    private String[] getColNames(String mode, String timeSpan){
        String[] colNames = new String[2];
        switch (mode) {
            case "frameLen":
                colNames[0] = "timeChunk";
                colNames[1] = "avgLen";
                break;
            case "popSender":
                colNames[0] = "source";
                colNames[1] = "freq";
                break;
            case "popDestPort":
                colNames[0] = "destination_port";
                colNames[1] = "freq";
                break;
            case "netActivity":
                colNames[0] = "timeChunk";
                colNames[1] = "freq";
                break;
        }
        return colNames;
    }
}
