<!DOCTYPE html>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>

<% 
    Connection conn = null;
    try{
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe","yabe","yabe");
    }

    catch(Exception e){
        System.out.println("Could not connect to SQL server");
        e.printStackTrace();
    }
  
    Statement stmt = conn.createStatement();
    ResultSet rs = null;

%>

<html>
    <head>
        <title>YABE</title>
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
        <div class="col-lg-12">
        <h1>Welcome to YABE!</h1>
        <% if(session.getAttribute("loggedIn") != "true") {%>
            <div class="alert alert-info">
            Login to buy and sell computer parts.
            </div>
        <% } else { 
                String username = (String) session.getAttribute("username");
        %>
        <div class="jumbotron">
            <h2>Your active auctions</h2>
            <table class="table">
            <tr><th>User</th><th>Item</th><th>Current Bid</th><th>End Date</th></tr>
            <%
                String active_q = "SELECT p.model, p.brand, a.end_date, a.maxBid, "+
                    "a.auctionID, a.username FROM auction a, product p "+
                    "WHERE a.productID=p.productID AND a.username=\'"+username+
                    "\' AND TIMESTAMPDIFF(SECOND,NOW(),a.end_date)>0";
                rs = stmt.executeQuery(active_q);

                while(rs.next()){ %>
            <tr>
                <td>
                    <a href="userprofile.jsp?username=<%= rs.getString("username")%>">
                    <%= rs.getString("username") %>
                    </a>
                </td>
                <td>
                    <a href="auction.jsp?auctionID=<%= rs.getInt("auctionID")%>">
                    <%= rs.getString("brand") %> <%= rs.getString("model") %>
                    </a>
                </td>
                <td><%= rs.getDouble("maxBid") %></td>
                <td><%= rs.getTimestamp("end_date").toString() %></td>
            </tr>
            <%  }
            %>
            </table>
            <h2>Your active bids</h2>
            <table class="table">
            <tr><th>Item</th><th>Current Bid</th><th>End Date</th></tr>
            <%
                String bids_q = "SELECT p.model, p.brand, a.end_date, a.maxBid, "+
                    "b.username, a.auctionID "+
                    "FROM auction a, product p, bid b, participatesIn q "+
                    "WHERE q.username=\'"+username+"\' AND q.auctionID=a.auctionID "+
                    "AND a.productID=p.productID AND b.auctionID=a.auctionID "+
                    "AND TIMESTAMPDIFF(SECOND,NOW(),a.end_date)>0";
                rs = stmt.executeQuery(bids_q);

                while(rs.next()){ 
                    if(username != rs.getString("username")){%>
            <tr class="danger">
            <% } else { %>
            <tr> 
                <td>
                    <a href="auction.jsp?auctionID=<%= rs.getInt("auctionID")%>">
                    <%= rs.getString("brand") %> <%= rs.getString("model") %>
                    </a>
                </td>
                <td><%= rs.getDouble("maxBid") %></td>
                <td><%= rs.getTimestamp("end_date").toString() %></td>
            </tr>
            <%  } }
            %>
            </table>
        </div>
        <% } %>
        </div>
        </div>
        <div class="row">
        <div class="col-md-4">
        <div class="jumbotron">
            <h3>Sponsored Auctions</h3>
            <table class="table">
            <tr><th>Item</th><th>End Date</th></tr>
            <%
                String sponsor_q = "SELECT p.model, p.brand, a.end_date, "+
                    "a.auctionID FROM auction a, product p, "+
                        "(SELECT auctionID, COUNT(*) AS num_bids FROM bid "+
                        "GROUP BY auctionID) b "+
                    "WHERE TIMESTAMPDIFF(SECOND,NOW(),a.end_date)>0 AND "+
                    "b.num_bids <= (SELECT AVG(num_bids) "+
                        "FROM (SELECT auctionID, COUNT(*) AS num_bids FROM bid "+
                        "GROUP BY auctionID) as c) AND "+
                    "a.productID=p.productID AND sponsored=true";
                rs = stmt.executeQuery(sponsor_q);

                for(int i=0;rs.next() && i<10; ++i){ %>
            <tr> 
                <td>
                    <a href="auction.jsp?auctionID=<%= rs.getInt("auctionID")%>">
                    <%= rs.getString("brand") %> <%= rs.getString("model") %>
                    </a>
                </td>
                <td><%= rs.getDouble("maxBid") %></td>
                <td><%= rs.getTimestamp("end_date").toString() %></td>
            </tr>
            <%  } %>
            </table>
        </div>
        </div>
        <div class="col-md-8">
        <div class="jumbotron">
            <h2>Popular Items</h2>
            <table class="table">
            <tr><th>User</th><th>Item</th><th>Current Bid</th><th>End Date</th></tr>
            <%
                String popular_q = "SELECT p.model, p.brand, a.end_date, a.maxBid, "+
                    "a.auctionID, a.username FROM auction a, product p, "+
                        "(SELECT auctionID, COUNT(*) AS num_bids FROM bid "+
                        "GROUP BY auctionID) b "+
                    "WHERE TIMESTAMPDIFF(SECOND,NOW(),a.end_date)>0 AND "+
                    "b.num_bids >= (SELECT AVG(num_bids) "+
                        "FROM (SELECT auctionID, COUNT(*) AS num_bids FROM bid "+
                        "GROUP BY auctionID) as c) AND "+
                    "a.productID=p.productID";
                rs = stmt.executeQuery(popular_q);

                for(int i=0;rs.next() && i<10; ++i){ %>
            <tr> 
                <td>
                    <a href="userprofile.jsp?username=<%= rs.getString("username")%>">
                    <%= rs.getString("username") %>
                    </a>
                </td>
                <td>
                    <a href="auction.jsp?auctionID=<%= rs.getInt("auctionID")%>">
                    <%= rs.getString("brand") %> <%= rs.getString("model") %>
                    </a>
                </td>
                <td><%= rs.getDouble("maxBid") %></td>
                <td><%= rs.getTimestamp("end_date").toString() %></td>
            </tr>
            <%  } %>
            </table>
        </div>
        </div>
        </div>
        <%@include file="includes/footer.jsp" %>
        </div>
    </body>
</html>
