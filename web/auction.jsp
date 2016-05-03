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
        <div class="col-md-6">
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
              
              int productID = Integer.parseInt(resultset.getString("productID"));
                      
              Date date = new Date();
              long diff = resultset.getTimestamp("end_date").getTime() - date.getTime();

              long diffSeconds = diff / 1000 % 60;
              long diffMinutes = diff / (60 * 1000) % 60;
              long diffHours = diff / (60 * 60 * 1000) % 24;
              long diffDays = diff / (24 * 60 * 60 * 1000);

              String time_left = ""+diffDays+" days, "+diffHours+":"+diffMinutes+":"+diffSeconds;

              
              
			  %>			  
              <div class="jumbotron">
              <h1> 
			  <%=resultset.getString("brand")%> <%=resultset.getString("model")%>
              </h1>
              <h2>Sold by <%=resultset.getString("username")%> - Condition:<%=resultset.getString("item_condition")%>
              </h2>

    <%
        //find the product type
        String prodtype = null;
        Statement type_stmt = auction_conn.createStatement();
        ResultSet type_rs = type_stmt.executeQuery("SELECT * FROM item_types");
        ResultSet count_rs;
        Statement count_stmt = auction_conn.createStatement();
        while(type_rs.next()){
            count_rs = count_stmt.executeQuery("SELECT COUNT(*) FROM "+type_rs.getString("table_name")+" WHERE productID="+productID);
            if(count_rs.first() && count_rs.getInt(1)!=0){
                prodtype = type_rs.getString("table_name");
                break;
            }
        }

        Statement prod_stmt=auction_conn.createStatement();
        ResultSet prod_rs = prod_stmt.executeQuery("SELECT * FROM "+prodtype+" WHERE productID="+productID);
        prod_rs.first();
        %>
    <b>Product specific information:</b><br>
    <%    if (prodtype.equalsIgnoreCase("motherboard")) { %>
            Number of PCIe Slots: <%= prod_rs.getString("pcieSlots") %><br>
            Number of RAM memory slots: <%= prod_rs.getString("memorySlots") %><br>
            Maximum RAM capacity: <%= prod_rs.getString("maxRAM")%> GB<br>
            Socket type: <%= prod_rs.getString("socketType") %><br>
            Chipset: <%= prod_rs.getString("chipset") %><br>
            On-board sound: <%= prod_rs.getString("onBoardSound") %><br>
            On-board video: <%= prod_rs.getString("onBoardVideo") %><br>
    <%  } else if (prodtype.equalsIgnoreCase("cpu")) { %>
                Number of cores:<%= prod_rs.getString("cores") %><br>
                Clock speed: <%= prod_rs.getString("clockSpeed") %> GHz<br>
                Socket type: <%= prod_rs.getString("socketType") %><br>
    <%  } else if (prodtype.equalsIgnoreCase("ram")) { %>
                Capacity: <%= prod_rs.getString("capacity") %> GB<br>
                Memory type: <%= prod_rs.getString("memoryType") %><br>
                Clock speed: <%= prod_rs.getString("clockSpeed") %> MHz<br>
    <%  } else if (prodtype.equalsIgnoreCase("gpu")) { %>
                Core clock speed: <%= prod_rs.getString("coreClockSpeed") %> GHz<br>
                Number of cores: <%= prod_rs.getString("numCores") %><br>
                Memory: <%= prod_rs.getString("memoryCapacity") %> GB<br>
                Memory clock speed: <%= prod_rs.getString("memoryClockSpeed") %> MHz<br>
                Memory type: <%= prod_rs.getString("memoryType") %><br>
                HDMI ports: <%= prod_rs.getString("numHDMI") %><br>
                DVI ports: <%= prod_rs.getString("numDVI") %><br>
                DisplayPorts: <%= prod_rs.getString("numDP") %><br>
                Power requirement: <%= prod_rs.getString("powerRequirement") %><br>
    <%  } else if (prodtype.equalsIgnoreCase("storage")) { %>
                Capacity: <%= prod_rs.getString("capacityInGB") %> GB<br>
                Storage type: <%= prod_rs.getString("storageType") %><br>
    <%  } else if (prodtype.equalsIgnoreCase("case_hw")) { %>
                Dimensions: <%= prod_rs.getString("dimensions") %><br>
                Number of case fans: <%= prod_rs.getString("numCaseFans") %><br>
                Built in lighting: <%= prod_rs.getString("isLITT") %><br>
    <%  } else if (prodtype.equalsIgnoreCase("psu")) { %>
                Power output: <%= prod_rs.getString("power") %><br>
                Modular: <%= prod_rs.getString("modular") %><br>
    <%  } else if (prodtype.equalsIgnoreCase("fan")) { %>
                Dimensions: <%= prod_rs.getString("dimensions") %><br>
                Flow rate: <%= prod_rs.getString("flowrate") %><br>
                Maximum RPM: <%= prod_rs.getString("maxRPM") %><br>
    <%  } else if (prodtype.equalsIgnoreCase("other")) { %>
                
    <%  } %>
                Additional Information:   <%= resultset.getString("extraInfo")%>
				<br>
				<br>
				Item Condition:<b><%=resultset.getString("item_condition")%></b>
				<br>
				Time Left:<%=time_left %>
				
				<br>
				Starting Time:<%= resultset.getTimestamp("start_date") %>
				<br>
				<b>Quantity:<%= resultset.getInt("quantity")%></b><br>
				<br>
				Current Highest Bid:<%=resultset.getInt("maxBid") %>
				<br>
                </div>
                </div>

				<% if(session.getAttribute("loggedIn") == "true"){%>
                <div class="col-md-6">
                <div class="jumbotron">
                <h3>Place bid:</h3>
        			<form action="processbid.jsp?auctionID=<%= new_auctionID %>" method="post">       
                 	<p>
                     	Amount: <input type="number" name="amount" placeholder="[Min_Bid]" value="<%=resultset.getInt("maxBid")%>" min="1" step="1" required autofocus />
                        <br/>
                      	Max Amount: <input type="number" name="max_amount" placeholder="[Max Bid]" value="<%=resultset.getInt("maxBid")%>" min="1" step="1" required />
                        <br/>
                      	Bid History: <a href="bidhistory.jsp?auctionID=<%= new_auctionID %>"> <%=resultset.getInt("numBids")%></a><center-right>
                 	</p>
			<button class="btn btn-lg btn-primary btn-block" type="submit">Place Bid</button>
            	</form>
                </div>
                </div>
            	
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
