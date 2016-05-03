<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>

<%
    Connection bid_conn = null;
    try{
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        bid_conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe","yabe","yabe");
    }
    catch(Exception e){
        out.print("<p>Could not connect to SQL server.</p>");
        e.printStackTrace();
    }
    
    
    int amount = Integer.parseInt(request.getParameter("amount"));
    int max_amount = Integer.parseInt(request.getParameter("max_amount"));
    String username = (String)session.getAttribute("username");
    int auctionID = Integer.parseInt(request.getParameter("auctionID"));

    if(max_amount < amount)
        max_amount = amount;
     
    
    // give the bid an id
    int bidID = 0;
    Statement id_stmt = bid_conn.createStatement();
    String id_query = "SELECT MAX(b.bidID) FROM bid b";
    ResultSet id_rs = id_stmt.executeQuery(id_query);
    
    if(id_rs.next()){
    	bidID = id_rs.getInt(1) + 1;
    }
    // if the table was empty and we don't have a Max ID, start at 1
    else{
    	bidID=1;
    }

    Statement bid_stmt = bid_conn.createStatement();
    // get old max bid info
    String max_query = "SELECT MAX(max_amount) as high_max FROM bid "+
        "WHERE auctionID="+auctionID;
    System.out.println(max_query);
    ResultSet max_rs = bid_stmt.executeQuery(max_query);

    int high_max=0;
    if(max_rs.next())
        high_max = max_rs.getInt("high_max");
    max_query = "SELECT username FROM bid "+
        "WHERE auctionID="+auctionID+" AND max_amount="+high_max;
    max_rs = bid_stmt.executeQuery(max_query);
    String curr_high_user = "";
    if(max_rs.next())
        curr_high_user = max_rs.getString("username");

    // insert this bid into bid table
    String place_bid = "INSERT INTO bid (bidID, amount, max_amount, time, "+
        "username, auctionID) VALUES ("+bidID+","+amount+","+max_amount+
        ",NOW(),\'"+username+"\',"+auctionID+")";
    int bid_res = 1;
    try{
        bid_res = bid_stmt.executeUpdate(place_bid);
    }
    catch(Exception e){bid_res=0;}

    if(bid_res==0){
        session.setAttribute("alert","Bid could not be placed.");
        session.setAttribute("alert_type","danger");
    }
    else if(high_max == 0){ // bid went through, no autobids to process
        session.setAttribute("alert","Bid successful.");
        session.setAttribute("alert_type","success");
    }
    else if(curr_high_user != username){ // process autobids
        session.setAttribute("alert","Bid successful.");
        session.setAttribute("alert_type","success");

        // if the max_amount is the same as the high_max, give it to the other guy
        if(high_max == max_amount){
            place_bid = "INSERT INTO bid (bidID, amount, max_amount, time, "+
                "username, auctionID) VALUES ("+(++bidID)+","+(max_amount)+","+
                high_max+",NOW(),\'"+curr_high_user+"\',"+auctionID+")";
            bid_res = bid_stmt.executeUpdate(place_bid);

            if(bid_res==0){
                session.setAttribute("alert","Autobid could not be placed.");
                session.setAttribute("alert_type","danger");
            }
            else{
                session.setAttribute("alert","Outbid by another user");
                session.setAttribute("alert_type","warning");
            }
        }
    
        // if this bid's max_amount is higher than highest max_amount, bid again
        else if(max_amount >= high_max+1){
            place_bid = "INSERT INTO bid (bidID, amount, max_amount, time, "+
                "username, auctionID) VALUES ("+(++bidID)+","+(high_max+1)+","+
                max_amount+",NOW(),\'"+username+"\',"+auctionID+")";
            bid_res = bid_stmt.executeUpdate(place_bid);

            if(bid_res==0){
                session.setAttribute("alert","Autobid could not be placed.");
                session.setAttribute("alert_type","danger");
            }
        }
        // if this bid's max_amount is lower than highest max_amount, bid again
        else if(high_max >= max_amount+1){
            place_bid = "INSERT INTO bid (bidID, amount, max_amount, time, "+
                "username, auctionID) VALUES ("+(++bidID)+","+(max_amount+1)+","+
                high_max+",NOW(),\'"+curr_high_user+"\',"+auctionID+")";
            bid_res = bid_stmt.executeUpdate(place_bid);

            if(bid_res==0){
                session.setAttribute("alert","Autobid could not be placed.");
                session.setAttribute("alert_type","danger");
            }
            else{
                session.setAttribute("alert","Outbid by another user");
                session.setAttribute("alert_type","warning");
            }
        }


    
    }
    %><%@ include file="auction.jsp" %><%
	
%>
