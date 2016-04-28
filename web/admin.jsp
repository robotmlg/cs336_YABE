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

%>

<html>
    <head>
        <title>YABE Admin Page</title>
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
        <h1>YABE Admin Page</h1>
        <!-- check if user is admin -->
        <% if(session.getAttribute("loggedIn") != "true") {%>
        <p> Must be logged in as an administrator to view this page.<p>
        <% } else {
            
                String username = (String)session.getAttribute("username");
                Statement stmt = conn.createStatement();
                String admin_query = "SELECT COUNT(*) FROM admins WHERE username=\'"+username+"\'";
                ResultSet rs = stmt.executeQuery(admin_query);
                rs.next();

                if(rs.getInt(1) == 0){%>
        <p> Must be logged in as an administrator to view this page.<p>
              <% }
                else { 

                    if(session.getAttribute("alert") != null){%>
        <div class="alert alert-<%= session.getAttribute("alert_type")%>" role="alert"><%= session.getAttribute("alert") %></div>
                    <%
                    session.setAttribute("alert",null);
                    }
        %>

        </div>
        </div>
        <div class="row">
        <div class="col-lg-4">
        <div class="jumbotron">
        <h3>Best Selling Users</h3>
        <%
        String user_earnings = "SELECT win.owner, SUM(win.winning_bid) as total " +
            "FROM (SELECT MAX(b.amount) as winning_bid, a.username as owner " +
                    "FROM  auction a, bid b WHERE b.auctionID=a.auctionID AND " +
                    "TIMESTAMPDIFF(SECOND,NOW(),a.end_date)<0 " +
                    "GROUP BY a.auctionID) as win "+
            "GROUP BY win.owner ORDER BY total DESC";
        ResultSet users = stmt.executeQuery(user_earnings);
        %>
        <p><table border="1">
            <tr><th>User</th><th>Earnings</th><tr>
            <% for(int i=0; users.next() && i<10; ++i){%>
            <tr><td><%=users.getString(1)%></td><td><%=users.getDouble(2)%></td></tr>
            <%}%>
        </table></p>
        <button type="button" class="btn btn-primary btn-lg" data-toggle="modal" data-target="#userReportModal">See all users</button>
        <div class="modal fade" id="userReportModal" tabindex="-1" role="dialog" aria-labelledby="userReportModalLabel">
        <div class="modal-dialog" role="document">
        <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title" id="userReportModalLabel">User Report</h4>
        </div>
        <div class="modal-body">
        <p><table border="1">
            <tr><th>User</th><th>Earnings</th><tr>
            <% while(users.next()){%>
            <tr><td><%=users.getString(1)%></td><td><%=users.getDouble(2)%></td></tr>
            <%}%>
        </table></p>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
        </div>
        </div>
        </div>
        </div>
        </div>
        </div>
        <div class="col-lg-4">
        <div class="jumbotron">
        <%
        String item_earnings = "SELECT p.brand, p.model, SUM(win.win_bid) as total "+
            "FROM (SELECT MAX(b.amount) as win_bid, a.productID as productID " +
                    "FROM  auction a, bid b WHERE b.auctionID=a.auctionID AND " +
                    "TIMESTAMPDIFF(SECOND,NOW(),a.end_date)<0 " +
                    "GROUP BY a.auctionID) as win, product p "+
            "WHERE p.productID=win.productID "+
            "GROUP BY p.productID ORDER BY total DESC";
        ResultSet items = stmt.executeQuery(item_earnings);
        %>
        <h3>Best Selling Items</h3>
        <p><table border="1">
            <tr><th>Brand</th><th>Model</th><th>Earnings</th><tr>
            <% for(int i=0; items.next() && i<10; ++i){%>
            <tr><td><%=items.getString(1)%></td>
                <td><%=items.getString(2)%></td>
                <td><%=items.getDouble(3)%></td></tr>
            <%}%>
        </table></p>
        <button type="button" class="btn btn-primary btn-lg" data-toggle="modal" data-target="#itemReportModal">See all items</button>
        <div class="modal fade" id="itemReportModal" tabindex="-1" role="dialog" aria-labelledby="itemReportModalLabel">
        <div class="modal-dialog" role="document">
        <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title" id="itemReportModalLabel">Item Report</h4>
        </div>
        <div class="modal-body">
        <p><table border="1">
            <tr><th>Brand</th><th>Model</th><th>Earnings</th><tr>
            <% while(items.next()){%>
            <tr><td><%=items.getString(1)%></td>
                <td><%=items.getString(2)%></td>
                <td><%=items.getDouble(3)%></td></tr>
            <%}%>
        </table></p>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
        </div>
        </div>
        </div>
        </div>

        </div>
        </div>
        <div class="col-lg-4">
        <div class="jumbotron">
        <%
        // get the sum of all winning bids of ended auctions
        double total_earnings = 0;
        String total_earnings_q = "SELECT SUM(win.winning_bid) FROM (SELECT MAX(amount) as winning_bid FROM bid b, auction a WHERE b.auctionID=a.auctionID AND TIMESTAMPDIFF(SECOND,NOW(),end_date)<0 GROUP BY a.auctionID) as win";
        ResultSet total = stmt.executeQuery(total_earnings_q);
        if(total.first()){
            total_earnings = total.getDouble(1);
        }
        %>
        <h3>Total Earnings = <%= total_earnings %></h3>
        <h3>Earnings by Item Type</h3>
        <p><table border="1">
            <tr><th>Item Type</th><th>Earnings</th><tr>
            <% String types_list_q = "SELECT table_name, nice_name FROM item_types";
               ResultSet types_list = stmt.executeQuery(types_list_q);
               Statement stmt2 = conn.createStatement();

               while(types_list.next()){

        String type_earnings = "SELECT SUM(win.win_bid) as total "+
            "FROM (SELECT MAX(b.amount) as win_bid, a.productID as productID " +
                    "FROM  auction a, bid b WHERE b.auctionID=a.auctionID AND " +
                    "TIMESTAMPDIFF(SECOND,NOW(),a.end_date)<0 " +
                    "GROUP BY a.auctionID) as win "+
            "WHERE win.productID IN (SELECT productID FROM "+types_list.getString(1)+")";
        ResultSet types = stmt2.executeQuery(type_earnings);
        types.first();
        %>
            <tr><td><%=types_list.getString(2)%></td>
                <td><%=types.getDouble(1)%></td></tr>
            <%}%>
        </table></p>
        </div>
        </div>
        </div>
        <div class="row">
        <div class="col-lg-12">

        <div class="jumbotron">
        <h2>Create Customer Representatives</h2>
        <p>Enter a username to make that account a customer representative</p>
        <form action="makeRep.jsp" method="put">
            <input type="text" name="username" placeholder="Username" required />
            <button type="submit" class="btn btn-primary btn-lg">Create rep</button>
        </form>
        </div>

        <div class="jumbotron">
        <h2>Delete YABE</h2>
        <p>Press this button to erase the YABE database (except for your admin
        account) 
        </p>
        <button type="button" class="btn btn-danger btn-lg" data-toggle="modal" data-target="#deleteModal">Delete DB</button>
        <div class="modal fade" id="deleteModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
        <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title" id="myModalLabel">Are you sure you want to delete all info from the database?</h4>
        </div>
        <div class="modal-footer">
            <form action="deleteYABE.jsp">
            <button type="button" class="btn btn-primary" data-dismiss="modal">No, go back</button>
            <button type="submit" class="btn btn-danger">Yes, nuke it</button>
            </form>
        </div>
        </div>
        </div>
        </div>
        </div>
              <% }
        } %>


        </div>
        </div>
        <%@include file="includes/footer.jsp" %>
        </div>
    </body>
</html>
