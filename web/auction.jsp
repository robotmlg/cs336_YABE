<!DOCTYPE html>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>

<html>
    <head>
        <title>Auction Page</title>
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
        <%
        	Connection auction_conn = null;
                try{
                Class.forName("com.mysql.jdbc.Driver").newInstance();
                auction_conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe","yabe","yabe");
                }

                catch(Exception e){
                 System.out.println("Could not connect to SQL server");
                 e.printStackTrace();
                }


              Integer new_auctionID = Integer.parseInt(request.getParameter("auctionID"));
              Statement statement = auction_conn.createStatement() ;
              ResultSet resultset;
              resultset = null;
              String active_query = "SELECT * FROM auction a, product p WHERE a.auctionID = "+new_auctionID+" and a.productID=p.productID";
              resultset = statement.executeQuery(active_query);
              resultset.next();
              

                      
              Date date = new Date();
              long diff = resultset.getTimestamp("end_date").getTime() - date.getTime();

              long diffSeconds = diff / 1000 % 60;
              long diffMinutes = diff / (60 * 1000) % 60;
              long diffHours = diff / (60 * 60 * 1000) % 24;
              long diffDays = diff / (24 * 60 * 60 * 1000);

              String time_left = ""+diffDays+" days, "+diffHours+":"+diffMinutes+":"+diffSeconds;

              
              
			  %>			  
              <h1> 
			  <center>Auction:<%=resultset.getString("brand")%>,<%=resultset.getString("model")%>, Sold by <%=resultset.getString("username")%> - Condition:<%=resultset.getString("item_condition")%> </center>
              </h1>
                
            <body>
				<br>
				<br>
				<center>Item Condition:<b><%=resultset.getString("item_condition")%></b></center>
				<br>
				<center>Time Left:<%=time_left %>
				</center>
				<br>
				<center>Starting Time:<%= resultset.getTimestamp("start_date") %></center>
				<br>
				<center><b>Quantity:<%= resultset.getInt("quantity")%></b><br></center>
				<br>
				<center>Current Highest Bid:<%=resultset.getInt("maxBid") %></center>
				<br>

				<% if(session.getAttribute("loggedIn") == "true"){%>
        			<form action="processbid.jsp?auctionID=<%= new_auctionID %>" method="post">       
                 	<p>
                     	<center>
                     	Amount: <input type="number" name="amount" placeholder="[Min_Bid]" value="<%=resultset.getInt("maxBid")%>" min="1" step="1" required autofocus />
                      	Max Amount: <input type="number" name="max_amount" placeholder="[Max Bid]" value="<%=resultset.getInt("maxBid")%>" min="1" step="1" required />
                     	Bid History: <a href="bidhistory.jsp"> Number: <%=resultset.getInt("numBids")%></a><center-right>
                     	</center>
                 	</p>
               	<div style="text-align:center;">
			<button class="btn btn-lg btn-primary btn-block" type="submit">Place Bid</button>
				</div>
            	</form>
            	
        		<%  } %>		
			<br>
			<br>
			<br>
		</body>
            </div>
            <div class="col-md-4">
            </div>   
        </div>
        <%@include file="includes/footer.jsp" %>
        </div>
    </body>
</html>
