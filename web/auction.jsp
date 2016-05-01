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
                 auction_conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe,"yabe","yabe");
               }

               catch(Exception e){
                 System.out.println("Could not connect to SQL server");
                 e.printStackTrace();
               }

              Integer new_auctionId = Integer.parseInt(request.getParameter("auctionID"));
			  Integer new_productID = Integer.parseInt(request.getParameter("productID"));
			  String new_username = request.getParameter("username");
			  String new_condition = request.getParameter("item_condition");
			  String new_start_date = request.getParameter("start_date");
              String new_end_date = request.getParameter("end_date");
			  Double new_reservePrice = Double.parseDouble(request.getParameter("reserve_price"));
			  Double new_startPrice = Double.parseDouble(request.getParameter("start_price"));
			  Integer new_quantity = Integer.parseInt(request.getParameter("quantity"));
			  Integer new_maxBid = Integer.parseInt(request.getParameter("maxBid"));
			  Integer new_numBids = Integer.parseInt(request.getParameter("numBids"));

              
              Statement statement = auction_conn.createStatement() ;
              ResultSet resultset;
              resultset = statement.executeQuery("SELECT * FROM product p, auction a WHERE p.productID=new_productID and a.auctionID = new_auctionId");
              String new_brand = resultset.getString("brand");
              String new_model = resultset.getString("model");
              Date date = new Date();
              
              
			  %>			  
                <h1> 
				<center>Auction:<%="new_brand"%>,<%="new_model"%>, Sold by <%="new_username"%> - Condition:<%="new_condition"%> </center>
                </h1>
                
                <body>
			<br>
			<br>
			<center>Item Condition:<b><%="new_condition"%></b></center>
			<br>
			<center>Time Left:<%=resultset.getString("TIMESTAMPDIFF(SECOND,'date','new_end_date')")%>
			</center>
			<br>
			<center>Starting Time:<%= resultset.getTimestamp("new_start_date") %></center>
			<br>
			<center>Location:<%= resultset.getString("new_address")%></center>
			<br>
			<center><b>Quantity:<%= resultset.getString("new_quantity")%></b><br></center>
			<br>
			
			<form action="processbid.jsp" method="post">       
                 <p>
                     <center>
                     <input type="number" name="bid" placeholder="[Max Bid]" value=<%="new_maxBid"%> min="1" step="1" required />
                     Bid History: <a href="bidhistory.jsp"> Number: <%="new_numBids"%></a><center-right>
                     </center>
                 </p>
               	<div style="text-align:center;">
			<button class="btn btn-lg btn-primary btn-block" type="submit">Place Bid</button>
			</div>
            	</form>
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
