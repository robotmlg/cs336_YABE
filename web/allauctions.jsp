<!DOCTYPE html>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>


<html>
    <head>
        <title>All Auctions</title>
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
            <div class="jumbotron">
                <form action="keywordsearchres.jsp" method="post">
                        <b>Search brand and model names (separate keywords by spaces):</b><br>
                        <input type="text" name="searchparam" placeholder="Search keywords" /><br>

                        <button class="btn btn-lg btn-primary btn-block" type="submit">Keyword Search</button>
                </form>
                </div>
                <div class="jumbotron">
                <form action="productsearchres.jsp" method="post">
                        <b>Specialized product search (can be combined with keyword search after you submit):</b><br>
                        <b>Select a product type:</b><br>
                        <input type="radio" name="producttype" value="motherboard" checked> Motherboard<br>
                        <input type="radio" name="producttype" value="cpu" checked> CPU<br>
                        <input type="radio" name="producttype" value="ram"> RAM<br>
                        <input type="radio" name="producttype" value="gpu" checked> GPU<br>
                        <input type="radio" name="producttype" value="storage" checked> Storage<br>
                        <input type="radio" name="producttype" value="case"> Case<br>
                        <input type="radio" name="producttype" value="psu"> PSU<br>
                        <input type="radio" name="producttype" value="fan"> Fan<br>
                        <input type="radio" name="producttype" value="other"> Other<br>

                        <b>Auction sorting options:</b><br>
                        <input type="checkbox" name="brand" value="brand" > Sort by product brand name<br>
                        Sorting order: 
                        <input type="radio" name="brand_order" value="ASC" checked> Ascending
                        <input type="radio" name="brand_order" value="DESC" > Descending<br>
                        <input type="checkbox" name="model" value="model" > Sort by product model name<br>
                        Sorting order: 
                        <input type="radio" name="model_order" value="ASC" checked> Ascending
                        <input type="radio" name="model_order" value="DESC" > Descending<br>
                        <input type="checkbox" name="maxbid" value="maxbid" > Sort by max bid<br>
                        Sorting order: 
                        <input type="radio" name="maxBid_order" value="ASC" checked> Ascending
                        <input type="radio" name="maxBid_order" value="DESC" > Descending<br>
                        <input type="checkbox" name="numbids" value="numbids" > Sort by number of bids<br>
                        Sorting order: 
                        <input type="radio" name="numBids_order" value="ASC" checked> Ascending
                        <input type="radio" name="numBids_order" value="DESC" > Descending<br>
                        <input type="checkbox" name="enddate" value="enddate" > Sort by auction end date<br>
                        Sorting order: 
                        <input type="radio" name="endDate_order" value="ASC" checked> Ascending
                        <input type="radio" name="endDate_order" value="DESC" > Descending<br>

                        <button class="btn btn-lg btn-primary btn-block" type="submit">Product Search</button>
                </form>
                </div>
                </div>
                <div class="col-md-8">
                <div class="jumbotron">
                <h2>List Of All Auctions</h2>
                    <table class="table">
                        <tr>
                            <th>Seller</th>
                            <th>Item</th>
                            <th>Condition</th>
                            <th>Quantity</th>
                            <th>Max Bid</th>
                            <th>Number of Bids</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                        </tr>
                        <%
                            Connection products_conn = null;
                            try{
                                Class.forName("com.mysql.jdbc.Driver").newInstance();
                                products_conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe","yabe","yabe");
                            }

                            catch(Exception e){
                                out.print("<p>Could not connect to SQL server.</p>");
                                e.printStackTrace();
                            }

                            Statement statement = products_conn.createStatement() ;
                            ResultSet resultset;
                            resultset = statement.executeQuery("SELECT * FROM auction a, product p WHERE a.productID = p.productID AND a.completed = FALSE");
                        %>
                        <%  while(resultset.next()){ 
                                int auctionID = resultset.getInt("auctionID");
                                String username = resultset.getString("username"); %>
                        <tr>
                            <td><a href="userprofile.jsp?username=<%= username %>" /><%= username %> </a></td>
                            <td><a href="auction.jsp?auctionID=<%= auctionID %>" /><%= resultset.getString("brand") %> <%= resultset.getString("model") %></a></td>
                            <td><%= resultset.getString("item_condition") %></td>
                            <td><%= resultset.getInt("quantity") %></td>
                            <td><%= resultset.getDouble("maxBid") %></td>
                            <td><%= resultset.getInt("numBids") %></td>
                            <td><%= resultset.getTimestamp("start_date") %></td>
                            <td><%= resultset.getTimestamp("end_date") %></td>
                        </tr>
                        <% } %>
                    </table>
                    </div>
            </div>   
        </div>
        <%@include file="includes/footer.jsp" %>
        </div>
    </body>
</html>
