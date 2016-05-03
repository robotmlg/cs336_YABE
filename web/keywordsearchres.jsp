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
                            
                            String searchparam = request.getParameter("searchparam").trim();
                            StringBuilder sb = new StringBuilder();
                            if (searchparam.contains(" ")) {
                                String parameters[] = searchparam.trim().split(" +");
                                
                                int i = 0;
                                for (i = 0; i < parameters.length; i++) {
                                    if (i == 0) {
                                        sb.append("p.brand LIKE '%" + parameters[i] + "%'");
                                        sb.append(" OR ");
                                        sb.append("p.model LIKE '%" + parameters[i] + "%'");
                                        sb.append(" OR ");
                                        sb.append("p.extraInfo LIKE '%" + parameters[i] + "%'");
                                    } else {
                                        sb.append(" OR ");
                                        sb.append("p.brand LIKE '%" + parameters[i] + "%'");
                                        sb.append(" OR ");
                                        sb.append("p.model LIKE '%" + parameters[i] + "%'");
                                        sb.append(" OR ");
                                        sb.append("p.extraInfo LIKE '%" + parameters[i] + "%'");
                                    }
                                }
                            } else {
                                sb.append("p.brand LIKE '%" + searchparam + "%'");
                                sb.append(" OR ");
                                sb.append("p.model LIKE '%" + searchparam + "%'");
                                sb.append(" OR ");
                                sb.append("p.extraInfo LIKE '%" + searchparam + "%'");
                            }
                            
                            String keywordComp = sb.toString();
                            Statement statement = searchres_conn.createStatement() ;
                            ResultSet resultset;
                            resultset = statement.executeQuery("SELECT * FROM auction a, product p WHERE (" + keywordComp + ")");
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
                <a href="allauctions.jsp" class="button btn btn-lg btn-primary btn-block">New Search</a>
            </div>   
        </div>
        <%@include file="includes/footer.jsp" %>
        </div>
    </body>
</html>
