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
    
%>
