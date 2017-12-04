<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Pinsight - Most Recent 30 Minutes</title>
        <meta http-equiv="content-type" content="text/html;charset=utf-8" />

        <!-- Mobile Specific Meta -->
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">

        <!-- Fonts -->
        <link href="https://fonts.googleapis.com/css?family=Roboto:300,300italic,400,500,700" rel="stylesheet" type="text/css">
        <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700" rel="stylesheet" type="text/css">

        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js" integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ" crossorigin="anonymous"></script>
        <script src="fusioncharts/fusioncharts.js"></script>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-light bg-light" style="">
            <a class="navbar-brand" href="#">Pinsight</a></a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav mr-auto">
                    <li class="nav-item active">
                        <!--<a class="nav-link" href="#">Home <span class="sr-only">(current)</span></a>-->
                    </li>
                </ul>
            </div>
        </nav>
        <div class="container-fluid" style="background-color: #2b9eec; height: 250px; margin-bottom: 30px;">
            <div class="row">
                <div class="col-sm-4" style="margin-top: 100px;">
                    <h1 style="color: white;">Network Analytics</h1>
                    <p style="color: white; margin-top: -10px;">Welcome to Pinsight, an online network analytics tool.</p>
                </div>
            </div>
        </div>
        <div style="align-content: center; text-align: center;">
            <h2>
                Most Recent 30 Minutes
            </h2>
            <div class="container" style="margin-bottom: 30px;">
                <div class="btn-group">
                    <button type="button" class="btn btn-primary" disabled="disabled">Most Recent 30 Minutes</button>
                    <a class="btn btn-primary" href="index.jsp" role="button">All Time</a>
                </div>
            </div>
        </div>
        <div id="charts" class="container-fluid">
            <div class="row"  style="margin-bottom: 40px;">
                <div  style="align-content: center; margin-right: 10%; margin-left: 10%;">
                    <div id="senderChart"></div>
                </div>
            </div>
            <div class="row" style="margin-bottom: 40px;">

                <div  style="align-content: center; margin-right: 10%; margin-left: 10%;">
                    <div id="destPortChart"></div>
                </div>
            </div>
            <div class="row" style="margin-bottom: 40px;">
                <div  style="align-content: center; margin-right: 10%; margin-left: 10%;">
                    <div id="netActivityChart"></div>
                </div>
            </div>
            <div class="row" style="margin-bottom: 40px;">
                <div  style="align-content: center; margin-right: 10%; margin-left: 10%;">
                    <div id="frameLenChart"></div>
                </div>
            </div>
            <!-- JSP CODE -->
            <%@page import="fusioncharts.FusionCharts" %>
            <%@page import="DBModule.QueryHelper" %>
            <%@page import="java.sql.SQLException" %>
                <%
            // Call the core DB java code
            QueryHelper queryHelp = new QueryHelper();

            // Create first chart
            FusionCharts senderChart = null;
            try {
                senderChart= new FusionCharts(
                        "column2d",// chartType
                        "popSender",// chartId
                        "1000","400",// chartWidth, chartHeight
                        "senderChart",// chartContainer
                        "json",// dataFormat
                        queryHelp.generateChartJSON("popSender", "recent") //dataSource
                );
            }
            catch(SQLException e){
                out.print(e.getStackTrace());
            }
        %>
                <%=senderChart.render()%>
                <%
            // Create second chart
            FusionCharts destPortChart = null;
            try {
                destPortChart= new FusionCharts(
                        "column2d",// chartType
                        "destPort",// chartId
                        "1000","400",// chartWidth, chartHeight
                        "destPortChart",// chartContainer
                        "json",// dataFormat
                        queryHelp.generateChartJSON("popDestPort", "recent") //dataSource
                );
            }
            catch(SQLException e){
                out.print(e.getStackTrace());
            }
        %>
                <%=destPortChart.render()%>
                <%
            // Create third chart
            FusionCharts netActivityChart = null;
            try {
                netActivityChart= new FusionCharts(
                        "area2d",// chartType
                        "netActivity",// chartId
                        "1000","400",// chartWidth, chartHeight
                        "netActivityChart",// chartContainer
                        "json",// dataFormat
                        queryHelp.generateChartJSON("netActivity", "recent") //dataSource
                );
            }
            catch(SQLException e){
                out.print(e.getStackTrace());
            }
        %>
                <%=netActivityChart.render()%>
                <%
            // Create fourth chart
            FusionCharts frameLenChart = null;
            try {
                frameLenChart= new FusionCharts(
                        "area2d",// chartType
                        "frameLen",// chartId
                        "1000","400",// chartWidth, chartHeight
                        "frameLenChart",// chartContainer
                        "json",// dataFormat
                        queryHelp.generateChartJSON("frameLen", "recent") //dataSource
                );
            }
            catch(SQLException e){
                out.print(e.getStackTrace());
            }
        %>
                <%=frameLenChart.render()%>
            <!-- END JSP CODE -->
    </body>
</html>
