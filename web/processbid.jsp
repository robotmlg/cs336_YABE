<%@page import="java.sql.*"%>

<%
    Connection conn = null;
    try{
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe","yabe","yabe");
    }

    catch(Exception e){
        out.print("<p>Could not connect to SQL server.</p>");
        e.printStackTrace();
    }
    
 
    Integer bid = Integer.parseInt(request.getParameter("bid"));
    // give the bid an id
    int bidID = 0;
    
    Statement stmt = conn.createStatement();
    String id_query = "SELECT MAX(b.bidID) FROM bid b";
    ResultSet rs = stmt.executeQuery(id_query);
    
    if(rs.next()){
    	bidID = rs.getInt(1) + 1;
    }
    // if the table was empty and we don't have a Max ID, start at 1
    else{
    	bidID=1;
    }

    Integer bid = Integer.parseInt(request.getParameter("bid"));
    Integer amount = Integer.parseInt(request.getParameter("amount"));
    Integer max_amount = Integer.parseInt(request.getParameter("max_amount"));
    String time = (request.getParameter("time"));
    String username = (String)session.getAttribute("username");
    Integer auctionID = Integer.parseInt(request.getParameter("auctionID"));

    
    // give the bid an id
    Integer bidID = 0;
    
    Statement stmt = conn.createStatement();
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
   
	
%>
