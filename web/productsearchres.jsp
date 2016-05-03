<!DOCTYPE html>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>


<html>
    <head>
        <title>Search Results</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="css/bootstrap.css" rel="stylesheet">
        <style>
        body {
            padding-top: 60px; /* 60px to make the container go all the way to the bottom of the topbar */
            padding-bottom: 40px;
        }
        </style>
        <script src="js/jquery-1.10.2.min.js"></script>
        <script src="js/bootstrap.js"></script>
    </head>
    <body>
        <%@include file="includes/navbar.jsp" %>
        <div class="container">
        <div class="row">
            <div class="col-md-4">
                <p>
                    <b>Search Results</b><br>
                    <table class="table" style="width:100%">
                        <tr>
                            <th>Auction ID</th>
                            <th>Username</th>
                            <th>Brand</th>
                            <th>Model</th>
                            <th>Item Condition</th>
                            <th>Quantity</th>
                            <th>Max Bid</th>
                            <th>Number of Bids</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                        </tr>
                        <%
                            Connection searchres_conn = null;
                            try{
                                Class.forName("com.mysql.jdbc.Driver").newInstance();
                                searchres_conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe","yabe","yabe");
                            }

                            catch(Exception e){
                                out.print("<p>Could not connect to SQL server.</p>");
                                e.printStackTrace();
                            }
                            
                            String producttype = request.getParameter("producttype");
                            String tabletype = null;
                            if (producttype.equalsIgnoreCase("motherboard")) {
                                tabletype = "motherboard";
                            } else if (producttype.equalsIgnoreCase("cpu")) {
                                tabletype = "cpu";
                            } else if (producttype.equalsIgnoreCase("ram")) {
                                tabletype = "ram";
                            } else if (producttype.equalsIgnoreCase("gpu")) {
                                tabletype = "gpu";
                            } else if (producttype.equalsIgnoreCase("storage")) {
                                tabletype = "storage";
                            } else if (producttype.equalsIgnoreCase("case")) {
                                tabletype = "case_hw";
                            } else if (producttype.equalsIgnoreCase("psu")) {
                                tabletype = "psu";
                            } else if (producttype.equalsIgnoreCase("fan")) {
                                tabletype = "fan";
                            } else if (producttype.equalsIgnoreCase("other")) {
                                tabletype = "other";
                            }
                            
                            StringBuilder sb = new StringBuilder();
                            boolean sort = false;
                            boolean brandsort = (request.getParameter("brand") != null);
                            boolean modelsort = (request.getParameter("model") != null);
                            boolean maxbidsort = (request.getParameter("maxbid") != null);
                            boolean numbidssort = (request.getParameter("numbids") != null);
                            boolean enddatesort = (request.getParameter("enddate") != null);
                            if (brandsort) {
                                if (!sort) {
                                    sb.append("ORDER BY ");
                                    sort = true;
                                } else {
                                    sb.append(", ");
                                }
                                sb.append("brand ");
                                sb.append(request.getParameter("brand_order"));
                            } else if (modelsort) {
                                if (!sort) {
                                    sb.append("ORDER BY ");
                                    sort = true;
                                } else {
                                    sb.append(", ");
                                }
                                sb.append("model ");
                                sb.append(request.getParameter("model_order"));
                            } else if (maxbidsort) {
                                if (!sort) {
                                    sb.append("ORDER BY ");
                                    sort = true;
                                } else {
                                    sb.append(", ");
                                }
                                sb.append("maxBid ");
                                sb.append(request.getParameter("maxBid_order"));
                            } else if (numbidssort) {
                                if (!sort) {
                                    sb.append("ORDER BY ");
                                    sort = true;
                                } else {
                                    sb.append(", ");
                                }
                                sb.append("numBids ");
                                sb.append(request.getParameter("numBids_order"));
                            } else if (enddatesort) {
                                if (!sort) {
                                    sb.append("ORDER BY ");
                                    sort = true;
                                } else {
                                    sb.append(", ");
                                }
                                sb.append("end_date ");
                                sb.append(request.getParameter("enddate_order"));
                            }
                            
                            String searchquery = "SELECT * FROM " + tabletype + " t, product p, auction a WHERE p.productID = a.productID AND p.productID = t.productID AND a.completed = TRUE";
                            String oldquery = searchquery;
                            if (sort) {
                                searchquery += " " + sb.toString();
                            }
                            
                            Statement statement = searchres_conn.createStatement() ;
                            ResultSet resultset;
                            resultset = statement.executeQuery(searchquery);
                        %>
                        <%  while(resultset.next()){ 
                                int auctionID = resultset.getInt("auctionID");
                                String username = resultset.getString("username"); %>
                        <tr>
                            <td><a href="auction.jsp?auctionID=<%= auctionID %>" /><%= auctionID %></a></td>
                            <td><a href="userprofile.jsp?username=<%= username %>" /><%= username %> </a></td>
                            <td><%= resultset.getString("brand") %></td>
                            <td><%= resultset.getString("model") %></td>
                            <td><%= resultset.getString("item_condition") %></td>
                            <td><%= resultset.getInt("quantity") %></td>
                            <td><%= resultset.getDouble("maxBid") %></td>
                            <td><%= resultset.getInt("numBids") %></td>
                            <td><%= resultset.getTimestamp("start_date") %></td>
                            <td><%= resultset.getTimestamp("end_date") %></td>
                        </tr>
                        <% } %>
                    </table>
                </p>
                <form action="hybridsearchres.jsp" method="post">
                    <p>
                        <b>Further refine product search with keyword search:</b><br>
                        Search brand and model names (separate keywords by spaces):<br>
                        <input type="text" name="searchparam" value="Search keywords" /><br>
                        <input type="hidden" name="oldquery" value="<%= oldquery %>">
                        <input type="hidden" name="oldsort" value="<%= sb.toString() %>">
                        <button class="btn btn-lg btn-primary btn-block" type="submit">Keyword Search</button>
                    </p>
                </form>
                <a href="allauctions.jsp" class="button btn btn-lg btn-primary btn-block">New Search</a>
            </div>   
        </div>
        <%@include file="includes/footer.jsp" %>
        </div>
    </body>
</html>
