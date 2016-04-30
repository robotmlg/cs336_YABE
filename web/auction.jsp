<!DOCTYPE html>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="mindrot.jbcrypt.BCrypt" %>

  
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
                 auction_conn = DriverManager.getConnection("jdbc:mysql://localhost,"yabe","yabe");
               }

               catch(Exception e){
                 System.out.println("Could not connect to SQL server");
                 e.printStackTrace();
               }

               
        	Integer auctionId = Integer.parseInt(request.getParameter("auctionID"));
		Integer productID = Integer.parseInt(request.getParameter("productID"));
		String username = request.getParameter("username");
		String condition = request.getParameter("item_condition");
		Double reservePrice = Double.parseDouble(request.getParameter("reserve_price"));
		Double startPrice = Double.parseDouble(request.getParameter("start_price"));
		Integer quantity = Integer.parseInt(request.getParameter("quantity"));
		Integer maxBid = Integer.parseInt(request.getParameter("maxBid"));
		Integer numBids = Integer.parseInt(request.getParameter("numBids"));
		String start_date = request.getParameter("start_date");
		String end_date = request.getParameter("end_date");

              Statement statement = auction_conn.createStatement() ;
              ResultSet resultset;
              resultset = statement.executeQuery("SELECT * FROM product p, auction a WHERE p.productID=productID and a.auctionID = auctionId");
              String brand = resultset.getString("brand");
              String model = resultset.getString("model");
			  %>			  
                <h1> 
				<input type="text" name="brand" value="<%= brand %>" />
				<input type="text" name="model" value="<%= model %>" />
                <input type="text" name="condition" value="<%= condition %>" />
                For Sale By 
                <input type="text" name= "username" value="<%=username%>"/>
                </h1>
            </div>
            <div class="col-md-4">
                </p>
              Starting Bid: 
              <input type="number" name="startprice" value="<%=startPrice %>" /><br>
              <br> 
              Current Bid:
              <input type="number" name="maxBid" value="<%=maxBid %>" /><br>
              <br>
              Number of Bids:
              <input type="number" name="numBids" value="<%=numBids %>" /><br>

                <p>
            </div>   
        </div>
        <%@include file="includes/footer.jsp" %>
        </div>
    </body>
</html>
