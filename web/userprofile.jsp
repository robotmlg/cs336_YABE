<!DOCTYPE html>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>


<html>
    <head>
        <title><%= session.getAttribute("username") %>'s Profile</title>
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
                <%  
                    String name;
                    int age;
                    String address;
                    String username;
                    
                    Connection userinfo_conn = null;
                    try{
                        Class.forName("com.mysql.jdbc.Driver").newInstance();
                        userinfo_conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe","yabe","yabe");
                    }

                    catch(Exception e){
                        out.print("<p>Could not connect to SQL server.</p>");
                        e.printStackTrace();
                    }
                        
                    if (request.getParameter("username") == null) {
                        Statement statement = userinfo_conn.createStatement() ;
                        ResultSet resultset;
                        resultset = statement.executeQuery("SELECT * FROM users u WHERE u.username = \'" + session.getAttribute("username") + "\'");

                        resultset.next();

                        name = resultset.getString("name");
                        age = resultset.getInt("age");
                        address = resultset.getString("address");
                        username = resultset.getString("username");
                    } else {
                        Statement statement = userinfo_conn.createStatement() ;
                        ResultSet resultset;
                        resultset = statement.executeQuery("SELECT * FROM users u WHERE u.username = \'" + (String)request.getParameter("username") + "\'");

                        if(resultset.next()){
                            name = resultset.getString("name");
                            age = resultset.getInt("age");
                            address = resultset.getString("address");
                            username = resultset.getString("username");
                        }
                        else{
                            name = "User Not Found";
                            age = 0;
                            address = "";
                            username = "";
                        }
                    } %>
                    
                <%  if (session.getAttribute("username").equals(username)) { %>
                    <h>Hello <%= session.getAttribute("username") %>!</h>
                    <form action="edituser.jsp" method="post">
                        <p>
                            <b>Account Info:</b><br>
                            Name: 
                            <input type="text" name="name" placeholder="<%= name %>" /><br>
                            Age: 
                            <input type="number" name="age" value="<%= age %>" min="1" step="1" /><br>
                            Address: 
                            <input type="text" name="address" placeholder="<%= address %>" /><br>
                            Password: 
                            <input type="password" name="password" placeholder="New Password" /><br>
                            <button class="btn btn-lg btn-primary btn-block" type="submit">Submit Changes</button>
                        </p>
                    </form>
                <%  } else { %>
                    <h><%= request.getParameter("username") %>'s Public Profile</h>
                    <p>
                        <b>Account Info:</b><br>
                        Name: 
                        <input type="text" name="name" placeholder="<%= name %>" disabled /><br>
                        Age: 
                        <input type="number" name="age" value="<%= age %>" min="1" step="1" disabled /><br>
                        Address: 
                        <input type="text" name="address" placeholder="<%= address %>" disabled /><br>
                    </p>
                <%  } %>
                
                <p>
                    <b>Auctions:</b><br>
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
                            Connection userauctions_conn = null;
                            try{
                                Class.forName("com.mysql.jdbc.Driver").newInstance();
                                userauctions_conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe","yabe","yabe");
                            }

                            catch(Exception e){
                                out.print("<p>Could not connect to SQL server.</p>");
                                e.printStackTrace();
                            }

                            Statement statement = userauctions_conn.createStatement() ;
                            ResultSet resultset;
                            resultset = statement.executeQuery("SELECT * FROM auction a, product p WHERE a.productID = p.productID AND a.username = '" + username + "' ORDER BY a.end_date DESC");
                        %>
                        <%  while(resultset.next()){ 
                                int auctionID = resultset.getInt("auctionID"); %>
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
                
                <p>
                    <b>Bids:</b><br>
                    <table class="table" style="width:100%">
                        <tr>
                            <th>Auction ID</th>
                            <th>Username</th>
                            <th>Brand</th>
                            <th>Model</th>
                            <th>Time</th>
                            <th>Bid Amount</th>
                        </tr>
                        <%
                            Connection userbids_conn = null;
                            try{
                                Class.forName("com.mysql.jdbc.Driver").newInstance();
                                userbids_conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe","yabe","yabe");
                            }

                            catch(Exception e){
                                out.print("<p>Could not connect to SQL server.</p>");
                                e.printStackTrace();
                            }

                            Statement statement2 = userbids_conn.createStatement() ;
                            ResultSet resultset2;
                            resultset2 = statement2.executeQuery("SELECT * FROM bid b, auction a, product p WHERE a.auctionID = b.auctionID AND a.productID = p.productID AND b.username = '" + username + "' ORDER BY b.time DESC");
                        %>
                        <%  while(resultset2.next()){ 
                                int auctionID = resultset2.getInt("auctionID"); %>
                                <tr>
                                    <td><a href="auction.jsp?auctionID=<%= auctionID %>" /><%= auctionID %></a></td>
                                    <td><a href="userprofile.jsp?username=<%= username %>" /><%= username %> </a></td>
                                    <td><%= resultset2.getString("brand") %></td>
                                    <td><%= resultset2.getString("model") %></td>
                                    <td><%= resultset2.getTimestamp("time") %></td>
                                    <td><%= resultset2.getInt("amount") %></td>
                                </tr>
                        <% } %>
                    </table>
                </p>
            </div>   
        </div>
        <%@include file="includes/footer.jsp" %>
        </div>
    </body>
</html>
