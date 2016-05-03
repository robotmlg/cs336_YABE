<%@page import="java.sql.*"%>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="mindrot.jbcrypt.BCrypt" %>

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
    
    
    Integer bid = Integer.parseInt(request.getParameter("bid"));
    Integer amount = Integer.parseInt(request.getParameter("amount"));
    Integer max_amount = Integer.parseInt(request.getParameter("max_amount"));
    String time = (request.getParameter("time"));
    String username = (String)session.getAttribute("username");
    Integer auctionID = Integer.parseInt(request.getParameter("auctionID"));
	
    Statement new_statement = bid_conn.createStatement() ;
    ResultSet new_resultset;
    int res2;
    new_resultset = null;
    String random_query = "SELECT * FROM auction a WHERE a.auctionID = "+auctionID+"";
    new_resultset = new_statement.executeQuery(random_query);
    
    
    Integer max_bid = new_resultset.getInt("maxBid");
    
    if (bid > max_bid) {
		String inserting_query = "INSERT INTO auction (maxBid) VALUES )(\'" + bid + "\')";
	    res2 = new_statement.executeUpdate(inserting_query);

        if (res2 < 1) {
            session.setAttribute("alert","Auction failed due update the max bid. Please try again.");
            session.setAttribute("alert_type","danger");
            %><%@ include file="auction.jsp" %><%
        }

    }

    
    if(bid <= max_bid){
    	session.setAttribute("alert","Bid is lower than Current Maximum Bid. Please Bid Higher!");
        session.setAttribute("alert_type","danger");
        %><%@ include file="auction.jsp" %><%
    }
    
    
    // give the bid an id
    Integer bidID = 0;
    
    Statement stmt = bid_conn.createStatement();
    String id_query = "SELECT MAX(b.bidID) FROM bid b";
    ResultSet rs = stmt.executeQuery(id_query);
    
    if(rs.next()){
    	bidID = rs.getInt(1) + 1;
    }
    // if the table was empty and we don't have a Max ID, start at 1
    else{
    	bidID=1;
    }
    
    String ins_query = "INSERT INTO bid (bidID, amount, max_amount, time, username, auctionID) VALUES (\'" + bidID + "\', \'" + amount + "\', \'" + max_amount + "\', \'" + time + "\', \'" + username + "\', \'" + auctionID + "\')";
    int res = stmt.executeUpdate(ins_query);
    
    if (res < 1) {
        session.setAttribute("alert","Bid failed.");
        session.setAttribute("alert_type","danger");
        %><%@ include file="auction.jsp" %><%
    } else {
        session.setAttribute("alert","Bid Successful.");
        session.setAttribute("alert_type","success");
        %><%@ include file="auction.jsp" %><%
    }
   
	
%>
