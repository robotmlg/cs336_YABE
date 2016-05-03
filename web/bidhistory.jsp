<!DOCTYPE html>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>


<html>
    <head>
        <title>Bid History</title>
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
                <h1>Below are the bids for this auction:</h1>
            </div>
            <div class="col-md-4">

<% 
			Connection bidhistory_conn = null;
               try{
                 Class.forName("com.mysql.jdbc.Driver").newInstance();
                 bidhistory_conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe","yabe","yabe");
               }

               catch(Exception e){
                 System.out.println("Could not connect to SQL server");
                 e.printStackTrace();
               }

			  Integer new_auctionID = Integer.parseInt(request.getParameter("auctionID"));
				
			  Statement newest_statement = bidhistory_conn.createStatement() ;
              ResultSet rs3;
              rs3 = null;
              String active_query = "SELECT * FROM auction a, bid b WHERE a.auctionID = "+new_auctionID+" and b.auctionID=a.auctionID";
              rs3 = newest_statement.executeQuery(active_query);
              while(rs3.next()){  %>  
			  

			
			
				<div align="center">
				        <table border="1" cellpadding="5">
				            <caption><h2>List of Bids</h2></caption>
				            <tr>
				                <th>Bid ID</th>
				                <th>Bid Amount</th>
				                <th>Max Amount</th>
				                <th>Username</th>
				                <th>Date</th>
				            </tr>
				      
				                <tr>
				                    <td> <%= rs3.getInt("bidID") %></td>
				                    <td><%= rs3.getInt("amount") %></td>
				                    <td><%= rs3.getInt("max_amount") %></td>
				                    <td><%= rs3.getString("username") %></td>
				                    <td><%= rs3.getString("time") %></td>
				                </tr>
				        </table>
				</div>
            </div>  
            <% } %>
        </div>
        <%@include file="includes/footer.jsp" %>
        </div>
    </body>
</html>
